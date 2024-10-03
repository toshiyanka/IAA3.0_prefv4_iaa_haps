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

module hqm_system

     import
// collage-pragma translate_off
            hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_msix_mem_pkg::*,
// collage-pragma translate_on
            hqm_sif_pkg::*, hqm_AW_pkg::*, hqm_pkg::*;
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
    ,input  logic [BITS_HCW_ENQ_IN_DATA_T-1:0]      hcw_enq_in_data

    //---------------------------------------------------------------------------------------------
    // SIF Non-Posted interface

    ,input  logic                                   write_buffer_mstr_ready

    ,output logic                                   write_buffer_mstr_v
    ,output logic [BITS_WRITE_BUFFER_MSTR_T-1:0]    write_buffer_mstr

    //---------------------------------------------------------------------------------------------
    // SIF Alarm Interrupt interface

    ,output logic                                   sif_alarm_ready

    ,input  logic                                   sif_alarm_v
    ,input  logic [BITS_AW_ALARM_T-1:0]             sif_alarm_data

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
    ,input  logic [BITS_CFG_REQ_T-1:0]              system_cfg_req_up

    ,output logic                                   system_cfg_req_down_write
    ,output logic                                   system_cfg_req_down_read
    ,output logic [BITS_CFG_REQ_T-1:0]              system_cfg_req_down
    ,output logic                                   system_cfg_rsp_down_ack
    ,output logic [BITS_CFG_RSP_T-1:0]              system_cfg_rsp_down

    //---------------------------------------------------------------------------------------------
    // Core Alarm Interrupt interface

    ,output logic                                   hqm_alarm_ready

    ,input  logic                                   hqm_alarm_v
    ,input  logic [BITS_AW_ALARM_T-1:0]             hqm_alarm_data

    //---------------------------------------------------------------------------------------------
    // Core HCW Enqueue interface

    ,input  logic                                   hcw_enq_w_req_ready

    ,output logic                                   hcw_enq_w_req_valid
    ,output logic [BITS_HCW_ENQ_W_REQ_T-1:0]        hcw_enq_w_req

    //---------------------------------------------------------------------------------------------
    // Core HCW Schedule interface

    ,output logic                                   hcw_sched_w_req_ready

    ,input  logic                                   hcw_sched_w_req_valid
    ,input  logic [BITS_HCW_SCHED_W_REQ_T-1:0]      hcw_sched_w_req

    //---------------------------------------------------------------------------------------------
    // Core CQ occupany interrupt interface

    ,output logic                                   interrupt_w_req_ready

    ,input  logic                                   interrupt_w_req_valid
    ,input  logic [BITS_INTERRUPT_W_REQ_T-1:0]      interrupt_w_req

    //---------------------------------------------------------------------------------------------
    // Core Watchdog interrupt interface

    ,output logic                                   cwdi_interrupt_w_req_ready

    ,input  logic                                   cwdi_interrupt_w_req_valid

    //---------------------------------------------------------------------------------------------
    // DFX interface

    ,input  logic                                   fscan_rstbypen
    ,input  logic                                   fscan_byprst_b

    //---------------------------------------------------------------------------------------------
    // Visa interface

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


// collage-pragma translate_off


`ifndef HQM_VISA_ELABORATE

hqm_system_core i_hqm_system_core (.*);

`endif

// collage-pragma translate_on

endmodule // hqm_system

