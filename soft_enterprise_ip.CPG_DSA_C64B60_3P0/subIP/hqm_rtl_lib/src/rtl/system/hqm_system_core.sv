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

module hqm_system_core

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_msix_mem_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //---------------------------------------------------------------------------------------------
    // Clocks and Resets

     input  logic                                   prim_gated_clk

    ,input  logic                                   hqm_inp_gated_clk
    ,input  logic                                   hqm_inp_gated_rst_b      //not synced to any clocks
    ,input  logic                                   hqm_inp_gated_rst_b_sys

    ,input  logic                                   hqm_gated_clk
    ,input  logic                                   hqm_gated_rst_b_sys

    ,output logic                                   hqm_proc_clk_en_sys

   , input  logic                                   hqm_gated_rst_b_start_sys
   , input  logic                                   hqm_gated_rst_b_active_sys
   , output logic                                   hqm_gated_rst_b_done_sys

    //-----------------------------------------------------------------------------------------------------
    // SIF HCW enqueue interface

    ,output logic                                   hcw_enq_in_ready

    ,input  logic                                   hcw_enq_in_v
    ,input  hqm_system_enq_data_in_t                hcw_enq_in_data

    //---------------------------------------------------------------------------------------------
    // SIF Non-Posted interface

    ,input  logic                                   write_buffer_mstr_ready

    ,output logic                                   write_buffer_mstr_v
    ,output write_buffer_mstr_t                     write_buffer_mstr

    //---------------------------------------------------------------------------------------------
    // SIF Alarm Interrupt interface

    ,output logic                                   sif_alarm_ready

    ,input  logic                                   sif_alarm_v
    ,input  aw_alarm_t                              sif_alarm_data

    //---------------------------------------------------------------------------------------------
    // SIF Control Inputs

    ,input  logic                                   pci_cfg_sciov_en                // Scalable IO Virtualization enable

    ,input  logic                                   pci_cfg_pmsixctl_msie           // MSIX global enable
    ,input  logic                                   pci_cfg_pmsixctl_fm             // MSIX global mask

    //---------------------------------------------------------------------------------------------
    // Master interface

    ,input  logic                                   hqm_rst_prep_sys

    ,output logic                                   system_reset_done
    ,output logic                                   system_idle

    //---------------------------------------------------------------------------------------------
    // Core CFG Ring interface

    ,input  logic                                   system_cfg_req_up_write
    ,input  logic                                   system_cfg_req_up_read
    ,input  cfg_req_t                               system_cfg_req_up

    ,output logic                                   system_cfg_req_down_write
    ,output logic                                   system_cfg_req_down_read
    ,output cfg_req_t                               system_cfg_req_down
    ,output logic                                   system_cfg_rsp_down_ack
    ,output cfg_rsp_t                               system_cfg_rsp_down

    //---------------------------------------------------------------------------------------------
    // Core Alarm Interrupt interface

    ,output logic                                   hqm_alarm_ready

    ,input  logic                                   hqm_alarm_v
    ,input  aw_alarm_t                              hqm_alarm_data

    //---------------------------------------------------------------------------------------------
    // Core HCW Enqueue interface

    ,input  logic                                   hcw_enq_w_req_ready

    ,output logic                                   hcw_enq_w_req_valid
    ,output hcw_enq_w_req_t                         hcw_enq_w_req

    //---------------------------------------------------------------------------------------------
    // Core HCW Schedule interface

    ,output logic                                   hcw_sched_w_req_ready

    ,input  logic                                   hcw_sched_w_req_valid
    ,input  hcw_sched_w_req_t                       hcw_sched_w_req

    //---------------------------------------------------------------------------------------------
    // Core CQ occupany interrupt interface

    ,output logic                                   interrupt_w_req_ready

    ,input  logic                                   interrupt_w_req_valid
    ,input  interrupt_w_req_t                       interrupt_w_req

    //---------------------------------------------------------------------------------------------
    // Core Watchdog interrupt interface

    ,output logic                                   cwdi_interrupt_w_req_ready

    ,input  logic                                   cwdi_interrupt_w_req_valid

    //---------------------------------------------------------------------------------------------
    // DFX interface

    ,input  logic                                   fscan_rstbypen
    ,input  logic                                   fscan_byprst_b

    //---------------------------------------------------------------------------------------------
    // VISA outputs

    ,output logic [29:0]                            hqm_system_visa

    //---------------------------------------------------------------------------------------------
    // Spares

    ,input  logic [1:0]                             spare_lsp_sys
    ,input  logic [1:0]                             spare_qed_sys

    ,output logic [1:0]                             spare_sys_lsp
    ,output logic [1:0]                             spare_sys_qed

    //---------------------------------------------------------------------------------------------
    // Memory solution ports

// BEGIN HQM_MEMPORT_DECL hqm_system_core
    ,output logic                  rf_alarm_vf_synd0_re
    ,output logic                  rf_alarm_vf_synd0_rclk
    ,output logic                  rf_alarm_vf_synd0_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd0_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd0_waddr
    ,output logic                  rf_alarm_vf_synd0_we
    ,output logic                  rf_alarm_vf_synd0_wclk
    ,output logic                  rf_alarm_vf_synd0_wclk_rst_n
    ,output logic [(      30)-1:0] rf_alarm_vf_synd0_wdata
    ,input  logic [(      30)-1:0] rf_alarm_vf_synd0_rdata

    ,output logic                  rf_alarm_vf_synd1_re
    ,output logic                  rf_alarm_vf_synd1_rclk
    ,output logic                  rf_alarm_vf_synd1_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd1_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd1_waddr
    ,output logic                  rf_alarm_vf_synd1_we
    ,output logic                  rf_alarm_vf_synd1_wclk
    ,output logic                  rf_alarm_vf_synd1_wclk_rst_n
    ,output logic [(      32)-1:0] rf_alarm_vf_synd1_wdata
    ,input  logic [(      32)-1:0] rf_alarm_vf_synd1_rdata

    ,output logic                  rf_alarm_vf_synd2_re
    ,output logic                  rf_alarm_vf_synd2_rclk
    ,output logic                  rf_alarm_vf_synd2_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd2_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd2_waddr
    ,output logic                  rf_alarm_vf_synd2_we
    ,output logic                  rf_alarm_vf_synd2_wclk
    ,output logic                  rf_alarm_vf_synd2_wclk_rst_n
    ,output logic [(      32)-1:0] rf_alarm_vf_synd2_wdata
    ,input  logic [(      32)-1:0] rf_alarm_vf_synd2_rdata

    ,output logic                  rf_dir_wb0_re
    ,output logic                  rf_dir_wb0_rclk
    ,output logic                  rf_dir_wb0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb0_raddr
    ,output logic [(       6)-1:0] rf_dir_wb0_waddr
    ,output logic                  rf_dir_wb0_we
    ,output logic                  rf_dir_wb0_wclk
    ,output logic                  rf_dir_wb0_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb0_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb0_rdata

    ,output logic                  rf_dir_wb1_re
    ,output logic                  rf_dir_wb1_rclk
    ,output logic                  rf_dir_wb1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb1_raddr
    ,output logic [(       6)-1:0] rf_dir_wb1_waddr
    ,output logic                  rf_dir_wb1_we
    ,output logic                  rf_dir_wb1_wclk
    ,output logic                  rf_dir_wb1_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb1_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb1_rdata

    ,output logic                  rf_dir_wb2_re
    ,output logic                  rf_dir_wb2_rclk
    ,output logic                  rf_dir_wb2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb2_raddr
    ,output logic [(       6)-1:0] rf_dir_wb2_waddr
    ,output logic                  rf_dir_wb2_we
    ,output logic                  rf_dir_wb2_wclk
    ,output logic                  rf_dir_wb2_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb2_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb2_rdata

    ,output logic                  rf_hcw_enq_fifo_re
    ,output logic                  rf_hcw_enq_fifo_rclk
    ,output logic                  rf_hcw_enq_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_hcw_enq_fifo_raddr
    ,output logic [(       8)-1:0] rf_hcw_enq_fifo_waddr
    ,output logic                  rf_hcw_enq_fifo_we
    ,output logic                  rf_hcw_enq_fifo_wclk
    ,output logic                  rf_hcw_enq_fifo_wclk_rst_n
    ,output logic [(     167)-1:0] rf_hcw_enq_fifo_wdata
    ,input  logic [(     167)-1:0] rf_hcw_enq_fifo_rdata

    ,output logic                  rf_ldb_wb0_re
    ,output logic                  rf_ldb_wb0_rclk
    ,output logic                  rf_ldb_wb0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb0_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb0_waddr
    ,output logic                  rf_ldb_wb0_we
    ,output logic                  rf_ldb_wb0_wclk
    ,output logic                  rf_ldb_wb0_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb0_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb0_rdata

    ,output logic                  rf_ldb_wb1_re
    ,output logic                  rf_ldb_wb1_rclk
    ,output logic                  rf_ldb_wb1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb1_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb1_waddr
    ,output logic                  rf_ldb_wb1_we
    ,output logic                  rf_ldb_wb1_wclk
    ,output logic                  rf_ldb_wb1_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb1_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb1_rdata

    ,output logic                  rf_ldb_wb2_re
    ,output logic                  rf_ldb_wb2_rclk
    ,output logic                  rf_ldb_wb2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb2_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb2_waddr
    ,output logic                  rf_ldb_wb2_we
    ,output logic                  rf_ldb_wb2_wclk
    ,output logic                  rf_ldb_wb2_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb2_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb2_rdata

    ,output logic                  rf_lut_dir_cq2vf_pf_ro_re
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_rclk
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_dir_cq2vf_pf_ro_raddr
    ,output logic [(       5)-1:0] rf_lut_dir_cq2vf_pf_ro_waddr
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_we
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_wclk
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_dir_cq2vf_pf_ro_wdata
    ,input  logic [(      13)-1:0] rf_lut_dir_cq2vf_pf_ro_rdata

    ,output logic                  rf_lut_dir_cq_addr_l_re
    ,output logic                  rf_lut_dir_cq_addr_l_rclk
    ,output logic                  rf_lut_dir_cq_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_l_waddr
    ,output logic                  rf_lut_dir_cq_addr_l_we
    ,output logic                  rf_lut_dir_cq_addr_l_wclk
    ,output logic                  rf_lut_dir_cq_addr_l_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_dir_cq_addr_l_wdata
    ,input  logic [(      27)-1:0] rf_lut_dir_cq_addr_l_rdata

    ,output logic                  rf_lut_dir_cq_addr_u_re
    ,output logic                  rf_lut_dir_cq_addr_u_rclk
    ,output logic                  rf_lut_dir_cq_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_u_waddr
    ,output logic                  rf_lut_dir_cq_addr_u_we
    ,output logic                  rf_lut_dir_cq_addr_u_wclk
    ,output logic                  rf_lut_dir_cq_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_addr_u_rdata

    ,output logic                  rf_lut_dir_cq_ai_addr_l_re
    ,output logic                  rf_lut_dir_cq_ai_addr_l_rclk
    ,output logic                  rf_lut_dir_cq_ai_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_l_waddr
    ,output logic                  rf_lut_dir_cq_ai_addr_l_we
    ,output logic                  rf_lut_dir_cq_ai_addr_l_wclk
    ,output logic                  rf_lut_dir_cq_ai_addr_l_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_dir_cq_ai_addr_l_wdata
    ,input  logic [(      31)-1:0] rf_lut_dir_cq_ai_addr_l_rdata

    ,output logic                  rf_lut_dir_cq_ai_addr_u_re
    ,output logic                  rf_lut_dir_cq_ai_addr_u_rclk
    ,output logic                  rf_lut_dir_cq_ai_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_u_waddr
    ,output logic                  rf_lut_dir_cq_ai_addr_u_we
    ,output logic                  rf_lut_dir_cq_ai_addr_u_wclk
    ,output logic                  rf_lut_dir_cq_ai_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_ai_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_ai_addr_u_rdata

    ,output logic                  rf_lut_dir_cq_ai_data_re
    ,output logic                  rf_lut_dir_cq_ai_data_rclk
    ,output logic                  rf_lut_dir_cq_ai_data_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_data_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_data_waddr
    ,output logic                  rf_lut_dir_cq_ai_data_we
    ,output logic                  rf_lut_dir_cq_ai_data_wclk
    ,output logic                  rf_lut_dir_cq_ai_data_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_ai_data_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_ai_data_rdata

    ,output logic                  rf_lut_dir_cq_isr_re
    ,output logic                  rf_lut_dir_cq_isr_rclk
    ,output logic                  rf_lut_dir_cq_isr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_isr_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_isr_waddr
    ,output logic                  rf_lut_dir_cq_isr_we
    ,output logic                  rf_lut_dir_cq_isr_wclk
    ,output logic                  rf_lut_dir_cq_isr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_dir_cq_isr_wdata
    ,input  logic [(      13)-1:0] rf_lut_dir_cq_isr_rdata

    ,output logic                  rf_lut_dir_cq_pasid_re
    ,output logic                  rf_lut_dir_cq_pasid_rclk
    ,output logic                  rf_lut_dir_cq_pasid_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_pasid_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_pasid_waddr
    ,output logic                  rf_lut_dir_cq_pasid_we
    ,output logic                  rf_lut_dir_cq_pasid_wclk
    ,output logic                  rf_lut_dir_cq_pasid_wclk_rst_n
    ,output logic [(      24)-1:0] rf_lut_dir_cq_pasid_wdata
    ,input  logic [(      24)-1:0] rf_lut_dir_cq_pasid_rdata

    ,output logic                  rf_lut_dir_pp2vas_re
    ,output logic                  rf_lut_dir_pp2vas_rclk
    ,output logic                  rf_lut_dir_pp2vas_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_dir_pp2vas_raddr
    ,output logic [(       5)-1:0] rf_lut_dir_pp2vas_waddr
    ,output logic                  rf_lut_dir_pp2vas_we
    ,output logic                  rf_lut_dir_pp2vas_wclk
    ,output logic                  rf_lut_dir_pp2vas_wclk_rst_n
    ,output logic [(      11)-1:0] rf_lut_dir_pp2vas_wdata
    ,input  logic [(      11)-1:0] rf_lut_dir_pp2vas_rdata

    ,output logic                  rf_lut_dir_pp_v_re
    ,output logic                  rf_lut_dir_pp_v_rclk
    ,output logic                  rf_lut_dir_pp_v_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lut_dir_pp_v_raddr
    ,output logic [(       2)-1:0] rf_lut_dir_pp_v_waddr
    ,output logic                  rf_lut_dir_pp_v_we
    ,output logic                  rf_lut_dir_pp_v_wclk
    ,output logic                  rf_lut_dir_pp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_dir_pp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_dir_pp_v_rdata

    ,output logic                  rf_lut_dir_vasqid_v_re
    ,output logic                  rf_lut_dir_vasqid_v_rclk
    ,output logic                  rf_lut_dir_vasqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_vasqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_vasqid_v_waddr
    ,output logic                  rf_lut_dir_vasqid_v_we
    ,output logic                  rf_lut_dir_vasqid_v_wclk
    ,output logic                  rf_lut_dir_vasqid_v_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_vasqid_v_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_vasqid_v_rdata

    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_re
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_rclk
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_ldb_cq2vf_pf_ro_raddr
    ,output logic [(       5)-1:0] rf_lut_ldb_cq2vf_pf_ro_waddr
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_we
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_wclk
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_ldb_cq2vf_pf_ro_wdata
    ,input  logic [(      13)-1:0] rf_lut_ldb_cq2vf_pf_ro_rdata

    ,output logic                  rf_lut_ldb_cq_addr_l_re
    ,output logic                  rf_lut_ldb_cq_addr_l_rclk
    ,output logic                  rf_lut_ldb_cq_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_l_waddr
    ,output logic                  rf_lut_ldb_cq_addr_l_we
    ,output logic                  rf_lut_ldb_cq_addr_l_wclk
    ,output logic                  rf_lut_ldb_cq_addr_l_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_ldb_cq_addr_l_wdata
    ,input  logic [(      27)-1:0] rf_lut_ldb_cq_addr_l_rdata

    ,output logic                  rf_lut_ldb_cq_addr_u_re
    ,output logic                  rf_lut_ldb_cq_addr_u_rclk
    ,output logic                  rf_lut_ldb_cq_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_u_waddr
    ,output logic                  rf_lut_ldb_cq_addr_u_we
    ,output logic                  rf_lut_ldb_cq_addr_u_wclk
    ,output logic                  rf_lut_ldb_cq_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_addr_u_rdata

    ,output logic                  rf_lut_ldb_cq_ai_addr_l_re
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_rclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_l_waddr
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_we
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_wclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_ldb_cq_ai_addr_l_wdata
    ,input  logic [(      31)-1:0] rf_lut_ldb_cq_ai_addr_l_rdata

    ,output logic                  rf_lut_ldb_cq_ai_addr_u_re
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_rclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_u_waddr
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_we
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_wclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_ai_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_ai_addr_u_rdata

    ,output logic                  rf_lut_ldb_cq_ai_data_re
    ,output logic                  rf_lut_ldb_cq_ai_data_rclk
    ,output logic                  rf_lut_ldb_cq_ai_data_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_data_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_data_waddr
    ,output logic                  rf_lut_ldb_cq_ai_data_we
    ,output logic                  rf_lut_ldb_cq_ai_data_wclk
    ,output logic                  rf_lut_ldb_cq_ai_data_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_ai_data_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_ai_data_rdata

    ,output logic                  rf_lut_ldb_cq_isr_re
    ,output logic                  rf_lut_ldb_cq_isr_rclk
    ,output logic                  rf_lut_ldb_cq_isr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_isr_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_isr_waddr
    ,output logic                  rf_lut_ldb_cq_isr_we
    ,output logic                  rf_lut_ldb_cq_isr_wclk
    ,output logic                  rf_lut_ldb_cq_isr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_ldb_cq_isr_wdata
    ,input  logic [(      13)-1:0] rf_lut_ldb_cq_isr_rdata

    ,output logic                  rf_lut_ldb_cq_pasid_re
    ,output logic                  rf_lut_ldb_cq_pasid_rclk
    ,output logic                  rf_lut_ldb_cq_pasid_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_pasid_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_pasid_waddr
    ,output logic                  rf_lut_ldb_cq_pasid_we
    ,output logic                  rf_lut_ldb_cq_pasid_wclk
    ,output logic                  rf_lut_ldb_cq_pasid_wclk_rst_n
    ,output logic [(      24)-1:0] rf_lut_ldb_cq_pasid_wdata
    ,input  logic [(      24)-1:0] rf_lut_ldb_cq_pasid_rdata

    ,output logic                  rf_lut_ldb_pp2vas_re
    ,output logic                  rf_lut_ldb_pp2vas_rclk
    ,output logic                  rf_lut_ldb_pp2vas_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_ldb_pp2vas_raddr
    ,output logic [(       5)-1:0] rf_lut_ldb_pp2vas_waddr
    ,output logic                  rf_lut_ldb_pp2vas_we
    ,output logic                  rf_lut_ldb_pp2vas_wclk
    ,output logic                  rf_lut_ldb_pp2vas_wclk_rst_n
    ,output logic [(      11)-1:0] rf_lut_ldb_pp2vas_wdata
    ,input  logic [(      11)-1:0] rf_lut_ldb_pp2vas_rdata

    ,output logic                  rf_lut_ldb_qid2vqid_re
    ,output logic                  rf_lut_ldb_qid2vqid_rclk
    ,output logic                  rf_lut_ldb_qid2vqid_rclk_rst_n
    ,output logic [(       3)-1:0] rf_lut_ldb_qid2vqid_raddr
    ,output logic [(       3)-1:0] rf_lut_ldb_qid2vqid_waddr
    ,output logic                  rf_lut_ldb_qid2vqid_we
    ,output logic                  rf_lut_ldb_qid2vqid_wclk
    ,output logic                  rf_lut_ldb_qid2vqid_wclk_rst_n
    ,output logic [(      21)-1:0] rf_lut_ldb_qid2vqid_wdata
    ,input  logic [(      21)-1:0] rf_lut_ldb_qid2vqid_rdata

    ,output logic                  rf_lut_ldb_vasqid_v_re
    ,output logic                  rf_lut_ldb_vasqid_v_rclk
    ,output logic                  rf_lut_ldb_vasqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_vasqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_vasqid_v_waddr
    ,output logic                  rf_lut_ldb_vasqid_v_we
    ,output logic                  rf_lut_ldb_vasqid_v_wclk
    ,output logic                  rf_lut_ldb_vasqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_ldb_vasqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_ldb_vasqid_v_rdata

    ,output logic                  rf_lut_vf_dir_vpp2pp_re
    ,output logic                  rf_lut_vf_dir_vpp2pp_rclk
    ,output logic                  rf_lut_vf_dir_vpp2pp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vpp2pp_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vpp2pp_waddr
    ,output logic                  rf_lut_vf_dir_vpp2pp_we
    ,output logic                  rf_lut_vf_dir_vpp2pp_wclk
    ,output logic                  rf_lut_vf_dir_vpp2pp_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_vf_dir_vpp2pp_wdata
    ,input  logic [(      31)-1:0] rf_lut_vf_dir_vpp2pp_rdata

    ,output logic                  rf_lut_vf_dir_vpp_v_re
    ,output logic                  rf_lut_vf_dir_vpp_v_rclk
    ,output logic                  rf_lut_vf_dir_vpp_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vpp_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vpp_v_waddr
    ,output logic                  rf_lut_vf_dir_vpp_v_we
    ,output logic                  rf_lut_vf_dir_vpp_v_wclk
    ,output logic                  rf_lut_vf_dir_vpp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_dir_vpp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_dir_vpp_v_rdata

    ,output logic                  rf_lut_vf_dir_vqid2qid_re
    ,output logic                  rf_lut_vf_dir_vqid2qid_rclk
    ,output logic                  rf_lut_vf_dir_vqid2qid_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vqid2qid_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vqid2qid_waddr
    ,output logic                  rf_lut_vf_dir_vqid2qid_we
    ,output logic                  rf_lut_vf_dir_vqid2qid_wclk
    ,output logic                  rf_lut_vf_dir_vqid2qid_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_vf_dir_vqid2qid_wdata
    ,input  logic [(      31)-1:0] rf_lut_vf_dir_vqid2qid_rdata

    ,output logic                  rf_lut_vf_dir_vqid_v_re
    ,output logic                  rf_lut_vf_dir_vqid_v_rclk
    ,output logic                  rf_lut_vf_dir_vqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vqid_v_waddr
    ,output logic                  rf_lut_vf_dir_vqid_v_we
    ,output logic                  rf_lut_vf_dir_vqid_v_wclk
    ,output logic                  rf_lut_vf_dir_vqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_dir_vqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_dir_vqid_v_rdata

    ,output logic                  rf_lut_vf_ldb_vpp2pp_re
    ,output logic                  rf_lut_vf_ldb_vpp2pp_rclk
    ,output logic                  rf_lut_vf_ldb_vpp2pp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_ldb_vpp2pp_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_ldb_vpp2pp_waddr
    ,output logic                  rf_lut_vf_ldb_vpp2pp_we
    ,output logic                  rf_lut_vf_ldb_vpp2pp_wclk
    ,output logic                  rf_lut_vf_ldb_vpp2pp_wclk_rst_n
    ,output logic [(      25)-1:0] rf_lut_vf_ldb_vpp2pp_wdata
    ,input  logic [(      25)-1:0] rf_lut_vf_ldb_vpp2pp_rdata

    ,output logic                  rf_lut_vf_ldb_vpp_v_re
    ,output logic                  rf_lut_vf_ldb_vpp_v_rclk
    ,output logic                  rf_lut_vf_ldb_vpp_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_ldb_vpp_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_ldb_vpp_v_waddr
    ,output logic                  rf_lut_vf_ldb_vpp_v_we
    ,output logic                  rf_lut_vf_ldb_vpp_v_wclk
    ,output logic                  rf_lut_vf_ldb_vpp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_ldb_vpp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_ldb_vpp_v_rdata

    ,output logic                  rf_lut_vf_ldb_vqid2qid_re
    ,output logic                  rf_lut_vf_ldb_vqid2qid_rclk
    ,output logic                  rf_lut_vf_ldb_vqid2qid_rclk_rst_n
    ,output logic [(       7)-1:0] rf_lut_vf_ldb_vqid2qid_raddr
    ,output logic [(       7)-1:0] rf_lut_vf_ldb_vqid2qid_waddr
    ,output logic                  rf_lut_vf_ldb_vqid2qid_we
    ,output logic                  rf_lut_vf_ldb_vqid2qid_wclk
    ,output logic                  rf_lut_vf_ldb_vqid2qid_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_vf_ldb_vqid2qid_wdata
    ,input  logic [(      27)-1:0] rf_lut_vf_ldb_vqid2qid_rdata

    ,output logic                  rf_lut_vf_ldb_vqid_v_re
    ,output logic                  rf_lut_vf_ldb_vqid_v_rclk
    ,output logic                  rf_lut_vf_ldb_vqid_v_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_vf_ldb_vqid_v_raddr
    ,output logic [(       5)-1:0] rf_lut_vf_ldb_vqid_v_waddr
    ,output logic                  rf_lut_vf_ldb_vqid_v_we
    ,output logic                  rf_lut_vf_ldb_vqid_v_wclk
    ,output logic                  rf_lut_vf_ldb_vqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_ldb_vqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_ldb_vqid_v_rdata

    ,output logic                  rf_msix_tbl_word0_re
    ,output logic                  rf_msix_tbl_word0_rclk
    ,output logic                  rf_msix_tbl_word0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word0_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word0_waddr
    ,output logic                  rf_msix_tbl_word0_we
    ,output logic                  rf_msix_tbl_word0_wclk
    ,output logic                  rf_msix_tbl_word0_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word0_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word0_rdata

    ,output logic                  rf_msix_tbl_word1_re
    ,output logic                  rf_msix_tbl_word1_rclk
    ,output logic                  rf_msix_tbl_word1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word1_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word1_waddr
    ,output logic                  rf_msix_tbl_word1_we
    ,output logic                  rf_msix_tbl_word1_wclk
    ,output logic                  rf_msix_tbl_word1_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word1_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word1_rdata

    ,output logic                  rf_msix_tbl_word2_re
    ,output logic                  rf_msix_tbl_word2_rclk
    ,output logic                  rf_msix_tbl_word2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word2_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word2_waddr
    ,output logic                  rf_msix_tbl_word2_we
    ,output logic                  rf_msix_tbl_word2_wclk
    ,output logic                  rf_msix_tbl_word2_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word2_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word2_rdata

    ,output logic                  rf_sch_out_fifo_re
    ,output logic                  rf_sch_out_fifo_rclk
    ,output logic                  rf_sch_out_fifo_rclk_rst_n
    ,output logic [(       7)-1:0] rf_sch_out_fifo_raddr
    ,output logic [(       7)-1:0] rf_sch_out_fifo_waddr
    ,output logic                  rf_sch_out_fifo_we
    ,output logic                  rf_sch_out_fifo_wclk
    ,output logic                  rf_sch_out_fifo_wclk_rst_n
    ,output logic [(     270)-1:0] rf_sch_out_fifo_wdata
    ,input  logic [(     270)-1:0] rf_sch_out_fifo_rdata

    ,output logic                  sr_rob_mem_re
    ,output logic                  sr_rob_mem_clk
    ,output logic                  sr_rob_mem_clk_rst_n
    ,output logic [(      11)-1:0] sr_rob_mem_addr
    ,output logic                  sr_rob_mem_we
    ,output logic [(     156)-1:0] sr_rob_mem_wdata
    ,input  logic [(     156)-1:0] sr_rob_mem_rdata

// END HQM_MEMPORT_DECL hqm_system_core

);

//-----------------------------------------------------------------------------------------------------
// HCW schedule interface signals from egress to write buffer

logic                                   hcw_sched_out_ready;
logic                                   hcw_sched_out_v;
hqm_system_sch_data_out_t               hcw_sched_out;

// HW agitate control

WB_SCH_OUT_AFULL_AGITATE_CONTROL_t      wb_sch_out_afull_agitate_control;         // SCH_OUT almost full agitate control
IG_HCW_ENQ_AFULL_AGITATE_CONTROL_t      ig_hcw_enq_afull_agitate_control;         // HCW Enqueue almost full agitate control
IG_HCW_ENQ_W_DB_AGITATE_CONTROL_t       ig_hcw_enq_w_db_agitate_control;          // HCW Enqueue W double buffer agitate control
EG_HCW_SCHED_DB_AGITATE_CONTROL_t       eg_hcw_sched_db_agitate_control;
AL_IMS_MSIX_DB_AGITATE_CONTROL_t        al_ims_msix_db_agitate_control;
AL_CWD_ALARM_DB_AGITATE_CONTROL_t       al_cwd_alarm_db_agitate_control;
AL_HQM_ALARM_DB_AGITATE_CONTROL_t       al_hqm_alarm_db_agitate_control;
AL_SIF_ALARM_AFULL_AGITATE_CONTROL_t    al_sif_alarm_afull_agitate_control;

//-----------------------------------------------------------------------------------------------------
// RF Memory Signal Declarations

hqm_system_memi_lut_vf_dir_vpp2pp_t     memi_lut_vf_dir_vpp2pp;
hqm_system_memo_lut_vf_dir_vpp2pp_t     memo_lut_vf_dir_vpp2pp;
hqm_system_memi_lut_vf_ldb_vpp2pp_t     memi_lut_vf_ldb_vpp2pp;
hqm_system_memo_lut_vf_ldb_vpp2pp_t     memo_lut_vf_ldb_vpp2pp;
hqm_system_memi_lut_vf_dir_vpp_v_t      memi_lut_vf_dir_vpp_v;
hqm_system_memo_lut_vf_dir_vpp_v_t      memo_lut_vf_dir_vpp_v;
hqm_system_memi_lut_vf_ldb_vpp_v_t      memi_lut_vf_ldb_vpp_v;
hqm_system_memo_lut_vf_ldb_vpp_v_t      memo_lut_vf_ldb_vpp_v;
hqm_system_memi_lut_dir_pp_v_t          memi_lut_dir_pp_v;
hqm_system_memo_lut_dir_pp_v_t          memo_lut_dir_pp_v;
hqm_system_memi_lut_vf_dir_vqid2qid_t   memi_lut_vf_dir_vqid2qid;
hqm_system_memo_lut_vf_dir_vqid2qid_t   memo_lut_vf_dir_vqid2qid;
hqm_system_memi_lut_vf_ldb_vqid2qid_t   memi_lut_vf_ldb_vqid2qid;
hqm_system_memo_lut_vf_ldb_vqid2qid_t   memo_lut_vf_ldb_vqid2qid;
hqm_system_memi_lut_vf_dir_vqid_v_t     memi_lut_vf_dir_vqid_v;
hqm_system_memo_lut_vf_dir_vqid_v_t     memo_lut_vf_dir_vqid_v;
hqm_system_memi_lut_vf_ldb_vqid_v_t     memi_lut_vf_ldb_vqid_v;
hqm_system_memo_lut_vf_ldb_vqid_v_t     memo_lut_vf_ldb_vqid_v;
hqm_system_memi_lut_dir_pp2vas_t        memi_lut_dir_pp2vas;
hqm_system_memo_lut_dir_pp2vas_t        memo_lut_dir_pp2vas;
hqm_system_memi_lut_ldb_pp2vas_t        memi_lut_ldb_pp2vas;
hqm_system_memo_lut_ldb_pp2vas_t        memo_lut_ldb_pp2vas;
hqm_system_memi_lut_dir_vasqid_v_t      memi_lut_dir_vasqid_v;
hqm_system_memo_lut_dir_vasqid_v_t      memo_lut_dir_vasqid_v;
hqm_system_memi_lut_ldb_vasqid_v_t      memi_lut_ldb_vasqid_v;
hqm_system_memo_lut_ldb_vasqid_v_t      memo_lut_ldb_vasqid_v;

hqm_system_memi_lut_dir_cq_pasid_t      memi_lut_dir_cq_pasid;
hqm_system_memo_lut_dir_cq_pasid_t      memo_lut_dir_cq_pasid;
hqm_system_memi_lut_ldb_cq_pasid_t      memi_lut_ldb_cq_pasid;
hqm_system_memo_lut_ldb_cq_pasid_t      memo_lut_ldb_cq_pasid;
hqm_system_memi_lut_dir_cq_addr_l_t     memi_lut_dir_cq_addr_l;
hqm_system_memo_lut_dir_cq_addr_l_t     memo_lut_dir_cq_addr_l;
hqm_system_memi_lut_ldb_cq_addr_l_t     memi_lut_ldb_cq_addr_l;
hqm_system_memo_lut_ldb_cq_addr_l_t     memo_lut_ldb_cq_addr_l;
hqm_system_memi_lut_dir_cq_addr_u_t     memi_lut_dir_cq_addr_u;
hqm_system_memo_lut_dir_cq_addr_u_t     memo_lut_dir_cq_addr_u;
hqm_system_memi_lut_ldb_cq_addr_u_t     memi_lut_ldb_cq_addr_u;
hqm_system_memo_lut_ldb_cq_addr_u_t     memo_lut_ldb_cq_addr_u;
hqm_system_memi_lut_dir_cq2vf_pf_ro_t   memi_lut_dir_cq2vf_pf_ro;
hqm_system_memo_lut_dir_cq2vf_pf_ro_t   memo_lut_dir_cq2vf_pf_ro;
hqm_system_memi_lut_ldb_cq2vf_pf_ro_t   memi_lut_ldb_cq2vf_pf_ro;
hqm_system_memo_lut_ldb_cq2vf_pf_ro_t   memo_lut_ldb_cq2vf_pf_ro;
hqm_system_memi_lut_ldb_qid2vqid_t      memi_lut_ldb_qid2vqid;
hqm_system_memo_lut_ldb_qid2vqid_t      memo_lut_ldb_qid2vqid;
hqm_system_memi_lut_dir_cq_isr_t        memi_lut_dir_cq_isr;
hqm_system_memo_lut_dir_cq_isr_t        memo_lut_dir_cq_isr;
hqm_system_memi_lut_ldb_cq_isr_t        memi_lut_ldb_cq_isr;
hqm_system_memo_lut_ldb_cq_isr_t        memo_lut_ldb_cq_isr;
hqm_system_memi_lut_dir_cq_ai_addr_l_t  memi_lut_dir_cq_ai_addr_l;
hqm_system_memo_lut_dir_cq_ai_addr_l_t  memo_lut_dir_cq_ai_addr_l;
hqm_system_memi_lut_ldb_cq_ai_addr_l_t  memi_lut_ldb_cq_ai_addr_l;
hqm_system_memo_lut_ldb_cq_ai_addr_l_t  memo_lut_ldb_cq_ai_addr_l;
hqm_system_memi_lut_dir_cq_ai_addr_u_t  memi_lut_dir_cq_ai_addr_u;
hqm_system_memo_lut_dir_cq_ai_addr_u_t  memo_lut_dir_cq_ai_addr_u;
hqm_system_memi_lut_ldb_cq_ai_addr_u_t  memi_lut_ldb_cq_ai_addr_u;
hqm_system_memo_lut_ldb_cq_ai_addr_u_t  memo_lut_ldb_cq_ai_addr_u;
hqm_system_memi_lut_dir_cq_ai_data_t    memi_lut_dir_cq_ai_data;
hqm_system_memo_lut_dir_cq_ai_data_t    memo_lut_dir_cq_ai_data;
hqm_system_memi_lut_ldb_cq_ai_data_t    memi_lut_ldb_cq_ai_data;
hqm_system_memo_lut_ldb_cq_ai_data_t    memo_lut_ldb_cq_ai_data;

hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word0;
hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word0;
hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word1;
hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word1;
hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word2;
hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word2;

hqm_system_memi_hcw_enq_fifo_t          memi_hcw_enq_fifo;
hqm_system_memo_hcw_enq_fifo_t          memo_hcw_enq_fifo;
hqm_system_memi_sch_out_fifo_t          memi_sch_out_fifo;
hqm_system_memo_sch_out_fifo_t          memo_sch_out_fifo;
hqm_system_memi_alarm_vf_synd0_t        memi_alarm_vf_synd0;
hqm_system_memo_alarm_vf_synd0_t        memo_alarm_vf_synd0;
hqm_system_memi_alarm_vf_synd1_t        memi_alarm_vf_synd1;
hqm_system_memo_alarm_vf_synd1_t        memo_alarm_vf_synd1;
hqm_system_memi_alarm_vf_synd2_t        memi_alarm_vf_synd2;
hqm_system_memo_alarm_vf_synd2_t        memo_alarm_vf_synd2;
hqm_system_memi_dir_wb_t                memi_dir_wb0;
hqm_system_memo_dir_wb_t                memo_dir_wb0;
hqm_system_memi_dir_wb_t                memi_dir_wb1;
hqm_system_memo_dir_wb_t                memo_dir_wb1;
hqm_system_memi_dir_wb_t                memi_dir_wb2;
hqm_system_memo_dir_wb_t                memo_dir_wb2;
hqm_system_memi_ldb_wb_t                memi_ldb_wb0;
hqm_system_memo_ldb_wb_t                memo_ldb_wb0;
hqm_system_memi_ldb_wb_t                memi_ldb_wb1;
hqm_system_memo_ldb_wb_t                memo_ldb_wb1;
hqm_system_memi_ldb_wb_t                memi_ldb_wb2;
hqm_system_memo_ldb_wb_t                memo_ldb_wb2;

hqm_system_memi_rob_mem_t               memi_rob_mem;
hqm_system_memo_rob_mem_t               memo_rob_mem;

logic                                   rf_ipar_error;

//-----------------------------------------------------------------------------------------------------
// Map MMIO CFG interfaces to ingress/egress/master interfaces

// These will hook up to the mmio generated RDL decodes.  Tie off outputs until ready to hook them up.

hqm_system_csr_hc_re_t                  cfg_re;
hqm_system_csr_handcoded_t              cfg_we;
logic   [47:0]                          cfg_addr;
hqm_system_csr_hc_reg_write_t           cfg_wdata;

hqm_system_csr_hc_rvalid_t              cfg_rvalid;
hqm_system_csr_hc_wvalid_t              cfg_wvalid;
hqm_system_csr_hc_error_t               cfg_error;
hqm_system_csr_hc_reg_read_t            cfg_rdata;

hqm_msix_mem_hc_re_t                    msix_mem_re;
hqm_msix_mem_handcoded_t                msix_mem_we;
logic   [47:0]                          msix_mem_addr;
hqm_msix_mem_hc_reg_write_t             msix_mem_wdata;

hqm_msix_mem_hc_rvalid_t                msix_mem_rvalid;
hqm_msix_mem_hc_wvalid_t                msix_mem_wvalid;
hqm_msix_mem_hc_error_t                 msix_mem_error;
hqm_msix_mem_hc_reg_read_t              msix_mem_rdata;

hqm_system_ingress_cfg_signal_t         cfg_ingress_re;
hqm_system_ingress_cfg_signal_t         cfg_ingress_we;
logic   [11:0]                          cfg_ingress_addr;
logic   [31:0]                          cfg_ingress_wdata;
hqm_system_ingress_cfg_signal_t         cfg_ingress_rvalid;
hqm_system_ingress_cfg_signal_t         cfg_ingress_wvalid;
hqm_system_ingress_cfg_signal_t         cfg_ingress_error;
logic   [31:0]                          cfg_ingress_rdata;

hqm_system_wb_cfg_signal_t              cfg_wb_re;
hqm_system_wb_cfg_signal_t              cfg_wb_we;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]       cfg_wb_addr;
logic   [31:0]                          cfg_wb_wdata;
hqm_system_wb_cfg_signal_t              cfg_wb_rvalid;
hqm_system_wb_cfg_signal_t              cfg_wb_wvalid;
hqm_system_wb_cfg_signal_t              cfg_wb_error;
logic   [31:0]                          cfg_wb_rdata;

hqm_system_egress_cfg_signal_t          cfg_egress_re;
hqm_system_egress_cfg_signal_t          cfg_egress_we;
logic   [10:0]                          cfg_egress_addr;
logic   [31:0]                          cfg_egress_wdata;
hqm_system_egress_cfg_signal_t          cfg_egress_rvalid;
hqm_system_egress_cfg_signal_t          cfg_egress_wvalid;
hqm_system_egress_cfg_signal_t          cfg_egress_error;
logic   [31:0]                          cfg_egress_rdata;

hqm_system_alarm_cfg_signal_t           cfg_alarm_re;
hqm_system_alarm_cfg_signal_t           cfg_alarm_we;
logic   [6:0]                           cfg_alarm_addr;
logic   [7:0]                           cfg_alarm_addr_msix;
logic   [31:0]                          cfg_alarm_wdata;
logic   [31:0]                          cfg_alarm_wdata_msix;
hqm_system_alarm_cfg_signal_t           cfg_alarm_rvalid;
hqm_system_alarm_cfg_signal_t           cfg_alarm_wvalid;
hqm_system_alarm_cfg_signal_t           cfg_alarm_error;
logic   [31:0]                          cfg_alarm_rdata;

// MSIX
logic [HQM_SYSTEM_NUM_MSIX-1:0]         msix_pba;               // MSIX pending bits
logic [HQM_SYSTEM_NUM_MSIX-1:0]         msix_pba_clear;

logic                                   pwrite_v;
logic   [31:0]                          pwrite_comp;
logic   [31:0]                          pwrite_value;

logic   [6:0]                           sys_alarm_db_status;
logic   [6:0]                           ims_msix_db_status;
logic   [6:0]                           hcw_sched_db_status;
logic   [6:0]                           hcw_enq_db_status;
logic   [6:0]                           hcw_enq_w_db_status;
logic   [6:0]                           cq_occ_db_status;
logic   [6:0]                           phdr_db_status;
logic   [6:0]                           pdata_ms_db_status;
logic   [6:0]                           pdata_ls_db_status;

new_ALARM_DB_STATUS_t                   alarm_db_status;
new_EGRESS_DB_STATUS_t                  egress_db_status;
new_INGRESS_DB_STATUS_t                 ingress_db_status;

new_HCW_ENQ_FIFO_STATUS_t               hcw_enq_fifo_status;
new_HCW_SCH_FIFO_STATUS_t               hcw_sch_fifo_status;
new_SCH_OUT_FIFO_STATUS_t               sch_out_fifo_status;
new_CFG_RX_FIFO_STATUS_t                cfg_rx_fifo_status;
new_CWDI_RX_FIFO_STATUS_t               cwdi_rx_fifo_status;
new_HQM_ALARM_RX_FIFO_STATUS_t          hqm_alarm_rx_fifo_status;
new_SIF_ALARM_FIFO_STATUS_t             sif_alarm_fifo_status;

logic                                   fifo_overflow;
logic                                   fifo_underflow;

logic                                   ingress_idle;
logic                                   egress_idle;
logic                                   wbuf_idle;
logic   [1:0]                           wbuf_appended;
logic                                   alarm_idle;
logic                                   pba_idle;
logic                                   system_local_idle;
logic                                   system_local_idle_q;
logic                                   system_idle_q;
SYS_IDLE_STATUS_t                       sys_idle_status_reg;
new_SYS_IDLE_STATUS_t                   sys_idle_status;
new_ALARM_STATUS_t                      alarm_status;
new_EGRESS_STATUS_t                     egress_status;
new_INGRESS_STATUS_t                    ingress_status;
new_WBUF_STATUS_t                       wbuf_status;
new_WBUF_STATUS2_t                      wbuf_status2;
new_WBUF_DEBUG_t                        wbuf_debug;
logic [83:0]                            cfg_phdr_debug;
logic [511:0]                           cfg_pdata_debug;
logic [153:0]                           hcw_debug_data;

new_ALARM_LUT_PERR_t                    alarm_lut_perr;
new_EGRESS_LUT_ERR_t                    egress_lut_err;
new_INGRESS_LUT_ERR_t                   ingress_lut_err;

ECC_CTL_t                               cfg_ecc_ctl;
PARITY_CTL_t                            cfg_parity_ctl;
INGRESS_ALARM_ENABLE_t                  cfg_ingress_alarm_enable;
SYS_ALARM_INT_ENABLE_t                  cfg_sys_alarm_int_enable;
SYS_ALARM_SB_ECC_INT_ENABLE_t           cfg_sys_alarm_sb_ecc_int_enable;
SYS_ALARM_MB_ECC_INT_ENABLE_t           cfg_sys_alarm_mb_ecc_int_enable;
WRITE_BUFFER_CTL_t                      cfg_write_buffer_ctl;
INGRESS_CTL_t                           cfg_ingress_ctl;
EGRESS_CTL_t                            cfg_egress_ctl;
ALARM_CTL_t                             cfg_alarm_ctl;
CFG_PATCH_CONTROL_t                     cfg_patch_control;

HCW_ENQ_FIFO_CTL_t                      cfg_hcw_enq_fifo_ctl;
SCH_OUT_FIFO_CTL_t                      cfg_sch_out_fifo_ctl;
SIF_ALARM_FIFO_CTL_t                    cfg_sif_alarm_fifo_ctl;

logic                                   cq_occ_int_busy;
logic                                   cq_occ_int_v;
interrupt_w_req_t                       cq_occ_int;

logic                                   ims_msix_w_ready;
logic                                   ims_msix_w_v;
hqm_system_ims_msix_w_t                 ims_msix_w;

logic                                   interrupt_w_req_ready_i;
logic                                   interrupt_w_req_valid_i;
interrupt_w_req_t                       interrupt_w_req_i;

logic                                   cwdi_interrupt_w_req_ready_i;
logic                                   cwdi_interrupt_w_req_valid_i;

logic   [3:0]                           sch_wb_sb_ecc_error;
logic   [3:0]                           sch_wb_mb_ecc_error;
logic   [7:0]                           sch_wb_ecc_syndrome;
logic                                   sch_wb_error;
logic   [7:0]                           sch_wb_error_synd;

logic                                   alarm_int_error;
logic                                   alarm_perr;
logic                                   egress_perr;
logic                                   ingress_perr;

logic                                   cq_addr_overflow_error;
logic   [7:0]                           cq_addr_overflow_syndrome;

logic                                   ingress_alarm_v;
hqm_system_ingress_alarm_t              ingress_alarm;

logic                                   cfg_write_bad_parity;

logic   [4:0]                           ingress_sb_ecc_error;
logic   [2:0]                           ingress_mb_ecc_error;
logic   [23:0]                          ingress_ecc_syndrome;

logic                                   sch_sm_error;
logic   [7:0]                           sch_sm_syndrome;

logic                                   rob_error;
logic   [7:0]                           rob_error_synd;

load_MSIX_ACK_t                         set_msix_ack;
load_ALARM_ERR_t                        set_alarm_err;
load_ALARM_SB_ECC_ERR_t                 set_alarm_sb_ecc_err;
load_ALARM_MB_ECC_ERR_t                 set_alarm_mb_ecc_err;
load_DIR_CQ_63_32_OCC_INT_STATUS_t      set_dir_cq_63_32_occ_int_status;
load_DIR_CQ_31_0_OCC_INT_STATUS_t       set_dir_cq_31_0_occ_int_status;
load_LDB_CQ_63_32_OCC_INT_STATUS_t      set_ldb_cq_63_32_occ_int_status;
load_LDB_CQ_31_0_OCC_INT_STATUS_t       set_ldb_cq_31_0_occ_int_status;

MSIX_ACK_t                              msix_ack;
MSIX_PASSTHROUGH_t                      msix_passthrough;
MSIX_MODE_t                             msix_mode;
ALARM_ERR_t                             alarm_err;
DIR_CQ_63_32_OCC_INT_STATUS_t           dir_cq_63_32_occ_int_status;
DIR_CQ_31_0_OCC_INT_STATUS_t            dir_cq_31_0_occ_int_status;
LDB_CQ_63_32_OCC_INT_STATUS_t           ldb_cq_63_32_occ_int_status;
LDB_CQ_31_0_OCC_INT_STATUS_t            ldb_cq_31_0_occ_int_status;

HQM_SYSTEM_CNT_CTL_t                    hqm_system_cnt_ctl;
logic [21:0] [31:0]                     hqm_system_cnt;

logic   [HQM_SYSTEM_NUM_MSIX-1:0]       msix_synd;

logic                                   unit_cfg_req_write;
logic                                   unit_cfg_req_read;
cfg_req_t                               unit_cfg_req;

logic                                   unit_cfg_rsp_ack;
logic                                   unit_cfg_rsp_err;
logic [31:0]                            unit_cfg_rsp_rdata;

HQM_DIR_PP2VDEV_t [NUM_DIR_PP-1:0]      dir_pp2vdev;
HQM_LDB_PP2VDEV_t [NUM_LDB_PP-1:0]      ldb_pp2vdev;

DIR_PP_ROB_V_t [NUM_DIR_PP-1:0]         dir_pp_rob_v;
LDB_PP_ROB_V_t [NUM_LDB_PP-1:0]         ldb_pp_rob_v;

logic                                   rx_sync_hcw_sched_enable;
logic                                   rx_sync_hcw_sched_idle;
logic                                   rx_sync_cwd_interrupt_enable;
logic                                   rx_sync_cwd_interrupt_idle;
logic                                   rx_sync_hqm_alarm_enable;
logic                                   rx_sync_hqm_alarm_idle;
logic                                   sif_alarm_fifo_enable;
logic                                   sif_alarm_fifo_idle;
logic                                   hqm_enq_fifo_enable;
logic                                   hqm_enq_fifo_idle;

logic                                   hcw_enq_in_sync;

logic                                   pci_cfg_pmsixctl_msie_q;
logic                                   pci_cfg_pmsixctl_fm_q;

logic [2:0]                             sch_sm_drops;
logic [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]     sch_sm_drops_comp;
logic [2:0]                             sch_clr_drops;
logic [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]     sch_clr_drops_comp;

logic                                   sif_alarm_fifo_pop;

aw_alarm_t                              sif_alarm_fifo_pop_data;

logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]     ims_pend;
IMS_PEND_CLEAR_t                        ims_pend_clear;
logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]     ims_mask;

load_ROB_SYNDROME_t                     set_rob_syndrome;
new_ROB_SYNDROME_t                      rob_syndrome;

genvar                                  g;

//-------------------------------------------------------------------------------------------------------------
// Local reset control

logic                                   prim_gated_rst_n;
logic                                   hqm_gated_rst_n;
logic                                   hqm_gated_rst_n_active;
logic                                   hqm_gated_rst_n_done;
logic                                   hqm_inp_gated_rst_n;
logic   [2:0]                           rst_done;

assign hqm_gated_rst_n_done = &rst_done;
hqm_AW_reset_sync_scan i_prim_gated_rst_n (

     .clk                                   (prim_gated_clk)
    ,.rst_n                                 (hqm_inp_gated_rst_b)
    ,.fscan_rstbypen                        (fscan_rstbypen)
    ,.fscan_byprst_b                        (fscan_byprst_b)
    ,.rst_n_sync                            (prim_gated_rst_n)
);


logic rst_prep;
assign rst_prep             = hqm_rst_prep_sys;
assign hqm_gated_rst_n      = hqm_gated_rst_b_sys;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b_sys;

logic hqm_gated_rst_n_start_nc;
assign hqm_gated_rst_n_start_nc = hqm_gated_rst_b_start_sys;
assign hqm_gated_rst_n_active   = hqm_gated_rst_b_active_sys;
assign hqm_gated_rst_b_done_sys = hqm_gated_rst_n_done;

assign system_reset_done = ~hqm_gated_rst_n_active;

//-------------------------------------------------------------------------------------------------------------
// Local clock control

logic           cfg_rx_idle;
logic           cfg_rx_enable;
logic           cfg_idle;
logic           int_idle;

hqm_AW_module_clock_control #(.REQS(6)) i_hqm_AW_module_clock_control (

     .hqm_inp_gated_clk                     (hqm_inp_gated_clk)                     //I: CLK_CTL
    ,.hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n)                   //I: CLK_CTL
    ,.hqm_gated_clk                         (hqm_gated_clk)                         //I: CLK_CTL
    ,.hqm_gated_rst_n                       (hqm_gated_rst_n)                       //I: CLK_CTL

    ,.cfg_co_dly                            ( { 2'd0 , cfg_patch_control.DELAY_CLKOFF_BYPASS , cfg_patch_control.DELAY_CLOCKOFF } )      //I: CLK_CTL
    ,.cfg_co_disable                        ( cfg_patch_control.DISABLE_CLOCKOFF )  //I: CLK_CTL

    ,.hqm_proc_clk_en                       (hqm_proc_clk_en_sys)                   //O: CLK_CTL

    ,.unit_idle_local                       (system_local_idle)                     //I: CLK_CTL
    ,.unit_idle                             (system_idle)                           //O: CLK_CTL



    ,.inp_fifo_empty                        ({cfg_rx_idle                           //I: CLK_CTL
                                             ,rx_sync_hcw_sched_idle                //I: CLK_CTL
                                             ,rx_sync_cwd_interrupt_idle            //I: CLK_CTL
                                             ,rx_sync_hqm_alarm_idle                //I: CLK_CTL
                                             ,sif_alarm_fifo_idle                   //I: CLK_CTL
                                             ,hqm_enq_fifo_idle                     //I: CLK_CTL
                                            })                                      //I: CLK_CTL

    ,.inp_fifo_en                           ({cfg_rx_enable                         //O: CLK_CTL
                                             ,rx_sync_hcw_sched_enable              //O: CLK_CTL
                                             ,rx_sync_cwd_interrupt_enable          //O: CLK_CTL
                                             ,rx_sync_hqm_alarm_enable              //O: CLK_CTL
                                             ,sif_alarm_fifo_enable                 //O: CLK_CTL
                                             ,hqm_enq_fifo_enable                   //O: CLK_CTL
                                            })

    ,.cfg_idle                              (cfg_idle)                              //I: CLK_CTL
    ,.int_idle                              (int_idle)                              //I: CLK_CTL

    ,.rst_prep                              (rst_prep)
    ,.reset_active                          (hqm_gated_rst_n_active)
);

//-------------------------------------------------------------------------------------------------------------
// CFG ring interface

hqm_AW_cfg_ring_top #(

     .NODE_ID                               (1)
    ,.UNIT_ID                               (1)
    ,.UNIT_NUM_TGTS                         (1)
    ,.UNIT_TGT_MAP                          (16'h6000)
    ,.ALWAYS_HITS                           (1)

) i_hqm_AW_cfg_ring_top (

     .hqm_inp_gated_clk                     (hqm_inp_gated_clk)                     //I: CFG_RING
    ,.hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n)                   //I: CFG_RING

    ,.hqm_gated_clk                         (hqm_gated_clk)                         //I: CFG_RING
    ,.hqm_gated_rst_n                       (hqm_gated_rst_n)                       //I: CFG_RING

    ,.rst_prep                              (rst_prep)                              //I: CFG_RING

    ,.cfg_rx_enable                         (cfg_rx_enable)                         //I: CFG_RING

    ,.cfg_rx_fifo_status                    (cfg_rx_fifo_status)                    //O: CFG_RING
    ,.cfg_rx_idle                           (cfg_rx_idle)                           //O: CFG_RING
    ,.cfg_idle                              (cfg_idle)                              //O: CFG_RING

    ,.up_cfg_req_write                      (system_cfg_req_up_write)               //I: CFG_RING
    ,.up_cfg_req_read                       (system_cfg_req_up_read)                //I: CFG_RING
    ,.up_cfg_req                            (system_cfg_req_up)                     //I: CFG_RING
    ,.up_cfg_rsp_ack                        ('0)                                    //I: CFG_RING
    ,.up_cfg_rsp                            ('0)                                    //I: CFG_RING

    ,.down_cfg_req_write                    (system_cfg_req_down_write)             //O: CFG_RING
    ,.down_cfg_req_read                     (system_cfg_req_down_read)              //O: CFG_RING
    ,.down_cfg_req                          (system_cfg_req_down)                   //O: CFG_RING
    ,.down_cfg_rsp_ack                      (system_cfg_rsp_down_ack)               //O: CFG_RING
    ,.down_cfg_rsp                          (system_cfg_rsp_down)                   //O: CFG_RING

    ,.unit_cfg_req_write                    (unit_cfg_req_write)                    //O: CFG_RING
    ,.unit_cfg_req_read                     (unit_cfg_req_read)                     //O: CFG_RING
    ,.unit_cfg_req                          (unit_cfg_req)                          //O: CFG_RING

    ,.unit_cfg_rsp_ack                      (unit_cfg_rsp_ack)                      //I: CFG_RING
    ,.unit_cfg_rsp_err                      (unit_cfg_rsp_err)                      //I: CFG_RING
    ,.unit_cfg_rsp_rdata                    (unit_cfg_rsp_rdata)                    //I: CFG_RING

);

//-------------------------------------------------------------------------------------------------------------
// Convert CFG ring unit interface into CFG req/ack interface for the nebulon generated RTL decode blocks
// for the system_csr and msix_mem register maps.
// Need to latch and hold the cfg request until we get the ack if access takes more than 1 cycle.
// addr[31:28] == 1 indicates system block is the target
// addr[27]    is being used to indicate FEATURE as opposed to OS_W registers
// addr[26:25] must be set to 3 so the CFG ring infrastructure blocks pass the full target/offset values
// addr[24:22] == 0-3 indicates system_csr space (0x0001_0110_XXXX_XXXX_XXXX_XXXX_XXXX_XX00)
// addr[24:22] == 4   indicates msix_mem   space (0x0001_0111_00XX_XXXX_XXXX_XXXX_XXXX_XX00)
// addr[24:22] == 5   indicates func_pf    space (0x0001_0111_01XX_VVVV_XXXX_XXXX_XXXX_XX00)
// addr[24:22] == 6   indicates func_vf    space (0x0001_0111_10XX_VVVV_XXXX_XXXX_XXXX_XX00)
// addr[24:22] == 7   indicates system_csr space (0x0001_0111_11XX_VVVV_XXXX_XXXX_XXXX_XX00)

hqm_rtlgen_pkg_v12::cfg_req_32bit_t     hqm_system_csr_req;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t     hqm_system_csr_ack;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t     hqm_msix_mem_req;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t     hqm_msix_mem_ack;

logic                                   unit_cfg_req_write_q;
logic                                   unit_cfg_req_read_q;
logic                                   any_csr_req;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  unit_cfg_req_write_q <= '0;
  unit_cfg_req_read_q  <= '0;
 end else begin
  unit_cfg_req_write_q <= (unit_cfg_req_write | unit_cfg_req_write_q) & ~unit_cfg_rsp_ack;
  unit_cfg_req_read_q  <= (unit_cfg_req_read  | unit_cfg_req_read_q)  & ~unit_cfg_rsp_ack;
 end
end

assign any_csr_req = |{unit_cfg_req_write, unit_cfg_req_read, unit_cfg_req_write_q, unit_cfg_req_read_q};

always_comb begin

    hqm_system_csr_req  = '0;
    hqm_msix_mem_req    = '0;

    hqm_system_csr_req.valid      = any_csr_req & ((unit_cfg_req.addr.target[12]==1'd0) |    // addr[24]==0
                                                   (unit_cfg_req.addr.target[12:10]==3'd7)); // addr[24]==1 [23:22]=3
    hqm_system_csr_req.opcode[0]  = |{unit_cfg_req_write, unit_cfg_req_write_q};
    hqm_system_csr_req.be         = {4{hqm_system_csr_req.valid}};
    hqm_system_csr_req.data       = unit_cfg_req.wdata;
    hqm_system_csr_req.addr       = {20'd0                                  // addr[47:28]
                                    ,unit_cfg_req.addr.target[15]           // addr[27]
                                    ,2'd0                                   // addr[26:25]
                                    ,unit_cfg_req.addr.target[12:4]         // addr[24:16]
                                    ,unit_cfg_req.addr.offset[13:0]         // addr[15: 2]
                                    ,2'd0                                   // addr[ 1: 0]
                                    };

    hqm_msix_mem_req.valid        = any_csr_req & (unit_cfg_req.addr.target[12:10]==3'd4);  // addr[24]==1 [23:22]=0
    hqm_msix_mem_req.opcode[0]    = |{unit_cfg_req_write, unit_cfg_req_write_q};
    hqm_msix_mem_req.be           = {4{hqm_msix_mem_req.valid}};
    hqm_msix_mem_req.data         = unit_cfg_req.wdata;
    hqm_msix_mem_req.addr         = {20'd0                                  // addr[47:28]
                                    ,1'd0                                   // addr[27]
                                    ,3'd0                                   // addr[26:24]
                                    ,unit_cfg_req.addr.target[11:4]         // addr[23:16]
                                    ,unit_cfg_req.addr.offset[13:0]         // addr[15: 2]
                                    ,2'd0                                   // addr[ 1: 0]
                                    };

    unit_cfg_rsp_ack   = hqm_system_csr_ack.read_valid  | hqm_system_csr_ack.write_valid  |
                         hqm_msix_mem_ack.read_valid    | hqm_msix_mem_ack.write_valid;

    unit_cfg_rsp_err   = hqm_system_csr_ack.read_miss   | hqm_system_csr_ack.write_miss   |
                         hqm_msix_mem_ack.read_miss     | hqm_msix_mem_ack.write_miss;

    unit_cfg_rsp_rdata = (hqm_system_csr_ack.data  & {32{hqm_system_csr_ack.read_valid}})  |
                         (hqm_msix_mem_ack.data    & {32{hqm_msix_mem_ack.read_valid}});

    cfg_addr           = {20'd0                                  // addr[47:28]
                         ,unit_cfg_req.addr.target[15:4]         // addr[27:16]
                         ,unit_cfg_req.addr.offset[13:0]         // addr[15: 2]
                         ,2'd0                                   // addr[ 1: 0]
                         };
    msix_mem_addr      = {20'd0                                  // addr[47:28]
                         ,unit_cfg_req.addr.target[15:4]         // addr[27:16]
                         ,unit_cfg_req.addr.offset[13:0]         // addr[15: 2]
                         ,2'd0                                   // addr[ 1: 0]
                         };
end

//-----------------------------------------------------------------------------------------------------
// msix_mem register map decode generated by nebulon (purely handcoded interface)

hqm_system_msix_mem_wrap i_hqm_system_msix_mem_wrap (

     .hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n)                   //I: MSIX_MEM_WRAP

    ,.hqm_msix_mem_req                      (hqm_msix_mem_req)                      //I: MSIX_MEM_WRAP
    ,.hqm_msix_mem_ack                      (hqm_msix_mem_ack)                      //O: MSIX_MEM_WRAP

    ,.hqm_msix_mem_hc_re                    (msix_mem_re)                           //O: MSIX_MEM_WRAP
    ,.hqm_msix_mem_hc_we                    (msix_mem_we)                           //O: MSIX_MEM_WRAP
    ,.hqm_msix_mem_hc_reg_write             (msix_mem_wdata)                        //O: MSIX_MEM_WRAP

    ,.hqm_msix_mem_hc_rvalid                (msix_mem_rvalid)                       //I: MSIX_MEM_WRAP
    ,.hqm_msix_mem_hc_wvalid                (msix_mem_wvalid)                       //I: MSIX_MEM_WRAP
    ,.hqm_msix_mem_hc_error                 (msix_mem_error)                        //I: MSIX_MEM_WRAP
    ,.hqm_msix_mem_hc_reg_read              (msix_mem_rdata)                        //I: MSIX_MEM_WRAP

    ,.msix_pba                              (msix_pba)                              //I: MSIX_MEM_WRAP

);

//-----------------------------------------------------------------------------------------------------
// system_csr register map decode generated by nebulon (mix of internal regs and handcoded interface)

hqm_system_csr_wrap i_hqm_system_csr_wrap (

     .hqm_inp_gated_clk                     (hqm_inp_gated_clk)                     //I: CSR_WRAP
    ,.hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n)                   //I: CSR_WRAP

    ,.hqm_system_csr_hc_re                  (cfg_re)                                //O: CSR_WRAP
    ,.hqm_system_csr_hc_we                  (cfg_we)                                //O: CSR_WRAP
    ,.hqm_system_csr_hc_reg_write           (cfg_wdata)                             //O: CSR_WRAP

    ,.hqm_system_csr_hc_rvalid              (cfg_rvalid)                            //I: CSR_WRAP
    ,.hqm_system_csr_hc_wvalid              (cfg_wvalid)                            //I: CSR_WRAP
    ,.hqm_system_csr_hc_error               (cfg_error)                             //I: CSR_WRAP
    ,.hqm_system_csr_hc_reg_read            (cfg_rdata)                             //I: CSR_WRAP

    ,.hqm_system_csr_sai_import             ('1)                                    //I: CSR_WRAP

    ,.hqm_system_csr_req                    (hqm_system_csr_req)                    //I: CSR_WRAP
    ,.hqm_system_csr_ack                    (hqm_system_csr_ack)                    //O: CSR_WRAP

    ,.alarm_db_status                       (alarm_db_status)                       //I: CSR_WRAP
    ,.egress_db_status                      (egress_db_status)                      //I: CSR_WRAP
    ,.ingress_db_status                     (ingress_db_status)                     //I: CSR_WRAP

    ,.hcw_enq_fifo_status                   (hcw_enq_fifo_status)                   //I: CSR_WRAP
    ,.hcw_sch_fifo_status                   (hcw_sch_fifo_status)                   //I: CSR_WRAP
    ,.sch_out_fifo_status                   (sch_out_fifo_status)                   //I: CSR_WRAP
    ,.cfg_rx_fifo_status                    (cfg_rx_fifo_status)                    //I: CSR_WRAP
    ,.cwdi_rx_fifo_status                   (cwdi_rx_fifo_status)                   //I: CSR_WRAP
    ,.hqm_alarm_rx_fifo_status              (hqm_alarm_rx_fifo_status)              //I: CSR_WRAP
    ,.sif_alarm_fifo_status                 (sif_alarm_fifo_status)                 //I: CSR_WRAP

    ,.sys_idle_status                       (sys_idle_status)                       //I: CSR_WRAP
    ,.alarm_status                          (alarm_status)                          //I: CSR_WRAP
    ,.egress_status                         (egress_status)                         //I: CSR_WRAP
    ,.ingress_status                        (ingress_status)                        //I: CSR_WRAP
    ,.wbuf_status                           (wbuf_status)                           //I: CSR_WRAP
    ,.wbuf_status2                          (wbuf_status2)                          //I: CSR_WRAP
    ,.wbuf_debug                            (wbuf_debug)                            //I: CSR_WRAP
    ,.cfg_phdr_debug                        (cfg_phdr_debug)                        //I: CSR_WRAP
    ,.cfg_pdata_debug                       (cfg_pdata_debug)                       //I: CSR_WRAP
    ,.hcw_debug_data                        (hcw_debug_data)                        //I: CSR_WRAP

    ,.alarm_lut_perr                        (alarm_lut_perr)                        //I: CSR_WRAP
    ,.egress_lut_err                        (egress_lut_err)                        //I: CSR_WRAP
    ,.ingress_lut_err                       (ingress_lut_err)                       //I: CSR_WRAP

    ,.ecc_ctl                               (cfg_ecc_ctl)                           //O: CSR_WRAP
    ,.parity_ctl                            (cfg_parity_ctl)                        //O: CSR_WRAP
    ,.ingress_alarm_enable                  (cfg_ingress_alarm_enable)              //O: CSR_WRAP
    ,.sys_alarm_int_enable                  (cfg_sys_alarm_int_enable)              //O: CSR_WRAP
    ,.sys_alarm_sb_ecc_int_enable           (cfg_sys_alarm_sb_ecc_int_enable)       //O: CSR_WRAP
    ,.sys_alarm_mb_ecc_int_enable           (cfg_sys_alarm_mb_ecc_int_enable)       //O: CSR_WRAP
    ,.write_buffer_ctl                      (cfg_write_buffer_ctl)                  //O: CSR_WRAP
    ,.ingress_ctl                           (cfg_ingress_ctl)                       //O: CSR_WRAP
    ,.egress_ctl                            (cfg_egress_ctl)                        //O: CSR_WRAP
    ,.alarm_ctl                             (cfg_alarm_ctl)                         //O: CSR_WRAP
    ,.cfg_patch_control                     (cfg_patch_control)                     //O: CSR_WRAP

    ,.hcw_enq_fifo_ctl                      (cfg_hcw_enq_fifo_ctl)                  //O: CSR_WRAP
    ,.sch_out_fifo_ctl                      (cfg_sch_out_fifo_ctl)                  //O: CSR_WRAP
    ,.sif_alarm_fifo_ctl                    (cfg_sif_alarm_fifo_ctl)                //O: CSR_WRAP

    ,.wb_sch_out_afull_agitate_control      (wb_sch_out_afull_agitate_control)      //O: CSR_WRAP
    ,.ig_hcw_enq_afull_agitate_control      (ig_hcw_enq_afull_agitate_control)      //O: CSR_WRAP
    ,.ig_hcw_enq_w_db_agitate_control       (ig_hcw_enq_w_db_agitate_control)       //O: CSR_WRAP
    ,.eg_hcw_sched_db_agitate_control       (eg_hcw_sched_db_agitate_control)       //O: CSR_WRAP
    ,.al_ims_msix_db_agitate_control        (al_ims_msix_db_agitate_control)        //O: CSR_WRAP
    ,.al_cwd_alarm_db_agitate_control       (al_cwd_alarm_db_agitate_control)       //O: CSR_WRAP
    ,.al_sif_alarm_afull_agitate_control    (al_sif_alarm_afull_agitate_control)    //O: CSR_WRAP
    ,.al_hqm_alarm_db_agitate_control       (al_hqm_alarm_db_agitate_control)       //O: CSR_WRAP

    ,.set_msix_ack                          (set_msix_ack)                          //I: CSR_WRAP
    ,.set_alarm_err                         (set_alarm_err)                         //I: CSR_WRAP
    ,.set_alarm_sb_ecc_err                  (set_alarm_sb_ecc_err)                  //I: CSR_WRAP
    ,.set_alarm_mb_ecc_err                  (set_alarm_mb_ecc_err)                  //I: CSR_WRAP
    ,.set_dir_cq_63_32_occ_int_status       (set_dir_cq_63_32_occ_int_status)       //I: CSR_WRAP
    ,.set_dir_cq_31_0_occ_int_status        (set_dir_cq_31_0_occ_int_status)        //I: CSR_WRAP
    ,.set_ldb_cq_63_32_occ_int_status       (set_ldb_cq_63_32_occ_int_status)       //I: CSR_WRAP
    ,.set_ldb_cq_31_0_occ_int_status        (set_ldb_cq_31_0_occ_int_status)        //I: CSR_WRAP

    ,.msix_ack                              (msix_ack)                              //O: CSR_WRAP
    ,.msix_passthrough                      (msix_passthrough)                      //O: CSR_WRAP
    ,.msix_mode                             (msix_mode)                             //O: CSR_WRAP
    ,.msix_pba_clear                        (msix_pba_clear)                        //O: CSR_WRAP
    ,.dir_cq_63_32_occ_int_status           (dir_cq_63_32_occ_int_status)           //O: CSR_WRAP
    ,.dir_cq_31_0_occ_int_status            (dir_cq_31_0_occ_int_status)            //O: CSR_WRAP
    ,.ldb_cq_63_32_occ_int_status           (ldb_cq_63_32_occ_int_status)           //O: CSR_WRAP
    ,.ldb_cq_31_0_occ_int_status            (ldb_cq_31_0_occ_int_status)            //O: CSR_WRAP

    ,.alarm_err                             (alarm_err)                             //O: CSR_WRAP

    ,.sys_idle_status_reg                   (sys_idle_status_reg)                   //O: CSR_WRAP

    ,.hqm_system_cnt_ctl                    (hqm_system_cnt_ctl)                    //O: CSR_WRAP
    ,.hqm_system_cnt                        (hqm_system_cnt)                        //I: CSR_WRAP

    ,.msix_synd                             (msix_synd)                             //I: CSR_WRAP

    ,.dir_pp2vdev                           (dir_pp2vdev)                           //O: CSR_WRAP
    ,.ldb_pp2vdev                           (ldb_pp2vdev)                           //O: CSR_WRAP

    ,.dir_pp_rob_v                          (dir_pp_rob_v)                          //O: CSR_WRAP
    ,.ldb_pp_rob_v                          (ldb_pp_rob_v)                          //O: CSR_WRAP

    // IMS pending and mask

    ,.ims_pend                              (ims_pend)                              //I: CSR_WRAP
    ,.ims_pend_clear                        (ims_pend_clear)                        //O: CSR_WRAP
    ,.ims_mask                              (ims_mask)                              //O: CSR_WRAP

    ,.set_rob_syndrome                      (set_rob_syndrome)                      //I: CSR_WRAP
    ,.rob_syndrome                          (rob_syndrome)                          //I: CSR_WRAP
);

//-------------------------------------------------------------------------------------------------------------
// Register these inputs from hqm_sif for timing

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  pci_cfg_pmsixctl_msie_q <=  '0;
 end else begin
  pci_cfg_pmsixctl_msie_q <=  pci_cfg_pmsixctl_msie;
 end
end


always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
 if (~hqm_inp_gated_rst_n) begin
  pci_cfg_pmsixctl_fm_q   <=  '0;
 end else begin
  pci_cfg_pmsixctl_fm_q   <=  pci_cfg_pmsixctl_fm;
 end
end

//-----------------------------------------------------------------------------------------------------
// Route CFG interfaces to the appropriate blocks

// Only supporting 32b operations, so can just AND-reduce the byte read/write enables

assign cfg_ingress_re.vf_dir_vpp2pp              = &cfg_re.VF_DIR_VPP2PP;
assign cfg_ingress_re.vf_ldb_vpp2pp              = &cfg_re.VF_LDB_VPP2PP;
assign cfg_ingress_re.vf_dir_vpp_v               = &cfg_re.VF_DIR_VPP_V;
assign cfg_ingress_re.vf_ldb_vpp_v               = &cfg_re.VF_LDB_VPP_V;
assign cfg_ingress_re.dir_pp_v                   = &cfg_re.DIR_PP_V;
assign cfg_ingress_re.ldb_pp_v                   = &cfg_re.LDB_PP_V;
assign cfg_ingress_re.vf_dir_vqid2qid            = &cfg_re.VF_DIR_VQID2QID;
assign cfg_ingress_re.vf_ldb_vqid2qid            = &cfg_re.VF_LDB_VQID2QID;
assign cfg_ingress_re.vf_dir_vqid_v              = &cfg_re.VF_DIR_VQID_V;
assign cfg_ingress_re.vf_ldb_vqid_v              = &cfg_re.VF_LDB_VQID_V;
assign cfg_ingress_re.ldb_vasqid_v               = &cfg_re.LDB_VASQID_V;
assign cfg_ingress_re.dir_vasqid_v               = &cfg_re.DIR_VASQID_V;
assign cfg_ingress_re.ldb_pp2vas                 = &cfg_re.LDB_PP2VAS;
assign cfg_ingress_re.dir_pp2vas                 = &cfg_re.DIR_PP2VAS;
assign cfg_ingress_re.ldb_qid_cfg_v              = &cfg_re.LDB_QID_CFG_V;
assign cfg_ingress_re.ldb_qid_its                = &cfg_re.LDB_QID_ITS;
assign cfg_ingress_re.dir_qid_its                = &cfg_re.DIR_QID_ITS;
assign cfg_ingress_re.ldb_qid_v                  = &cfg_re.LDB_QID_V;
assign cfg_ingress_re.dir_qid_v                  = &cfg_re.DIR_QID_V;

assign cfg_wb_re.wb_dir_cq_state                 = &cfg_re.WB_DIR_CQ_STATE;
assign cfg_wb_re.wb_ldb_cq_state                 = &cfg_re.WB_LDB_CQ_STATE;

assign cfg_egress_re.ldb_qid2vqid                = &cfg_re.LDB_QID2VQID;
assign cfg_egress_re.ldb_cq_pasid                = &cfg_re.LDB_CQ_PASID;
assign cfg_egress_re.ldb_cq_addr_l               = &cfg_re.LDB_CQ_ADDR_L;
assign cfg_egress_re.ldb_cq_addr_u               = &cfg_re.LDB_CQ_ADDR_U;
assign cfg_egress_re.ldb_cq2vf_pf_ro             = &cfg_re.LDB_CQ2VF_PF_RO;
assign cfg_egress_re.dir_cq_pasid                = &cfg_re.DIR_CQ_PASID;
assign cfg_egress_re.dir_cq_addr_l               = &cfg_re.DIR_CQ_ADDR_L;
assign cfg_egress_re.dir_cq_addr_u               = &cfg_re.DIR_CQ_ADDR_U;
assign cfg_egress_re.dir_cq2vf_pf_ro             = &cfg_re.DIR_CQ2VF_PF_RO;
assign cfg_egress_re.dir_cq_fmt                  = &cfg_re.DIR_CQ_FMT;

assign cfg_alarm_re.sbe_cnt_0                    = &cfg_re.SBE_CNT_0;
assign cfg_alarm_re.sbe_cnt_1                    = &cfg_re.SBE_CNT_1;
assign cfg_alarm_re.alarm_hw_synd                = &cfg_re.ALARM_HW_SYND;
assign cfg_alarm_re.alarm_pf_synd0               = &cfg_re.ALARM_PF_SYND0;
assign cfg_alarm_re.alarm_pf_synd1               = &cfg_re.ALARM_PF_SYND1;
assign cfg_alarm_re.alarm_pf_synd2               = &cfg_re.ALARM_PF_SYND2;
assign cfg_alarm_re.alarm_vf_synd0               = &cfg_re.ALARM_VF_SYND0;
assign cfg_alarm_re.alarm_vf_synd1               = &cfg_re.ALARM_VF_SYND1;
assign cfg_alarm_re.alarm_vf_synd2               = &cfg_re.ALARM_VF_SYND2;
assign cfg_alarm_re.dir_cq_isr                   = &cfg_re.DIR_CQ_ISR;
assign cfg_alarm_re.ldb_cq_isr                   = &cfg_re.LDB_CQ_ISR;
assign cfg_alarm_re.ai_addr_l                    = &cfg_re.AI_ADDR_L;
assign cfg_alarm_re.ai_addr_u                    = &cfg_re.AI_ADDR_U;
assign cfg_alarm_re.ai_data                      = &cfg_re.AI_DATA;

assign cfg_alarm_re.msg_addr_l                   = &msix_mem_re.MSG_ADDR_L;
assign cfg_alarm_re.msg_addr_u                   = &msix_mem_re.MSG_ADDR_U;
assign cfg_alarm_re.msg_data                     = &msix_mem_re.MSG_DATA;
assign cfg_alarm_re.vector_ctrl                  = &msix_mem_re.VECTOR_CTRL;

assign cfg_ingress_we.vf_dir_vpp2pp              = &cfg_we.VF_DIR_VPP2PP;
assign cfg_ingress_we.vf_ldb_vpp2pp              = &cfg_we.VF_LDB_VPP2PP;
assign cfg_ingress_we.vf_dir_vpp_v               = &cfg_we.VF_DIR_VPP_V;
assign cfg_ingress_we.vf_ldb_vpp_v               = &cfg_we.VF_LDB_VPP_V;
assign cfg_ingress_we.dir_pp_v                   = &cfg_we.DIR_PP_V;
assign cfg_ingress_we.ldb_pp_v                   = &cfg_we.LDB_PP_V;
assign cfg_ingress_we.vf_dir_vqid2qid            = &cfg_we.VF_DIR_VQID2QID;
assign cfg_ingress_we.vf_ldb_vqid2qid            = &cfg_we.VF_LDB_VQID2QID;
assign cfg_ingress_we.vf_dir_vqid_v              = &cfg_we.VF_DIR_VQID_V;
assign cfg_ingress_we.vf_ldb_vqid_v              = &cfg_we.VF_LDB_VQID_V;
assign cfg_ingress_we.ldb_vasqid_v               = &cfg_we.LDB_VASQID_V;
assign cfg_ingress_we.dir_vasqid_v               = &cfg_we.DIR_VASQID_V;
assign cfg_ingress_we.ldb_pp2vas                 = &cfg_we.LDB_PP2VAS;
assign cfg_ingress_we.dir_pp2vas                 = &cfg_we.DIR_PP2VAS;
assign cfg_ingress_we.ldb_qid_cfg_v              = &cfg_we.LDB_QID_CFG_V;
assign cfg_ingress_we.ldb_qid_its                = &cfg_we.LDB_QID_ITS;
assign cfg_ingress_we.dir_qid_its                = &cfg_we.DIR_QID_ITS;
assign cfg_ingress_we.ldb_qid_v                  = &cfg_we.LDB_QID_V;
assign cfg_ingress_we.dir_qid_v                  = &cfg_we.DIR_QID_V;

assign cfg_wb_we.wb_dir_cq_state                 = &cfg_we.WB_DIR_CQ_STATE;
assign cfg_wb_we.wb_ldb_cq_state                 = &cfg_we.WB_LDB_CQ_STATE;

assign cfg_egress_we.ldb_qid2vqid                = &cfg_we.LDB_QID2VQID;
assign cfg_egress_we.ldb_cq_pasid                = &cfg_we.LDB_CQ_PASID;
assign cfg_egress_we.ldb_cq_addr_l               = &cfg_we.LDB_CQ_ADDR_L;
assign cfg_egress_we.ldb_cq_addr_u               = &cfg_we.LDB_CQ_ADDR_U;
assign cfg_egress_we.ldb_cq2vf_pf_ro             = &cfg_we.LDB_CQ2VF_PF_RO;
assign cfg_egress_we.dir_cq_pasid                = &cfg_we.DIR_CQ_PASID;
assign cfg_egress_we.dir_cq_addr_l               = &cfg_we.DIR_CQ_ADDR_L;
assign cfg_egress_we.dir_cq_addr_u               = &cfg_we.DIR_CQ_ADDR_U;
assign cfg_egress_we.dir_cq2vf_pf_ro             = &cfg_we.DIR_CQ2VF_PF_RO;
assign cfg_egress_we.dir_cq_fmt                  = &cfg_we.DIR_CQ_FMT;

assign cfg_alarm_we.sbe_cnt_0                    = &cfg_we.SBE_CNT_0;
assign cfg_alarm_we.sbe_cnt_1                    = &cfg_we.SBE_CNT_1;
assign cfg_alarm_we.alarm_hw_synd                = &cfg_we.ALARM_HW_SYND;
assign cfg_alarm_we.alarm_pf_synd0               = &cfg_we.ALARM_PF_SYND0;
assign cfg_alarm_we.alarm_pf_synd1               = &cfg_we.ALARM_PF_SYND1;
assign cfg_alarm_we.alarm_pf_synd2               = &cfg_we.ALARM_PF_SYND2;
assign cfg_alarm_we.alarm_vf_synd0               = &cfg_we.ALARM_VF_SYND0;
assign cfg_alarm_we.alarm_vf_synd1               = &cfg_we.ALARM_VF_SYND1;
assign cfg_alarm_we.alarm_vf_synd2               = &cfg_we.ALARM_VF_SYND2;
assign cfg_alarm_we.dir_cq_isr                   = &cfg_we.DIR_CQ_ISR;
assign cfg_alarm_we.ldb_cq_isr                   = &cfg_we.LDB_CQ_ISR;
assign cfg_alarm_we.ai_addr_l                    = &cfg_we.AI_ADDR_L;
assign cfg_alarm_we.ai_addr_u                    = &cfg_we.AI_ADDR_U;
assign cfg_alarm_we.ai_data                      = &cfg_we.AI_DATA;

assign cfg_alarm_we.msg_addr_l                   = &msix_mem_we.MSG_ADDR_L;
assign cfg_alarm_we.msg_addr_u                   = &msix_mem_we.MSG_ADDR_U;
assign cfg_alarm_we.msg_data                     = &msix_mem_we.MSG_DATA;
assign cfg_alarm_we.vector_ctrl                  = &msix_mem_we.VECTOR_CTRL;

// Only need the correct bits from the full address

assign cfg_ingress_addr                          = cfg_addr[23:12];
assign cfg_egress_addr                           = cfg_addr[22:12];
assign cfg_alarm_addr                            = cfg_addr[18:12];
assign cfg_wb_addr                               = cfg_addr[12 +: HQM_SYSTEM_CQ_WIDTH];

assign cfg_alarm_addr_msix                       = msix_mem_addr[11:4];

// All the wdata copies are the same, so can just pick one of them for each interface

assign cfg_ingress_wdata                         = cfg_wdata.VF_DIR_VPP_V;
assign cfg_egress_wdata                          = cfg_wdata.VF_DIR_VPP_V;
assign cfg_alarm_wdata                           = cfg_wdata.VF_DIR_VPP_V;
assign cfg_wb_wdata                              = cfg_wdata.WB_DIR_CQ_STATE;

assign cfg_alarm_wdata_msix                      = msix_mem_wdata.MSG_ADDR_L;

// rvalid/wvalid are a one-to-one mapping

assign cfg_rvalid.VF_DIR_VPP2PP                  = cfg_ingress_rvalid.vf_dir_vpp2pp;
assign cfg_rvalid.VF_LDB_VPP2PP                  = cfg_ingress_rvalid.vf_ldb_vpp2pp;
assign cfg_rvalid.VF_DIR_VPP_V                   = cfg_ingress_rvalid.vf_dir_vpp_v;
assign cfg_rvalid.VF_LDB_VPP_V                   = cfg_ingress_rvalid.vf_ldb_vpp_v;
assign cfg_rvalid.DIR_PP_V                       = cfg_ingress_rvalid.dir_pp_v;
assign cfg_rvalid.LDB_PP_V                       = cfg_ingress_rvalid.ldb_pp_v;
assign cfg_rvalid.VF_DIR_VQID2QID                = cfg_ingress_rvalid.vf_dir_vqid2qid;
assign cfg_rvalid.VF_LDB_VQID2QID                = cfg_ingress_rvalid.vf_ldb_vqid2qid;
assign cfg_rvalid.VF_DIR_VQID_V                  = cfg_ingress_rvalid.vf_dir_vqid_v;
assign cfg_rvalid.VF_LDB_VQID_V                  = cfg_ingress_rvalid.vf_ldb_vqid_v;
assign cfg_rvalid.LDB_VASQID_V                   = cfg_ingress_rvalid.ldb_vasqid_v;
assign cfg_rvalid.DIR_VASQID_V                   = cfg_ingress_rvalid.dir_vasqid_v;
assign cfg_rvalid.LDB_PP2VAS                     = cfg_ingress_rvalid.ldb_pp2vas;
assign cfg_rvalid.DIR_PP2VAS                     = cfg_ingress_rvalid.dir_pp2vas;
assign cfg_rvalid.LDB_QID_CFG_V                  = cfg_ingress_rvalid.ldb_qid_cfg_v;
assign cfg_rvalid.LDB_QID_ITS                    = cfg_ingress_rvalid.ldb_qid_its;
assign cfg_rvalid.DIR_QID_ITS                    = cfg_ingress_rvalid.dir_qid_its;
assign cfg_rvalid.LDB_QID_V                      = cfg_ingress_rvalid.ldb_qid_v;
assign cfg_rvalid.DIR_QID_V                      = cfg_ingress_rvalid.dir_qid_v;

assign cfg_rvalid.WB_DIR_CQ_STATE                = cfg_wb_rvalid.wb_dir_cq_state;
assign cfg_rvalid.WB_LDB_CQ_STATE                = cfg_wb_rvalid.wb_ldb_cq_state;

assign cfg_rvalid.LDB_QID2VQID                   = cfg_egress_rvalid.ldb_qid2vqid;
assign cfg_rvalid.LDB_CQ_PASID                   = cfg_egress_rvalid.ldb_cq_pasid;
assign cfg_rvalid.LDB_CQ_ADDR_L                  = cfg_egress_rvalid.ldb_cq_addr_l;
assign cfg_rvalid.LDB_CQ_ADDR_U                  = cfg_egress_rvalid.ldb_cq_addr_u;
assign cfg_rvalid.LDB_CQ2VF_PF_RO                = cfg_egress_rvalid.ldb_cq2vf_pf_ro;
assign cfg_rvalid.DIR_CQ_PASID                   = cfg_egress_rvalid.dir_cq_pasid;
assign cfg_rvalid.DIR_CQ_ADDR_L                  = cfg_egress_rvalid.dir_cq_addr_l;
assign cfg_rvalid.DIR_CQ_ADDR_U                  = cfg_egress_rvalid.dir_cq_addr_u;
assign cfg_rvalid.DIR_CQ2VF_PF_RO                = cfg_egress_rvalid.dir_cq2vf_pf_ro;
assign cfg_rvalid.DIR_CQ_FMT                     = cfg_egress_rvalid.dir_cq_fmt;

assign cfg_rvalid.SBE_CNT_0                      = cfg_alarm_rvalid.sbe_cnt_0;
assign cfg_rvalid.SBE_CNT_1                      = cfg_alarm_rvalid.sbe_cnt_1;
assign cfg_rvalid.ALARM_HW_SYND                  = cfg_alarm_rvalid.alarm_hw_synd;
assign cfg_rvalid.ALARM_PF_SYND0                 = cfg_alarm_rvalid.alarm_pf_synd0;
assign cfg_rvalid.ALARM_PF_SYND1                 = cfg_alarm_rvalid.alarm_pf_synd1;
assign cfg_rvalid.ALARM_PF_SYND2                 = cfg_alarm_rvalid.alarm_pf_synd2;
assign cfg_rvalid.ALARM_VF_SYND0                 = cfg_alarm_rvalid.alarm_vf_synd0;
assign cfg_rvalid.ALARM_VF_SYND1                 = cfg_alarm_rvalid.alarm_vf_synd1;
assign cfg_rvalid.ALARM_VF_SYND2                 = cfg_alarm_rvalid.alarm_vf_synd2;
assign cfg_rvalid.DIR_CQ_ISR                     = cfg_alarm_rvalid.dir_cq_isr;
assign cfg_rvalid.LDB_CQ_ISR                     = cfg_alarm_rvalid.ldb_cq_isr;
assign cfg_rvalid.AI_ADDR_L                      = cfg_alarm_rvalid.ai_addr_l;
assign cfg_rvalid.AI_ADDR_U                      = cfg_alarm_rvalid.ai_addr_u;
assign cfg_rvalid.AI_DATA                        = cfg_alarm_rvalid.ai_data;

assign msix_mem_rvalid.MSG_ADDR_L                = cfg_alarm_rvalid.msg_addr_l;
assign msix_mem_rvalid.MSG_ADDR_U                = cfg_alarm_rvalid.msg_addr_u;
assign msix_mem_rvalid.MSG_DATA                  = cfg_alarm_rvalid.msg_data;
assign msix_mem_rvalid.VECTOR_CTRL               = cfg_alarm_rvalid.vector_ctrl;

assign cfg_wvalid.VF_DIR_VPP2PP                  = cfg_ingress_wvalid.vf_dir_vpp2pp;
assign cfg_wvalid.VF_LDB_VPP2PP                  = cfg_ingress_wvalid.vf_ldb_vpp2pp;
assign cfg_wvalid.VF_DIR_VPP_V                   = cfg_ingress_wvalid.vf_dir_vpp_v;
assign cfg_wvalid.VF_LDB_VPP_V                   = cfg_ingress_wvalid.vf_ldb_vpp_v;
assign cfg_wvalid.DIR_PP_V                       = cfg_ingress_wvalid.dir_pp_v;
assign cfg_wvalid.LDB_PP_V                       = cfg_ingress_wvalid.ldb_pp_v;
assign cfg_wvalid.VF_DIR_VQID2QID                = cfg_ingress_wvalid.vf_dir_vqid2qid;
assign cfg_wvalid.VF_LDB_VQID2QID                = cfg_ingress_wvalid.vf_ldb_vqid2qid;
assign cfg_wvalid.VF_DIR_VQID_V                  = cfg_ingress_wvalid.vf_dir_vqid_v;
assign cfg_wvalid.VF_LDB_VQID_V                  = cfg_ingress_wvalid.vf_ldb_vqid_v;
assign cfg_wvalid.LDB_VASQID_V                   = cfg_ingress_wvalid.ldb_vasqid_v;
assign cfg_wvalid.DIR_VASQID_V                   = cfg_ingress_wvalid.dir_vasqid_v;
assign cfg_wvalid.LDB_PP2VAS                     = cfg_ingress_wvalid.ldb_pp2vas;
assign cfg_wvalid.DIR_PP2VAS                     = cfg_ingress_wvalid.dir_pp2vas;
assign cfg_wvalid.LDB_QID_CFG_V                  = cfg_ingress_wvalid.ldb_qid_cfg_v;
assign cfg_wvalid.LDB_QID_ITS                    = cfg_ingress_wvalid.ldb_qid_its;
assign cfg_wvalid.DIR_QID_ITS                    = cfg_ingress_wvalid.dir_qid_its;
assign cfg_wvalid.LDB_QID_V                      = cfg_ingress_wvalid.ldb_qid_v;
assign cfg_wvalid.DIR_QID_V                      = cfg_ingress_wvalid.dir_qid_v;

assign cfg_wvalid.WB_DIR_CQ_STATE                = cfg_wb_wvalid.wb_dir_cq_state;
assign cfg_wvalid.WB_LDB_CQ_STATE                = cfg_wb_wvalid.wb_ldb_cq_state;

assign cfg_wvalid.LDB_QID2VQID                   = cfg_egress_wvalid.ldb_qid2vqid;
assign cfg_wvalid.LDB_CQ_PASID                   = cfg_egress_wvalid.ldb_cq_pasid;
assign cfg_wvalid.LDB_CQ_ADDR_L                  = cfg_egress_wvalid.ldb_cq_addr_l;
assign cfg_wvalid.LDB_CQ_ADDR_U                  = cfg_egress_wvalid.ldb_cq_addr_u;
assign cfg_wvalid.LDB_CQ2VF_PF_RO                = cfg_egress_wvalid.ldb_cq2vf_pf_ro;
assign cfg_wvalid.DIR_CQ_PASID                   = cfg_egress_wvalid.dir_cq_pasid;
assign cfg_wvalid.DIR_CQ_ADDR_L                  = cfg_egress_wvalid.dir_cq_addr_l;
assign cfg_wvalid.DIR_CQ_ADDR_U                  = cfg_egress_wvalid.dir_cq_addr_u;
assign cfg_wvalid.DIR_CQ2VF_PF_RO                = cfg_egress_wvalid.dir_cq2vf_pf_ro;
assign cfg_wvalid.DIR_CQ_FMT                     = cfg_egress_wvalid.dir_cq_fmt;

assign cfg_wvalid.SBE_CNT_0                      = cfg_alarm_wvalid.sbe_cnt_0;
assign cfg_wvalid.SBE_CNT_1                      = cfg_alarm_wvalid.sbe_cnt_1;
assign cfg_wvalid.ALARM_HW_SYND                  = cfg_alarm_wvalid.alarm_hw_synd;
assign cfg_wvalid.ALARM_PF_SYND0                 = cfg_alarm_wvalid.alarm_pf_synd0;
assign cfg_wvalid.ALARM_PF_SYND1                 = cfg_alarm_wvalid.alarm_pf_synd1;
assign cfg_wvalid.ALARM_PF_SYND2                 = cfg_alarm_wvalid.alarm_pf_synd2;
assign cfg_wvalid.ALARM_VF_SYND0                 = cfg_alarm_wvalid.alarm_vf_synd0;
assign cfg_wvalid.ALARM_VF_SYND1                 = cfg_alarm_wvalid.alarm_vf_synd1;
assign cfg_wvalid.ALARM_VF_SYND2                 = cfg_alarm_wvalid.alarm_vf_synd2;
assign cfg_wvalid.DIR_CQ_ISR                     = cfg_alarm_wvalid.dir_cq_isr;
assign cfg_wvalid.LDB_CQ_ISR                     = cfg_alarm_wvalid.ldb_cq_isr;
assign cfg_wvalid.AI_ADDR_L                      = cfg_alarm_wvalid.ai_addr_l;
assign cfg_wvalid.AI_ADDR_U                      = cfg_alarm_wvalid.ai_addr_u;
assign cfg_wvalid.AI_DATA                        = cfg_alarm_wvalid.ai_data;

assign msix_mem_wvalid.MSG_ADDR_L                = cfg_alarm_wvalid.msg_addr_l;
assign msix_mem_wvalid.MSG_ADDR_U                = cfg_alarm_wvalid.msg_addr_u;
assign msix_mem_wvalid.MSG_DATA                  = cfg_alarm_wvalid.msg_data;
assign msix_mem_wvalid.VECTOR_CTRL               = cfg_alarm_wvalid.vector_ctrl;

assign cfg_error.VF_DIR_VPP2PP                   = cfg_ingress_error.vf_dir_vpp2pp;
assign cfg_error.VF_LDB_VPP2PP                   = cfg_ingress_error.vf_ldb_vpp2pp;
assign cfg_error.VF_DIR_VPP_V                    = cfg_ingress_error.vf_dir_vpp_v;
assign cfg_error.VF_LDB_VPP_V                    = cfg_ingress_error.vf_ldb_vpp_v;
assign cfg_error.DIR_PP_V                        = cfg_ingress_error.dir_pp_v;
assign cfg_error.LDB_PP_V                        = cfg_ingress_error.ldb_pp_v;
assign cfg_error.VF_DIR_VQID2QID                 = cfg_ingress_error.vf_dir_vqid2qid;
assign cfg_error.VF_LDB_VQID2QID                 = cfg_ingress_error.vf_ldb_vqid2qid;
assign cfg_error.VF_DIR_VQID_V                   = cfg_ingress_error.vf_dir_vqid_v;
assign cfg_error.VF_LDB_VQID_V                   = cfg_ingress_error.vf_ldb_vqid_v;
assign cfg_error.LDB_VASQID_V                    = cfg_ingress_error.ldb_vasqid_v;
assign cfg_error.DIR_VASQID_V                    = cfg_ingress_error.dir_vasqid_v;
assign cfg_error.LDB_PP2VAS                      = cfg_ingress_error.ldb_pp2vas;
assign cfg_error.DIR_PP2VAS                      = cfg_ingress_error.dir_pp2vas;
assign cfg_error.LDB_QID_CFG_V                   = cfg_ingress_error.ldb_qid_cfg_v;
assign cfg_error.LDB_QID_ITS                     = cfg_ingress_error.ldb_qid_its;
assign cfg_error.DIR_QID_ITS                     = cfg_ingress_error.dir_qid_its;
assign cfg_error.LDB_QID_V                       = cfg_ingress_error.ldb_qid_v;
assign cfg_error.DIR_QID_V                       = cfg_ingress_error.dir_qid_v;

assign cfg_error.WB_DIR_CQ_STATE                 = cfg_wb_error.wb_dir_cq_state;
assign cfg_error.WB_LDB_CQ_STATE                 = cfg_wb_error.wb_ldb_cq_state;

assign cfg_error.LDB_QID2VQID                    = cfg_egress_error.ldb_qid2vqid;
assign cfg_error.LDB_CQ_PASID                    = cfg_egress_error.ldb_cq_pasid;
assign cfg_error.LDB_CQ_ADDR_L                   = cfg_egress_error.ldb_cq_addr_l;
assign cfg_error.LDB_CQ_ADDR_U                   = cfg_egress_error.ldb_cq_addr_u;
assign cfg_error.LDB_CQ2VF_PF_RO                 = cfg_egress_error.ldb_cq2vf_pf_ro;
assign cfg_error.DIR_CQ_PASID                    = cfg_egress_error.dir_cq_pasid;
assign cfg_error.DIR_CQ_ADDR_L                   = cfg_egress_error.dir_cq_addr_l;
assign cfg_error.DIR_CQ_ADDR_U                   = cfg_egress_error.dir_cq_addr_u;
assign cfg_error.DIR_CQ2VF_PF_RO                 = cfg_egress_error.dir_cq2vf_pf_ro;
assign cfg_error.DIR_CQ_FMT                      = cfg_egress_error.dir_cq_fmt;

assign cfg_error.SBE_CNT_0                       = cfg_alarm_error.sbe_cnt_0;
assign cfg_error.SBE_CNT_1                       = cfg_alarm_error.sbe_cnt_1;
assign cfg_error.ALARM_HW_SYND                   = cfg_alarm_error.alarm_hw_synd;
assign cfg_error.ALARM_PF_SYND0                  = cfg_alarm_error.alarm_pf_synd0;
assign cfg_error.ALARM_PF_SYND1                  = cfg_alarm_error.alarm_pf_synd1;
assign cfg_error.ALARM_PF_SYND2                  = cfg_alarm_error.alarm_pf_synd2;
assign cfg_error.ALARM_VF_SYND0                  = cfg_alarm_error.alarm_vf_synd0;
assign cfg_error.ALARM_VF_SYND1                  = cfg_alarm_error.alarm_vf_synd1;
assign cfg_error.ALARM_VF_SYND2                  = cfg_alarm_error.alarm_vf_synd2;
assign cfg_error.DIR_CQ_ISR                      = cfg_alarm_error.dir_cq_isr;
assign cfg_error.LDB_CQ_ISR                      = cfg_alarm_error.ldb_cq_isr;
assign cfg_error.AI_ADDR_L                       = cfg_alarm_error.ai_addr_l;
assign cfg_error.AI_ADDR_U                       = cfg_alarm_error.ai_addr_u;
assign cfg_error.AI_DATA                         = cfg_alarm_error.ai_data;

assign msix_mem_error.MSG_ADDR_L                 = cfg_alarm_error.msg_addr_l;
assign msix_mem_error.MSG_ADDR_U                 = cfg_alarm_error.msg_addr_u;
assign msix_mem_error.MSG_DATA                   = cfg_alarm_error.msg_data;
assign msix_mem_error.VECTOR_CTRL                = cfg_alarm_error.vector_ctrl;

// Flopping and ORing the rdata internally for timing, so can hook final flopped version
// to all rdata copies

assign cfg_rdata.VF_DIR_VPP2PP                   = cfg_ingress_rdata;
assign cfg_rdata.VF_LDB_VPP2PP                   = cfg_ingress_rdata;
assign cfg_rdata.VF_DIR_VPP_V                    = cfg_ingress_rdata;
assign cfg_rdata.VF_LDB_VPP_V                    = cfg_ingress_rdata;
assign cfg_rdata.DIR_PP_V                        = cfg_ingress_rdata;
assign cfg_rdata.LDB_PP_V                        = cfg_ingress_rdata;
assign cfg_rdata.VF_DIR_VQID2QID                 = cfg_ingress_rdata;
assign cfg_rdata.VF_LDB_VQID2QID                 = cfg_ingress_rdata;
assign cfg_rdata.VF_DIR_VQID_V                   = cfg_ingress_rdata;
assign cfg_rdata.VF_LDB_VQID_V                   = cfg_ingress_rdata;
assign cfg_rdata.LDB_VASQID_V                    = cfg_ingress_rdata;
assign cfg_rdata.DIR_VASQID_V                    = cfg_ingress_rdata;
assign cfg_rdata.LDB_PP2VAS                      = cfg_ingress_rdata;
assign cfg_rdata.DIR_PP2VAS                      = cfg_ingress_rdata;
assign cfg_rdata.LDB_QID_CFG_V                   = cfg_ingress_rdata;
assign cfg_rdata.LDB_QID_ITS                     = cfg_ingress_rdata;
assign cfg_rdata.DIR_QID_ITS                     = cfg_ingress_rdata;
assign cfg_rdata.LDB_QID_V                       = cfg_ingress_rdata;
assign cfg_rdata.DIR_QID_V                       = cfg_ingress_rdata;

assign cfg_rdata.WB_DIR_CQ_STATE                 = cfg_wb_rdata;
assign cfg_rdata.WB_LDB_CQ_STATE                 = cfg_wb_rdata;

assign cfg_rdata.LDB_QID2VQID                    = cfg_egress_rdata;
assign cfg_rdata.LDB_CQ_PASID                    = cfg_egress_rdata;
assign cfg_rdata.LDB_CQ_ADDR_L                   = cfg_egress_rdata;
assign cfg_rdata.LDB_CQ_ADDR_U                   = cfg_egress_rdata;
assign cfg_rdata.LDB_CQ2VF_PF_RO                 = cfg_egress_rdata;
assign cfg_rdata.DIR_CQ_PASID                    = cfg_egress_rdata;
assign cfg_rdata.DIR_CQ_ADDR_L                   = cfg_egress_rdata;
assign cfg_rdata.DIR_CQ_ADDR_U                   = cfg_egress_rdata;
assign cfg_rdata.DIR_CQ2VF_PF_RO                 = cfg_egress_rdata;
assign cfg_rdata.DIR_CQ_FMT                      = cfg_egress_rdata;

assign cfg_rdata.SBE_CNT_0                       = cfg_alarm_rdata;
assign cfg_rdata.SBE_CNT_1                       = cfg_alarm_rdata;
assign cfg_rdata.ALARM_HW_SYND                   = cfg_alarm_rdata;
assign cfg_rdata.ALARM_PF_SYND0                  = cfg_alarm_rdata;
assign cfg_rdata.ALARM_PF_SYND1                  = cfg_alarm_rdata;
assign cfg_rdata.ALARM_PF_SYND2                  = cfg_alarm_rdata;
assign cfg_rdata.ALARM_VF_SYND0                  = cfg_alarm_rdata;
assign cfg_rdata.ALARM_VF_SYND1                  = cfg_alarm_rdata;
assign cfg_rdata.ALARM_VF_SYND2                  = cfg_alarm_rdata;
assign cfg_rdata.DIR_CQ_ISR                      = cfg_alarm_rdata;
assign cfg_rdata.LDB_CQ_ISR                      = cfg_alarm_rdata;
assign cfg_rdata.AI_ADDR_L                       = cfg_alarm_rdata;
assign cfg_rdata.AI_ADDR_U                       = cfg_alarm_rdata;
assign cfg_rdata.AI_DATA                         = cfg_alarm_rdata;

assign msix_mem_rdata.MSG_ADDR_L                 = cfg_alarm_rdata;
assign msix_mem_rdata.MSG_ADDR_U                 = cfg_alarm_rdata;
assign msix_mem_rdata.MSG_DATA                   = cfg_alarm_rdata;
assign msix_mem_rdata.VECTOR_CTRL                = cfg_alarm_rdata;

hqm_AW_unused_bits i_unused_csr (       

    .a  (|{cfg_wdata.VF_DIR_VPP2PP
          ,cfg_wdata.VF_LDB_VPP2PP
          ,cfg_wdata.VF_LDB_VPP_V
          ,cfg_wdata.DIR_PP_V
          ,cfg_wdata.LDB_PP_V
          ,cfg_wdata.VF_DIR_VQID2QID
          ,cfg_wdata.VF_LDB_VQID2QID
          ,cfg_wdata.VF_DIR_VQID_V
          ,cfg_wdata.VF_LDB_VQID_V
          ,cfg_wdata.LDB_VASQID_V
          ,cfg_wdata.DIR_VASQID_V
          ,cfg_wdata.LDB_PP2VAS
          ,cfg_wdata.DIR_PP2VAS
          ,cfg_wdata.LDB_QID_CFG_V
          ,cfg_wdata.LDB_QID_ITS
          ,cfg_wdata.DIR_QID_ITS
          ,cfg_wdata.LDB_QID_V
          ,cfg_wdata.DIR_QID_V
          ,cfg_wdata.LDB_QID2VQID
          ,cfg_wdata.LDB_CQ_PASID
          ,cfg_wdata.LDB_CQ_ADDR_L
          ,cfg_wdata.LDB_CQ_ADDR_U
          ,cfg_wdata.LDB_CQ2VF_PF_RO
          ,cfg_wdata.DIR_CQ_PASID
          ,cfg_wdata.DIR_CQ_ADDR_L
          ,cfg_wdata.DIR_CQ_ADDR_U
          ,cfg_wdata.DIR_CQ2VF_PF_RO
          ,cfg_wdata.DIR_CQ_FMT
          ,cfg_wdata.ALARM_PF_SYND0
          ,cfg_wdata.ALARM_PF_SYND1
          ,cfg_wdata.ALARM_PF_SYND2
          ,cfg_wdata.ALARM_VF_SYND0
          ,cfg_wdata.ALARM_VF_SYND1
          ,cfg_wdata.ALARM_VF_SYND2
          ,cfg_wdata.DIR_CQ_ISR
          ,cfg_wdata.LDB_CQ_ISR
          ,cfg_wdata.AI_ADDR_L
          ,cfg_wdata.AI_ADDR_U
          ,cfg_wdata.AI_DATA
          ,cfg_wdata.AW_SMON_MAXIMUM_TIMER
          ,cfg_wdata.AW_SMON_ACTIVITYCOUNTER1
          ,cfg_wdata.AW_SMON_ACTIVITYCOUNTER0
          ,cfg_wdata.AW_SMON_COMPARE1
          ,cfg_wdata.AW_SMON_COMPARE0
          ,cfg_wdata.AW_SMON_CONFIGURATION1
          ,cfg_wdata.AW_SMON_CONFIGURATION0
          ,cfg_wdata.AW_SMON_COMP_MASK0
          ,cfg_wdata.AW_SMON_COMP_MASK1
          ,cfg_wdata.PERF_SMON_TIMER
          ,cfg_wdata.PERF_SMON_MAXIMUM_TIMER
          ,cfg_wdata.PERF_SMON_ACTIVITYCOUNTER1
          ,cfg_wdata.PERF_SMON_ACTIVITYCOUNTER0
          ,cfg_wdata.PERF_SMON_COMPARE1
          ,cfg_wdata.PERF_SMON_COMPARE0
          ,cfg_wdata.PERF_SMON_CONFIGURATION1
          ,cfg_wdata.PERF_SMON_CONFIGURATION0
          ,cfg_wdata.PERF_SMON_COMP_MASK0
          ,cfg_wdata.PERF_SMON_COMP_MASK1
          ,cfg_wdata.WB_DIR_CQ_STATE.reserved0
          ,cfg_wdata.WB_LDB_CQ_STATE.reserved0
          ,cfg_wdata.WB_LDB_CQ_STATE.reserved1
          ,msix_mem_wdata.MSG_ADDR_U
          ,msix_mem_wdata.MSG_DATA
          ,msix_mem_wdata.VECTOR_CTRL
          ,cfg_addr[47:24]
          ,cfg_addr[11:7]
          ,cfg_addr[5:0]
          ,msix_mem_addr[47:11]
          ,msix_mem_addr[3:0]
          ,cfg_patch_control.RSVZ0
        })
);

//-----------------------------------------------------------------------------------------------------
// Alarm interrupt interface

assign fifo_overflow = |{hcw_enq_fifo_status.OVRFLOW
                        ,hcw_sch_fifo_status.OVRFLOW
                        ,sch_out_fifo_status.OVRFLOW
                        ,cfg_rx_fifo_status.OVRFLOW
                        ,cwdi_rx_fifo_status.OVRFLOW
                        ,hqm_alarm_rx_fifo_status.OVRFLOW
                        ,sif_alarm_fifo_status.OVRFLOW
};

assign fifo_underflow = |{hcw_enq_fifo_status.UNDFLOW
                         ,hcw_sch_fifo_status.UNDFLOW
                         ,sch_out_fifo_status.UNDFLOW
                         ,cfg_rx_fifo_status.UNDFLOW
                         ,cwdi_rx_fifo_status.UNDFLOW
                         ,hqm_alarm_rx_fifo_status.UNDFLOW
                         ,sif_alarm_fifo_status.UNDFLOW
};

localparam NUM_INF = 1;
localparam NUM_COR = 9;
localparam NUM_UNC = 18;

logic           [NUM_INF-1:0]   sys_alarm_inf_v;
aw_alarm_syn_t  [NUM_INF-1:0]   sys_alarm_inf_data;
logic           [NUM_COR-1:0]   sys_alarm_cor_v;
aw_alarm_syn_t  [NUM_COR-1:0]   sys_alarm_cor_data;
logic           [NUM_UNC-1:0]   sys_alarm_unc_v;
aw_alarm_syn_t  [NUM_UNC-1:0]   sys_alarm_unc_data;

assign sys_alarm_inf_v    = '0;
assign sys_alarm_inf_data = '0;

assign sys_alarm_unc_v    = {rob_error                                                 // 17   0x11
                            ,rf_ipar_error                                             // 16   0x10
                            ,alarm_int_error                                           // 15   0x0f
                            ,sch_wb_error                                              // 14   0x0e
                            ,(fifo_overflow         & ~alarm_err.FIFO_OVERFLOW)        // 13   0x0d
                            ,(fifo_underflow        & ~alarm_err.FIFO_UNDERFLOW)       // 12   0x0c
                            ,sch_sm_error                                              // 11   0x0b
                            ,alarm_perr                                                // 10   0x0a
                            ,egress_perr                                               // 9    0x09
                            ,ingress_perr                                              // 8    0x08
                            ,cq_addr_overflow_error                                    // 7    0x07
                            ,ingress_mb_ecc_error[2]                                   // 6    0x06
                            ,ingress_mb_ecc_error[1]                                   // 5    0x05
                            ,ingress_mb_ecc_error[0]                                   // 4    0x04
                            ,sch_wb_mb_ecc_error[3]                                    // 3    0x03
                            ,sch_wb_mb_ecc_error[2]                                    // 2    0x02
                            ,sch_wb_mb_ecc_error[1]                                    // 1    0x01
                            ,sch_wb_mb_ecc_error[0]                                    // 0    0x00
};

aw_alarm_msix_map_t alarm_msix_map;

assign alarm_msix_map = HQM_ALARM;

assign sys_alarm_unc_data = {// msix_map[2:0], rtype[1:0], rid[7:0]
                             {alarm_msix_map, 2'd0, rob_error_synd}                    // 17
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 16
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 15
                            ,{alarm_msix_map, 2'd0, sch_wb_error_synd}                 // 14
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 13
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 12
                            ,{alarm_msix_map, 2'd0, sch_sm_syndrome}                   // 11
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 10
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 9
                            ,{alarm_msix_map, 2'd0, 8'd0}                              // 8
                            ,{alarm_msix_map, 2'd1, cq_addr_overflow_syndrome}         // 7
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 6
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 5
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 4
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 3
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 2
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 1
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 0
};

assign sys_alarm_cor_v    = {ingress_sb_ecc_error[4]                                   // 8   cls=1 0x08
                            ,ingress_sb_ecc_error[3]                                   // 7   cls=1 0x07
                            ,ingress_sb_ecc_error[2]                                   // 6   cls=1 0x06
                            ,ingress_sb_ecc_error[1]                                   // 5   cls=1 0x05
                            ,ingress_sb_ecc_error[0]                                   // 4   cls=1 0x04
                            ,sch_wb_sb_ecc_error[3]                                    // 3   cls=1 0x03
                            ,sch_wb_sb_ecc_error[2]                                    // 2   cls=1 0x02
                            ,sch_wb_sb_ecc_error[1]                                    // 1   cls=1 0x01
                            ,sch_wb_sb_ecc_error[0]                                    // 0   cls=1 0x00
};

assign sys_alarm_cor_data = {// msix_map[2:0], rtype[1:0], rid[7:0]
                             {alarm_msix_map, 2'd1, ingress_ecc_syndrome[23:16]}       // 8
                            ,{alarm_msix_map, 2'd1, ingress_ecc_syndrome[15: 8]}       // 7
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 6
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 5
                            ,{alarm_msix_map, 2'd0, ingress_ecc_syndrome[7:0]}         // 4
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 3
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 2
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 1
                            ,{alarm_msix_map, 2'd1, sch_wb_ecc_syndrome[ 7:0]}         // 0
};

assign set_alarm_err        = sys_alarm_unc_v[17: 7];
assign set_alarm_mb_ecc_err = sys_alarm_unc_v[ 6: 0];
assign set_alarm_sb_ecc_err = sys_alarm_cor_v[ 8: 0];

assign cfg_write_bad_parity = cfg_parity_ctl.WRITE_BAD_PARITY;

logic           iecor_error_nc;
logic           ieunc_error_nc;

hqm_system_alarm #(

     .NUM_INF                               (NUM_INF)                               //P: ALARM
    ,.NUM_COR                               (NUM_COR)                               //P: ALARM
    ,.NUM_UNC                               (NUM_UNC)                               //P: ALARM
    ,.UNIT_WIDTH                            (4)                                     //P: ALARM

) i_hqm_system_alarm (

     .prim_gated_clk                        (prim_gated_clk)                        //I: ALARM
    ,.prim_gated_rst_n                      (prim_gated_rst_n)                      //I: ALARM

    ,.hqm_gated_clk                         (hqm_gated_clk)                         //I: ALARM
    ,.hqm_gated_rst_n                       (hqm_gated_rst_n)                       //I: ALARM

    ,.hqm_inp_gated_clk                     (hqm_inp_gated_clk)                     //I: ALARM
    ,.hqm_inp_gated_rst_n                   (hqm_inp_gated_rst_n)                   //I: ALARM

    ,.rx_sync_cwd_interrupt_enable          (rx_sync_cwd_interrupt_enable)          //I: ALARM
    ,.rx_sync_hqm_alarm_enable              (rx_sync_hqm_alarm_enable)              //I: ALARM
    ,.sif_alarm_fifo_enable                 (sif_alarm_fifo_enable)                 //I: ALARM

    ,.rx_sync_cwd_interrupt_idle            (rx_sync_cwd_interrupt_idle)            //O: ALARM
    ,.rx_sync_hqm_alarm_idle                (rx_sync_hqm_alarm_idle)                //O: ALARM
    ,.sif_alarm_fifo_idle                   (sif_alarm_fifo_idle)                   //O: ALARM
    ,.pba_idle                              (pba_idle)                              //O: ALARM
    ,.int_idle                              (int_idle)                              //O: ALARM

    ,.rst_prep                              (rst_prep)                              //I: ALARM

    ,.rst_done                              (rst_done[2])                           //O: ALARM

    // CFG interface

    ,.cfg_re                                (cfg_alarm_re)                          //I: ALARM
    ,.cfg_we                                (cfg_alarm_we)                          //I: ALARM
    ,.cfg_addr                              (cfg_alarm_addr)                        //I: ALARM
    ,.cfg_addr_msix                         (cfg_alarm_addr_msix)                   //I: ALARM
    ,.cfg_wdata                             (cfg_alarm_wdata)                       //I: ALARM
    ,.cfg_wdata_msix                        (cfg_alarm_wdata_msix)                  //I: ALARM

    ,.cfg_rvalid                            (cfg_alarm_rvalid)                      //O: ALARM
    ,.cfg_wvalid                            (cfg_alarm_wvalid)                      //O: ALARM
    ,.cfg_error                             (cfg_alarm_error)                       //O: ALARM
    ,.cfg_rdata                             (cfg_alarm_rdata)                       //O: ALARM

    ,.cfg_parity_off                        (cfg_parity_ctl.ALARM_PAR_OFF)          //I: ALARM
    ,.cfg_write_bad_parity                  (cfg_write_bad_parity)                  //I: ALARM
    ,.cfg_inj_par_err_vf_synd               (cfg_parity_ctl.INJ_PAR_ERR_VF_SYND)    //I: ALARM
    ,.cfg_sys_alarm_int_enable              (cfg_sys_alarm_int_enable)              //I: ALARM
    ,.cfg_sys_alarm_sb_ecc_int_enable       (cfg_sys_alarm_sb_ecc_int_enable)       //I: ALARM
    ,.cfg_sys_alarm_mb_ecc_int_enable       (cfg_sys_alarm_mb_ecc_int_enable)       //I: ALARM
    ,.cfg_alarm_ctl                         (cfg_alarm_ctl)                         //I: ALARM
    ,.cfg_msix_pba_clear                    (msix_pba_clear)                        //I: ALARM

    ,.al_ims_msix_db_agitate_control        (al_ims_msix_db_agitate_control)        //I: ALARM
    ,.al_cwd_alarm_db_agitate_control       (al_cwd_alarm_db_agitate_control)       //I: ALARM
    ,.al_hqm_alarm_db_agitate_control       (al_hqm_alarm_db_agitate_control)       //I: ALARM
    ,.al_sif_alarm_afull_agitate_control    (al_sif_alarm_afull_agitate_control)    //I: ALARM

    ,.set_msix_ack                          (set_msix_ack)                          //O: ALARM
    ,.set_dir_cq_63_32_occ_int_status       (set_dir_cq_63_32_occ_int_status)       //O: ALARM
    ,.set_dir_cq_31_0_occ_int_status        (set_dir_cq_31_0_occ_int_status)        //O: ALARM
    ,.set_ldb_cq_63_32_occ_int_status       (set_ldb_cq_63_32_occ_int_status)       //O: ALARM
    ,.set_ldb_cq_31_0_occ_int_status        (set_ldb_cq_31_0_occ_int_status)        //O: ALARM
    ,.msix_ack                              (msix_ack)                              //I: ALARM
    ,.msix_passthrough                      (msix_passthrough)                      //I: ALARM
    ,.msix_mode                             (msix_mode)                             //I: ALARM
    ,.dir_cq_63_32_occ_int_status           (dir_cq_63_32_occ_int_status)           //I: ALARM
    ,.dir_cq_31_0_occ_int_status            (dir_cq_31_0_occ_int_status)            //I: ALARM
    ,.ldb_cq_63_32_occ_int_status           (ldb_cq_63_32_occ_int_status)           //I: ALARM
    ,.ldb_cq_31_0_occ_int_status            (ldb_cq_31_0_occ_int_status)            //I: ALARM

    ,.alarm_int_error                       (alarm_int_error)                       //O: ALARM
    ,.alarm_lut_perr                        (alarm_lut_perr)                        //O: ALARM
    ,.alarm_perr                            (alarm_perr)                            //O: ALARM

    ,.sys_alarm_db_status                   (sys_alarm_db_status)                   //O: ALARM
    ,.ims_msix_db_status                    (ims_msix_db_status)                    //O: ALARM

    ,.cwdi_rx_fifo_status                   (cwdi_rx_fifo_status)                   //O: ALARM
    ,.hqm_alarm_rx_fifo_status              (hqm_alarm_rx_fifo_status)              //O: ALARM
    ,.sif_alarm_fifo_status                 (sif_alarm_fifo_status)                 //O: ALARM

    ,.cfg_sif_alarm_fifo_high_wm            (cfg_sif_alarm_fifo_ctl.HIGH_WM)        //I: ALARM

    ,.alarm_status                          (alarm_status)                          //O: ALARM

    ,.sys_idle_status_reg                   (sys_idle_status_reg)                   //I: ALARM

    ,.alarm_idle                            (alarm_idle)                            //O: ALARM
    ,.system_local_idle                     (system_local_idle)                     //O: ALARM

    ,.msix_synd                             (msix_synd)                             //O: ALARM

    // Internal error indications to ri_err

    ,.iecor_error                           (iecor_error_nc)                        //O: ALARM
    ,.ieunc_error                           (ieunc_error_nc)                        //O: ALARM

    // Vectored CSR Control Signals

    ,.pci_cfg_pmsixctl_msie                 (pci_cfg_pmsixctl_msie_q)               //I: ALARM
    ,.pci_cfg_pmsixctl_fm                   (pci_cfg_pmsixctl_fm_q)                 //I: ALARM

    // MSIX pending bits

    ,.msix_pba                              (msix_pba)                              //O: ALARM

    // System Alarm Interrupt interface

    ,.sys_unit                              (4'd1)                                  //I: ALARM

    ,.sys_alarm_inf_v                       (sys_alarm_inf_v)                       //I: ALARM
    ,.sys_alarm_inf_data                    (sys_alarm_inf_data)                    //I: ALARM

    ,.sys_alarm_cor_v                       (sys_alarm_cor_v)                       //I: ALARM
    ,.sys_alarm_cor_data                    (sys_alarm_cor_data)                    //I: ALARM

    ,.sys_alarm_unc_v                       (sys_alarm_unc_v)                       //I: ALARM
    ,.sys_alarm_unc_data                    (sys_alarm_unc_data)                    //I: ALARM

    // Core Alarm Interrupt interface

    ,.hqm_alarm_ready                       (hqm_alarm_ready)                       //O: ALARM

    ,.hqm_alarm_v                           (hqm_alarm_v)                           //I: ALARM
    ,.hqm_alarm_data                        (hqm_alarm_data)                        //I: ALARM

    // Core Alarm Interrupt interface

    ,.sif_alarm_ready                       (sif_alarm_ready)                       //O: ALARM

    ,.sif_alarm_v                           (sif_alarm_v)                           //I: ALARM
    ,.sif_alarm_data                        (sif_alarm_data)                        //I: ALARM

    ,.sif_alarm_fifo_pop                    (sif_alarm_fifo_pop)                    //O: ALARM
    ,.sif_alarm_fifo_pop_data               (sif_alarm_fifo_pop_data)               //O: ALARM

    // CQ occupany interrupt request from write buffer

    ,.cq_occ_int_busy                       (cq_occ_int_busy)                       //O: ALARM

    ,.cq_occ_int_v                          (cq_occ_int_v)                          //I: ALARM
    ,.cq_occ_int                            (cq_occ_int)                            //I: ALARM

    // Ingress alarm interface

    ,.ingress_alarm_v                       (ingress_alarm_v)                       //I: ALARM
    ,.ingress_alarm                         (ingress_alarm)                         //I: ALARM

    // Watchdog interrupt interface

    ,.cwdi_interrupt_w_req_ready            (cwdi_interrupt_w_req_ready_i)          //O: ALARM

    ,.cwdi_interrupt_w_req_valid            (cwdi_interrupt_w_req_valid_i)          //I: ALARM

    // IMS/MSI-X writes to write buffer

    ,.ims_msix_w_ready                      (ims_msix_w_ready)                      //I: ALARM

    ,.ims_msix_w_v                          (ims_msix_w_v)                          //O: ALARM
    ,.ims_msix_w                            (ims_msix_w)                            //O: ALARM

    // IMS pending and mask

    ,.ims_pend                              (ims_pend)                              //O: ALARM
    ,.ims_pend_clear                        (ims_pend_clear)                        //I: ALARM
    ,.ims_mask                              (ims_mask)                              //I: ALARM

    // Memory interface

    ,.memi_msix_tbl_word0                   (memi_msix_tbl_word0)                   //O: ALARM
    ,.memo_msix_tbl_word0                   (memo_msix_tbl_word0)                   //I: ALARM
    ,.memi_msix_tbl_word1                   (memi_msix_tbl_word1)                   //O: ALARM
    ,.memo_msix_tbl_word1                   (memo_msix_tbl_word1)                   //I: ALARM
    ,.memi_msix_tbl_word2                   (memi_msix_tbl_word2)                   //O: ALARM
    ,.memo_msix_tbl_word2                   (memo_msix_tbl_word2)                   //I: ALARM
    ,.memi_lut_dir_cq_isr                   (memi_lut_dir_cq_isr)                   //O: ALARM
    ,.memo_lut_dir_cq_isr                   (memo_lut_dir_cq_isr)                   //I: ALARM
    ,.memi_lut_ldb_cq_isr                   (memi_lut_ldb_cq_isr)                   //O: ALARM
    ,.memo_lut_ldb_cq_isr                   (memo_lut_ldb_cq_isr)                   //I: ALARM
    ,.memi_lut_dir_cq_ai_addr_l             (memi_lut_dir_cq_ai_addr_l)             //O: ALARM
    ,.memo_lut_dir_cq_ai_addr_l             (memo_lut_dir_cq_ai_addr_l)             //I: ALARM
    ,.memi_lut_ldb_cq_ai_addr_l             (memi_lut_ldb_cq_ai_addr_l)             //O: ALARM
    ,.memo_lut_ldb_cq_ai_addr_l             (memo_lut_ldb_cq_ai_addr_l)             //I: ALARM
    ,.memi_lut_dir_cq_ai_addr_u             (memi_lut_dir_cq_ai_addr_u)             //O: ALARM
    ,.memo_lut_dir_cq_ai_addr_u             (memo_lut_dir_cq_ai_addr_u)             //I: ALARM
    ,.memi_lut_ldb_cq_ai_addr_u             (memi_lut_ldb_cq_ai_addr_u)             //O: ALARM
    ,.memo_lut_ldb_cq_ai_addr_u             (memo_lut_ldb_cq_ai_addr_u)             //I: ALARM
    ,.memi_lut_dir_cq_ai_data               (memi_lut_dir_cq_ai_data)               //O: ALARM
    ,.memo_lut_dir_cq_ai_data               (memo_lut_dir_cq_ai_data)               //I: ALARM
    ,.memi_lut_ldb_cq_ai_data               (memi_lut_ldb_cq_ai_data)               //O: ALARM
    ,.memo_lut_ldb_cq_ai_data               (memo_lut_ldb_cq_ai_data)               //I: ALARM
    ,.memi_alarm_vf_synd0                   (memi_alarm_vf_synd0)                   //O: ALARM
    ,.memo_alarm_vf_synd0                   (memo_alarm_vf_synd0)                   //I: ALARM
    ,.memi_alarm_vf_synd1                   (memi_alarm_vf_synd1)                   //O: ALARM
    ,.memo_alarm_vf_synd1                   (memo_alarm_vf_synd1)                   //I: ALARM
    ,.memi_alarm_vf_synd2                   (memi_alarm_vf_synd2)                   //O: ALARM
    ,.memo_alarm_vf_synd2                   (memo_alarm_vf_synd2)                   //I: ALARM
);

// Double buffer status to CFG

assign alarm_db_status.MSIX_DB_READY = ims_msix_db_status[2];
assign alarm_db_status.MSIX_DB_DEPTH = ims_msix_db_status[1:0];
assign alarm_db_status.SYS_DB_READY  = sys_alarm_db_status[2];
assign alarm_db_status.SYS_DB_DEPTH  = sys_alarm_db_status[1:0];

//-----------------------------------------------------------------------------------------------------
// Ingress interface

logic                                   cfg_inj_par_err_ingress;
logic   [3:0]                           cfg_inj_ecc_err_ingress;

assign cfg_inj_par_err_ingress = cfg_parity_ctl.INJ_PAR_ERR_HCW_PORT;

assign cfg_inj_ecc_err_ingress = {cfg_ecc_ctl.INJ_SB_ECC_HCW_ENQ_LS
                                 ,cfg_ecc_ctl.INJ_MB_ECC_HCW_ENQ_LS
                                 ,cfg_ecc_ctl.INJ_SB_ECC_HCW_ENQ_MS
                                 ,cfg_ecc_ctl.INJ_MB_ECC_HCW_ENQ_MS
};

hqm_system_ingress i_hqm_system_ingress (

     .prim_gated_clk                    (prim_gated_clk)                    //I: INGRESS
    ,.prim_gated_rst_n                  (prim_gated_rst_n)                  //I: INGRESS

    ,.hqm_inp_gated_clk                 (hqm_inp_gated_clk)                 //I: INGRESS
    ,.hqm_inp_gated_rst_n               (hqm_inp_gated_rst_n)               //I: INGRESS

    ,.hqm_gated_clk                     (hqm_gated_clk)                     //I: INGRESS
    ,.hqm_gated_rst_n                   (hqm_gated_rst_n)                   //I: INGRESS

    ,.rst_prep                          (rst_prep)                          //I: INGRESS

    ,.rst_done                          (rst_done[0])                       //O: INGRESS

    ,.hqm_enq_fifo_enable               (hqm_enq_fifo_enable)               //I: INGRESS
    ,.hqm_enq_fifo_idle                 (hqm_enq_fifo_idle)                 //O: INGRESS

    //---------------------------------------------------------------------------------------------
    // CFG interface

    ,.cfg_re                            (cfg_ingress_re)                    //I: INGRESS
    ,.cfg_we                            (cfg_ingress_we)                    //I: INGRESS
    ,.cfg_addr                          (cfg_ingress_addr)                  //I: INGRESS
    ,.cfg_wdata                         (cfg_ingress_wdata)                 //I: INGRESS

    ,.cfg_rvalid                        (cfg_ingress_rvalid)                //O: INGRESS
    ,.cfg_wvalid                        (cfg_ingress_wvalid)                //O: INGRESS
    ,.cfg_error                         (cfg_ingress_error)                 //O: INGRESS
    ,.cfg_rdata                         (cfg_ingress_rdata)                 //O: INGRESS

    ,.cfg_parity_off                    (cfg_parity_ctl.INGRESS_PAR_OFF)    //I: INGRESS
    ,.cfg_write_bad_parity              (cfg_write_bad_parity)              //I: INGRESS
    ,.cfg_write_bad_sb_ecc              (cfg_ecc_ctl.WRITE_BAD_SB_ECC)      //I: INGRESS
    ,.cfg_write_bad_mb_ecc              (cfg_ecc_ctl.WRITE_BAD_MB_ECC)      //I: INGRESS
    ,.cfg_inj_par_err_ingress           (cfg_inj_par_err_ingress)           //I: INGRESS
    ,.cfg_inj_ecc_err_ingress           (cfg_inj_ecc_err_ingress)           //I: INGRESS
    ,.cfg_hcw_enq_fifo_high_wm          (cfg_hcw_enq_fifo_ctl.HIGH_WM)      //I: INGRESS
    ,.cfg_ingress_alarm_enable          (cfg_ingress_alarm_enable)          //I: INGRESS
    ,.cfg_hcw_enq_ecc_enable            (cfg_ecc_ctl.HCW_ENQ_ECC_ENABLE)    //I: INGRESS
    ,.cfg_lut_ecc_enable                (cfg_ecc_ctl.LUT_ECC_ENABLE)        //I: INGRESS
    ,.cfg_cnt_clear                     (hqm_system_cnt_ctl.CNT_CLR)        //I: INGRESS
    ,.cfg_cnt_clearv                    (hqm_system_cnt_ctl.CNT_CLRV)       //I: INGRESS

    ,.ig_hcw_enq_afull_agitate_control  (ig_hcw_enq_afull_agitate_control)  //I: INGRESS
    ,.ig_hcw_enq_w_db_agitate_control   (ig_hcw_enq_w_db_agitate_control)   //I: INGRESS

    ,.dir_pp2vdev                       (dir_pp2vdev)                       //I: INGRESS
    ,.ldb_pp2vdev                       (ldb_pp2vdev)                       //I: INGRESS

    ,.dir_pp_rob_v                      (dir_pp_rob_v)                      //I: INGRESS
    ,.ldb_pp_rob_v                      (ldb_pp_rob_v)                      //I: INGRESS

    ,.ingress_lut_err                   (ingress_lut_err)                   //O: INGRESS
    ,.ingress_perr                      (ingress_perr)                      //O: INGRESS
    ,.ingress_sb_ecc_error              (ingress_sb_ecc_error)              //O: INGRESS
    ,.ingress_mb_ecc_error              (ingress_mb_ecc_error)              //O: INGRESS
    ,.ingress_ecc_syndrome              (ingress_ecc_syndrome)              //O: INGRESS

    ,.rob_error                         (rob_error)                         //O: INGRESS
    ,.rob_error_synd                    (rob_error_synd)                    //O: INGRESS
    ,.rob_syndrome                      (rob_syndrome)                      //O: INGRESS

    ,.hcw_enq_fifo_status               (hcw_enq_fifo_status)               //O: INGRESS
    ,.hcw_enq_db_status                 (hcw_enq_db_status)                 //O: INGRESS
    ,.hcw_enq_w_db_status               (hcw_enq_w_db_status)               //O: INGRESS

    ,.cfg_ingress_ctl                   (cfg_ingress_ctl)                   //I: INGRESS
    ,.ingress_status                    (ingress_status)                    //O: INGRESS
    ,.ingress_idle                      (ingress_idle)                      //O: INGRESS

    ,.cfg_ingress_cnts                  (hqm_system_cnt[5:0])               //O: INGRESS
    ,.hcw_debug_data                    (hcw_debug_data)                    //O: INGRESS

    //---------------------------------------------------------------------------------------------
    // SIF endpoint HCW Enqueue input interface

    ,.hcw_enq_in_ready                  (hcw_enq_in_ready)                  //O: INGRESS

    ,.hcw_enq_in_v                      (hcw_enq_in_v)                      //I: INGRESS
    ,.hcw_enq_in_data                   (hcw_enq_in_data)                   //I: INGRESS

    ,.hcw_enq_in_sync                   (hcw_enq_in_sync)                   //O: INGRESS

    //---------------------------------------------------------------------------------------------
    // Core HCW Enqueue output interface

    ,.hcw_enq_w_req_ready               (hcw_enq_w_req_ready)               //I: INGRESS

    ,.hcw_enq_w_req_valid               (hcw_enq_w_req_valid)               //O: INGRESS
    ,.hcw_enq_w_req                     (hcw_enq_w_req)                     //O: INGRESS

    //---------------------------------------------------------------------------------------------
    // Alarm interface

    ,.ingress_alarm_v                   (ingress_alarm_v)                   //O: INGRESS
    ,.ingress_alarm                     (ingress_alarm)                     //O: INGRESS

    //---------------------------------------------------------------------------------------------
    // Memory interface

    ,.memi_lut_vf_dir_vpp2pp            (memi_lut_vf_dir_vpp2pp)            //O: INGRESS
    ,.memo_lut_vf_dir_vpp2pp            (memo_lut_vf_dir_vpp2pp)            //I: INGRESS
    ,.memi_lut_vf_ldb_vpp2pp            (memi_lut_vf_ldb_vpp2pp)            //O: INGRESS
    ,.memo_lut_vf_ldb_vpp2pp            (memo_lut_vf_ldb_vpp2pp)            //I: INGRESS
    ,.memi_lut_vf_dir_vpp_v             (memi_lut_vf_dir_vpp_v)             //O: INGRESS
    ,.memo_lut_vf_dir_vpp_v             (memo_lut_vf_dir_vpp_v)             //I: INGRESS
    ,.memi_lut_vf_ldb_vpp_v             (memi_lut_vf_ldb_vpp_v)             //O: INGRESS
    ,.memo_lut_vf_ldb_vpp_v             (memo_lut_vf_ldb_vpp_v)             //I: INGRESS
    ,.memi_lut_dir_pp_v                 (memi_lut_dir_pp_v)                 //O: INGRESS
    ,.memo_lut_dir_pp_v                 (memo_lut_dir_pp_v)                 //I: INGRESS
    ,.memi_lut_vf_dir_vqid2qid          (memi_lut_vf_dir_vqid2qid)          //O: INGRESS
    ,.memo_lut_vf_dir_vqid2qid          (memo_lut_vf_dir_vqid2qid)          //I: INGRESS
    ,.memi_lut_vf_ldb_vqid2qid          (memi_lut_vf_ldb_vqid2qid)          //O: INGRESS
    ,.memo_lut_vf_ldb_vqid2qid          (memo_lut_vf_ldb_vqid2qid)          //I: INGRESS
    ,.memi_lut_vf_dir_vqid_v            (memi_lut_vf_dir_vqid_v)            //O: INGRESS
    ,.memo_lut_vf_dir_vqid_v            (memo_lut_vf_dir_vqid_v)            //I: INGRESS
    ,.memi_lut_vf_ldb_vqid_v            (memi_lut_vf_ldb_vqid_v)            //O: INGRESS
    ,.memo_lut_vf_ldb_vqid_v            (memo_lut_vf_ldb_vqid_v)            //I: INGRESS
    ,.memi_lut_dir_pp2vas               (memi_lut_dir_pp2vas)               //O: INGRESS
    ,.memo_lut_dir_pp2vas               (memo_lut_dir_pp2vas)               //I: INGRESS
    ,.memi_lut_ldb_pp2vas               (memi_lut_ldb_pp2vas)               //O: INGRESS
    ,.memo_lut_ldb_pp2vas               (memo_lut_ldb_pp2vas)               //I: INGRESS
    ,.memi_lut_dir_vasqid_v             (memi_lut_dir_vasqid_v)             //O: INGRESS
    ,.memo_lut_dir_vasqid_v             (memo_lut_dir_vasqid_v)             //I: INGRESS
    ,.memi_lut_ldb_vasqid_v             (memi_lut_ldb_vasqid_v)             //O: INGRESS
    ,.memo_lut_ldb_vasqid_v             (memo_lut_ldb_vasqid_v)             //I: INGRESS
    ,.memi_hcw_enq_fifo                 (memi_hcw_enq_fifo)                 //O: INGRESS
    ,.memo_hcw_enq_fifo                 (memo_hcw_enq_fifo)                 //I: INGRESS
    ,.memi_rob_mem                      (memi_rob_mem)                      //O: INGRESS
    ,.memo_rob_mem                      (memo_rob_mem)                      //I: INGRESS

    ,.fscan_byprst_b                    (fscan_byprst_b)                    //I: INGRESS
    ,.fscan_rstbypen                    (fscan_rstbypen)                    //I: INGRESS
);

assign set_rob_syndrome = {$bits(set_rob_syndrome){(rob_error & ~alarm_err.ROB_ERROR)}};

// Double buffer status to CFG

assign ingress_db_status.HCW_ENQ_DB_READY    = hcw_enq_db_status[2];
assign ingress_db_status.HCW_ENQ_DB_DEPTH    = hcw_enq_db_status[1:0];
assign ingress_db_status.HCW_ENQ_W_DB_READY  = hcw_enq_w_db_status[2];
assign ingress_db_status.HCW_ENQ_W_DB_DEPTH  = hcw_enq_w_db_status[1:0];

hqm_AW_unused_bits i_unused_ingress (       

     .a     (|{cfg_hcw_enq_fifo_ctl.reserved0
              ,cfg_sif_alarm_fifo_ctl.reserved0
              ,hcw_enq_db_status[3]
            })
);

//-----------------------------------------------------------------------------------------------------
// Egress interface

logic   [4:0]       cfg_inj_par_err_egress;

assign cfg_inj_par_err_egress = {cfg_parity_ctl.INJ_PAR_ERR_SCH_INT
                                ,cfg_parity_ctl.INJ_PAR_ERR_SCH_PL  
                                ,cfg_parity_ctl.INJ_RES_ERR_SCH_REQ
                                ,cfg_parity_ctl.INJ_PAR_ERR_SCH_REQ
                                ,cfg_parity_ctl.INJ_PAR_ERR_SCH_DATA
};

hqm_system_egress i_hqm_system_egress (

     .hqm_gated_clk                     (hqm_gated_clk)                     //I: EGRESS
    ,.hqm_gated_rst_n                   (hqm_gated_rst_n)                   //I: EGRESS

    ,.hqm_inp_gated_clk                 (hqm_inp_gated_clk)                 //I: EGRESS
    ,.hqm_inp_gated_rst_n               (hqm_inp_gated_rst_n)               //I: EGRESS

    ,.rx_sync_hcw_sched_enable          (rx_sync_hcw_sched_enable)          //I: EGRESS

    ,.rx_sync_hcw_sched_idle            (rx_sync_hcw_sched_idle)            //O: EGRESS

    ,.rst_prep                          (rst_prep)                          //I: EGRESS

    ,.rst_done                          (rst_done[1])                       //O: EGRESS

    //---------------------------------------------------------------------------------------------
    // CFG interface

    ,.cfg_re                            (cfg_egress_re)                     //I: EGRESS
    ,.cfg_we                            (cfg_egress_we)                     //I: EGRESS
    ,.cfg_addr                          (cfg_egress_addr)                   //I: EGRESS
    ,.cfg_wdata                         (cfg_egress_wdata)                  //I: EGRESS

    ,.cfg_rvalid                        (cfg_egress_rvalid)                 //O: EGRESS
    ,.cfg_wvalid                        (cfg_egress_wvalid)                 //O: EGRESS
    ,.cfg_error                         (cfg_egress_error)                  //O: EGRESS
    ,.cfg_rdata                         (cfg_egress_rdata)                  //O: EGRESS

    ,.cfg_int_parity_off                (cfg_parity_ctl.EGRESS_INT_PAR_OFF) //I: EGRESS
    ,.cfg_parity_off                    (cfg_parity_ctl.EGRESS_PAR_OFF)     //I: EGRESS
    ,.cfg_residue_off                   (cfg_parity_ctl.EGRESS_RES_OFF)     //I: EGRESS
    ,.cfg_write_bad_parity              (cfg_write_bad_parity)              //I: EGRESS
    ,.cfg_inj_par_err_egress            (cfg_inj_par_err_egress)            //I: EGRESS
    ,.cfg_cnt_clear                     (hqm_system_cnt_ctl.CNT_CLR)        //I: EGRESS
    ,.cfg_cnt_clearv                    (hqm_system_cnt_ctl.CNT_CLRV)       //I: EGRESS
    ,.eg_hcw_sched_db_agitate_control   (eg_hcw_sched_db_agitate_control)   //I: EGRESS

    ,.egress_lut_err                    (egress_lut_err)                    //O: EGRESS
    ,.egress_perr                       (egress_perr)                       //O: EGRESS
    ,.cq_addr_overflow_error            (cq_addr_overflow_error)            //O: EGRESS
    ,.cq_addr_overflow_syndrome         (cq_addr_overflow_syndrome)         //O: EGRESS

    ,.hcw_sched_db_status               (hcw_sched_db_status)               //O: EGRESS

    ,.hcw_sch_fifo_status               (hcw_sch_fifo_status)               //O: EGRESS

    ,.cfg_egress_ctl                    (cfg_egress_ctl)                    //I: EGRESS
    ,.egress_status                     (egress_status)                     //O: EGRESS
    ,.egress_idle                       (egress_idle)                       //O: EGRESS

    ,.cfg_egress_cnts                   (hqm_system_cnt[9:6])               //O: EGRESS

    //---------------------------------------------------------------------------------------------
    // CQ occupancy interrupt interface

    ,.interrupt_w_req_ready             (interrupt_w_req_ready_i)           //O: EGRESS

    ,.interrupt_w_req                   (interrupt_w_req_i)                 //I: EGRESS
    ,.interrupt_w_req_valid             (interrupt_w_req_valid_i)           //I: EGRESS

    //---------------------------------------------------------------------------------------------
    // Core HCW Sched interface from hqm_core

    ,.hcw_sched_w_req_ready             (hcw_sched_w_req_ready)             //O: EGRESS

    ,.hcw_sched_w_req_valid             (hcw_sched_w_req_valid)             //I: EGRESS
    ,.hcw_sched_w_req                   (hcw_sched_w_req)                   //I: EGRESS

    //---------------------------------------------------------------------------------------------
    // HCW Sched interface to write buffer

    ,.hcw_sched_out_ready               (hcw_sched_out_ready)               //I: EGRESS

    ,.hcw_sched_out_v                   (hcw_sched_out_v)                   //O: EGRESS
    ,.hcw_sched_out                     (hcw_sched_out)                     //O: EGRESS

    //---------------------------------------------------------------------------------------------
    // Memory interface

    ,.memi_lut_dir_cq_pasid             (memi_lut_dir_cq_pasid)             //O: EGRESS
    ,.memo_lut_dir_cq_pasid             (memo_lut_dir_cq_pasid)             //I: EGRESS
    ,.memi_lut_ldb_cq_pasid             (memi_lut_ldb_cq_pasid)             //O: EGRESS
    ,.memo_lut_ldb_cq_pasid             (memo_lut_ldb_cq_pasid)             //I: EGRESS
    ,.memi_lut_dir_cq_addr_l            (memi_lut_dir_cq_addr_l)            //O: EGRESS
    ,.memo_lut_dir_cq_addr_l            (memo_lut_dir_cq_addr_l)            //I: EGRESS
    ,.memi_lut_ldb_cq_addr_l            (memi_lut_ldb_cq_addr_l)            //O: EGRESS
    ,.memo_lut_ldb_cq_addr_l            (memo_lut_ldb_cq_addr_l)            //I: EGRESS
    ,.memi_lut_dir_cq_addr_u            (memi_lut_dir_cq_addr_u)            //O: EGRESS
    ,.memo_lut_dir_cq_addr_u            (memo_lut_dir_cq_addr_u)            //I: EGRESS
    ,.memi_lut_ldb_cq_addr_u            (memi_lut_ldb_cq_addr_u)            //O: EGRESS
    ,.memo_lut_ldb_cq_addr_u            (memo_lut_ldb_cq_addr_u)            //I: EGRESS
    ,.memi_lut_dir_cq2vf_pf_ro          (memi_lut_dir_cq2vf_pf_ro)          //O: EGRESS
    ,.memo_lut_dir_cq2vf_pf_ro          (memo_lut_dir_cq2vf_pf_ro)          //I: EGRESS
    ,.memi_lut_ldb_cq2vf_pf_ro          (memi_lut_ldb_cq2vf_pf_ro)          //O: EGRESS
    ,.memo_lut_ldb_cq2vf_pf_ro          (memo_lut_ldb_cq2vf_pf_ro)          //I: EGRESS
    ,.memi_lut_ldb_qid2vqid             (memi_lut_ldb_qid2vqid)             //O: EGRESS
    ,.memo_lut_ldb_qid2vqid             (memo_lut_ldb_qid2vqid)             //I: EGRESS
);

// Double buffer status to CFG

assign egress_db_status.PHDR_DB_READY      = phdr_db_status[2];
assign egress_db_status.PHDR_DB_DEPTH      = phdr_db_status[1:0];
assign egress_db_status.PDATA_MS_DB_READY  = pdata_ms_db_status[2];
assign egress_db_status.PDATA_MS_DB_DEPTH  = pdata_ms_db_status[1:0];
assign egress_db_status.PDATA_LS_DB_READY  = pdata_ls_db_status[2];
assign egress_db_status.PDATA_LS_DB_DEPTH  = pdata_ls_db_status[1:0];
assign egress_db_status.CQ_OCC_DB_READY    = cq_occ_db_status[2];
assign egress_db_status.CQ_OCC_DB_DEPTH    = cq_occ_db_status[1:0];
assign egress_db_status.HCW_SCHED_DB_READY = hcw_sched_db_status[2];
assign egress_db_status.HCW_SCHED_DB_DEPTH = hcw_sched_db_status[1:0];

//-----------------------------------------------------------------------------------------------------
// Write Buffer

logic   [7:0]  cfg_inj_ecc_err_wbuf;
logic   [4:0]  cfg_inj_par_err_wbuf;

assign cfg_inj_ecc_err_wbuf = {cfg_ecc_ctl.INJ_SB_ECC_WBUF_W1_MS
                              ,cfg_ecc_ctl.INJ_MB_ECC_WBUF_W1_MS
                              ,cfg_ecc_ctl.INJ_SB_ECC_WBUF_W1_LS
                              ,cfg_ecc_ctl.INJ_MB_ECC_WBUF_W1_LS
                              ,cfg_ecc_ctl.INJ_SB_ECC_WBUF_W0_MS
                              ,cfg_ecc_ctl.INJ_MB_ECC_WBUF_W0_MS
                              ,cfg_ecc_ctl.INJ_SB_ECC_WBUF_W0_LS
                              ,cfg_ecc_ctl.INJ_MB_ECC_WBUF_W0_LS
};

assign cfg_inj_par_err_wbuf = {cfg_parity_ctl.INJ_RES_ERR_INT
                              ,cfg_parity_ctl.INJ_PAR_ERR_INT
                              ,cfg_parity_ctl.INJ_RES_ERR_SCH
                              ,cfg_parity_ctl.INJ_PAR_ERR_SCH
                              ,cfg_parity_ctl.INJ_PAR_ERR_SCH_OUT
};

hqm_system_write_buffer i_hqm_system_write_buffer (

     .hqm_gated_clk                     (hqm_gated_clk)                     //I: WBUF
    ,.hqm_gated_rst_n                   (hqm_gated_rst_n)                   //I: WBUF

    //---------------------------------------------------------------------------------------------
    // CFG interface

    ,.cfg_re                            (cfg_wb_re)                         //I: WBUF
    ,.cfg_we                            (cfg_wb_we)                         //I: WBUF
    ,.cfg_addr                          (cfg_wb_addr)                       //I: WBUF
    ,.cfg_wdata                         (cfg_wb_wdata)                      //I: WBUF

    ,.cfg_rvalid                        (cfg_wb_rvalid)                     //O: WBUF
    ,.cfg_wvalid                        (cfg_wb_wvalid)                     //O: WBUF
    ,.cfg_error                         (cfg_wb_error)                      //O: WBUF
    ,.cfg_rdata                         (cfg_wb_rdata)                      //O: WBUF

    ,.wb_sch_out_afull_agitate_control  (wb_sch_out_afull_agitate_control)  //I: WBUF
    ,.cfg_write_buffer_ctl              (cfg_write_buffer_ctl)              //I: WBUF
    ,.cfg_sch_wb_ecc_enable             (cfg_ecc_ctl.SCH_WB_ECC_ENABLE)     //I: WBUF
    ,.cfg_inj_ecc_err_wbuf              (cfg_inj_ecc_err_wbuf)              //I: WBUF
    ,.cfg_inj_par_err_wbuf              (cfg_inj_par_err_wbuf)              //I: WBUF
    ,.cfg_sch_out_fifo_high_wm          (cfg_sch_out_fifo_ctl.HIGH_WM)      //I: WBUF
    ,.cfg_cnt_clear                     (hqm_system_cnt_ctl.CNT_CLR)        //I: WBUF
    ,.cfg_cnt_clearv                    (hqm_system_cnt_ctl.CNT_CLRV)       //I: WBUF
    ,.cfg_parity_off                    (cfg_parity_ctl.WBUF_PAR_OFF)       //I: WBUF
    ,.cfg_residue_off                   (cfg_parity_ctl.WBUF_RES_OFF)       //I: WBUF

    ,.pci_cfg_sciov_en                  (pci_cfg_sciov_en)                  //I: WBUF

    ,.sch_sm_error                      (sch_sm_error)                      //O: WBUF
    ,.sch_sm_syndrome                   (sch_sm_syndrome)                   //O: WBUF

    ,.sch_sm_drops                      (sch_sm_drops)                      //O: WBUF
    ,.sch_sm_drops_comp                 (sch_sm_drops_comp)                 //O: WBUF
    ,.sch_clr_drops                     (sch_clr_drops)                     //O: WBUF
    ,.sch_clr_drops_comp                (sch_clr_drops_comp)                //O: WBUF

    ,.sch_wb_error                      (sch_wb_error)                      //O: WBUF
    ,.sch_wb_error_synd                 (sch_wb_error_synd)                 //O: WBUF
    ,.sch_wb_sb_ecc_error               (sch_wb_sb_ecc_error)               //O: WBUF
    ,.sch_wb_mb_ecc_error               (sch_wb_mb_ecc_error)               //O: WBUF
    ,.sch_wb_ecc_syndrome               (sch_wb_ecc_syndrome)               //O: WBUF

    ,.sch_out_fifo_status               (sch_out_fifo_status)               //O: WBUF
    ,.cq_occ_db_status                  (cq_occ_db_status)                  //O: WBUF
    ,.phdr_db_status                    (phdr_db_status)                    //O: WBUF
    ,.pdata_ms_db_status                (pdata_ms_db_status)                //O: WBUF
    ,.pdata_ls_db_status                (pdata_ls_db_status)                //O: WBUF

    ,.wbuf_status                       (wbuf_status)                       //O: WBUF
    ,.wbuf_status2                      (wbuf_status2)                      //O: WBUF
    ,.wbuf_debug                        (wbuf_debug)                        //O: WBUF
    ,.wbuf_idle                         (wbuf_idle)                         //O: WBUF
    ,.wbuf_appended                     (wbuf_appended)                     //O: WBUF

    ,.cfg_wbuf_cnts                     (hqm_system_cnt[21:10])             //O: WBUF
    ,.cfg_phdr_debug                    (cfg_phdr_debug)                    //O: WBUF
    ,.cfg_pdata_debug                   (cfg_pdata_debug)                   //O: WBUF

    //---------------------------------------------------------------------------------------------
    // HCW Sched interface from egress

    ,.hcw_sched_out_ready               (hcw_sched_out_ready)               //O: WBUF

    ,.hcw_sched_out_v                   (hcw_sched_out_v)                   //I: WBUF
    ,.hcw_sched_out                     (hcw_sched_out)                     //I: WBUF

    //---------------------------------------------------------------------------------------------
    // CQ occupany interrupt request to alarm

    ,.cq_occ_int_busy                   (cq_occ_int_busy)                   //I: WBUF

    ,.cq_occ_int_v                      (cq_occ_int_v)                      //O: WBUF
    ,.cq_occ_int                        (cq_occ_int)                        //O: WBUF

    //---------------------------------------------------------------------------------------------
    // IMS/MSI-X writes from alarm

    ,.ims_msix_w_ready                  (ims_msix_w_ready)                  //O: WBUF

    ,.ims_msix_w_v                      (ims_msix_w_v)                      //I: WBUF
    ,.ims_msix_w                        (ims_msix_w)                        //I: WBUF

    //---------------------------------------------------------------------------------------------
    // SIF interface

    ,.write_buffer_mstr_ready           (write_buffer_mstr_ready)           //I: WBUF

    ,.write_buffer_mstr_v               (write_buffer_mstr_v)               //O: WBUF
    ,.write_buffer_mstr                 (write_buffer_mstr)                 //O: WBUF

    ,.pwrite_v                          (pwrite_v)                          //O: WBUF
    ,.pwrite_comp                       (pwrite_comp)                       //O: WBUF
    ,.pwrite_value                      (pwrite_value)                      //O: WBUF

    //---------------------------------------------------------------------------------------------
    // Memory interface

    ,.memi_sch_out_fifo                 (memi_sch_out_fifo)                 //O: WBUF
    ,.memo_sch_out_fifo                 (memo_sch_out_fifo)                 //I: WBUF
    ,.memi_dir_wb0                      (memi_dir_wb0)                      //O: WBUF
    ,.memo_dir_wb0                      (memo_dir_wb0)                      //I: WBUF
    ,.memi_dir_wb1                      (memi_dir_wb1)                      //O: WBUF
    ,.memo_dir_wb1                      (memo_dir_wb1)                      //I: WBUF
    ,.memi_dir_wb2                      (memi_dir_wb2)                      //O: WBUF
    ,.memo_dir_wb2                      (memo_dir_wb2)                      //I: WBUF
    ,.memi_ldb_wb0                      (memi_ldb_wb0)                      //O: WBUF
    ,.memo_ldb_wb0                      (memo_ldb_wb0)                      //I: WBUF
    ,.memi_ldb_wb1                      (memi_ldb_wb1)                      //O: WBUF
    ,.memo_ldb_wb1                      (memo_ldb_wb1)                      //I: WBUF
    ,.memi_ldb_wb2                      (memi_ldb_wb2)                      //O: WBUF
    ,.memo_ldb_wb2                      (memo_ldb_wb2)                      //I: WBUF
);

hqm_AW_unused_bits i_unused_wbuf (       

     .a     (|{cfg_sch_out_fifo_ctl.reserved0
              ,cfg_ecc_ctl.reserved0
            })
);

//---------------------------------------------------------------------------------------------
// Memory solution assignment

//-----------------------------------------------------------------------------------------------------
// Status

always_comb begin

 sys_idle_status                     = '0;
 sys_idle_status.PBA_IDLE            = pba_idle;
 sys_idle_status.ALARM_IDLE          = alarm_idle;
 sys_idle_status.WBUF_IDLE           = wbuf_idle;
 sys_idle_status.EGRESS_IDLE         = egress_idle;
 sys_idle_status.INGRESS_IDLE        = ingress_idle;
 sys_idle_status.INT_IDLE            = int_idle;

end

//-----------------------------------------------------------------------------------------------------
// BEGIN HQM_RAM_ACCESS

logic                  hqm_system_rfw_top_ipar_error;

logic                  func_alarm_vf_synd0_re; //I
logic [(       4)-1:0] func_alarm_vf_synd0_raddr; //I
logic [(       4)-1:0] func_alarm_vf_synd0_waddr; //I
logic                  func_alarm_vf_synd0_we;    //I
logic [(      30)-1:0] func_alarm_vf_synd0_wdata; //I
logic [(      30)-1:0] func_alarm_vf_synd0_rdata;

logic                  func_alarm_vf_synd1_re; //I
logic [(       4)-1:0] func_alarm_vf_synd1_raddr; //I
logic [(       4)-1:0] func_alarm_vf_synd1_waddr; //I
logic                  func_alarm_vf_synd1_we;    //I
logic [(      32)-1:0] func_alarm_vf_synd1_wdata; //I
logic [(      32)-1:0] func_alarm_vf_synd1_rdata;

logic                  func_alarm_vf_synd2_re; //I
logic [(       4)-1:0] func_alarm_vf_synd2_raddr; //I
logic [(       4)-1:0] func_alarm_vf_synd2_waddr; //I
logic                  func_alarm_vf_synd2_we;    //I
logic [(      32)-1:0] func_alarm_vf_synd2_wdata; //I
logic [(      32)-1:0] func_alarm_vf_synd2_rdata;

logic                  func_dir_wb0_re; //I
logic [(       6)-1:0] func_dir_wb0_raddr; //I
logic [(       6)-1:0] func_dir_wb0_waddr; //I
logic                  func_dir_wb0_we;    //I
logic [(     144)-1:0] func_dir_wb0_wdata; //I
logic [(     144)-1:0] func_dir_wb0_rdata;

logic                  func_dir_wb1_re; //I
logic [(       6)-1:0] func_dir_wb1_raddr; //I
logic [(       6)-1:0] func_dir_wb1_waddr; //I
logic                  func_dir_wb1_we;    //I
logic [(     144)-1:0] func_dir_wb1_wdata; //I
logic [(     144)-1:0] func_dir_wb1_rdata;

logic                  func_dir_wb2_re; //I
logic [(       6)-1:0] func_dir_wb2_raddr; //I
logic [(       6)-1:0] func_dir_wb2_waddr; //I
logic                  func_dir_wb2_we;    //I
logic [(     144)-1:0] func_dir_wb2_wdata; //I
logic [(     144)-1:0] func_dir_wb2_rdata;

logic                  func_hcw_enq_fifo_re; //I
logic [(       8)-1:0] func_hcw_enq_fifo_raddr; //I
logic [(       8)-1:0] func_hcw_enq_fifo_waddr; //I
logic                  func_hcw_enq_fifo_we;    //I
logic [(     161)-1:0] func_hcw_enq_fifo_wdata; //I
logic [(     161)-1:0] func_hcw_enq_fifo_rdata;

logic                  func_ldb_wb0_re; //I
logic [(       6)-1:0] func_ldb_wb0_raddr; //I
logic [(       6)-1:0] func_ldb_wb0_waddr; //I
logic                  func_ldb_wb0_we;    //I
logic [(     144)-1:0] func_ldb_wb0_wdata; //I
logic [(     144)-1:0] func_ldb_wb0_rdata;

logic                  func_ldb_wb1_re; //I
logic [(       6)-1:0] func_ldb_wb1_raddr; //I
logic [(       6)-1:0] func_ldb_wb1_waddr; //I
logic                  func_ldb_wb1_we;    //I
logic [(     144)-1:0] func_ldb_wb1_wdata; //I
logic [(     144)-1:0] func_ldb_wb1_rdata;

logic                  func_ldb_wb2_re; //I
logic [(       6)-1:0] func_ldb_wb2_raddr; //I
logic [(       6)-1:0] func_ldb_wb2_waddr; //I
logic                  func_ldb_wb2_we;    //I
logic [(     144)-1:0] func_ldb_wb2_wdata; //I
logic [(     144)-1:0] func_ldb_wb2_rdata;

logic                  func_lut_dir_cq2vf_pf_ro_re; //I
logic [(       5)-1:0] func_lut_dir_cq2vf_pf_ro_raddr; //I
logic [(       5)-1:0] func_lut_dir_cq2vf_pf_ro_waddr; //I
logic                  func_lut_dir_cq2vf_pf_ro_we;    //I
logic [(      13)-1:0] func_lut_dir_cq2vf_pf_ro_wdata; //I
logic [(      13)-1:0] func_lut_dir_cq2vf_pf_ro_rdata;

logic                  func_lut_dir_cq_addr_l_re; //I
logic [(       6)-1:0] func_lut_dir_cq_addr_l_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_addr_l_waddr; //I
logic                  func_lut_dir_cq_addr_l_we;    //I
logic [(      27)-1:0] func_lut_dir_cq_addr_l_wdata; //I
logic [(      27)-1:0] func_lut_dir_cq_addr_l_rdata;

logic                  func_lut_dir_cq_addr_u_re; //I
logic [(       6)-1:0] func_lut_dir_cq_addr_u_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_addr_u_waddr; //I
logic                  func_lut_dir_cq_addr_u_we;    //I
logic [(      33)-1:0] func_lut_dir_cq_addr_u_wdata; //I
logic [(      33)-1:0] func_lut_dir_cq_addr_u_rdata;

logic                  func_lut_dir_cq_ai_addr_l_re; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_addr_l_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_addr_l_waddr; //I
logic                  func_lut_dir_cq_ai_addr_l_we;    //I
logic [(      31)-1:0] func_lut_dir_cq_ai_addr_l_wdata; //I
logic [(      31)-1:0] func_lut_dir_cq_ai_addr_l_rdata;

logic                  func_lut_dir_cq_ai_addr_u_re; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_addr_u_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_addr_u_waddr; //I
logic                  func_lut_dir_cq_ai_addr_u_we;    //I
logic [(      33)-1:0] func_lut_dir_cq_ai_addr_u_wdata; //I
logic [(      33)-1:0] func_lut_dir_cq_ai_addr_u_rdata;

logic                  func_lut_dir_cq_ai_data_re; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_data_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_ai_data_waddr; //I
logic                  func_lut_dir_cq_ai_data_we;    //I
logic [(      33)-1:0] func_lut_dir_cq_ai_data_wdata; //I
logic [(      33)-1:0] func_lut_dir_cq_ai_data_rdata;

logic                  func_lut_dir_cq_isr_re; //I
logic [(       6)-1:0] func_lut_dir_cq_isr_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_isr_waddr; //I
logic                  func_lut_dir_cq_isr_we;    //I
logic [(      13)-1:0] func_lut_dir_cq_isr_wdata; //I
logic [(      13)-1:0] func_lut_dir_cq_isr_rdata;

logic                  func_lut_dir_cq_pasid_re; //I
logic [(       6)-1:0] func_lut_dir_cq_pasid_raddr; //I
logic [(       6)-1:0] func_lut_dir_cq_pasid_waddr; //I
logic                  func_lut_dir_cq_pasid_we;    //I
logic [(      24)-1:0] func_lut_dir_cq_pasid_wdata; //I
logic [(      24)-1:0] func_lut_dir_cq_pasid_rdata;

logic                  func_lut_dir_pp2vas_re; //I
logic [(       5)-1:0] func_lut_dir_pp2vas_raddr; //I
logic [(       5)-1:0] func_lut_dir_pp2vas_waddr; //I
logic                  func_lut_dir_pp2vas_we;    //I
logic [(      11)-1:0] func_lut_dir_pp2vas_wdata; //I
logic [(      11)-1:0] func_lut_dir_pp2vas_rdata;

logic                  func_lut_dir_pp_v_re; //I
logic [(       2)-1:0] func_lut_dir_pp_v_raddr; //I
logic [(       2)-1:0] func_lut_dir_pp_v_waddr; //I
logic                  func_lut_dir_pp_v_we;    //I
logic [(      17)-1:0] func_lut_dir_pp_v_wdata; //I
logic [(      17)-1:0] func_lut_dir_pp_v_rdata;

logic                  func_lut_dir_vasqid_v_re; //I
logic [(       6)-1:0] func_lut_dir_vasqid_v_raddr; //I
logic [(       6)-1:0] func_lut_dir_vasqid_v_waddr; //I
logic                  func_lut_dir_vasqid_v_we;    //I
logic [(      33)-1:0] func_lut_dir_vasqid_v_wdata; //I
logic [(      33)-1:0] func_lut_dir_vasqid_v_rdata;

logic                  func_lut_ldb_cq2vf_pf_ro_re; //I
logic [(       5)-1:0] func_lut_ldb_cq2vf_pf_ro_raddr; //I
logic [(       5)-1:0] func_lut_ldb_cq2vf_pf_ro_waddr; //I
logic                  func_lut_ldb_cq2vf_pf_ro_we;    //I
logic [(      13)-1:0] func_lut_ldb_cq2vf_pf_ro_wdata; //I
logic [(      13)-1:0] func_lut_ldb_cq2vf_pf_ro_rdata;

logic                  func_lut_ldb_cq_addr_l_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_addr_l_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_addr_l_waddr; //I
logic                  func_lut_ldb_cq_addr_l_we;    //I
logic [(      27)-1:0] func_lut_ldb_cq_addr_l_wdata; //I
logic [(      27)-1:0] func_lut_ldb_cq_addr_l_rdata;

logic                  func_lut_ldb_cq_addr_u_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_addr_u_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_addr_u_waddr; //I
logic                  func_lut_ldb_cq_addr_u_we;    //I
logic [(      33)-1:0] func_lut_ldb_cq_addr_u_wdata; //I
logic [(      33)-1:0] func_lut_ldb_cq_addr_u_rdata;

logic                  func_lut_ldb_cq_ai_addr_l_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_l_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_l_waddr; //I
logic                  func_lut_ldb_cq_ai_addr_l_we;    //I
logic [(      31)-1:0] func_lut_ldb_cq_ai_addr_l_wdata; //I
logic [(      31)-1:0] func_lut_ldb_cq_ai_addr_l_rdata;

logic                  func_lut_ldb_cq_ai_addr_u_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_u_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_u_waddr; //I
logic                  func_lut_ldb_cq_ai_addr_u_we;    //I
logic [(      33)-1:0] func_lut_ldb_cq_ai_addr_u_wdata; //I
logic [(      33)-1:0] func_lut_ldb_cq_ai_addr_u_rdata;

logic                  func_lut_ldb_cq_ai_data_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_data_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_ai_data_waddr; //I
logic                  func_lut_ldb_cq_ai_data_we;    //I
logic [(      33)-1:0] func_lut_ldb_cq_ai_data_wdata; //I
logic [(      33)-1:0] func_lut_ldb_cq_ai_data_rdata;

logic                  func_lut_ldb_cq_isr_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_isr_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_isr_waddr; //I
logic                  func_lut_ldb_cq_isr_we;    //I
logic [(      13)-1:0] func_lut_ldb_cq_isr_wdata; //I
logic [(      13)-1:0] func_lut_ldb_cq_isr_rdata;

logic                  func_lut_ldb_cq_pasid_re; //I
logic [(       6)-1:0] func_lut_ldb_cq_pasid_raddr; //I
logic [(       6)-1:0] func_lut_ldb_cq_pasid_waddr; //I
logic                  func_lut_ldb_cq_pasid_we;    //I
logic [(      24)-1:0] func_lut_ldb_cq_pasid_wdata; //I
logic [(      24)-1:0] func_lut_ldb_cq_pasid_rdata;

logic                  func_lut_ldb_pp2vas_re; //I
logic [(       5)-1:0] func_lut_ldb_pp2vas_raddr; //I
logic [(       5)-1:0] func_lut_ldb_pp2vas_waddr; //I
logic                  func_lut_ldb_pp2vas_we;    //I
logic [(      11)-1:0] func_lut_ldb_pp2vas_wdata; //I
logic [(      11)-1:0] func_lut_ldb_pp2vas_rdata;

logic                  func_lut_ldb_qid2vqid_re; //I
logic [(       3)-1:0] func_lut_ldb_qid2vqid_raddr; //I
logic [(       3)-1:0] func_lut_ldb_qid2vqid_waddr; //I
logic                  func_lut_ldb_qid2vqid_we;    //I
logic [(      21)-1:0] func_lut_ldb_qid2vqid_wdata; //I
logic [(      21)-1:0] func_lut_ldb_qid2vqid_rdata;

logic                  func_lut_ldb_vasqid_v_re; //I
logic [(       6)-1:0] func_lut_ldb_vasqid_v_raddr; //I
logic [(       6)-1:0] func_lut_ldb_vasqid_v_waddr; //I
logic                  func_lut_ldb_vasqid_v_we;    //I
logic [(      17)-1:0] func_lut_ldb_vasqid_v_wdata; //I
logic [(      17)-1:0] func_lut_ldb_vasqid_v_rdata;

logic                  func_lut_vf_dir_vpp2pp_re; //I
logic [(       8)-1:0] func_lut_vf_dir_vpp2pp_raddr; //I
logic [(       8)-1:0] func_lut_vf_dir_vpp2pp_waddr; //I
logic                  func_lut_vf_dir_vpp2pp_we;    //I
logic [(      31)-1:0] func_lut_vf_dir_vpp2pp_wdata; //I
logic [(      31)-1:0] func_lut_vf_dir_vpp2pp_rdata;

logic                  func_lut_vf_dir_vpp_v_re; //I
logic [(       6)-1:0] func_lut_vf_dir_vpp_v_raddr; //I
logic [(       6)-1:0] func_lut_vf_dir_vpp_v_waddr; //I
logic                  func_lut_vf_dir_vpp_v_we;    //I
logic [(      17)-1:0] func_lut_vf_dir_vpp_v_wdata; //I
logic [(      17)-1:0] func_lut_vf_dir_vpp_v_rdata;

logic                  func_lut_vf_dir_vqid2qid_re; //I
logic [(       8)-1:0] func_lut_vf_dir_vqid2qid_raddr; //I
logic [(       8)-1:0] func_lut_vf_dir_vqid2qid_waddr; //I
logic                  func_lut_vf_dir_vqid2qid_we;    //I
logic [(      31)-1:0] func_lut_vf_dir_vqid2qid_wdata; //I
logic [(      31)-1:0] func_lut_vf_dir_vqid2qid_rdata;

logic                  func_lut_vf_dir_vqid_v_re; //I
logic [(       6)-1:0] func_lut_vf_dir_vqid_v_raddr; //I
logic [(       6)-1:0] func_lut_vf_dir_vqid_v_waddr; //I
logic                  func_lut_vf_dir_vqid_v_we;    //I
logic [(      17)-1:0] func_lut_vf_dir_vqid_v_wdata; //I
logic [(      17)-1:0] func_lut_vf_dir_vqid_v_rdata;

logic                  func_lut_vf_ldb_vpp2pp_re; //I
logic [(       8)-1:0] func_lut_vf_ldb_vpp2pp_raddr; //I
logic [(       8)-1:0] func_lut_vf_ldb_vpp2pp_waddr; //I
logic                  func_lut_vf_ldb_vpp2pp_we;    //I
logic [(      25)-1:0] func_lut_vf_ldb_vpp2pp_wdata; //I
logic [(      25)-1:0] func_lut_vf_ldb_vpp2pp_rdata;

logic                  func_lut_vf_ldb_vpp_v_re; //I
logic [(       6)-1:0] func_lut_vf_ldb_vpp_v_raddr; //I
logic [(       6)-1:0] func_lut_vf_ldb_vpp_v_waddr; //I
logic                  func_lut_vf_ldb_vpp_v_we;    //I
logic [(      17)-1:0] func_lut_vf_ldb_vpp_v_wdata; //I
logic [(      17)-1:0] func_lut_vf_ldb_vpp_v_rdata;

logic                  func_lut_vf_ldb_vqid2qid_re; //I
logic [(       7)-1:0] func_lut_vf_ldb_vqid2qid_raddr; //I
logic [(       7)-1:0] func_lut_vf_ldb_vqid2qid_waddr; //I
logic                  func_lut_vf_ldb_vqid2qid_we;    //I
logic [(      27)-1:0] func_lut_vf_ldb_vqid2qid_wdata; //I
logic [(      27)-1:0] func_lut_vf_ldb_vqid2qid_rdata;

logic                  func_lut_vf_ldb_vqid_v_re; //I
logic [(       5)-1:0] func_lut_vf_ldb_vqid_v_raddr; //I
logic [(       5)-1:0] func_lut_vf_ldb_vqid_v_waddr; //I
logic                  func_lut_vf_ldb_vqid_v_we;    //I
logic [(      17)-1:0] func_lut_vf_ldb_vqid_v_wdata; //I
logic [(      17)-1:0] func_lut_vf_ldb_vqid_v_rdata;

logic                  func_msix_tbl_word0_re; //I
logic [(       6)-1:0] func_msix_tbl_word0_raddr; //I
logic [(       6)-1:0] func_msix_tbl_word0_waddr; //I
logic                  func_msix_tbl_word0_we;    //I
logic [(      33)-1:0] func_msix_tbl_word0_wdata; //I
logic [(      33)-1:0] func_msix_tbl_word0_rdata;

logic                  func_msix_tbl_word1_re; //I
logic [(       6)-1:0] func_msix_tbl_word1_raddr; //I
logic [(       6)-1:0] func_msix_tbl_word1_waddr; //I
logic                  func_msix_tbl_word1_we;    //I
logic [(      33)-1:0] func_msix_tbl_word1_wdata; //I
logic [(      33)-1:0] func_msix_tbl_word1_rdata;

logic                  func_msix_tbl_word2_re; //I
logic [(       6)-1:0] func_msix_tbl_word2_raddr; //I
logic [(       6)-1:0] func_msix_tbl_word2_waddr; //I
logic                  func_msix_tbl_word2_we;    //I
logic [(      33)-1:0] func_msix_tbl_word2_wdata; //I
logic [(      33)-1:0] func_msix_tbl_word2_rdata;

logic                  func_sch_out_fifo_re; //I
logic [(       7)-1:0] func_sch_out_fifo_raddr; //I
logic [(       7)-1:0] func_sch_out_fifo_waddr; //I
logic                  func_sch_out_fifo_we;    //I
logic [(     262)-1:0] func_sch_out_fifo_wdata; //I
logic [(     262)-1:0] func_sch_out_fifo_rdata;

logic                  func_rob_mem_re;    //I
logic [(      11)-1:0] func_rob_mem_addr;  //I
logic                  func_rob_mem_we;    //I
logic [(     156)-1:0] func_rob_mem_wdata; //I
logic [(     156)-1:0] func_rob_mem_rdata;

hqm_system_ram_access i_hqm_system_ram_access (
  .hqm_gated_clk (hqm_gated_clk)
, .prim_gated_clk (prim_gated_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
, .prim_gated_rst_n (prim_gated_rst_n)
,.hqm_system_rfw_top_ipar_error (hqm_system_rfw_top_ipar_error)

,.func_alarm_vf_synd0_re    (func_alarm_vf_synd0_re)
,.func_alarm_vf_synd0_raddr (func_alarm_vf_synd0_raddr)
,.func_alarm_vf_synd0_waddr (func_alarm_vf_synd0_waddr)
,.func_alarm_vf_synd0_we    (func_alarm_vf_synd0_we)
,.func_alarm_vf_synd0_wdata (func_alarm_vf_synd0_wdata)
,.func_alarm_vf_synd0_rdata (func_alarm_vf_synd0_rdata)

,.rf_alarm_vf_synd0_rclk (rf_alarm_vf_synd0_rclk)
,.rf_alarm_vf_synd0_rclk_rst_n (rf_alarm_vf_synd0_rclk_rst_n)
,.rf_alarm_vf_synd0_re    (rf_alarm_vf_synd0_re)
,.rf_alarm_vf_synd0_raddr (rf_alarm_vf_synd0_raddr)
,.rf_alarm_vf_synd0_waddr (rf_alarm_vf_synd0_waddr)
,.rf_alarm_vf_synd0_wclk (rf_alarm_vf_synd0_wclk)
,.rf_alarm_vf_synd0_wclk_rst_n (rf_alarm_vf_synd0_wclk_rst_n)
,.rf_alarm_vf_synd0_we    (rf_alarm_vf_synd0_we)
,.rf_alarm_vf_synd0_wdata (rf_alarm_vf_synd0_wdata)
,.rf_alarm_vf_synd0_rdata (rf_alarm_vf_synd0_rdata)

,.func_alarm_vf_synd1_re    (func_alarm_vf_synd1_re)
,.func_alarm_vf_synd1_raddr (func_alarm_vf_synd1_raddr)
,.func_alarm_vf_synd1_waddr (func_alarm_vf_synd1_waddr)
,.func_alarm_vf_synd1_we    (func_alarm_vf_synd1_we)
,.func_alarm_vf_synd1_wdata (func_alarm_vf_synd1_wdata)
,.func_alarm_vf_synd1_rdata (func_alarm_vf_synd1_rdata)

,.rf_alarm_vf_synd1_rclk (rf_alarm_vf_synd1_rclk)
,.rf_alarm_vf_synd1_rclk_rst_n (rf_alarm_vf_synd1_rclk_rst_n)
,.rf_alarm_vf_synd1_re    (rf_alarm_vf_synd1_re)
,.rf_alarm_vf_synd1_raddr (rf_alarm_vf_synd1_raddr)
,.rf_alarm_vf_synd1_waddr (rf_alarm_vf_synd1_waddr)
,.rf_alarm_vf_synd1_wclk (rf_alarm_vf_synd1_wclk)
,.rf_alarm_vf_synd1_wclk_rst_n (rf_alarm_vf_synd1_wclk_rst_n)
,.rf_alarm_vf_synd1_we    (rf_alarm_vf_synd1_we)
,.rf_alarm_vf_synd1_wdata (rf_alarm_vf_synd1_wdata)
,.rf_alarm_vf_synd1_rdata (rf_alarm_vf_synd1_rdata)

,.func_alarm_vf_synd2_re    (func_alarm_vf_synd2_re)
,.func_alarm_vf_synd2_raddr (func_alarm_vf_synd2_raddr)
,.func_alarm_vf_synd2_waddr (func_alarm_vf_synd2_waddr)
,.func_alarm_vf_synd2_we    (func_alarm_vf_synd2_we)
,.func_alarm_vf_synd2_wdata (func_alarm_vf_synd2_wdata)
,.func_alarm_vf_synd2_rdata (func_alarm_vf_synd2_rdata)

,.rf_alarm_vf_synd2_rclk (rf_alarm_vf_synd2_rclk)
,.rf_alarm_vf_synd2_rclk_rst_n (rf_alarm_vf_synd2_rclk_rst_n)
,.rf_alarm_vf_synd2_re    (rf_alarm_vf_synd2_re)
,.rf_alarm_vf_synd2_raddr (rf_alarm_vf_synd2_raddr)
,.rf_alarm_vf_synd2_waddr (rf_alarm_vf_synd2_waddr)
,.rf_alarm_vf_synd2_wclk (rf_alarm_vf_synd2_wclk)
,.rf_alarm_vf_synd2_wclk_rst_n (rf_alarm_vf_synd2_wclk_rst_n)
,.rf_alarm_vf_synd2_we    (rf_alarm_vf_synd2_we)
,.rf_alarm_vf_synd2_wdata (rf_alarm_vf_synd2_wdata)
,.rf_alarm_vf_synd2_rdata (rf_alarm_vf_synd2_rdata)

,.func_dir_wb0_re    (func_dir_wb0_re)
,.func_dir_wb0_raddr (func_dir_wb0_raddr)
,.func_dir_wb0_waddr (func_dir_wb0_waddr)
,.func_dir_wb0_we    (func_dir_wb0_we)
,.func_dir_wb0_wdata (func_dir_wb0_wdata)
,.func_dir_wb0_rdata (func_dir_wb0_rdata)

,.rf_dir_wb0_rclk (rf_dir_wb0_rclk)
,.rf_dir_wb0_rclk_rst_n (rf_dir_wb0_rclk_rst_n)
,.rf_dir_wb0_re    (rf_dir_wb0_re)
,.rf_dir_wb0_raddr (rf_dir_wb0_raddr)
,.rf_dir_wb0_waddr (rf_dir_wb0_waddr)
,.rf_dir_wb0_wclk (rf_dir_wb0_wclk)
,.rf_dir_wb0_wclk_rst_n (rf_dir_wb0_wclk_rst_n)
,.rf_dir_wb0_we    (rf_dir_wb0_we)
,.rf_dir_wb0_wdata (rf_dir_wb0_wdata)
,.rf_dir_wb0_rdata (rf_dir_wb0_rdata)

,.func_dir_wb1_re    (func_dir_wb1_re)
,.func_dir_wb1_raddr (func_dir_wb1_raddr)
,.func_dir_wb1_waddr (func_dir_wb1_waddr)
,.func_dir_wb1_we    (func_dir_wb1_we)
,.func_dir_wb1_wdata (func_dir_wb1_wdata)
,.func_dir_wb1_rdata (func_dir_wb1_rdata)

,.rf_dir_wb1_rclk (rf_dir_wb1_rclk)
,.rf_dir_wb1_rclk_rst_n (rf_dir_wb1_rclk_rst_n)
,.rf_dir_wb1_re    (rf_dir_wb1_re)
,.rf_dir_wb1_raddr (rf_dir_wb1_raddr)
,.rf_dir_wb1_waddr (rf_dir_wb1_waddr)
,.rf_dir_wb1_wclk (rf_dir_wb1_wclk)
,.rf_dir_wb1_wclk_rst_n (rf_dir_wb1_wclk_rst_n)
,.rf_dir_wb1_we    (rf_dir_wb1_we)
,.rf_dir_wb1_wdata (rf_dir_wb1_wdata)
,.rf_dir_wb1_rdata (rf_dir_wb1_rdata)

,.func_dir_wb2_re    (func_dir_wb2_re)
,.func_dir_wb2_raddr (func_dir_wb2_raddr)
,.func_dir_wb2_waddr (func_dir_wb2_waddr)
,.func_dir_wb2_we    (func_dir_wb2_we)
,.func_dir_wb2_wdata (func_dir_wb2_wdata)
,.func_dir_wb2_rdata (func_dir_wb2_rdata)

,.rf_dir_wb2_rclk (rf_dir_wb2_rclk)
,.rf_dir_wb2_rclk_rst_n (rf_dir_wb2_rclk_rst_n)
,.rf_dir_wb2_re    (rf_dir_wb2_re)
,.rf_dir_wb2_raddr (rf_dir_wb2_raddr)
,.rf_dir_wb2_waddr (rf_dir_wb2_waddr)
,.rf_dir_wb2_wclk (rf_dir_wb2_wclk)
,.rf_dir_wb2_wclk_rst_n (rf_dir_wb2_wclk_rst_n)
,.rf_dir_wb2_we    (rf_dir_wb2_we)
,.rf_dir_wb2_wdata (rf_dir_wb2_wdata)
,.rf_dir_wb2_rdata (rf_dir_wb2_rdata)

,.func_hcw_enq_fifo_re    (func_hcw_enq_fifo_re)
,.func_hcw_enq_fifo_raddr (func_hcw_enq_fifo_raddr)
,.func_hcw_enq_fifo_waddr (func_hcw_enq_fifo_waddr)
,.func_hcw_enq_fifo_we    (func_hcw_enq_fifo_we)
,.func_hcw_enq_fifo_wdata (func_hcw_enq_fifo_wdata)
,.func_hcw_enq_fifo_rdata (func_hcw_enq_fifo_rdata)

,.rf_hcw_enq_fifo_rclk (rf_hcw_enq_fifo_rclk)
,.rf_hcw_enq_fifo_rclk_rst_n (rf_hcw_enq_fifo_rclk_rst_n)
,.rf_hcw_enq_fifo_re    (rf_hcw_enq_fifo_re)
,.rf_hcw_enq_fifo_raddr (rf_hcw_enq_fifo_raddr)
,.rf_hcw_enq_fifo_waddr (rf_hcw_enq_fifo_waddr)
,.rf_hcw_enq_fifo_wclk (rf_hcw_enq_fifo_wclk)
,.rf_hcw_enq_fifo_wclk_rst_n (rf_hcw_enq_fifo_wclk_rst_n)
,.rf_hcw_enq_fifo_we    (rf_hcw_enq_fifo_we)
,.rf_hcw_enq_fifo_wdata (rf_hcw_enq_fifo_wdata)
,.rf_hcw_enq_fifo_rdata (rf_hcw_enq_fifo_rdata)

,.func_ldb_wb0_re    (func_ldb_wb0_re)
,.func_ldb_wb0_raddr (func_ldb_wb0_raddr)
,.func_ldb_wb0_waddr (func_ldb_wb0_waddr)
,.func_ldb_wb0_we    (func_ldb_wb0_we)
,.func_ldb_wb0_wdata (func_ldb_wb0_wdata)
,.func_ldb_wb0_rdata (func_ldb_wb0_rdata)

,.rf_ldb_wb0_rclk (rf_ldb_wb0_rclk)
,.rf_ldb_wb0_rclk_rst_n (rf_ldb_wb0_rclk_rst_n)
,.rf_ldb_wb0_re    (rf_ldb_wb0_re)
,.rf_ldb_wb0_raddr (rf_ldb_wb0_raddr)
,.rf_ldb_wb0_waddr (rf_ldb_wb0_waddr)
,.rf_ldb_wb0_wclk (rf_ldb_wb0_wclk)
,.rf_ldb_wb0_wclk_rst_n (rf_ldb_wb0_wclk_rst_n)
,.rf_ldb_wb0_we    (rf_ldb_wb0_we)
,.rf_ldb_wb0_wdata (rf_ldb_wb0_wdata)
,.rf_ldb_wb0_rdata (rf_ldb_wb0_rdata)

,.func_ldb_wb1_re    (func_ldb_wb1_re)
,.func_ldb_wb1_raddr (func_ldb_wb1_raddr)
,.func_ldb_wb1_waddr (func_ldb_wb1_waddr)
,.func_ldb_wb1_we    (func_ldb_wb1_we)
,.func_ldb_wb1_wdata (func_ldb_wb1_wdata)
,.func_ldb_wb1_rdata (func_ldb_wb1_rdata)

,.rf_ldb_wb1_rclk (rf_ldb_wb1_rclk)
,.rf_ldb_wb1_rclk_rst_n (rf_ldb_wb1_rclk_rst_n)
,.rf_ldb_wb1_re    (rf_ldb_wb1_re)
,.rf_ldb_wb1_raddr (rf_ldb_wb1_raddr)
,.rf_ldb_wb1_waddr (rf_ldb_wb1_waddr)
,.rf_ldb_wb1_wclk (rf_ldb_wb1_wclk)
,.rf_ldb_wb1_wclk_rst_n (rf_ldb_wb1_wclk_rst_n)
,.rf_ldb_wb1_we    (rf_ldb_wb1_we)
,.rf_ldb_wb1_wdata (rf_ldb_wb1_wdata)
,.rf_ldb_wb1_rdata (rf_ldb_wb1_rdata)

,.func_ldb_wb2_re    (func_ldb_wb2_re)
,.func_ldb_wb2_raddr (func_ldb_wb2_raddr)
,.func_ldb_wb2_waddr (func_ldb_wb2_waddr)
,.func_ldb_wb2_we    (func_ldb_wb2_we)
,.func_ldb_wb2_wdata (func_ldb_wb2_wdata)
,.func_ldb_wb2_rdata (func_ldb_wb2_rdata)

,.rf_ldb_wb2_rclk (rf_ldb_wb2_rclk)
,.rf_ldb_wb2_rclk_rst_n (rf_ldb_wb2_rclk_rst_n)
,.rf_ldb_wb2_re    (rf_ldb_wb2_re)
,.rf_ldb_wb2_raddr (rf_ldb_wb2_raddr)
,.rf_ldb_wb2_waddr (rf_ldb_wb2_waddr)
,.rf_ldb_wb2_wclk (rf_ldb_wb2_wclk)
,.rf_ldb_wb2_wclk_rst_n (rf_ldb_wb2_wclk_rst_n)
,.rf_ldb_wb2_we    (rf_ldb_wb2_we)
,.rf_ldb_wb2_wdata (rf_ldb_wb2_wdata)
,.rf_ldb_wb2_rdata (rf_ldb_wb2_rdata)

,.func_lut_dir_cq2vf_pf_ro_re    (func_lut_dir_cq2vf_pf_ro_re)
,.func_lut_dir_cq2vf_pf_ro_raddr (func_lut_dir_cq2vf_pf_ro_raddr)
,.func_lut_dir_cq2vf_pf_ro_waddr (func_lut_dir_cq2vf_pf_ro_waddr)
,.func_lut_dir_cq2vf_pf_ro_we    (func_lut_dir_cq2vf_pf_ro_we)
,.func_lut_dir_cq2vf_pf_ro_wdata (func_lut_dir_cq2vf_pf_ro_wdata)
,.func_lut_dir_cq2vf_pf_ro_rdata (func_lut_dir_cq2vf_pf_ro_rdata)

,.rf_lut_dir_cq2vf_pf_ro_rclk (rf_lut_dir_cq2vf_pf_ro_rclk)
,.rf_lut_dir_cq2vf_pf_ro_rclk_rst_n (rf_lut_dir_cq2vf_pf_ro_rclk_rst_n)
,.rf_lut_dir_cq2vf_pf_ro_re    (rf_lut_dir_cq2vf_pf_ro_re)
,.rf_lut_dir_cq2vf_pf_ro_raddr (rf_lut_dir_cq2vf_pf_ro_raddr)
,.rf_lut_dir_cq2vf_pf_ro_waddr (rf_lut_dir_cq2vf_pf_ro_waddr)
,.rf_lut_dir_cq2vf_pf_ro_wclk (rf_lut_dir_cq2vf_pf_ro_wclk)
,.rf_lut_dir_cq2vf_pf_ro_wclk_rst_n (rf_lut_dir_cq2vf_pf_ro_wclk_rst_n)
,.rf_lut_dir_cq2vf_pf_ro_we    (rf_lut_dir_cq2vf_pf_ro_we)
,.rf_lut_dir_cq2vf_pf_ro_wdata (rf_lut_dir_cq2vf_pf_ro_wdata)
,.rf_lut_dir_cq2vf_pf_ro_rdata (rf_lut_dir_cq2vf_pf_ro_rdata)

,.func_lut_dir_cq_addr_l_re    (func_lut_dir_cq_addr_l_re)
,.func_lut_dir_cq_addr_l_raddr (func_lut_dir_cq_addr_l_raddr)
,.func_lut_dir_cq_addr_l_waddr (func_lut_dir_cq_addr_l_waddr)
,.func_lut_dir_cq_addr_l_we    (func_lut_dir_cq_addr_l_we)
,.func_lut_dir_cq_addr_l_wdata (func_lut_dir_cq_addr_l_wdata)
,.func_lut_dir_cq_addr_l_rdata (func_lut_dir_cq_addr_l_rdata)

,.rf_lut_dir_cq_addr_l_rclk (rf_lut_dir_cq_addr_l_rclk)
,.rf_lut_dir_cq_addr_l_rclk_rst_n (rf_lut_dir_cq_addr_l_rclk_rst_n)
,.rf_lut_dir_cq_addr_l_re    (rf_lut_dir_cq_addr_l_re)
,.rf_lut_dir_cq_addr_l_raddr (rf_lut_dir_cq_addr_l_raddr)
,.rf_lut_dir_cq_addr_l_waddr (rf_lut_dir_cq_addr_l_waddr)
,.rf_lut_dir_cq_addr_l_wclk (rf_lut_dir_cq_addr_l_wclk)
,.rf_lut_dir_cq_addr_l_wclk_rst_n (rf_lut_dir_cq_addr_l_wclk_rst_n)
,.rf_lut_dir_cq_addr_l_we    (rf_lut_dir_cq_addr_l_we)
,.rf_lut_dir_cq_addr_l_wdata (rf_lut_dir_cq_addr_l_wdata)
,.rf_lut_dir_cq_addr_l_rdata (rf_lut_dir_cq_addr_l_rdata)

,.func_lut_dir_cq_addr_u_re    (func_lut_dir_cq_addr_u_re)
,.func_lut_dir_cq_addr_u_raddr (func_lut_dir_cq_addr_u_raddr)
,.func_lut_dir_cq_addr_u_waddr (func_lut_dir_cq_addr_u_waddr)
,.func_lut_dir_cq_addr_u_we    (func_lut_dir_cq_addr_u_we)
,.func_lut_dir_cq_addr_u_wdata (func_lut_dir_cq_addr_u_wdata)
,.func_lut_dir_cq_addr_u_rdata (func_lut_dir_cq_addr_u_rdata)

,.rf_lut_dir_cq_addr_u_rclk (rf_lut_dir_cq_addr_u_rclk)
,.rf_lut_dir_cq_addr_u_rclk_rst_n (rf_lut_dir_cq_addr_u_rclk_rst_n)
,.rf_lut_dir_cq_addr_u_re    (rf_lut_dir_cq_addr_u_re)
,.rf_lut_dir_cq_addr_u_raddr (rf_lut_dir_cq_addr_u_raddr)
,.rf_lut_dir_cq_addr_u_waddr (rf_lut_dir_cq_addr_u_waddr)
,.rf_lut_dir_cq_addr_u_wclk (rf_lut_dir_cq_addr_u_wclk)
,.rf_lut_dir_cq_addr_u_wclk_rst_n (rf_lut_dir_cq_addr_u_wclk_rst_n)
,.rf_lut_dir_cq_addr_u_we    (rf_lut_dir_cq_addr_u_we)
,.rf_lut_dir_cq_addr_u_wdata (rf_lut_dir_cq_addr_u_wdata)
,.rf_lut_dir_cq_addr_u_rdata (rf_lut_dir_cq_addr_u_rdata)

,.func_lut_dir_cq_ai_addr_l_re    (func_lut_dir_cq_ai_addr_l_re)
,.func_lut_dir_cq_ai_addr_l_raddr (func_lut_dir_cq_ai_addr_l_raddr)
,.func_lut_dir_cq_ai_addr_l_waddr (func_lut_dir_cq_ai_addr_l_waddr)
,.func_lut_dir_cq_ai_addr_l_we    (func_lut_dir_cq_ai_addr_l_we)
,.func_lut_dir_cq_ai_addr_l_wdata (func_lut_dir_cq_ai_addr_l_wdata)
,.func_lut_dir_cq_ai_addr_l_rdata (func_lut_dir_cq_ai_addr_l_rdata)

,.rf_lut_dir_cq_ai_addr_l_rclk (rf_lut_dir_cq_ai_addr_l_rclk)
,.rf_lut_dir_cq_ai_addr_l_rclk_rst_n (rf_lut_dir_cq_ai_addr_l_rclk_rst_n)
,.rf_lut_dir_cq_ai_addr_l_re    (rf_lut_dir_cq_ai_addr_l_re)
,.rf_lut_dir_cq_ai_addr_l_raddr (rf_lut_dir_cq_ai_addr_l_raddr)
,.rf_lut_dir_cq_ai_addr_l_waddr (rf_lut_dir_cq_ai_addr_l_waddr)
,.rf_lut_dir_cq_ai_addr_l_wclk (rf_lut_dir_cq_ai_addr_l_wclk)
,.rf_lut_dir_cq_ai_addr_l_wclk_rst_n (rf_lut_dir_cq_ai_addr_l_wclk_rst_n)
,.rf_lut_dir_cq_ai_addr_l_we    (rf_lut_dir_cq_ai_addr_l_we)
,.rf_lut_dir_cq_ai_addr_l_wdata (rf_lut_dir_cq_ai_addr_l_wdata)
,.rf_lut_dir_cq_ai_addr_l_rdata (rf_lut_dir_cq_ai_addr_l_rdata)

,.func_lut_dir_cq_ai_addr_u_re    (func_lut_dir_cq_ai_addr_u_re)
,.func_lut_dir_cq_ai_addr_u_raddr (func_lut_dir_cq_ai_addr_u_raddr)
,.func_lut_dir_cq_ai_addr_u_waddr (func_lut_dir_cq_ai_addr_u_waddr)
,.func_lut_dir_cq_ai_addr_u_we    (func_lut_dir_cq_ai_addr_u_we)
,.func_lut_dir_cq_ai_addr_u_wdata (func_lut_dir_cq_ai_addr_u_wdata)
,.func_lut_dir_cq_ai_addr_u_rdata (func_lut_dir_cq_ai_addr_u_rdata)

,.rf_lut_dir_cq_ai_addr_u_rclk (rf_lut_dir_cq_ai_addr_u_rclk)
,.rf_lut_dir_cq_ai_addr_u_rclk_rst_n (rf_lut_dir_cq_ai_addr_u_rclk_rst_n)
,.rf_lut_dir_cq_ai_addr_u_re    (rf_lut_dir_cq_ai_addr_u_re)
,.rf_lut_dir_cq_ai_addr_u_raddr (rf_lut_dir_cq_ai_addr_u_raddr)
,.rf_lut_dir_cq_ai_addr_u_waddr (rf_lut_dir_cq_ai_addr_u_waddr)
,.rf_lut_dir_cq_ai_addr_u_wclk (rf_lut_dir_cq_ai_addr_u_wclk)
,.rf_lut_dir_cq_ai_addr_u_wclk_rst_n (rf_lut_dir_cq_ai_addr_u_wclk_rst_n)
,.rf_lut_dir_cq_ai_addr_u_we    (rf_lut_dir_cq_ai_addr_u_we)
,.rf_lut_dir_cq_ai_addr_u_wdata (rf_lut_dir_cq_ai_addr_u_wdata)
,.rf_lut_dir_cq_ai_addr_u_rdata (rf_lut_dir_cq_ai_addr_u_rdata)

,.func_lut_dir_cq_ai_data_re    (func_lut_dir_cq_ai_data_re)
,.func_lut_dir_cq_ai_data_raddr (func_lut_dir_cq_ai_data_raddr)
,.func_lut_dir_cq_ai_data_waddr (func_lut_dir_cq_ai_data_waddr)
,.func_lut_dir_cq_ai_data_we    (func_lut_dir_cq_ai_data_we)
,.func_lut_dir_cq_ai_data_wdata (func_lut_dir_cq_ai_data_wdata)
,.func_lut_dir_cq_ai_data_rdata (func_lut_dir_cq_ai_data_rdata)

,.rf_lut_dir_cq_ai_data_rclk (rf_lut_dir_cq_ai_data_rclk)
,.rf_lut_dir_cq_ai_data_rclk_rst_n (rf_lut_dir_cq_ai_data_rclk_rst_n)
,.rf_lut_dir_cq_ai_data_re    (rf_lut_dir_cq_ai_data_re)
,.rf_lut_dir_cq_ai_data_raddr (rf_lut_dir_cq_ai_data_raddr)
,.rf_lut_dir_cq_ai_data_waddr (rf_lut_dir_cq_ai_data_waddr)
,.rf_lut_dir_cq_ai_data_wclk (rf_lut_dir_cq_ai_data_wclk)
,.rf_lut_dir_cq_ai_data_wclk_rst_n (rf_lut_dir_cq_ai_data_wclk_rst_n)
,.rf_lut_dir_cq_ai_data_we    (rf_lut_dir_cq_ai_data_we)
,.rf_lut_dir_cq_ai_data_wdata (rf_lut_dir_cq_ai_data_wdata)
,.rf_lut_dir_cq_ai_data_rdata (rf_lut_dir_cq_ai_data_rdata)

,.func_lut_dir_cq_isr_re    (func_lut_dir_cq_isr_re)
,.func_lut_dir_cq_isr_raddr (func_lut_dir_cq_isr_raddr)
,.func_lut_dir_cq_isr_waddr (func_lut_dir_cq_isr_waddr)
,.func_lut_dir_cq_isr_we    (func_lut_dir_cq_isr_we)
,.func_lut_dir_cq_isr_wdata (func_lut_dir_cq_isr_wdata)
,.func_lut_dir_cq_isr_rdata (func_lut_dir_cq_isr_rdata)

,.rf_lut_dir_cq_isr_rclk (rf_lut_dir_cq_isr_rclk)
,.rf_lut_dir_cq_isr_rclk_rst_n (rf_lut_dir_cq_isr_rclk_rst_n)
,.rf_lut_dir_cq_isr_re    (rf_lut_dir_cq_isr_re)
,.rf_lut_dir_cq_isr_raddr (rf_lut_dir_cq_isr_raddr)
,.rf_lut_dir_cq_isr_waddr (rf_lut_dir_cq_isr_waddr)
,.rf_lut_dir_cq_isr_wclk (rf_lut_dir_cq_isr_wclk)
,.rf_lut_dir_cq_isr_wclk_rst_n (rf_lut_dir_cq_isr_wclk_rst_n)
,.rf_lut_dir_cq_isr_we    (rf_lut_dir_cq_isr_we)
,.rf_lut_dir_cq_isr_wdata (rf_lut_dir_cq_isr_wdata)
,.rf_lut_dir_cq_isr_rdata (rf_lut_dir_cq_isr_rdata)

,.func_lut_dir_cq_pasid_re    (func_lut_dir_cq_pasid_re)
,.func_lut_dir_cq_pasid_raddr (func_lut_dir_cq_pasid_raddr)
,.func_lut_dir_cq_pasid_waddr (func_lut_dir_cq_pasid_waddr)
,.func_lut_dir_cq_pasid_we    (func_lut_dir_cq_pasid_we)
,.func_lut_dir_cq_pasid_wdata (func_lut_dir_cq_pasid_wdata)
,.func_lut_dir_cq_pasid_rdata (func_lut_dir_cq_pasid_rdata)

,.rf_lut_dir_cq_pasid_rclk (rf_lut_dir_cq_pasid_rclk)
,.rf_lut_dir_cq_pasid_rclk_rst_n (rf_lut_dir_cq_pasid_rclk_rst_n)
,.rf_lut_dir_cq_pasid_re    (rf_lut_dir_cq_pasid_re)
,.rf_lut_dir_cq_pasid_raddr (rf_lut_dir_cq_pasid_raddr)
,.rf_lut_dir_cq_pasid_waddr (rf_lut_dir_cq_pasid_waddr)
,.rf_lut_dir_cq_pasid_wclk (rf_lut_dir_cq_pasid_wclk)
,.rf_lut_dir_cq_pasid_wclk_rst_n (rf_lut_dir_cq_pasid_wclk_rst_n)
,.rf_lut_dir_cq_pasid_we    (rf_lut_dir_cq_pasid_we)
,.rf_lut_dir_cq_pasid_wdata (rf_lut_dir_cq_pasid_wdata)
,.rf_lut_dir_cq_pasid_rdata (rf_lut_dir_cq_pasid_rdata)

,.func_lut_dir_pp2vas_re    (func_lut_dir_pp2vas_re)
,.func_lut_dir_pp2vas_raddr (func_lut_dir_pp2vas_raddr)
,.func_lut_dir_pp2vas_waddr (func_lut_dir_pp2vas_waddr)
,.func_lut_dir_pp2vas_we    (func_lut_dir_pp2vas_we)
,.func_lut_dir_pp2vas_wdata (func_lut_dir_pp2vas_wdata)
,.func_lut_dir_pp2vas_rdata (func_lut_dir_pp2vas_rdata)

,.rf_lut_dir_pp2vas_rclk (rf_lut_dir_pp2vas_rclk)
,.rf_lut_dir_pp2vas_rclk_rst_n (rf_lut_dir_pp2vas_rclk_rst_n)
,.rf_lut_dir_pp2vas_re    (rf_lut_dir_pp2vas_re)
,.rf_lut_dir_pp2vas_raddr (rf_lut_dir_pp2vas_raddr)
,.rf_lut_dir_pp2vas_waddr (rf_lut_dir_pp2vas_waddr)
,.rf_lut_dir_pp2vas_wclk (rf_lut_dir_pp2vas_wclk)
,.rf_lut_dir_pp2vas_wclk_rst_n (rf_lut_dir_pp2vas_wclk_rst_n)
,.rf_lut_dir_pp2vas_we    (rf_lut_dir_pp2vas_we)
,.rf_lut_dir_pp2vas_wdata (rf_lut_dir_pp2vas_wdata)
,.rf_lut_dir_pp2vas_rdata (rf_lut_dir_pp2vas_rdata)

,.func_lut_dir_pp_v_re    (func_lut_dir_pp_v_re)
,.func_lut_dir_pp_v_raddr (func_lut_dir_pp_v_raddr)
,.func_lut_dir_pp_v_waddr (func_lut_dir_pp_v_waddr)
,.func_lut_dir_pp_v_we    (func_lut_dir_pp_v_we)
,.func_lut_dir_pp_v_wdata (func_lut_dir_pp_v_wdata)
,.func_lut_dir_pp_v_rdata (func_lut_dir_pp_v_rdata)

,.rf_lut_dir_pp_v_rclk (rf_lut_dir_pp_v_rclk)
,.rf_lut_dir_pp_v_rclk_rst_n (rf_lut_dir_pp_v_rclk_rst_n)
,.rf_lut_dir_pp_v_re    (rf_lut_dir_pp_v_re)
,.rf_lut_dir_pp_v_raddr (rf_lut_dir_pp_v_raddr)
,.rf_lut_dir_pp_v_waddr (rf_lut_dir_pp_v_waddr)
,.rf_lut_dir_pp_v_wclk (rf_lut_dir_pp_v_wclk)
,.rf_lut_dir_pp_v_wclk_rst_n (rf_lut_dir_pp_v_wclk_rst_n)
,.rf_lut_dir_pp_v_we    (rf_lut_dir_pp_v_we)
,.rf_lut_dir_pp_v_wdata (rf_lut_dir_pp_v_wdata)
,.rf_lut_dir_pp_v_rdata (rf_lut_dir_pp_v_rdata)

,.func_lut_dir_vasqid_v_re    (func_lut_dir_vasqid_v_re)
,.func_lut_dir_vasqid_v_raddr (func_lut_dir_vasqid_v_raddr)
,.func_lut_dir_vasqid_v_waddr (func_lut_dir_vasqid_v_waddr)
,.func_lut_dir_vasqid_v_we    (func_lut_dir_vasqid_v_we)
,.func_lut_dir_vasqid_v_wdata (func_lut_dir_vasqid_v_wdata)
,.func_lut_dir_vasqid_v_rdata (func_lut_dir_vasqid_v_rdata)

,.rf_lut_dir_vasqid_v_rclk (rf_lut_dir_vasqid_v_rclk)
,.rf_lut_dir_vasqid_v_rclk_rst_n (rf_lut_dir_vasqid_v_rclk_rst_n)
,.rf_lut_dir_vasqid_v_re    (rf_lut_dir_vasqid_v_re)
,.rf_lut_dir_vasqid_v_raddr (rf_lut_dir_vasqid_v_raddr)
,.rf_lut_dir_vasqid_v_waddr (rf_lut_dir_vasqid_v_waddr)
,.rf_lut_dir_vasqid_v_wclk (rf_lut_dir_vasqid_v_wclk)
,.rf_lut_dir_vasqid_v_wclk_rst_n (rf_lut_dir_vasqid_v_wclk_rst_n)
,.rf_lut_dir_vasqid_v_we    (rf_lut_dir_vasqid_v_we)
,.rf_lut_dir_vasqid_v_wdata (rf_lut_dir_vasqid_v_wdata)
,.rf_lut_dir_vasqid_v_rdata (rf_lut_dir_vasqid_v_rdata)

,.func_lut_ldb_cq2vf_pf_ro_re    (func_lut_ldb_cq2vf_pf_ro_re)
,.func_lut_ldb_cq2vf_pf_ro_raddr (func_lut_ldb_cq2vf_pf_ro_raddr)
,.func_lut_ldb_cq2vf_pf_ro_waddr (func_lut_ldb_cq2vf_pf_ro_waddr)
,.func_lut_ldb_cq2vf_pf_ro_we    (func_lut_ldb_cq2vf_pf_ro_we)
,.func_lut_ldb_cq2vf_pf_ro_wdata (func_lut_ldb_cq2vf_pf_ro_wdata)
,.func_lut_ldb_cq2vf_pf_ro_rdata (func_lut_ldb_cq2vf_pf_ro_rdata)

,.rf_lut_ldb_cq2vf_pf_ro_rclk (rf_lut_ldb_cq2vf_pf_ro_rclk)
,.rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n (rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n)
,.rf_lut_ldb_cq2vf_pf_ro_re    (rf_lut_ldb_cq2vf_pf_ro_re)
,.rf_lut_ldb_cq2vf_pf_ro_raddr (rf_lut_ldb_cq2vf_pf_ro_raddr)
,.rf_lut_ldb_cq2vf_pf_ro_waddr (rf_lut_ldb_cq2vf_pf_ro_waddr)
,.rf_lut_ldb_cq2vf_pf_ro_wclk (rf_lut_ldb_cq2vf_pf_ro_wclk)
,.rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n (rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n)
,.rf_lut_ldb_cq2vf_pf_ro_we    (rf_lut_ldb_cq2vf_pf_ro_we)
,.rf_lut_ldb_cq2vf_pf_ro_wdata (rf_lut_ldb_cq2vf_pf_ro_wdata)
,.rf_lut_ldb_cq2vf_pf_ro_rdata (rf_lut_ldb_cq2vf_pf_ro_rdata)

,.func_lut_ldb_cq_addr_l_re    (func_lut_ldb_cq_addr_l_re)
,.func_lut_ldb_cq_addr_l_raddr (func_lut_ldb_cq_addr_l_raddr)
,.func_lut_ldb_cq_addr_l_waddr (func_lut_ldb_cq_addr_l_waddr)
,.func_lut_ldb_cq_addr_l_we    (func_lut_ldb_cq_addr_l_we)
,.func_lut_ldb_cq_addr_l_wdata (func_lut_ldb_cq_addr_l_wdata)
,.func_lut_ldb_cq_addr_l_rdata (func_lut_ldb_cq_addr_l_rdata)

,.rf_lut_ldb_cq_addr_l_rclk (rf_lut_ldb_cq_addr_l_rclk)
,.rf_lut_ldb_cq_addr_l_rclk_rst_n (rf_lut_ldb_cq_addr_l_rclk_rst_n)
,.rf_lut_ldb_cq_addr_l_re    (rf_lut_ldb_cq_addr_l_re)
,.rf_lut_ldb_cq_addr_l_raddr (rf_lut_ldb_cq_addr_l_raddr)
,.rf_lut_ldb_cq_addr_l_waddr (rf_lut_ldb_cq_addr_l_waddr)
,.rf_lut_ldb_cq_addr_l_wclk (rf_lut_ldb_cq_addr_l_wclk)
,.rf_lut_ldb_cq_addr_l_wclk_rst_n (rf_lut_ldb_cq_addr_l_wclk_rst_n)
,.rf_lut_ldb_cq_addr_l_we    (rf_lut_ldb_cq_addr_l_we)
,.rf_lut_ldb_cq_addr_l_wdata (rf_lut_ldb_cq_addr_l_wdata)
,.rf_lut_ldb_cq_addr_l_rdata (rf_lut_ldb_cq_addr_l_rdata)

,.func_lut_ldb_cq_addr_u_re    (func_lut_ldb_cq_addr_u_re)
,.func_lut_ldb_cq_addr_u_raddr (func_lut_ldb_cq_addr_u_raddr)
,.func_lut_ldb_cq_addr_u_waddr (func_lut_ldb_cq_addr_u_waddr)
,.func_lut_ldb_cq_addr_u_we    (func_lut_ldb_cq_addr_u_we)
,.func_lut_ldb_cq_addr_u_wdata (func_lut_ldb_cq_addr_u_wdata)
,.func_lut_ldb_cq_addr_u_rdata (func_lut_ldb_cq_addr_u_rdata)

,.rf_lut_ldb_cq_addr_u_rclk (rf_lut_ldb_cq_addr_u_rclk)
,.rf_lut_ldb_cq_addr_u_rclk_rst_n (rf_lut_ldb_cq_addr_u_rclk_rst_n)
,.rf_lut_ldb_cq_addr_u_re    (rf_lut_ldb_cq_addr_u_re)
,.rf_lut_ldb_cq_addr_u_raddr (rf_lut_ldb_cq_addr_u_raddr)
,.rf_lut_ldb_cq_addr_u_waddr (rf_lut_ldb_cq_addr_u_waddr)
,.rf_lut_ldb_cq_addr_u_wclk (rf_lut_ldb_cq_addr_u_wclk)
,.rf_lut_ldb_cq_addr_u_wclk_rst_n (rf_lut_ldb_cq_addr_u_wclk_rst_n)
,.rf_lut_ldb_cq_addr_u_we    (rf_lut_ldb_cq_addr_u_we)
,.rf_lut_ldb_cq_addr_u_wdata (rf_lut_ldb_cq_addr_u_wdata)
,.rf_lut_ldb_cq_addr_u_rdata (rf_lut_ldb_cq_addr_u_rdata)

,.func_lut_ldb_cq_ai_addr_l_re    (func_lut_ldb_cq_ai_addr_l_re)
,.func_lut_ldb_cq_ai_addr_l_raddr (func_lut_ldb_cq_ai_addr_l_raddr)
,.func_lut_ldb_cq_ai_addr_l_waddr (func_lut_ldb_cq_ai_addr_l_waddr)
,.func_lut_ldb_cq_ai_addr_l_we    (func_lut_ldb_cq_ai_addr_l_we)
,.func_lut_ldb_cq_ai_addr_l_wdata (func_lut_ldb_cq_ai_addr_l_wdata)
,.func_lut_ldb_cq_ai_addr_l_rdata (func_lut_ldb_cq_ai_addr_l_rdata)

,.rf_lut_ldb_cq_ai_addr_l_rclk (rf_lut_ldb_cq_ai_addr_l_rclk)
,.rf_lut_ldb_cq_ai_addr_l_rclk_rst_n (rf_lut_ldb_cq_ai_addr_l_rclk_rst_n)
,.rf_lut_ldb_cq_ai_addr_l_re    (rf_lut_ldb_cq_ai_addr_l_re)
,.rf_lut_ldb_cq_ai_addr_l_raddr (rf_lut_ldb_cq_ai_addr_l_raddr)
,.rf_lut_ldb_cq_ai_addr_l_waddr (rf_lut_ldb_cq_ai_addr_l_waddr)
,.rf_lut_ldb_cq_ai_addr_l_wclk (rf_lut_ldb_cq_ai_addr_l_wclk)
,.rf_lut_ldb_cq_ai_addr_l_wclk_rst_n (rf_lut_ldb_cq_ai_addr_l_wclk_rst_n)
,.rf_lut_ldb_cq_ai_addr_l_we    (rf_lut_ldb_cq_ai_addr_l_we)
,.rf_lut_ldb_cq_ai_addr_l_wdata (rf_lut_ldb_cq_ai_addr_l_wdata)
,.rf_lut_ldb_cq_ai_addr_l_rdata (rf_lut_ldb_cq_ai_addr_l_rdata)

,.func_lut_ldb_cq_ai_addr_u_re    (func_lut_ldb_cq_ai_addr_u_re)
,.func_lut_ldb_cq_ai_addr_u_raddr (func_lut_ldb_cq_ai_addr_u_raddr)
,.func_lut_ldb_cq_ai_addr_u_waddr (func_lut_ldb_cq_ai_addr_u_waddr)
,.func_lut_ldb_cq_ai_addr_u_we    (func_lut_ldb_cq_ai_addr_u_we)
,.func_lut_ldb_cq_ai_addr_u_wdata (func_lut_ldb_cq_ai_addr_u_wdata)
,.func_lut_ldb_cq_ai_addr_u_rdata (func_lut_ldb_cq_ai_addr_u_rdata)

,.rf_lut_ldb_cq_ai_addr_u_rclk (rf_lut_ldb_cq_ai_addr_u_rclk)
,.rf_lut_ldb_cq_ai_addr_u_rclk_rst_n (rf_lut_ldb_cq_ai_addr_u_rclk_rst_n)
,.rf_lut_ldb_cq_ai_addr_u_re    (rf_lut_ldb_cq_ai_addr_u_re)
,.rf_lut_ldb_cq_ai_addr_u_raddr (rf_lut_ldb_cq_ai_addr_u_raddr)
,.rf_lut_ldb_cq_ai_addr_u_waddr (rf_lut_ldb_cq_ai_addr_u_waddr)
,.rf_lut_ldb_cq_ai_addr_u_wclk (rf_lut_ldb_cq_ai_addr_u_wclk)
,.rf_lut_ldb_cq_ai_addr_u_wclk_rst_n (rf_lut_ldb_cq_ai_addr_u_wclk_rst_n)
,.rf_lut_ldb_cq_ai_addr_u_we    (rf_lut_ldb_cq_ai_addr_u_we)
,.rf_lut_ldb_cq_ai_addr_u_wdata (rf_lut_ldb_cq_ai_addr_u_wdata)
,.rf_lut_ldb_cq_ai_addr_u_rdata (rf_lut_ldb_cq_ai_addr_u_rdata)

,.func_lut_ldb_cq_ai_data_re    (func_lut_ldb_cq_ai_data_re)
,.func_lut_ldb_cq_ai_data_raddr (func_lut_ldb_cq_ai_data_raddr)
,.func_lut_ldb_cq_ai_data_waddr (func_lut_ldb_cq_ai_data_waddr)
,.func_lut_ldb_cq_ai_data_we    (func_lut_ldb_cq_ai_data_we)
,.func_lut_ldb_cq_ai_data_wdata (func_lut_ldb_cq_ai_data_wdata)
,.func_lut_ldb_cq_ai_data_rdata (func_lut_ldb_cq_ai_data_rdata)

,.rf_lut_ldb_cq_ai_data_rclk (rf_lut_ldb_cq_ai_data_rclk)
,.rf_lut_ldb_cq_ai_data_rclk_rst_n (rf_lut_ldb_cq_ai_data_rclk_rst_n)
,.rf_lut_ldb_cq_ai_data_re    (rf_lut_ldb_cq_ai_data_re)
,.rf_lut_ldb_cq_ai_data_raddr (rf_lut_ldb_cq_ai_data_raddr)
,.rf_lut_ldb_cq_ai_data_waddr (rf_lut_ldb_cq_ai_data_waddr)
,.rf_lut_ldb_cq_ai_data_wclk (rf_lut_ldb_cq_ai_data_wclk)
,.rf_lut_ldb_cq_ai_data_wclk_rst_n (rf_lut_ldb_cq_ai_data_wclk_rst_n)
,.rf_lut_ldb_cq_ai_data_we    (rf_lut_ldb_cq_ai_data_we)
,.rf_lut_ldb_cq_ai_data_wdata (rf_lut_ldb_cq_ai_data_wdata)
,.rf_lut_ldb_cq_ai_data_rdata (rf_lut_ldb_cq_ai_data_rdata)

,.func_lut_ldb_cq_isr_re    (func_lut_ldb_cq_isr_re)
,.func_lut_ldb_cq_isr_raddr (func_lut_ldb_cq_isr_raddr)
,.func_lut_ldb_cq_isr_waddr (func_lut_ldb_cq_isr_waddr)
,.func_lut_ldb_cq_isr_we    (func_lut_ldb_cq_isr_we)
,.func_lut_ldb_cq_isr_wdata (func_lut_ldb_cq_isr_wdata)
,.func_lut_ldb_cq_isr_rdata (func_lut_ldb_cq_isr_rdata)

,.rf_lut_ldb_cq_isr_rclk (rf_lut_ldb_cq_isr_rclk)
,.rf_lut_ldb_cq_isr_rclk_rst_n (rf_lut_ldb_cq_isr_rclk_rst_n)
,.rf_lut_ldb_cq_isr_re    (rf_lut_ldb_cq_isr_re)
,.rf_lut_ldb_cq_isr_raddr (rf_lut_ldb_cq_isr_raddr)
,.rf_lut_ldb_cq_isr_waddr (rf_lut_ldb_cq_isr_waddr)
,.rf_lut_ldb_cq_isr_wclk (rf_lut_ldb_cq_isr_wclk)
,.rf_lut_ldb_cq_isr_wclk_rst_n (rf_lut_ldb_cq_isr_wclk_rst_n)
,.rf_lut_ldb_cq_isr_we    (rf_lut_ldb_cq_isr_we)
,.rf_lut_ldb_cq_isr_wdata (rf_lut_ldb_cq_isr_wdata)
,.rf_lut_ldb_cq_isr_rdata (rf_lut_ldb_cq_isr_rdata)

,.func_lut_ldb_cq_pasid_re    (func_lut_ldb_cq_pasid_re)
,.func_lut_ldb_cq_pasid_raddr (func_lut_ldb_cq_pasid_raddr)
,.func_lut_ldb_cq_pasid_waddr (func_lut_ldb_cq_pasid_waddr)
,.func_lut_ldb_cq_pasid_we    (func_lut_ldb_cq_pasid_we)
,.func_lut_ldb_cq_pasid_wdata (func_lut_ldb_cq_pasid_wdata)
,.func_lut_ldb_cq_pasid_rdata (func_lut_ldb_cq_pasid_rdata)

,.rf_lut_ldb_cq_pasid_rclk (rf_lut_ldb_cq_pasid_rclk)
,.rf_lut_ldb_cq_pasid_rclk_rst_n (rf_lut_ldb_cq_pasid_rclk_rst_n)
,.rf_lut_ldb_cq_pasid_re    (rf_lut_ldb_cq_pasid_re)
,.rf_lut_ldb_cq_pasid_raddr (rf_lut_ldb_cq_pasid_raddr)
,.rf_lut_ldb_cq_pasid_waddr (rf_lut_ldb_cq_pasid_waddr)
,.rf_lut_ldb_cq_pasid_wclk (rf_lut_ldb_cq_pasid_wclk)
,.rf_lut_ldb_cq_pasid_wclk_rst_n (rf_lut_ldb_cq_pasid_wclk_rst_n)
,.rf_lut_ldb_cq_pasid_we    (rf_lut_ldb_cq_pasid_we)
,.rf_lut_ldb_cq_pasid_wdata (rf_lut_ldb_cq_pasid_wdata)
,.rf_lut_ldb_cq_pasid_rdata (rf_lut_ldb_cq_pasid_rdata)

,.func_lut_ldb_pp2vas_re    (func_lut_ldb_pp2vas_re)
,.func_lut_ldb_pp2vas_raddr (func_lut_ldb_pp2vas_raddr)
,.func_lut_ldb_pp2vas_waddr (func_lut_ldb_pp2vas_waddr)
,.func_lut_ldb_pp2vas_we    (func_lut_ldb_pp2vas_we)
,.func_lut_ldb_pp2vas_wdata (func_lut_ldb_pp2vas_wdata)
,.func_lut_ldb_pp2vas_rdata (func_lut_ldb_pp2vas_rdata)

,.rf_lut_ldb_pp2vas_rclk (rf_lut_ldb_pp2vas_rclk)
,.rf_lut_ldb_pp2vas_rclk_rst_n (rf_lut_ldb_pp2vas_rclk_rst_n)
,.rf_lut_ldb_pp2vas_re    (rf_lut_ldb_pp2vas_re)
,.rf_lut_ldb_pp2vas_raddr (rf_lut_ldb_pp2vas_raddr)
,.rf_lut_ldb_pp2vas_waddr (rf_lut_ldb_pp2vas_waddr)
,.rf_lut_ldb_pp2vas_wclk (rf_lut_ldb_pp2vas_wclk)
,.rf_lut_ldb_pp2vas_wclk_rst_n (rf_lut_ldb_pp2vas_wclk_rst_n)
,.rf_lut_ldb_pp2vas_we    (rf_lut_ldb_pp2vas_we)
,.rf_lut_ldb_pp2vas_wdata (rf_lut_ldb_pp2vas_wdata)
,.rf_lut_ldb_pp2vas_rdata (rf_lut_ldb_pp2vas_rdata)

,.func_lut_ldb_qid2vqid_re    (func_lut_ldb_qid2vqid_re)
,.func_lut_ldb_qid2vqid_raddr (func_lut_ldb_qid2vqid_raddr)
,.func_lut_ldb_qid2vqid_waddr (func_lut_ldb_qid2vqid_waddr)
,.func_lut_ldb_qid2vqid_we    (func_lut_ldb_qid2vqid_we)
,.func_lut_ldb_qid2vqid_wdata (func_lut_ldb_qid2vqid_wdata)
,.func_lut_ldb_qid2vqid_rdata (func_lut_ldb_qid2vqid_rdata)

,.rf_lut_ldb_qid2vqid_rclk (rf_lut_ldb_qid2vqid_rclk)
,.rf_lut_ldb_qid2vqid_rclk_rst_n (rf_lut_ldb_qid2vqid_rclk_rst_n)
,.rf_lut_ldb_qid2vqid_re    (rf_lut_ldb_qid2vqid_re)
,.rf_lut_ldb_qid2vqid_raddr (rf_lut_ldb_qid2vqid_raddr)
,.rf_lut_ldb_qid2vqid_waddr (rf_lut_ldb_qid2vqid_waddr)
,.rf_lut_ldb_qid2vqid_wclk (rf_lut_ldb_qid2vqid_wclk)
,.rf_lut_ldb_qid2vqid_wclk_rst_n (rf_lut_ldb_qid2vqid_wclk_rst_n)
,.rf_lut_ldb_qid2vqid_we    (rf_lut_ldb_qid2vqid_we)
,.rf_lut_ldb_qid2vqid_wdata (rf_lut_ldb_qid2vqid_wdata)
,.rf_lut_ldb_qid2vqid_rdata (rf_lut_ldb_qid2vqid_rdata)

,.func_lut_ldb_vasqid_v_re    (func_lut_ldb_vasqid_v_re)
,.func_lut_ldb_vasqid_v_raddr (func_lut_ldb_vasqid_v_raddr)
,.func_lut_ldb_vasqid_v_waddr (func_lut_ldb_vasqid_v_waddr)
,.func_lut_ldb_vasqid_v_we    (func_lut_ldb_vasqid_v_we)
,.func_lut_ldb_vasqid_v_wdata (func_lut_ldb_vasqid_v_wdata)
,.func_lut_ldb_vasqid_v_rdata (func_lut_ldb_vasqid_v_rdata)

,.rf_lut_ldb_vasqid_v_rclk (rf_lut_ldb_vasqid_v_rclk)
,.rf_lut_ldb_vasqid_v_rclk_rst_n (rf_lut_ldb_vasqid_v_rclk_rst_n)
,.rf_lut_ldb_vasqid_v_re    (rf_lut_ldb_vasqid_v_re)
,.rf_lut_ldb_vasqid_v_raddr (rf_lut_ldb_vasqid_v_raddr)
,.rf_lut_ldb_vasqid_v_waddr (rf_lut_ldb_vasqid_v_waddr)
,.rf_lut_ldb_vasqid_v_wclk (rf_lut_ldb_vasqid_v_wclk)
,.rf_lut_ldb_vasqid_v_wclk_rst_n (rf_lut_ldb_vasqid_v_wclk_rst_n)
,.rf_lut_ldb_vasqid_v_we    (rf_lut_ldb_vasqid_v_we)
,.rf_lut_ldb_vasqid_v_wdata (rf_lut_ldb_vasqid_v_wdata)
,.rf_lut_ldb_vasqid_v_rdata (rf_lut_ldb_vasqid_v_rdata)

,.func_lut_vf_dir_vpp2pp_re    (func_lut_vf_dir_vpp2pp_re)
,.func_lut_vf_dir_vpp2pp_raddr (func_lut_vf_dir_vpp2pp_raddr)
,.func_lut_vf_dir_vpp2pp_waddr (func_lut_vf_dir_vpp2pp_waddr)
,.func_lut_vf_dir_vpp2pp_we    (func_lut_vf_dir_vpp2pp_we)
,.func_lut_vf_dir_vpp2pp_wdata (func_lut_vf_dir_vpp2pp_wdata)
,.func_lut_vf_dir_vpp2pp_rdata (func_lut_vf_dir_vpp2pp_rdata)

,.rf_lut_vf_dir_vpp2pp_rclk (rf_lut_vf_dir_vpp2pp_rclk)
,.rf_lut_vf_dir_vpp2pp_rclk_rst_n (rf_lut_vf_dir_vpp2pp_rclk_rst_n)
,.rf_lut_vf_dir_vpp2pp_re    (rf_lut_vf_dir_vpp2pp_re)
,.rf_lut_vf_dir_vpp2pp_raddr (rf_lut_vf_dir_vpp2pp_raddr)
,.rf_lut_vf_dir_vpp2pp_waddr (rf_lut_vf_dir_vpp2pp_waddr)
,.rf_lut_vf_dir_vpp2pp_wclk (rf_lut_vf_dir_vpp2pp_wclk)
,.rf_lut_vf_dir_vpp2pp_wclk_rst_n (rf_lut_vf_dir_vpp2pp_wclk_rst_n)
,.rf_lut_vf_dir_vpp2pp_we    (rf_lut_vf_dir_vpp2pp_we)
,.rf_lut_vf_dir_vpp2pp_wdata (rf_lut_vf_dir_vpp2pp_wdata)
,.rf_lut_vf_dir_vpp2pp_rdata (rf_lut_vf_dir_vpp2pp_rdata)

,.func_lut_vf_dir_vpp_v_re    (func_lut_vf_dir_vpp_v_re)
,.func_lut_vf_dir_vpp_v_raddr (func_lut_vf_dir_vpp_v_raddr)
,.func_lut_vf_dir_vpp_v_waddr (func_lut_vf_dir_vpp_v_waddr)
,.func_lut_vf_dir_vpp_v_we    (func_lut_vf_dir_vpp_v_we)
,.func_lut_vf_dir_vpp_v_wdata (func_lut_vf_dir_vpp_v_wdata)
,.func_lut_vf_dir_vpp_v_rdata (func_lut_vf_dir_vpp_v_rdata)

,.rf_lut_vf_dir_vpp_v_rclk (rf_lut_vf_dir_vpp_v_rclk)
,.rf_lut_vf_dir_vpp_v_rclk_rst_n (rf_lut_vf_dir_vpp_v_rclk_rst_n)
,.rf_lut_vf_dir_vpp_v_re    (rf_lut_vf_dir_vpp_v_re)
,.rf_lut_vf_dir_vpp_v_raddr (rf_lut_vf_dir_vpp_v_raddr)
,.rf_lut_vf_dir_vpp_v_waddr (rf_lut_vf_dir_vpp_v_waddr)
,.rf_lut_vf_dir_vpp_v_wclk (rf_lut_vf_dir_vpp_v_wclk)
,.rf_lut_vf_dir_vpp_v_wclk_rst_n (rf_lut_vf_dir_vpp_v_wclk_rst_n)
,.rf_lut_vf_dir_vpp_v_we    (rf_lut_vf_dir_vpp_v_we)
,.rf_lut_vf_dir_vpp_v_wdata (rf_lut_vf_dir_vpp_v_wdata)
,.rf_lut_vf_dir_vpp_v_rdata (rf_lut_vf_dir_vpp_v_rdata)

,.func_lut_vf_dir_vqid2qid_re    (func_lut_vf_dir_vqid2qid_re)
,.func_lut_vf_dir_vqid2qid_raddr (func_lut_vf_dir_vqid2qid_raddr)
,.func_lut_vf_dir_vqid2qid_waddr (func_lut_vf_dir_vqid2qid_waddr)
,.func_lut_vf_dir_vqid2qid_we    (func_lut_vf_dir_vqid2qid_we)
,.func_lut_vf_dir_vqid2qid_wdata (func_lut_vf_dir_vqid2qid_wdata)
,.func_lut_vf_dir_vqid2qid_rdata (func_lut_vf_dir_vqid2qid_rdata)

,.rf_lut_vf_dir_vqid2qid_rclk (rf_lut_vf_dir_vqid2qid_rclk)
,.rf_lut_vf_dir_vqid2qid_rclk_rst_n (rf_lut_vf_dir_vqid2qid_rclk_rst_n)
,.rf_lut_vf_dir_vqid2qid_re    (rf_lut_vf_dir_vqid2qid_re)
,.rf_lut_vf_dir_vqid2qid_raddr (rf_lut_vf_dir_vqid2qid_raddr)
,.rf_lut_vf_dir_vqid2qid_waddr (rf_lut_vf_dir_vqid2qid_waddr)
,.rf_lut_vf_dir_vqid2qid_wclk (rf_lut_vf_dir_vqid2qid_wclk)
,.rf_lut_vf_dir_vqid2qid_wclk_rst_n (rf_lut_vf_dir_vqid2qid_wclk_rst_n)
,.rf_lut_vf_dir_vqid2qid_we    (rf_lut_vf_dir_vqid2qid_we)
,.rf_lut_vf_dir_vqid2qid_wdata (rf_lut_vf_dir_vqid2qid_wdata)
,.rf_lut_vf_dir_vqid2qid_rdata (rf_lut_vf_dir_vqid2qid_rdata)

,.func_lut_vf_dir_vqid_v_re    (func_lut_vf_dir_vqid_v_re)
,.func_lut_vf_dir_vqid_v_raddr (func_lut_vf_dir_vqid_v_raddr)
,.func_lut_vf_dir_vqid_v_waddr (func_lut_vf_dir_vqid_v_waddr)
,.func_lut_vf_dir_vqid_v_we    (func_lut_vf_dir_vqid_v_we)
,.func_lut_vf_dir_vqid_v_wdata (func_lut_vf_dir_vqid_v_wdata)
,.func_lut_vf_dir_vqid_v_rdata (func_lut_vf_dir_vqid_v_rdata)

,.rf_lut_vf_dir_vqid_v_rclk (rf_lut_vf_dir_vqid_v_rclk)
,.rf_lut_vf_dir_vqid_v_rclk_rst_n (rf_lut_vf_dir_vqid_v_rclk_rst_n)
,.rf_lut_vf_dir_vqid_v_re    (rf_lut_vf_dir_vqid_v_re)
,.rf_lut_vf_dir_vqid_v_raddr (rf_lut_vf_dir_vqid_v_raddr)
,.rf_lut_vf_dir_vqid_v_waddr (rf_lut_vf_dir_vqid_v_waddr)
,.rf_lut_vf_dir_vqid_v_wclk (rf_lut_vf_dir_vqid_v_wclk)
,.rf_lut_vf_dir_vqid_v_wclk_rst_n (rf_lut_vf_dir_vqid_v_wclk_rst_n)
,.rf_lut_vf_dir_vqid_v_we    (rf_lut_vf_dir_vqid_v_we)
,.rf_lut_vf_dir_vqid_v_wdata (rf_lut_vf_dir_vqid_v_wdata)
,.rf_lut_vf_dir_vqid_v_rdata (rf_lut_vf_dir_vqid_v_rdata)

,.func_lut_vf_ldb_vpp2pp_re    (func_lut_vf_ldb_vpp2pp_re)
,.func_lut_vf_ldb_vpp2pp_raddr (func_lut_vf_ldb_vpp2pp_raddr)
,.func_lut_vf_ldb_vpp2pp_waddr (func_lut_vf_ldb_vpp2pp_waddr)
,.func_lut_vf_ldb_vpp2pp_we    (func_lut_vf_ldb_vpp2pp_we)
,.func_lut_vf_ldb_vpp2pp_wdata (func_lut_vf_ldb_vpp2pp_wdata)
,.func_lut_vf_ldb_vpp2pp_rdata (func_lut_vf_ldb_vpp2pp_rdata)

,.rf_lut_vf_ldb_vpp2pp_rclk (rf_lut_vf_ldb_vpp2pp_rclk)
,.rf_lut_vf_ldb_vpp2pp_rclk_rst_n (rf_lut_vf_ldb_vpp2pp_rclk_rst_n)
,.rf_lut_vf_ldb_vpp2pp_re    (rf_lut_vf_ldb_vpp2pp_re)
,.rf_lut_vf_ldb_vpp2pp_raddr (rf_lut_vf_ldb_vpp2pp_raddr)
,.rf_lut_vf_ldb_vpp2pp_waddr (rf_lut_vf_ldb_vpp2pp_waddr)
,.rf_lut_vf_ldb_vpp2pp_wclk (rf_lut_vf_ldb_vpp2pp_wclk)
,.rf_lut_vf_ldb_vpp2pp_wclk_rst_n (rf_lut_vf_ldb_vpp2pp_wclk_rst_n)
,.rf_lut_vf_ldb_vpp2pp_we    (rf_lut_vf_ldb_vpp2pp_we)
,.rf_lut_vf_ldb_vpp2pp_wdata (rf_lut_vf_ldb_vpp2pp_wdata)
,.rf_lut_vf_ldb_vpp2pp_rdata (rf_lut_vf_ldb_vpp2pp_rdata)

,.func_lut_vf_ldb_vpp_v_re    (func_lut_vf_ldb_vpp_v_re)
,.func_lut_vf_ldb_vpp_v_raddr (func_lut_vf_ldb_vpp_v_raddr)
,.func_lut_vf_ldb_vpp_v_waddr (func_lut_vf_ldb_vpp_v_waddr)
,.func_lut_vf_ldb_vpp_v_we    (func_lut_vf_ldb_vpp_v_we)
,.func_lut_vf_ldb_vpp_v_wdata (func_lut_vf_ldb_vpp_v_wdata)
,.func_lut_vf_ldb_vpp_v_rdata (func_lut_vf_ldb_vpp_v_rdata)

,.rf_lut_vf_ldb_vpp_v_rclk (rf_lut_vf_ldb_vpp_v_rclk)
,.rf_lut_vf_ldb_vpp_v_rclk_rst_n (rf_lut_vf_ldb_vpp_v_rclk_rst_n)
,.rf_lut_vf_ldb_vpp_v_re    (rf_lut_vf_ldb_vpp_v_re)
,.rf_lut_vf_ldb_vpp_v_raddr (rf_lut_vf_ldb_vpp_v_raddr)
,.rf_lut_vf_ldb_vpp_v_waddr (rf_lut_vf_ldb_vpp_v_waddr)
,.rf_lut_vf_ldb_vpp_v_wclk (rf_lut_vf_ldb_vpp_v_wclk)
,.rf_lut_vf_ldb_vpp_v_wclk_rst_n (rf_lut_vf_ldb_vpp_v_wclk_rst_n)
,.rf_lut_vf_ldb_vpp_v_we    (rf_lut_vf_ldb_vpp_v_we)
,.rf_lut_vf_ldb_vpp_v_wdata (rf_lut_vf_ldb_vpp_v_wdata)
,.rf_lut_vf_ldb_vpp_v_rdata (rf_lut_vf_ldb_vpp_v_rdata)

,.func_lut_vf_ldb_vqid2qid_re    (func_lut_vf_ldb_vqid2qid_re)
,.func_lut_vf_ldb_vqid2qid_raddr (func_lut_vf_ldb_vqid2qid_raddr)
,.func_lut_vf_ldb_vqid2qid_waddr (func_lut_vf_ldb_vqid2qid_waddr)
,.func_lut_vf_ldb_vqid2qid_we    (func_lut_vf_ldb_vqid2qid_we)
,.func_lut_vf_ldb_vqid2qid_wdata (func_lut_vf_ldb_vqid2qid_wdata)
,.func_lut_vf_ldb_vqid2qid_rdata (func_lut_vf_ldb_vqid2qid_rdata)

,.rf_lut_vf_ldb_vqid2qid_rclk (rf_lut_vf_ldb_vqid2qid_rclk)
,.rf_lut_vf_ldb_vqid2qid_rclk_rst_n (rf_lut_vf_ldb_vqid2qid_rclk_rst_n)
,.rf_lut_vf_ldb_vqid2qid_re    (rf_lut_vf_ldb_vqid2qid_re)
,.rf_lut_vf_ldb_vqid2qid_raddr (rf_lut_vf_ldb_vqid2qid_raddr)
,.rf_lut_vf_ldb_vqid2qid_waddr (rf_lut_vf_ldb_vqid2qid_waddr)
,.rf_lut_vf_ldb_vqid2qid_wclk (rf_lut_vf_ldb_vqid2qid_wclk)
,.rf_lut_vf_ldb_vqid2qid_wclk_rst_n (rf_lut_vf_ldb_vqid2qid_wclk_rst_n)
,.rf_lut_vf_ldb_vqid2qid_we    (rf_lut_vf_ldb_vqid2qid_we)
,.rf_lut_vf_ldb_vqid2qid_wdata (rf_lut_vf_ldb_vqid2qid_wdata)
,.rf_lut_vf_ldb_vqid2qid_rdata (rf_lut_vf_ldb_vqid2qid_rdata)

,.func_lut_vf_ldb_vqid_v_re    (func_lut_vf_ldb_vqid_v_re)
,.func_lut_vf_ldb_vqid_v_raddr (func_lut_vf_ldb_vqid_v_raddr)
,.func_lut_vf_ldb_vqid_v_waddr (func_lut_vf_ldb_vqid_v_waddr)
,.func_lut_vf_ldb_vqid_v_we    (func_lut_vf_ldb_vqid_v_we)
,.func_lut_vf_ldb_vqid_v_wdata (func_lut_vf_ldb_vqid_v_wdata)
,.func_lut_vf_ldb_vqid_v_rdata (func_lut_vf_ldb_vqid_v_rdata)

,.rf_lut_vf_ldb_vqid_v_rclk (rf_lut_vf_ldb_vqid_v_rclk)
,.rf_lut_vf_ldb_vqid_v_rclk_rst_n (rf_lut_vf_ldb_vqid_v_rclk_rst_n)
,.rf_lut_vf_ldb_vqid_v_re    (rf_lut_vf_ldb_vqid_v_re)
,.rf_lut_vf_ldb_vqid_v_raddr (rf_lut_vf_ldb_vqid_v_raddr)
,.rf_lut_vf_ldb_vqid_v_waddr (rf_lut_vf_ldb_vqid_v_waddr)
,.rf_lut_vf_ldb_vqid_v_wclk (rf_lut_vf_ldb_vqid_v_wclk)
,.rf_lut_vf_ldb_vqid_v_wclk_rst_n (rf_lut_vf_ldb_vqid_v_wclk_rst_n)
,.rf_lut_vf_ldb_vqid_v_we    (rf_lut_vf_ldb_vqid_v_we)
,.rf_lut_vf_ldb_vqid_v_wdata (rf_lut_vf_ldb_vqid_v_wdata)
,.rf_lut_vf_ldb_vqid_v_rdata (rf_lut_vf_ldb_vqid_v_rdata)

,.func_msix_tbl_word0_re    (func_msix_tbl_word0_re)
,.func_msix_tbl_word0_raddr (func_msix_tbl_word0_raddr)
,.func_msix_tbl_word0_waddr (func_msix_tbl_word0_waddr)
,.func_msix_tbl_word0_we    (func_msix_tbl_word0_we)
,.func_msix_tbl_word0_wdata (func_msix_tbl_word0_wdata)
,.func_msix_tbl_word0_rdata (func_msix_tbl_word0_rdata)

,.rf_msix_tbl_word0_rclk (rf_msix_tbl_word0_rclk)
,.rf_msix_tbl_word0_rclk_rst_n (rf_msix_tbl_word0_rclk_rst_n)
,.rf_msix_tbl_word0_re    (rf_msix_tbl_word0_re)
,.rf_msix_tbl_word0_raddr (rf_msix_tbl_word0_raddr)
,.rf_msix_tbl_word0_waddr (rf_msix_tbl_word0_waddr)
,.rf_msix_tbl_word0_wclk (rf_msix_tbl_word0_wclk)
,.rf_msix_tbl_word0_wclk_rst_n (rf_msix_tbl_word0_wclk_rst_n)
,.rf_msix_tbl_word0_we    (rf_msix_tbl_word0_we)
,.rf_msix_tbl_word0_wdata (rf_msix_tbl_word0_wdata)
,.rf_msix_tbl_word0_rdata (rf_msix_tbl_word0_rdata)

,.func_msix_tbl_word1_re    (func_msix_tbl_word1_re)
,.func_msix_tbl_word1_raddr (func_msix_tbl_word1_raddr)
,.func_msix_tbl_word1_waddr (func_msix_tbl_word1_waddr)
,.func_msix_tbl_word1_we    (func_msix_tbl_word1_we)
,.func_msix_tbl_word1_wdata (func_msix_tbl_word1_wdata)
,.func_msix_tbl_word1_rdata (func_msix_tbl_word1_rdata)

,.rf_msix_tbl_word1_rclk (rf_msix_tbl_word1_rclk)
,.rf_msix_tbl_word1_rclk_rst_n (rf_msix_tbl_word1_rclk_rst_n)
,.rf_msix_tbl_word1_re    (rf_msix_tbl_word1_re)
,.rf_msix_tbl_word1_raddr (rf_msix_tbl_word1_raddr)
,.rf_msix_tbl_word1_waddr (rf_msix_tbl_word1_waddr)
,.rf_msix_tbl_word1_wclk (rf_msix_tbl_word1_wclk)
,.rf_msix_tbl_word1_wclk_rst_n (rf_msix_tbl_word1_wclk_rst_n)
,.rf_msix_tbl_word1_we    (rf_msix_tbl_word1_we)
,.rf_msix_tbl_word1_wdata (rf_msix_tbl_word1_wdata)
,.rf_msix_tbl_word1_rdata (rf_msix_tbl_word1_rdata)

,.func_msix_tbl_word2_re    (func_msix_tbl_word2_re)
,.func_msix_tbl_word2_raddr (func_msix_tbl_word2_raddr)
,.func_msix_tbl_word2_waddr (func_msix_tbl_word2_waddr)
,.func_msix_tbl_word2_we    (func_msix_tbl_word2_we)
,.func_msix_tbl_word2_wdata (func_msix_tbl_word2_wdata)
,.func_msix_tbl_word2_rdata (func_msix_tbl_word2_rdata)

,.rf_msix_tbl_word2_rclk (rf_msix_tbl_word2_rclk)
,.rf_msix_tbl_word2_rclk_rst_n (rf_msix_tbl_word2_rclk_rst_n)
,.rf_msix_tbl_word2_re    (rf_msix_tbl_word2_re)
,.rf_msix_tbl_word2_raddr (rf_msix_tbl_word2_raddr)
,.rf_msix_tbl_word2_waddr (rf_msix_tbl_word2_waddr)
,.rf_msix_tbl_word2_wclk (rf_msix_tbl_word2_wclk)
,.rf_msix_tbl_word2_wclk_rst_n (rf_msix_tbl_word2_wclk_rst_n)
,.rf_msix_tbl_word2_we    (rf_msix_tbl_word2_we)
,.rf_msix_tbl_word2_wdata (rf_msix_tbl_word2_wdata)
,.rf_msix_tbl_word2_rdata (rf_msix_tbl_word2_rdata)

,.func_sch_out_fifo_re    (func_sch_out_fifo_re)
,.func_sch_out_fifo_raddr (func_sch_out_fifo_raddr)
,.func_sch_out_fifo_waddr (func_sch_out_fifo_waddr)
,.func_sch_out_fifo_we    (func_sch_out_fifo_we)
,.func_sch_out_fifo_wdata (func_sch_out_fifo_wdata)
,.func_sch_out_fifo_rdata (func_sch_out_fifo_rdata)

,.rf_sch_out_fifo_rclk (rf_sch_out_fifo_rclk)
,.rf_sch_out_fifo_rclk_rst_n (rf_sch_out_fifo_rclk_rst_n)
,.rf_sch_out_fifo_re    (rf_sch_out_fifo_re)
,.rf_sch_out_fifo_raddr (rf_sch_out_fifo_raddr)
,.rf_sch_out_fifo_waddr (rf_sch_out_fifo_waddr)
,.rf_sch_out_fifo_wclk (rf_sch_out_fifo_wclk)
,.rf_sch_out_fifo_wclk_rst_n (rf_sch_out_fifo_wclk_rst_n)
,.rf_sch_out_fifo_we    (rf_sch_out_fifo_we)
,.rf_sch_out_fifo_wdata (rf_sch_out_fifo_wdata)
,.rf_sch_out_fifo_rdata (rf_sch_out_fifo_rdata)

,.func_rob_mem_re    (func_rob_mem_re)
,.func_rob_mem_addr  (func_rob_mem_addr)
,.func_rob_mem_we    (func_rob_mem_we)
,.func_rob_mem_wdata (func_rob_mem_wdata)
,.func_rob_mem_rdata (func_rob_mem_rdata)

,.sr_rob_mem_clk (sr_rob_mem_clk)
,.sr_rob_mem_clk_rst_n (sr_rob_mem_clk_rst_n)
,.sr_rob_mem_re    (sr_rob_mem_re)
,.sr_rob_mem_addr  (sr_rob_mem_addr)
,.sr_rob_mem_we    (sr_rob_mem_we)
,.sr_rob_mem_wdata (sr_rob_mem_wdata)
,.sr_rob_mem_rdata (sr_rob_mem_rdata)

);
// END HQM_RAM_ACCESS

// BEGIN HQM_MEMS_ASSIGN
assign func_alarm_vf_synd0_we                   = memi_alarm_vf_synd0.we;
assign func_alarm_vf_synd0_re                   = memi_alarm_vf_synd0.re;
assign func_alarm_vf_synd0_waddr                = memi_alarm_vf_synd0.waddr;
assign func_alarm_vf_synd0_raddr                = memi_alarm_vf_synd0.raddr;
assign func_alarm_vf_synd0_wdata                = memi_alarm_vf_synd0.wdata;
assign memo_alarm_vf_synd0.rdata                = func_alarm_vf_synd0_rdata;

assign func_alarm_vf_synd1_we                   = memi_alarm_vf_synd1.we;
assign func_alarm_vf_synd1_re                   = memi_alarm_vf_synd1.re;
assign func_alarm_vf_synd1_waddr                = memi_alarm_vf_synd1.waddr;
assign func_alarm_vf_synd1_raddr                = memi_alarm_vf_synd1.raddr;
assign func_alarm_vf_synd1_wdata                = memi_alarm_vf_synd1.wdata;
assign memo_alarm_vf_synd1.rdata                = func_alarm_vf_synd1_rdata;

assign func_alarm_vf_synd2_we                   = memi_alarm_vf_synd2.we;
assign func_alarm_vf_synd2_re                   = memi_alarm_vf_synd2.re;
assign func_alarm_vf_synd2_waddr                = memi_alarm_vf_synd2.waddr;
assign func_alarm_vf_synd2_raddr                = memi_alarm_vf_synd2.raddr;
assign func_alarm_vf_synd2_wdata                = memi_alarm_vf_synd2.wdata;
assign memo_alarm_vf_synd2.rdata                = func_alarm_vf_synd2_rdata;

assign func_dir_wb0_we                          = memi_dir_wb0.we;
assign func_dir_wb0_re                          = memi_dir_wb0.re;
assign func_dir_wb0_waddr                       = memi_dir_wb0.waddr;
assign func_dir_wb0_raddr                       = memi_dir_wb0.raddr;
assign func_dir_wb0_wdata                       = memi_dir_wb0.wdata;
assign memo_dir_wb0.rdata                       = func_dir_wb0_rdata;

assign func_dir_wb1_we                          = memi_dir_wb1.we;
assign func_dir_wb1_re                          = memi_dir_wb1.re;
assign func_dir_wb1_waddr                       = memi_dir_wb1.waddr;
assign func_dir_wb1_raddr                       = memi_dir_wb1.raddr;
assign func_dir_wb1_wdata                       = memi_dir_wb1.wdata;
assign memo_dir_wb1.rdata                       = func_dir_wb1_rdata;

assign func_dir_wb2_we                          = memi_dir_wb2.we;
assign func_dir_wb2_re                          = memi_dir_wb2.re;
assign func_dir_wb2_waddr                       = memi_dir_wb2.waddr;
assign func_dir_wb2_raddr                       = memi_dir_wb2.raddr;
assign func_dir_wb2_wdata                       = memi_dir_wb2.wdata;
assign memo_dir_wb2.rdata                       = func_dir_wb2_rdata;

assign func_hcw_enq_fifo_we                     = memi_hcw_enq_fifo.we;
assign func_hcw_enq_fifo_re                     = memi_hcw_enq_fifo.re;
assign func_hcw_enq_fifo_waddr                  = memi_hcw_enq_fifo.waddr;
assign func_hcw_enq_fifo_raddr                  = memi_hcw_enq_fifo.raddr;
assign func_hcw_enq_fifo_wdata                  = memi_hcw_enq_fifo.wdata;
assign memo_hcw_enq_fifo.rdata                  = func_hcw_enq_fifo_rdata;

assign func_ldb_wb0_we                          = memi_ldb_wb0.we;
assign func_ldb_wb0_re                          = memi_ldb_wb0.re;
assign func_ldb_wb0_waddr                       = memi_ldb_wb0.waddr;
assign func_ldb_wb0_raddr                       = memi_ldb_wb0.raddr;
assign func_ldb_wb0_wdata                       = memi_ldb_wb0.wdata;
assign memo_ldb_wb0.rdata                       = func_ldb_wb0_rdata;

assign func_ldb_wb1_we                          = memi_ldb_wb1.we;
assign func_ldb_wb1_re                          = memi_ldb_wb1.re;
assign func_ldb_wb1_waddr                       = memi_ldb_wb1.waddr;
assign func_ldb_wb1_raddr                       = memi_ldb_wb1.raddr;
assign func_ldb_wb1_wdata                       = memi_ldb_wb1.wdata;
assign memo_ldb_wb1.rdata                       = func_ldb_wb1_rdata;

assign func_ldb_wb2_we                          = memi_ldb_wb2.we;
assign func_ldb_wb2_re                          = memi_ldb_wb2.re;
assign func_ldb_wb2_waddr                       = memi_ldb_wb2.waddr;
assign func_ldb_wb2_raddr                       = memi_ldb_wb2.raddr;
assign func_ldb_wb2_wdata                       = memi_ldb_wb2.wdata;
assign memo_ldb_wb2.rdata                       = func_ldb_wb2_rdata;

assign func_lut_dir_cq2vf_pf_ro_we              = memi_lut_dir_cq2vf_pf_ro.we;
assign func_lut_dir_cq2vf_pf_ro_re              = memi_lut_dir_cq2vf_pf_ro.re;
assign func_lut_dir_cq2vf_pf_ro_waddr           = memi_lut_dir_cq2vf_pf_ro.addr;
assign func_lut_dir_cq2vf_pf_ro_raddr           = memi_lut_dir_cq2vf_pf_ro.addr;
assign func_lut_dir_cq2vf_pf_ro_wdata           = memi_lut_dir_cq2vf_pf_ro.wdata;
assign memo_lut_dir_cq2vf_pf_ro.rdata           = func_lut_dir_cq2vf_pf_ro_rdata;

assign func_lut_dir_cq_addr_l_we                = memi_lut_dir_cq_addr_l.we;
assign func_lut_dir_cq_addr_l_re                = memi_lut_dir_cq_addr_l.re;
assign func_lut_dir_cq_addr_l_waddr             = memi_lut_dir_cq_addr_l.addr;
assign func_lut_dir_cq_addr_l_raddr             = memi_lut_dir_cq_addr_l.addr;
assign func_lut_dir_cq_addr_l_wdata             = memi_lut_dir_cq_addr_l.wdata;
assign memo_lut_dir_cq_addr_l.rdata             = func_lut_dir_cq_addr_l_rdata;

assign func_lut_dir_cq_addr_u_we                = memi_lut_dir_cq_addr_u.we;
assign func_lut_dir_cq_addr_u_re                = memi_lut_dir_cq_addr_u.re;
assign func_lut_dir_cq_addr_u_waddr             = memi_lut_dir_cq_addr_u.addr;
assign func_lut_dir_cq_addr_u_raddr             = memi_lut_dir_cq_addr_u.addr;
assign func_lut_dir_cq_addr_u_wdata             = memi_lut_dir_cq_addr_u.wdata;
assign memo_lut_dir_cq_addr_u.rdata             = func_lut_dir_cq_addr_u_rdata;

assign func_lut_dir_cq_ai_addr_l_we             = memi_lut_dir_cq_ai_addr_l.we;
assign func_lut_dir_cq_ai_addr_l_re             = memi_lut_dir_cq_ai_addr_l.re;
assign func_lut_dir_cq_ai_addr_l_waddr          = memi_lut_dir_cq_ai_addr_l.addr;
assign func_lut_dir_cq_ai_addr_l_raddr          = memi_lut_dir_cq_ai_addr_l.addr;
assign func_lut_dir_cq_ai_addr_l_wdata          = memi_lut_dir_cq_ai_addr_l.wdata;
assign memo_lut_dir_cq_ai_addr_l.rdata          = func_lut_dir_cq_ai_addr_l_rdata;

assign func_lut_dir_cq_ai_addr_u_we             = memi_lut_dir_cq_ai_addr_u.we;
assign func_lut_dir_cq_ai_addr_u_re             = memi_lut_dir_cq_ai_addr_u.re;
assign func_lut_dir_cq_ai_addr_u_waddr          = memi_lut_dir_cq_ai_addr_u.addr;
assign func_lut_dir_cq_ai_addr_u_raddr          = memi_lut_dir_cq_ai_addr_u.addr;
assign func_lut_dir_cq_ai_addr_u_wdata          = memi_lut_dir_cq_ai_addr_u.wdata;
assign memo_lut_dir_cq_ai_addr_u.rdata          = func_lut_dir_cq_ai_addr_u_rdata;

assign func_lut_dir_cq_ai_data_we               = memi_lut_dir_cq_ai_data.we;
assign func_lut_dir_cq_ai_data_re               = memi_lut_dir_cq_ai_data.re;
assign func_lut_dir_cq_ai_data_waddr            = memi_lut_dir_cq_ai_data.addr;
assign func_lut_dir_cq_ai_data_raddr            = memi_lut_dir_cq_ai_data.addr;
assign func_lut_dir_cq_ai_data_wdata            = memi_lut_dir_cq_ai_data.wdata;
assign memo_lut_dir_cq_ai_data.rdata            = func_lut_dir_cq_ai_data_rdata;

assign func_lut_dir_cq_isr_we                   = memi_lut_dir_cq_isr.we;
assign func_lut_dir_cq_isr_re                   = memi_lut_dir_cq_isr.re;
assign func_lut_dir_cq_isr_waddr                = memi_lut_dir_cq_isr.addr;
assign func_lut_dir_cq_isr_raddr                = memi_lut_dir_cq_isr.addr;
assign func_lut_dir_cq_isr_wdata                = memi_lut_dir_cq_isr.wdata;
assign memo_lut_dir_cq_isr.rdata                = func_lut_dir_cq_isr_rdata;

assign func_lut_dir_cq_pasid_we                 = memi_lut_dir_cq_pasid.we;
assign func_lut_dir_cq_pasid_re                 = memi_lut_dir_cq_pasid.re;
assign func_lut_dir_cq_pasid_waddr              = memi_lut_dir_cq_pasid.addr;
assign func_lut_dir_cq_pasid_raddr              = memi_lut_dir_cq_pasid.addr;
assign func_lut_dir_cq_pasid_wdata              = memi_lut_dir_cq_pasid.wdata;
assign memo_lut_dir_cq_pasid.rdata              = func_lut_dir_cq_pasid_rdata;

assign func_lut_dir_pp2vas_we                   = memi_lut_dir_pp2vas.we;
assign func_lut_dir_pp2vas_re                   = memi_lut_dir_pp2vas.re;
assign func_lut_dir_pp2vas_waddr                = memi_lut_dir_pp2vas.addr;
assign func_lut_dir_pp2vas_raddr                = memi_lut_dir_pp2vas.addr;
assign func_lut_dir_pp2vas_wdata                = memi_lut_dir_pp2vas.wdata;
assign memo_lut_dir_pp2vas.rdata                = func_lut_dir_pp2vas_rdata;

assign func_lut_dir_pp_v_we                     = memi_lut_dir_pp_v.we;
assign func_lut_dir_pp_v_re                     = memi_lut_dir_pp_v.re;
assign func_lut_dir_pp_v_waddr                  = memi_lut_dir_pp_v.addr;
assign func_lut_dir_pp_v_raddr                  = memi_lut_dir_pp_v.addr;
assign func_lut_dir_pp_v_wdata                  = memi_lut_dir_pp_v.wdata;
assign memo_lut_dir_pp_v.rdata                  = func_lut_dir_pp_v_rdata;

assign func_lut_dir_vasqid_v_we                 = memi_lut_dir_vasqid_v.we;
assign func_lut_dir_vasqid_v_re                 = memi_lut_dir_vasqid_v.re;
assign func_lut_dir_vasqid_v_waddr              = memi_lut_dir_vasqid_v.addr;
assign func_lut_dir_vasqid_v_raddr              = memi_lut_dir_vasqid_v.addr;
assign func_lut_dir_vasqid_v_wdata              = memi_lut_dir_vasqid_v.wdata;
assign memo_lut_dir_vasqid_v.rdata              = func_lut_dir_vasqid_v_rdata;

assign func_lut_ldb_cq2vf_pf_ro_we              = memi_lut_ldb_cq2vf_pf_ro.we;
assign func_lut_ldb_cq2vf_pf_ro_re              = memi_lut_ldb_cq2vf_pf_ro.re;
assign func_lut_ldb_cq2vf_pf_ro_waddr           = memi_lut_ldb_cq2vf_pf_ro.addr;
assign func_lut_ldb_cq2vf_pf_ro_raddr           = memi_lut_ldb_cq2vf_pf_ro.addr;
assign func_lut_ldb_cq2vf_pf_ro_wdata           = memi_lut_ldb_cq2vf_pf_ro.wdata;
assign memo_lut_ldb_cq2vf_pf_ro.rdata           = func_lut_ldb_cq2vf_pf_ro_rdata;

assign func_lut_ldb_cq_addr_l_we                = memi_lut_ldb_cq_addr_l.we;
assign func_lut_ldb_cq_addr_l_re                = memi_lut_ldb_cq_addr_l.re;
assign func_lut_ldb_cq_addr_l_waddr             = memi_lut_ldb_cq_addr_l.addr;
assign func_lut_ldb_cq_addr_l_raddr             = memi_lut_ldb_cq_addr_l.addr;
assign func_lut_ldb_cq_addr_l_wdata             = memi_lut_ldb_cq_addr_l.wdata;
assign memo_lut_ldb_cq_addr_l.rdata             = func_lut_ldb_cq_addr_l_rdata;

assign func_lut_ldb_cq_addr_u_we                = memi_lut_ldb_cq_addr_u.we;
assign func_lut_ldb_cq_addr_u_re                = memi_lut_ldb_cq_addr_u.re;
assign func_lut_ldb_cq_addr_u_waddr             = memi_lut_ldb_cq_addr_u.addr;
assign func_lut_ldb_cq_addr_u_raddr             = memi_lut_ldb_cq_addr_u.addr;
assign func_lut_ldb_cq_addr_u_wdata             = memi_lut_ldb_cq_addr_u.wdata;
assign memo_lut_ldb_cq_addr_u.rdata             = func_lut_ldb_cq_addr_u_rdata;

assign func_lut_ldb_cq_ai_addr_l_we             = memi_lut_ldb_cq_ai_addr_l.we;
assign func_lut_ldb_cq_ai_addr_l_re             = memi_lut_ldb_cq_ai_addr_l.re;
assign func_lut_ldb_cq_ai_addr_l_waddr          = memi_lut_ldb_cq_ai_addr_l.addr;
assign func_lut_ldb_cq_ai_addr_l_raddr          = memi_lut_ldb_cq_ai_addr_l.addr;
assign func_lut_ldb_cq_ai_addr_l_wdata          = memi_lut_ldb_cq_ai_addr_l.wdata;
assign memo_lut_ldb_cq_ai_addr_l.rdata          = func_lut_ldb_cq_ai_addr_l_rdata;

assign func_lut_ldb_cq_ai_addr_u_we             = memi_lut_ldb_cq_ai_addr_u.we;
assign func_lut_ldb_cq_ai_addr_u_re             = memi_lut_ldb_cq_ai_addr_u.re;
assign func_lut_ldb_cq_ai_addr_u_waddr          = memi_lut_ldb_cq_ai_addr_u.addr;
assign func_lut_ldb_cq_ai_addr_u_raddr          = memi_lut_ldb_cq_ai_addr_u.addr;
assign func_lut_ldb_cq_ai_addr_u_wdata          = memi_lut_ldb_cq_ai_addr_u.wdata;
assign memo_lut_ldb_cq_ai_addr_u.rdata          = func_lut_ldb_cq_ai_addr_u_rdata;

assign func_lut_ldb_cq_ai_data_we               = memi_lut_ldb_cq_ai_data.we;
assign func_lut_ldb_cq_ai_data_re               = memi_lut_ldb_cq_ai_data.re;
assign func_lut_ldb_cq_ai_data_waddr            = memi_lut_ldb_cq_ai_data.addr;
assign func_lut_ldb_cq_ai_data_raddr            = memi_lut_ldb_cq_ai_data.addr;
assign func_lut_ldb_cq_ai_data_wdata            = memi_lut_ldb_cq_ai_data.wdata;
assign memo_lut_ldb_cq_ai_data.rdata            = func_lut_ldb_cq_ai_data_rdata;

assign func_lut_ldb_cq_isr_we                   = memi_lut_ldb_cq_isr.we;
assign func_lut_ldb_cq_isr_re                   = memi_lut_ldb_cq_isr.re;
assign func_lut_ldb_cq_isr_waddr                = memi_lut_ldb_cq_isr.addr;
assign func_lut_ldb_cq_isr_raddr                = memi_lut_ldb_cq_isr.addr;
assign func_lut_ldb_cq_isr_wdata                = memi_lut_ldb_cq_isr.wdata;
assign memo_lut_ldb_cq_isr.rdata                = func_lut_ldb_cq_isr_rdata;

assign func_lut_ldb_cq_pasid_we                 = memi_lut_ldb_cq_pasid.we;
assign func_lut_ldb_cq_pasid_re                 = memi_lut_ldb_cq_pasid.re;
assign func_lut_ldb_cq_pasid_waddr              = memi_lut_ldb_cq_pasid.addr;
assign func_lut_ldb_cq_pasid_raddr              = memi_lut_ldb_cq_pasid.addr;
assign func_lut_ldb_cq_pasid_wdata              = memi_lut_ldb_cq_pasid.wdata;
assign memo_lut_ldb_cq_pasid.rdata              = func_lut_ldb_cq_pasid_rdata;

assign func_lut_ldb_pp2vas_we                   = memi_lut_ldb_pp2vas.we;
assign func_lut_ldb_pp2vas_re                   = memi_lut_ldb_pp2vas.re;
assign func_lut_ldb_pp2vas_waddr                = memi_lut_ldb_pp2vas.addr;
assign func_lut_ldb_pp2vas_raddr                = memi_lut_ldb_pp2vas.addr;
assign func_lut_ldb_pp2vas_wdata                = memi_lut_ldb_pp2vas.wdata;
assign memo_lut_ldb_pp2vas.rdata                = func_lut_ldb_pp2vas_rdata;

assign func_lut_ldb_qid2vqid_we                 = memi_lut_ldb_qid2vqid.we;
assign func_lut_ldb_qid2vqid_re                 = memi_lut_ldb_qid2vqid.re;
assign func_lut_ldb_qid2vqid_waddr              = memi_lut_ldb_qid2vqid.addr;
assign func_lut_ldb_qid2vqid_raddr              = memi_lut_ldb_qid2vqid.addr;
assign func_lut_ldb_qid2vqid_wdata              = memi_lut_ldb_qid2vqid.wdata;
assign memo_lut_ldb_qid2vqid.rdata              = func_lut_ldb_qid2vqid_rdata;

assign func_lut_ldb_vasqid_v_we                 = memi_lut_ldb_vasqid_v.we;
assign func_lut_ldb_vasqid_v_re                 = memi_lut_ldb_vasqid_v.re;
assign func_lut_ldb_vasqid_v_waddr              = memi_lut_ldb_vasqid_v.addr;
assign func_lut_ldb_vasqid_v_raddr              = memi_lut_ldb_vasqid_v.addr;
assign func_lut_ldb_vasqid_v_wdata              = memi_lut_ldb_vasqid_v.wdata;
assign memo_lut_ldb_vasqid_v.rdata              = func_lut_ldb_vasqid_v_rdata;

assign func_lut_vf_dir_vpp2pp_we                = memi_lut_vf_dir_vpp2pp.we;
assign func_lut_vf_dir_vpp2pp_re                = memi_lut_vf_dir_vpp2pp.re;
assign func_lut_vf_dir_vpp2pp_waddr             = memi_lut_vf_dir_vpp2pp.addr;
assign func_lut_vf_dir_vpp2pp_raddr             = memi_lut_vf_dir_vpp2pp.addr;
assign func_lut_vf_dir_vpp2pp_wdata             = memi_lut_vf_dir_vpp2pp.wdata;
assign memo_lut_vf_dir_vpp2pp.rdata             = func_lut_vf_dir_vpp2pp_rdata;

assign func_lut_vf_dir_vpp_v_we                 = memi_lut_vf_dir_vpp_v.we;
assign func_lut_vf_dir_vpp_v_re                 = memi_lut_vf_dir_vpp_v.re;
assign func_lut_vf_dir_vpp_v_waddr              = memi_lut_vf_dir_vpp_v.addr;
assign func_lut_vf_dir_vpp_v_raddr              = memi_lut_vf_dir_vpp_v.addr;
assign func_lut_vf_dir_vpp_v_wdata              = memi_lut_vf_dir_vpp_v.wdata;
assign memo_lut_vf_dir_vpp_v.rdata              = func_lut_vf_dir_vpp_v_rdata;

assign func_lut_vf_dir_vqid2qid_we              = memi_lut_vf_dir_vqid2qid.we;
assign func_lut_vf_dir_vqid2qid_re              = memi_lut_vf_dir_vqid2qid.re;
assign func_lut_vf_dir_vqid2qid_waddr           = memi_lut_vf_dir_vqid2qid.addr;
assign func_lut_vf_dir_vqid2qid_raddr           = memi_lut_vf_dir_vqid2qid.addr;
assign func_lut_vf_dir_vqid2qid_wdata           = memi_lut_vf_dir_vqid2qid.wdata;
assign memo_lut_vf_dir_vqid2qid.rdata           = func_lut_vf_dir_vqid2qid_rdata;

assign func_lut_vf_dir_vqid_v_we                = memi_lut_vf_dir_vqid_v.we;
assign func_lut_vf_dir_vqid_v_re                = memi_lut_vf_dir_vqid_v.re;
assign func_lut_vf_dir_vqid_v_waddr             = memi_lut_vf_dir_vqid_v.addr;
assign func_lut_vf_dir_vqid_v_raddr             = memi_lut_vf_dir_vqid_v.addr;
assign func_lut_vf_dir_vqid_v_wdata             = memi_lut_vf_dir_vqid_v.wdata;
assign memo_lut_vf_dir_vqid_v.rdata             = func_lut_vf_dir_vqid_v_rdata;

assign func_lut_vf_ldb_vpp2pp_we                = memi_lut_vf_ldb_vpp2pp.we;
assign func_lut_vf_ldb_vpp2pp_re                = memi_lut_vf_ldb_vpp2pp.re;
assign func_lut_vf_ldb_vpp2pp_waddr             = memi_lut_vf_ldb_vpp2pp.addr;
assign func_lut_vf_ldb_vpp2pp_raddr             = memi_lut_vf_ldb_vpp2pp.addr;
assign func_lut_vf_ldb_vpp2pp_wdata             = memi_lut_vf_ldb_vpp2pp.wdata;
assign memo_lut_vf_ldb_vpp2pp.rdata             = func_lut_vf_ldb_vpp2pp_rdata;

assign func_lut_vf_ldb_vpp_v_we                 = memi_lut_vf_ldb_vpp_v.we;
assign func_lut_vf_ldb_vpp_v_re                 = memi_lut_vf_ldb_vpp_v.re;
assign func_lut_vf_ldb_vpp_v_waddr              = memi_lut_vf_ldb_vpp_v.addr;
assign func_lut_vf_ldb_vpp_v_raddr              = memi_lut_vf_ldb_vpp_v.addr;
assign func_lut_vf_ldb_vpp_v_wdata              = memi_lut_vf_ldb_vpp_v.wdata;
assign memo_lut_vf_ldb_vpp_v.rdata              = func_lut_vf_ldb_vpp_v_rdata;

assign func_lut_vf_ldb_vqid2qid_we              = memi_lut_vf_ldb_vqid2qid.we;
assign func_lut_vf_ldb_vqid2qid_re              = memi_lut_vf_ldb_vqid2qid.re;
assign func_lut_vf_ldb_vqid2qid_waddr           = memi_lut_vf_ldb_vqid2qid.addr;
assign func_lut_vf_ldb_vqid2qid_raddr           = memi_lut_vf_ldb_vqid2qid.addr;
assign func_lut_vf_ldb_vqid2qid_wdata           = memi_lut_vf_ldb_vqid2qid.wdata;
assign memo_lut_vf_ldb_vqid2qid.rdata           = func_lut_vf_ldb_vqid2qid_rdata;

assign func_lut_vf_ldb_vqid_v_we                = memi_lut_vf_ldb_vqid_v.we;
assign func_lut_vf_ldb_vqid_v_re                = memi_lut_vf_ldb_vqid_v.re;
assign func_lut_vf_ldb_vqid_v_waddr             = memi_lut_vf_ldb_vqid_v.addr;
assign func_lut_vf_ldb_vqid_v_raddr             = memi_lut_vf_ldb_vqid_v.addr;
assign func_lut_vf_ldb_vqid_v_wdata             = memi_lut_vf_ldb_vqid_v.wdata;
assign memo_lut_vf_ldb_vqid_v.rdata             = func_lut_vf_ldb_vqid_v_rdata;

assign func_msix_tbl_word0_we                   = memi_msix_tbl_word0.we;
assign func_msix_tbl_word0_re                   = memi_msix_tbl_word0.re;
assign func_msix_tbl_word0_waddr                = memi_msix_tbl_word0.addr[5:0];
assign func_msix_tbl_word0_raddr                = memi_msix_tbl_word0.addr[5:0];
assign func_msix_tbl_word0_wdata                = memi_msix_tbl_word0.wdata;
assign memo_msix_tbl_word0.rdata                = func_msix_tbl_word0_rdata;

assign func_msix_tbl_word1_we                   = memi_msix_tbl_word1.we;
assign func_msix_tbl_word1_re                   = memi_msix_tbl_word1.re;
assign func_msix_tbl_word1_waddr                = memi_msix_tbl_word1.addr[5:0];
assign func_msix_tbl_word1_raddr                = memi_msix_tbl_word1.addr[5:0];
assign func_msix_tbl_word1_wdata                = memi_msix_tbl_word1.wdata;
assign memo_msix_tbl_word1.rdata                = func_msix_tbl_word1_rdata;

assign func_msix_tbl_word2_we                   = memi_msix_tbl_word2.we;
assign func_msix_tbl_word2_re                   = memi_msix_tbl_word2.re;
assign func_msix_tbl_word2_waddr                = memi_msix_tbl_word2.addr[5:0];
assign func_msix_tbl_word2_raddr                = memi_msix_tbl_word2.addr[5:0];
assign func_msix_tbl_word2_wdata                = memi_msix_tbl_word2.wdata;
assign memo_msix_tbl_word2.rdata                = func_msix_tbl_word2_rdata;

assign func_sch_out_fifo_we                     = memi_sch_out_fifo.we;
assign func_sch_out_fifo_re                     = memi_sch_out_fifo.re;
assign func_sch_out_fifo_waddr                  = memi_sch_out_fifo.waddr;
assign func_sch_out_fifo_raddr                  = memi_sch_out_fifo.raddr;
assign func_sch_out_fifo_wdata                  = memi_sch_out_fifo.wdata;
assign memo_sch_out_fifo.rdata                  = func_sch_out_fifo_rdata;

assign func_rob_mem_we                          = memi_rob_mem.we;
assign func_rob_mem_re                          = memi_rob_mem.re;
assign func_rob_mem_addr                        = memi_rob_mem.addr;
assign func_rob_mem_wdata                       = memi_rob_mem.wdata;
assign memo_rob_mem.rdata                       = func_rob_mem_rdata;

// END HQM_MEMS_ASSIGN

assign rf_ipar_error = hqm_system_rfw_top_ipar_error ;

//-----------------------------------------------------------------------------------------------------
// SMON logic

localparam SMON_WIDTH = 33;

logic   [9:0]                           smon_cfg_write_q;
logic   [9:0]                           smon_cfg_read_q;
logic   [31:0]                          smon_cfg_wdata_q;
logic                                   smon_cfg_addr_q;
logic   [31:0]                          smon_cfg_rdata[19:0];

logic   [ SMON_WIDTH    -1:0]           smon_v;
logic   [(SMON_WIDTH*32)-1:0]           smon_comp;
logic   [(SMON_WIDTH*32)-1:0]           smon_val;
logic   [2:0]                           smon_enabled;

logic   [9:0]                           perf_smon_cfg_write_q;
logic   [9:0]                           perf_smon_cfg_read_q;
logic   [31:0]                          perf_smon_cfg_rdata[9:0];

logic   [ 2    -1:0]                    perf_smon_v;
logic   [(2*32)-1:0]                    perf_smon_comp;
logic   [(2*32)-1:0]                    perf_smon_val;

logic                                   hqm_alarm_ready_q;
logic                                   hqm_alarm_v_q;
aw_alarm_t                              hqm_alarm_data_q;
hcw_enq_w_req_wuser_t                   hcw_enq_w_req_user_q;
logic [127:64]                          hcw_enq_w_req_q;
logic [$bits(hcw_sched_w_req_wuser_t)-1:0] hcw_sched_w_req_user_q;
logic [127:64]                          hcw_sched_w_req_q;
logic                                   interrupt_w_req_ready_q;
logic                                   interrupt_w_req_valid_q;
logic                                   cwdi_int_w_req_ready_q;
logic                                   cwdi_int_w_req_valid_q;
interrupt_w_req_t                       interrupt_w_req_q;
logic                                   ims_msix_w_ready_q;
logic                                   ims_msix_w_v_q;
logic [31:0]                            ims_msix_w_data_q;
interrupt_w_req_t                       cq_occ_int_q;
logic   [6:0]                           fifo_afull_q;
logic   [31:0]                          hcw_sched_out_comp_q;
logic                                   hcw_sched_w_req_ready_q;
logic                                   hcw_sched_w_req_valid_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  smon_cfg_write_q      <= '0;
  smon_cfg_read_q       <= '0;
  perf_smon_cfg_write_q <= '0;
  perf_smon_cfg_read_q  <= '0;
 end else begin
  smon_cfg_write_q      <= {(&cfg_we.AW_SMON_COMP_MASK1)
                           ,(&cfg_we.AW_SMON_COMP_MASK0)
                           ,(&cfg_we.AW_SMON_MAXIMUM_TIMER)
                           ,(&cfg_we.AW_SMON_TIMER)
                           ,(&cfg_we.AW_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_we.AW_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_we.AW_SMON_COMPARE1)
                           ,(&cfg_we.AW_SMON_COMPARE0)
                           ,(&cfg_we.AW_SMON_CONFIGURATION1)
                           ,(&cfg_we.AW_SMON_CONFIGURATION0)
                           } & ~{10{(|smon_cfg_write_q)}};
  smon_cfg_read_q       <= {(&cfg_re.AW_SMON_COMP_MASK1)
                           ,(&cfg_re.AW_SMON_COMP_MASK0)
                           ,(&cfg_re.AW_SMON_MAXIMUM_TIMER)
                           ,(&cfg_re.AW_SMON_TIMER)
                           ,(&cfg_re.AW_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_re.AW_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_re.AW_SMON_COMPARE1)
                           ,(&cfg_re.AW_SMON_COMPARE0)
                           ,(&cfg_re.AW_SMON_CONFIGURATION1)
                           ,(&cfg_re.AW_SMON_CONFIGURATION0)
                           } & ~{10{(|smon_cfg_read_q)}};
  perf_smon_cfg_write_q <= {(&cfg_we.PERF_SMON_COMP_MASK1)
                           ,(&cfg_we.PERF_SMON_COMP_MASK0)
                           ,(&cfg_we.PERF_SMON_MAXIMUM_TIMER)
                           ,(&cfg_we.PERF_SMON_TIMER)
                           ,(&cfg_we.PERF_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_we.PERF_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_we.PERF_SMON_COMPARE1)
                           ,(&cfg_we.PERF_SMON_COMPARE0)
                           ,(&cfg_we.PERF_SMON_CONFIGURATION1)
                           ,(&cfg_we.PERF_SMON_CONFIGURATION0)
                           } & ~{10{(|perf_smon_cfg_write_q)}};
  perf_smon_cfg_read_q  <= {(&cfg_re.PERF_SMON_COMP_MASK1)
                           ,(&cfg_re.PERF_SMON_COMP_MASK0)
                           ,(&cfg_re.PERF_SMON_MAXIMUM_TIMER)
                           ,(&cfg_re.PERF_SMON_TIMER)
                           ,(&cfg_re.PERF_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_re.PERF_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_re.PERF_SMON_COMPARE1)
                           ,(&cfg_re.PERF_SMON_COMPARE0)
                           ,(&cfg_re.PERF_SMON_CONFIGURATION1)
                           ,(&cfg_re.PERF_SMON_CONFIGURATION0)
                           } & ~{10{(|perf_smon_cfg_read_q)}};
 end
end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
    ims_msix_w_ready_q          <= '0;
    ims_msix_w_v_q              <= '0;
    system_local_idle_q         <= '0;
    system_idle_q               <= '0;
  end else begin
    if (|smon_enabled) begin
      ims_msix_w_ready_q        <= ims_msix_w_ready;
      ims_msix_w_v_q            <= ims_msix_w_v;
      system_local_idle_q       <= system_local_idle;
      system_idle_q             <= system_idle;
    end
  end
end

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
  if (~hqm_inp_gated_rst_n) begin
    hcw_sched_w_req_ready_q     <= '0;
    hcw_sched_w_req_valid_q     <= '0;
    interrupt_w_req_ready_q     <= '0;
    interrupt_w_req_valid_q     <= '0;
    cwdi_int_w_req_ready_q      <= '0;
    cwdi_int_w_req_valid_q      <= '0;
    hqm_alarm_ready_q           <= '0;
    hqm_alarm_v_q               <= '0;
  end else begin
    if (|smon_enabled) begin
      hcw_sched_w_req_ready_q   <= hcw_sched_w_req_ready;
      hcw_sched_w_req_valid_q   <= hcw_sched_w_req_valid;
      interrupt_w_req_ready_q   <= interrupt_w_req_ready;
      interrupt_w_req_valid_q   <= interrupt_w_req_valid;
      cwdi_int_w_req_ready_q    <= cwdi_interrupt_w_req_ready;
      cwdi_int_w_req_valid_q    <= cwdi_interrupt_w_req_valid;
      hqm_alarm_ready_q         <= hqm_alarm_ready;
      hqm_alarm_v_q             <= hqm_alarm_v;
    end
  end
end

always_ff @(posedge hqm_gated_clk) begin
 smon_cfg_wdata_q <= cfg_wdata.AW_SMON_TIMER;
 smon_cfg_addr_q  <= cfg_addr[6];
 if (|smon_enabled) begin
  hcw_enq_w_req_user_q        <= hcw_enq_w_req.user;
  hcw_enq_w_req_q             <= hcw_enq_w_req.data[127:64];
  ims_msix_w_data_q           <= ims_msix_w.data;
  cq_occ_int_q                <= cq_occ_int;

  fifo_afull_q                <= {hcw_enq_fifo_status.AFULL         // 6
                                 ,hcw_sch_fifo_status.AFULL         // 5
                                 ,sch_out_fifo_status.AFULL         // 4
                                 ,cfg_rx_fifo_status.AFULL          // 3
                                 ,cwdi_rx_fifo_status.AFULL         // 2
                                 ,hqm_alarm_rx_fifo_status.AFULL    // 1
                                 ,sif_alarm_fifo_status.AFULL       // 0
                                 };

  hcw_sched_out_comp_q        <= {hcw_sched_out.pasidtlp[22]                                        // 31
                                 ,hcw_sched_out.pasidtlp[1:0]                                       // 30:29
                                 ,hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb                     // 28
                                 ,hcw_sched_out.w.user.cq[6:0]                                      // 27:21
                                 ,hcw_sched_out.w.user.hqm_core_flags.write_buffer_optimization     // 20:19
                                 ,hcw_sched_out.w.user.cq_wptr[1:0]                                 // 18:17
                                 ,hcw_sched_out.error                                               // 16
                                 ,hcw_sched_out.ro                                                  // 15
                                 ,hcw_sched_out.vf                                                  // 14:11
                                 ,hcw_sched_out.is_pf                                               // 10
                                 ,hcw_sched_out.hcw_v                                               // 9
                                 ,hcw_sched_out.int_v                                               // 8
                                 ,hcw_sched_out.int_d.is_ldb                                        // 7
                                 ,hcw_sched_out.int_d.cq_occ_cq                                     // 6:0
                                 };
 end
end

always_ff @(posedge hqm_inp_gated_clk) begin
 if (|smon_enabled) begin
  hcw_sched_w_req_user_q      <= hcw_sched_w_req.user;
  hcw_sched_w_req_q           <= hcw_sched_w_req.data[127:64];
  interrupt_w_req_q           <= interrupt_w_req;
  hqm_alarm_data_q            <= hqm_alarm_data;
 end
end

assign cfg_rvalid.AW_SMON_COMP_MASK1        = smon_cfg_read_q[9];
assign cfg_rvalid.AW_SMON_COMP_MASK0        = smon_cfg_read_q[8];
assign cfg_rvalid.AW_SMON_MAXIMUM_TIMER     = smon_cfg_read_q[7];
assign cfg_rvalid.AW_SMON_TIMER             = smon_cfg_read_q[6];
assign cfg_rvalid.AW_SMON_ACTIVITYCOUNTER1  = smon_cfg_read_q[5];
assign cfg_rvalid.AW_SMON_ACTIVITYCOUNTER0  = smon_cfg_read_q[4];
assign cfg_rvalid.AW_SMON_COMPARE1          = smon_cfg_read_q[3];
assign cfg_rvalid.AW_SMON_COMPARE0          = smon_cfg_read_q[2];
assign cfg_rvalid.AW_SMON_CONFIGURATION1    = smon_cfg_read_q[1];
assign cfg_rvalid.AW_SMON_CONFIGURATION0    = smon_cfg_read_q[0];

assign cfg_wvalid.AW_SMON_COMP_MASK1        = smon_cfg_write_q[9];
assign cfg_wvalid.AW_SMON_COMP_MASK0        = smon_cfg_write_q[8];
assign cfg_wvalid.AW_SMON_MAXIMUM_TIMER     = smon_cfg_write_q[7];
assign cfg_wvalid.AW_SMON_TIMER             = smon_cfg_write_q[6];
assign cfg_wvalid.AW_SMON_ACTIVITYCOUNTER1  = smon_cfg_write_q[5];
assign cfg_wvalid.AW_SMON_ACTIVITYCOUNTER0  = smon_cfg_write_q[4];
assign cfg_wvalid.AW_SMON_COMPARE1          = smon_cfg_write_q[3];
assign cfg_wvalid.AW_SMON_COMPARE0          = smon_cfg_write_q[2];
assign cfg_wvalid.AW_SMON_CONFIGURATION1    = smon_cfg_write_q[1];
assign cfg_wvalid.AW_SMON_CONFIGURATION0    = smon_cfg_write_q[0];

assign cfg_error.AW_SMON_COMP_MASK1         = '0;
assign cfg_error.AW_SMON_COMP_MASK0         = '0;
assign cfg_error.AW_SMON_MAXIMUM_TIMER      = '0;
assign cfg_error.AW_SMON_TIMER              = '0;
assign cfg_error.AW_SMON_ACTIVITYCOUNTER1   = '0;
assign cfg_error.AW_SMON_ACTIVITYCOUNTER0   = '0;
assign cfg_error.AW_SMON_COMPARE1           = '0;
assign cfg_error.AW_SMON_COMPARE0           = '0;
assign cfg_error.AW_SMON_CONFIGURATION1     = '0;
assign cfg_error.AW_SMON_CONFIGURATION0     = '0;

assign cfg_rdata.AW_SMON_COMP_MASK1         = (smon_cfg_addr_q) ? smon_cfg_rdata[19] : smon_cfg_rdata[9];
assign cfg_rdata.AW_SMON_COMP_MASK0         = (smon_cfg_addr_q) ? smon_cfg_rdata[18] : smon_cfg_rdata[8];
assign cfg_rdata.AW_SMON_MAXIMUM_TIMER      = (smon_cfg_addr_q) ? smon_cfg_rdata[17] : smon_cfg_rdata[7];
assign cfg_rdata.AW_SMON_TIMER              = (smon_cfg_addr_q) ? smon_cfg_rdata[16] : smon_cfg_rdata[6];
assign cfg_rdata.AW_SMON_ACTIVITYCOUNTER1   = (smon_cfg_addr_q) ? smon_cfg_rdata[15] : smon_cfg_rdata[5];
assign cfg_rdata.AW_SMON_ACTIVITYCOUNTER0   = (smon_cfg_addr_q) ? smon_cfg_rdata[14] : smon_cfg_rdata[4];
assign cfg_rdata.AW_SMON_COMPARE1           = (smon_cfg_addr_q) ? smon_cfg_rdata[13] : smon_cfg_rdata[3];
assign cfg_rdata.AW_SMON_COMPARE0           = (smon_cfg_addr_q) ? smon_cfg_rdata[12] : smon_cfg_rdata[2];
assign cfg_rdata.AW_SMON_CONFIGURATION1     = (smon_cfg_addr_q) ? smon_cfg_rdata[11] : smon_cfg_rdata[1];
assign cfg_rdata.AW_SMON_CONFIGURATION0     = (smon_cfg_addr_q) ? smon_cfg_rdata[10] : smon_cfg_rdata[0];

assign smon_v    = {
                    1'b1                                                        // 32   SCH CLR drops
                   ,1'b1                                                        // 31   SCH SM drops
                   ,1'b1                                                        // 30   FIFO afulls
                   ,(|wbuf_appended)                                            // 29   Coalesced wbuf writes
                   ,system_idle_q                                               // 28   Idle
                   ,cq_occ_db_status[3]                                         // 27   CQ Occ ints egress->wbuf
                   ,(ims_msix_w_ready_q & ims_msix_w_v_q)                       // 26   IMS/MSI-X ints
                   ,1'd0                                                        // 25   Spare
                   ,1'd0                                                        // 24   Spare
                   ,(|{sch_wb_error, sch_wb_sb_ecc_error})                      // 23   WBUF errors
                   ,(|sch_wb_mb_ecc_error)                                      // 22   WBUF MB ECC errors
                   ,(|ingress_sb_ecc_error)                                     // 21   INGRESS SB ECC errors
                   ,(|ingress_mb_ecc_error)                                     // 20   INGRESS MB ECC errors
                   ,1'b1                                                        // 19   DB input stalls
                   ,1'b1                                                        // 18   DB output stalls
                   ,1'b1                                                        // 17   DB output takens
                   ,hcw_sched_db_status[3]                                      // 16   egress->wbuf hcw sched
                   ,ingress_alarm_v                                             // 15   ingress alarms info
                   ,ingress_alarm_v                                             // 14   ingress alarms ms
                   ,ingress_alarm_v                                             // 13   ingress alarms ls
                   ,ims_msix_db_status[3]                                       // 12   ai_ims_msix writes
                   ,(cwdi_int_w_req_valid_q & cwdi_int_w_req_ready_q)           // 11   cq wd alarms
                   ,sif_alarm_fifo_pop                                          // 10   sif alarms
                   ,(hqm_alarm_v_q & hqm_alarm_ready_q)                         //  9   hqm_core alarms
                   ,sys_alarm_db_status[5]                                      //  8   system alarms
                   ,(interrupt_w_req_valid_q & interrupt_w_req_ready_q)         //  7   hqm_core cq_occ alarm ints
                   ,pwrite_v                                                    //  6   wbuf->mstr valid
                   ,(hcw_sched_w_req_ready_q & hcw_sched_w_req_valid_q)         //  5   hqm_core->egress hcw sched w ms
                   ,(hcw_sched_w_req_ready_q & hcw_sched_w_req_valid_q)         //  4   hqm_core->egress hcw sched w ls
                   ,(hcw_sched_w_req_ready_q & hcw_sched_w_req_valid_q)         //  3   hqm_core->egress hcw sched w user
                   ,hcw_enq_w_db_status[3]                                      //  2   ingress->hqm_core hcw enq w ms
                   ,hcw_enq_w_db_status[3]                                      //  1   ingress->hqm_core hcw enq w ls
                   ,hcw_enq_w_db_status[3]                                      //  0   ingress->hqm_core hcw enq w user
};

assign smon_comp = {
                    {{(32-$bits(sch_clr_drops_comp)){1'b0}}
                    ,sch_clr_drops_comp}                                        // 32   SCH CLR drops
                   ,{{(32-$bits(sch_sm_drops_comp)){1'b0}}
                    ,sch_sm_drops_comp}                                         // 31   SCH SM drops
                   ,{25'd0, fifo_afull_q}                                       // 30
                   ,{30'd0, wbuf_appended}                                      // 29
                   ,32'd0                                                       // 28
                   ,{{(32-$bits(cq_occ_int_q)){1'b0}}
                    ,cq_occ_int_q}                                              // 27
                   ,ims_msix_w_data_q                                           // 26
                   ,32'd0                                                       // 25
                   ,32'd0                                                       // 24
                   ,{20'd0, sch_wb_error_synd, sch_wb_sb_ecc_error}             // 23
                   ,{28'd0, sch_wb_mb_ecc_error}                                // 22
                   ,{27'd0, ingress_sb_ecc_error}                               // 21
                   ,{29'd0, ingress_mb_ecc_error}                               // 20
                   ,{23'd0
                    ,phdr_db_status[6]                                          // 19 b8
                    ,pdata_ms_db_status[6]                                      // 19 b7
                    ,pdata_ls_db_status[6]                                      // 19 b6
                    ,hcw_enq_db_status[6]                                       // 19 b5
                    ,cq_occ_db_status[6]                                        // 19 b4
                    ,hcw_sched_db_status[6]                                     // 19 b3
                    ,ims_msix_db_status[6]                                      // 19 b2
                    ,sys_alarm_db_status[6]                                     // 19 b1
                    ,hcw_enq_w_db_status[6]}                                    // 19 b0
                   ,{23'd0
                    ,phdr_db_status[4]                                          // 18 b8
                    ,pdata_ms_db_status[4]                                      // 18 b7
                    ,pdata_ls_db_status[4]                                      // 18 b6
                    ,hcw_enq_db_status[4]                                       // 18 b5
                    ,cq_occ_db_status[4]                                        // 18 b4
                    ,hcw_sched_db_status[4]                                     // 18 b3
                    ,ims_msix_db_status[4]                                      // 18 b2
                    ,sys_alarm_db_status[4]                                     // 18 b1
                    ,hcw_enq_w_db_status[4]}                                    // 18 b0
                   ,{23'd0
                    ,phdr_db_status[5]                                          // 17 b8
                    ,pdata_ms_db_status[5]                                      // 17 b7
                    ,pdata_ls_db_status[5]                                      // 17 b6
                    ,hcw_enq_db_status[5]                                       // 17 b5
                    ,cq_occ_db_status[5]                                        // 17 b4
                    ,hcw_sched_db_status[5]                                     // 17 b3
                    ,ims_msix_db_status[5]                                      // 17 b2
                    ,sys_alarm_db_status[3]                                     // 17 b1
                    ,hcw_enq_w_db_status[5]}                                    // 17 b0
                   ,hcw_sched_out_comp_q                                        // 16
                   ,{{(96-$bits(ingress_alarm)){1'b0}}
                    ,ingress_alarm[$bits(ingress_alarm)-1:64]}                  // 15
                   ,ingress_alarm.hcw[63:32]                                    // 14
                   ,ingress_alarm.hcw[31: 0]                                    // 13
                   ,32'd0                                                       // 12
                   ,32'd0                                                       // 11
                   ,{{(32-$bits(sif_alarm_fifo_pop_data)){1'b0}}
                    ,sif_alarm_fifo_pop_data}                                   // 10
                   ,{{(32-$bits(hqm_alarm_data_q)){1'b0}}
                    ,hqm_alarm_data_q}                                          //  9
                   ,32'd0                                                       //  8
                   ,{{(32-$bits(interrupt_w_req_q)){1'b0}}
                    ,interrupt_w_req_q}                                         //  7
                   ,pwrite_comp                                                 //  6
                   ,hcw_sched_w_req_q[127:96]                                   //  5
                   ,hcw_sched_w_req_q[ 95:64]                                   //  4
                   ,{{(32-$bits(hcw_sched_w_req_user_q)){1'b0}}
                    ,hcw_sched_w_req_user_q}                                    //  3
                   ,hcw_enq_w_req_q[127:96]                                     //  2
                   ,hcw_enq_w_req_q[ 95:64]                                     //  1
                   ,{{(32-$bits(hcw_enq_w_req_user_q)){1'b0}}
                    ,hcw_enq_w_req_user_q}                                      //  0
};

assign smon_val  = {
                    {{(32-$bits(sch_clr_drops)){1'b0}}
                    ,sch_clr_drops}                                             // 32   SCH CLR drops
                   ,{{(32-$bits(sch_sm_drops)){1'b0}}
                    ,sch_sm_drops}                                              // 31   SCH SM drops
                   ,32'd1                                                       // 30
                   ,{30'd0, wbuf_appended}                                      // 29
                   ,32'd1                                                       // 28
                   ,32'd1                                                       // 27
                   ,32'd1                                                       // 26
                   ,32'd1                                                       // 25
                   ,32'd1                                                       // 24
                   ,32'd1                                                       // 23
                   ,32'd1                                                       // 22
                   ,32'd1                                                       // 21
                   ,32'd1                                                       // 20
                   ,32'd1                                                       // 19
                   ,32'd1                                                       // 18
                   ,32'd1                                                       // 17
                   ,32'd1                                                       // 16
                   ,32'd1                                                       // 15
                   ,32'd1                                                       // 14
                   ,32'd1                                                       // 13
                   ,32'd1                                                       // 12
                   ,32'd1                                                       // 11
                   ,32'd1                                                       // 10
                   ,32'd1                                                       //  9
                   ,32'd1                                                       //  8
                   ,32'd1                                                       //  7
                   ,pwrite_value                                                //  6
                   ,32'd16                                                      //  5
                   ,32'd16                                                      //  4
                   ,32'd1                                                       //  3
                   ,32'd16                                                      //  2
                   ,32'd16                                                      //  1
                   ,32'd1                                                       //  0
};

logic   [2:0]   out_smon_interrupt_nc;

hqm_AW_smon_mask #(.WIDTH(SMON_WIDTH)) i_smon0 (

         .clk                   (hqm_inp_gated_clk)
        ,.rst_n                 (hqm_inp_gated_rst_n)
        ,.disable_smon          (1'b0)

        ,.in_smon_cfg0_write    (smon_cfg_write_q[0] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg1_write    (smon_cfg_write_q[1] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg2_write    (smon_cfg_write_q[2] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg3_write    (smon_cfg_write_q[3] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg4_write    (smon_cfg_write_q[4] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg5_write    (smon_cfg_write_q[5] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg6_write    (smon_cfg_write_q[6] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg7_write    (smon_cfg_write_q[7] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg8_write    (smon_cfg_write_q[8] & ~smon_cfg_addr_q)        
        ,.in_smon_cfg9_write    (smon_cfg_write_q[9] & ~smon_cfg_addr_q)        

        ,.in_smon_cfg_wdata     (smon_cfg_wdata_q)

        ,.out_smon_cfg0_data    (smon_cfg_rdata[0])
        ,.out_smon_cfg1_data    (smon_cfg_rdata[1])
        ,.out_smon_cfg2_data    (smon_cfg_rdata[2])
        ,.out_smon_cfg3_data    (smon_cfg_rdata[3])
        ,.out_smon_cfg4_data    (smon_cfg_rdata[4])
        ,.out_smon_cfg5_data    (smon_cfg_rdata[5])
        ,.out_smon_cfg6_data    (smon_cfg_rdata[6])
        ,.out_smon_cfg7_data    (smon_cfg_rdata[7])
        ,.out_smon_cfg8_data    (smon_cfg_rdata[8])
        ,.out_smon_cfg9_data    (smon_cfg_rdata[9])

        ,.in_mon_v              (smon_v)
        ,.in_mon_comp           (smon_comp)
        ,.in_mon_val            (smon_val)

        ,.out_smon_interrupt    (out_smon_interrupt_nc[0])
        ,.out_smon_enabled      (smon_enabled[0])
);

hqm_AW_smon_mask #(.WIDTH(SMON_WIDTH)) i_smon1 (

         .clk                   (hqm_inp_gated_clk)
        ,.rst_n                 (hqm_inp_gated_rst_n)
        ,.disable_smon          (1'b0)

        ,.in_smon_cfg0_write    (smon_cfg_write_q[0] & smon_cfg_addr_q)         
        ,.in_smon_cfg1_write    (smon_cfg_write_q[1] & smon_cfg_addr_q)         
        ,.in_smon_cfg2_write    (smon_cfg_write_q[2] & smon_cfg_addr_q)         
        ,.in_smon_cfg3_write    (smon_cfg_write_q[3] & smon_cfg_addr_q)         
        ,.in_smon_cfg4_write    (smon_cfg_write_q[4] & smon_cfg_addr_q)         
        ,.in_smon_cfg5_write    (smon_cfg_write_q[5] & smon_cfg_addr_q)         
        ,.in_smon_cfg6_write    (smon_cfg_write_q[6] & smon_cfg_addr_q)         
        ,.in_smon_cfg7_write    (smon_cfg_write_q[7] & smon_cfg_addr_q)         
        ,.in_smon_cfg8_write    (smon_cfg_write_q[8] & smon_cfg_addr_q)         
        ,.in_smon_cfg9_write    (smon_cfg_write_q[9] & smon_cfg_addr_q)         

        ,.in_smon_cfg_wdata     (smon_cfg_wdata_q)

        ,.out_smon_cfg0_data    (smon_cfg_rdata[10])
        ,.out_smon_cfg1_data    (smon_cfg_rdata[11])
        ,.out_smon_cfg2_data    (smon_cfg_rdata[12])
        ,.out_smon_cfg3_data    (smon_cfg_rdata[13])
        ,.out_smon_cfg4_data    (smon_cfg_rdata[14])
        ,.out_smon_cfg5_data    (smon_cfg_rdata[15])
        ,.out_smon_cfg6_data    (smon_cfg_rdata[16])
        ,.out_smon_cfg7_data    (smon_cfg_rdata[17])
        ,.out_smon_cfg8_data    (smon_cfg_rdata[18])
        ,.out_smon_cfg9_data    (smon_cfg_rdata[19])

        ,.in_mon_v              (smon_v)
        ,.in_mon_comp           (smon_comp)
        ,.in_mon_val            (smon_val)

        ,.out_smon_interrupt    (out_smon_interrupt_nc[1])
        ,.out_smon_enabled      (smon_enabled[1])
);

assign cfg_rvalid.PERF_SMON_COMP_MASK1        = perf_smon_cfg_read_q[9];
assign cfg_rvalid.PERF_SMON_COMP_MASK0        = perf_smon_cfg_read_q[8];
assign cfg_rvalid.PERF_SMON_MAXIMUM_TIMER     = perf_smon_cfg_read_q[7];
assign cfg_rvalid.PERF_SMON_TIMER             = perf_smon_cfg_read_q[6];
assign cfg_rvalid.PERF_SMON_ACTIVITYCOUNTER1  = perf_smon_cfg_read_q[5];
assign cfg_rvalid.PERF_SMON_ACTIVITYCOUNTER0  = perf_smon_cfg_read_q[4];
assign cfg_rvalid.PERF_SMON_COMPARE1          = perf_smon_cfg_read_q[3];
assign cfg_rvalid.PERF_SMON_COMPARE0          = perf_smon_cfg_read_q[2];
assign cfg_rvalid.PERF_SMON_CONFIGURATION1    = perf_smon_cfg_read_q[1];
assign cfg_rvalid.PERF_SMON_CONFIGURATION0    = perf_smon_cfg_read_q[0];

assign cfg_wvalid.PERF_SMON_COMP_MASK1        = perf_smon_cfg_write_q[9];
assign cfg_wvalid.PERF_SMON_COMP_MASK0        = perf_smon_cfg_write_q[8];
assign cfg_wvalid.PERF_SMON_MAXIMUM_TIMER     = perf_smon_cfg_write_q[7];
assign cfg_wvalid.PERF_SMON_TIMER             = perf_smon_cfg_write_q[6];
assign cfg_wvalid.PERF_SMON_ACTIVITYCOUNTER1  = perf_smon_cfg_write_q[5];
assign cfg_wvalid.PERF_SMON_ACTIVITYCOUNTER0  = perf_smon_cfg_write_q[4];
assign cfg_wvalid.PERF_SMON_COMPARE1          = perf_smon_cfg_write_q[3];
assign cfg_wvalid.PERF_SMON_COMPARE0          = perf_smon_cfg_write_q[2];
assign cfg_wvalid.PERF_SMON_CONFIGURATION1    = perf_smon_cfg_write_q[1];
assign cfg_wvalid.PERF_SMON_CONFIGURATION0    = perf_smon_cfg_write_q[0];

assign cfg_error.PERF_SMON_COMP_MASK1         = '0;
assign cfg_error.PERF_SMON_COMP_MASK0         = '0;
assign cfg_error.PERF_SMON_MAXIMUM_TIMER      = '0;
assign cfg_error.PERF_SMON_TIMER              = '0;
assign cfg_error.PERF_SMON_ACTIVITYCOUNTER1   = '0;
assign cfg_error.PERF_SMON_ACTIVITYCOUNTER0   = '0;
assign cfg_error.PERF_SMON_COMPARE1           = '0;
assign cfg_error.PERF_SMON_COMPARE0           = '0;
assign cfg_error.PERF_SMON_CONFIGURATION1     = '0;
assign cfg_error.PERF_SMON_CONFIGURATION0     = '0;

assign cfg_rdata.PERF_SMON_COMP_MASK1         = perf_smon_cfg_rdata[9];
assign cfg_rdata.PERF_SMON_COMP_MASK0         = perf_smon_cfg_rdata[8];
assign cfg_rdata.PERF_SMON_MAXIMUM_TIMER      = perf_smon_cfg_rdata[7];
assign cfg_rdata.PERF_SMON_TIMER              = perf_smon_cfg_rdata[6];
assign cfg_rdata.PERF_SMON_ACTIVITYCOUNTER1   = perf_smon_cfg_rdata[5];
assign cfg_rdata.PERF_SMON_ACTIVITYCOUNTER0   = perf_smon_cfg_rdata[4];
assign cfg_rdata.PERF_SMON_COMPARE1           = perf_smon_cfg_rdata[3];
assign cfg_rdata.PERF_SMON_COMPARE0           = perf_smon_cfg_rdata[2];
assign cfg_rdata.PERF_SMON_CONFIGURATION1     = perf_smon_cfg_rdata[1];
assign cfg_rdata.PERF_SMON_CONFIGURATION0     = perf_smon_cfg_rdata[0];

assign perf_smon_v    = {(pwrite_v & (pwrite_comp[1:0]==2'd1))      //  1 wbuf->mstr
                        ,hcw_enq_in_sync                            //  0 sif hcw enq
};

assign perf_smon_val  = {pwrite_value                               //  1
                        ,32'd1                                      //  0
};

assign perf_smon_comp = {2{32'd0}};

hqm_AW_smon_mask #(.WIDTH(2)) i_smon2 (

         .clk                   (hqm_gated_clk)
        ,.rst_n                 (hqm_gated_rst_n)
        ,.disable_smon          (1'b0)

        ,.in_smon_cfg0_write    (perf_smon_cfg_write_q[0])
        ,.in_smon_cfg1_write    (perf_smon_cfg_write_q[1])
        ,.in_smon_cfg2_write    (perf_smon_cfg_write_q[2])
        ,.in_smon_cfg3_write    (perf_smon_cfg_write_q[3])
        ,.in_smon_cfg4_write    (perf_smon_cfg_write_q[4])
        ,.in_smon_cfg5_write    (perf_smon_cfg_write_q[5])
        ,.in_smon_cfg6_write    (perf_smon_cfg_write_q[6])
        ,.in_smon_cfg7_write    (perf_smon_cfg_write_q[7])
        ,.in_smon_cfg8_write    (perf_smon_cfg_write_q[8])
        ,.in_smon_cfg9_write    (perf_smon_cfg_write_q[9])

        ,.in_smon_cfg_wdata     (smon_cfg_wdata_q)

        ,.out_smon_cfg0_data    (perf_smon_cfg_rdata[0])
        ,.out_smon_cfg1_data    (perf_smon_cfg_rdata[1])
        ,.out_smon_cfg2_data    (perf_smon_cfg_rdata[2])
        ,.out_smon_cfg3_data    (perf_smon_cfg_rdata[3])
        ,.out_smon_cfg4_data    (perf_smon_cfg_rdata[4])
        ,.out_smon_cfg5_data    (perf_smon_cfg_rdata[5])
        ,.out_smon_cfg6_data    (perf_smon_cfg_rdata[6])
        ,.out_smon_cfg7_data    (perf_smon_cfg_rdata[7])
        ,.out_smon_cfg8_data    (perf_smon_cfg_rdata[8])
        ,.out_smon_cfg9_data    (perf_smon_cfg_rdata[9])

        ,.in_mon_v              (perf_smon_v)
        ,.in_mon_comp           (perf_smon_comp)
        ,.in_mon_val            (perf_smon_val)

        ,.out_smon_interrupt    (out_smon_interrupt_nc[2])
        ,.out_smon_enabled      (smon_enabled[2])
);

//-----------------------------------------------------------------------------------------------------

//TBD: Update visa
assign hqm_system_visa = { ingress_alarm.is_ldb_port                             //I: VISA 29
                          ,ingress_alarm.is_pf                                   //I: VISA 28
                          ,ingress_alarm.vdev                                    //I: VISA 27:24

                          ,ingress_alarm_v                                       //I: VISA 23
                          ,ingress_alarm_v                                       //I: VISA 22
                          ,ingress_alarm.aid                                     //I: VISA 21:16

                          ,ims_msix_w_v                                          //I: VISA 15
                          ,ims_msix_w.ai                                         //I: VISA 14
                          ,ims_msix_w.poll                                       //I: VISA 13
                          ,ims_msix_w.cq_ldb                                     //I: VISA 12
                          ,ims_msix_w.cq_v                                       //I: VISA 11
                          ,ims_msix_w.cq[0]                                      //I: VISA 10
                          ,ims_msix_w.tc_sel[1:0]                                //I: VISA 9:8

                          ,system_idle_q                                         //I: VISA 7
                          ,system_local_idle_q                                   //I: VISA 6
                          ,sys_idle_status_reg.INT_IDLE                          //I: VISA 5
                          ,sys_idle_status_reg.ALARM_IDLE                        //I: VISA 4
                          ,1'b0                                                  //I: VISA 3
                          ,sys_idle_status_reg.WBUF_IDLE                         //I: VISA 2
                          ,sys_idle_status_reg.EGRESS_IDLE                       //I: VISA 1
                          ,sys_idle_status_reg.INGRESS_IDLE                      //I: VISA 0
                          };

//-----------------------------------------------------------------------------------------------------
// Spares

hqm_AW_spare_ports i_spare_ports_lsp (

     .clk                       (hqm_inp_gated_clk)
    ,.rst_n                     (hqm_inp_gated_rst_b_sys)
    ,.spare_in                  (spare_lsp_sys)
    ,.spare_out                 (spare_sys_lsp)
);

hqm_AW_spare_ports i_spare_ports_qed (

     .clk                       (hqm_inp_gated_clk)
    ,.rst_n                     (hqm_inp_gated_rst_b_sys)
    ,.spare_in                  (spare_qed_sys)
    ,.spare_out                 (spare_sys_qed)
);

//-----------------------------------------------------------------------------------------------------
// Be able to artificially drive CQ occupancy interrupt interface

// VCS coverage off

`ifdef INTEL_INST_ON
 `ifndef INTEL_EMULATION

 logic                          test_interrupt;
 logic                          test_cwdi;
 logic                          test_interrupt_w_req_valid;
 interrupt_w_req_t              test_interrupt_w_req;
 logic                          test_cnt_run;
 logic  [7:0]                   test_cnt_next;
 logic  [7:0]                   test_cnt_q;
 logic  [1:0]                   test_wdv_q;

 initial begin
  test_interrupt='0; if ($test$plusargs("HQM_SYSTEM_TEST_INTERRUPT")) test_interrupt='1;
  test_cwdi='0; if ($test$plusargs("HQM_SYSTEM_TEST_CWDI")) test_cwdi='1;
 end

 assign test_cnt_run = pci_cfg_pmsixctl_msie_q;

 assign test_cnt_next = (test_cnt_run & interrupt_w_req_ready_i & ~(|test_wdv_q) & (test_cnt_q < 8'h80)) ?
  (test_cnt_q+8'd1) : ((test_cnt_run) ? test_cnt_q : '0);

 always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
  if (~hqm_inp_gated_rst_n) begin
   test_cnt_q <= '0;
   test_wdv_q <= '0;
  end else begin
   test_cnt_q <= test_cnt_next;
   test_wdv_q <= {test_interrupt_w_req_valid, test_wdv_q[1]};
  end
 end

 assign test_interrupt_w_req_valid     = test_cnt_run & ~(|test_wdv_q) & (test_cnt_q < 8'h80);
 assign test_interrupt_w_req.is_ldb    = test_cnt_q[6];
 assign test_interrupt_w_req.cq_occ_cq = {1'b0, test_cnt_q[5:0]};
 assign test_interrupt_w_req.parity    = ~(^test_cnt_q[6:0]);

 `endif
`endif

assign {interrupt_w_req_valid_i, interrupt_w_req_i, interrupt_w_req_ready} =
`ifdef INTEL_INST_ON
 `ifndef INTEL_EMULATION
 (test_interrupt) ? {test_interrupt_w_req_valid, test_interrupt_w_req, 1'b1} :
 `endif
`endif
 {interrupt_w_req_valid, interrupt_w_req, interrupt_w_req_ready_i};

assign {cwdi_interrupt_w_req_valid_i, cwdi_interrupt_w_req_ready} =
`ifdef INTEL_INST_ON
 `ifndef INTEL_EMULATION
 (test_cwdi) ? {test_interrupt_w_req_valid, 1'b1} :
 `endif
`endif
 {cwdi_interrupt_w_req_valid, cwdi_interrupt_w_req_ready_i};

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

    // Synchronizer validation controls

    logic [31:0] metastability_seed;
    logic        en_metastability_testing;

    initial begin
      metastability_seed       = '0;
      en_metastability_testing = '0;
    end

`endif

// VCS coverage on

endmodule // hqm_system_core
