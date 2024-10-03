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

module hqm_sif_core

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
`ifdef HQM_SFI
     import hqm_sfi_pkg::*;
`endif
#(
     parameter HQM_SBE_NPQUEUEDEPTH     = 4
    ,parameter HQM_SBE_PCQUEUEDEPTH     = 4
    ,parameter HQM_SBE_DATAWIDTH        = 8
    ,parameter HQM_SBE_PARITY_REQUIRED  = 1

`ifdef HQM_SFI
    ,
//`include "hqm_sfi_params.sv"
    parameter HQM_SFI_RX_BCM_EN                = 1,     // Fixed
    parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN    = 1,    // Fixed
    parameter HQM_SFI_RX_D                     = 32,    // Fixed
    parameter HQM_SFI_RX_DATA_AUX_PARITY_EN    = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_CRD_GRAN         = 4,     // Fixed
    parameter HQM_SFI_RX_DATA_INTERLEAVE       = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_LAYER_EN         = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PARITY_EN        = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PASS_HDR         = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_RX_DS                    = 1,     // Fixed
    parameter HQM_SFI_RX_ECRC_SUPPORT          = 0,     // Fixed
    parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_RX_FATAL_EN              = 0,     // Fixed
    parameter HQM_SFI_RX_H                     = 32,    // Fixed
    parameter HQM_SFI_RX_HDR_DATA_SEP          = 1 ,    // Fixed
    parameter HQM_SFI_RX_HDR_MAX_FC_VC         = 1 ,    // Fixed
    parameter HQM_SFI_RX_HGRAN                 = 4,     // Fixed
    parameter HQM_SFI_RX_HPARITY               = 1,     // Fixed
    parameter HQM_SFI_RX_IDE_SUPPORT           = 0,    // Fixed
    parameter HQM_SFI_RX_M                     = 1,    // Fixed
    parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH     = 12,    // Fixed: Width of agent RX credit counters
    parameter HQM_SFI_RX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_RX_NDCRD                 = 4 ,    // Fabric data   credit return value width
    parameter HQM_SFI_RX_NHCRD                 = 4 ,    // Fabric header credit return value width
    parameter HQM_SFI_RX_NUM_SHARED_POOLS      = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_MERGED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_SHARED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_RBN                   = 3 ,    // Fixed
    parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ     = 1 ,    // Fixed
    parameter HQM_SFI_RX_SHARED_CREDIT_EN      = 0 ,    // Fixed
    parameter HQM_SFI_RX_TBN                   = 1 ,    // Cycles after agent hdr/data_block is received before fabric TX stalls
    parameter HQM_SFI_RX_TX_CRD_REG            = 1 ,    // Fixed
    parameter HQM_SFI_RX_VIRAL_EN              = 0 ,    // Fixed
    parameter HQM_SFI_RX_VR                    = 0  ,   // Fixed
    parameter HQM_SFI_RX_VT                    = 0  ,   // Fixed

    parameter HQM_SFI_TX_BCM_EN                = 1 ,   // Fixed
    parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_D                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_DATA_AUX_PARITY_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_CRD_GRAN         = 4 ,    // Fixed
    parameter HQM_SFI_TX_DATA_INTERLEAVE       = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_LAYER_EN         = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PARITY_EN        = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PASS_HDR         = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_TX_DS                    = 1 ,    // Fixed
    parameter HQM_SFI_TX_ECRC_SUPPORT          = 0 ,    // Fixed
    parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_TX_FATAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_H                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_HDR_DATA_SEP          = 1  ,   // Fixed
    parameter HQM_SFI_TX_HDR_MAX_FC_VC         = 1  ,   // Fixed
    parameter HQM_SFI_TX_HGRAN                 = 4  ,   // Fixed
    parameter HQM_SFI_TX_HPARITY               = 1  ,   // Fixed
    parameter HQM_SFI_TX_IDE_SUPPORT           = 0  ,   // Fixed
    parameter HQM_SFI_TX_M                     = 1  ,   // Fixed
    parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH     = 12 ,   // Width of agent TX credit counters
    parameter HQM_SFI_TX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_TX_NDCRD                 = 4  ,   // Fabric data   credit return value width
    parameter HQM_SFI_TX_NHCRD                 = 4  ,   // Fabric header credit return value width
    parameter HQM_SFI_TX_NUM_SHARED_POOLS      = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_MERGED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_SHARED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_RBN                   = 1  ,   // Cycles after fabric hdr/data_crd_rtn_block is received before agent RX stalls
    parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ     = 1  ,   // Fixed
    parameter HQM_SFI_TX_SHARED_CREDIT_EN      = 0  ,   // Fixed
    parameter HQM_SFI_TX_TBN                   = 3  ,   // Fixed
    parameter HQM_SFI_TX_TX_CRD_REG            = 1  ,   // Fixed
    parameter HQM_SFI_TX_VIRAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_VR                    = 0   ,  // Fixed
    parameter HQM_SFI_TX_VT                    = 0     // Fixed
`endif
) (

     input  logic                               pgcb_clk
    ,input  logic                               powergood_rst_b

    ,input  logic                               pma_safemode

    ,input  logic                               hqm_inp_gated_clk
    ,input  logic                               hqm_gated_rst_b

    //---------------------------------------------------------------------------------------------
    // System Configuration Ports

    ,input  logic                               strap_hqm_is_reg_ep    // PCIe Type - 0 = RCIEP, 1 = regular endpoint
    ,input  logic [63:0]                        strap_hqm_csr_cp
    ,input  logic [63:0]                        strap_hqm_csr_rac
    ,input  logic [63:0]                        strap_hqm_csr_wac

    // SetID Information
    ,input  logic [15:0]                        strap_hqm_device_id

    // Sideband destination port ID for PCIe errors
    ,input  logic [15:0]                        strap_hqm_err_sb_dstid

    // SAI sent with PCIe error messages
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_err_sb_sai

    // SAI for tx
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_tx_sai

    // SAI for completions
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_cmpl_sai

    // SAI sent with ResetPrepAck messages
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_resetprep_ack_sai

    // Legal SAI values for Sideband ResetPrep message
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_resetprep_sai_0
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_resetprep_sai_1

    // Legal SAI values for Sideband ForcePwrGatePOK message
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_force_pok_sai_0
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_force_pok_sai_1

    //---------------------------------------------------------------------------------------------
    // GPSB Configuration Ports

    ,input  logic [15:0]                        strap_hqm_gpsb_srcid
    ,input  logic                               strap_hqm_16b_portids

    //---------------------------------------------------------------------------------------------
    // Parity Message configuration

    ,input  logic [15:0]                        strap_hqm_do_serr_dstid
    ,input  logic [2:0]                         strap_hqm_do_serr_tag
    ,input  logic                               strap_hqm_do_serr_sairs_valid
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_do_serr_sai
    ,input  logic [ RS_WIDTH:0]                 strap_hqm_do_serr_rs

    //---------------------------------------------------------------------------------------------
    // IOSF Sideband CDC signals

    ,output logic                               side_pok
    ,input  logic                               side_clk
    ,output logic                               side_clkreq
    ,input  logic                               side_clkack
    ,input  logic                               side_rst_b
    ,input  logic [2:0]                         gpsb_side_ism_fabric
    ,output logic [2:0]                         gpsb_side_ism_agent
    ,input  logic                               side_pwrgate_pmc_wake

    //---------------------------------------------------------------------------------------------
    // Egress port interface to the IOSF Sideband Channel

    ,input  logic                               gpsb_mpccup
    ,input  logic                               gpsb_mnpcup

    ,output logic                               gpsb_mpcput
    ,output logic                               gpsb_mnpput
    ,output logic                               gpsb_meom
    ,output logic [HQM_SBE_DATAWIDTH-1:0]       gpsb_mpayload
    ,output logic                               gpsb_mparity

    //---------------------------------------------------------------------------------------------
    // Ingress port interface to the IOSF Sideband Channel

    ,output logic                               gpsb_tpccup
    ,output logic                               gpsb_tnpcup

    ,input  logic                               gpsb_tpcput
    ,input  logic                               gpsb_tnpput
    ,input  logic                               gpsb_teom
    ,input  logic [HQM_SBE_DATAWIDTH-1:0]       gpsb_tpayload
    ,input  logic                               gpsb_tparity

    //---------------------------------------------------------------------------------------------
    // Primary Interface

`ifdef HQM_SFI

    //-------------------------------------------------------------------------------------------------
    // SFI TX Global

    ,output logic                                           sfi_tx_txcon_req            // Connection request

    ,input  logic                                           sfi_tx_rxcon_ack            // Connection acknowledge
    ,input  logic                                           sfi_tx_rxdiscon_nack        // Disconnect rejection
    ,input  logic                                           sfi_tx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI TX Header

    ,output logic                                           sfi_tx_hdr_valid            // Header is valid
    ,output logic                                           sfi_tx_hdr_early_valid      // Header early valid indication
    ,output hqm_sfi_hdr_info_t                              sfi_tx_hdr_info_bytes       // Header info
    ,output logic [(HQM_SFI_TX_H*8 )-1:0]                   sfi_tx_header               // Header

    ,input  logic                                           sfi_tx_hdr_block            // RX requires TX to pause hdr

    ,input  logic                                           sfi_tx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,input  logic [4:0]                                     sfi_tx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                                 sfi_tx_hdr_crd_rtn_fc_id    // Credit flow class
    ,input  logic [HQM_SFI_TX_NHCRD-1:0]                    sfi_tx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,output logic                                           sfi_tx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI TX Data

    ,output logic                                           sfi_tx_data_valid           // Data is valid
    ,output logic                                           sfi_tx_data_early_valid     // Data early valid indication
    ,output logic                                           sfi_tx_data_aux_parity      // Data auxilliary parity
    ,output logic [(HQM_SFI_TX_D/8)-1:0]                    sfi_tx_data_parity          // Data parity per 8B
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_poison          // Data poisoned per DW
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_edb             // Data bad per DW
    ,output logic                                           sfi_tx_data_start           // Start of data
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_end             // End   of data
    ,output hqm_sfi_data_info_t                             sfi_tx_data_info_byte       // Data info
    ,output logic [(HQM_SFI_TX_D*8)-1:0]                    sfi_tx_data                 // Data payload

    ,input  logic                                           sfi_tx_data_block           // RX requires TX to pause data

    ,input  logic                                           sfi_tx_data_crd_rtn_valid   // RX returning data credit
    ,input  logic [4:0]                                     sfi_tx_data_crd_rtn_vc_id   // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                                 sfi_tx_data_crd_rtn_fc_id   // Credit flow class
    ,input  logic [HQM_SFI_TX_NDCRD-1:0]                    sfi_tx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,output logic                                           sfi_tx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //---------------------------------------------------------------------------------------------
    // SFI RX Global

    ,input  logic                                           sfi_rx_txcon_req            // Connection request

    ,output logic                                           sfi_rx_rxcon_ack            // Connection acknowledge
    ,output logic                                           sfi_rx_rxdiscon_nack        // Disconnect rejection
    ,output logic                                           sfi_rx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI RX Header

    ,input  logic                                           sfi_rx_hdr_valid            // Header is valid
    ,input  logic                                           sfi_rx_hdr_early_valid      // Header early valid indication
    ,input  hqm_sfi_hdr_info_t                              sfi_rx_hdr_info_bytes       // Header info
    ,input  logic [(HQM_SFI_RX_H*8 )-1:0]                   sfi_rx_header               // Header

    ,output logic                                           sfi_rx_hdr_block            // RX requires TX to pause hdr

    ,output logic                                           sfi_rx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,output logic [4:0]                                     sfi_rx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,output hqm_sfi_fc_id_t                                 sfi_rx_hdr_crd_rtn_fc_id    // Credit flow class
    ,output logic [HQM_SFI_RX_NHCRD-1:0]                    sfi_rx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,input  logic                                           sfi_rx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI RX Data

    ,input  logic                                           sfi_rx_data_valid           // Data is valid
    ,input  logic                                           sfi_rx_data_early_valid     // Data early valid indication
    ,input  logic                                           sfi_rx_data_aux_parity      // Data auxilliary parity
    ,input  logic [(HQM_SFI_RX_D/8)-1:0]                    sfi_rx_data_parity          // Data parity per 8B
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_poison          // Data poisoned per DW
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_edb             // Data bad per DW
    ,input  logic                                           sfi_rx_data_start           // Start of data
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_end             // End   of data
    ,input  hqm_sfi_data_info_t                             sfi_rx_data_info_byte       // Data info
    ,input  logic [(HQM_SFI_RX_D*8)-1:0]                    sfi_rx_data                 // Data payload

    ,output logic                                           sfi_rx_data_block           // RX requires TX to pause data

    ,output logic                                           sfi_rx_data_crd_rtn_valid   // RX returning data credit
    ,output logic [4:0]                                     sfi_rx_data_crd_rtn_vc_id   // Credit virtual channel
    ,output hqm_sfi_fc_id_t                                 sfi_rx_data_crd_rtn_fc_id   // Credit flow class
    ,output logic [HQM_SFI_RX_NDCRD-1:0]                    sfi_rx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,input  logic                                           sfi_rx_data_crd_rtn_block   // TX requires RX to pause data credit returns


`else

    ,input  logic                               strap_hqm_completertenbittagen

    // IOSF Target

    ,output logic                               prim_pok

    ,input  logic [2:0]                         prim_ism_fabric
    ,output logic [2:0]                         prim_ism_agent

    ,output logic                               credit_cmd
    ,output logic [2:0]                         credit_data
    ,output logic                               credit_put
    ,output logic [1:0]                         credit_rtype

    ,input  logic                               cmd_nfs_err
    ,input  logic                               cmd_put
    ,input  logic [1:0]                         cmd_rtype

    ,input  logic [63:0]                        taddress
    ,input  logic [1:0]                         tat
    ,input  logic                               tchain
    ,input  logic                               tcparity
    ,input  logic [255:0]                       tdata
    ,input  logic                               tdec
    ,input  logic [13:0]                        tdest_id
    ,input  logic                               tdparity
    ,input  logic [31:0]                        tecrc
    ,input  logic                               tep
    ,input  logic [3:0]                         tfbe
    ,input  logic [1:0]                         tfmt
    ,input  logic                               tido
    ,input  logic [3:0]                         tlbe
    ,input  logic [9:0]                         tlength
    ,input  logic                               tns
    ,input  logic [22:0]                        tpasidtlp
    ,input  logic                               tro
    ,input  logic [15:0]                        trqid
    ,input  logic                               trs
    ,input  logic                               trsvd1_3
    ,input  logic                               trsvd1_7
    ,input  logic [7:0]                         tsai
    ,input  logic [13:0]                        tsrc_id
    ,input  logic [7:0]                         ttag
    ,input  logic [3:0]                         ttc
    ,input  logic                               ttd
    ,input  logic                               tth
    ,input  logic [4:0]                         ttype

    ,output logic                               hit
    ,output logic                               sub_hit

    // IOSF Master

    ,output logic                               req_agent
    ,output logic                               req_cdata
    ,output logic                               req_chain
    ,output logic [13:0]                        req_dest_id
    ,output logic [9:0]                         req_dlen
    ,output logic [15:0]                        req_id
    ,output logic                               req_ido
    ,output logic                               req_locked
    ,output logic                               req_ns
    ,output logic                               req_opp
    ,output logic                               req_put
    ,output logic                               req_ro
    ,output logic                               req_rs
    ,output logic [1:0]                         req_rtype
    ,output logic [3:0]                         req_tc

    ,input  logic                               gnt
    ,input  logic [1:0]                         gnt_rtype
    ,input  logic [1:0]                         gnt_type

    ,output logic [63:0]                        maddress
    ,output logic [1:0]                         mat
    ,output logic                               mcparity
    ,output logic [255:0]                       mdata
    ,output logic [13:0]                        mdest_id
    ,output logic                               mdparity
    ,output logic [31:0]                        mecrc
    ,output logic                               mep
    ,output logic [3:0]                         mfbe
    ,output logic [1:0]                         mfmt
    ,output logic                               mido
    ,output logic [3:0]                         mlbe
    ,output logic [9:0]                         mlength
    ,output logic                               mns
    ,output logic [22:0]                        mpasidtlp
    ,output logic                               mro
    ,output logic [15:0]                        mrqid
    ,output logic                               mrs
    ,output logic                               mrsvd1_3
    ,output logic                               mrsvd1_7
    ,output logic [7:0]                         msai
    ,output logic [13:0]                        msrc_id
    ,output logic [7:0]                         mtag
    ,output logic [3:0]                         mtc
    ,output logic                               mtd
    ,output logic                               mth
    ,output logic [4:0]                         mtype

`endif

    //---------------------------------------------------------------------------------------------
    // Primary Clock signals

    ,input  logic                               prim_pwrgate_pmc_wake

    ,input  logic                               prim_freerun_clk
    ,input  logic                               prim_gated_clk
    ,input  logic                               prim_nonflr_clk

    ,output logic                               prim_clk_enable
    ,output logic                               prim_clk_enable_cdc
    ,output logic                               prim_clk_enable_sys
    ,output logic                               prim_clk_ungate

    ,input  logic                               prim_rst_b
    ,output logic                               prim_gated_rst_b

    ,output logic                               prim_clkreq
    ,input  logic                               prim_clkack

    ,output logic                               flr_triggered

    //---------------------------------------------------------------------------------------------
    // APB interface

    ,output logic                               psel
    ,output logic                               penable
    ,output logic                               pwrite
    ,output logic [31:0]                        paddr
    ,output logic [31:0]                        pwdata
    ,output logic [19:0]                        puser

    ,input  logic                               pready
    ,input  logic                               pslverr
    ,input  logic [31:0]                        prdata
    ,input  logic                               prdata_par

    //---------------------------------------------------------------------------------------------
    // System HCW Enqueue interface

    ,input  logic                               hcw_enq_in_ready

    ,output logic                               hcw_enq_in_v
    ,output hqm_system_enq_data_in_t            hcw_enq_in_data

    //---------------------------------------------------------------------------------------------
    // System Posted Request interface

    ,output logic                               write_buffer_mstr_ready

    ,input  logic                               write_buffer_mstr_v
    ,input  write_buffer_mstr_t                 write_buffer_mstr

    //---------------------------------------------------------------------------------------------
    // System Alarm Interrupt interface

    ,input  logic                               sif_alarm_ready

    ,output logic                               sif_alarm_v
    ,output aw_alarm_t                          sif_alarm_data

    //---------------------------------------------------------------------------------------------
    // IOSF Control interface to hqm_system

    ,output logic                               pci_cfg_sciov_en                // Scalable IO Virtualization enable

    ,output logic                               pci_cfg_pmsixctl_msie           // MSIX global enable
    ,output logic                               pci_cfg_pmsixctl_fm             // MSIX global mask

    //---------------------------------------------------------------------------------------------
    // MASTER interface

    ,output pm_fsm_t                            pm_state
    ,input  logic                               pm_fsm_d0tod3_ok
    ,input  logic                               pm_fsm_d3tod0_ok
    ,input  logic                               pm_fsm_in_run
    ,input  logic                               pm_allow_ing_drop

    ,input  logic                               hqm_proc_reset_done
    ,input  logic                               hqm_proc_idle
    ,input  logic                               hqm_flr_prep

    ,output logic                               master_ctl_load
    ,output logic [31:0]                        master_ctl

    //---------------------------------------------------------------------------------------------
    // DFX interface

    ,input  logic                               fdfx_sbparity_def

    ,input  logic                               fscan_byprst_b
    ,input  logic                               fscan_clkungate
    ,input  logic                               fscan_clkungate_syn
    ,input  logic                               fscan_latchclosed_b
    ,input  logic                               fscan_latchopen
    ,input  logic                               fscan_mode
    ,input  logic                               fscan_rstbypen
    ,input  logic                               fscan_shiften

    ,input  logic                               prim_jta_force_clkreq
    ,input  logic                               prim_jta_force_creditreq
    ,input  logic                               prim_jta_force_idle
    ,input  logic                               prim_jta_force_notidle

    ,input  logic                               gpsb_jta_clkgate_ovrd
    ,input  logic                               gpsb_jta_force_clkreq
    ,input  logic                               gpsb_jta_force_creditreq
    ,input  logic                               gpsb_jta_force_idle
    ,input  logic                               gpsb_jta_force_notidle

    ,input  logic                               cdc_prim_jta_force_clkreq
    ,input  logic                               cdc_prim_jta_clkgate_ovrd

    ,input  logic                               cdc_side_jta_force_clkreq
    ,input  logic                               cdc_side_jta_clkgate_ovrd

    //---------------------------------------------------------------------------------------------
    // Fuse interface

    ,output logic                               fuse_force_on
    ,output logic                               fuse_proc_disable

    ,input  logic [EARLY_FUSES_BITS_TOT-1:0]    early_fuses
    ,output logic                               ip_ready
    ,input  logic                               strap_no_mgmt_acks
    ,output logic                               reset_prep_ack


    //---------------------------------------------------------------------------------------------
    // DIMM refresh interface

    ,input  logic                               pm_hqm_adr_assert
    ,output logic                               hqm_pm_adr_ack

    //---------------------------------------------------------------------------------------------
    // VISA outputs

    ,output logic [679:0]                       hqm_sif_visa
    ,output logic [9:0]                         hqm_triggers

    //---------------------------------------------------------------------------------------------
    // Memory solution ports

// BEGIN HQM_MEMPORT_DECL hqm_sif_core
    ,output logic                  rf_ibcpl_data_fifo_re
    ,output logic                  rf_ibcpl_data_fifo_rclk
    ,output logic                  rf_ibcpl_data_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_ibcpl_data_fifo_raddr
    ,output logic [(       8)-1:0] rf_ibcpl_data_fifo_waddr
    ,output logic                  rf_ibcpl_data_fifo_we
    ,output logic                  rf_ibcpl_data_fifo_wclk
    ,output logic                  rf_ibcpl_data_fifo_wclk_rst_n
    ,output logic [(      66)-1:0] rf_ibcpl_data_fifo_wdata
    ,input  logic [(      66)-1:0] rf_ibcpl_data_fifo_rdata

    ,output logic                  rf_ibcpl_hdr_fifo_re
    ,output logic                  rf_ibcpl_hdr_fifo_rclk
    ,output logic                  rf_ibcpl_hdr_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_ibcpl_hdr_fifo_raddr
    ,output logic [(       8)-1:0] rf_ibcpl_hdr_fifo_waddr
    ,output logic                  rf_ibcpl_hdr_fifo_we
    ,output logic                  rf_ibcpl_hdr_fifo_wclk
    ,output logic                  rf_ibcpl_hdr_fifo_wclk_rst_n
    ,output logic [(      20)-1:0] rf_ibcpl_hdr_fifo_wdata
    ,input  logic [(      20)-1:0] rf_ibcpl_hdr_fifo_rdata

    ,output logic                  rf_mstr_ll_data0_re
    ,output logic                  rf_mstr_ll_data0_rclk
    ,output logic                  rf_mstr_ll_data0_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data0_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data0_waddr
    ,output logic                  rf_mstr_ll_data0_we
    ,output logic                  rf_mstr_ll_data0_wclk
    ,output logic                  rf_mstr_ll_data0_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data0_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data0_rdata

    ,output logic                  rf_mstr_ll_data1_re
    ,output logic                  rf_mstr_ll_data1_rclk
    ,output logic                  rf_mstr_ll_data1_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data1_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data1_waddr
    ,output logic                  rf_mstr_ll_data1_we
    ,output logic                  rf_mstr_ll_data1_wclk
    ,output logic                  rf_mstr_ll_data1_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data1_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data1_rdata

    ,output logic                  rf_mstr_ll_data2_re
    ,output logic                  rf_mstr_ll_data2_rclk
    ,output logic                  rf_mstr_ll_data2_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data2_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data2_waddr
    ,output logic                  rf_mstr_ll_data2_we
    ,output logic                  rf_mstr_ll_data2_wclk
    ,output logic                  rf_mstr_ll_data2_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data2_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data2_rdata

    ,output logic                  rf_mstr_ll_data3_re
    ,output logic                  rf_mstr_ll_data3_rclk
    ,output logic                  rf_mstr_ll_data3_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data3_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data3_waddr
    ,output logic                  rf_mstr_ll_data3_we
    ,output logic                  rf_mstr_ll_data3_wclk
    ,output logic                  rf_mstr_ll_data3_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data3_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data3_rdata

    ,output logic                  rf_mstr_ll_hdr_re
    ,output logic                  rf_mstr_ll_hdr_rclk
    ,output logic                  rf_mstr_ll_hdr_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_hdr_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_hdr_waddr
    ,output logic                  rf_mstr_ll_hdr_we
    ,output logic                  rf_mstr_ll_hdr_wclk
    ,output logic                  rf_mstr_ll_hdr_wclk_rst_n
    ,output logic [(     153)-1:0] rf_mstr_ll_hdr_wdata
    ,input  logic [(     153)-1:0] rf_mstr_ll_hdr_rdata

    ,output logic                  rf_mstr_ll_hpa_re
    ,output logic                  rf_mstr_ll_hpa_rclk
    ,output logic                  rf_mstr_ll_hpa_rclk_rst_n
    ,output logic [(       7)-1:0] rf_mstr_ll_hpa_raddr
    ,output logic [(       7)-1:0] rf_mstr_ll_hpa_waddr
    ,output logic                  rf_mstr_ll_hpa_we
    ,output logic                  rf_mstr_ll_hpa_wclk
    ,output logic                  rf_mstr_ll_hpa_wclk_rst_n
    ,output logic [(      35)-1:0] rf_mstr_ll_hpa_wdata
    ,input  logic [(      35)-1:0] rf_mstr_ll_hpa_rdata

    ,output logic                  rf_ri_tlq_fifo_npdata_re
    ,output logic                  rf_ri_tlq_fifo_npdata_rclk
    ,output logic                  rf_ri_tlq_fifo_npdata_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_npdata_raddr
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_npdata_waddr
    ,output logic                  rf_ri_tlq_fifo_npdata_we
    ,output logic                  rf_ri_tlq_fifo_npdata_wclk
    ,output logic                  rf_ri_tlq_fifo_npdata_wclk_rst_n
    ,output logic [(      33)-1:0] rf_ri_tlq_fifo_npdata_wdata
    ,input  logic [(      33)-1:0] rf_ri_tlq_fifo_npdata_rdata

    ,output logic                  rf_ri_tlq_fifo_nphdr_re
    ,output logic                  rf_ri_tlq_fifo_nphdr_rclk
    ,output logic                  rf_ri_tlq_fifo_nphdr_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_nphdr_raddr
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_nphdr_waddr
    ,output logic                  rf_ri_tlq_fifo_nphdr_we
    ,output logic                  rf_ri_tlq_fifo_nphdr_wclk
    ,output logic                  rf_ri_tlq_fifo_nphdr_wclk_rst_n
    ,output logic [(     158)-1:0] rf_ri_tlq_fifo_nphdr_wdata
    ,input  logic [(     158)-1:0] rf_ri_tlq_fifo_nphdr_rdata

    ,output logic                  rf_ri_tlq_fifo_pdata_re
    ,output logic                  rf_ri_tlq_fifo_pdata_rclk
    ,output logic                  rf_ri_tlq_fifo_pdata_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ri_tlq_fifo_pdata_raddr
    ,output logic [(       5)-1:0] rf_ri_tlq_fifo_pdata_waddr
    ,output logic                  rf_ri_tlq_fifo_pdata_we
    ,output logic                  rf_ri_tlq_fifo_pdata_wclk
    ,output logic                  rf_ri_tlq_fifo_pdata_wclk_rst_n
    ,output logic [(     264)-1:0] rf_ri_tlq_fifo_pdata_wdata
    ,input  logic [(     264)-1:0] rf_ri_tlq_fifo_pdata_rdata

    ,output logic                  rf_ri_tlq_fifo_phdr_re
    ,output logic                  rf_ri_tlq_fifo_phdr_rclk
    ,output logic                  rf_ri_tlq_fifo_phdr_rclk_rst_n
    ,output logic [(       4)-1:0] rf_ri_tlq_fifo_phdr_raddr
    ,output logic [(       4)-1:0] rf_ri_tlq_fifo_phdr_waddr
    ,output logic                  rf_ri_tlq_fifo_phdr_we
    ,output logic                  rf_ri_tlq_fifo_phdr_wclk
    ,output logic                  rf_ri_tlq_fifo_phdr_wclk_rst_n
    ,output logic [(     153)-1:0] rf_ri_tlq_fifo_phdr_wdata
    ,input  logic [(     153)-1:0] rf_ri_tlq_fifo_phdr_rdata

    ,output logic                  rf_scrbd_mem_re
    ,output logic                  rf_scrbd_mem_rclk
    ,output logic                  rf_scrbd_mem_rclk_rst_n
    ,output logic [(       8)-1:0] rf_scrbd_mem_raddr
    ,output logic [(       8)-1:0] rf_scrbd_mem_waddr
    ,output logic                  rf_scrbd_mem_we
    ,output logic                  rf_scrbd_mem_wclk
    ,output logic                  rf_scrbd_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_scrbd_mem_wdata
    ,input  logic [(      10)-1:0] rf_scrbd_mem_rdata

    ,output logic                  rf_tlb_data0_4k_re
    ,output logic                  rf_tlb_data0_4k_rclk
    ,output logic                  rf_tlb_data0_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data0_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data0_4k_waddr
    ,output logic                  rf_tlb_data0_4k_we
    ,output logic                  rf_tlb_data0_4k_wclk
    ,output logic                  rf_tlb_data0_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data0_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data0_4k_rdata

    ,output logic                  rf_tlb_data1_4k_re
    ,output logic                  rf_tlb_data1_4k_rclk
    ,output logic                  rf_tlb_data1_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data1_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data1_4k_waddr
    ,output logic                  rf_tlb_data1_4k_we
    ,output logic                  rf_tlb_data1_4k_wclk
    ,output logic                  rf_tlb_data1_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data1_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data1_4k_rdata

    ,output logic                  rf_tlb_data2_4k_re
    ,output logic                  rf_tlb_data2_4k_rclk
    ,output logic                  rf_tlb_data2_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data2_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data2_4k_waddr
    ,output logic                  rf_tlb_data2_4k_we
    ,output logic                  rf_tlb_data2_4k_wclk
    ,output logic                  rf_tlb_data2_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data2_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data2_4k_rdata

    ,output logic                  rf_tlb_data3_4k_re
    ,output logic                  rf_tlb_data3_4k_rclk
    ,output logic                  rf_tlb_data3_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data3_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data3_4k_waddr
    ,output logic                  rf_tlb_data3_4k_we
    ,output logic                  rf_tlb_data3_4k_wclk
    ,output logic                  rf_tlb_data3_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data3_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data3_4k_rdata

    ,output logic                  rf_tlb_data4_4k_re
    ,output logic                  rf_tlb_data4_4k_rclk
    ,output logic                  rf_tlb_data4_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data4_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data4_4k_waddr
    ,output logic                  rf_tlb_data4_4k_we
    ,output logic                  rf_tlb_data4_4k_wclk
    ,output logic                  rf_tlb_data4_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data4_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data4_4k_rdata

    ,output logic                  rf_tlb_data5_4k_re
    ,output logic                  rf_tlb_data5_4k_rclk
    ,output logic                  rf_tlb_data5_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data5_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data5_4k_waddr
    ,output logic                  rf_tlb_data5_4k_we
    ,output logic                  rf_tlb_data5_4k_wclk
    ,output logic                  rf_tlb_data5_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data5_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data5_4k_rdata

    ,output logic                  rf_tlb_data6_4k_re
    ,output logic                  rf_tlb_data6_4k_rclk
    ,output logic                  rf_tlb_data6_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data6_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data6_4k_waddr
    ,output logic                  rf_tlb_data6_4k_we
    ,output logic                  rf_tlb_data6_4k_wclk
    ,output logic                  rf_tlb_data6_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data6_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data6_4k_rdata

    ,output logic                  rf_tlb_data7_4k_re
    ,output logic                  rf_tlb_data7_4k_rclk
    ,output logic                  rf_tlb_data7_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data7_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data7_4k_waddr
    ,output logic                  rf_tlb_data7_4k_we
    ,output logic                  rf_tlb_data7_4k_wclk
    ,output logic                  rf_tlb_data7_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data7_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data7_4k_rdata

    ,output logic                  rf_tlb_tag0_4k_re
    ,output logic                  rf_tlb_tag0_4k_rclk
    ,output logic                  rf_tlb_tag0_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag0_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag0_4k_waddr
    ,output logic                  rf_tlb_tag0_4k_we
    ,output logic                  rf_tlb_tag0_4k_wclk
    ,output logic                  rf_tlb_tag0_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag0_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag0_4k_rdata

    ,output logic                  rf_tlb_tag1_4k_re
    ,output logic                  rf_tlb_tag1_4k_rclk
    ,output logic                  rf_tlb_tag1_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag1_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag1_4k_waddr
    ,output logic                  rf_tlb_tag1_4k_we
    ,output logic                  rf_tlb_tag1_4k_wclk
    ,output logic                  rf_tlb_tag1_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag1_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag1_4k_rdata

    ,output logic                  rf_tlb_tag2_4k_re
    ,output logic                  rf_tlb_tag2_4k_rclk
    ,output logic                  rf_tlb_tag2_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag2_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag2_4k_waddr
    ,output logic                  rf_tlb_tag2_4k_we
    ,output logic                  rf_tlb_tag2_4k_wclk
    ,output logic                  rf_tlb_tag2_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag2_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag2_4k_rdata

    ,output logic                  rf_tlb_tag3_4k_re
    ,output logic                  rf_tlb_tag3_4k_rclk
    ,output logic                  rf_tlb_tag3_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag3_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag3_4k_waddr
    ,output logic                  rf_tlb_tag3_4k_we
    ,output logic                  rf_tlb_tag3_4k_wclk
    ,output logic                  rf_tlb_tag3_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag3_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag3_4k_rdata

    ,output logic                  rf_tlb_tag4_4k_re
    ,output logic                  rf_tlb_tag4_4k_rclk
    ,output logic                  rf_tlb_tag4_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag4_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag4_4k_waddr
    ,output logic                  rf_tlb_tag4_4k_we
    ,output logic                  rf_tlb_tag4_4k_wclk
    ,output logic                  rf_tlb_tag4_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag4_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag4_4k_rdata

    ,output logic                  rf_tlb_tag5_4k_re
    ,output logic                  rf_tlb_tag5_4k_rclk
    ,output logic                  rf_tlb_tag5_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag5_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag5_4k_waddr
    ,output logic                  rf_tlb_tag5_4k_we
    ,output logic                  rf_tlb_tag5_4k_wclk
    ,output logic                  rf_tlb_tag5_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag5_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag5_4k_rdata

    ,output logic                  rf_tlb_tag6_4k_re
    ,output logic                  rf_tlb_tag6_4k_rclk
    ,output logic                  rf_tlb_tag6_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag6_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag6_4k_waddr
    ,output logic                  rf_tlb_tag6_4k_we
    ,output logic                  rf_tlb_tag6_4k_wclk
    ,output logic                  rf_tlb_tag6_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag6_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag6_4k_rdata

    ,output logic                  rf_tlb_tag7_4k_re
    ,output logic                  rf_tlb_tag7_4k_rclk
    ,output logic                  rf_tlb_tag7_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag7_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag7_4k_waddr
    ,output logic                  rf_tlb_tag7_4k_we
    ,output logic                  rf_tlb_tag7_4k_wclk
    ,output logic                  rf_tlb_tag7_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag7_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag7_4k_rdata

// END HQM_MEMPORT_DECL hqm_sif_core

);

logic                                           adr_clkreq;
logic                                           agent_clkreq;
logic                                           agent_clkreq_async;
logic                                           agent_idle;
hqm_cds_sb_tgt_cmsg_t                           cds_sb_cmsg;
logic                                           cds_sb_rdack;
logic                                           cds_sb_wrack;
logic [47:0]                                    cfg_addr;
hqm_sif_csr_hc_error_t                          cfg_error;
CFG_MASTER_TIMEOUT_t                            cfg_master_timeout;
PRIM_CDC_CTL_t                                  cfg_prim_cdc_ctl;
hqm_sif_csr_hc_reg_read_t                       cfg_rdata;
hqm_sif_csr_hc_re_t                             cfg_re;
hqm_sif_csr_hc_rvalid_t                         cfg_rvalid;
SIDE_CDC_CTL_t                                  cfg_side_cdc_ctl;
VISA_SW_CONTROL_t                               cfg_visa_sw_control;
VISA_SW_CONTROL_t                               cfg_visa_sw_control_wdata;
logic                                           cfg_visa_sw_control_write;
logic                                           cfg_visa_sw_control_write_done;
hqm_sif_csr_hc_reg_write_t                      cfg_wdata;
hqm_sif_csr_handcoded_t                         cfg_we;
hqm_sif_csr_hc_wvalid_t                         cfg_wvalid;
logic                                           cfgm_idle;
new_CFGM_STATUS_t                               cfgm_status;
new_CFGM_STATUS2_t                              cfgm_status2;
logic                                           cfgm_timeout_error;
logic                                           cpl_abort;
logic                                           cpl_error;
tdl_cplhdr_t                                    cpl_error_hdr;
logic                                           cpl_poisoned;
logic                                           cpl_timeout;
logic [8:0]                                     cpl_timeout_synd;
logic                                           cpl_unexpected;
logic                                           cpl_usr;
logic                                           csr_pasid_enable;
logic                                           csr_pmsixctl_fm_wxp;
logic                                           csr_pmsixctl_msie_wxp;
logic                                           err_gen_msg;
logic [15:0]                                    err_gen_msg_func;
logic [7:0]                                     err_gen_msg_data;
logic                                           err_sb_msgack;
logic                                           flr_treatment;
logic                                           flr_treatment_vec;
logic [6:2]                                     flr_triggered_wl;
logic                                           force_pm_state_d3hot;
logic                                           force_ip_inaccessible;
logic                                           force_warm_reset;
logic                                           hard_rst_np;
logic                                           hcw_enq_in_ready_qual;
logic                                           hcw_enq_in_v_prequal;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t             hqm_csr_ext_mmio_req;
logic                                           hqm_csr_ext_mmio_req_apar;
logic                                           hqm_csr_ext_mmio_req_dpar;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t             hqm_csr_ext_mmio_ack;
logic [1:0]                                     hqm_csr_ext_mmio_ack_err;
logic [63:0]                                    hqm_csr_rac;
logic [63:0]                                    hqm_csr_wac;
logic                                           hqm_idle;
hqm_sif_csr_pkg::hqm_sif_csr_sai_export_t       hqm_sif_csr_sai_export;
logic                                           hqm_sif_idle;
logic                                           int_idle;
logic [31:0]                                    int_serial_status;
SIF_ALARM_ERR_t                                 sif_alarm_err;
logic                                           sif_parity_alarm;
logic                                           sif_mstr_quiesce_ack;
IOSFP_CGCTL_t                                   iosfp_cgctl;
IOSFS_CGCTL_t                                   iosfs_cgctl;
logic                                           mask_posted;
logic [2:0]                                     mstr_db_status_in_stalled;
logic [2:0]                                     mstr_db_status_in_taken;
logic [2:0]                                     mstr_db_status_out_stalled;
logic [2:0]                                     mstr_fifo_afull;
logic                                           mstr_fifo_overflow;
logic                                           mstr_fifo_underflow;
logic                                           ti_idle;
logic                                           ti_intf_idle;
logic                                           mstr_idle;
logic                                           mstr_intf_idle;
logic                                           prim_clkack_async_sbe;
logic                                           prim_clkreq_async_sbe;
logic                                           prim_gated_wflr_rst_b_primary;
logic                                           quiesce_qualifier;
logic                                           rf_ipar_error;
logic [5:0]                                     ri_db_status_in_stalled;
logic [5:0]                                     ri_db_status_in_taken;
logic [5:0]                                     ri_db_status_out_stalled;
logic [5:0]                                     ri_fifo_afull;
logic                                           ri_fifo_overflow;
logic                                           ri_fifo_underflow;
logic                                           ri_idle;
logic                                           ri_iosf_sb_idle;
logic                                           sif_mstr_quiesce_req;
logic                                           ri_parity_alarm;
logic                                           rpa_clkreq;
hqm_sb_ri_cds_msg_t                             sb_cds_msg;
hqm_sif_fuses_t                                 sb_ep_fuses;
logic                                           sb_ep_parity_err_sync;
logic                                           sbe_prim_clkreq_nc;
load_SIF_ALARM_ERR_t                            set_sif_alarm_err;
load_SIF_PARITY_ERR_t                           set_sif_parity_err;
logic [8:0]                                     set_sif_parity_err_mstr;
load_RI_PARITY_ERR_t                            set_ri_parity_err;
logic                                           side_clkack_async_sbebase;
logic                                           side_clkreq_async_ri_iosf_sb;
logic                                           side_clkreq_async_sbebase;
logic                                           side_gated_clk;
logic                                           side_gated_rst_b;
logic                                           side_gated_rst_prim_b;
logic                                           tgt_idle;
logic                                           tlq_idle;
logic                                           timeout_error;
logic [9:0]                                     timeout_syndrome;
load_DEVTLB_ATS_ERR_t                           set_devtlb_ats_err;
logic                                           devtlb_ats_alarm;
logic                                           cds_smon_event;
logic [31:0]                                    cds_smon_comp;

logic                                           hqm_csr_pf0_rst_n;
logic                                           func_in_rst;

logic                                           flr_clk_enable;
logic                                           flr_clk_enable_system;

logic                                           flr_txn_sent;
nphdr_tag_t                                     flr_txn_tag;
hdr_reqid_t                                     flr_txn_reqid;

logic                                           ps_txn_sent;
nphdr_tag_t                                     ps_txn_tag;
hdr_reqid_t                                     ps_txn_reqid;

logic [13:0]                                    flr_visa_ri;

hqm_iosf_tgt_crd_t                              ri_tgt_crd_inc;

logic                                           lli_phdr_val;
tdl_phdr_t                                      lli_phdr;

logic                                           lli_nphdr_val;
tdl_nphdr_t                                     lli_nphdr;

logic                                           lli_pdata_push;
logic                                           lli_npdata_push;
ri_bus_width_t                                  lli_pkt_data;
ri_bus_par_t                                    lli_pkt_data_par;

logic                                           iosf_ep_cpar_err;
logic                                           iosf_ep_tecrc_err;
errhdr_t                                        iosf_ep_chdr_w_err;

logic                                           np_trans_pending;
logic                                           poisoned_wr_sent;

logic                                           obcpl_ready;

logic                                           obcpl_v;
RiObCplHdr_t                                    obcpl_hdr;
csr_data_t                                      obcpl_data;
logic                                           obcpl_dpar;
upd_enables_t                                   obcpl_enables;

upd_enables_t                                   gpsb_upd_enables;

logic                                           csr_ppdcntl_ero;

logic [7:0]                                     current_bus;

HQM_SIF_CNT_CTL_t                               hqm_sif_cnt_ctl;

SIF_CTL_t                                       cfg_sif_ctl;
SIF_VC_RXMAP_t                                  cfg_sif_vc_rxmap;
SIF_VC_TXMAP_t                                  cfg_sif_vc_txmap;

logic [1:0] [31:0]                              mstr_cnts;

logic [256:0]                                   noa_ri;

logic                                           rx_msg_v;
hqm_devtlb_rx_msg_t                             rx_msg;

logic                                           cfg_ats_enabled;
SCRBD_CTL_t                                     cfg_scrbd_ctl;
MSTR_LL_CTL_t                                   cfg_mstr_ll_ctl;
DEVTLB_CTL_t                                    cfg_devtlb_ctl;
DEVTLB_SPARE_t                                  cfg_devtlb_spare;
DEVTLB_DEFEATURE0_t                             cfg_devtlb_defeature0;
DEVTLB_DEFEATURE1_t                             cfg_devtlb_defeature1;
DEVTLB_DEFEATURE2_t                             cfg_devtlb_defeature2;

logic [63:0]                                    cfg_ph_trigger_addr;
logic [63:0]                                    cfg_ph_trigger_mask;

new_TGT_INIT_HCREDITS_t                         tgt_init_hcredits;
new_TGT_INIT_DCREDITS_t                         tgt_init_dcredits;
new_TGT_REM_HCREDITS_t                          tgt_rem_hcredits;
new_TGT_REM_DCREDITS_t                          tgt_rem_dcredits;
new_TGT_RET_HCREDITS_t                          tgt_ret_hcredits;
new_TGT_RET_DCREDITS_t                          tgt_ret_dcredits;

DIR_CQ2TC_MAP_t                                 dir_cq2tc_map;
LDB_CQ2TC_MAP_t                                 ldb_cq2tc_map;
INT2TC_MAP_t                                    int2tc_map;

IBCPL_HDR_FIFO_CTL_t                            cfg_ibcpl_hdr_fifo_ctl;
IBCPL_DATA_FIFO_CTL_t                           cfg_ibcpl_data_fifo_ctl;

new_IBCPL_HDR_FIFO_STATUS_t                     cfg_ibcpl_hdr_fifo_status;
new_IBCPL_DATA_FIFO_STATUS_t                    cfg_ibcpl_data_fifo_status;
new_P_RL_CQ_FIFO_STATUS_t                       cfg_p_rl_cq_fifo_status;

new_LOCAL_BME_STATUS_t                          local_bme_status;
new_LOCAL_MSIXE_STATUS_t                        local_msixe_status;

new_SIF_MSTR_DEBUG_t                            sif_mstr_debug;

hqm_sif_csr_pkg::PARITY_CTL_t                   cfg_parity_ctl;

new_DEVTLB_STATUS_t                             devtlb_status;
new_SCRBD_STATUS_t                              scrbd_status;
new_MSTR_CRD_STATUS_t                           mstr_crd_status;
new_MSTR_FL_STATUS_t                            mstr_fl_status;
new_MSTR_LL_STATUS_t                            mstr_ll_status;

new_SIF_DB_STATUS_t                             sif_db_status;

new_SIF_IDLE_STATUS_t                           sif_idle_status;
SIF_IDLE_STATUS_t                               sif_idle_status_reg;

logic                                           hqm_proc_idle_sync;
logic                                           hqm_proc_clkreq;
logic                                           quiesce_clkreq;

logic                                           hqm_inp_gated_rst_n_nc;

// Memory interfaces

hqm_sif_memi_fifo_phdr_t                        memi_ri_tlq_fifo_phdr;
hqm_sif_memo_fifo_phdr_t                        memo_ri_tlq_fifo_phdr;
hqm_sif_memi_fifo_pdata_t                       memi_ri_tlq_fifo_pdata;
hqm_sif_memo_fifo_pdata_t                       memo_ri_tlq_fifo_pdata;
hqm_sif_memi_fifo_nphdr_t                       memi_ri_tlq_fifo_nphdr;
hqm_sif_memo_fifo_nphdr_t                       memo_ri_tlq_fifo_nphdr;
hqm_sif_memi_fifo_npdata_t                      memi_ri_tlq_fifo_npdata;
hqm_sif_memo_fifo_npdata_t                      memo_ri_tlq_fifo_npdata;

hqm_sif_memi_scrbd_mem_t                        memi_scrbd_mem;
hqm_sif_memo_scrbd_mem_t                        memo_scrbd_mem;
hqm_sif_memi_ibcpl_hdr_t                        memi_ibcpl_hdr_fifo;
hqm_sif_memo_ibcpl_hdr_t                        memo_ibcpl_hdr_fifo;
hqm_sif_memi_ibcpl_data_t                       memi_ibcpl_data_fifo;
hqm_sif_memo_ibcpl_data_t                       memo_ibcpl_data_fifo;
hqm_sif_memi_mstr_ll_hpa_t                      memi_mstr_ll_hpa;
hqm_sif_memo_mstr_ll_hpa_t                      memo_mstr_ll_hpa;
hqm_sif_memi_mstr_ll_hdr_t                      memi_mstr_ll_hdr;
hqm_sif_memo_mstr_ll_hdr_t                      memo_mstr_ll_hdr;
hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data0;
hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data0;
hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data1;
hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data1;
hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data2;
hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data2;
hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data3;
hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data3;

hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag0_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag0_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag1_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag1_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag2_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag2_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag3_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag3_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag4_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag4_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag5_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag5_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag6_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag6_4k;
hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag7_4k;
hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag7_4k;

hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data0_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data0_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data1_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data1_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data2_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data2_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data3_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data3_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data4_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data4_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data5_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data5_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data6_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data6_4k;
hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data7_4k;
hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data7_4k;

`ifdef HQM_SFI

logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail;

logic                                           agent_tx_v;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             agent_tx_vc;
hqm_sfi_fc_id_t                                 agent_tx_fc;
logic [3:0]                                     agent_tx_hdr_size;
logic                                           agent_tx_hdr_has_data;
hqm_sfi_flit_header_t                           agent_tx_hdr;
logic                                           agent_tx_hdr_par;
logic [(HQM_SFI_TX_D*16)-1:0]                   agent_tx_data;
logic [(HQM_SFI_TX_D/4)-1:0]                    agent_tx_data_par;

logic                                           agent_tx_ack;

logic                                           rx_hcrd_return_v;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             rx_hcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_hcrd_return_fc;
logic [HQM_SFI_RX_NHCRD-1:0]                    rx_hcrd_return_val;

logic                                           rx_dcrd_return_v;
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            rx_dcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_dcrd_return_fc;
logic [HQM_SFI_RX_NDCRD-1:0]                    rx_dcrd_return_val;

logic                                           agent_rxqs_empty;

logic                                           ibcpl_hdr_push;
tdl_cplhdr_t                                    ibcpl_hdr;

logic                                           ibcpl_data_push;
logic [HQM_IBCPL_DATA_WIDTH-1:0]                ibcpl_data;
logic [HQM_IBCPL_PARITY_WIDTH-1:0]              ibcpl_data_par;

logic                                           prim_clkreq_sync;
logic [1:0]                                     prim_clkreq_async;
logic [1:0]                                     prim_clkack_async;

logic                                           write_buffer_mstr_v_qual;

logic [191:0]                                   noa_mstr;

logic                                           prim_rst_b_synced;
logic                                           prim_gated_rst_b_synced;

logic                                           sfi_rx_idle;
logic                                           sfi_tx_idle;

logic                                           cfg_ph_trigger_enable;
logic                                           ph_trigger;

logic                                           gnt;
logic [1:0]                                     gnt_rtype;
logic [1:0]                                     gnt_type;

logic                                           mrsvd1_7;
logic                                           mrsvd1_3;
logic [7:0]                                     mtag;
logic [15:0]                                    mrqid;

logic                                           cmd_put;
logic [1:0]                                     cmd_rtype;

logic                                           credit_cmd;
logic [2:0]                                     credit_data;
logic                                           credit_put;
logic [1:0]                                     credit_rtype;

logic                                           req_put;
logic [1:0]                                     req_rtype;
logic [9:0]                                     req_dlen;

logic [1:0]                                     mfmt;
logic [4:0]                                     mtype;
logic [9:0]                                     mlength;

logic [1:0]                                     tfmt;
logic [4:0]                                     ttype;
logic [9:0]                                     tlength;

logic                                           strap_hqm_completertenbittagen;

logic                                           tx_hcrd_consume_v;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             tx_hcrd_consume_vc;
hqm_sfi_fc_id_t                                 tx_hcrd_consume_fc;
logic                                           tx_hcrd_consume_val;

logic                                           tx_dcrd_consume_v;
logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]            tx_dcrd_consume_vc;
hqm_sfi_fc_id_t                                 tx_dcrd_consume_fc;
logic [2:0]                                     tx_dcrd_consume_val;

hqm_sfi_flit_header_t                           sfi_tx_header_rev;

hqm_ti #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_ti (

     .prim_nonflr_clk                       (prim_nonflr_clk)                   //I: TI:

    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: TI:
    ,.prim_gated_wflr_rst_b                 (prim_gated_wflr_rst_b_primary)     //I: TI:

    ,.hqm_csr_pf0_rst_n                     (hqm_csr_pf0_rst_n)                 //I: TI:

    ,.flr_treatment_vec                     (flr_treatment_vec)                 //I: TI:

    ,.strap_hqm_cmpl_sai                    (strap_hqm_cmpl_sai)                //I: TI:
    ,.strap_hqm_tx_sai                      (strap_hqm_tx_sai)                  //I: TI:

    ,.current_bus                           (current_bus)                       //I: TI:

    ,.cfg_ats_enabled                       (cfg_ats_enabled)                   //I: TI:
    ,.cfg_mstr_ll_ctl                       (cfg_mstr_ll_ctl)                   //I: TI:
    ,.cfg_mstr_par_off                      (cfg_parity_ctl.MSTR_PAR_OFF)       //I: TI:
    ,.cfg_scrbd_ctl                         (cfg_scrbd_ctl)                     //I: TI:

    ,.cfg_devtlb_ctl                        (cfg_devtlb_ctl)                    //I: TI:
    ,.cfg_devtlb_defeature0                 (cfg_devtlb_defeature0)             //I: TI:
    ,.cfg_devtlb_defeature1                 (cfg_devtlb_defeature1)             //I: TI:
    ,.cfg_devtlb_defeature2                 (cfg_devtlb_defeature2)             //I: TI:
    ,.cfg_devtlb_spare                      (cfg_devtlb_spare)                  //I: TI:

    ,.cfg_ph_trigger_enable                 (cfg_ph_trigger_enable)             //I: TI
    ,.cfg_ph_trigger_addr                   (cfg_ph_trigger_addr)               //I: TI:
    ,.cfg_ph_trigger_mask                   (cfg_ph_trigger_mask)               //I: TI:

    ,.hqm_sif_cnt_ctl                       (hqm_sif_cnt_ctl)                   //I: TI:
    ,.dir_cq2tc_map                         (dir_cq2tc_map)                     //I: TI:
    ,.ldb_cq2tc_map                         (ldb_cq2tc_map)                     //I: TI:
    ,.int2tc_map                            (int2tc_map)                        //I: TI:

    ,.csr_ppdcntl_ero                       (csr_ppdcntl_ero)                   //I: TI:

    ,.cfg_ibcpl_hdr_fifo_high_wm            (cfg_ibcpl_hdr_fifo_ctl.HIGH_WM)    //I: TI:
    ,.cfg_ibcpl_data_fifo_high_wm           (cfg_ibcpl_data_fifo_ctl.HIGH_WM)   //I: TI:

    ,.cfg_ibcpl_hdr_fifo_status             (cfg_ibcpl_hdr_fifo_status)         //O: TI:
    ,.cfg_ibcpl_data_fifo_status            (cfg_ibcpl_data_fifo_status)        //O: TI:

    ,.devtlb_status                         (devtlb_status)                     //O: TI:
    ,.mstr_fl_status                        (mstr_fl_status)                    //O: TI:
    ,.mstr_ll_status                        (mstr_ll_status)                    //O: TI:
    ,.scrbd_status                          (scrbd_status)                      //O: TI:

    ,.local_bme_status                      (local_bme_status)                  //O: TI:
    ,.local_msixe_status                    (local_msixe_status)                //O: TI:

    ,.write_buffer_mstr_ready               (write_buffer_mstr_ready)           //O: TI:

    ,.write_buffer_mstr_v                   (write_buffer_mstr_v_qual)          //I: TI:
    ,.write_buffer_mstr                     (write_buffer_mstr)                 //I: TI:

    ,.obcpl_ready                           (obcpl_ready)                       //O: TI:

    ,.obcpl_v                               (obcpl_v)                           //I: TI:
    ,.obcpl_hdr                             (obcpl_hdr)                         //I: TI:
    ,.obcpl_data                            (obcpl_data)                        //I: TI:
    ,.obcpl_dpar                            (obcpl_dpar)                        //I: TI:
    ,.obcpl_enables                         (obcpl_enables)                     //I: TI:

    ,.gpsb_upd_enables                      (gpsb_upd_enables)                  //I: TI:

    ,.ibcpl_hdr_push                        (ibcpl_hdr_push)                    //I: TI:
    ,.ibcpl_hdr                             (ibcpl_hdr)                         //I: TI:

    ,.ibcpl_data_push                       (ibcpl_data_push)                   //I: TI:
    ,.ibcpl_data                            (ibcpl_data)                        //I: TI:
    ,.ibcpl_data_par                        (ibcpl_data_par)                    //I: TI:

    ,.rx_msg_v                              (rx_msg_v)                          //I: TI:
    ,.rx_msg                                (rx_msg)                            //I: TI:

    ,.tx_hcrds_avail                        (tx_hcrds_avail)                    //I: TI:
    ,.tx_dcrds_avail                        (tx_dcrds_avail)                    //I: TI:

    ,.tx_hcrd_consume_v                     (tx_hcrd_consume_v)                 //O: TI:
    ,.tx_hcrd_consume_vc                    (tx_hcrd_consume_vc)                //O: TI:
    ,.tx_hcrd_consume_fc                    (tx_hcrd_consume_fc)                //O: TI:
    ,.tx_hcrd_consume_val                   (tx_hcrd_consume_val)               //O: TI:

    ,.tx_dcrd_consume_v                     (tx_dcrd_consume_v)                 //O: TI:
    ,.tx_dcrd_consume_vc                    (tx_dcrd_consume_vc)                //O: TI:
    ,.tx_dcrd_consume_fc                    (tx_dcrd_consume_fc)                //O: TI:
    ,.tx_dcrd_consume_val                   (tx_dcrd_consume_val)               //O: TI:

    ,.agent_tx_v                            (agent_tx_v)                        //O: TI:
    ,.agent_tx_vc                           (agent_tx_vc)                       //O: TI:
    ,.agent_tx_fc                           (agent_tx_fc)                       //O: TI:
    ,.agent_tx_hdr_size                     (agent_tx_hdr_size)                 //O: TI:
    ,.agent_tx_hdr_has_data                 (agent_tx_hdr_has_data)             //O: TI:
    ,.agent_tx_hdr                          (agent_tx_hdr)                      //O: TI:
    ,.agent_tx_hdr_par                      (agent_tx_hdr_par)                  //O: TI:
    ,.agent_tx_data                         (agent_tx_data)                     //O: TI:
    ,.agent_tx_data_par                     (agent_tx_data_par)                 //O: TI:

    ,.agent_tx_ack                          (agent_tx_ack)                      //I: TI:

    ,.func_in_rst                           (func_in_rst)                       //I: TI:

    ,.flr_txn_sent                          (flr_txn_sent)                      //I: TI:
    ,.flr_txn_tag                           (flr_txn_tag)                       //I: TI:
    ,.flr_txn_reqid                         (flr_txn_reqid)                     //I: TI:

    ,.flr_triggered                         (flr_triggered)                     //O: TI:

    ,.ps_txn_sent                           (ps_txn_sent)                       //I: TI:
    ,.ps_txn_tag                            (ps_txn_tag)                        //I: TI:
    ,.ps_txn_reqid                          (ps_txn_reqid)                      //I: TI:

    ,.sif_mstr_quiesce_req                  (sif_mstr_quiesce_req)              //I: TI:
    ,.sif_mstr_quiesce_ack                  (sif_mstr_quiesce_ack)              //O: TI:

    ,.ti_idle                               (ti_idle)                           //O: TI:
    ,.ti_intf_idle                          (ti_intf_idle)                      //O: TI:
    ,.np_trans_pending                      (np_trans_pending)                  //O: TI:

    ,.poisoned_wr_sent                      (poisoned_wr_sent)                  //O: TI:

    ,.cpl_abort                             (cpl_abort)                         //O: TI:
    ,.cpl_poisoned                          (cpl_poisoned)                      //O: TI:
    ,.cpl_unexpected                        (cpl_unexpected)                    //O: TI:
    ,.cpl_usr                               (cpl_usr)                           //O: TI:
    ,.cpl_error_hdr                         (cpl_error_hdr)                     //O: TI:

    ,.cpl_timeout                           (cpl_timeout)                       //O: TI:
    ,.cpl_timeout_synd                      (cpl_timeout_synd)                  //O: TI:

    ,.sif_parity_alarm                      (sif_parity_alarm)                  //O: TI:
    ,.set_sif_parity_err                    (set_sif_parity_err_mstr)           //O: TI:

    ,.devtlb_ats_alarm                      (devtlb_ats_alarm)                  //O: TI:
    ,.set_devtlb_ats_err                    (set_devtlb_ats_err)                //O: TI:

    ,.mstr_cnts                             (mstr_cnts)                         //O: TI:

    ,.ph_trigger                            (ph_trigger)                        //O: TI:

    ,.sif_mstr_debug                        (sif_mstr_debug)                    //O: TI:
    ,.mstr_crd_status                       (mstr_crd_status)                   //O: TI:
    ,.noa_mstr                              (noa_mstr)                          //O: TI:


    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: TI:
    ,.fscan_clkungate                       (fscan_clkungate)                   //I: TI:
    ,.fscan_clkungate_syn                   (fscan_clkungate_syn)               //I: TI:
    ,.fscan_latchclosed_b                   (fscan_latchclosed_b)               //I: TI:
    ,.fscan_latchopen                       (fscan_latchopen)                   //I: TI:
    ,.fscan_mode                            (fscan_mode)                        //I: TI:
    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: TI:
    ,.fscan_shiften                         (fscan_shiften)                     //I: TI:

    ,.memi_scrbd_mem                        (memi_scrbd_mem)                    //O: TI:
    ,.memo_scrbd_mem                        (memo_scrbd_mem)                    //I: TI:
    ,.memi_ibcpl_hdr_fifo                   (memi_ibcpl_hdr_fifo)               //O: TI:
    ,.memo_ibcpl_hdr_fifo                   (memo_ibcpl_hdr_fifo)               //I: TI:
    ,.memi_ibcpl_data_fifo                  (memi_ibcpl_data_fifo)              //O: TI:
    ,.memo_ibcpl_data_fifo                  (memo_ibcpl_data_fifo)              //I: TI:
    ,.memi_mstr_ll_hpa                      (memi_mstr_ll_hpa)                  //O: TI:
    ,.memo_mstr_ll_hpa                      (memo_mstr_ll_hpa)                  //I: TI:
    ,.memi_mstr_ll_hdr                      (memi_mstr_ll_hdr)                  //O: TI:
    ,.memo_mstr_ll_hdr                      (memo_mstr_ll_hdr)                  //I: TI:
    ,.memi_mstr_ll_data0                    (memi_mstr_ll_data0)                //O: TI:
    ,.memo_mstr_ll_data0                    (memo_mstr_ll_data0)                //I: TI:
    ,.memi_mstr_ll_data1                    (memi_mstr_ll_data1)                //O: TI:
    ,.memo_mstr_ll_data1                    (memo_mstr_ll_data1)                //I: TI:
    ,.memi_mstr_ll_data2                    (memi_mstr_ll_data2)                //O: TI:
    ,.memo_mstr_ll_data2                    (memo_mstr_ll_data2)                //I: TI:
    ,.memi_mstr_ll_data3                    (memi_mstr_ll_data3)                //O: TI:
    ,.memo_mstr_ll_data3                    (memo_mstr_ll_data3)                //I: TI:

    ,.memi_tlb_tag0_4k                      (memi_tlb_tag0_4k)                  //O: TI:
    ,.memo_tlb_tag0_4k                      (memo_tlb_tag0_4k)                  //I: TI:
    ,.memi_tlb_tag1_4k                      (memi_tlb_tag1_4k)                  //O: TI:
    ,.memo_tlb_tag1_4k                      (memo_tlb_tag1_4k)                  //I: TI:
    ,.memi_tlb_tag2_4k                      (memi_tlb_tag2_4k)                  //O: TI:
    ,.memo_tlb_tag2_4k                      (memo_tlb_tag2_4k)                  //I: TI:
    ,.memi_tlb_tag3_4k                      (memi_tlb_tag3_4k)                  //O: TI:
    ,.memo_tlb_tag3_4k                      (memo_tlb_tag3_4k)                  //I: TI:
    ,.memi_tlb_tag4_4k                      (memi_tlb_tag4_4k)                  //O: TI:
    ,.memo_tlb_tag4_4k                      (memo_tlb_tag4_4k)                  //I: TI:
    ,.memi_tlb_tag5_4k                      (memi_tlb_tag5_4k)                  //O: TI:
    ,.memo_tlb_tag5_4k                      (memo_tlb_tag5_4k)                  //I: TI:
    ,.memi_tlb_tag6_4k                      (memi_tlb_tag6_4k)                  //O: TI:
    ,.memo_tlb_tag6_4k                      (memo_tlb_tag6_4k)                  //I: TI:
    ,.memi_tlb_tag7_4k                      (memi_tlb_tag7_4k)                  //O: TI:
    ,.memo_tlb_tag7_4k                      (memo_tlb_tag7_4k)                  //I: TI:

    ,.memi_tlb_data0_4k                     (memi_tlb_data0_4k)                 //O: TI:
    ,.memo_tlb_data0_4k                     (memo_tlb_data0_4k)                 //I: TI:
    ,.memi_tlb_data1_4k                     (memi_tlb_data1_4k)                 //O: TI:
    ,.memo_tlb_data1_4k                     (memo_tlb_data1_4k)                 //I: TI:
    ,.memi_tlb_data2_4k                     (memi_tlb_data2_4k)                 //O: TI:
    ,.memo_tlb_data2_4k                     (memo_tlb_data2_4k)                 //I: TI:
    ,.memi_tlb_data3_4k                     (memi_tlb_data3_4k)                 //O: TI:
    ,.memo_tlb_data3_4k                     (memo_tlb_data3_4k)                 //I: TI:
    ,.memi_tlb_data4_4k                     (memi_tlb_data4_4k)                 //O: TI:
    ,.memo_tlb_data4_4k                     (memo_tlb_data4_4k)                 //I: TI:
    ,.memi_tlb_data5_4k                     (memi_tlb_data5_4k)                 //O: TI:
    ,.memo_tlb_data5_4k                     (memo_tlb_data5_4k)                 //I: TI:
    ,.memi_tlb_data6_4k                     (memi_tlb_data6_4k)                 //O: TI:
    ,.memo_tlb_data6_4k                     (memo_tlb_data6_4k)                 //I: TI:
    ,.memi_tlb_data7_4k                     (memi_tlb_data7_4k)                 //O: TI:
    ,.memo_tlb_data7_4k                     (memo_tlb_data7_4k)                 //I: TI:
);

hqm_sfi_core #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_core (

     .pgcb_clk                              (pgcb_clk)                          //I: SFI_CORE:

    ,.pma_safemode                          (pma_safemode)                      //I: SFI_CORE:
    ,.prim_pwrgate_pmc_wake                 (prim_pwrgate_pmc_wake)             //I: SFI_CORE:

    ,.prim_freerun_clk                      (prim_freerun_clk)                  //I: SFI_CORE:
    ,.prim_nonflr_clk                       (prim_nonflr_clk)                   //I: SFI_CORE:

    ,.prim_rst_b                            (prim_rst_b)                        //I: SFI_CORE:
    ,.side_rst_b                            (side_rst_b)                        //I: SFI_CORE:

    ,.prim_clkreq                           (prim_clkreq)                       //O: SFI_CORE:
    ,.prim_clkack                           (prim_clkack)                       //I: SFI_CORE:

    ,.prim_clkreq_sync                      (prim_clkreq_sync)                  //I: SFI_CORE:
    ,.prim_clkreq_async                     (prim_clkreq_async)                 //I: SFI_CORE:
    ,.prim_clkack_async                     (prim_clkack_async)                 //O: SFI_CORE:

    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //O: SFI_CORE:
    ,.side_gated_rst_prim_b                 (side_gated_rst_prim_b)             //O: SFI_CORE:

    ,.flr_clk_enable                        (flr_clk_enable)                    //I: SFI_CORE:
    ,.flr_clk_enable_system                 (flr_clk_enable_system)             //I: SFI_CORE:

    ,.prim_clk_enable                       (prim_clk_enable)                   //O: SFI_CORE:
    ,.prim_clk_enable_cdc                   (prim_clk_enable_cdc)               //O: SFI_CORE:
    ,.prim_clk_enable_sys                   (prim_clk_enable_sys)               //O: SFI_CORE:
    ,.prim_clk_ungate                       (prim_clk_ungate)                   //O: SFI_CORE:

    ,.force_ip_inaccessible                 (force_ip_inaccessible)             //I: SFI_CORE:
    ,.force_pm_state_d3hot                  (force_pm_state_d3hot)              //I: SFI_CORE:
    ,.force_warm_reset                      (force_warm_reset)                  //I: SFI_CORE:
    ,.pm_fsm_d3tod0_ok                      (pm_fsm_d3tod0_ok)                  //I: SFI_CORE:

    ,.cfg_parity_ctl                        (cfg_parity_ctl)                    //I: SFI_CORE:
    ,.cfg_prim_cdc_ctl                      (cfg_prim_cdc_ctl)                  //I: SFI_CORE:
    ,.cfg_sif_ctl                           (cfg_sif_ctl)                       //I: SFI_CORE:
    ,.cfg_sif_vc_rxmap                      (cfg_sif_vc_rxmap)                  //I: SFI_CORE:
    ,.cfg_sif_vc_txmap                      (cfg_sif_vc_txmap)                  //I: SFI_CORE:

    ,.sb_ep_fuses                           (sb_ep_fuses)                       //I: SFI_CORE:

    ,.sfi_rx_idle                           (sfi_rx_idle)                       //O: SFI_CORE:
    ,.sfi_tx_idle                           (sfi_tx_idle)                       //O: SFI_CORE:

    ,.sfi_tx_txcon_req                      (sfi_tx_txcon_req)                  //O: SFI_CORE:

    ,.sfi_tx_rxcon_ack                      (sfi_tx_rxcon_ack)                  //I: SFI_CORE:
    ,.sfi_tx_rxdiscon_nack                  (sfi_tx_rxdiscon_nack)              //I: SFI_CORE:
    ,.sfi_tx_rx_empty                       (sfi_tx_rx_empty)                   //I: SFI_CORE:

    ,.sfi_tx_hdr_valid                      (sfi_tx_hdr_valid)                  //O: SFI_CORE:
    ,.sfi_tx_hdr_early_valid                (sfi_tx_hdr_early_valid)            //O: SFI_CORE:
    ,.sfi_tx_hdr_info_bytes                 (sfi_tx_hdr_info_bytes)             //O: SFI_CORE:
    ,.sfi_tx_header                         (sfi_tx_header)                     //O: SFI_CORE:

    ,.sfi_tx_hdr_block                      (sfi_tx_hdr_block)                  //I: SFI_CORE:

    ,.sfi_tx_hdr_crd_rtn_valid              (sfi_tx_hdr_crd_rtn_valid)          //I: SFI_CORE:
    ,.sfi_tx_hdr_crd_rtn_vc_id              (sfi_tx_hdr_crd_rtn_vc_id)          //I: SFI_CORE:
    ,.sfi_tx_hdr_crd_rtn_fc_id              (sfi_tx_hdr_crd_rtn_fc_id)          //I: SFI_CORE:
    ,.sfi_tx_hdr_crd_rtn_value              (sfi_tx_hdr_crd_rtn_value)          //I: SFI_CORE:

    ,.sfi_tx_hdr_crd_rtn_block              (sfi_tx_hdr_crd_rtn_block)          //O: SFI_CORE:

    ,.sfi_tx_data_valid                     (sfi_tx_data_valid)                 //O: SFI_CORE:
    ,.sfi_tx_data_early_valid               (sfi_tx_data_early_valid)           //O: SFI_CORE:
    ,.sfi_tx_data_aux_parity                (sfi_tx_data_aux_parity)            //O: SFI_CORE:
    ,.sfi_tx_data_poison                    (sfi_tx_data_poison)                //O: SFI_CORE:
    ,.sfi_tx_data_edb                       (sfi_tx_data_edb)                   //O: SFI_CORE:
    ,.sfi_tx_data_start                     (sfi_tx_data_start)                 //O: SFI_CORE:
    ,.sfi_tx_data_end                       (sfi_tx_data_end)                   //O: SFI_CORE:
    ,.sfi_tx_data_parity                    (sfi_tx_data_parity)                //O: SFI_CORE:
    ,.sfi_tx_data_info_byte                 (sfi_tx_data_info_byte)             //O: SFI_CORE:
    ,.sfi_tx_data                           (sfi_tx_data)                       //O: SFI_CORE:

    ,.sfi_tx_data_block                     (sfi_tx_data_block)                 //I: SFI_CORE:

    ,.sfi_tx_data_crd_rtn_valid             (sfi_tx_data_crd_rtn_valid)         //I: SFI_CORE:
    ,.sfi_tx_data_crd_rtn_vc_id             (sfi_tx_data_crd_rtn_vc_id)         //I: SFI_CORE:
    ,.sfi_tx_data_crd_rtn_fc_id             (sfi_tx_data_crd_rtn_fc_id)         //I: SFI_CORE:
    ,.sfi_tx_data_crd_rtn_value             (sfi_tx_data_crd_rtn_value)         //I: SFI_CORE:

    ,.sfi_tx_data_crd_rtn_block             (sfi_tx_data_crd_rtn_block)         //O: SFI_CORE:

    ,.sfi_rx_txcon_req                      (sfi_rx_txcon_req)                  //I: SFI_CORE:

    ,.sfi_rx_rxcon_ack                      (sfi_rx_rxcon_ack)                  //O: SFI_CORE:
    ,.sfi_rx_rxdiscon_nack                  (sfi_rx_rxdiscon_nack)              //O: SFI_CORE:
    ,.sfi_rx_rx_empty                       (sfi_rx_rx_empty)                   //O: SFI_CORE:

    ,.sfi_rx_hdr_valid                      (sfi_rx_hdr_valid)                  //I: SFI_CORE:
    ,.sfi_rx_hdr_early_valid                (sfi_rx_hdr_early_valid)            //I: SFI_CORE:
    ,.sfi_rx_hdr_info_bytes                 (sfi_rx_hdr_info_bytes)             //I: SFI_CORE:
    ,.sfi_rx_header                         (sfi_rx_header)                     //I: SFI_CORE:

    ,.sfi_rx_hdr_block                      (sfi_rx_hdr_block)                  //O: SFI_CORE:

    ,.sfi_rx_hdr_crd_rtn_valid              (sfi_rx_hdr_crd_rtn_valid)          //O: SFI_CORE:
    ,.sfi_rx_hdr_crd_rtn_vc_id              (sfi_rx_hdr_crd_rtn_vc_id)          //O: SFI_CORE:
    ,.sfi_rx_hdr_crd_rtn_fc_id              (sfi_rx_hdr_crd_rtn_fc_id)          //O: SFI_CORE:
    ,.sfi_rx_hdr_crd_rtn_value              (sfi_rx_hdr_crd_rtn_value)          //O: SFI_CORE:

    ,.sfi_rx_hdr_crd_rtn_block              (sfi_rx_hdr_crd_rtn_block)          //I: SFI_CORE:

    ,.sfi_rx_data_valid                     (sfi_rx_data_valid)                 //I: SFI_CORE:
    ,.sfi_rx_data_early_valid               (sfi_rx_data_early_valid)           //I: SFI_CORE:
    ,.sfi_rx_data_aux_parity                (sfi_rx_data_aux_parity)            //I: SFI_CORE:
    ,.sfi_rx_data_poison                    (sfi_rx_data_poison)                //I: SFI_CORE:
    ,.sfi_rx_data_edb                       (sfi_rx_data_edb)                   //I: SFI_CORE:
    ,.sfi_rx_data_start                     (sfi_rx_data_start)                 //I: SFI_CORE:
    ,.sfi_rx_data_end                       (sfi_rx_data_end)                   //I: SFI_CORE:
    ,.sfi_rx_data_parity                    (sfi_rx_data_parity)                //I: SFI_CORE:
    ,.sfi_rx_data_info_byte                 (sfi_rx_data_info_byte)             //I: SFI_CORE:
    ,.sfi_rx_data                           (sfi_rx_data)                       //I: SFI_CORE:

    ,.sfi_rx_data_block                     (sfi_rx_data_block)                 //O: SFI_CORE:

    ,.sfi_rx_data_crd_rtn_valid             (sfi_rx_data_crd_rtn_valid)         //O: SFI_CORE:
    ,.sfi_rx_data_crd_rtn_vc_id             (sfi_rx_data_crd_rtn_vc_id)         //O: SFI_CORE:
    ,.sfi_rx_data_crd_rtn_fc_id             (sfi_rx_data_crd_rtn_fc_id)         //O: SFI_CORE:
    ,.sfi_rx_data_crd_rtn_value             (sfi_rx_data_crd_rtn_value)         //O: SFI_CORE:

    ,.sfi_rx_data_crd_rtn_block             (sfi_rx_data_crd_rtn_block)         //I: SFI_CORE:

    ,.agent_tx_v                            (agent_tx_v)                        //I: SFI_CORE:
    ,.agent_tx_vc                           (agent_tx_vc)                       //I: SFI_CORE:
    ,.agent_tx_fc                           (agent_tx_fc)                       //I: SFI_CORE:
    ,.agent_tx_hdr_size                     (agent_tx_hdr_size)                 //I: SFI_CORE:
    ,.agent_tx_hdr_has_data                 (agent_tx_hdr_has_data)             //I: SFI_CORE:
    ,.agent_tx_hdr                          (agent_tx_hdr)                      //I: SFI_CORE:
    ,.agent_tx_hdr_par                      (agent_tx_hdr_par)                  //I: SFI_CORE:
    ,.agent_tx_data                         (agent_tx_data)                     //I: SFI_CORE:
    ,.agent_tx_data_par                     (agent_tx_data_par)                 //I: SFI_CORE:

    ,.agent_tx_ack                          (agent_tx_ack)                      //O: SFI_CORE:

    ,.tx_hcrds_avail                        (tx_hcrds_avail)                    //O: SFI_CORE:
    ,.tx_dcrds_avail                        (tx_dcrds_avail)                    //O: SFI_CORE:

    ,.tx_hcrd_consume_v                     (tx_hcrd_consume_v)                 //I: SFI_CORE: Target hdr  credit consume
    ,.tx_hcrd_consume_vc                    (tx_hcrd_consume_vc)                //I: SFI_CORE:
    ,.tx_hcrd_consume_fc                    (tx_hcrd_consume_fc)                //I: SFI_CORE:
    ,.tx_hcrd_consume_val                   (tx_hcrd_consume_val)               //I: SFI_CORE:

    ,.tx_dcrd_consume_v                     (tx_dcrd_consume_v)                 //I: SFI_CORE: Target data credit consume
    ,.tx_dcrd_consume_vc                    (tx_dcrd_consume_vc)                //I: SFI_CORE:
    ,.tx_dcrd_consume_fc                    (tx_dcrd_consume_fc)                //I: SFI_CORE:
    ,.tx_dcrd_consume_val                   (tx_dcrd_consume_val)               //I: SFI_CORE:

    ,.lli_phdr_val                          (lli_phdr_val)                      //O: SFI_CORE:
    ,.lli_phdr                              (lli_phdr)                          //O: SFI_CORE:

    ,.lli_nphdr_val                         (lli_nphdr_val)                     //O: SFI_CORE:
    ,.lli_nphdr                             (lli_nphdr)                         //O: SFI_CORE:

    ,.lli_pdata_push                        (lli_pdata_push)                    //O: SFI_CORE:
    ,.lli_npdata_push                       (lli_npdata_push)                   //O: SFI_CORE:
    ,.lli_pkt_data                          (lli_pkt_data)                      //O: SFI_CORE:
    ,.lli_pkt_data_par                      (lli_pkt_data_par)                  //O: SFI_CORE:

    ,.ibcpl_hdr_push                        (ibcpl_hdr_push)                    //O: SFI_CORE:
    ,.ibcpl_hdr                             (ibcpl_hdr)                         //O: SFI_CORE:

    ,.ibcpl_data_push                       (ibcpl_data_push)                   //O: SFI_CORE:
    ,.ibcpl_data                            (ibcpl_data)                        //O: SFI_CORE:
    ,.ibcpl_data_par                        (ibcpl_data_par)                    //O: SFI_CORE:

    ,.ri_tgt_crd_inc                        (ri_tgt_crd_inc)                    //I: SFI_CORE:

    ,.agent_rxqs_empty                      (agent_rxqs_empty)                  //I: SFI_CORE:

    ,.iosf_ep_cpar_err                      (iosf_ep_cpar_err)                  //O: SFI_CORE:
    ,.iosf_ep_chdr_w_err                    (iosf_ep_chdr_w_err)                //O: SFI_CORE:

    ,.fscan_clkungate                       (fscan_clkungate)                   //I: SFI_CORE:
    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: SFI_CORE:
    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: SFI_CORE:

    ,.prim_jta_force_clkreq                 (prim_jta_force_clkreq)             //I: SFI_CORE:
    ,.prim_jta_force_creditreq              (prim_jta_force_creditreq)          //I: SFI_CORE:
    ,.prim_jta_force_idle                   (prim_jta_force_idle)               //I: SFI_CORE:
    ,.prim_jta_force_notidle                (prim_jta_force_notidle)            //I: SFI_CORE:
                                                                                  
    ,.cdc_prim_jta_clkgate_ovrd             (cdc_prim_jta_clkgate_ovrd)         //I: SFI_CORE:
    ,.cdc_prim_jta_force_clkreq             (cdc_prim_jta_force_clkreq)         //I: SFI_CORE:
);

always_comb begin

 prim_clkreq_sync               = agent_clkreq;

 prim_clkreq_async[1]           = prim_clkreq_async_sbe;
 prim_clkreq_async[0]           = agent_clkreq_async;

 prim_clkack_async_sbe          = prim_clkack_async[1];

 agent_rxqs_empty               = tlq_idle;

 // TBD: Faking out the ri_pm FLR and PS completion logic here...
 //      Setting the tag and reqid to all ones when not valid, otherwise passing values

 gnt                            = '1;
 gnt_rtype                      = 2'd2;

 // Swap bytes within the header DWs

 for (int i=0; i<HQM_SFI_TX_H; i=i+4) begin
  sfi_tx_header_rev[((i*8)+ 0) +: 8] = sfi_tx_header[((i*8)+24) +: 8];
  sfi_tx_header_rev[((i*8)+ 8) +: 8] = sfi_tx_header[((i*8)+16) +: 8];
  sfi_tx_header_rev[((i*8)+16) +: 8] = sfi_tx_header[((i*8)+ 8) +: 8];
  sfi_tx_header_rev[((i*8)+24) +: 8] = sfi_tx_header[((i*8)+ 0) +: 8];
 end

 mrsvd1_7                       = sfi_tx_header_rev.cpl.tag[9]   |     (~sfi_tx_hdr_valid);
 mrsvd1_3                       = sfi_tx_header_rev.cpl.tag[8]   |     (~sfi_tx_hdr_valid);
 mtag                           = sfi_tx_header_rev.cpl.tag[7:0] | { 8{(~sfi_tx_hdr_valid)}};
 mrqid                          = sfi_tx_header_rev.cpl.bdf      | {16{(~sfi_tx_hdr_valid)}};

 // These legacy IOSF inputs to the RI need to be driven

 mstr_db_status_in_stalled      = '0;
 mstr_db_status_in_taken        = '0;
 mstr_db_status_out_stalled     = '0;

 iosf_ep_tecrc_err              = '0;

 tgt_init_hcredits              = '0;
 tgt_init_dcredits              = '0;
 tgt_rem_hcredits               = '0;
 tgt_rem_dcredits               = '0;
 tgt_ret_hcredits               = '0;
 tgt_ret_dcredits               = '0;

 cfg_p_rl_cq_fifo_status        = '0;

 cmd_put                        = '0;
 cmd_rtype                      = '0;

 credit_cmd                     = '0;
 credit_data                    = '0;
 credit_put                     = '0;
 credit_rtype                   = '0;

 gnt_type                       = '0;

 mfmt                           = '0;
 mtype                          = '0;
 mlength                        = '0;

 req_put                        = '0;
 req_rtype                      = '0;
 req_dlen                       = '0;

 tfmt                           = '0;
 ttype                          = '0;
 tlength                        = '0;

 strap_hqm_completertenbittagen = '0;

end

//TBD: Adjust visa signals

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

hqm_sif_probes i_hqm_sif_probes (

     .clk                   (prim_freerun_clk)                                      //I: VISA
    ,.hqm_sif_visa_in       ({
                              1'b0                                                  //I: VISA 679
                             ,flr_triggered_wl[6]                                   //I: VISA 678
                             ,flr_clk_enable                                        //I: VISA 677
                             ,flr_clk_enable_system                                 //I: VISA 676
                             ,prim_clk_enable_cdc                                   //I: VISA 675
                             ,flr_triggered                                         //I: VISA 674
                             ,flr_visa_ri                                           //I: VISA 673:660

                             ,cfg_visa_sw_control.SW_TRIGGER                        //I: VISA 659
                             ,prim_gated_rst_b_synced                               //I: VISA 658
                             ,prim_clk_enable                                       //I: VISA 657
                             ,prim_clk_enable_sys                                   //I: VISA 656

                             ,1'b0                                                  //I: VISA 655
                             ,1'b0                                                  //I: VISA 654
                             ,hqm_idle                                              //I: VISA 653
                             ,sif_idle_status_reg.MSTR_IDLE                         //I: VISA 652
                             ,sif_idle_status_reg.MSTR_INTF_IDLE                    //I: VISA 651
                             ,sif_idle_status_reg.TGT_IDLE                          //I: VISA 650
                             ,sif_idle_status_reg.RI_IDLE                           //I: VISA 649
                             ,sif_idle_status_reg.CFGM_IDLE                         //I: VISA 648

                             ,32'd0                                                 //I: VISA 647:616
                             ,noa_mstr                                              //I: VISA 615:424
                             ,noa_ri                                                //I: VISA 423:167
                             ,167'd0                                                //I: VISA 166:0
                            })
    ,.hqm_sif_visa_out      (hqm_sif_visa)                                          //O: VISA
);

always_comb begin

 cfg_ph_trigger_enable = cfg_visa_sw_control.PH_TRIGGER_ENABLE;

 cpl_error = cpl_usr | cpl_abort;

 mstr_fifo_overflow  = |{cfg_ibcpl_data_fifo_status.OVRFLOW
                        ,cfg_ibcpl_hdr_fifo_status.OVRFLOW
 };

 mstr_fifo_underflow = |{cfg_ibcpl_data_fifo_status.UNDFLOW
                        ,cfg_ibcpl_hdr_fifo_status.UNDFLOW
 };

 mstr_fifo_afull     = {1'b0
                       ,cfg_ibcpl_data_fifo_status.AFULL
                       ,cfg_ibcpl_hdr_fifo_status.AFULL
 };

 sif_db_status                = '0;
 sif_db_status.ALARM_DB_READY = int_serial_status[9];
 sif_db_status.ALARM_DB_DEPTH = int_serial_status[8:7];

 write_buffer_mstr_v_qual     = write_buffer_mstr_v & ~mask_posted;

 tgt_idle            = sfi_rx_idle & tlq_idle;
 mstr_idle           = sfi_tx_idle & ti_idle;
 mstr_intf_idle      = sfi_tx_idle & ti_intf_idle;

 // TBD: Revisit triggers

 hqm_triggers        = {cfg_visa_sw_control.SW_TRIGGER  // 9
                       ,ph_trigger                      // 8
                       ,hqm_idle                        // 7
                       ,prim_gated_rst_b_synced         // 6
                       ,prim_rst_b_synced               // 5
                       ,prim_clk_enable                 // 4
                       ,1'b0                            // 3
                       ,1'b0                            // 2
                       ,1'b0                            // 1
                       ,1'b0                            // 0

 } & ~{10{cfg_visa_sw_control.TRIGGER_MASK}};

end

hqm_AW_unused_bits i_unused (

     .a     (|{int_serial_status[31:14]
              ,int_serial_status[12]
              ,int_serial_status[6:0]
              ,iosfp_cgctl
            // May need to use some of these for the clock gating logic when coded
              ,force_ip_inaccessible
              ,force_warm_reset
              ,agent_idle
              ,prim_clkack_async[0]
            })
);

`else

hqm_iosfp_core #(

    // iosf tgt

     .TCRD_BYPASS                           (HQMIOSF_TCRD_BYPASS)
    ,.TGT_TX_PRH                            (HQMIOSF_TGT_TX_PRH)
    ,.TGT_TX_NPRH                           (HQMIOSF_TGT_TX_NPRH)
    ,.TGT_TX_CPLH                           (HQMIOSF_TGT_TX_CPLH)
    ,.TGT_TX_PRD                            (HQMIOSF_TGT_TX_PRD)
    ,.TGT_TX_NPRD                           (HQMIOSF_TGT_TX_NPRD)
    ,.TGT_TX_CPLD                           (HQMIOSF_TGT_TX_CPLD)

    // iosf common

    ,.PORTS                                 (HQMIOSF_PORTS)
    ,.VC                                    (HQMIOSF_VC)
    ,.MNUMCHANL2                            (HQMIOSF_MNUMCHANL2)
    ,.TNUMCHANL2                            (HQMIOSF_TNUMCHANL2)
    ,.MAX_PAYLOAD                           (HQMIOSF_MSTR_MAX_PAYLOAD)

) i_hqm_iosfp_core (

    // Inputs

     .agent_clkreq                          (agent_clkreq)                      //I: IOSFP
    ,.agent_clkreq_async                    (agent_clkreq_async)                //I: IOSFP
    ,.agent_idle                            (agent_idle)                        //I: IOSFP
    ,.cdc_prim_jta_clkgate_ovrd             (cdc_prim_jta_clkgate_ovrd)         //I: IOSFP
    ,.cdc_prim_jta_force_clkreq             (cdc_prim_jta_force_clkreq)         //I: IOSFP
    ,.cfg_ats_enabled                       (cfg_ats_enabled)                   //I: IOSFP
    ,.cfg_devtlb_ctl                        (cfg_devtlb_ctl)                    //I: IOSFP
    ,.cfg_devtlb_defeature0                 (cfg_devtlb_defeature0)             //I: IOSFP
    ,.cfg_devtlb_defeature1                 (cfg_devtlb_defeature1)             //I: IOSFP
    ,.cfg_devtlb_defeature2                 (cfg_devtlb_defeature2)             //I: IOSFP
    ,.cfg_devtlb_spare                      (cfg_devtlb_spare)                  //I: IOSFP
    ,.cfg_ibcpl_hdr_fifo_ctl                (cfg_ibcpl_hdr_fifo_ctl)            //I: IOSFP
    ,.cfg_ibcpl_data_fifo_ctl               (cfg_ibcpl_data_fifo_ctl)           //I: IOSFP
    ,.cfg_mstr_ll_ctl                       (cfg_mstr_ll_ctl)                   //I: IOSFP
    ,.cfg_parity_ctl                        (cfg_parity_ctl)                    //I: IOSFP
    ,.cfg_ph_trigger_addr                   (cfg_ph_trigger_addr)               //I: IOSFP
    ,.cfg_ph_trigger_mask                   (cfg_ph_trigger_mask)               //I: IOSFP
    ,.cfg_prim_cdc_ctl                      (cfg_prim_cdc_ctl)                  //I: IOSFP
    ,.cfg_scrbd_ctl                         (cfg_scrbd_ctl)                     //I: IOSFP
    ,.cfg_visa_sw_control                   (cfg_visa_sw_control)               //I: IOSFP
    ,.cmd_nfs_err                           (cmd_nfs_err)                       //I: IOSFP
    ,.cmd_put                               (cmd_put)                           //I: IOSFP
    ,.cmd_rtype                             (cmd_rtype)                         //I: IOSFP
    ,.csr_ppdcntl_ero                       (csr_ppdcntl_ero)                   //I: IOSFP
    ,.current_bus                           (current_bus)                       //I: IOSFP
    ,.dir_cq2tc_map                         (dir_cq2tc_map)                     //I: IOSFP
    ,.flr_clk_enable                        (flr_clk_enable)                    //I: IOSFP
    ,.flr_clk_enable_system                 (flr_clk_enable_system)             //I: IOSFP
    ,.flr_treatment                         (flr_treatment)                     //I: IOSFP
    ,.flr_treatment_vec                     (flr_treatment_vec)                 //I: IOSFP
    ,.flr_triggered_wl                      (flr_triggered_wl[6])               //I: IOSFP
    ,.flr_txn_reqid                         (flr_txn_reqid)                     //I: IOSFP
    ,.flr_txn_sent                          (flr_txn_sent)                      //I: IOSFP
    ,.flr_txn_tag                           (flr_txn_tag)                       //I: IOSFP
    ,.flr_visa_ri                           (flr_visa_ri)                       //I: IOSFP
    ,.force_ip_inaccessible                 (force_ip_inaccessible)             //I: IOSFP
    ,.force_pm_state_d3hot                  (force_pm_state_d3hot)              //I: IOSFP
    ,.force_warm_reset                      (force_warm_reset)                  //I: IOSFP
    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: IOSFP
    ,.fscan_clkungate                       (fscan_clkungate)                   //I: IOSFP
    ,.fscan_clkungate_syn                   (fscan_clkungate_syn)               //I: IOSFP
    ,.fscan_latchclosed_b                   (fscan_latchclosed_b)               //I: IOSFP
    ,.fscan_latchopen                       (fscan_latchopen)                   //I: IOSFP
    ,.fscan_mode                            (fscan_mode)                        //I: IOSFP
    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: IOSFP
    ,.fscan_shiften                         (fscan_shiften)                     //I: IOSFP
    ,.func_in_rst                           (func_in_rst)                       //I: IOSFP
    ,.fuse_proc_disable                     (sb_ep_fuses.proc_disable)          //I: IOSFP
    ,.gnt                                   (gnt)                               //I: IOSFP
    ,.gnt_rtype                             (gnt_rtype)                         //I: IOSFP
    ,.gnt_type                              (gnt_type)                          //I: IOSFP
    ,.gpsb_upd_enables                      (gpsb_upd_enables)                  //I: IOSFP
    ,.hqm_csr_pf0_rst_n                     (hqm_csr_pf0_rst_n)                 //I: IOSFP
    ,.hqm_flr_prep                          (hqm_flr_prep)                      //I: IOSFP
    ,.hqm_idle                              (hqm_idle)                          //I: IOSFP
    ,.hqm_sif_cnt_ctl                       (hqm_sif_cnt_ctl)                   //I: IOSFP
    ,.int_serial_status                     (int_serial_status)                 //I: IOSFP
    ,.int2tc_map                            (int2tc_map)                        //I: IOSFP
    ,.sif_idle_status_reg                   (sif_idle_status_reg)               //I: IOSFP
    ,.iosfp_cgctl                           (iosfp_cgctl)                       //I: IOSFP
    ,.ldb_cq2tc_map                         (ldb_cq2tc_map)                     //I: IOSFP
    ,.mask_posted                           (mask_posted)                       //I: IOSFP
    ,.noa_ri                                (noa_ri)                            //I: IOSFP
    ,.obcpl_v                               (obcpl_v)                           //I: IOSFP
    ,.obcpl_hdr                             (obcpl_hdr)                         //I: IOSFP
    ,.obcpl_data                            (obcpl_data)                        //I: IOSFP
    ,.obcpl_dpar                            (obcpl_dpar)                        //I: IOSFP
    ,.obcpl_enables                         (obcpl_enables)                     //I: IOSFP
    ,.pgcb_clk                              (pgcb_clk)                          //I: IOSFP
    ,.pm_fsm_d0tod3_ok                      (pm_fsm_d0tod3_ok)                  //I: IOSFP
    ,.pm_fsm_d3tod0_ok                      (pm_fsm_d3tod0_ok)                  //I: IOSFP
    ,.pma_safemode                          (pma_safemode)                      //I: IOSFP
    ,.prim_clkack                           (prim_clkack)                       //I: IOSFP
    ,.prim_clkreq_async_sbe                 (prim_clkreq_async_sbe)             //I: IOSFP
    ,.prim_freerun_clk                      (prim_freerun_clk)                  //I: IOSFP
    ,.prim_gated_clk                        (prim_gated_clk)                    //I: IOSFP
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: IOSFP
    ,.prim_gated_wflr_rst_b_primary         (prim_gated_wflr_rst_b_primary)     //I: IOSFP
    ,.prim_ism_fabric                       (prim_ism_fabric)                   //I: IOSFP
    ,.prim_jta_force_clkreq                 (prim_jta_force_clkreq)             //I: IOSFP
    ,.prim_jta_force_creditreq              (prim_jta_force_creditreq)          //I: IOSFP
    ,.prim_jta_force_idle                   (prim_jta_force_idle)               //I: IOSFP
    ,.prim_jta_force_notidle                (prim_jta_force_notidle)            //I: IOSFP
    ,.prim_nonflr_clk                       (prim_nonflr_clk)                   //I: IOSFP
    ,.prim_rst_b                            (prim_rst_b)                        //I: IOSFP
    ,.prim_pwrgate_pmc_wake                 (prim_pwrgate_pmc_wake)             //I: IOSFP
    ,.ps_txn_reqid                          (ps_txn_reqid)                      //I: IOSFP
    ,.ps_txn_sent                           (ps_txn_sent)                       //I: IOSFP
    ,.ps_txn_tag                            (ps_txn_tag)                        //I: IOSFP
    ,.sif_mstr_quiesce_req                  (sif_mstr_quiesce_req)              //I: IOSFP
    ,.ri_tgt_crd_inc                        (ri_tgt_crd_inc)                    //I: IOSFP
    ,.rx_msg_v                              (rx_msg_v)                          //I: IOSFP
    ,.rx_msg                                (rx_msg)                            //I: IOSFP
    ,.side_rst_b                            (side_rst_b)                        //I: IOSFP
    ,.strap_hqm_cmpl_sai                    (strap_hqm_cmpl_sai)                //I: IOSFP
    ,.strap_hqm_completertenbittagen        (strap_hqm_completertenbittagen)    //I: IOSFP
    ,.strap_hqm_tx_sai                      (strap_hqm_tx_sai)                  //I: IOSFP
    ,.taddress                              (taddress)                          //I: IOSFP
    ,.tat                                   (tat)                               //I: IOSFP
    ,.tchain                                (tchain)                            //I: IOSFP
    ,.tcparity                              (tcparity)                          //I: IOSFP
    ,.tdata                                 (tdata)                             //I: IOSFP
    ,.tdec                                  (tdec)                              //I: IOSFP
    ,.tdest_id                              (tdest_id)                          //I: IOSFP
    ,.tdparity                              (tdparity)                          //I: IOSFP
    ,.tecrc                                 (tecrc)                             //I: IOSFP
    ,.tep                                   (tep)                               //I: IOSFP
    ,.tfbe                                  (tfbe)                              //I: IOSFP
    ,.tfmt                                  (tfmt)                              //I: IOSFP
    ,.tido                                  (tido)                              //I: IOSFP
    ,.tlbe                                  (tlbe)                              //I: IOSFP
    ,.tlength                               (tlength)                           //I: IOSFP
    ,.tns                                   (tns)                               //I: IOSFP
    ,.tpasidtlp                             (tpasidtlp)                         //I: IOSFP
    ,.tro                                   (tro)                               //I: IOSFP
    ,.trqid                                 (trqid)                             //I: IOSFP
    ,.trs                                   (trs)                               //I: IOSFP
    ,.trsvd1_3                              (trsvd1_3)                          //I: IOSFP
    ,.trsvd1_7                              (trsvd1_7)                          //I: IOSFP
    ,.tsai                                  (tsai)                              //I: IOSFP
    ,.tsrc_id                               (tsrc_id)                           //I: IOSFP
    ,.ttag                                  (ttag)                              //I: IOSFP
    ,.ttc                                   (ttc)                               //I: IOSFP
    ,.ttd                                   (ttd)                               //I: IOSFP
    ,.tth                                   (tth)                               //I: IOSFP
    ,.ttype                                 (ttype)                             //I: IOSFP
    ,.write_buffer_mstr_v                   (write_buffer_mstr_v)               //I: IOSFP
    ,.write_buffer_mstr                     (write_buffer_mstr)                 //I: IOSFP

    // Outputs

    ,.cfg_ibcpl_hdr_fifo_status             (cfg_ibcpl_hdr_fifo_status)         //O: IOSFP
    ,.cfg_ibcpl_data_fifo_status            (cfg_ibcpl_data_fifo_status)        //O: IOSFP
    ,.cfg_p_rl_cq_fifo_status               (cfg_p_rl_cq_fifo_status)           //O: IOSFP
    ,.cpl_abort                             (cpl_abort)                         //O: IOSFP
    ,.cpl_error                             (cpl_error)                         //O: IOSFP
    ,.cpl_error_hdr                         (cpl_error_hdr)                     //O: IOSFP
    ,.cpl_poisoned                          (cpl_poisoned)                      //O: IOSFP
    ,.cpl_timeout                           (cpl_timeout)                       //O: IOSFP
    ,.cpl_timeout_synd                      (cpl_timeout_synd)                  //O: IOSFP
    ,.cpl_unexpected                        (cpl_unexpected)                    //O: IOSFP
    ,.cpl_usr                               (cpl_usr)                           //O: IOSFP
    ,.credit_cmd                            (credit_cmd)                        //O: IOSFP
    ,.credit_data                           (credit_data)                       //O: IOSFP
    ,.credit_put                            (credit_put)                        //O: IOSFP
    ,.credit_rtype                          (credit_rtype)                      //O: IOSFP
    ,.devtlb_status                         (devtlb_status)                     //O: IOSFP
    ,.flr_triggered                         (flr_triggered)                     //O: IOSFP
    ,.hit                                   (hit)                               //O: IOSFP
    ,.hqm_sif_visa                          (hqm_sif_visa)                      //O: IOSFP
    ,.hqm_triggers                          (hqm_triggers)                      //O: IOSFP
    ,.sif_db_status                         (sif_db_status)                     //O: IOSFP
    ,.iosf_ep_cpar_err                      (iosf_ep_cpar_err)                  //O: IOSFP
    ,.iosf_ep_tecrc_err                     (iosf_ep_tecrc_err)                 //O: IOSFP
    ,.iosf_ep_chdr_w_err                    (iosf_ep_chdr_w_err)                //O: IOSFP
    ,.sif_parity_alarm                      (sif_parity_alarm)                  //O: IOSFP
    ,.sif_mstr_debug                        (sif_mstr_debug)                    //O: IOSFP
    ,.sif_mstr_quiesce_ack                  (sif_mstr_quiesce_ack)              //O: IOSFP
    ,.lli_phdr_val                          (lli_phdr_val)                      //O: IOSFP
    ,.lli_phdr                              (lli_phdr)                          //O: IOSFP
    ,.lli_nphdr_val                         (lli_nphdr_val)                     //O: IOSFP
    ,.lli_nphdr                             (lli_nphdr)                         //O: IOSFP
    ,.lli_pdata_push                        (lli_pdata_push)                    //O: IOSFP
    ,.lli_npdata_push                       (lli_npdata_push)                   //O: IOSFP
    ,.lli_pkt_data                          (lli_pkt_data)                      //O: IOSFP
    ,.lli_pkt_data_par                      (lli_pkt_data_par)                  //O: IOSFP
    ,.local_bme_status                      (local_bme_status)                  //O: IOSFP
    ,.local_msixe_status                    (local_msixe_status)                //O: IOSFP
    ,.maddress                              (maddress)                          //O: IOSFP
    ,.mat                                   (mat)                               //O: IOSFP
    ,.mcparity                              (mcparity)                          //O: IOSFP
    ,.mdata                                 (mdata)                             //O: IOSFP
    ,.mdest_id                              (mdest_id)                          //O: IOSFP
    ,.mdparity                              (mdparity)                          //O: IOSFP
    ,.mecrc                                 (mecrc)                             //O: IOSFP
    ,.mep                                   (mep)                               //O: IOSFP
    ,.mfbe                                  (mfbe)                              //O: IOSFP
    ,.mfmt                                  (mfmt)                              //O: IOSFP
    ,.mido                                  (mido)                              //O: IOSFP
    ,.mlbe                                  (mlbe)                              //O: IOSFP
    ,.mlength                               (mlength)                           //O: IOSFP
    ,.mns                                   (mns)                               //O: IOSFP
    ,.mpasidtlp                             (mpasidtlp)                         //O: IOSFP
    ,.mro                                   (mro)                               //O: IOSFP
    ,.mrqid                                 (mrqid)                             //O: IOSFP
    ,.mrs                                   (mrs)                               //O: IOSFP
    ,.mrsvd1_3                              (mrsvd1_3)                          //O: IOSFP
    ,.mrsvd1_7                              (mrsvd1_7)                          //O: IOSFP
    ,.msai                                  (msai)                              //O: IOSFP
    ,.msrc_id                               (msrc_id)                           //O: IOSFP
    ,.mstr_cnts                             (mstr_cnts)                         //O: IOSFP
    ,.mstr_crd_status                       (mstr_crd_status)                   //O: IOSFP
    ,.mstr_db_status_in_stalled             (mstr_db_status_in_stalled)         //O: IOSFP
    ,.mstr_db_status_in_taken               (mstr_db_status_in_taken)           //O: IOSFP
    ,.mstr_db_status_out_stalled            (mstr_db_status_out_stalled)        //O: IOSFP
    ,.mstr_fifo_afull                       (mstr_fifo_afull)                   //O: IOSFP
    ,.mstr_fifo_overflow                    (mstr_fifo_overflow)                //O: IOSFP
    ,.mstr_fifo_underflow                   (mstr_fifo_underflow)               //O: IOSFP
    ,.mstr_fl_status                        (mstr_fl_status)                    //O: IOSFP
    ,.mstr_idle                             (mstr_idle)                         //O: IOSFP
    ,.mstr_intf_idle                        (mstr_intf_idle)                    //O: IOSFP
    ,.mstr_ll_status                        (mstr_ll_status)                    //O: IOSFP
    ,.mtag                                  (mtag)                              //O: IOSFP
    ,.mtc                                   (mtc)                               //O: IOSFP
    ,.mtd                                   (mtd)                               //O: IOSFP
    ,.mth                                   (mth)                               //O: IOSFP
    ,.mtype                                 (mtype)                             //O: IOSFP
    ,.np_trans_pending                      (np_trans_pending)                  //O: IOSFP
    ,.obcpl_ready                           (obcpl_ready)                       //O: IOSFP
    ,.poisoned_wr_sent                      (poisoned_wr_sent)                  //O: IOSFP
    ,.prim_clk_enable                       (prim_clk_enable)                   //O: IOSFP
    ,.prim_clk_enable_cdc                   (prim_clk_enable_cdc)               //O: IOSFP
    ,.prim_clk_enable_sys                   (prim_clk_enable_sys)               //O: IOSFP
    ,.prim_clk_ungate                       (prim_clk_ungate)                   //O: IOSFP
    ,.prim_clkack_async_sbe                 (prim_clkack_async_sbe)             //O: IOSFP
    ,.prim_clkreq                           (prim_clkreq)                       //O: IOSFP
    ,.prim_ism_agent                        (prim_ism_agent)                    //O: IOSFP
    ,.prim_pok                              (prim_pok)                          //O: IOSFP
    ,.req_agent                             (req_agent)                         //O: IOSFP
    ,.req_cdata                             (req_cdata)                         //O: IOSFP
    ,.req_chain                             (req_chain)                         //O: IOSFP
    ,.req_dest_id                           (req_dest_id)                       //O: IOSFP
    ,.req_dlen                              (req_dlen)                          //O: IOSFP
    ,.req_id                                (req_id)                            //O: IOSFP
    ,.req_ido                               (req_ido)                           //O: IOSFP
    ,.req_locked                            (req_locked)                        //O: IOSFP
    ,.req_ns                                (req_ns)                            //O: IOSFP
    ,.req_opp                               (req_opp)                           //O: IOSFP
    ,.req_put                               (req_put)                           //O: IOSFP
    ,.req_ro                                (req_ro)                            //O: IOSFP
    ,.req_rs                                (req_rs)                            //O: IOSFP
    ,.req_rtype                             (req_rtype)                         //O: IOSFP
    ,.req_tc                                (req_tc)                            //O: IOSFP
    ,.set_sif_parity_err_mstr               (set_sif_parity_err_mstr)           //O: IOSFP
    ,.side_gated_rst_prim_b                 (side_gated_rst_prim_b)             //O: IOSFP
    ,.sub_hit                               (sub_hit)                           //O: IOSFP
    ,.tgt_idle                              (tgt_idle)                          //O: IOSFP
    ,.tgt_init_hcredits                     (tgt_init_hcredits)                 //O: ISOFP
    ,.tgt_init_dcredits                     (tgt_init_dcredits)                 //O: ISOFP
    ,.tgt_rem_hcredits                      (tgt_rem_hcredits)                  //O: ISOFP
    ,.tgt_rem_dcredits                      (tgt_rem_dcredits)                  //O: ISOFP
    ,.tgt_ret_hcredits                      (tgt_ret_hcredits)                  //O: ISOFP
    ,.tgt_ret_dcredits                      (tgt_ret_dcredits)                  //O: ISOFP
    ,.devtlb_ats_alarm                      (devtlb_ats_alarm)                  //O: IOSFP
    ,.scrbd_status                          (scrbd_status)                      //O: IOSFP
    ,.set_devtlb_ats_err                    (set_devtlb_ats_err)                //O: IOSFP
    ,.write_buffer_mstr_ready               (write_buffer_mstr_ready)           //O: IOSFP

    ,.memi_scrbd_mem                        (memi_scrbd_mem)                    //O: IOSFP
    ,.memo_scrbd_mem                        (memo_scrbd_mem)                    //I: IOSFP
    ,.memi_ibcpl_hdr_fifo                   (memi_ibcpl_hdr_fifo)               //O: IOSFP
    ,.memo_ibcpl_hdr_fifo                   (memo_ibcpl_hdr_fifo)               //I: IOSFP
    ,.memi_ibcpl_data_fifo                  (memi_ibcpl_data_fifo)              //O: IOSFP
    ,.memo_ibcpl_data_fifo                  (memo_ibcpl_data_fifo)              //I: IOSFP
    ,.memi_mstr_ll_hpa                      (memi_mstr_ll_hpa)                  //O: IOSFP
    ,.memo_mstr_ll_hpa                      (memo_mstr_ll_hpa)                  //I: IOSFP
    ,.memi_mstr_ll_hdr                      (memi_mstr_ll_hdr)                  //O: IOSFP
    ,.memo_mstr_ll_hdr                      (memo_mstr_ll_hdr)                  //I: IOSFP
    ,.memi_mstr_ll_data0                    (memi_mstr_ll_data0)                //O: IOSFP
    ,.memo_mstr_ll_data0                    (memo_mstr_ll_data0)                //I: IOSFP
    ,.memi_mstr_ll_data1                    (memi_mstr_ll_data1)                //O: IOSFP
    ,.memo_mstr_ll_data1                    (memo_mstr_ll_data1)                //I: IOSFP
    ,.memi_mstr_ll_data2                    (memi_mstr_ll_data2)                //O: IOSFP
    ,.memo_mstr_ll_data2                    (memo_mstr_ll_data2)                //I: IOSFP
    ,.memi_mstr_ll_data3                    (memi_mstr_ll_data3)                //O: IOSFP
    ,.memo_mstr_ll_data3                    (memo_mstr_ll_data3)                //I: IOSFP

    ,.memi_tlb_tag0_4k                      (memi_tlb_tag0_4k)                  //O: IOSFP
    ,.memo_tlb_tag0_4k                      (memo_tlb_tag0_4k)                  //I: IOSFP
    ,.memi_tlb_tag1_4k                      (memi_tlb_tag1_4k)                  //O: IOSFP
    ,.memo_tlb_tag1_4k                      (memo_tlb_tag1_4k)                  //I: IOSFP
    ,.memi_tlb_tag2_4k                      (memi_tlb_tag2_4k)                  //O: IOSFP
    ,.memo_tlb_tag2_4k                      (memo_tlb_tag2_4k)                  //I: IOSFP
    ,.memi_tlb_tag3_4k                      (memi_tlb_tag3_4k)                  //O: IOSFP
    ,.memo_tlb_tag3_4k                      (memo_tlb_tag3_4k)                  //I: IOSFP
    ,.memi_tlb_tag4_4k                      (memi_tlb_tag4_4k)                  //O: IOSFP
    ,.memo_tlb_tag4_4k                      (memo_tlb_tag4_4k)                  //I: IOSFP
    ,.memi_tlb_tag5_4k                      (memi_tlb_tag5_4k)                  //O: IOSFP
    ,.memo_tlb_tag5_4k                      (memo_tlb_tag5_4k)                  //I: IOSFP
    ,.memi_tlb_tag6_4k                      (memi_tlb_tag6_4k)                  //O: IOSFP
    ,.memo_tlb_tag6_4k                      (memo_tlb_tag6_4k)                  //I: IOSFP
    ,.memi_tlb_tag7_4k                      (memi_tlb_tag7_4k)                  //O: IOSFP
    ,.memo_tlb_tag7_4k                      (memo_tlb_tag7_4k)                  //I: IOSFP

    ,.memi_tlb_data0_4k                     (memi_tlb_data0_4k)                 //O: IOSFP
    ,.memo_tlb_data0_4k                     (memo_tlb_data0_4k)                 //I: IOSFP
    ,.memi_tlb_data1_4k                     (memi_tlb_data1_4k)                 //O: IOSFP
    ,.memo_tlb_data1_4k                     (memo_tlb_data1_4k)                 //I: IOSFP
    ,.memi_tlb_data2_4k                     (memi_tlb_data2_4k)                 //O: IOSFP
    ,.memo_tlb_data2_4k                     (memo_tlb_data2_4k)                 //I: IOSFP
    ,.memi_tlb_data3_4k                     (memi_tlb_data3_4k)                 //O: IOSFP
    ,.memo_tlb_data3_4k                     (memo_tlb_data3_4k)                 //I: IOSFP
    ,.memi_tlb_data4_4k                     (memi_tlb_data4_4k)                 //O: IOSFP
    ,.memo_tlb_data4_4k                     (memo_tlb_data4_4k)                 //I: IOSFP
    ,.memi_tlb_data5_4k                     (memi_tlb_data5_4k)                 //O: IOSFP
    ,.memo_tlb_data5_4k                     (memo_tlb_data5_4k)                 //I: IOSFP
    ,.memi_tlb_data6_4k                     (memi_tlb_data6_4k)                 //O: IOSFP
    ,.memo_tlb_data6_4k                     (memo_tlb_data6_4k)                 //I: IOSFP
    ,.memi_tlb_data7_4k                     (memi_tlb_data7_4k)                 //O: IOSFP
    ,.memo_tlb_data7_4k                     (memo_tlb_data7_4k)                 //I: IOSFP
);

`endif

hqm_iosfsb_core #(

     .RX_EXT_HEADER_SUPPORT                 (HQMIOSF_RX_EXT_HEADER_SUPPORT)
    ,.TX_EXT_HEADER_SUPPORT                 (HQMIOSF_TX_EXT_HEADER_SUPPORT)
    ,.NUM_TX_EXT_HEADERS                    (HQMIOSF_NUM_TX_EXT_HEADERS)
    ,.TX_EXT_HEADER_IDS                     (HQMIOSF_TX_EXT_HEADER_IDS)
    ,.NUM_RX_EXT_HEADERS                    (HQMIOSF_NUM_RX_EXT_HEADERS)
    ,.RX_EXT_HEADER_IDS                     (HQMIOSF_RX_EXT_HEADER_IDS)

    // Used to qualify incoming SetIDValue and RSWARN

    ,.SAME_FREQUENCY                        (1)                      // Asynchronous endpoint= 0, 1 otherwise
    ,.MAX_TGT_ADR                           (HQMEPSB_MAX_TGT_ADR)
    ,.MAX_TGT_DAT                           (HQMEPSB_MAX_TGT_DAT)
    ,.HQM_SBE_NPQUEUEDEPTH                  (HQM_SBE_NPQUEUEDEPTH)
    ,.HQM_SBE_PCQUEUEDEPTH                  (HQM_SBE_PCQUEUEDEPTH)
    ,.HQM_SBE_DATAWIDTH                     (HQM_SBE_DATAWIDTH)
    ,.HQM_SBE_PARITY_REQUIRED               (HQM_SBE_PARITY_REQUIRED)

) i_hqm_iosfsb_core (

    // Inputs

     .cdc_side_jta_force_clkreq             (cdc_side_jta_force_clkreq)         //I: IOSFSB
    ,.cdc_side_jta_clkgate_ovrd             (cdc_side_jta_clkgate_ovrd)         //I: IOSFSB
    ,.cds_sb_cmsg                           (cds_sb_cmsg)                       //I: IOSFSB
    ,.cds_sb_rdack                          (cds_sb_rdack)                      //I: IOSFSB
    ,.cds_sb_wrack                          (cds_sb_wrack)                      //I: IOSFSB
    ,.cfg_side_cdc_ctl                      (cfg_side_cdc_ctl)                  //I: IOSFSB
    ,.cfg_visa_sw_control_wdata             (cfg_visa_sw_control_wdata)         //I: IOSFSB
    ,.cfg_visa_sw_control_write             (cfg_visa_sw_control_write)         //I: IOSFSB
    ,.early_fuses                           (early_fuses)                       //I: IOSFSB
    ,.err_gen_msg                           (err_gen_msg)                       //I: IOSFSB
    ,.err_gen_msg_data                      (err_gen_msg_data)                  //I: IOSFSB
    ,.err_gen_msg_func                      (err_gen_msg_func)                  //I: IOSFSB
    ,.fdfx_sbparity_def                     (fdfx_sbparity_def)                 //I: IOSFSB
    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: IOSFSB
    ,.fscan_clkungate                       (fscan_clkungate)                   //I: IOSFSB
    ,.fscan_clkungate_syn                   (fscan_clkungate_syn)               //I: IOSFSB
    ,.fscan_latchclosed_b                   (fscan_latchclosed_b)               //I: IOSFSB
    ,.fscan_latchopen                       (fscan_latchopen)                   //I: IOSFSB
    ,.fscan_mode                            (fscan_mode)                        //I: IOSFSB
    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: IOSFSB
    ,.fscan_shiften                         (fscan_shiften)                     //I: IOSFSB
    ,.gpsb_jta_clkgate_ovrd                 (gpsb_jta_clkgate_ovrd)             //I: IOSFSB
    ,.gpsb_jta_force_clkreq                 (gpsb_jta_force_clkreq)             //I: IOSFSB
    ,.gpsb_jta_force_creditreq              (gpsb_jta_force_creditreq)          //I: IOSFSB
    ,.gpsb_jta_force_idle                   (gpsb_jta_force_idle)               //I: IOSFSB
    ,.gpsb_jta_force_notidle                (gpsb_jta_force_notidle)            //I: IOSFSB
    ,.gpsb_mnpcup                           (gpsb_mnpcup)                       //I: IOSFSB
    ,.gpsb_mpccup                           (gpsb_mpccup)                       //I: IOSFSB
    ,.gpsb_side_ism_fabric                  (gpsb_side_ism_fabric)              //I: IOSFSB
    ,.gpsb_teom                             (gpsb_teom)                         //I: IOSFSB
    ,.gpsb_tnpput                           (gpsb_tnpput)                       //I: IOSFSB
    ,.gpsb_tparity                          (gpsb_tparity)                      //I: IOSFSB
    ,.gpsb_tpayload                         (gpsb_tpayload)                     //I: IOSFSB
    ,.gpsb_tpcput                           (gpsb_tpcput)                       //I: IOSFSB
    ,.hard_rst_np                           (hard_rst_np)                       //I: IOSFSB
    ,.hqm_csr_rac                           (hqm_csr_rac)                       //I: IOSFSB
    ,.hqm_csr_wac                           (hqm_csr_wac)                       //I: IOSFSB
    ,.side_gated_rst_prim_b                 (side_gated_rst_prim_b)             //I: IOSFSB
    ,.sif_mstr_quiesce_ack                  (sif_mstr_quiesce_ack)              //I: IOSFSB
    ,.iosfs_cgctl                           (iosfs_cgctl)                       //I: IOSFSB
    ,.pgcb_clk                              (pgcb_clk)                          //I: IOSFSB
    ,.pm_fsm_d3tod0_ok                      (pm_fsm_d3tod0_ok)                  //I: IOSFSB
    ,.pm_hqm_adr_assert                     (pm_hqm_adr_assert)                 //I: IOSFSB
    ,.pma_safemode                          (pma_safemode)                      //I: IOSFSB
    ,.prim_clkack_async_sbe                 (prim_clkack_async_sbe)             //I: IOSFSB
    ,.prim_freerun_clk                      (prim_freerun_clk)                  //I: IOSFSB
    ,.prim_gated_clk                        (prim_gated_clk)                    //I: IOSFSB
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: IOSFSB
    ,.prim_nonflr_clk                       (prim_nonflr_clk)                   //I: IOSFSB
    ,.prim_rst_b                            (prim_rst_b)                        //I: IOSFSB
    ,.side_clk                              (side_clk)                          //I: IOSFSB
    ,.side_clkack                           (side_clkack)                       //I: IOSFSB
    ,.side_pwrgate_pmc_wake                 (side_pwrgate_pmc_wake)             //I: IOSFSB
    ,.side_rst_b                            (side_rst_b)                        //I: IOSFSB
    ,.strap_hqm_16b_portids                 (strap_hqm_16b_portids)             //I: IOSFSB
    ,.strap_hqm_cmpl_sai                    (strap_hqm_cmpl_sai)                //I: IOSFSB
    ,.strap_hqm_do_serr_dstid               (strap_hqm_do_serr_dstid)           //I: IOSFSB
    ,.strap_hqm_do_serr_rs                  (strap_hqm_do_serr_rs)              //I: IOSFSB
    ,.strap_hqm_do_serr_sai                 (strap_hqm_do_serr_sai)             //I: IOSFSB
    ,.strap_hqm_do_serr_sairs_valid         (strap_hqm_do_serr_sairs_valid)     //I: IOSFSB
    ,.strap_hqm_do_serr_tag                 (strap_hqm_do_serr_tag)             //I: IOSFSB
    ,.strap_hqm_err_sb_dstid                (strap_hqm_err_sb_dstid)            //I: IOSFSB
    ,.strap_hqm_err_sb_sai                  (strap_hqm_err_sb_sai)              //I: IOSFSB
    ,.strap_hqm_force_pok_sai_0             (strap_hqm_force_pok_sai_0)         //I: IOSFSB
    ,.strap_hqm_force_pok_sai_1             (strap_hqm_force_pok_sai_1)         //I: IOSFSB
    ,.strap_hqm_gpsb_srcid                  (strap_hqm_gpsb_srcid)              //I: IOSFSB
    ,.strap_hqm_resetprep_ack_sai           (strap_hqm_resetprep_ack_sai)       //I: IOSFSB
    ,.strap_hqm_resetprep_sai_0             (strap_hqm_resetprep_sai_0)         //I: IOSFSB
    ,.strap_hqm_resetprep_sai_1             (strap_hqm_resetprep_sai_1)         //I: IOSFSB
    ,.strap_hqm_tx_sai                      (strap_hqm_tx_sai)                  //I: IOSFSB
    ,.strap_no_mgmt_acks                    (strap_no_mgmt_acks)                //I: IOSFSB

    // Outputs

    ,.adr_clkreq                            (adr_clkreq)                        //O: IOSFSB
    ,.cfg_visa_sw_control                   (cfg_visa_sw_control)               //O: IOSFSB
    ,.cfg_visa_sw_control_write_done        (cfg_visa_sw_control_write_done)    //O: IOSFSB
    ,.err_sb_msgack                         (err_sb_msgack)                     //O: IOSFSB
    ,.force_ip_inaccessible                 (force_ip_inaccessible)             //O: IOSFSB
    ,.force_pm_state_d3hot                  (force_pm_state_d3hot)              //O: IOSFSB
    ,.force_warm_reset                      (force_warm_reset)                  //O: IOSFSB
    ,.fuse_force_on                         (fuse_force_on)                     //O: IOSFSB
    ,.fuse_proc_disable                     (fuse_proc_disable)                 //O: IOSFSB
    ,.gpsb_meom                             (gpsb_meom)                         //O: IOSFSB
    ,.gpsb_mnpput                           (gpsb_mnpput)                       //O: IOSFSB
    ,.gpsb_mparity                          (gpsb_mparity)                      //O: IOSFSB
    ,.gpsb_mpayload                         (gpsb_mpayload)                     //O: IOSFSB
    ,.gpsb_mpcput                           (gpsb_mpcput)                       //O: IOSFSB
    ,.gpsb_side_ism_agent                   (gpsb_side_ism_agent)               //O: IOSFSB
    ,.gpsb_tnpcup                           (gpsb_tnpcup)                       //O: IOSFSB
    ,.gpsb_tpccup                           (gpsb_tpccup)                       //O: IOSFSB
    ,.hqm_pm_adr_ack                        (hqm_pm_adr_ack)                    //O: IOSFSB
    ,.ip_ready                              (ip_ready)                          //O: IOSFSB
    ,.master_ctl                            (master_ctl)                        //O: IOSFSB
    ,.master_ctl_load                       (master_ctl_load)                   //O: IOSFSB
    ,.prim_clkreq_async_sbe                 (prim_clkreq_async_sbe)             //O: IOSFSB
    ,.quiesce_qualifier                     (quiesce_qualifier)                 //O: IOSFSB
    ,.reset_prep_ack                        (reset_prep_ack)                    //O: IOSFSB
    ,.ri_iosf_sb_idle                       (ri_iosf_sb_idle)                   //O: IOSFSB
    ,.sif_mstr_quiesce_req                  (sif_mstr_quiesce_req)              //O: IOSFSB
    ,.rpa_clkreq                            (rpa_clkreq)                        //O: IOSFSB
    ,.sb_cds_msg                            (sb_cds_msg)                        //O: IOSFSB
    ,.sb_ep_fuses                           (sb_ep_fuses)                       //O: IOSFSB
    ,.sb_ep_parity_err_sync                 (sb_ep_parity_err_sync)             //O: IOSFSB
    ,.sbe_prim_clkreq                       (sbe_prim_clkreq_nc)                //O: IOSFSB
    ,.side_clkreq                           (side_clkreq)                       //O: IOSFSB
    ,.side_gated_clk                        (side_gated_clk)                    //O: IOSFSB
    ,.side_gated_rst_b                      (side_gated_rst_b)                  //O: IOSFSB
    ,.side_pok                              (side_pok)                          //O: IOSFSB
);

hqm_sif_infra_core i_hqm_sif_infra_core (

    // Inputs

     .cds_smon_comp                         (cds_smon_comp)                     //I: INFRA
    ,.cds_smon_event                        (cds_smon_event)                    //I: INFRA
    ,.cfg_addr                              (cfg_addr)                          //I: INFRA
    ,.cfg_master_timeout                    (cfg_master_timeout)                //I: INFRA
    ,.cfg_re                                (cfg_re)                            //I: INFRA
    ,.cfg_wdata                             (cfg_wdata)                         //I: INFRA
    ,.cfg_we                                (cfg_we)                            //I: INFRA
    ,.cmd_put                               (cmd_put)                           //I: INFRA
    ,.cmd_rtype                             (cmd_rtype)                         //I: INFRA
    ,.cpl_error                             (cpl_error)                         //I: INFRA
    ,.credit_cmd                            (credit_cmd)                        //I: INFRA
    ,.credit_data                           (credit_data)                       //I: INFRA
    ,.credit_put                            (credit_put)                        //I: INFRA
    ,.credit_rtype                          (credit_rtype)                      //I: INFRA
    ,.csr_pasid_enable                      (csr_pasid_enable)                  //I: INFRA
    ,.csr_pmsixctl_fm_wxp                   (csr_pmsixctl_fm_wxp)               //I: INFRA
    ,.csr_pmsixctl_msie_wxp                 (csr_pmsixctl_msie_wxp)             //I: INFRA
    ,.devtlb_ats_alarm                      (devtlb_ats_alarm)                  //I: INFRA
    ,.flr_treatment                         (flr_treatment)                     //I: INFRA
    ,.flr_triggered_wl_infra                (flr_triggered_wl[5:2])             //I: INFRA
    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: INFRA
    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: INFRA
    ,.gnt                                   (gnt)                               //I: INFRA
    ,.gnt_rtype                             (gnt_rtype)                         //I: INFRA
    ,.gnt_type                              (gnt_type)                          //I: INFRA
    ,.hcw_enq_in_data                       (hcw_enq_in_data)                   //I: INFRA
    ,.hcw_enq_in_ready                      (hcw_enq_in_ready)                  //I: INFRA
    ,.hcw_enq_in_v_prequal                  (hcw_enq_in_v_prequal)              //I: INFRA
    ,.hqm_csr_ext_mmio_req                  (hqm_csr_ext_mmio_req)              //I: INFRA
    ,.hqm_csr_ext_mmio_req_apar             (hqm_csr_ext_mmio_req_apar)         //I: INFRA
    ,.hqm_csr_ext_mmio_req_dpar             (hqm_csr_ext_mmio_req_dpar)         //I: INFRA
    ,.hqm_flr_prep                          (hqm_flr_prep)                      //I: INFRA
    ,.hqm_gated_rst_b                       (hqm_gated_rst_b)                   //I: INFRA
    ,.hqm_idle                              (hqm_idle)                          //I: INFRA
    ,.hqm_inp_gated_clk                     (hqm_inp_gated_clk)                 //I: INFRA
    ,.hqm_proc_reset_done                   (hqm_proc_reset_done)               //I: INFRA
    ,.hqm_sif_csr_sai_export                (hqm_sif_csr_sai_export)            //I: INFRA
    ,.sif_alarm_err                         (sif_alarm_err)                     //I: INFRA
    ,.sif_alarm_ready                       (sif_alarm_ready)                   //I: INFRA
    ,.sif_parity_alarm                      (sif_parity_alarm)                  //I: INFRA
    ,.mfmt                                  (mfmt)                              //I: INFRA
    ,.mlength                               (mlength)                           //I: INFRA
    ,.mstr_db_status_in_stalled             (mstr_db_status_in_stalled)         //I: INFRA
    ,.mstr_db_status_in_taken               (mstr_db_status_in_taken)           //I: INFRA
    ,.mstr_db_status_out_stalled            (mstr_db_status_out_stalled)        //I: INFRA
    ,.mstr_fifo_afull                       (mstr_fifo_afull)                   //I: INFRA
    ,.mstr_fifo_overflow                    (mstr_fifo_overflow)                //I: INFRA
    ,.mstr_fifo_underflow                   (mstr_fifo_underflow)               //I: INFRA
    ,.mtype                                 (mtype)                             //I: INFRA
    ,.pm_allow_ing_drop                     (pm_allow_ing_drop)                 //I: INFRA
    ,.pm_fsm_in_run                         (pm_fsm_in_run)                     //I: INFRA
    ,.prdata                                (prdata)                            //I: INFRA
    ,.prdata_par                            (prdata_par)                        //I: INFRA
    ,.pready                                (pready)                            //I: INFRA
    ,.prim_freerun_clk                      (prim_freerun_clk)                  //I: INFRA
    ,.prim_gated_clk                        (prim_gated_clk)                    //I: INFRA
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: INFRA
    ,.prim_nonflr_clk                       (prim_nonflr_clk)                   //I: INFRA
    ,.pslverr                               (pslverr)                           //I: INFRA
    ,.req_dlen                              (req_dlen)                          //I: INFRA
    ,.req_put                               (req_put)                           //I: INFRA
    ,.req_rtype                             (req_rtype)                         //I: INFRA
    ,.rf_ipar_error                         (rf_ipar_error)                     //I: INFRA
    ,.ri_db_status_in_stalled               (ri_db_status_in_stalled)           //I: INFRA
    ,.ri_db_status_in_taken                 (ri_db_status_in_taken)             //I: INFRA
    ,.ri_db_status_out_stalled              (ri_db_status_out_stalled)          //I: INFRA
    ,.ri_fifo_afull                         (ri_fifo_afull)                     //I: INFRA
    ,.ri_fifo_overflow                      (ri_fifo_overflow)                  //I: INFRA
    ,.ri_fifo_underflow                     (ri_fifo_underflow)                 //I: INFRA
    ,.ri_parity_alarm                       (ri_parity_alarm)                   //I: INFRA
    ,.sb_ep_parity_err_sync                 (sb_ep_parity_err_sync)             //I: INFRA
    ,.set_devtlb_ats_err                    (set_devtlb_ats_err)                //I: INFRA
    ,.set_sif_parity_err_mstr               (set_sif_parity_err_mstr)           //I: INFRA
    ,.set_ri_parity_err                     (set_ri_parity_err)                 //I: INFRA
    ,.tfmt                                  (tfmt)                              //I: INFRA
    ,.timeout_error                         (timeout_error)                     //I: INFRA
    ,.timeout_syndrome                      (timeout_syndrome)                  //I: INFRA
    ,.tlength                               (tlength)                           //I: INFRA
    ,.ttype                                 (ttype)                             //I: INFRA

    // Outputs

    ,.cfg_error                             (cfg_error)                         //O: INFRA
    ,.cfg_rdata                             (cfg_rdata)                         //O: INFRA
    ,.cfg_rvalid                            (cfg_rvalid)                        //O: INFRA
    ,.cfg_wvalid                            (cfg_wvalid)                        //O: INFRA
    ,.cfgm_idle                             (cfgm_idle)                         //O: INFRA
    ,.cfgm_status                           (cfgm_status)                       //O: INFRA
    ,.cfgm_status2                          (cfgm_status2)                      //O: INFRA
    ,.cfgm_timeout_error                    (cfgm_timeout_error)                //O: INFRA
    ,.hcw_enq_in_ready_qual                 (hcw_enq_in_ready_qual)             //O: INFRA
    ,.hcw_enq_in_v                          (hcw_enq_in_v)                      //O: INFRA
    ,.hqm_csr_ext_mmio_ack                  (hqm_csr_ext_mmio_ack)              //O: INFRA
    ,.hqm_csr_ext_mmio_ack_err              (hqm_csr_ext_mmio_ack_err)          //O: INFRA
    ,.hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n_nc)            //O: INFRA
    ,.int_idle                              (int_idle)                          //O: INFRA
    ,.int_serial_status                     (int_serial_status)                 //O: INFRA
    ,.sif_alarm_data                        (sif_alarm_data)                    //O: INFRA
    ,.sif_alarm_v                           (sif_alarm_v)                       //O: INFRA
    ,.mask_posted                           (mask_posted)                       //O: INFRA
    ,.paddr                                 (paddr)                             //O: INFRA
    ,.pci_cfg_pmsixctl_fm                   (pci_cfg_pmsixctl_fm)               //O: INFRA
    ,.pci_cfg_pmsixctl_msie                 (pci_cfg_pmsixctl_msie)             //O: INFRA
    ,.pci_cfg_sciov_en                      (pci_cfg_sciov_en)                  //O: INFRA
    ,.penable                               (penable)                           //O: INFRA
    ,.prim_gated_wflr_rst_b_primary         (prim_gated_wflr_rst_b_primary)     //O: INFRA
    ,.psel                                  (psel)                              //O: INFRA
    ,.puser                                 (puser)                             //O: INFRA
    ,.pwdata                                (pwdata)                            //O: INFRA
    ,.pwrite                                (pwrite)                            //O: INFRA
    ,.set_sif_alarm_err                     (set_sif_alarm_err)                 //O: INFRA
);

hqm_ri i_hqm_ri (

    //---------------------------------------------------------------------------------------------
    // Clocks/Resets

     .prim_freerun_clk                      (prim_freerun_clk)                  //I: RI
    ,.prim_gated_clk                        (prim_gated_clk)                    //I: RI
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: RI
    ,.prim_nonflr_clk                       (prim_nonflr_clk)                   //I: RI

    ,.side_gated_rst_prim_b                 (side_gated_rst_prim_b)             //I: RI: asynchronous assertion, deassertion synced to prim_clk

    ,.powergood_rst_b                       (powergood_rst_b)                   //I: RI

    ,.hqm_csr_pf0_rst_n                     (hqm_csr_pf0_rst_n)                 //O: RI

    //---------------------------------------------------------------------------------------------
    // Straps

    ,.strap_hqm_is_reg_ep                   (strap_hqm_is_reg_ep)               //I: RI
    ,.strap_hqm_completertenbittagen        (strap_hqm_completertenbittagen)    //I: RI
    ,.strap_hqm_csr_cp                      (strap_hqm_csr_cp)                  //I: RI
    ,.strap_hqm_csr_rac                     (strap_hqm_csr_rac)                 //I: RI
    ,.strap_hqm_csr_wac                     (strap_hqm_csr_wac)                 //I: RI
    ,.strap_hqm_device_id                   (strap_hqm_device_id)               //I: RI

    //---------------------------------------------------------------------------------------------
    // Link Layer interface

    ,.lli_phdr_val                          (lli_phdr_val)                      //I: RI
    ,.lli_phdr                              (lli_phdr)                          //I: RI
    ,.lli_nphdr_val                         (lli_nphdr_val)                     //I: RI
    ,.lli_nphdr                             (lli_nphdr)                         //I: RI

    ,.lli_pdata_push                        (lli_pdata_push)                    //I: RI
    ,.lli_npdata_push                       (lli_npdata_push)                   //I: RI
    ,.lli_pkt_data                          (lli_pkt_data)                      //I: RI
    ,.lli_pkt_data_par                      (lli_pkt_data_par)                  //I: RI

    ,.ri_tgt_crd_inc                        (ri_tgt_crd_inc)                    //O: RI

    ,.tgt_init_hcredits                     (tgt_init_hcredits)                 //I: RI
    ,.tgt_init_dcredits                     (tgt_init_dcredits)                 //I: RI
    ,.tgt_rem_hcredits                      (tgt_rem_hcredits)                  //I: RI
    ,.tgt_rem_dcredits                      (tgt_rem_dcredits)                  //I: RI
    ,.tgt_ret_hcredits                      (tgt_ret_hcredits)                  //I: RI
    ,.tgt_ret_dcredits                      (tgt_ret_dcredits)                  //I: RI

    ,.cpl_usr                               (cpl_usr)                           //I: RI
    ,.cpl_abort                             (cpl_abort)                         //I: RI
    ,.cpl_poisoned                          (cpl_poisoned)                      //I: RI
    ,.cpl_unexpected                        (cpl_unexpected)                    //I: RI
    ,.cpl_error_hdr                         (cpl_error_hdr)                     //I: RI

    ,.cpl_timeout                           (cpl_timeout)                       //I: RI
    ,.cpl_timeout_synd                      (cpl_timeout_synd)                  //I: RI

    ,.iosf_ep_cpar_err                      (iosf_ep_cpar_err)                  //I: RI
    ,.iosf_ep_tecrc_err                     (iosf_ep_tecrc_err)                 //I: RI
    ,.iosf_ep_chdr_w_err                    (iosf_ep_chdr_w_err)                //I: RI

    ,.np_trans_pending                      (np_trans_pending)                  //I: RI
    ,.poisoned_wr_sent                      (poisoned_wr_sent)                  //I: RI

    //---------------------------------------------------------------------------------------------
    // HCW Enqueue Interface

    ,.hcw_enq_in_ready                      (hcw_enq_in_ready_qual)             //I: RI

    ,.hcw_enq_in_v                          (hcw_enq_in_v_prequal)              //O: RI
    ,.hcw_enq_in_data                       (hcw_enq_in_data)                   //O: RI

    //---------------------------------------------------------------------------------------------
    // Outbound completions

    ,.obcpl_ready                           (obcpl_ready)                       //I: RI

    ,.obcpl_v                               (obcpl_v)                           //O: RI
    ,.obcpl_hdr                             (obcpl_hdr)                         //O: RI
    ,.obcpl_data                            (obcpl_data)                        //O: RI
    ,.obcpl_dpar                            (obcpl_dpar)                        //O: RI
    ,.obcpl_enables                         (obcpl_enables)                     //O: RI

    ,.gpsb_upd_enables                      (gpsb_upd_enables)                  //O: RI

    //---------------------------------------------------------------------------------------------
    // FLR

    ,.gnt                                   (gnt)                               //I: RI
    ,.gnt_rtype                             (gnt_rtype)                         //I: RI
    ,.mrsvd1_7                              (mrsvd1_7)                          //I: RI
    ,.mrsvd1_3                              (mrsvd1_3)                          //I: RI
    ,.mtag                                  (mtag)                              //I: RI
    ,.mrqid                                 (mrqid)                             //I: RI

    ,.func_in_rst                           (func_in_rst)                       //O: RI

    ,.flr_treatment                         (flr_treatment)                     //O: RI
    ,.flr_treatment_vec                     (flr_treatment_vec)                 //O: RI
    ,.flr_clk_enable                        (flr_clk_enable)                    //O: RI
    ,.flr_clk_enable_system                 (flr_clk_enable_system)             //O: RI
    ,.flr_triggered_wl                      (flr_triggered_wl[6:2])             //O: RI

    ,.flr_txn_sent                          (flr_txn_sent)                      //O: RI
    ,.flr_txn_tag                           (flr_txn_tag)                       //O: RI
    ,.flr_txn_reqid                         (flr_txn_reqid)                     //O: RI

    ,.ps_txn_sent                           (ps_txn_sent)                       //O: RI
    ,.ps_txn_tag                            (ps_txn_tag)                        //O: RI
    ,.ps_txn_reqid                          (ps_txn_reqid)                      //O: RI

    //---------------------------------------------------------------------------------------------
    // CFG interface

    ,.hqm_sif_csr_hc_rvalid                 (cfg_rvalid)                        //I: RI
    ,.hqm_sif_csr_hc_wvalid                 (cfg_wvalid)                        //I: RI
    ,.hqm_sif_csr_hc_error                  (cfg_error)                         //I: RI
    ,.hqm_sif_csr_hc_reg_read               (cfg_rdata)                         //I: RI

    ,.hqm_sif_csr_hc_addr                   (cfg_addr)                          //O: RI
    ,.hqm_sif_csr_hc_we                     (cfg_we)                            //O: RI
    ,.hqm_sif_csr_hc_re                     (cfg_re)                            //O: RI
    ,.hqm_sif_csr_hc_reg_write              (cfg_wdata)                         //O: RI

    ,.hqm_sif_csr_sai_export                (hqm_sif_csr_sai_export)            //O: RI

    ,.hqm_csr_ext_mmio_req                  (hqm_csr_ext_mmio_req)              //O: RI
    ,.hqm_csr_ext_mmio_req_apar             (hqm_csr_ext_mmio_req_apar)         //O: RI
    ,.hqm_csr_ext_mmio_req_dpar             (hqm_csr_ext_mmio_req_dpar)         //O: RI

    ,.hqm_csr_ext_mmio_ack                  (hqm_csr_ext_mmio_ack)              //I: RI
    ,.hqm_csr_ext_mmio_ack_err              (hqm_csr_ext_mmio_ack_err)          //I: RI

    //---------------------------------------------------------------------------------------------
    // Config

    ,.hqm_csr_rac                           (hqm_csr_rac)                       //O: RI
    ,.hqm_csr_wac                           (hqm_csr_wac)                       //O: RI

    ,.csr_ppdcntl_ero                       (csr_ppdcntl_ero)                   //O: RI
    ,.csr_pasid_enable                      (csr_pasid_enable)                  //O: RI
    ,.csr_pmsixctl_msie_wxp                 (csr_pmsixctl_msie_wxp)             //O: RI
    ,.csr_pmsixctl_fm_wxp                   (csr_pmsixctl_fm_wxp)               //O: RI

    ,.current_bus                           (current_bus)                       //O: RI

    ,.hqm_sif_cnt_ctl                       (hqm_sif_cnt_ctl)                   //O: RI

    ,.cfg_sif_ctl                           (cfg_sif_ctl)                       //O: RI
    ,.cfg_sif_vc_rxmap                      (cfg_sif_vc_rxmap)                  //O: RI
    ,.cfg_sif_vc_txmap                      (cfg_sif_vc_txmap)                  //O: RI

    ,.prim_cdc_ctl                          (cfg_prim_cdc_ctl)                  //O: RI
    ,.side_cdc_ctl                          (cfg_side_cdc_ctl)                  //O: RI
    ,.iosfp_cgctl                           (iosfp_cgctl)                       //O: RI
    ,.iosfs_cgctl                           (iosfs_cgctl)                       //O: RI

    ,.cfg_master_timeout                    (cfg_master_timeout)                //O: RI
    ,.parity_ctl                            (cfg_parity_ctl)                    //O: RI
    ,.cfg_ph_trigger_addr                   (cfg_ph_trigger_addr)               //O: RI
    ,.cfg_ph_trigger_mask                   (cfg_ph_trigger_mask)               //O: RI

    ,.ats_enabled                           (cfg_ats_enabled)                   //O: RI
    ,.scrbd_ctl                             (cfg_scrbd_ctl)                     //O: RI
    ,.mstr_ll_ctl                           (cfg_mstr_ll_ctl)                   //O: RI
    ,.devtlb_ctl                            (cfg_devtlb_ctl)                    //O: RI
    ,.devtlb_spare                          (cfg_devtlb_spare)                  //O: RI
    ,.devtlb_defeature0                     (cfg_devtlb_defeature0)             //O: RI
    ,.devtlb_defeature1                     (cfg_devtlb_defeature1)             //O: RI
    ,.devtlb_defeature2                     (cfg_devtlb_defeature2)             //O: RI

    ,.ibcpl_hdr_fifo_ctl                    (cfg_ibcpl_hdr_fifo_ctl)            //O: RI
    ,.ibcpl_data_fifo_ctl                   (cfg_ibcpl_data_fifo_ctl)           //O: RI

    ,.cfg_visa_sw_control_write             (cfg_visa_sw_control_write)         //O: RI
    ,.cfg_visa_sw_control_wdata             (cfg_visa_sw_control_wdata)         //O: RI

    ,.cfg_visa_sw_control_write_done        (cfg_visa_sw_control_write_done)    //I: RI
    ,.cfg_visa_sw_control                   (cfg_visa_sw_control)               //I: RI

    ,.dir_cq2tc_map                         (dir_cq2tc_map)                     //O: RI
    ,.ldb_cq2tc_map                         (ldb_cq2tc_map)                     //O: RI
    ,.int2tc_map                            (int2tc_map)                        //O: RI

    ,.sb_ep_fuses                           (sb_ep_fuses)                       //I: RI

    //---------------------------------------------------------------------------------------------
    // Status

    ,.ibcpl_hdr_fifo_status                 (cfg_ibcpl_hdr_fifo_status)         //I: RI
    ,.ibcpl_data_fifo_status                (cfg_ibcpl_data_fifo_status)        //I: RI
    ,.p_rl_cq_fifo_status                   (cfg_p_rl_cq_fifo_status)           //I: RI

    ,.sif_db_status                         (sif_db_status)                     //I: RI

    ,.devtlb_status                         (devtlb_status)                     //I: RI
    ,.scrbd_status                          (scrbd_status)                      //I: RI
    ,.mstr_crd_status                       (mstr_crd_status)                   //I: RI
    ,.mstr_fl_status                        (mstr_fl_status)                    //I: RI
    ,.mstr_ll_status                        (mstr_ll_status)                    //I: RI

    ,.local_bme_status                      (local_bme_status)                  //I: RI
    ,.local_msixe_status                    (local_msixe_status)                //I: RI

    ,.cfgm_status                           (cfgm_status)                       //I: RI
    ,.cfgm_status2                          (cfgm_status2)                      //I: RI

    ,.sif_mstr_debug                        (sif_mstr_debug)                    //I: RI

    ,.mstr_cnts                             (mstr_cnts)                         //I: RI

    ,.ri_fifo_afull                         (ri_fifo_afull)                     //O: RI
    ,.ri_idle                               (ri_idle)                           //O: RI
    ,.tlq_idle                              (tlq_idle)                          //O: RI

    ,.ri_db_status_in_stalled               (ri_db_status_in_stalled)           //O: RI
    ,.ri_db_status_in_taken                 (ri_db_status_in_taken)             //O: RI
    ,.ri_db_status_out_stalled              (ri_db_status_out_stalled)          //O: RI

    ,.sif_idle_status                       (sif_idle_status)                   //I: RI
    ,.sif_idle_status_reg                   (sif_idle_status_reg)               //O: RI

    //---------------------------------------------------------------------------------------------
    // Error Signals

    ,.ri_fifo_overflow                      (ri_fifo_overflow)                  //O: RI
    ,.ri_fifo_underflow                     (ri_fifo_underflow)                 //O: RI

    ,.sif_alarm_err                         (sif_alarm_err)                     //O: RI
    ,.ri_parity_alarm                       (ri_parity_alarm)                   //O: RI

    ,.set_devtlb_ats_err                    (set_devtlb_ats_err)                //I: RI
    ,.set_sif_alarm_err                     (set_sif_alarm_err)                 //I: RI
    ,.set_sif_parity_err                    (set_sif_parity_err)                //I: RI
    ,.set_ri_parity_err                     (set_ri_parity_err)                 //O: RI

    ,.cfgm_timeout_error                    (cfgm_timeout_error)                //I: RI

    ,.timeout_error                         (timeout_error)                     //O: RI
    ,.timeout_syndrome                      (timeout_syndrome)                  //O: RI

    ,.cds_smon_event                        (cds_smon_event)                    //O: RI
    ,.cds_smon_comp                         (cds_smon_comp)                     //O: RI

    //---------------------------------------------------------------------------------------------
    // Power Management

    ,.force_pm_state_d3hot                  (force_pm_state_d3hot)              //I: RI

    ,.pm_fsm_d0tod3_ok                      (pm_fsm_d0tod3_ok)                  //I: RI
    ,.pm_fsm_d3tod0_ok                      (pm_fsm_d3tod0_ok)                  //I: RI

    ,.pm_state                              (pm_state)                          //O: RI

    //---------------------------------------------------------------------------------------------
    // Sideband

    ,.ri_iosf_sb_idle                       (ri_iosf_sb_idle)                   //I: RI
    ,.sif_mstr_quiesce_req                  (sif_mstr_quiesce_req)              //I: RI

    ,.quiesce_qualifier                     (quiesce_qualifier)                 //I: RI

    ,.hard_rst_np                           (hard_rst_np)                       //O: RI

    ,.cds_sb_cmsg                           (cds_sb_cmsg)                       //O: RI
    ,.cds_sb_wrack                          (cds_sb_wrack)                      //O: RI
    ,.cds_sb_rdack                          (cds_sb_rdack)                      //O: RI

    ,.sb_cds_msg                            (sb_cds_msg)                        //I: RI

    ,.err_gen_msg                           (err_gen_msg)                       //O: RI
    ,.err_gen_msg_data                      (err_gen_msg_data)                  //O: RI
    ,.err_gen_msg_func                      (err_gen_msg_func)                  //O: RI

    ,.err_sb_msgack                         (err_sb_msgack)                     //I: RI

    //---------------------------------------------------------------------------------------------
    // ATS Invalidate Requests

    ,.rx_msg_v                              (rx_msg_v)                          //O: RI
    ,.rx_msg                                (rx_msg)                            //O: RI

    //---------------------------------------------------------------------------------------------
    // Visa

    ,.flr_visa                              (flr_visa_ri)                       //O: RI

    ,.noa_ri                                (noa_ri)                            //O: RI

    //---------------------------------------------------------------------------------------------
    // DFX

    ,.fscan_rstbypen                        (fscan_rstbypen)                    //I: RI
    ,.fscan_byprst_b                        (fscan_byprst_b)                    //I: RI

    //---------------------------------------------------------------------------------------------
    // Memory Interface

    ,.memi_ri_tlq_fifo_phdr                 (memi_ri_tlq_fifo_phdr)             //O: RI
    ,.memi_ri_tlq_fifo_pdata                (memi_ri_tlq_fifo_pdata)            //O: RI
    ,.memi_ri_tlq_fifo_nphdr                (memi_ri_tlq_fifo_nphdr)            //O: RI
    ,.memi_ri_tlq_fifo_npdata               (memi_ri_tlq_fifo_npdata)           //O: RI

    ,.memo_ri_tlq_fifo_phdr                 (memo_ri_tlq_fifo_phdr)             //I: RI
    ,.memo_ri_tlq_fifo_pdata                (memo_ri_tlq_fifo_pdata)            //I: RI
    ,.memo_ri_tlq_fifo_nphdr                (memo_ri_tlq_fifo_nphdr)            //I: RI
    ,.memo_ri_tlq_fifo_npdata               (memo_ri_tlq_fifo_npdata)           //I: RI

); // hqm_ri

//-----------------------------------------------------------------------------------------------------
// Idle logic

hqm_AW_sync_rst0 i_hqm_proc_idle_sync (

     .clk           (prim_freerun_clk)
    ,.rst_n         (side_gated_rst_prim_b)
    ,.data          (hqm_proc_idle)
    ,.data_sync     (hqm_proc_idle_sync)
);

always_comb begin

 sif_idle_status                = '0;
 sif_idle_status.PROC_IDLE      = hqm_proc_idle_sync;
 sif_idle_status.INT_IDLE       = int_idle;
 sif_idle_status.MSTR_IDLE      = mstr_idle;
 sif_idle_status.MSTR_INTF_IDLE = mstr_intf_idle;
 sif_idle_status.TGT_IDLE       = tgt_idle;
 sif_idle_status.RI_IDLE        = ri_idle;
 sif_idle_status.CFGM_IDLE      = cfgm_idle;

 hqm_sif_idle = &{cfgm_idle, int_idle, mstr_idle, tgt_idle, ri_idle, ~adr_clkreq};

 hqm_idle     = &{hqm_proc_idle_sync, hqm_sif_idle};

end

//-----------------------------------------------------------------------------------------------------
// Clock request logic

always_comb begin

 quiesce_clkreq     = |{~sif_mstr_quiesce_ack, ~tgt_idle, ~mstr_idle, adr_clkreq, rpa_clkreq};

 hqm_proc_clkreq    = (sif_mstr_quiesce_req) ? ((pm_state == PM_FSM_D3HOT) & ~pm_fsm_d3tod0_ok) :
                                               (~hqm_proc_idle);

 agent_clkreq       = (sif_mstr_quiesce_req) ? quiesce_clkreq : ~hqm_sif_idle;

 agent_clkreq_async = hqm_proc_clkreq;

 agent_idle         = tgt_idle & mstr_intf_idle;

end

//-----------------------------------------------------------------------------------------------------

always_comb begin

 set_sif_parity_err.GPSB_PERR            = sb_ep_parity_err_sync;
 set_sif_parity_err.SCRBD_PERR           = set_sif_parity_err_mstr[8];
 set_sif_parity_err.IBCPL_DATA_FIFO_PERR = set_sif_parity_err_mstr[7];
 set_sif_parity_err.IBCPL_HDR_FIFO_PERR  = set_sif_parity_err_mstr[6];
 set_sif_parity_err.TLB_DATA_1G_PERR     = set_sif_parity_err_mstr[5];
 set_sif_parity_err.TLB_DATA_2M_PERR     = set_sif_parity_err_mstr[4];
 set_sif_parity_err.TLB_DATA_4K_PERR     = set_sif_parity_err_mstr[3];
 set_sif_parity_err.TLB_TAG_1G_PERR      = set_sif_parity_err_mstr[2];
 set_sif_parity_err.TLB_TAG_2M_PERR      = set_sif_parity_err_mstr[1];
 set_sif_parity_err.TLB_TAG_4K_PERR      = set_sif_parity_err_mstr[0];

end

//---------------------------------------------------------------------------------------------
// Memory solution interface

// BEGIN HQM_RAM_ACCESS

logic                  hqm_sif_rfw_top_ipar_error;

logic                  func_ibcpl_data_fifo_re; //I
logic [(       8)-1:0] func_ibcpl_data_fifo_raddr; //I
logic [(       8)-1:0] func_ibcpl_data_fifo_waddr; //I
logic                  func_ibcpl_data_fifo_we;    //I
logic [(      66)-1:0] func_ibcpl_data_fifo_wdata; //I
logic [(      66)-1:0] func_ibcpl_data_fifo_rdata;

logic                  func_ibcpl_hdr_fifo_re; //I
logic [(       8)-1:0] func_ibcpl_hdr_fifo_raddr; //I
logic [(       8)-1:0] func_ibcpl_hdr_fifo_waddr; //I
logic                  func_ibcpl_hdr_fifo_we;    //I
logic [(      20)-1:0] func_ibcpl_hdr_fifo_wdata; //I
logic [(      20)-1:0] func_ibcpl_hdr_fifo_rdata;

logic                  func_mstr_ll_data0_re; //I
logic [(       8)-1:0] func_mstr_ll_data0_raddr; //I
logic [(       8)-1:0] func_mstr_ll_data0_waddr; //I
logic                  func_mstr_ll_data0_we;    //I
logic [(     129)-1:0] func_mstr_ll_data0_wdata; //I
logic [(     129)-1:0] func_mstr_ll_data0_rdata;

logic                  func_mstr_ll_data1_re; //I
logic [(       8)-1:0] func_mstr_ll_data1_raddr; //I
logic [(       8)-1:0] func_mstr_ll_data1_waddr; //I
logic                  func_mstr_ll_data1_we;    //I
logic [(     129)-1:0] func_mstr_ll_data1_wdata; //I
logic [(     129)-1:0] func_mstr_ll_data1_rdata;

logic                  func_mstr_ll_data2_re; //I
logic [(       8)-1:0] func_mstr_ll_data2_raddr; //I
logic [(       8)-1:0] func_mstr_ll_data2_waddr; //I
logic                  func_mstr_ll_data2_we;    //I
logic [(     129)-1:0] func_mstr_ll_data2_wdata; //I
logic [(     129)-1:0] func_mstr_ll_data2_rdata;

logic                  func_mstr_ll_data3_re; //I
logic [(       8)-1:0] func_mstr_ll_data3_raddr; //I
logic [(       8)-1:0] func_mstr_ll_data3_waddr; //I
logic                  func_mstr_ll_data3_we;    //I
logic [(     129)-1:0] func_mstr_ll_data3_wdata; //I
logic [(     129)-1:0] func_mstr_ll_data3_rdata;

logic                  func_mstr_ll_hdr_re; //I
logic [(       8)-1:0] func_mstr_ll_hdr_raddr; //I
logic [(       8)-1:0] func_mstr_ll_hdr_waddr; //I
logic                  func_mstr_ll_hdr_we;    //I
logic [(     153)-1:0] func_mstr_ll_hdr_wdata; //I
logic [(     153)-1:0] func_mstr_ll_hdr_rdata;

logic                  func_mstr_ll_hpa_re; //I
logic [(       7)-1:0] func_mstr_ll_hpa_raddr; //I
logic [(       7)-1:0] func_mstr_ll_hpa_waddr; //I
logic                  func_mstr_ll_hpa_we;    //I
logic [(      35)-1:0] func_mstr_ll_hpa_wdata; //I
logic [(      35)-1:0] func_mstr_ll_hpa_rdata;

logic                  func_ri_tlq_fifo_npdata_re; //I
logic [(       3)-1:0] func_ri_tlq_fifo_npdata_raddr; //I
logic [(       3)-1:0] func_ri_tlq_fifo_npdata_waddr; //I
logic                  func_ri_tlq_fifo_npdata_we;    //I
logic [(      33)-1:0] func_ri_tlq_fifo_npdata_wdata; //I
logic [(      33)-1:0] func_ri_tlq_fifo_npdata_rdata;

logic                  func_ri_tlq_fifo_nphdr_re; //I
logic [(       3)-1:0] func_ri_tlq_fifo_nphdr_raddr; //I
logic [(       3)-1:0] func_ri_tlq_fifo_nphdr_waddr; //I
logic                  func_ri_tlq_fifo_nphdr_we;    //I
logic [(     158)-1:0] func_ri_tlq_fifo_nphdr_wdata; //I
logic [(     158)-1:0] func_ri_tlq_fifo_nphdr_rdata;

logic                  func_ri_tlq_fifo_pdata_re; //I
logic [(       5)-1:0] func_ri_tlq_fifo_pdata_raddr; //I
logic [(       5)-1:0] func_ri_tlq_fifo_pdata_waddr; //I
logic                  func_ri_tlq_fifo_pdata_we;    //I
logic [(     264)-1:0] func_ri_tlq_fifo_pdata_wdata; //I
logic [(     264)-1:0] func_ri_tlq_fifo_pdata_rdata;

logic                  func_ri_tlq_fifo_phdr_re; //I
logic [(       4)-1:0] func_ri_tlq_fifo_phdr_raddr; //I
logic [(       4)-1:0] func_ri_tlq_fifo_phdr_waddr; //I
logic                  func_ri_tlq_fifo_phdr_we;    //I
logic [(     153)-1:0] func_ri_tlq_fifo_phdr_wdata; //I
logic [(     153)-1:0] func_ri_tlq_fifo_phdr_rdata;

logic                  func_scrbd_mem_re; //I
logic [(       8)-1:0] func_scrbd_mem_raddr; //I
logic [(       8)-1:0] func_scrbd_mem_waddr; //I
logic                  func_scrbd_mem_we;    //I
logic [(      10)-1:0] func_scrbd_mem_wdata; //I
logic [(      10)-1:0] func_scrbd_mem_rdata;

logic                  func_tlb_data0_4k_re; //I
logic [(       4)-1:0] func_tlb_data0_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data0_4k_waddr; //I
logic                  func_tlb_data0_4k_we;    //I
logic [(      39)-1:0] func_tlb_data0_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data0_4k_rdata;

logic                  func_tlb_data1_4k_re; //I
logic [(       4)-1:0] func_tlb_data1_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data1_4k_waddr; //I
logic                  func_tlb_data1_4k_we;    //I
logic [(      39)-1:0] func_tlb_data1_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data1_4k_rdata;

logic                  func_tlb_data2_4k_re; //I
logic [(       4)-1:0] func_tlb_data2_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data2_4k_waddr; //I
logic                  func_tlb_data2_4k_we;    //I
logic [(      39)-1:0] func_tlb_data2_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data2_4k_rdata;

logic                  func_tlb_data3_4k_re; //I
logic [(       4)-1:0] func_tlb_data3_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data3_4k_waddr; //I
logic                  func_tlb_data3_4k_we;    //I
logic [(      39)-1:0] func_tlb_data3_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data3_4k_rdata;

logic                  func_tlb_data4_4k_re; //I
logic [(       4)-1:0] func_tlb_data4_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data4_4k_waddr; //I
logic                  func_tlb_data4_4k_we;    //I
logic [(      39)-1:0] func_tlb_data4_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data4_4k_rdata;

logic                  func_tlb_data5_4k_re; //I
logic [(       4)-1:0] func_tlb_data5_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data5_4k_waddr; //I
logic                  func_tlb_data5_4k_we;    //I
logic [(      39)-1:0] func_tlb_data5_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data5_4k_rdata;

logic                  func_tlb_data6_4k_re; //I
logic [(       4)-1:0] func_tlb_data6_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data6_4k_waddr; //I
logic                  func_tlb_data6_4k_we;    //I
logic [(      39)-1:0] func_tlb_data6_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data6_4k_rdata;

logic                  func_tlb_data7_4k_re; //I
logic [(       4)-1:0] func_tlb_data7_4k_raddr; //I
logic [(       4)-1:0] func_tlb_data7_4k_waddr; //I
logic                  func_tlb_data7_4k_we;    //I
logic [(      39)-1:0] func_tlb_data7_4k_wdata; //I
logic [(      39)-1:0] func_tlb_data7_4k_rdata;

logic                  func_tlb_tag0_4k_re; //I
logic [(       4)-1:0] func_tlb_tag0_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag0_4k_waddr; //I
logic                  func_tlb_tag0_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag0_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag0_4k_rdata;

logic                  func_tlb_tag1_4k_re; //I
logic [(       4)-1:0] func_tlb_tag1_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag1_4k_waddr; //I
logic                  func_tlb_tag1_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag1_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag1_4k_rdata;

logic                  func_tlb_tag2_4k_re; //I
logic [(       4)-1:0] func_tlb_tag2_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag2_4k_waddr; //I
logic                  func_tlb_tag2_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag2_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag2_4k_rdata;

logic                  func_tlb_tag3_4k_re; //I
logic [(       4)-1:0] func_tlb_tag3_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag3_4k_waddr; //I
logic                  func_tlb_tag3_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag3_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag3_4k_rdata;

logic                  func_tlb_tag4_4k_re; //I
logic [(       4)-1:0] func_tlb_tag4_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag4_4k_waddr; //I
logic                  func_tlb_tag4_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag4_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag4_4k_rdata;

logic                  func_tlb_tag5_4k_re; //I
logic [(       4)-1:0] func_tlb_tag5_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag5_4k_waddr; //I
logic                  func_tlb_tag5_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag5_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag5_4k_rdata;

logic                  func_tlb_tag6_4k_re; //I
logic [(       4)-1:0] func_tlb_tag6_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag6_4k_waddr; //I
logic                  func_tlb_tag6_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag6_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag6_4k_rdata;

logic                  func_tlb_tag7_4k_re; //I
logic [(       4)-1:0] func_tlb_tag7_4k_raddr; //I
logic [(       4)-1:0] func_tlb_tag7_4k_waddr; //I
logic                  func_tlb_tag7_4k_we;    //I
logic [(      85)-1:0] func_tlb_tag7_4k_wdata; //I
logic [(      85)-1:0] func_tlb_tag7_4k_rdata;

hqm_sif_ram_access i_hqm_sif_ram_access (
  .prim_nonflr_clk (prim_nonflr_clk)
, .prim_gated_rst_b (prim_gated_rst_b)
,.hqm_sif_rfw_top_ipar_error (hqm_sif_rfw_top_ipar_error)

,.func_ibcpl_data_fifo_re    (func_ibcpl_data_fifo_re)
,.func_ibcpl_data_fifo_raddr (func_ibcpl_data_fifo_raddr)
,.func_ibcpl_data_fifo_waddr (func_ibcpl_data_fifo_waddr)
,.func_ibcpl_data_fifo_we    (func_ibcpl_data_fifo_we)
,.func_ibcpl_data_fifo_wdata (func_ibcpl_data_fifo_wdata)
,.func_ibcpl_data_fifo_rdata (func_ibcpl_data_fifo_rdata)

,.rf_ibcpl_data_fifo_rclk (rf_ibcpl_data_fifo_rclk)
,.rf_ibcpl_data_fifo_rclk_rst_n (rf_ibcpl_data_fifo_rclk_rst_n)
,.rf_ibcpl_data_fifo_re    (rf_ibcpl_data_fifo_re)
,.rf_ibcpl_data_fifo_raddr (rf_ibcpl_data_fifo_raddr)
,.rf_ibcpl_data_fifo_waddr (rf_ibcpl_data_fifo_waddr)
,.rf_ibcpl_data_fifo_wclk (rf_ibcpl_data_fifo_wclk)
,.rf_ibcpl_data_fifo_wclk_rst_n (rf_ibcpl_data_fifo_wclk_rst_n)
,.rf_ibcpl_data_fifo_we    (rf_ibcpl_data_fifo_we)
,.rf_ibcpl_data_fifo_wdata (rf_ibcpl_data_fifo_wdata)
,.rf_ibcpl_data_fifo_rdata (rf_ibcpl_data_fifo_rdata)

,.func_ibcpl_hdr_fifo_re    (func_ibcpl_hdr_fifo_re)
,.func_ibcpl_hdr_fifo_raddr (func_ibcpl_hdr_fifo_raddr)
,.func_ibcpl_hdr_fifo_waddr (func_ibcpl_hdr_fifo_waddr)
,.func_ibcpl_hdr_fifo_we    (func_ibcpl_hdr_fifo_we)
,.func_ibcpl_hdr_fifo_wdata (func_ibcpl_hdr_fifo_wdata)
,.func_ibcpl_hdr_fifo_rdata (func_ibcpl_hdr_fifo_rdata)

,.rf_ibcpl_hdr_fifo_rclk (rf_ibcpl_hdr_fifo_rclk)
,.rf_ibcpl_hdr_fifo_rclk_rst_n (rf_ibcpl_hdr_fifo_rclk_rst_n)
,.rf_ibcpl_hdr_fifo_re    (rf_ibcpl_hdr_fifo_re)
,.rf_ibcpl_hdr_fifo_raddr (rf_ibcpl_hdr_fifo_raddr)
,.rf_ibcpl_hdr_fifo_waddr (rf_ibcpl_hdr_fifo_waddr)
,.rf_ibcpl_hdr_fifo_wclk (rf_ibcpl_hdr_fifo_wclk)
,.rf_ibcpl_hdr_fifo_wclk_rst_n (rf_ibcpl_hdr_fifo_wclk_rst_n)
,.rf_ibcpl_hdr_fifo_we    (rf_ibcpl_hdr_fifo_we)
,.rf_ibcpl_hdr_fifo_wdata (rf_ibcpl_hdr_fifo_wdata)
,.rf_ibcpl_hdr_fifo_rdata (rf_ibcpl_hdr_fifo_rdata)

,.func_mstr_ll_data0_re    (func_mstr_ll_data0_re)
,.func_mstr_ll_data0_raddr (func_mstr_ll_data0_raddr)
,.func_mstr_ll_data0_waddr (func_mstr_ll_data0_waddr)
,.func_mstr_ll_data0_we    (func_mstr_ll_data0_we)
,.func_mstr_ll_data0_wdata (func_mstr_ll_data0_wdata)
,.func_mstr_ll_data0_rdata (func_mstr_ll_data0_rdata)

,.rf_mstr_ll_data0_rclk (rf_mstr_ll_data0_rclk)
,.rf_mstr_ll_data0_rclk_rst_n (rf_mstr_ll_data0_rclk_rst_n)
,.rf_mstr_ll_data0_re    (rf_mstr_ll_data0_re)
,.rf_mstr_ll_data0_raddr (rf_mstr_ll_data0_raddr)
,.rf_mstr_ll_data0_waddr (rf_mstr_ll_data0_waddr)
,.rf_mstr_ll_data0_wclk (rf_mstr_ll_data0_wclk)
,.rf_mstr_ll_data0_wclk_rst_n (rf_mstr_ll_data0_wclk_rst_n)
,.rf_mstr_ll_data0_we    (rf_mstr_ll_data0_we)
,.rf_mstr_ll_data0_wdata (rf_mstr_ll_data0_wdata)
,.rf_mstr_ll_data0_rdata (rf_mstr_ll_data0_rdata)

,.func_mstr_ll_data1_re    (func_mstr_ll_data1_re)
,.func_mstr_ll_data1_raddr (func_mstr_ll_data1_raddr)
,.func_mstr_ll_data1_waddr (func_mstr_ll_data1_waddr)
,.func_mstr_ll_data1_we    (func_mstr_ll_data1_we)
,.func_mstr_ll_data1_wdata (func_mstr_ll_data1_wdata)
,.func_mstr_ll_data1_rdata (func_mstr_ll_data1_rdata)

,.rf_mstr_ll_data1_rclk (rf_mstr_ll_data1_rclk)
,.rf_mstr_ll_data1_rclk_rst_n (rf_mstr_ll_data1_rclk_rst_n)
,.rf_mstr_ll_data1_re    (rf_mstr_ll_data1_re)
,.rf_mstr_ll_data1_raddr (rf_mstr_ll_data1_raddr)
,.rf_mstr_ll_data1_waddr (rf_mstr_ll_data1_waddr)
,.rf_mstr_ll_data1_wclk (rf_mstr_ll_data1_wclk)
,.rf_mstr_ll_data1_wclk_rst_n (rf_mstr_ll_data1_wclk_rst_n)
,.rf_mstr_ll_data1_we    (rf_mstr_ll_data1_we)
,.rf_mstr_ll_data1_wdata (rf_mstr_ll_data1_wdata)
,.rf_mstr_ll_data1_rdata (rf_mstr_ll_data1_rdata)

,.func_mstr_ll_data2_re    (func_mstr_ll_data2_re)
,.func_mstr_ll_data2_raddr (func_mstr_ll_data2_raddr)
,.func_mstr_ll_data2_waddr (func_mstr_ll_data2_waddr)
,.func_mstr_ll_data2_we    (func_mstr_ll_data2_we)
,.func_mstr_ll_data2_wdata (func_mstr_ll_data2_wdata)
,.func_mstr_ll_data2_rdata (func_mstr_ll_data2_rdata)

,.rf_mstr_ll_data2_rclk (rf_mstr_ll_data2_rclk)
,.rf_mstr_ll_data2_rclk_rst_n (rf_mstr_ll_data2_rclk_rst_n)
,.rf_mstr_ll_data2_re    (rf_mstr_ll_data2_re)
,.rf_mstr_ll_data2_raddr (rf_mstr_ll_data2_raddr)
,.rf_mstr_ll_data2_waddr (rf_mstr_ll_data2_waddr)
,.rf_mstr_ll_data2_wclk (rf_mstr_ll_data2_wclk)
,.rf_mstr_ll_data2_wclk_rst_n (rf_mstr_ll_data2_wclk_rst_n)
,.rf_mstr_ll_data2_we    (rf_mstr_ll_data2_we)
,.rf_mstr_ll_data2_wdata (rf_mstr_ll_data2_wdata)
,.rf_mstr_ll_data2_rdata (rf_mstr_ll_data2_rdata)

,.func_mstr_ll_data3_re    (func_mstr_ll_data3_re)
,.func_mstr_ll_data3_raddr (func_mstr_ll_data3_raddr)
,.func_mstr_ll_data3_waddr (func_mstr_ll_data3_waddr)
,.func_mstr_ll_data3_we    (func_mstr_ll_data3_we)
,.func_mstr_ll_data3_wdata (func_mstr_ll_data3_wdata)
,.func_mstr_ll_data3_rdata (func_mstr_ll_data3_rdata)

,.rf_mstr_ll_data3_rclk (rf_mstr_ll_data3_rclk)
,.rf_mstr_ll_data3_rclk_rst_n (rf_mstr_ll_data3_rclk_rst_n)
,.rf_mstr_ll_data3_re    (rf_mstr_ll_data3_re)
,.rf_mstr_ll_data3_raddr (rf_mstr_ll_data3_raddr)
,.rf_mstr_ll_data3_waddr (rf_mstr_ll_data3_waddr)
,.rf_mstr_ll_data3_wclk (rf_mstr_ll_data3_wclk)
,.rf_mstr_ll_data3_wclk_rst_n (rf_mstr_ll_data3_wclk_rst_n)
,.rf_mstr_ll_data3_we    (rf_mstr_ll_data3_we)
,.rf_mstr_ll_data3_wdata (rf_mstr_ll_data3_wdata)
,.rf_mstr_ll_data3_rdata (rf_mstr_ll_data3_rdata)

,.func_mstr_ll_hdr_re    (func_mstr_ll_hdr_re)
,.func_mstr_ll_hdr_raddr (func_mstr_ll_hdr_raddr)
,.func_mstr_ll_hdr_waddr (func_mstr_ll_hdr_waddr)
,.func_mstr_ll_hdr_we    (func_mstr_ll_hdr_we)
,.func_mstr_ll_hdr_wdata (func_mstr_ll_hdr_wdata)
,.func_mstr_ll_hdr_rdata (func_mstr_ll_hdr_rdata)

,.rf_mstr_ll_hdr_rclk (rf_mstr_ll_hdr_rclk)
,.rf_mstr_ll_hdr_rclk_rst_n (rf_mstr_ll_hdr_rclk_rst_n)
,.rf_mstr_ll_hdr_re    (rf_mstr_ll_hdr_re)
,.rf_mstr_ll_hdr_raddr (rf_mstr_ll_hdr_raddr)
,.rf_mstr_ll_hdr_waddr (rf_mstr_ll_hdr_waddr)
,.rf_mstr_ll_hdr_wclk (rf_mstr_ll_hdr_wclk)
,.rf_mstr_ll_hdr_wclk_rst_n (rf_mstr_ll_hdr_wclk_rst_n)
,.rf_mstr_ll_hdr_we    (rf_mstr_ll_hdr_we)
,.rf_mstr_ll_hdr_wdata (rf_mstr_ll_hdr_wdata)
,.rf_mstr_ll_hdr_rdata (rf_mstr_ll_hdr_rdata)

,.func_mstr_ll_hpa_re    (func_mstr_ll_hpa_re)
,.func_mstr_ll_hpa_raddr (func_mstr_ll_hpa_raddr)
,.func_mstr_ll_hpa_waddr (func_mstr_ll_hpa_waddr)
,.func_mstr_ll_hpa_we    (func_mstr_ll_hpa_we)
,.func_mstr_ll_hpa_wdata (func_mstr_ll_hpa_wdata)
,.func_mstr_ll_hpa_rdata (func_mstr_ll_hpa_rdata)

,.rf_mstr_ll_hpa_rclk (rf_mstr_ll_hpa_rclk)
,.rf_mstr_ll_hpa_rclk_rst_n (rf_mstr_ll_hpa_rclk_rst_n)
,.rf_mstr_ll_hpa_re    (rf_mstr_ll_hpa_re)
,.rf_mstr_ll_hpa_raddr (rf_mstr_ll_hpa_raddr)
,.rf_mstr_ll_hpa_waddr (rf_mstr_ll_hpa_waddr)
,.rf_mstr_ll_hpa_wclk (rf_mstr_ll_hpa_wclk)
,.rf_mstr_ll_hpa_wclk_rst_n (rf_mstr_ll_hpa_wclk_rst_n)
,.rf_mstr_ll_hpa_we    (rf_mstr_ll_hpa_we)
,.rf_mstr_ll_hpa_wdata (rf_mstr_ll_hpa_wdata)
,.rf_mstr_ll_hpa_rdata (rf_mstr_ll_hpa_rdata)

,.func_ri_tlq_fifo_npdata_re    (func_ri_tlq_fifo_npdata_re)
,.func_ri_tlq_fifo_npdata_raddr (func_ri_tlq_fifo_npdata_raddr)
,.func_ri_tlq_fifo_npdata_waddr (func_ri_tlq_fifo_npdata_waddr)
,.func_ri_tlq_fifo_npdata_we    (func_ri_tlq_fifo_npdata_we)
,.func_ri_tlq_fifo_npdata_wdata (func_ri_tlq_fifo_npdata_wdata)
,.func_ri_tlq_fifo_npdata_rdata (func_ri_tlq_fifo_npdata_rdata)

,.rf_ri_tlq_fifo_npdata_rclk (rf_ri_tlq_fifo_npdata_rclk)
,.rf_ri_tlq_fifo_npdata_rclk_rst_n (rf_ri_tlq_fifo_npdata_rclk_rst_n)
,.rf_ri_tlq_fifo_npdata_re    (rf_ri_tlq_fifo_npdata_re)
,.rf_ri_tlq_fifo_npdata_raddr (rf_ri_tlq_fifo_npdata_raddr)
,.rf_ri_tlq_fifo_npdata_waddr (rf_ri_tlq_fifo_npdata_waddr)
,.rf_ri_tlq_fifo_npdata_wclk (rf_ri_tlq_fifo_npdata_wclk)
,.rf_ri_tlq_fifo_npdata_wclk_rst_n (rf_ri_tlq_fifo_npdata_wclk_rst_n)
,.rf_ri_tlq_fifo_npdata_we    (rf_ri_tlq_fifo_npdata_we)
,.rf_ri_tlq_fifo_npdata_wdata (rf_ri_tlq_fifo_npdata_wdata)
,.rf_ri_tlq_fifo_npdata_rdata (rf_ri_tlq_fifo_npdata_rdata)

,.func_ri_tlq_fifo_nphdr_re    (func_ri_tlq_fifo_nphdr_re)
,.func_ri_tlq_fifo_nphdr_raddr (func_ri_tlq_fifo_nphdr_raddr)
,.func_ri_tlq_fifo_nphdr_waddr (func_ri_tlq_fifo_nphdr_waddr)
,.func_ri_tlq_fifo_nphdr_we    (func_ri_tlq_fifo_nphdr_we)
,.func_ri_tlq_fifo_nphdr_wdata (func_ri_tlq_fifo_nphdr_wdata)
,.func_ri_tlq_fifo_nphdr_rdata (func_ri_tlq_fifo_nphdr_rdata)

,.rf_ri_tlq_fifo_nphdr_rclk (rf_ri_tlq_fifo_nphdr_rclk)
,.rf_ri_tlq_fifo_nphdr_rclk_rst_n (rf_ri_tlq_fifo_nphdr_rclk_rst_n)
,.rf_ri_tlq_fifo_nphdr_re    (rf_ri_tlq_fifo_nphdr_re)
,.rf_ri_tlq_fifo_nphdr_raddr (rf_ri_tlq_fifo_nphdr_raddr)
,.rf_ri_tlq_fifo_nphdr_waddr (rf_ri_tlq_fifo_nphdr_waddr)
,.rf_ri_tlq_fifo_nphdr_wclk (rf_ri_tlq_fifo_nphdr_wclk)
,.rf_ri_tlq_fifo_nphdr_wclk_rst_n (rf_ri_tlq_fifo_nphdr_wclk_rst_n)
,.rf_ri_tlq_fifo_nphdr_we    (rf_ri_tlq_fifo_nphdr_we)
,.rf_ri_tlq_fifo_nphdr_wdata (rf_ri_tlq_fifo_nphdr_wdata)
,.rf_ri_tlq_fifo_nphdr_rdata (rf_ri_tlq_fifo_nphdr_rdata)

,.func_ri_tlq_fifo_pdata_re    (func_ri_tlq_fifo_pdata_re)
,.func_ri_tlq_fifo_pdata_raddr (func_ri_tlq_fifo_pdata_raddr)
,.func_ri_tlq_fifo_pdata_waddr (func_ri_tlq_fifo_pdata_waddr)
,.func_ri_tlq_fifo_pdata_we    (func_ri_tlq_fifo_pdata_we)
,.func_ri_tlq_fifo_pdata_wdata (func_ri_tlq_fifo_pdata_wdata)
,.func_ri_tlq_fifo_pdata_rdata (func_ri_tlq_fifo_pdata_rdata)

,.rf_ri_tlq_fifo_pdata_rclk (rf_ri_tlq_fifo_pdata_rclk)
,.rf_ri_tlq_fifo_pdata_rclk_rst_n (rf_ri_tlq_fifo_pdata_rclk_rst_n)
,.rf_ri_tlq_fifo_pdata_re    (rf_ri_tlq_fifo_pdata_re)
,.rf_ri_tlq_fifo_pdata_raddr (rf_ri_tlq_fifo_pdata_raddr)
,.rf_ri_tlq_fifo_pdata_waddr (rf_ri_tlq_fifo_pdata_waddr)
,.rf_ri_tlq_fifo_pdata_wclk (rf_ri_tlq_fifo_pdata_wclk)
,.rf_ri_tlq_fifo_pdata_wclk_rst_n (rf_ri_tlq_fifo_pdata_wclk_rst_n)
,.rf_ri_tlq_fifo_pdata_we    (rf_ri_tlq_fifo_pdata_we)
,.rf_ri_tlq_fifo_pdata_wdata (rf_ri_tlq_fifo_pdata_wdata)
,.rf_ri_tlq_fifo_pdata_rdata (rf_ri_tlq_fifo_pdata_rdata)

,.func_ri_tlq_fifo_phdr_re    (func_ri_tlq_fifo_phdr_re)
,.func_ri_tlq_fifo_phdr_raddr (func_ri_tlq_fifo_phdr_raddr)
,.func_ri_tlq_fifo_phdr_waddr (func_ri_tlq_fifo_phdr_waddr)
,.func_ri_tlq_fifo_phdr_we    (func_ri_tlq_fifo_phdr_we)
,.func_ri_tlq_fifo_phdr_wdata (func_ri_tlq_fifo_phdr_wdata)
,.func_ri_tlq_fifo_phdr_rdata (func_ri_tlq_fifo_phdr_rdata)

,.rf_ri_tlq_fifo_phdr_rclk (rf_ri_tlq_fifo_phdr_rclk)
,.rf_ri_tlq_fifo_phdr_rclk_rst_n (rf_ri_tlq_fifo_phdr_rclk_rst_n)
,.rf_ri_tlq_fifo_phdr_re    (rf_ri_tlq_fifo_phdr_re)
,.rf_ri_tlq_fifo_phdr_raddr (rf_ri_tlq_fifo_phdr_raddr)
,.rf_ri_tlq_fifo_phdr_waddr (rf_ri_tlq_fifo_phdr_waddr)
,.rf_ri_tlq_fifo_phdr_wclk (rf_ri_tlq_fifo_phdr_wclk)
,.rf_ri_tlq_fifo_phdr_wclk_rst_n (rf_ri_tlq_fifo_phdr_wclk_rst_n)
,.rf_ri_tlq_fifo_phdr_we    (rf_ri_tlq_fifo_phdr_we)
,.rf_ri_tlq_fifo_phdr_wdata (rf_ri_tlq_fifo_phdr_wdata)
,.rf_ri_tlq_fifo_phdr_rdata (rf_ri_tlq_fifo_phdr_rdata)

,.func_scrbd_mem_re    (func_scrbd_mem_re)
,.func_scrbd_mem_raddr (func_scrbd_mem_raddr)
,.func_scrbd_mem_waddr (func_scrbd_mem_waddr)
,.func_scrbd_mem_we    (func_scrbd_mem_we)
,.func_scrbd_mem_wdata (func_scrbd_mem_wdata)
,.func_scrbd_mem_rdata (func_scrbd_mem_rdata)

,.rf_scrbd_mem_rclk (rf_scrbd_mem_rclk)
,.rf_scrbd_mem_rclk_rst_n (rf_scrbd_mem_rclk_rst_n)
,.rf_scrbd_mem_re    (rf_scrbd_mem_re)
,.rf_scrbd_mem_raddr (rf_scrbd_mem_raddr)
,.rf_scrbd_mem_waddr (rf_scrbd_mem_waddr)
,.rf_scrbd_mem_wclk (rf_scrbd_mem_wclk)
,.rf_scrbd_mem_wclk_rst_n (rf_scrbd_mem_wclk_rst_n)
,.rf_scrbd_mem_we    (rf_scrbd_mem_we)
,.rf_scrbd_mem_wdata (rf_scrbd_mem_wdata)
,.rf_scrbd_mem_rdata (rf_scrbd_mem_rdata)

,.func_tlb_data0_4k_re    (func_tlb_data0_4k_re)
,.func_tlb_data0_4k_raddr (func_tlb_data0_4k_raddr)
,.func_tlb_data0_4k_waddr (func_tlb_data0_4k_waddr)
,.func_tlb_data0_4k_we    (func_tlb_data0_4k_we)
,.func_tlb_data0_4k_wdata (func_tlb_data0_4k_wdata)
,.func_tlb_data0_4k_rdata (func_tlb_data0_4k_rdata)

,.rf_tlb_data0_4k_rclk (rf_tlb_data0_4k_rclk)
,.rf_tlb_data0_4k_rclk_rst_n (rf_tlb_data0_4k_rclk_rst_n)
,.rf_tlb_data0_4k_re    (rf_tlb_data0_4k_re)
,.rf_tlb_data0_4k_raddr (rf_tlb_data0_4k_raddr)
,.rf_tlb_data0_4k_waddr (rf_tlb_data0_4k_waddr)
,.rf_tlb_data0_4k_wclk (rf_tlb_data0_4k_wclk)
,.rf_tlb_data0_4k_wclk_rst_n (rf_tlb_data0_4k_wclk_rst_n)
,.rf_tlb_data0_4k_we    (rf_tlb_data0_4k_we)
,.rf_tlb_data0_4k_wdata (rf_tlb_data0_4k_wdata)
,.rf_tlb_data0_4k_rdata (rf_tlb_data0_4k_rdata)

,.func_tlb_data1_4k_re    (func_tlb_data1_4k_re)
,.func_tlb_data1_4k_raddr (func_tlb_data1_4k_raddr)
,.func_tlb_data1_4k_waddr (func_tlb_data1_4k_waddr)
,.func_tlb_data1_4k_we    (func_tlb_data1_4k_we)
,.func_tlb_data1_4k_wdata (func_tlb_data1_4k_wdata)
,.func_tlb_data1_4k_rdata (func_tlb_data1_4k_rdata)

,.rf_tlb_data1_4k_rclk (rf_tlb_data1_4k_rclk)
,.rf_tlb_data1_4k_rclk_rst_n (rf_tlb_data1_4k_rclk_rst_n)
,.rf_tlb_data1_4k_re    (rf_tlb_data1_4k_re)
,.rf_tlb_data1_4k_raddr (rf_tlb_data1_4k_raddr)
,.rf_tlb_data1_4k_waddr (rf_tlb_data1_4k_waddr)
,.rf_tlb_data1_4k_wclk (rf_tlb_data1_4k_wclk)
,.rf_tlb_data1_4k_wclk_rst_n (rf_tlb_data1_4k_wclk_rst_n)
,.rf_tlb_data1_4k_we    (rf_tlb_data1_4k_we)
,.rf_tlb_data1_4k_wdata (rf_tlb_data1_4k_wdata)
,.rf_tlb_data1_4k_rdata (rf_tlb_data1_4k_rdata)

,.func_tlb_data2_4k_re    (func_tlb_data2_4k_re)
,.func_tlb_data2_4k_raddr (func_tlb_data2_4k_raddr)
,.func_tlb_data2_4k_waddr (func_tlb_data2_4k_waddr)
,.func_tlb_data2_4k_we    (func_tlb_data2_4k_we)
,.func_tlb_data2_4k_wdata (func_tlb_data2_4k_wdata)
,.func_tlb_data2_4k_rdata (func_tlb_data2_4k_rdata)

,.rf_tlb_data2_4k_rclk (rf_tlb_data2_4k_rclk)
,.rf_tlb_data2_4k_rclk_rst_n (rf_tlb_data2_4k_rclk_rst_n)
,.rf_tlb_data2_4k_re    (rf_tlb_data2_4k_re)
,.rf_tlb_data2_4k_raddr (rf_tlb_data2_4k_raddr)
,.rf_tlb_data2_4k_waddr (rf_tlb_data2_4k_waddr)
,.rf_tlb_data2_4k_wclk (rf_tlb_data2_4k_wclk)
,.rf_tlb_data2_4k_wclk_rst_n (rf_tlb_data2_4k_wclk_rst_n)
,.rf_tlb_data2_4k_we    (rf_tlb_data2_4k_we)
,.rf_tlb_data2_4k_wdata (rf_tlb_data2_4k_wdata)
,.rf_tlb_data2_4k_rdata (rf_tlb_data2_4k_rdata)

,.func_tlb_data3_4k_re    (func_tlb_data3_4k_re)
,.func_tlb_data3_4k_raddr (func_tlb_data3_4k_raddr)
,.func_tlb_data3_4k_waddr (func_tlb_data3_4k_waddr)
,.func_tlb_data3_4k_we    (func_tlb_data3_4k_we)
,.func_tlb_data3_4k_wdata (func_tlb_data3_4k_wdata)
,.func_tlb_data3_4k_rdata (func_tlb_data3_4k_rdata)

,.rf_tlb_data3_4k_rclk (rf_tlb_data3_4k_rclk)
,.rf_tlb_data3_4k_rclk_rst_n (rf_tlb_data3_4k_rclk_rst_n)
,.rf_tlb_data3_4k_re    (rf_tlb_data3_4k_re)
,.rf_tlb_data3_4k_raddr (rf_tlb_data3_4k_raddr)
,.rf_tlb_data3_4k_waddr (rf_tlb_data3_4k_waddr)
,.rf_tlb_data3_4k_wclk (rf_tlb_data3_4k_wclk)
,.rf_tlb_data3_4k_wclk_rst_n (rf_tlb_data3_4k_wclk_rst_n)
,.rf_tlb_data3_4k_we    (rf_tlb_data3_4k_we)
,.rf_tlb_data3_4k_wdata (rf_tlb_data3_4k_wdata)
,.rf_tlb_data3_4k_rdata (rf_tlb_data3_4k_rdata)

,.func_tlb_data4_4k_re    (func_tlb_data4_4k_re)
,.func_tlb_data4_4k_raddr (func_tlb_data4_4k_raddr)
,.func_tlb_data4_4k_waddr (func_tlb_data4_4k_waddr)
,.func_tlb_data4_4k_we    (func_tlb_data4_4k_we)
,.func_tlb_data4_4k_wdata (func_tlb_data4_4k_wdata)
,.func_tlb_data4_4k_rdata (func_tlb_data4_4k_rdata)

,.rf_tlb_data4_4k_rclk (rf_tlb_data4_4k_rclk)
,.rf_tlb_data4_4k_rclk_rst_n (rf_tlb_data4_4k_rclk_rst_n)
,.rf_tlb_data4_4k_re    (rf_tlb_data4_4k_re)
,.rf_tlb_data4_4k_raddr (rf_tlb_data4_4k_raddr)
,.rf_tlb_data4_4k_waddr (rf_tlb_data4_4k_waddr)
,.rf_tlb_data4_4k_wclk (rf_tlb_data4_4k_wclk)
,.rf_tlb_data4_4k_wclk_rst_n (rf_tlb_data4_4k_wclk_rst_n)
,.rf_tlb_data4_4k_we    (rf_tlb_data4_4k_we)
,.rf_tlb_data4_4k_wdata (rf_tlb_data4_4k_wdata)
,.rf_tlb_data4_4k_rdata (rf_tlb_data4_4k_rdata)

,.func_tlb_data5_4k_re    (func_tlb_data5_4k_re)
,.func_tlb_data5_4k_raddr (func_tlb_data5_4k_raddr)
,.func_tlb_data5_4k_waddr (func_tlb_data5_4k_waddr)
,.func_tlb_data5_4k_we    (func_tlb_data5_4k_we)
,.func_tlb_data5_4k_wdata (func_tlb_data5_4k_wdata)
,.func_tlb_data5_4k_rdata (func_tlb_data5_4k_rdata)

,.rf_tlb_data5_4k_rclk (rf_tlb_data5_4k_rclk)
,.rf_tlb_data5_4k_rclk_rst_n (rf_tlb_data5_4k_rclk_rst_n)
,.rf_tlb_data5_4k_re    (rf_tlb_data5_4k_re)
,.rf_tlb_data5_4k_raddr (rf_tlb_data5_4k_raddr)
,.rf_tlb_data5_4k_waddr (rf_tlb_data5_4k_waddr)
,.rf_tlb_data5_4k_wclk (rf_tlb_data5_4k_wclk)
,.rf_tlb_data5_4k_wclk_rst_n (rf_tlb_data5_4k_wclk_rst_n)
,.rf_tlb_data5_4k_we    (rf_tlb_data5_4k_we)
,.rf_tlb_data5_4k_wdata (rf_tlb_data5_4k_wdata)
,.rf_tlb_data5_4k_rdata (rf_tlb_data5_4k_rdata)

,.func_tlb_data6_4k_re    (func_tlb_data6_4k_re)
,.func_tlb_data6_4k_raddr (func_tlb_data6_4k_raddr)
,.func_tlb_data6_4k_waddr (func_tlb_data6_4k_waddr)
,.func_tlb_data6_4k_we    (func_tlb_data6_4k_we)
,.func_tlb_data6_4k_wdata (func_tlb_data6_4k_wdata)
,.func_tlb_data6_4k_rdata (func_tlb_data6_4k_rdata)

,.rf_tlb_data6_4k_rclk (rf_tlb_data6_4k_rclk)
,.rf_tlb_data6_4k_rclk_rst_n (rf_tlb_data6_4k_rclk_rst_n)
,.rf_tlb_data6_4k_re    (rf_tlb_data6_4k_re)
,.rf_tlb_data6_4k_raddr (rf_tlb_data6_4k_raddr)
,.rf_tlb_data6_4k_waddr (rf_tlb_data6_4k_waddr)
,.rf_tlb_data6_4k_wclk (rf_tlb_data6_4k_wclk)
,.rf_tlb_data6_4k_wclk_rst_n (rf_tlb_data6_4k_wclk_rst_n)
,.rf_tlb_data6_4k_we    (rf_tlb_data6_4k_we)
,.rf_tlb_data6_4k_wdata (rf_tlb_data6_4k_wdata)
,.rf_tlb_data6_4k_rdata (rf_tlb_data6_4k_rdata)

,.func_tlb_data7_4k_re    (func_tlb_data7_4k_re)
,.func_tlb_data7_4k_raddr (func_tlb_data7_4k_raddr)
,.func_tlb_data7_4k_waddr (func_tlb_data7_4k_waddr)
,.func_tlb_data7_4k_we    (func_tlb_data7_4k_we)
,.func_tlb_data7_4k_wdata (func_tlb_data7_4k_wdata)
,.func_tlb_data7_4k_rdata (func_tlb_data7_4k_rdata)

,.rf_tlb_data7_4k_rclk (rf_tlb_data7_4k_rclk)
,.rf_tlb_data7_4k_rclk_rst_n (rf_tlb_data7_4k_rclk_rst_n)
,.rf_tlb_data7_4k_re    (rf_tlb_data7_4k_re)
,.rf_tlb_data7_4k_raddr (rf_tlb_data7_4k_raddr)
,.rf_tlb_data7_4k_waddr (rf_tlb_data7_4k_waddr)
,.rf_tlb_data7_4k_wclk (rf_tlb_data7_4k_wclk)
,.rf_tlb_data7_4k_wclk_rst_n (rf_tlb_data7_4k_wclk_rst_n)
,.rf_tlb_data7_4k_we    (rf_tlb_data7_4k_we)
,.rf_tlb_data7_4k_wdata (rf_tlb_data7_4k_wdata)
,.rf_tlb_data7_4k_rdata (rf_tlb_data7_4k_rdata)

,.func_tlb_tag0_4k_re    (func_tlb_tag0_4k_re)
,.func_tlb_tag0_4k_raddr (func_tlb_tag0_4k_raddr)
,.func_tlb_tag0_4k_waddr (func_tlb_tag0_4k_waddr)
,.func_tlb_tag0_4k_we    (func_tlb_tag0_4k_we)
,.func_tlb_tag0_4k_wdata (func_tlb_tag0_4k_wdata)
,.func_tlb_tag0_4k_rdata (func_tlb_tag0_4k_rdata)

,.rf_tlb_tag0_4k_rclk (rf_tlb_tag0_4k_rclk)
,.rf_tlb_tag0_4k_rclk_rst_n (rf_tlb_tag0_4k_rclk_rst_n)
,.rf_tlb_tag0_4k_re    (rf_tlb_tag0_4k_re)
,.rf_tlb_tag0_4k_raddr (rf_tlb_tag0_4k_raddr)
,.rf_tlb_tag0_4k_waddr (rf_tlb_tag0_4k_waddr)
,.rf_tlb_tag0_4k_wclk (rf_tlb_tag0_4k_wclk)
,.rf_tlb_tag0_4k_wclk_rst_n (rf_tlb_tag0_4k_wclk_rst_n)
,.rf_tlb_tag0_4k_we    (rf_tlb_tag0_4k_we)
,.rf_tlb_tag0_4k_wdata (rf_tlb_tag0_4k_wdata)
,.rf_tlb_tag0_4k_rdata (rf_tlb_tag0_4k_rdata)

,.func_tlb_tag1_4k_re    (func_tlb_tag1_4k_re)
,.func_tlb_tag1_4k_raddr (func_tlb_tag1_4k_raddr)
,.func_tlb_tag1_4k_waddr (func_tlb_tag1_4k_waddr)
,.func_tlb_tag1_4k_we    (func_tlb_tag1_4k_we)
,.func_tlb_tag1_4k_wdata (func_tlb_tag1_4k_wdata)
,.func_tlb_tag1_4k_rdata (func_tlb_tag1_4k_rdata)

,.rf_tlb_tag1_4k_rclk (rf_tlb_tag1_4k_rclk)
,.rf_tlb_tag1_4k_rclk_rst_n (rf_tlb_tag1_4k_rclk_rst_n)
,.rf_tlb_tag1_4k_re    (rf_tlb_tag1_4k_re)
,.rf_tlb_tag1_4k_raddr (rf_tlb_tag1_4k_raddr)
,.rf_tlb_tag1_4k_waddr (rf_tlb_tag1_4k_waddr)
,.rf_tlb_tag1_4k_wclk (rf_tlb_tag1_4k_wclk)
,.rf_tlb_tag1_4k_wclk_rst_n (rf_tlb_tag1_4k_wclk_rst_n)
,.rf_tlb_tag1_4k_we    (rf_tlb_tag1_4k_we)
,.rf_tlb_tag1_4k_wdata (rf_tlb_tag1_4k_wdata)
,.rf_tlb_tag1_4k_rdata (rf_tlb_tag1_4k_rdata)

,.func_tlb_tag2_4k_re    (func_tlb_tag2_4k_re)
,.func_tlb_tag2_4k_raddr (func_tlb_tag2_4k_raddr)
,.func_tlb_tag2_4k_waddr (func_tlb_tag2_4k_waddr)
,.func_tlb_tag2_4k_we    (func_tlb_tag2_4k_we)
,.func_tlb_tag2_4k_wdata (func_tlb_tag2_4k_wdata)
,.func_tlb_tag2_4k_rdata (func_tlb_tag2_4k_rdata)

,.rf_tlb_tag2_4k_rclk (rf_tlb_tag2_4k_rclk)
,.rf_tlb_tag2_4k_rclk_rst_n (rf_tlb_tag2_4k_rclk_rst_n)
,.rf_tlb_tag2_4k_re    (rf_tlb_tag2_4k_re)
,.rf_tlb_tag2_4k_raddr (rf_tlb_tag2_4k_raddr)
,.rf_tlb_tag2_4k_waddr (rf_tlb_tag2_4k_waddr)
,.rf_tlb_tag2_4k_wclk (rf_tlb_tag2_4k_wclk)
,.rf_tlb_tag2_4k_wclk_rst_n (rf_tlb_tag2_4k_wclk_rst_n)
,.rf_tlb_tag2_4k_we    (rf_tlb_tag2_4k_we)
,.rf_tlb_tag2_4k_wdata (rf_tlb_tag2_4k_wdata)
,.rf_tlb_tag2_4k_rdata (rf_tlb_tag2_4k_rdata)

,.func_tlb_tag3_4k_re    (func_tlb_tag3_4k_re)
,.func_tlb_tag3_4k_raddr (func_tlb_tag3_4k_raddr)
,.func_tlb_tag3_4k_waddr (func_tlb_tag3_4k_waddr)
,.func_tlb_tag3_4k_we    (func_tlb_tag3_4k_we)
,.func_tlb_tag3_4k_wdata (func_tlb_tag3_4k_wdata)
,.func_tlb_tag3_4k_rdata (func_tlb_tag3_4k_rdata)

,.rf_tlb_tag3_4k_rclk (rf_tlb_tag3_4k_rclk)
,.rf_tlb_tag3_4k_rclk_rst_n (rf_tlb_tag3_4k_rclk_rst_n)
,.rf_tlb_tag3_4k_re    (rf_tlb_tag3_4k_re)
,.rf_tlb_tag3_4k_raddr (rf_tlb_tag3_4k_raddr)
,.rf_tlb_tag3_4k_waddr (rf_tlb_tag3_4k_waddr)
,.rf_tlb_tag3_4k_wclk (rf_tlb_tag3_4k_wclk)
,.rf_tlb_tag3_4k_wclk_rst_n (rf_tlb_tag3_4k_wclk_rst_n)
,.rf_tlb_tag3_4k_we    (rf_tlb_tag3_4k_we)
,.rf_tlb_tag3_4k_wdata (rf_tlb_tag3_4k_wdata)
,.rf_tlb_tag3_4k_rdata (rf_tlb_tag3_4k_rdata)

,.func_tlb_tag4_4k_re    (func_tlb_tag4_4k_re)
,.func_tlb_tag4_4k_raddr (func_tlb_tag4_4k_raddr)
,.func_tlb_tag4_4k_waddr (func_tlb_tag4_4k_waddr)
,.func_tlb_tag4_4k_we    (func_tlb_tag4_4k_we)
,.func_tlb_tag4_4k_wdata (func_tlb_tag4_4k_wdata)
,.func_tlb_tag4_4k_rdata (func_tlb_tag4_4k_rdata)

,.rf_tlb_tag4_4k_rclk (rf_tlb_tag4_4k_rclk)
,.rf_tlb_tag4_4k_rclk_rst_n (rf_tlb_tag4_4k_rclk_rst_n)
,.rf_tlb_tag4_4k_re    (rf_tlb_tag4_4k_re)
,.rf_tlb_tag4_4k_raddr (rf_tlb_tag4_4k_raddr)
,.rf_tlb_tag4_4k_waddr (rf_tlb_tag4_4k_waddr)
,.rf_tlb_tag4_4k_wclk (rf_tlb_tag4_4k_wclk)
,.rf_tlb_tag4_4k_wclk_rst_n (rf_tlb_tag4_4k_wclk_rst_n)
,.rf_tlb_tag4_4k_we    (rf_tlb_tag4_4k_we)
,.rf_tlb_tag4_4k_wdata (rf_tlb_tag4_4k_wdata)
,.rf_tlb_tag4_4k_rdata (rf_tlb_tag4_4k_rdata)

,.func_tlb_tag5_4k_re    (func_tlb_tag5_4k_re)
,.func_tlb_tag5_4k_raddr (func_tlb_tag5_4k_raddr)
,.func_tlb_tag5_4k_waddr (func_tlb_tag5_4k_waddr)
,.func_tlb_tag5_4k_we    (func_tlb_tag5_4k_we)
,.func_tlb_tag5_4k_wdata (func_tlb_tag5_4k_wdata)
,.func_tlb_tag5_4k_rdata (func_tlb_tag5_4k_rdata)

,.rf_tlb_tag5_4k_rclk (rf_tlb_tag5_4k_rclk)
,.rf_tlb_tag5_4k_rclk_rst_n (rf_tlb_tag5_4k_rclk_rst_n)
,.rf_tlb_tag5_4k_re    (rf_tlb_tag5_4k_re)
,.rf_tlb_tag5_4k_raddr (rf_tlb_tag5_4k_raddr)
,.rf_tlb_tag5_4k_waddr (rf_tlb_tag5_4k_waddr)
,.rf_tlb_tag5_4k_wclk (rf_tlb_tag5_4k_wclk)
,.rf_tlb_tag5_4k_wclk_rst_n (rf_tlb_tag5_4k_wclk_rst_n)
,.rf_tlb_tag5_4k_we    (rf_tlb_tag5_4k_we)
,.rf_tlb_tag5_4k_wdata (rf_tlb_tag5_4k_wdata)
,.rf_tlb_tag5_4k_rdata (rf_tlb_tag5_4k_rdata)

,.func_tlb_tag6_4k_re    (func_tlb_tag6_4k_re)
,.func_tlb_tag6_4k_raddr (func_tlb_tag6_4k_raddr)
,.func_tlb_tag6_4k_waddr (func_tlb_tag6_4k_waddr)
,.func_tlb_tag6_4k_we    (func_tlb_tag6_4k_we)
,.func_tlb_tag6_4k_wdata (func_tlb_tag6_4k_wdata)
,.func_tlb_tag6_4k_rdata (func_tlb_tag6_4k_rdata)

,.rf_tlb_tag6_4k_rclk (rf_tlb_tag6_4k_rclk)
,.rf_tlb_tag6_4k_rclk_rst_n (rf_tlb_tag6_4k_rclk_rst_n)
,.rf_tlb_tag6_4k_re    (rf_tlb_tag6_4k_re)
,.rf_tlb_tag6_4k_raddr (rf_tlb_tag6_4k_raddr)
,.rf_tlb_tag6_4k_waddr (rf_tlb_tag6_4k_waddr)
,.rf_tlb_tag6_4k_wclk (rf_tlb_tag6_4k_wclk)
,.rf_tlb_tag6_4k_wclk_rst_n (rf_tlb_tag6_4k_wclk_rst_n)
,.rf_tlb_tag6_4k_we    (rf_tlb_tag6_4k_we)
,.rf_tlb_tag6_4k_wdata (rf_tlb_tag6_4k_wdata)
,.rf_tlb_tag6_4k_rdata (rf_tlb_tag6_4k_rdata)

,.func_tlb_tag7_4k_re    (func_tlb_tag7_4k_re)
,.func_tlb_tag7_4k_raddr (func_tlb_tag7_4k_raddr)
,.func_tlb_tag7_4k_waddr (func_tlb_tag7_4k_waddr)
,.func_tlb_tag7_4k_we    (func_tlb_tag7_4k_we)
,.func_tlb_tag7_4k_wdata (func_tlb_tag7_4k_wdata)
,.func_tlb_tag7_4k_rdata (func_tlb_tag7_4k_rdata)

,.rf_tlb_tag7_4k_rclk (rf_tlb_tag7_4k_rclk)
,.rf_tlb_tag7_4k_rclk_rst_n (rf_tlb_tag7_4k_rclk_rst_n)
,.rf_tlb_tag7_4k_re    (rf_tlb_tag7_4k_re)
,.rf_tlb_tag7_4k_raddr (rf_tlb_tag7_4k_raddr)
,.rf_tlb_tag7_4k_waddr (rf_tlb_tag7_4k_waddr)
,.rf_tlb_tag7_4k_wclk (rf_tlb_tag7_4k_wclk)
,.rf_tlb_tag7_4k_wclk_rst_n (rf_tlb_tag7_4k_wclk_rst_n)
,.rf_tlb_tag7_4k_we    (rf_tlb_tag7_4k_we)
,.rf_tlb_tag7_4k_wdata (rf_tlb_tag7_4k_wdata)
,.rf_tlb_tag7_4k_rdata (rf_tlb_tag7_4k_rdata)

);
// END HQM_RAM_ACCESS

// BEGIN HQM_MEMS_ASSIGN
assign func_ibcpl_data_fifo_we                  = memi_ibcpl_data_fifo.we;
assign func_ibcpl_data_fifo_re                  = memi_ibcpl_data_fifo.re;
assign func_ibcpl_data_fifo_waddr               = memi_ibcpl_data_fifo.waddr;
assign func_ibcpl_data_fifo_raddr               = memi_ibcpl_data_fifo.raddr;
assign func_ibcpl_data_fifo_wdata               = memi_ibcpl_data_fifo.wdata;
assign memo_ibcpl_data_fifo.rdata               = func_ibcpl_data_fifo_rdata;

assign func_ibcpl_hdr_fifo_we                   = memi_ibcpl_hdr_fifo.we;
assign func_ibcpl_hdr_fifo_re                   = memi_ibcpl_hdr_fifo.re;
assign func_ibcpl_hdr_fifo_waddr                = memi_ibcpl_hdr_fifo.waddr;
assign func_ibcpl_hdr_fifo_raddr                = memi_ibcpl_hdr_fifo.raddr;
assign func_ibcpl_hdr_fifo_wdata                = memi_ibcpl_hdr_fifo.wdata;
assign memo_ibcpl_hdr_fifo.rdata                = func_ibcpl_hdr_fifo_rdata;

assign func_mstr_ll_data0_we                    = memi_mstr_ll_data0.we;
assign func_mstr_ll_data0_re                    = memi_mstr_ll_data0.re;
assign func_mstr_ll_data0_waddr                 = memi_mstr_ll_data0.waddr;
assign func_mstr_ll_data0_raddr                 = memi_mstr_ll_data0.raddr;
assign func_mstr_ll_data0_wdata                 = memi_mstr_ll_data0.wdata;
assign memo_mstr_ll_data0.rdata                 = func_mstr_ll_data0_rdata;

assign func_mstr_ll_data1_we                    = memi_mstr_ll_data1.we;
assign func_mstr_ll_data1_re                    = memi_mstr_ll_data1.re;
assign func_mstr_ll_data1_waddr                 = memi_mstr_ll_data1.waddr;
assign func_mstr_ll_data1_raddr                 = memi_mstr_ll_data1.raddr;
assign func_mstr_ll_data1_wdata                 = memi_mstr_ll_data1.wdata;
assign memo_mstr_ll_data1.rdata                 = func_mstr_ll_data1_rdata;

assign func_mstr_ll_data2_we                    = memi_mstr_ll_data2.we;
assign func_mstr_ll_data2_re                    = memi_mstr_ll_data2.re;
assign func_mstr_ll_data2_waddr                 = memi_mstr_ll_data2.waddr;
assign func_mstr_ll_data2_raddr                 = memi_mstr_ll_data2.raddr;
assign func_mstr_ll_data2_wdata                 = memi_mstr_ll_data2.wdata;
assign memo_mstr_ll_data2.rdata                 = func_mstr_ll_data2_rdata;

assign func_mstr_ll_data3_we                    = memi_mstr_ll_data3.we;
assign func_mstr_ll_data3_re                    = memi_mstr_ll_data3.re;
assign func_mstr_ll_data3_waddr                 = memi_mstr_ll_data3.waddr;
assign func_mstr_ll_data3_raddr                 = memi_mstr_ll_data3.raddr;
assign func_mstr_ll_data3_wdata                 = memi_mstr_ll_data3.wdata;
assign memo_mstr_ll_data3.rdata                 = func_mstr_ll_data3_rdata;

assign func_mstr_ll_hdr_we                      = memi_mstr_ll_hdr.we;
assign func_mstr_ll_hdr_re                      = memi_mstr_ll_hdr.re;
assign func_mstr_ll_hdr_waddr                   = memi_mstr_ll_hdr.waddr;
assign func_mstr_ll_hdr_raddr                   = memi_mstr_ll_hdr.raddr;
assign func_mstr_ll_hdr_wdata                   = memi_mstr_ll_hdr.wdata;
assign memo_mstr_ll_hdr.rdata                   = func_mstr_ll_hdr_rdata;

assign func_mstr_ll_hpa_we                      = memi_mstr_ll_hpa.we;
assign func_mstr_ll_hpa_re                      = memi_mstr_ll_hpa.re;
assign func_mstr_ll_hpa_waddr                   = memi_mstr_ll_hpa.waddr;
assign func_mstr_ll_hpa_raddr                   = memi_mstr_ll_hpa.raddr;
assign func_mstr_ll_hpa_wdata                   = memi_mstr_ll_hpa.wdata;
assign memo_mstr_ll_hpa.rdata                   = func_mstr_ll_hpa_rdata;

assign func_ri_tlq_fifo_npdata_we               = memi_ri_tlq_fifo_npdata.we;
assign func_ri_tlq_fifo_npdata_re               = memi_ri_tlq_fifo_npdata.re;
assign func_ri_tlq_fifo_npdata_waddr            = memi_ri_tlq_fifo_npdata.waddr;
assign func_ri_tlq_fifo_npdata_raddr            = memi_ri_tlq_fifo_npdata.raddr;
assign func_ri_tlq_fifo_npdata_wdata            = memi_ri_tlq_fifo_npdata.wdata;
assign memo_ri_tlq_fifo_npdata.rdata            = func_ri_tlq_fifo_npdata_rdata;

assign func_ri_tlq_fifo_nphdr_we                = memi_ri_tlq_fifo_nphdr.we;
assign func_ri_tlq_fifo_nphdr_re                = memi_ri_tlq_fifo_nphdr.re;
assign func_ri_tlq_fifo_nphdr_waddr             = memi_ri_tlq_fifo_nphdr.waddr;
assign func_ri_tlq_fifo_nphdr_raddr             = memi_ri_tlq_fifo_nphdr.raddr;
assign func_ri_tlq_fifo_nphdr_wdata             = memi_ri_tlq_fifo_nphdr.wdata;
assign memo_ri_tlq_fifo_nphdr.rdata             = func_ri_tlq_fifo_nphdr_rdata;

assign func_ri_tlq_fifo_pdata_we                = memi_ri_tlq_fifo_pdata.we;
assign func_ri_tlq_fifo_pdata_re                = memi_ri_tlq_fifo_pdata.re;
assign func_ri_tlq_fifo_pdata_waddr             = memi_ri_tlq_fifo_pdata.waddr;
assign func_ri_tlq_fifo_pdata_raddr             = memi_ri_tlq_fifo_pdata.raddr;
assign func_ri_tlq_fifo_pdata_wdata             = memi_ri_tlq_fifo_pdata.wdata;
assign memo_ri_tlq_fifo_pdata.rdata             = func_ri_tlq_fifo_pdata_rdata;

assign func_ri_tlq_fifo_phdr_we                 = memi_ri_tlq_fifo_phdr.we;
assign func_ri_tlq_fifo_phdr_re                 = memi_ri_tlq_fifo_phdr.re;
assign func_ri_tlq_fifo_phdr_waddr              = memi_ri_tlq_fifo_phdr.waddr;
assign func_ri_tlq_fifo_phdr_raddr              = memi_ri_tlq_fifo_phdr.raddr;
assign func_ri_tlq_fifo_phdr_wdata              = memi_ri_tlq_fifo_phdr.wdata;
assign memo_ri_tlq_fifo_phdr.rdata              = func_ri_tlq_fifo_phdr_rdata;

assign func_scrbd_mem_we                        = memi_scrbd_mem.we;
assign func_scrbd_mem_re                        = memi_scrbd_mem.re;
assign func_scrbd_mem_waddr                     = memi_scrbd_mem.waddr;
assign func_scrbd_mem_raddr                     = memi_scrbd_mem.raddr;
assign func_scrbd_mem_wdata                     = memi_scrbd_mem.wdata;
assign memo_scrbd_mem.rdata                     = func_scrbd_mem_rdata;

assign func_tlb_data0_4k_we                     = memi_tlb_data0_4k.we;
assign func_tlb_data0_4k_re                     = memi_tlb_data0_4k.re;
assign func_tlb_data0_4k_waddr                  = memi_tlb_data0_4k.waddr;
assign func_tlb_data0_4k_raddr                  = memi_tlb_data0_4k.raddr;
assign func_tlb_data0_4k_wdata                  = memi_tlb_data0_4k.wdata;
assign memo_tlb_data0_4k.rdata                  = func_tlb_data0_4k_rdata;

assign func_tlb_data1_4k_we                     = memi_tlb_data1_4k.we;
assign func_tlb_data1_4k_re                     = memi_tlb_data1_4k.re;
assign func_tlb_data1_4k_waddr                  = memi_tlb_data1_4k.waddr;
assign func_tlb_data1_4k_raddr                  = memi_tlb_data1_4k.raddr;
assign func_tlb_data1_4k_wdata                  = memi_tlb_data1_4k.wdata;
assign memo_tlb_data1_4k.rdata                  = func_tlb_data1_4k_rdata;

assign func_tlb_data2_4k_we                     = memi_tlb_data2_4k.we;
assign func_tlb_data2_4k_re                     = memi_tlb_data2_4k.re;
assign func_tlb_data2_4k_waddr                  = memi_tlb_data2_4k.waddr;
assign func_tlb_data2_4k_raddr                  = memi_tlb_data2_4k.raddr;
assign func_tlb_data2_4k_wdata                  = memi_tlb_data2_4k.wdata;
assign memo_tlb_data2_4k.rdata                  = func_tlb_data2_4k_rdata;

assign func_tlb_data3_4k_we                     = memi_tlb_data3_4k.we;
assign func_tlb_data3_4k_re                     = memi_tlb_data3_4k.re;
assign func_tlb_data3_4k_waddr                  = memi_tlb_data3_4k.waddr;
assign func_tlb_data3_4k_raddr                  = memi_tlb_data3_4k.raddr;
assign func_tlb_data3_4k_wdata                  = memi_tlb_data3_4k.wdata;
assign memo_tlb_data3_4k.rdata                  = func_tlb_data3_4k_rdata;

assign func_tlb_data4_4k_we                     = memi_tlb_data4_4k.we;
assign func_tlb_data4_4k_re                     = memi_tlb_data4_4k.re;
assign func_tlb_data4_4k_waddr                  = memi_tlb_data4_4k.waddr;
assign func_tlb_data4_4k_raddr                  = memi_tlb_data4_4k.raddr;
assign func_tlb_data4_4k_wdata                  = memi_tlb_data4_4k.wdata;
assign memo_tlb_data4_4k.rdata                  = func_tlb_data4_4k_rdata;

assign func_tlb_data5_4k_we                     = memi_tlb_data5_4k.we;
assign func_tlb_data5_4k_re                     = memi_tlb_data5_4k.re;
assign func_tlb_data5_4k_waddr                  = memi_tlb_data5_4k.waddr;
assign func_tlb_data5_4k_raddr                  = memi_tlb_data5_4k.raddr;
assign func_tlb_data5_4k_wdata                  = memi_tlb_data5_4k.wdata;
assign memo_tlb_data5_4k.rdata                  = func_tlb_data5_4k_rdata;

assign func_tlb_data6_4k_we                     = memi_tlb_data6_4k.we;
assign func_tlb_data6_4k_re                     = memi_tlb_data6_4k.re;
assign func_tlb_data6_4k_waddr                  = memi_tlb_data6_4k.waddr;
assign func_tlb_data6_4k_raddr                  = memi_tlb_data6_4k.raddr;
assign func_tlb_data6_4k_wdata                  = memi_tlb_data6_4k.wdata;
assign memo_tlb_data6_4k.rdata                  = func_tlb_data6_4k_rdata;

assign func_tlb_data7_4k_we                     = memi_tlb_data7_4k.we;
assign func_tlb_data7_4k_re                     = memi_tlb_data7_4k.re;
assign func_tlb_data7_4k_waddr                  = memi_tlb_data7_4k.waddr;
assign func_tlb_data7_4k_raddr                  = memi_tlb_data7_4k.raddr;
assign func_tlb_data7_4k_wdata                  = memi_tlb_data7_4k.wdata;
assign memo_tlb_data7_4k.rdata                  = func_tlb_data7_4k_rdata;

assign func_tlb_tag0_4k_we                      = memi_tlb_tag0_4k.we;
assign func_tlb_tag0_4k_re                      = memi_tlb_tag0_4k.re;
assign func_tlb_tag0_4k_waddr                   = memi_tlb_tag0_4k.waddr;
assign func_tlb_tag0_4k_raddr                   = memi_tlb_tag0_4k.raddr;
assign func_tlb_tag0_4k_wdata                   = memi_tlb_tag0_4k.wdata;
assign memo_tlb_tag0_4k.rdata                   = func_tlb_tag0_4k_rdata;

assign func_tlb_tag1_4k_we                      = memi_tlb_tag1_4k.we;
assign func_tlb_tag1_4k_re                      = memi_tlb_tag1_4k.re;
assign func_tlb_tag1_4k_waddr                   = memi_tlb_tag1_4k.waddr;
assign func_tlb_tag1_4k_raddr                   = memi_tlb_tag1_4k.raddr;
assign func_tlb_tag1_4k_wdata                   = memi_tlb_tag1_4k.wdata;
assign memo_tlb_tag1_4k.rdata                   = func_tlb_tag1_4k_rdata;

assign func_tlb_tag2_4k_we                      = memi_tlb_tag2_4k.we;
assign func_tlb_tag2_4k_re                      = memi_tlb_tag2_4k.re;
assign func_tlb_tag2_4k_waddr                   = memi_tlb_tag2_4k.waddr;
assign func_tlb_tag2_4k_raddr                   = memi_tlb_tag2_4k.raddr;
assign func_tlb_tag2_4k_wdata                   = memi_tlb_tag2_4k.wdata;
assign memo_tlb_tag2_4k.rdata                   = func_tlb_tag2_4k_rdata;

assign func_tlb_tag3_4k_we                      = memi_tlb_tag3_4k.we;
assign func_tlb_tag3_4k_re                      = memi_tlb_tag3_4k.re;
assign func_tlb_tag3_4k_waddr                   = memi_tlb_tag3_4k.waddr;
assign func_tlb_tag3_4k_raddr                   = memi_tlb_tag3_4k.raddr;
assign func_tlb_tag3_4k_wdata                   = memi_tlb_tag3_4k.wdata;
assign memo_tlb_tag3_4k.rdata                   = func_tlb_tag3_4k_rdata;

assign func_tlb_tag4_4k_we                      = memi_tlb_tag4_4k.we;
assign func_tlb_tag4_4k_re                      = memi_tlb_tag4_4k.re;
assign func_tlb_tag4_4k_waddr                   = memi_tlb_tag4_4k.waddr;
assign func_tlb_tag4_4k_raddr                   = memi_tlb_tag4_4k.raddr;
assign func_tlb_tag4_4k_wdata                   = memi_tlb_tag4_4k.wdata;
assign memo_tlb_tag4_4k.rdata                   = func_tlb_tag4_4k_rdata;

assign func_tlb_tag5_4k_we                      = memi_tlb_tag5_4k.we;
assign func_tlb_tag5_4k_re                      = memi_tlb_tag5_4k.re;
assign func_tlb_tag5_4k_waddr                   = memi_tlb_tag5_4k.waddr;
assign func_tlb_tag5_4k_raddr                   = memi_tlb_tag5_4k.raddr;
assign func_tlb_tag5_4k_wdata                   = memi_tlb_tag5_4k.wdata;
assign memo_tlb_tag5_4k.rdata                   = func_tlb_tag5_4k_rdata;

assign func_tlb_tag6_4k_we                      = memi_tlb_tag6_4k.we;
assign func_tlb_tag6_4k_re                      = memi_tlb_tag6_4k.re;
assign func_tlb_tag6_4k_waddr                   = memi_tlb_tag6_4k.waddr;
assign func_tlb_tag6_4k_raddr                   = memi_tlb_tag6_4k.raddr;
assign func_tlb_tag6_4k_wdata                   = memi_tlb_tag6_4k.wdata;
assign memo_tlb_tag6_4k.rdata                   = func_tlb_tag6_4k_rdata;

assign func_tlb_tag7_4k_we                      = memi_tlb_tag7_4k.we;
assign func_tlb_tag7_4k_re                      = memi_tlb_tag7_4k.re;
assign func_tlb_tag7_4k_waddr                   = memi_tlb_tag7_4k.waddr;
assign func_tlb_tag7_4k_raddr                   = memi_tlb_tag7_4k.raddr;
assign func_tlb_tag7_4k_wdata                   = memi_tlb_tag7_4k.wdata;
assign memo_tlb_tag7_4k.rdata                   = func_tlb_tag7_4k_rdata;

// END HQM_MEMS_ASSIGN

assign rf_ipar_error = hqm_sif_rfw_top_ipar_error;

//-----------------------------------------------------------------------------------------------------

// VCS coverage off

`ifndef INTEL_SVA_OFF

    // Synchronizer validation controls

    logic [31:0] metastability_seed;
    logic        en_metastability_testing;
    logic        first_prim_nonflr_clk_occurred;

    initial begin
      metastability_seed       = '0;
      en_metastability_testing = '0;
    end

    always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
      if (~prim_gated_rst_b) begin
        first_prim_nonflr_clk_occurred  <= '0;
      end else begin
        first_prim_nonflr_clk_occurred  <= '1;
      end
    end

  ///////////////////////////////////////////////////////////////////////////
  // Assertions
  ///////////////////////////////////////////////////////////////////////////
  // After the vote to resetprepack from IOSF Primary, a primary transaction should never be seen.
  AFTER_VOTE_TO_RESETPREPACK_PC_BLOCKED: assert property (@(posedge prim_freerun_clk) disable iff (~prim_gated_rst_b)           // formerly prim_clk
    (~(sif_mstr_quiesce_ack & req_put & (req_rtype != 2'b10)))) else
    $error ("Error: After the PC RESETREPACK votes are sent, no posted or non-posted requests allowed on HQM IOSF MSTR.");

 `ifndef HQM_SFI
  // Made this a fatal to avoid long hangs, reset prep need a clock until its drained and voted.
  RESET_PREP_QUIESCE_NEEDS_CLKREQ: assert property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    (~( ( $past(sif_mstr_quiesce_req & (~sif_mstr_quiesce_ack)) & first_prim_nonflr_clk_occurred ) &           // Quiescing  but no votes
       ~(|{i_hqm_iosfp_core.prim_clkreq_async, i_hqm_iosfp_core.agent_clkreq, sif_mstr_quiesce_ack})))) else   // clkreq not asserted? ERROR
    $fatal ("Error: HQM in order to quiesce and drain Primary Channel it must have a clk.");
 `endif

`endif

// VCS coverage on

endmodule // hqm_sif_core

