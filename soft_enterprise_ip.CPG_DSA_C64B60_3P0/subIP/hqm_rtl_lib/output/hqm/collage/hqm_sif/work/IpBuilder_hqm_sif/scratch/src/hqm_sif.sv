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

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_sif

     import
            hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*;
`ifdef HQM_SFI
     import hqm_sfi_pkg::*;
`endif
#(

     // reuse-pragma startSub HQM_SBE_NPQUEUEDEPTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SBE_NPQUEUEDEPTH -endTok , -indent "     "]
     parameter HQM_SBE_NPQUEUEDEPTH     = 4
    ,
     // reuse-pragma endSub HQM_SBE_NPQUEUEDEPTH
     // reuse-pragma startSub HQM_SBE_PCQUEUEDEPTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SBE_PCQUEUEDEPTH -endTok , -indent ""]
parameter HQM_SBE_PCQUEUEDEPTH     = 4
    ,
// reuse-pragma endSub HQM_SBE_PCQUEUEDEPTH
// reuse-pragma startSub HQM_SBE_DATAWIDTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SBE_DATAWIDTH -endTok , -indent ""]
parameter HQM_SBE_DATAWIDTH        = 8
    ,
// reuse-pragma endSub HQM_SBE_DATAWIDTH
// reuse-pragma startSub HQM_SBE_PARITY_REQUIRED [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SBE_PARITY_REQUIRED -endTok , -indent ""]
parameter HQM_SBE_PARITY_REQUIRED  = 1
`ifdef HQM_SFI
    ,
// reuse-pragma endSub HQM_SBE_PARITY_REQUIRED

// reuse-pragma startSub [InsertFilePrefix %subText]
`include "hqm_sfi_params.sv"
`endif
) 
                   (
     input  logic                                   pgcb_clk
    ,input  logic                                   powergood_rst_b

    ,input  logic                                   pma_safemode

    ,input  logic                                   hqm_inp_gated_clk
    ,input  logic                                   hqm_gated_rst_b

    //---------------------------------------------------------------------------------------------
    // System Configuration Ports

    ,input  logic                                   strap_hqm_is_reg_ep

    ,input  logic [63:0]                            strap_hqm_csr_cp
    ,input  logic [63:0]                            strap_hqm_csr_rac
    ,input  logic [63:0]                            strap_hqm_csr_wac

    // SetID Information
    ,input  logic [15:0]                            strap_hqm_device_id

    // Sideband destination port ID for PCIe errors
    ,input  logic [15:0]                            strap_hqm_err_sb_dstid

    // SAI sent with PCIe error messages
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_err_sb_sai

    // SAI for tx
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_tx_sai

    // SAI for completions
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_cmpl_sai

    // SAI sent with ResetPrepAck messages
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_resetprep_ack_sai

    // Legal SAI values for Sideband ResetPrep message
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_resetprep_sai_0
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_resetprep_sai_1

    // Legal SAI values for Sideband ForcePwrGatePOK message
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_force_pok_sai_0
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_force_pok_sai_1

    //---------------------------------------------------------------------------------------------
    // GPSB source port ID

    ,input  logic [15:0]                            strap_hqm_gpsb_srcid
    ,input  logic                                   strap_hqm_16b_portids

    //---------------------------------------------------------------------------------------------
    // Parity Message configuration

    ,input  logic [15:0]                            strap_hqm_do_serr_dstid
    ,input  logic [2:0]                             strap_hqm_do_serr_tag
    ,input  logic                                   strap_hqm_do_serr_sairs_valid
    ,input  logic [SAI_WIDTH:0]                     strap_hqm_do_serr_sai
    ,input  logic [ RS_WIDTH:0]                     strap_hqm_do_serr_rs

    //---------------------------------------------------------------------------------------------
    // IOSF Sideband CDC signals

    ,output logic                                   side_pok
    ,input  logic                                   side_clk
    ,output logic                                   side_clkreq
    ,input  logic                                   side_clkack
    ,input  logic                                   side_rst_b
    ,input  logic [2:0]                             gpsb_side_ism_fabric
    ,output logic [2:0]                             gpsb_side_ism_agent
    ,input  logic                                   side_pwrgate_pmc_wake

    //---------------------------------------------------------------------------------------------
    // Egress port interface to the IOSF Sideband Channel

    ,input  logic                                   gpsb_mpccup
    ,input  logic                                   gpsb_mnpcup

    ,output logic                                   gpsb_mpcput
    ,output logic                                   gpsb_mnpput
    ,output logic                                   gpsb_meom
    ,output logic [HQM_SBE_DATAWIDTH-1:0]           gpsb_mpayload
    ,output logic                                   gpsb_mparity

    //---------------------------------------------------------------------------------------------
    // Ingress port interface to the IOSF Sideband Channel

    ,output logic                                   gpsb_tpccup
    ,output logic                                   gpsb_tnpcup

    ,input  logic                                   gpsb_tpcput
    ,input  logic                                   gpsb_tnpput
    ,input  logic                                   gpsb_teom
    ,input  logic [HQM_SBE_DATAWIDTH-1:0]           gpsb_tpayload
    ,input  logic                                   gpsb_tparity

    //---------------------------------------------------------------------------------------------
    // Primary Interface

`ifdef HQM_SFI

    //-------------------------------------------------------------------------------------------------
    // SFI TX Global

    ,output logic                                   sfi_tx_txcon_req            // Connection request

    ,input  logic                                   sfi_tx_rxcon_ack            // Connection acknowledge
    ,input  logic                                   sfi_tx_rxdiscon_nack        // Disconnect rejection
    ,input  logic                                   sfi_tx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI TX Header

    ,output logic                                   sfi_tx_hdr_valid            // Header is valid
    ,output logic                                   sfi_tx_hdr_early_valid      // Header early valid indication
    ,output logic [(HQM_SFI_TX_M*16)-1:0]           sfi_tx_hdr_info_bytes       // Header info
    ,output logic [(HQM_SFI_TX_H*8 )-1:0]           sfi_tx_header               // Header

    ,input  logic                                   sfi_tx_hdr_block            // RX requires TX to pause hdr

    ,input  logic                                   sfi_tx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,input  logic [4:0]                             sfi_tx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,input  logic [1:0]                             sfi_tx_hdr_crd_rtn_fc_id    // Credit flow class
    ,input  logic [HQM_SFI_TX_NHCRD-1:0]            sfi_tx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,output logic                                   sfi_tx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI TX Data

    ,output logic                                   sfi_tx_data_valid           // Data is valid
    ,output logic                                   sfi_tx_data_early_valid     // Data early valid indication
    ,output logic                                   sfi_tx_data_aux_parity      // Data auxilliary parity
    ,output logic [(HQM_SFI_TX_D/8 )-1:0]           sfi_tx_data_parity          // Data parity per 8B
    ,output logic [(HQM_SFI_TX_D/4 )-1:0]           sfi_tx_data_poison          // Data poisoned per DW
    ,output logic [(HQM_SFI_TX_D/4 )-1:0]           sfi_tx_data_edb             // Data bad per DW
    ,output logic [ HQM_SFI_TX_DS   -1:0]           sfi_tx_data_start           // Start of data
    ,output logic [(HQM_SFI_TX_D/4 )-1:0]           sfi_tx_data_end             // End   of data
    ,output logic [(HQM_SFI_TX_DS*8)-1:0]           sfi_tx_data_info_byte       // Data info
    ,output logic [(HQM_SFI_TX_D*8 )-1:0]           sfi_tx_data                 // Data payload

    ,input  logic                                   sfi_tx_data_block           // RX requires TX to pause data

    ,input  logic                                   sfi_tx_data_crd_rtn_valid   // RX returning data credit
    ,input  logic [4:0]                             sfi_tx_data_crd_rtn_vc_id   // Credit virtual channel
    ,input  logic [1:0]                             sfi_tx_data_crd_rtn_fc_id   // Credit flow class
    ,input  logic [HQM_SFI_TX_NDCRD-1:0]            sfi_tx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,output logic                                   sfi_tx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //---------------------------------------------------------------------------------------------
    // SFI RX Global

    ,input  logic                                   sfi_rx_txcon_req            // Connection request

    ,output logic                                   sfi_rx_rxcon_ack            // Connection acknowledge
    ,output logic                                   sfi_rx_rxdiscon_nack        // Disconnect rejection
    ,output logic                                   sfi_rx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI RX Header

    ,input  logic                                   sfi_rx_hdr_valid            // Header is valid
    ,input  logic                                   sfi_rx_hdr_early_valid      // Header early valid indication
    ,input  logic [(HQM_SFI_RX_M*16)-1:0]           sfi_rx_hdr_info_bytes       // Header info
    ,input  logic [(HQM_SFI_RX_H*8 )-1:0]           sfi_rx_header               // Header

    ,output logic                                   sfi_rx_hdr_block            // RX requires TX to pause hdr

    ,output logic                                   sfi_rx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,output logic [4:0]                             sfi_rx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,output logic [1:0]                             sfi_rx_hdr_crd_rtn_fc_id    // Credit flow class
    ,output logic [HQM_SFI_RX_NHCRD-1:0]            sfi_rx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,input  logic                                   sfi_rx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI RX Data

    ,input  logic                                   sfi_rx_data_valid           // Data is valid
    ,input  logic                                   sfi_rx_data_early_valid     // Data early valid indication
    ,input  logic                                   sfi_rx_data_aux_parity      // Data auxilliary parity
    ,input  logic [(HQM_SFI_RX_D/8 )-1:0]           sfi_rx_data_parity          // Data parity per 8B
    ,input  logic [(HQM_SFI_RX_D/4 )-1:0]           sfi_rx_data_poison          // Data poisoned per DW
    ,input  logic [(HQM_SFI_RX_D/4 )-1:0]           sfi_rx_data_edb             // Data bad per DW
    ,input  logic [ HQM_SFI_RX_DS   -1:0]           sfi_rx_data_start           // Start of data
    ,input  logic [(HQM_SFI_RX_D/4 )-1:0]           sfi_rx_data_end             // End   of data
    ,input  logic [(HQM_SFI_RX_DS*8)-1:0]           sfi_rx_data_info_byte       // Data info
    ,input  logic [(HQM_SFI_RX_D*8 )-1:0]           sfi_rx_data                 // Data payload

    ,output logic                                   sfi_rx_data_block           // RX requires TX to pause data

    ,output logic                                   sfi_rx_data_crd_rtn_valid   // RX returning data credit
    ,output logic [4:0]                             sfi_rx_data_crd_rtn_vc_id   // Credit virtual channel
    ,output logic [1:0]                             sfi_rx_data_crd_rtn_fc_id   // Credit flow class
    ,output logic [HQM_SFI_RX_NDCRD-1:0]            sfi_rx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,input  logic                                   sfi_rx_data_crd_rtn_block   // TX requires RX to pause data credit returns

`else

    // IOSF Target

    ,input  logic                                   strap_hqm_completertenbittagen

    ,output logic                                   prim_pok

    ,input  logic [2:0]                             prim_ism_fabric
    ,output logic [2:0]                             prim_ism_agent

    ,output logic                                   credit_cmd
    ,output logic [2:0]                             credit_data
    ,output logic                                   credit_put
    ,output logic [1:0]                             credit_rtype

    ,input  logic                                   cmd_nfs_err
    ,input  logic                                   cmd_put
    ,input  logic [1:0]                             cmd_rtype

    ,input  logic [63:0]                            taddress
    ,input  logic [1:0]                             tat
    ,input  logic                                   tchain
    ,input  logic                                   tcparity
    ,input  logic [255:0]                           tdata
    ,input  logic                                   tdec
    ,input  logic [13:0]                            tdest_id
    ,input  logic                                   tdparity
    ,input  logic [31:0]                            tecrc
    ,input  logic                                   tep
    ,input  logic [3:0]                             tfbe
    ,input  logic [1:0]                             tfmt
    ,input  logic                                   tido
    ,input  logic [3:0]                             tlbe
    ,input  logic [9:0]                             tlength
    ,input  logic                                   tns
    ,input  logic [22:0]                            tpasidtlp
    ,input  logic                                   tro
    ,input  logic [15:0]                            trqid
    ,input  logic                                   trs
    ,input  logic                                   trsvd1_3
    ,input  logic                                   trsvd1_7
    ,input  logic [7:0]                             tsai
    ,input  logic [13:0]                            tsrc_id
    ,input  logic [7:0]                             ttag
    ,input  logic [3:0]                             ttc
    ,input  logic                                   ttd
    ,input  logic                                   tth
    ,input  logic [4:0]                             ttype

    ,output logic                                   hit
    ,output logic                                   sub_hit

    // IOSF Master

    ,output logic                                   req_agent
    ,output logic                                   req_cdata
    ,output logic                                   req_chain
    ,output logic [13:0]                            req_dest_id
    ,output logic [9:0]                             req_dlen
    ,output logic [15:0]                            req_id
    ,output logic                                   req_ido
    ,output logic                                   req_locked
    ,output logic                                   req_ns
    ,output logic                                   req_opp
    ,output logic                                   req_put
    ,output logic                                   req_ro
    ,output logic                                   req_rs
    ,output logic [1:0]                             req_rtype
    ,output logic [3:0]                             req_tc

    ,input  logic                                   gnt
    ,input  logic [1:0]                             gnt_rtype
    ,input  logic [1:0]                             gnt_type

    ,output logic [63:0]                            maddress
    ,output logic [1:0]                             mat
    ,output logic                                   mcparity
    ,output logic [255:0]                           mdata
    ,output logic [13:0]                            mdest_id
    ,output logic                                   mdparity
    ,output logic [31:0]                            mecrc
    ,output logic                                   mep
    ,output logic [3:0]                             mfbe
    ,output logic [1:0]                             mfmt
    ,output logic                                   mido
    ,output logic [3:0]                             mlbe
    ,output logic [9:0]                             mlength
    ,output logic                                   mns
    ,output logic [22:0]                            mpasidtlp
    ,output logic                                   mro
    ,output logic [15:0]                            mrqid
    ,output logic                                   mrs
    ,output logic                                   mrsvd1_3
    ,output logic                                   mrsvd1_7
    ,output logic [7:0]                             msai
    ,output logic [13:0]                            msrc_id
    ,output logic [7:0]                             mtag
    ,output logic [3:0]                             mtc
    ,output logic                                   mtd
    ,output logic                                   mth
    ,output logic [4:0]                             mtype

`endif

    //---------------------------------------------------------------------------------------------
    // Primary Clock signals

    ,input  wire                                    prim_pwrgate_pmc_wake

    ,input  wire                                    prim_freerun_clk
    ,input  wire                                    prim_gated_clk
    ,input  wire                                    prim_nonflr_clk

    ,input  logic                                   prim_clkack
    ,output logic                                   prim_clkreq

    ,output wire                                    prim_clk_enable
    ,output wire                                    prim_clk_enable_cdc
    ,output wire                                    prim_clk_enable_sys
    ,output wire                                    prim_clk_ungate

    ,input  wire                                    prim_rst_b
    ,output wire                                    prim_gated_rst_b

    ,output wire                                    flr_triggered

    //---------------------------------------------------------------------------------------------
    // APB interface

    ,output logic                                   psel
    ,output logic                                   penable
    ,output logic                                   pwrite
    ,output logic [31:0]                            paddr
    ,output logic [31:0]                            pwdata
    ,output logic [19:0]                            puser

    ,input  logic                                   pready
    ,input  logic                                   pslverr
    ,input  logic [31:0]                            prdata
    ,input  logic                                   prdata_par

    //-----------------------------------------------------------------------------------------------------
    // IOSF HCW enqueue interface

    ,input  logic                                   hcw_enq_in_ready

    ,output logic                                   hcw_enq_in_v
    ,output logic [BITS_HCW_ENQ_IN_DATA_T-1:0]      hcw_enq_in_data

    //---------------------------------------------------------------------------------------------
    // IOSF Non-Posted interface

    ,output logic                                   write_buffer_mstr_ready

    ,input  logic                                   write_buffer_mstr_v
    ,input  logic [BITS_WRITE_BUFFER_MSTR_T-1:0]    write_buffer_mstr

    //---------------------------------------------------------------------------------------------
    // Alarm Interrupt interface

    ,input  logic                                   sif_alarm_ready

    ,output logic                                   sif_alarm_v
    ,output logic [BITS_AW_ALARM_T-1:0]             sif_alarm_data

    //---------------------------------------------------------------------------------------------
    // IOSF Control interface to hqm_system

    ,output logic                                   pci_cfg_sciov_en                // Scalable IO Virtualization enable

    ,output logic                                   pci_cfg_pmsixctl_msie           // MSIX global enable
    ,output logic                                   pci_cfg_pmsixctl_fm             // MSIX global mask

    //---------------------------------------------------------------------------------------------
    // MASTER interface

    ,output logic [`HQM_PM_FSM_VEC_SZ-1:0]          pm_state
    ,input  logic                                   pm_fsm_d0tod3_ok
    ,input  logic                                   pm_fsm_d3tod0_ok
    ,input  logic                                   pm_fsm_in_run
    ,input  logic                                   pm_allow_ing_drop

    ,input  logic                                   hqm_proc_reset_done
    ,input  logic                                   hqm_proc_idle
    ,input  logic                                   hqm_flr_prep

    ,output logic                                   master_ctl_load
    ,output logic [31:0]                            master_ctl

    //---------------------------------------------------------------------------------------------
    // DFX interface

    ,input  logic                                   fdfx_sbparity_def

    ,input  logic                                   fscan_byprst_b
    ,input  logic                                   fscan_clkungate
    ,input  logic                                   fscan_clkungate_syn
    ,input  logic                                   fscan_latchclosed_b
    ,input  logic                                   fscan_latchopen
    ,input  logic                                   fscan_mode
    ,input  logic                                   fscan_rstbypen
    ,input  logic                                   fscan_shiften

    ,input  logic                                   prim_jta_force_clkreq
    ,input  logic                                   prim_jta_force_creditreq
    ,input  logic                                   prim_jta_force_idle
    ,input  logic                                   prim_jta_force_notidle

    ,input  logic                                   gpsb_jta_clkgate_ovrd
    ,input  logic                                   gpsb_jta_force_clkreq
    ,input  logic                                   gpsb_jta_force_creditreq
    ,input  logic                                   gpsb_jta_force_idle
    ,input  logic                                   gpsb_jta_force_notidle

    ,input  logic                                   cdc_prim_jta_force_clkreq
    ,input  logic                                   cdc_prim_jta_clkgate_ovrd

    ,input  logic                                   cdc_side_jta_force_clkreq
    ,input  logic                                   cdc_side_jta_clkgate_ovrd

    //---------------------------------------------------------------------------------------------
    // Fuse interface

    ,output logic                                   fuse_force_on
    ,output logic                                   fuse_proc_disable

    ,input  logic [EARLY_FUSES_BITS_TOT-1:0]        early_fuses
    ,output logic                                   ip_ready

    ,input  logic                                   strap_no_mgmt_acks
    ,output logic                                   reset_prep_ack

    //---------------------------------------------------------------------------------------------
    // DIMM refresh interface

    ,input  logic                                   pm_hqm_adr_assert
    ,output logic                                   hqm_pm_adr_ack

    //---------------------------------------------------------------------------------------------
    // VISA triggers

    ,output logic [9:0]                             hqm_triggers

    //---------------------------------------------------------------------------------------------

    ,output logic [679:0]                           hqm_sif_visa

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


endmodule // hqm_sif


