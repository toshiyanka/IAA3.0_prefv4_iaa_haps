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

module hqm_system_alarm

         import hqm_AW_pkg::*, hqm_sif_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_system_type_pkg::*;
#(
         parameter NUM_INF      = 1
        ,parameter NUM_COR      = 1
        ,parameter NUM_UNC      = 1
        ,parameter UNIT_WIDTH   = 4
) (
         input  logic                                   prim_gated_clk
        ,input  logic                                   prim_gated_rst_n

        ,input  logic                                   hqm_gated_clk
        ,input  logic                                   hqm_gated_rst_n

        ,input  logic                                   hqm_inp_gated_clk
        ,input  logic                                   hqm_inp_gated_rst_n

        ,input  logic                                   rx_sync_cwd_interrupt_enable
        ,input  logic                                   rx_sync_hqm_alarm_enable
        ,input  logic                                   sif_alarm_fifo_enable

        ,output logic                                   rx_sync_cwd_interrupt_idle
        ,output logic                                   rx_sync_hqm_alarm_idle
        ,output logic                                   sif_alarm_fifo_idle
        ,output logic                                   pba_idle
        ,output logic                                   int_idle

        ,input  logic                                   rst_prep

        ,output logic                                   rst_done

        //---------------------------------------------------------------------------------------------
        // CFG interface

        ,input  hqm_system_alarm_cfg_signal_t           cfg_re
        ,input  hqm_system_alarm_cfg_signal_t           cfg_we
        ,input  logic   [6:0]                           cfg_addr
        ,input  logic   [7:0]                           cfg_addr_msix
        ,input  logic   [31:0]                          cfg_wdata
        ,input  logic   [31:0]                          cfg_wdata_msix
                                                       
        ,output hqm_system_alarm_cfg_signal_t           cfg_rvalid
        ,output hqm_system_alarm_cfg_signal_t           cfg_wvalid
        ,output hqm_system_alarm_cfg_signal_t           cfg_error
        ,output logic   [31:0]                          cfg_rdata
                                                       
        ,input  logic                                   cfg_parity_off
        ,input  logic                                   cfg_write_bad_parity
        ,input  logic                                   cfg_inj_par_err_vf_synd
        ,input  SYS_ALARM_INT_ENABLE_t                  cfg_sys_alarm_int_enable
        ,input  SYS_ALARM_SB_ECC_INT_ENABLE_t           cfg_sys_alarm_sb_ecc_int_enable
        ,input  SYS_ALARM_MB_ECC_INT_ENABLE_t           cfg_sys_alarm_mb_ecc_int_enable
        ,input  ALARM_CTL_t                             cfg_alarm_ctl
        ,input  logic   [HQM_SYSTEM_NUM_MSIX-1:0]       cfg_msix_pba_clear
                                                       
        ,input  AL_IMS_MSIX_DB_AGITATE_CONTROL_t        al_ims_msix_db_agitate_control
        ,input  AL_CWD_ALARM_DB_AGITATE_CONTROL_t       al_cwd_alarm_db_agitate_control
        ,input  AL_HQM_ALARM_DB_AGITATE_CONTROL_t       al_hqm_alarm_db_agitate_control
        ,input  AL_SIF_ALARM_AFULL_AGITATE_CONTROL_t    al_sif_alarm_afull_agitate_control
                                                       
        ,output load_MSIX_ACK_t                         set_msix_ack
        ,output load_DIR_CQ_63_32_OCC_INT_STATUS_t      set_dir_cq_63_32_occ_int_status
        ,output load_DIR_CQ_31_0_OCC_INT_STATUS_t       set_dir_cq_31_0_occ_int_status
        ,output load_LDB_CQ_63_32_OCC_INT_STATUS_t      set_ldb_cq_63_32_occ_int_status
        ,output load_LDB_CQ_31_0_OCC_INT_STATUS_t       set_ldb_cq_31_0_occ_int_status
                                                       
        ,input  MSIX_ACK_t                              msix_ack
        ,input  MSIX_PASSTHROUGH_t                      msix_passthrough
        ,input  MSIX_MODE_t                             msix_mode
        ,input  DIR_CQ_63_32_OCC_INT_STATUS_t           dir_cq_63_32_occ_int_status
        ,input  DIR_CQ_31_0_OCC_INT_STATUS_t            dir_cq_31_0_occ_int_status
        ,input  LDB_CQ_63_32_OCC_INT_STATUS_t           ldb_cq_63_32_occ_int_status
        ,input  LDB_CQ_31_0_OCC_INT_STATUS_t            ldb_cq_31_0_occ_int_status
                                                       
        ,output logic                                   alarm_int_error
        ,output logic   [12:0]                          alarm_lut_perr
        ,output logic                                   alarm_perr
                                                       
        ,output logic   [6:0]                           sys_alarm_db_status
        ,output logic   [6:0]                           ims_msix_db_status

        ,output aw_fifo_status_t                        cwdi_rx_fifo_status
        ,output aw_fifo_status_t                        hqm_alarm_rx_fifo_status
        ,output aw_fifo_status_t                        sif_alarm_fifo_status

        ,input  logic                                   cfg_sif_alarm_fifo_high_wm
                                                       
        ,output new_ALARM_STATUS_t                      alarm_status

        ,output logic   [HQM_SYSTEM_NUM_MSIX-1:0]       msix_synd

        //---------------------------------------------------------------------------------------------
        // Internal error indications to ri_err

        ,output logic                                   iecor_error
        ,output logic                                   ieunc_error

        //---------------------------------------------------------------------------------------------
        // Idle interface

        ,input  SYS_IDLE_STATUS_t                       sys_idle_status_reg

        ,output logic                                   alarm_idle
        ,output logic                                   system_local_idle

        //---------------------------------------------------------------------------------------------
        // SIF interface

        // Vectored CSR Control Signals

        ,input  logic                                   pci_cfg_pmsixctl_msie           // Control output for MSIX enable
        ,input  logic                                   pci_cfg_pmsixctl_fm             // MSIX per function mask

        // MSIX pending bits

        ,output logic   [HQM_SYSTEM_NUM_MSIX-1:0]       msix_pba

        //---------------------------------------------------------------------------------------------
        // System Alarm Interrupt interface

        ,input  logic   [UNIT_WIDTH-1:0]                sys_unit

        ,input  logic   [NUM_INF-1:0]                   sys_alarm_inf_v
        ,input  aw_alarm_syn_t  [NUM_INF-1:0]           sys_alarm_inf_data

        ,input  logic   [NUM_COR-1:0]                   sys_alarm_cor_v
        ,input  aw_alarm_syn_t  [NUM_COR-1:0]           sys_alarm_cor_data

        ,input  logic   [NUM_UNC-1:0]                   sys_alarm_unc_v
        ,input  aw_alarm_syn_t  [NUM_UNC-1:0]           sys_alarm_unc_data

        //---------------------------------------------------------------------------------------------
        // Core Alarm Interrupt interface

        ,output logic                                   hqm_alarm_ready

        ,input  logic                                   hqm_alarm_v
        ,input  aw_alarm_t                              hqm_alarm_data

        //---------------------------------------------------------------------------------------------
        // SIF Alarm Interrupt interface

        ,output logic                                   sif_alarm_ready

        ,input  logic                                   sif_alarm_v
        ,input  aw_alarm_t                              sif_alarm_data

        ,output logic                                   sif_alarm_fifo_pop
        ,output aw_alarm_t                              sif_alarm_fifo_pop_data

        //---------------------------------------------------------------------------------------------
        // CQ occupancy interrupt interface from write buffer

        ,output logic                                   cq_occ_int_busy

        ,input  logic                                   cq_occ_int_v
        ,input  interrupt_w_req_t                       cq_occ_int

        //---------------------------------------------------------------------------------------------
        // Watchdog interrupt interface

        ,output logic                                   cwdi_interrupt_w_req_ready

        ,input  logic                                   cwdi_interrupt_w_req_valid

        //---------------------------------------------------------------------------------------------
        // Ingress alarm interface

        ,input logic                                    ingress_alarm_v
        ,input hqm_system_ingress_alarm_t               ingress_alarm

        //---------------------------------------------------------------------------------------------
        // IMS/MSI-X write interface to write buffer

        ,input  logic                                   ims_msix_w_ready
                                                     
        ,output logic                                   ims_msix_w_v
        ,output hqm_system_ims_msix_w_t                 ims_msix_w

        //---------------------------------------------------------------------------------------------
        // IMS pending and mask

        ,output logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]     ims_pend
        ,input  logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]     ims_mask
        ,input  IMS_PEND_CLEAR_t                        ims_pend_clear

        //---------------------------------------------------------------------------------------------
        // Memory interface

        ,output hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word0
        ,input  hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word0
                                                     
        ,output hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word1
        ,input  hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word1
                                                     
        ,output hqm_system_memi_msix_tbl_word_t         memi_msix_tbl_word2
        ,input  hqm_system_memo_msix_tbl_word_t         memo_msix_tbl_word2
                                                     
        ,output hqm_system_memi_lut_dir_cq_isr_t        memi_lut_dir_cq_isr
        ,input  hqm_system_memo_lut_dir_cq_isr_t        memo_lut_dir_cq_isr
                                                     
        ,output hqm_system_memi_lut_ldb_cq_isr_t        memi_lut_ldb_cq_isr
        ,input  hqm_system_memo_lut_ldb_cq_isr_t        memo_lut_ldb_cq_isr

        ,output hqm_system_memi_lut_dir_cq_ai_addr_l_t  memi_lut_dir_cq_ai_addr_l
        ,input  hqm_system_memo_lut_dir_cq_ai_addr_l_t  memo_lut_dir_cq_ai_addr_l

        ,output hqm_system_memi_lut_ldb_cq_ai_addr_l_t  memi_lut_ldb_cq_ai_addr_l
        ,input  hqm_system_memo_lut_ldb_cq_ai_addr_l_t  memo_lut_ldb_cq_ai_addr_l

        ,output hqm_system_memi_lut_dir_cq_ai_addr_u_t  memi_lut_dir_cq_ai_addr_u
        ,input  hqm_system_memo_lut_dir_cq_ai_addr_u_t  memo_lut_dir_cq_ai_addr_u

        ,output hqm_system_memi_lut_ldb_cq_ai_addr_u_t  memi_lut_ldb_cq_ai_addr_u
        ,input  hqm_system_memo_lut_ldb_cq_ai_addr_u_t  memo_lut_ldb_cq_ai_addr_u

        ,output hqm_system_memi_lut_dir_cq_ai_data_t    memi_lut_dir_cq_ai_data
        ,input  hqm_system_memo_lut_dir_cq_ai_data_t    memo_lut_dir_cq_ai_data

        ,output hqm_system_memi_lut_ldb_cq_ai_data_t    memi_lut_ldb_cq_ai_data
        ,input  hqm_system_memo_lut_ldb_cq_ai_data_t    memo_lut_ldb_cq_ai_data

        ,output hqm_system_memi_alarm_vf_synd0_t        memi_alarm_vf_synd0
        ,input  hqm_system_memo_alarm_vf_synd0_t        memo_alarm_vf_synd0
                                                     
        ,output hqm_system_memi_alarm_vf_synd1_t        memi_alarm_vf_synd1
        ,input  hqm_system_memo_alarm_vf_synd1_t        memo_alarm_vf_synd1
                                                     
        ,output hqm_system_memi_alarm_vf_synd2_t        memi_alarm_vf_synd2
        ,input  hqm_system_memo_alarm_vf_synd2_t        memo_alarm_vf_synd2
);

localparam CQ_OCC_CQ_WIDTH = $bits(cq_occ_int.cq_occ_cq);
localparam CQ_OCC_NUM_CQS  = 1 << CQ_OCC_CQ_WIDTH;
localparam AI_VEC_WIDTH    = AW_logb2(NUM_DIR_CQ+NUM_LDB_CQ-1)+1;

//-----------------------------------------------------------------------------------------------------
                                                    
logic   [3:0]                                       init_q;
logic   [12:0]                                      init_done;
logic                                               init_done_q;
logic                                               init_in_progress;
logic   [7:0]                                       init_addr;

logic                                               cfg_write_bad_parity_q;

hqm_system_alarm_cfg_signal_t                       cfg_re_next;
hqm_system_alarm_cfg_signal_t                       cfg_re_q;
hqm_system_alarm_cfg_signal_t                       cfg_re_v;
hqm_system_alarm_cfg_signal_t                       cfg_we_next;
hqm_system_alarm_cfg_signal_t                       cfg_we_q;
hqm_system_alarm_cfg_signal_t                       cfg_we_v;
logic   [7:0]                                       cfg_addr_q;
logic   [7:0]                                       cfg_addr_ldb;

logic                                               cfg_addr_q_dir_cq;
logic                                               cfg_addr_q_ldb_cq;
               
logic                                               cfg_re_dir_cq_ai_addr_l;
logic                                               cfg_re_ldb_cq_ai_addr_l;
logic                                               cfg_we_dir_cq_ai_addr_l;
logic                                               cfg_we_ldb_cq_ai_addr_l;
logic                                               cfg_re_dir_cq_ai_addr_u;
logic                                               cfg_re_ldb_cq_ai_addr_u;
logic                                               cfg_we_dir_cq_ai_addr_u;
logic                                               cfg_we_ldb_cq_ai_addr_u;
logic                                               cfg_re_dir_cq_ai_data;
logic                                               cfg_re_ldb_cq_ai_data;
logic                                               cfg_we_dir_cq_ai_data;
logic                                               cfg_we_ldb_cq_ai_data;

logic   [31:0]                                      cfg_wdata_q;
logic                                               cfg_taken_next;
logic                                               cfg_taken_q;
logic                                               cfg_taken_lut;
logic                                               cfg_taken_msix;
logic                                               cfg_taken_ai;
                                                    
logic                                               cfg_re_in_lut;
logic                                               cfg_we_in_lut;
logic                                               cfg_re_in_msix;
logic                                               cfg_we_in_msix;
logic                                               cfg_re_in_ai;
logic                                               cfg_we_in_ai;
                                                    
hqm_system_alarm_cfg_data_t                         cfg_rdata_lut;
logic   [31:0]                                      cfg_rdata_next;
logic   [31:0]                                      cfg_rdata_q;
logic                                               cfg_rvalid_next;
logic                                               cfg_wvalid_next;
logic                                               cfg_rvalid_q;
logic                                               cfg_wvalid_q;
logic                                               cfg_error_q;
                                                    
logic                                               hqm_alarm_db_ready;
logic                                               hqm_alarm_db_v;
logic                                               agg_hqm_alarm_db_ready;
logic                                               agg_hqm_alarm_db_v;
logic                                               hqm_alarm_db_valid;
aw_alarm_t                                          hqm_alarm_db_data;
logic   [3:0]                                       hqm_alarm_db_base;

logic                                               sif_alarm_v_q;
aw_alarm_t                                          sif_alarm_data_q;
                                                    
logic                                               sif_alarm_fifo_push;
aw_alarm_t                                          sif_alarm_fifo_push_data;
logic                                               sif_alarm_fifo_push_empty;
logic   [3:0]                                       sif_alarm_fifo_pop_data_base;
logic                                               sif_alarm_fifo_pop_data_v;
logic                                               sif_alarm_fifo_afull_raw;
logic                                               sif_alarm_fifo_afull;
logic                                               sif_alarm_fifo_valid;
                                                    
logic                                               sys_alarm_db_ready;
logic                                               sys_alarm_db_v;
logic                                               sys_alarm_db_valid;
aw_alarm_t                                          sys_alarm_db_data;
logic   [31:0]                                      sys_alarm_is_status;
logic   [3:0]                                       sys_alarm_db_base;

logic                                               cwd_alarm_db_ready;
logic                                               cwd_alarm_db_v;
logic                                               agg_cwd_alarm_db_ready;
logic                                               agg_cwd_alarm_db_v;
logic                                               cwd_alarm_db_valid;

logic   [7:0]                                       ingress_alarm_vpp_scaled;

logic   [2:0]                                       alarm_mask_next;
logic   [2:0]                                       alarm_mask_q;
logic                                               alarm_reqs_next;
logic                                               alarm_reqs_q;

logic                                               alarm_hw_synd_v_next;
logic                                               alarm_hw_synd_v_q;
logic                                               alarm_hw_synd_more_next;
logic                                               alarm_hw_synd_more_q;
logic   [29:0]                                      alarm_hw_synd_next;
logic   [29:0]                                      alarm_hw_synd_q;

logic                                               alarm_pf_synd_v_next;
logic                                               alarm_pf_synd_v_q;
logic                                               alarm_pf_synd_more_next;
logic                                               alarm_pf_synd_more_q;
logic   [93:0]                                      alarm_pf_synd_next;
logic   [93:0]                                      alarm_pf_synd_q;

logic   [NUM_VDEV-1:0]                              alarm_vf_synd_v_next;
logic   [NUM_VDEV-1:0]                              alarm_vf_synd_v_q;
logic   [NUM_VDEV-1:0]                              alarm_vf_synd_more_next;
logic   [NUM_VDEV-1:0]                              alarm_vf_synd_more_q;

hqm_system_memi_alarm_vf_synd0_t                    alarm_vf_synd0_next;
hqm_system_memi_alarm_vf_synd0_t                    alarm_vf_synd0_q;
hqm_system_memi_alarm_vf_synd1_t                    alarm_vf_synd1_next;
hqm_system_memi_alarm_vf_synd1_t                    alarm_vf_synd1_q;
hqm_system_memi_alarm_vf_synd2_t                    alarm_vf_synd2_next;
hqm_system_memi_alarm_vf_synd2_t                    alarm_vf_synd2_q;

logic   [31:0]                                      alarm_synd_rdata_next;
logic   [31:0]                                      alarm_synd_rdata_q;

logic   [2:1]                                       alarm_synd21_par_next;
logic   [2:1]                                       alarm_synd21_par_q;

logic                                               p0_hold;
logic                                               p0_load;
logic                                               p0_v_next;
logic                                               p0_v_q;
logic                                               p0_cfg_next;
logic                                               p0_cfg_q;
logic                                               p0_cfg_we_q;
interrupt_w_req_t                                   p0_data_q;
                                                    
logic                                               p1_hold;
logic                                               p1_load;
logic                                               p1_v_q;
logic                                               p1_cfg_q;
logic                                               p1_cfg_we_q;
interrupt_w_req_t                                   p1_data_q;
                                                    
logic                                               p2_hold;
logic                                               p2_load;
logic                                               p2_v_q;
logic                                               p2_v;
logic                                               p2_cfg_q;
logic   [1:0]                                       p2_cfg_we_q;
interrupt_w_req_t                                   p2_data_q;
logic   [1:0]                                       p2_int_code_dir;
logic   [1:0]                                       p2_int_code_ldb;
logic   [1:0]                                       p2_int_code;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   p2_int_vf_dir;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   p2_int_vf_ldb;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   p2_int_vf;
logic   [5:0]                                       p2_int_vec_dir;
logic   [5:0]                                       p2_int_vec_ldb;
logic   [5:0]                                       p2_int_vec;
logic   [6:0]                                       p2_int_vec_p1;
logic                                               p2_perr;

logic                                               p3_hold;
logic                                               p3_perr_q;
                                                    
logic   [11:0]                                      lut_perr;
logic   [12:0]                                      lut_perr_next;
logic   [12:0]                                      lut_perr_q;
logic                                               perr_next;
logic                                               perr_q;

logic                                               cq_occ_int_valid;
                                                    
logic                                               cq_occ_inta_req;
logic                                               cq_occ_msix_req;
logic                                               cq_occ_msix_req_q;
logic                                               cq_occ_msix_mask;
logic                                               cq_occ_msix_v;
logic                                               cq_occ_msix_setp;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       cq_occ_msix_vec;
logic                                               cq_occ_msix_push_req;
logic   [(1<<HQM_SYSTEM_CQ_WIDTH)-1:0]              cq_occ_decode_next;
logic   [HQM_SYSTEM_NUM_CQ-1:0]                     cq_occ_decode_q;
logic                                               cq_occ_is_ldb_q;
logic   [1:0]                                       cq_occ_ack_q;

logic                                               alarm_msix_req;
logic                                               alarm_msix_mask;
logic                                               alarm_msix_v;
logic                                               alarm_msix_setp;

logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_pba_v;
logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_pba_next;
logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_pba_q;
logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_pba_ldb_next;
logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_pba_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_pba_cq_next[(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_pba_cq_q[HQM_SYSTEM_NUM_MSIX-1:0];

logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_arb_reqs_next;
logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_arb_reqs_q;
logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_arb_ldb_next;
logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_arb_ldb_q;
logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_arb_ldb_scaled;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_arb_cq_next[(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_arb_cq_q[HQM_SYSTEM_NUM_MSIX-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_arb_cq_scaled[(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0];
logic                                               msix_arb_update;
logic                                               msix_arb_winner_v;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       msix_arb_winner;

logic                                               msix_tbl_req;
logic                                               msix_tbl_ack;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       msix_tbl_vec;
logic                                               msix_tbl_ldb;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_tbl_cq;
logic   [(2*HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)-1:0]   msix_tbl_rdata_addr;
logic   [HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD-1:0]       msix_tbl_rdata_data;
logic                                               msix_tbl_rdata_mask;
logic                                               msix_tbl_hold;
                                                    
logic                                               msix_p0_hold;
logic                                               msix_p0_load;
logic                                               msix_p0_v_next;
logic                                               msix_p0_v_q;
logic                                               msix_p0_cfg_next;
logic                                               msix_p0_cfg_q;
logic                                               msix_p0_cfg_we_q;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       msix_p0_vec_q;
logic                                               msix_p0_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_p0_cq_q;
                                                    
logic                                               msix_p1_hold;
logic                                               msix_p1_load;
logic                                               msix_p1_v_q;
logic                                               msix_p1_cfg_q;
logic                                               msix_p1_cfg_we_q;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       msix_p1_vec_q;
logic                                               msix_p1_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_p1_cq_q;
                                                    
logic                                               msix_p2_hold;
logic                                               msix_p2_load;
logic                                               msix_p2_v_q;
logic                                               msix_p2_v;
logic                                               msix_p2_cfg_q;
logic   [1:0]                                       msix_p2_cfg_we_q;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       msix_p2_vec_q;
logic                                               msix_p2_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   msix_p2_cq_q;

logic   [1:0]                                       set_msix_ack_next;
load_MSIX_ACK_t                                     set_msix_ack_q;

hqm_system_memi_msix_tbl_word3_t                    memi_msix_tbl_word3;
hqm_system_memo_msix_tbl_word3_t                    memo_msix_tbl_word3;

logic   [((HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3 + HQM_SYSTEM_PACK_MSIX_TBL_WORD3 - 1)/
          HQM_SYSTEM_PACK_MSIX_TBL_WORD3)-1:0]
        [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1:0]     msix_tbl_mask_q;
logic   [HQM_SYSTEM_NUM_MSIX-1:0]                   msix_tbl_mask;
logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_tbl_mask_scaled;

logic                                               func_arb_update;
logic   [1:0]                                       func_arb_reqs;
logic                                               func_arb_winner_v;
logic                                               func_arb_winner;
logic   [1:0]                                       func_arb_winner_dec;
logic   [63:2]                                      func_arb_addr[1:0];
logic   [1:0]                                       func_arb_addr_res[1:0];
logic   [31:0]                                      func_arb_data[1:0];
logic                                               func_arb_data_par[1:0];

logic                                               ims_msix_ready;
logic                                               ims_msix_v;
logic                                               agg_ims_msix_ready;
logic                                               agg_ims_msix_v;
hqm_system_ims_msix_w_t                             ims_msix;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       ims_msix_vec;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       ims_msix_w_vec;

logic                                               ims_msix_synd_pf_v_next;
logic                                               ims_msix_synd_pf_v_q;
logic   [HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0]       ims_msix_synd_vec_q;

logic   [(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:0]  msix_synd_scaled;

logic                                               alarm_idle_next;
logic                                               alarm_idle_q;
logic                                               system_local_idle_next;
logic                                               system_local_idle_q;
logic                                               pba_idle_next;
logic                                               pba_idle_q;

logic                                               sys_alarm_int_enable;

logic   [63:0]                                      cfg_mb_ecc_int_enable;
logic   [63:0]                                      cfg_sb_ecc_int_enable;
logic   [63:0]                                      cfg_alarm_int_enable;
logic   [5:0]                                       sys_alarm_db_aid_mmb;

logic                                               enable_msix_ack_dec;

logic                                               sbe_in;
logic   [1:0]                                       sbe_inc_q;
logic   [31:0]                                      sbe_cnt_ls_p1;
logic   [31:0]                                      sbe_cnt_ms_p1;
logic   [63:0]                                      sbe_cnt_q;

logic                                               rst_done_q;

logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_arb_reqs_next;
logic   [NUM_DIR_CQ+NUM_LDB_CQ-1:0]                 ai_arb_reqs_q;
logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_arb_ldb_next;
logic   [NUM_DIR_CQ+NUM_LDB_CQ-1:0]                 ai_arb_ldb_q;
logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_arb_ldb_scaled;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_arb_cq_next[(1<<AI_VEC_WIDTH)-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_arb_cq_q[NUM_DIR_CQ+NUM_LDB_CQ-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_arb_cq_scaled[(1<<AI_VEC_WIDTH)-1:0];
logic                                               ai_arb_update;
logic                                               ai_arb_winner_v;
logic   [AI_VEC_WIDTH-1:0]                          ai_arb_winner;
logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_mask_scaled;

logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_pend_next;
logic   [NUM_DIR_CQ+NUM_LDB_CQ-1:0]                 ai_pend_q;
logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_pend_ldb_next;
logic   [NUM_DIR_CQ+NUM_LDB_CQ-1:0]                 ai_pend_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_pend_cq_next[(1<<AI_VEC_WIDTH)-1:0];
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_pend_cq_q[NUM_DIR_CQ+NUM_LDB_CQ-1:0];
logic   [NUM_DIR_CQ+NUM_LDB_CQ-1:0]                 ai_pend_v;
logic   [(1<<AI_VEC_WIDTH)-1:0]                     ai_pend_clear;
logic   [AI_VEC_WIDTH-1:0]                          ai_int_vec;

logic                                               ai_tbl_req;
logic                                               ai_tbl_ack;
logic                                               ai_tbl_hold;
logic   [AI_VEC_WIDTH-1:0]                          ai_tbl_vec;
logic   [AI_VEC_WIDTH-1:0]                          ai_tbl_vec_ldb;
logic                                               ai_tbl_dir;
logic                                               ai_tbl_ldb;
                                                    
logic                                               ai_p0_hold;
logic                                               ai_p0_load;
logic                                               ai_p0_v_next;
logic                                               ai_p0_v_q;
logic                                               ai_p0_cfg_next;
logic                                               ai_p0_cfg_q;
logic                                               ai_p0_cfg_we_q;
logic   [AI_VEC_WIDTH-1:0]                          ai_p0_vec_q;
logic                                               ai_p0_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_p0_cq_q;
                                                    
logic                                               ai_p1_hold;
logic                                               ai_p1_load;
logic                                               ai_p1_v_q;
logic                                               ai_p1_cfg_q;
logic                                               ai_p1_cfg_we_q;
logic   [AI_VEC_WIDTH-1:0]                          ai_p1_vec_q;
logic                                               ai_p1_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_p1_cq_q;
                                                    
logic                                               ai_p2_hold;
logic                                               ai_p2_load;
logic                                               ai_p2_v_q;
logic                                               ai_p2_v;
logic                                               ai_p2_cfg_q;
logic   [1:0]                                       ai_p2_cfg_we_q;
logic   [AI_VEC_WIDTH-1:0]                          ai_p2_vec_q;
logic                                               ai_p2_ldb_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   ai_p2_cq_q;

logic   [63:2]                                      ai_p2_addr_dir;
logic   [63:2]                                      ai_p2_addr_ldb;
logic   [63:2]                                      ai_p2_addr;
logic   [31:0]                                      ai_p2_data_dir;
logic   [31:0]                                      ai_p2_data_ldb;
logic   [31:0]                                      ai_p2_data;

logic                                               ims_poll_mode;

hqm_system_memi_msix_tbl_word_t                     memi_msix_tbl_word0i;
hqm_system_memo_msix_tbl_word_t                     memo_msix_tbl_word0i;
                                     
hqm_system_memi_msix_tbl_word_t                     memi_msix_tbl_word1i;
hqm_system_memo_msix_tbl_word_t                     memo_msix_tbl_word1i;
                                     
hqm_system_memi_msix_tbl_word_t                     memi_msix_tbl_word2i;
hqm_system_memo_msix_tbl_word_t                     memo_msix_tbl_word2i;

logic                                               cfg_inj_par_err_q;
logic                                               cfg_inj_par_err_last_q;
logic  [2:0]                                        cfg_read_vf_synd;
logic                                               vf_synd_perr;
logic  [2:1]                                        cfg_vf_par_q;

// Since the RDL will now produce a cfg_rdata_lut with only one field instead of 2 for these structures
// also need new signals to hold the other version of the cfg_rdata.

logic   [31:0]                                      cfg_rdata_lut_ai_addr_l_ldb;
logic   [31:0]                                      cfg_rdata_lut_ai_addr_u_ldb;
logic   [31:0]                                      cfg_rdata_lut_ai_data_ldb;

genvar                                              g;

//-----------------------------------------------------------------------------------------------------
// Decode cfg access to individual memories here

assign cfg_re_next    = cfg_re & ~cfg_rvalid;
assign cfg_we_next    = cfg_we & ~cfg_wvalid;
assign cfg_taken_next = (|{cfg_taken_q, cfg_taken_lut, cfg_taken_msix, cfg_taken_ai}) & ~(cfg_rvalid_q | cfg_wvalid_q);

// Need to mux between the 2 separate CFG interfaces here for addr and wdata.

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  init_q      <= '0;
  init_done_q <= '0;
  rst_done_q  <= '0;
  cfg_re_q    <= '0;
  cfg_we_q    <= '0;
  cfg_taken_q <= '0;
  cfg_addr_q  <= '0;
 end else begin
  init_q      <= {1'b1, init_q[3:1]};
  init_done_q <= init_done_q | (&cfg_addr_q[3:0]);
  rst_done_q  <= (&init_done);
  if (rst_done_q) begin
   cfg_re_q   <= cfg_re_next;
   cfg_we_q   <= cfg_we_next;
  end
  cfg_taken_q <= cfg_taken_next;
  if (~init_done_q | init_in_progress) begin
   cfg_addr_q <= init_addr;
  end else if (~cfg_taken_q) begin
   cfg_addr_q  <= (|{cfg_re.dir_cq_isr
                    ,cfg_re.ldb_cq_isr
                    ,cfg_re.alarm_vf_synd0
                    ,cfg_re.alarm_vf_synd1
                    ,cfg_re.alarm_vf_synd2
                    ,cfg_we.dir_cq_isr
                    ,cfg_we.ldb_cq_isr
                    ,cfg_we.alarm_vf_synd0
                    ,cfg_we.alarm_vf_synd1
                    ,cfg_we.alarm_vf_synd2}) ? {1'b0, cfg_addr} : cfg_addr_msix;
  end
 end
end

assign init_in_progress = init_q[0] & ~init_done_q;
assign init_addr        = cfg_addr_q + {7'd0, init_q[0]};
assign init_done[12]    = init_done_q;

assign rst_done = rst_done_q;

always_ff @(posedge hqm_gated_clk) begin
 if (~cfg_taken_q) begin
  cfg_wdata_q <= (|{cfg_we.msg_addr_u
                   ,cfg_we.msg_addr_l
                   ,cfg_we.msg_data
                   ,cfg_we.vector_ctrl}) ? cfg_wdata_msix : cfg_wdata;
 end
 cfg_write_bad_parity_q <= cfg_write_bad_parity;
end

assign cfg_re_in_lut  = (|{cfg_re_q.dir_cq_isr
                          ,cfg_re_q.ldb_cq_isr
                          ,cfg_re_q.sbe_cnt_0
                          ,cfg_re_q.sbe_cnt_1
                          ,cfg_re_q.alarm_hw_synd
                          ,cfg_re_q.alarm_pf_synd0
                          ,cfg_re_q.alarm_pf_synd1
                          ,cfg_re_q.alarm_pf_synd2
                          ,cfg_re_q.alarm_vf_synd0
                          ,cfg_re_q.alarm_vf_synd1
                          ,cfg_re_q.alarm_vf_synd2
}) & (~cfg_taken_q);

assign cfg_we_in_lut  = (|{cfg_we_q.dir_cq_isr
                          ,cfg_we_q.ldb_cq_isr
                          ,cfg_we_q.sbe_cnt_0
                          ,cfg_we_q.sbe_cnt_1
                          ,cfg_we_q.alarm_hw_synd
                          ,cfg_we_q.alarm_pf_synd0
                          ,cfg_we_q.alarm_pf_synd1
                          ,cfg_we_q.alarm_pf_synd2
                          ,cfg_we_q.alarm_vf_synd0
                          ,cfg_we_q.alarm_vf_synd1
                          ,cfg_we_q.alarm_vf_synd2
}) & (~cfg_taken_q);

assign cfg_re_in_msix = (|{cfg_re_q.msg_addr_u
                          ,cfg_re_q.msg_addr_l
                          ,cfg_re_q.msg_data
                          ,cfg_re_q.vector_ctrl
}) & (~cfg_taken_q);

assign cfg_we_in_msix = (|{cfg_we_q.msg_addr_u
                          ,cfg_we_q.msg_addr_l
                          ,cfg_we_q.msg_data
                          ,cfg_we_q.vector_ctrl
}) & (~cfg_taken_q);

assign cfg_re_in_ai   = (|{cfg_re_q.ai_addr_l
                          ,cfg_re_q.ai_addr_u
                          ,cfg_re_q.ai_data
}) & (~cfg_taken_q);

assign cfg_we_in_ai   = (|{cfg_we_q.ai_addr_l
                          ,cfg_we_q.ai_addr_u
                          ,cfg_we_q.ai_data
}) & (~cfg_taken_q);

assign cfg_re_v.dir_cq_isr     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq_isr;
assign cfg_re_v.ldb_cq_isr     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_cq_isr;
assign cfg_re_v.sbe_cnt_0      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.sbe_cnt_0;
assign cfg_re_v.sbe_cnt_1      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.sbe_cnt_1;
assign cfg_re_v.alarm_hw_synd  = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_hw_synd;
assign cfg_re_v.alarm_pf_synd0 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_pf_synd0;
assign cfg_re_v.alarm_pf_synd1 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_pf_synd1;
assign cfg_re_v.alarm_pf_synd2 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_pf_synd2;

// Always read vf_synd0 (because it contains the parity bits when reading vf_synd0-2

assign cfg_re_v.alarm_vf_synd0 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & (cfg_re_q.alarm_vf_synd0 |
                                                                                cfg_re_q.alarm_vf_synd1 |
                                                                                cfg_re_q.alarm_vf_synd2);

assign cfg_re_v.alarm_vf_synd1 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_vf_synd1;
assign cfg_re_v.alarm_vf_synd2 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.alarm_vf_synd2;
                                              
assign cfg_we_v.dir_cq_isr     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq_isr;
assign cfg_we_v.ldb_cq_isr     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_cq_isr;
assign cfg_we_v.sbe_cnt_0      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.sbe_cnt_0;
assign cfg_we_v.sbe_cnt_1      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.sbe_cnt_1;
assign cfg_we_v.alarm_hw_synd  = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_hw_synd;
assign cfg_we_v.alarm_pf_synd0 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_pf_synd0;
assign cfg_we_v.alarm_pf_synd1 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_pf_synd1;
assign cfg_we_v.alarm_pf_synd2 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_pf_synd2;
assign cfg_we_v.alarm_vf_synd0 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_vf_synd0;
assign cfg_we_v.alarm_vf_synd1 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_vf_synd1;
assign cfg_we_v.alarm_vf_synd2 = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.alarm_vf_synd2;
                              
assign cfg_re_v.msg_addr_u     = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_re_q.msg_addr_u;
assign cfg_re_v.msg_addr_l     = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_re_q.msg_addr_l;
assign cfg_re_v.msg_data       = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_re_q.msg_data;
assign cfg_re_v.vector_ctrl    = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_re_q.vector_ctrl;
                              
assign cfg_we_v.msg_addr_u     = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_we_q.msg_addr_u;
assign cfg_we_v.msg_addr_l     = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_we_q.msg_addr_l;
assign cfg_we_v.msg_data       = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_we_q.msg_data;
assign cfg_we_v.vector_ctrl    = (~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q}) & ~cfg_taken_q & cfg_we_q.vector_ctrl;

assign cfg_re_v.ai_addr_l      = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_re_q.ai_addr_l;
assign cfg_re_v.ai_addr_u      = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_re_q.ai_addr_u;
assign cfg_re_v.ai_data        = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_re_q.ai_data;
                              
assign cfg_we_v.ai_addr_l      = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_we_q.ai_addr_l;
assign cfg_we_v.ai_addr_u      = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_we_q.ai_addr_u;
assign cfg_we_v.ai_data        = (~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q}) & ~cfg_taken_q & cfg_we_q.ai_data;

//-----------------------------------------------------------------------------------------------------
// CFG read data is valid when the memory output pipeline stage valid (p2_v_q) is asserted and
// the CFG flop is set but the write indication (p2) is not asserted.  Can ack CFG writes when
// the memory output pipeline stage is valid and the write indication is asserted.

assign cfg_rvalid_next = (     p2_v_q &      p2_cfg_q & ~(|     p2_cfg_we_q)) |
                         (msix_p2_v_q & msix_p2_cfg_q & ~(|msix_p2_cfg_we_q)) |
                         (  ai_p2_v_q &   ai_p2_cfg_q & ~(|  ai_p2_cfg_we_q));

assign cfg_wvalid_next = (&{     p2_v_q,      p2_cfg_q,      p2_cfg_we_q}) |
                         (&{msix_p2_v_q, msix_p2_cfg_q, msix_p2_cfg_we_q}) |
                         (&{  ai_p2_v_q,   ai_p2_cfg_q,   ai_p2_cfg_we_q});

assign cfg_rdata_next  = (|{cfg_re_q.sbe_cnt_0,      cfg_re_q.sbe_cnt_1
                           ,cfg_re_q.alarm_hw_synd
                           ,cfg_re_q.alarm_pf_synd0, cfg_re_q.alarm_vf_synd0
                           ,cfg_re_q.alarm_pf_synd1, cfg_re_q.alarm_vf_synd1
                           ,cfg_re_q.alarm_pf_synd2, cfg_re_q.alarm_vf_synd2}) ?
                          alarm_synd_rdata_q :
                        ((|{cfg_re_q.dir_cq_isr, cfg_re_q.ldb_cq_isr}) ?
                          (cfg_rdata_lut.dir_cq_isr  | cfg_rdata_lut.ldb_cq_isr) :
                        ((|{cfg_re_q.ai_addr_l, cfg_re_q.ai_addr_u, cfg_re_q.ai_data}) ?
                          (cfg_rdata_lut.ai_addr_l   | cfg_rdata_lut_ai_addr_l_ldb    |
                           cfg_rdata_lut.ai_addr_u   | cfg_rdata_lut_ai_addr_u_ldb    |
                           cfg_rdata_lut.ai_data     | cfg_rdata_lut_ai_data_ldb) :
                          (cfg_rdata_lut.msg_addr_l  | cfg_rdata_lut.msg_addr_u       |
                           cfg_rdata_lut.msg_data    | cfg_rdata_lut.vector_ctrl)));

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cfg_rvalid_q <= '0;
  cfg_wvalid_q <= '0;
  cfg_error_q  <= '0;
  cfg_rdata_q  <= '0;
  cfg_vf_par_q <= '0;
 end else begin
  cfg_rvalid_q <= cfg_rvalid_next;
  cfg_wvalid_q <= cfg_wvalid_next;
  cfg_error_q  <= cfg_wvalid_next & (|{cfg_we_q.alarm_pf_synd1
                                      ,cfg_we_q.alarm_pf_synd2
                                      ,cfg_we_q.alarm_vf_synd1
                                      ,cfg_we_q.alarm_vf_synd2});
  if (cfg_rvalid_next) begin
   cfg_rdata_q  <= cfg_rdata_next;
   cfg_vf_par_q <= alarm_synd21_par_q;
  end
 end
end

assign cfg_rvalid = cfg_re_q & {$bits(cfg_rvalid){cfg_rvalid_q}};
assign cfg_wvalid = cfg_we_q & {$bits(cfg_wvalid){cfg_wvalid_q}};
assign cfg_error  = (cfg_re_q | cfg_we_q) & {$bits(cfg_error){cfg_error_q}};
assign cfg_rdata  = cfg_rdata_q;

//-----------------------------------------------------------------------------------------------------
// Parity on VDEV syndrome bits

assign cfg_read_vf_synd = {3{cfg_rvalid_q}} & {cfg_re_q.alarm_vf_synd2
                                              ,cfg_re_q.alarm_vf_synd1
                                              ,cfg_re_q.alarm_vf_synd0};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cfg_inj_par_err_q      <= '0;
  cfg_inj_par_err_last_q <= '0;
 end else begin
  cfg_inj_par_err_q      <= cfg_inj_par_err_vf_synd;
  cfg_inj_par_err_last_q <= cfg_inj_par_err_q & (|{cfg_inj_par_err_last_q, cfg_read_vf_synd});
 end
end

// If reading one of the vf_synd0-2 memories, check parity
// Set the parity error if the parity error injection is armed
// vf_synd2's parity bit was piped down in cfg_vf_par_q[2] from the parallel vf_synd0 read
// vf_synd1's parity bit was piped down in cfg_vf_par_q[1] from the parallel vf_synd0 read
// vf_synd0's read data includes the valid and more bits which aren't covered in the parity
// Note that synd0_par also does not include synd2_par or synd1_par

assign vf_synd_perr = (|cfg_read_vf_synd) & ((cfg_inj_par_err_q & ~cfg_inj_par_err_last_q) |
                        (^{cfg_rdata_q, ((cfg_read_vf_synd[2]) ? {3'd0, cfg_vf_par_q[2]} :
                                        ((cfg_read_vf_synd[1]) ? {3'd0, cfg_vf_par_q[1]} :
                                                                 {cfg_rdata_q[31:30]
                                                                 ,cfg_rdata_q[12:11]}))}));

//-----------------------------------------------------------------------------------------------------
// Buffer hqm_proc and sif alarm interfaces

logic           agg_cwd_alarm_out_data_nc;
logic           agg_cwd_alarm_mem_re_nc;
logic   [1:0]   agg_cwd_alarm_mem_raddr_nc;
logic           agg_cwd_alarm_mem_we_nc;
logic   [1:0]   agg_cwd_alarm_mem_waddr_nc;
logic           agg_cwd_alarm_mem_wdata_nc;

hqm_AW_rx_sync #(.WIDTH(1)) i_cwd_alarm_rx_sync (

     .hqm_inp_gated_clk         (hqm_inp_gated_clk)
    ,.hqm_inp_gated_rst_n       (hqm_inp_gated_rst_n)

    ,.status                    (cwdi_rx_fifo_status)
    ,.enable                    (rx_sync_cwd_interrupt_enable)
    ,.idle                      (rx_sync_cwd_interrupt_idle)
    ,.rst_prep                  (rst_prep)

    ,.in_ready                  (cwdi_interrupt_w_req_ready)

    ,.in_valid                  (cwdi_interrupt_w_req_valid)
    ,.in_data                   ('0)

    ,.out_ready                 (agg_cwd_alarm_db_ready)

    ,.out_valid                 (agg_cwd_alarm_db_v)
    ,.out_data                  (agg_cwd_alarm_out_data_nc)

    ,.mem_re                    (agg_cwd_alarm_mem_re_nc)
    ,.mem_raddr                 (agg_cwd_alarm_mem_raddr_nc)
    ,.mem_we                    (agg_cwd_alarm_mem_we_nc)
    ,.mem_waddr                 (agg_cwd_alarm_mem_waddr_nc)
    ,.mem_wdata                 (agg_cwd_alarm_mem_wdata_nc)
    ,.mem_rdata                 ('0)
);

hqm_AW_agitate_readyvalid #(.SEED(32'h7240)) i_agitate_cwd_alarm_db (

         .clk                   (hqm_gated_clk)
        ,.rst_n                 (hqm_gated_rst_n)

        ,.control               (al_cwd_alarm_db_agitate_control)
        ,.enable                (1'b1)

        ,.up_v                  (agg_cwd_alarm_db_v)
        ,.up_ready              (agg_cwd_alarm_db_ready)

        ,.down_v                (cwd_alarm_db_v)
        ,.down_ready            (cwd_alarm_db_ready)
);

assign cwd_alarm_db_valid         = cwd_alarm_db_v & ~cfg_alarm_ctl.DISABLE_CWD_ALARMS;

logic                                           rx_sync_hqm_alarm_re;
logic                                           rx_sync_hqm_alarm_we;
logic   [1:0]                                   rx_sync_hqm_alarm_raddr;
logic   [1:0]                                   rx_sync_hqm_alarm_waddr;
logic   [$bits(hqm_alarm_data)-1:0]             rx_sync_hqm_alarm_wdata;
logic   [$bits(hqm_alarm_data)-1:0]             rx_sync_hqm_alarm_rdata;
logic   [3:0][$bits(hqm_alarm_data)-1:0]        rx_sync_hqm_alarm_mem;

hqm_AW_rx_sync #(.WIDTH($bits(hqm_alarm_data))) i_hqm_alarm_rx_sync (

     .hqm_inp_gated_clk         (hqm_inp_gated_clk)
    ,.hqm_inp_gated_rst_n       (hqm_inp_gated_rst_n)



    ,.status                    (hqm_alarm_rx_fifo_status)
    ,.enable                    (rx_sync_hqm_alarm_enable)
    ,.idle                      (rx_sync_hqm_alarm_idle)
    ,.rst_prep                  (rst_prep)

    ,.in_ready                  (hqm_alarm_ready)

    ,.in_valid                  (hqm_alarm_v)
    ,.in_data                   (hqm_alarm_data)

    ,.out_ready                 (agg_hqm_alarm_db_ready)

    ,.out_valid                 (agg_hqm_alarm_db_v)
    ,.out_data                  (hqm_alarm_db_data)

    ,.mem_re                    (rx_sync_hqm_alarm_re)
    ,.mem_raddr                 (rx_sync_hqm_alarm_raddr)
    ,.mem_we                    (rx_sync_hqm_alarm_we)
    ,.mem_waddr                 (rx_sync_hqm_alarm_waddr)
    ,.mem_wdata                 (rx_sync_hqm_alarm_wdata)
    ,.mem_rdata                 (rx_sync_hqm_alarm_rdata)
);

always_ff @(posedge hqm_inp_gated_clk) begin
 if (rx_sync_hqm_alarm_we) rx_sync_hqm_alarm_mem[rx_sync_hqm_alarm_waddr] <= rx_sync_hqm_alarm_wdata;   
 if (rx_sync_hqm_alarm_re) rx_sync_hqm_alarm_rdata <= rx_sync_hqm_alarm_mem[rx_sync_hqm_alarm_raddr];
end

hqm_AW_agitate_readyvalid #(.SEED(32'h7242)) i_agitate_hqm_alarm_db (

         .clk                   (hqm_gated_clk)
        ,.rst_n                 (hqm_gated_rst_n)

        ,.control               (al_hqm_alarm_db_agitate_control)
        ,.enable                (1'b1)

        ,.up_v                  (agg_hqm_alarm_db_v)
        ,.up_ready              (agg_hqm_alarm_db_ready)

        ,.down_v                (hqm_alarm_db_v)
        ,.down_ready            (hqm_alarm_db_ready)
) ;

assign hqm_alarm_db_valid = hqm_alarm_db_v & ~cfg_alarm_ctl.DISABLE_HQM_ALARMS;
assign hqm_alarm_db_base  = 4'd1;

logic                                           sif_alarm_fifo_re;
logic                                           sif_alarm_fifo_we;
logic   [$bits(sif_alarm_data)-1:0]             sif_alarm_fifo_wdata;
logic   [$bits(sif_alarm_data)-1:0]             sif_alarm_fifo_rdata;
logic   [$bits(sif_alarm_data)-1:0]             sif_alarm_fifo_mem;

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_n) begin
 if (~prim_gated_rst_n) begin
  sif_alarm_v_q    <= '0;
  sif_alarm_data_q <= '0;
 end else begin
  sif_alarm_v_q    <= (sif_alarm_fifo_afull) ? sif_alarm_v_q    : sif_alarm_v;
  sif_alarm_data_q <= (sif_alarm_fifo_afull) ? sif_alarm_data_q : sif_alarm_data;
 end
end

assign sif_alarm_ready          = ~sif_alarm_fifo_afull;
assign sif_alarm_fifo_push      = sif_alarm_v_q & ~sif_alarm_fifo_afull;
assign sif_alarm_fifo_push_data = sif_alarm_data_q;

// The watermark shouldn't be changed when the data path is active but adding a
// sync to avoid metastability on the bits.

logic   [$bits(cfg_sif_alarm_fifo_high_wm)-1:0]    cfg_sif_alarm_fifo_high_wm_sync;

hqm_AW_sync #(.WIDTH($bits(cfg_sif_alarm_fifo_high_wm))) i_cfg_sif_alarm_fifo_high_wm_sync (

     .clk                   (prim_gated_clk)
    ,.data                  (cfg_sif_alarm_fifo_high_wm)
    ,.data_sync             (cfg_sif_alarm_fifo_high_wm_sync)
);

logic           sif_alarm_fifo_mem_waddr_nc;
logic           sif_alarm_fifo_mem_raddr_nc;
logic           sif_alarm_fifo_push_depth_nc;
logic           sif_alarm_fifo_push_full_nc;
logic           sif_alarm_fifo_push_aempty_nc;
logic           sif_alarm_fifo_pop_depth_nc;
logic           sif_alarm_fifo_pop_aempty_nc;
logic           sif_alarm_fifo_pop_empty_nc;

hqm_AW_fifo_control_gdc_wreg #(

     .DEPTH                 (1)
    ,.DWIDTH                ($bits(sif_alarm_data))

) i_sif_alarm_fifo (

     .clk_push              (prim_gated_clk)
    ,.rst_push_n            (prim_gated_rst_n)

    ,.clk_pop               (hqm_gated_clk)
    ,.rst_pop_n             (hqm_gated_rst_n)

    ,.cfg_high_wm           (cfg_sif_alarm_fifo_high_wm_sync)
    ,.cfg_low_wm            ('0)

    ,.fifo_enable           (sif_alarm_fifo_enable)

    ,.clear_pop_state       ('0)

    ,.push                  (sif_alarm_fifo_push)
    ,.push_data             (sif_alarm_fifo_push_data)

    ,.pop                   (sif_alarm_fifo_pop)
    ,.pop_data_v            (sif_alarm_fifo_pop_data_v)
    ,.pop_data              (sif_alarm_fifo_pop_data)

    ,.mem_we                (sif_alarm_fifo_we)
    ,.mem_waddr             (sif_alarm_fifo_mem_waddr_nc)
    ,.mem_wdata             (sif_alarm_fifo_wdata)
    ,.mem_re                (sif_alarm_fifo_re)
    ,.mem_raddr             (sif_alarm_fifo_mem_raddr_nc)
    ,.mem_rdata             (sif_alarm_fifo_rdata)

    ,.fifo_push_depth       (sif_alarm_fifo_push_depth_nc)
    ,.fifo_push_full        (sif_alarm_fifo_push_full_nc)
    ,.fifo_push_afull       (sif_alarm_fifo_afull_raw)
    ,.fifo_push_empty       (sif_alarm_fifo_push_empty)
    ,.fifo_push_aempty      (sif_alarm_fifo_push_aempty_nc)

    ,.fifo_pop_depth        (sif_alarm_fifo_pop_depth_nc)
    ,.fifo_pop_aempty       (sif_alarm_fifo_pop_aempty_nc)
    ,.fifo_pop_empty        (sif_alarm_fifo_pop_empty_nc)

    ,.fifo_status           (sif_alarm_fifo_status)
);

hqm_AW_sync_rst0 i_sif_alarm_fifo_idle (

     .clk                   (hqm_inp_gated_clk)
    ,.rst_n                 (hqm_inp_gated_rst_n)
    ,.data                  (sif_alarm_fifo_push_empty)
    ,.data_sync             (sif_alarm_fifo_idle)
);

always_ff @(posedge prim_gated_clk) begin
 if (sif_alarm_fifo_we) sif_alarm_fifo_mem <= sif_alarm_fifo_wdata;   
end

always_ff @(posedge hqm_gated_clk) begin
 if (sif_alarm_fifo_re) sif_alarm_fifo_rdata <= sif_alarm_fifo_mem;
end

// This control should really not be changing during normal functional operation but, if it does,
// adding a sync to guard against the metastability and a qualifier on the mode changing.

AL_SIF_ALARM_AFULL_AGITATE_CONTROL_t    agitate_control_sync;
AL_SIF_ALARM_AFULL_AGITATE_CONTROL_t    agitate_control;
logic   [1:0]                           agitate_control_mode_q;
logic                                   agitate_control_stable;
logic                                   agitate_control_stable_q;

hqm_AW_sync_rst0 #(.WIDTH(32)) i_agitate_control_sync (

     .clk                   (prim_gated_clk)
    ,.rst_n                 (prim_gated_rst_n)
    ,.data                  (al_sif_alarm_afull_agitate_control)
    ,.data_sync             (agitate_control_sync)
);

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_n) begin
 if (~prim_gated_rst_n) begin
  agitate_control_mode_q   <= '0;
  agitate_control_stable_q <= '0;
 end else begin
  if (~agitate_control_stable) begin
   agitate_control_mode_q  <= agitate_control_sync.MODE;
  end
  agitate_control_stable_q <= agitate_control_stable;
 end
end

assign agitate_control_stable = (agitate_control_sync.MODE == agitate_control_mode_q);

assign agitate_control = agitate_control_sync &
                         {32{(agitate_control_stable & agitate_control_stable_q)}};

hqm_AW_agitate #(.SEED(32'h7241)) i_agitate_sif_alarm_afull (

        .clk                    (prim_gated_clk),
        .rst_n                  (prim_gated_rst_n),

        .control                (agitate_control),

        .in_agitate_value       (1'b1),
        .in_data                (sif_alarm_fifo_afull_raw),

        .in_stall_trigger       (1'b1),
        .out_data               (sif_alarm_fifo_afull)
);

assign sif_alarm_fifo_valid = sif_alarm_fifo_pop_data_v & ~cfg_alarm_ctl.DISABLE_SIF_ALARMS;
assign sif_alarm_fifo_pop_data_base = 4'd2;

//-----------------------------------------------------------------------------------------------------
// Serialize non-input_check alarms from the hqm_system logic

logic           int_up_ready_nc;

hqm_AW_int_serializer #(

         .NUM_INF               (NUM_INF)
        ,.NUM_COR               (NUM_COR)
        ,.NUM_UNC               (NUM_UNC)
        ,.UNIT_WIDTH            (UNIT_WIDTH)

) i_hqm_AW_int_serializer (

         .hqm_inp_gated_clk     (hqm_gated_clk)
        ,.hqm_inp_gated_rst_n   (hqm_gated_rst_n)
        ,.rst_prep              (rst_prep)

        ,.unit                  (sys_unit)

        ,.inf_v                 (sys_alarm_inf_v)
        ,.inf_data              (sys_alarm_inf_data)

        ,.cor_v                 (sys_alarm_cor_v)
        ,.cor_data              (sys_alarm_cor_data)

        ,.unc_v                 (sys_alarm_unc_v)
        ,.unc_data              (sys_alarm_unc_data)

        ,.int_up_ready          (int_up_ready_nc)

        ,.int_up_v              ('0)
        ,.int_up_data           ('0)

        ,.int_down_ready        (sys_alarm_db_ready)

        ,.int_down_v            (sys_alarm_db_v)
        ,.int_down_data         (sys_alarm_db_data)

        ,.status                (sys_alarm_is_status)
        ,.int_idle              (int_idle)
);

assign sys_alarm_db_valid  = sys_alarm_db_v & ~cfg_alarm_ctl.DISABLE_SYS_ALARMS;
assign sys_alarm_db_base   = 4'd0;

assign sys_alarm_db_status = sys_alarm_is_status[13:7];

hqm_AW_unused_bits i_unused_is (       

         .a     (|{sys_alarm_is_status[31:14]
                  ,sys_alarm_is_status[6:0]
                  ,cfg_we_v.alarm_pf_synd2
                  ,cfg_we_v.alarm_pf_synd1
                  ,cfg_we_v.alarm_vf_synd2
                  ,cfg_we_v.alarm_vf_synd1
                  ,sys_idle_status_reg.reserved0
                  ,msix_tbl_rdata_mask
                  ,msix_mode.reserved0
                  ,sys_alarm_db_data.msix_map[2:0]
                  ,sif_alarm_fifo_pop_data.msix_map[2:0]
                  ,msix_tbl_rdata_addr[1:0]
                  ,ims_pend_clear.reserved0
                  ,cfg_addr_ldb[7:HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_L]
                  ,ai_tbl_vec_ldb[AI_VEC_WIDTH-1:HQM_SYSTEM_CQ_WIDTH]
                })
);

//-----------------------------------------------------------------------------------------------------
// Serialize double buffered alarms with ingress alarms
//
// These are all treated as PF

always_comb begin

 sif_alarm_fifo_pop  = '0;
 hqm_alarm_db_ready  = '0;
 sys_alarm_db_ready  = '0;
 cwd_alarm_db_ready  = '0;
 alarm_mask_next     = alarm_mask_q;

 // If we're getting constant ingress alarms to hold off the others, then something is seriously wrong!

 if (~ingress_alarm_v) begin
  case ({cwd_alarm_db_valid, ({sif_alarm_fifo_valid, hqm_alarm_db_valid, sys_alarm_db_valid} & ~alarm_mask_q)})
   4'b0001: begin sys_alarm_db_ready  = '1; alarm_mask_next    =   '0; end
   4'b0010: begin hqm_alarm_db_ready  = '1; alarm_mask_next    =   '0; end
   4'b0100: begin sif_alarm_fifo_pop  = '1; alarm_mask_next    =   '0; end
   4'b1000: begin cwd_alarm_db_ready  = '1; alarm_mask_next    =   '0; end
   4'b0011,
   4'b0101,
   4'b0111,
   4'b1001,
   4'b1011,
   4'b1101,
   4'b1111: begin sys_alarm_db_ready  = '1; alarm_mask_next[0] = 1'b1; end
   4'b0110,
   4'b1010,
   4'b1110: begin hqm_alarm_db_ready  = '1; alarm_mask_next[1] = 1'b1; end
   4'b1100: begin sif_alarm_fifo_pop  = '1; alarm_mask_next[2] = 1'b1; end
   default: begin                           alarm_mask_next    = 3'd0; end
  endcase
 end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  alarm_mask_q <= '0;
 end else begin
  alarm_mask_q <= alarm_mask_next;
 end
end

hqm_AW_width_scale #(.A_WIDTH($bits(ingress_alarm.vpp)), .Z_WIDTH(8)) i_vpp_scaled (

     .a     (ingress_alarm.vpp)
    ,.z     (ingress_alarm_vpp_scaled)
);

assign sbe_in = sys_alarm_db_ready & (sys_alarm_db_data.cls == 2'd1);

// These are just used as triggers

assign iecor_error = (sys_alarm_db_valid    & (sys_alarm_db_data.cls  == 2'd1) & sys_alarm_int_enable) |
                     (hqm_alarm_db_valid    & (hqm_alarm_db_data.cls  == 2'd1)) |
                     (sif_alarm_fifo_valid  & (sif_alarm_fifo_pop_data.cls == 2'd1));

assign ieunc_error = (sys_alarm_db_valid    & (sys_alarm_db_data.cls  != 2'd1) & sys_alarm_int_enable) |
                     (hqm_alarm_db_valid    & (hqm_alarm_db_data.cls  != 2'd1)) |
                     (sif_alarm_fifo_valid  & (sif_alarm_fifo_pop_data.cls != 2'd1));

//-----------------------------------------------------------------------------------------------------
// Convert ingress, system, hqm_proc, and sif alarms into MSI-X requests and save syndromes

assign cfg_rdata_lut.alarm_hw_synd  = {alarm_hw_synd_v_q, alarm_hw_synd_more_q, alarm_hw_synd_q[29:0]};
assign cfg_rdata_lut.alarm_pf_synd0 = {alarm_pf_synd_v_q, alarm_pf_synd_more_q, alarm_pf_synd_q[29:0]};
assign cfg_rdata_lut.alarm_pf_synd1 = alarm_pf_synd_q[61:30];
assign cfg_rdata_lut.alarm_pf_synd2 = alarm_pf_synd_q[93:62];

assign cfg_rdata_lut.alarm_vf_synd0 = {alarm_vf_synd_v_q[   cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0]]
                                      ,alarm_vf_synd_more_q[cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0]]
                                      ,memo_alarm_vf_synd0.rdata};
assign cfg_rdata_lut.alarm_vf_synd1 = memo_alarm_vf_synd1.rdata;
assign cfg_rdata_lut.alarm_vf_synd2 = memo_alarm_vf_synd2.rdata;

localparam NUM_MB_ECC_BITS = 8;

hqm_AW_width_scale #(.A_WIDTH(NUM_MB_ECC_BITS), .Z_WIDTH(64)) i_cfg_mb_ecc_int_enable (

     .a     (cfg_sys_alarm_mb_ecc_int_enable[NUM_MB_ECC_BITS-1:0])
    ,.z     (cfg_mb_ecc_int_enable)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_MB_ECC_BITS+2), .Z_WIDTH(64)) i_cfg_sb_ecc_int_enable (

     .a     (cfg_sys_alarm_sb_ecc_int_enable[NUM_MB_ECC_BITS+1:0])
    ,.z     (cfg_sb_ecc_int_enable)
);

hqm_AW_width_scale #(.A_WIDTH($bits(cfg_sys_alarm_int_enable)), .Z_WIDTH(64)) i_cfg_alarm_int_enable (

     .a     (cfg_sys_alarm_int_enable)
    ,.z     (cfg_alarm_int_enable)
);

assign sys_alarm_db_aid_mmb = sys_alarm_db_data.aid - NUM_MB_ECC_BITS[5:0];

always_comb begin

 sys_alarm_int_enable = '0;

 if (sys_alarm_db_data.cls == 2'd1) begin
  sys_alarm_int_enable = cfg_sb_ecc_int_enable[sys_alarm_db_data.aid];
 end else if (sys_alarm_db_data.aid < NUM_MB_ECC_BITS[5:0]) begin
  sys_alarm_int_enable = cfg_mb_ecc_int_enable[sys_alarm_db_data.aid];
 end else begin
  sys_alarm_int_enable = cfg_alarm_int_enable[sys_alarm_db_aid_mmb];
 end
end

always_comb begin

 alarm_hw_synd_v_next      = alarm_hw_synd_v_q;
 alarm_hw_synd_more_next   = alarm_hw_synd_more_q;
 alarm_hw_synd_next        = alarm_hw_synd_q;

 alarm_pf_synd_v_next      = alarm_pf_synd_v_q;
 alarm_pf_synd_more_next   = alarm_pf_synd_more_q;
 alarm_pf_synd_next        = alarm_pf_synd_q;

 alarm_vf_synd_v_next      = alarm_vf_synd_v_q;
 alarm_vf_synd_more_next   = alarm_vf_synd_more_q;
 alarm_vf_synd0_next       = '0;
 alarm_vf_synd0_next.raddr = cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
 alarm_vf_synd0_next.waddr = ingress_alarm.vdev;
 alarm_vf_synd1_next       = '0;
 alarm_vf_synd1_next.raddr = cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
 alarm_vf_synd1_next.waddr = ingress_alarm.vdev;
 alarm_vf_synd2_next       = '0;
 alarm_vf_synd2_next.raddr = cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
 alarm_vf_synd2_next.waddr = ingress_alarm.vdev;

 alarm_synd_rdata_next     = alarm_synd_rdata_q;
 alarm_synd21_par_next     = alarm_synd21_par_q;

 alarm_reqs_next           = '0;

 // PF, HW and SBE regs are all local

 if (cfg_re_v.alarm_pf_synd0) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.alarm_pf_synd0;
 end else if (cfg_re_v.alarm_pf_synd1) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.alarm_pf_synd1;
 end else if (cfg_re_v.alarm_pf_synd2) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.alarm_pf_synd2;
 end else if (cfg_re_v.alarm_hw_synd) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.alarm_hw_synd;
 end else if (cfg_re_v.sbe_cnt_0) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.sbe_cnt_0;
 end else if (cfg_re_v.sbe_cnt_1) begin
  alarm_synd_rdata_next   = cfg_rdata_lut.sbe_cnt_1;
 end

 if (cfg_we_v.alarm_hw_synd) begin  // Only valid and more bits are COW1
  if (cfg_wdata_q[31]) alarm_hw_synd_v_next    = '0;
  if (cfg_wdata_q[30]) alarm_hw_synd_more_next = '0;
 end

 if (cfg_we_v.alarm_pf_synd0) begin // Only valid and more bits are COW1
  if (cfg_wdata_q[31]) alarm_pf_synd_v_next    = '0;
  if (cfg_wdata_q[30]) alarm_pf_synd_more_next = '0;
 end

 // VDEV valid and more stored locally and everything else in memory

 if (cfg_re_v.alarm_vf_synd0) begin
  alarm_vf_synd0_next.re = 1'b1;
 end
 if (cfg_re_v.alarm_vf_synd1) begin
  alarm_vf_synd1_next.re = 1'b1;
 end else if (cfg_re_v.alarm_vf_synd2) begin
  alarm_vf_synd2_next.re = 1'b1;
 end

 if (cfg_we_v.alarm_vf_synd0) begin // Only valid and more bits are COW1
  if (cfg_wdata_q[31]) alarm_vf_synd_v_next[   cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0]] = 1'b0; 
  if (cfg_wdata_q[30]) alarm_vf_synd_more_next[cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0]] = 1'b0; 
 end

 if (p1_v_q & p1_cfg_q) begin
  if (cfg_re_q.alarm_vf_synd0) begin
   alarm_synd_rdata_next = cfg_rdata_lut.alarm_vf_synd0;
  end else if (cfg_re_q.alarm_vf_synd1) begin
   alarm_synd_rdata_next = cfg_rdata_lut.alarm_vf_synd1;
   alarm_synd21_par_next = cfg_rdata_lut.alarm_vf_synd0[12:11];
  end else if (cfg_re_q.alarm_vf_synd2) begin
   alarm_synd_rdata_next = cfg_rdata_lut.alarm_vf_synd2;
   alarm_synd21_par_next = cfg_rdata_lut.alarm_vf_synd0[12:11];
  end
 end

 // HW alarms from the sif, system, hqm_proc, or ingress parity or ECC errors
 // need to update the HW syndrome regs and set the valid and alarm flag bits.
 // Watchdog interrupts will not set the syndrome regs except for the valid bit,
 // and the cwd flag bits respectively (ie. they do not set any other fields
 // except possibly the more bit).
 // So only alarms set the other syndrome fields.
 // The more bit gets set if we get an additional interrupt and the associated
 // flag bit (alarm, cwd) is already set.

 if ((ingress_alarm_v      & (ingress_alarm.msix_map     != INGRESS_ERROR)) |
     (hqm_alarm_db_ready   & (hqm_alarm_db_data.msix_map != INGRESS_ERROR)) |
     (sys_alarm_db_ready   & sys_alarm_int_enable) |
     sif_alarm_fifo_pop | cwd_alarm_db_ready) begin

  if (alarm_hw_synd_v_q & alarm_hw_synd_q[10]) begin

   // If already valid, set the more bit and the appropriate flag bit

   if (cwd_alarm_db_ready) begin
    if (alarm_hw_synd_q[11]) alarm_hw_synd_more_next = 1'b1;
    alarm_hw_synd_next[11] = 1'b1;
   end

   if (ingress_alarm_v | hqm_alarm_db_ready | sys_alarm_db_ready | sif_alarm_fifo_pop) begin
    alarm_hw_synd_more_next = 1'b1;
   end

  end else begin

   // Else, for alarms, set the valid and alarm flag bits and save the syndrome.
   // Else, for cwd, set the valid and appropriate flag bit and the more bit if
   // the associated flag bit was already set, but do not save the syndrome fields.

   alarm_hw_synd_v_next    = 1'b1;

   // Only one of these conditions is true at any one time due to the prior serialization code

   if (ingress_alarm_v) begin
    alarm_hw_synd_next = {sys_alarm_db_base                 // base
                         ,4'd1                              // unit
                         ,ingress_alarm.aid                 // aid
                         ,2'd2                              // cls
                         ,ingress_alarm.is_ldb_port         // is_ldb
                         ,1'd0                              // vf_pf_mb
                         ,1'd0                              // cwd
                         ,1'd1                              // alarm
                         ,2'd1                              // rtype
                         ,ingress_alarm_vpp_scaled          // rid
                         };
   end

   if (sys_alarm_db_ready) begin
    alarm_hw_synd_next = {sys_alarm_db_base                 // base
                         ,sys_alarm_db_data.unit            // unit
                         ,sys_alarm_db_data.aid             // aid
                         ,sys_alarm_db_data.cls             // cls
                         ,1'd0                              // is_ldb
                         ,1'd0                              // vf_pf_mb
                         ,1'd0                              // cwd
                         ,1'd1                              // alarm
                         ,sys_alarm_db_data.rtype           // rtype
                         ,sys_alarm_db_data.rid             // rid
                         };
   end

   if (hqm_alarm_db_ready) begin
    alarm_hw_synd_next = {hqm_alarm_db_base                 // base
                         ,hqm_alarm_db_data.unit            // unit
                         ,hqm_alarm_db_data.aid             // aid
                         ,hqm_alarm_db_data.cls             // cls
                         ,1'd0                              // is_ldb
                         ,1'd0                              // vf_pf_mb
                         ,1'd0                              // cwd
                         ,1'd1                              // alarm
                         ,hqm_alarm_db_data.rtype           // rtype
                         ,hqm_alarm_db_data.rid             // rid
                         };
   end

   if (sif_alarm_fifo_pop) begin
    alarm_hw_synd_next = {sif_alarm_fifo_pop_data_base      // base
                         ,sif_alarm_fifo_pop_data.unit      // unit
                         ,sif_alarm_fifo_pop_data.aid       // aid
                         ,sif_alarm_fifo_pop_data.cls       // cls
                         ,1'd0                              // is_ldb
                         ,1'd0                              // vf_pf_mb
                         ,1'd0                              // cwd
                         ,1'd1                              // alarm
                         ,sif_alarm_fifo_pop_data.rtype     // rtype
                         ,sif_alarm_fifo_pop_data.rid       // rid
                         };
   end

   if (cwd_alarm_db_ready) begin
    alarm_hw_synd_next[11] = 1'b1;
    if (alarm_hw_synd_v_q & alarm_hw_synd_q[11]) alarm_hw_synd_more_next = 1'b1;
   end

  end

  alarm_reqs_next = 1'b1;

 end

 // Ingress errors (non parity or ECC) are logged is a separate set of syndrome regs for the
 // PF and VDEVs.

 // PF ingress alarms

 if ((ingress_alarm_v    & ingress_alarm.is_pf & (ingress_alarm.msix_map == INGRESS_ERROR)) |
     (hqm_alarm_db_ready & (hqm_alarm_db_data.msix_map == INGRESS_ERROR))) begin

  if (alarm_pf_synd_v_q) begin

   // If already valid, just set the more bit

   alarm_pf_synd_more_next = 1'b1;

  end else begin

   // Else, set PF valid, clear PF more, and save the PF syndrome

   alarm_pf_synd_v_next    = 1'b1;
   alarm_pf_synd_more_next = 1'b0;

   // Only one of these conditions is true at any one time due to the prior serialization code

   if (ingress_alarm_v) begin
    alarm_pf_synd_next = {ingress_alarm.hcw                 // hcw
                         ,sys_alarm_db_base                 // base
                         ,4'd0                              // unit: ingress system alarms are unit 0
                         ,ingress_alarm.aid                 // aid
                         ,2'd0                              // cls
                         ,ingress_alarm.is_ldb_port         // is_ldb
                         ,3'd0                              // ???
                         ,2'd1                              // rtype
                         ,ingress_alarm_vpp_scaled          // rid
                         };
   end

   if (hqm_alarm_db_ready) begin
    alarm_pf_synd_next = {64'd0                             // hcw
                         ,hqm_alarm_db_base                 // base
                         ,hqm_alarm_db_data.unit            // unit
                         ,hqm_alarm_db_data.aid             // aid
                         ,hqm_alarm_db_data.cls             // cls
                         ,4'd0                              // ???
                         ,hqm_alarm_db_data.rtype           // rtype
                         ,hqm_alarm_db_data.rid             // rid
                         };
   end

  end

  alarm_reqs_next = 1'b1;

 end

 // VDEV ingress alarms

 if (ingress_alarm_v & ~ingress_alarm.is_pf & (ingress_alarm.msix_map == INGRESS_ERROR)) begin
  if (alarm_vf_synd_v_q[ingress_alarm.vdev]) begin

   // If VDEV valid already set, just set the VDEV more bit

   alarm_vf_synd_more_next[ingress_alarm.vdev] = 1'b1;    

  end else begin

   // Else, set VDEV valid, clear VDEV more, and write the VDEV syndrome memory

   alarm_vf_synd_v_next[ingress_alarm.vdev]    = 1'b1;    
   alarm_vf_synd_more_next[ingress_alarm.vdev] = 1'b0;    

   alarm_vf_synd0_next.we     = 1'b1;
   alarm_vf_synd1_next.we     = 1'b1;
   alarm_vf_synd2_next.we     = 1'b1;

   alarm_vf_synd2_next.wdata  = ingress_alarm.hcw[63:32];
   alarm_vf_synd1_next.wdata  = ingress_alarm.hcw[31: 0];
   alarm_vf_synd0_next.wdata  = {4'd0                                       // base
                                ,4'd0                                       // unit
                                ,ingress_alarm.aid                          // aid
                                ,2'd0                                       // cls
                                ,ingress_alarm.is_ldb_port                  // is_ldb
                                ,(^ingress_alarm.hcw[63:32])                // even parity
                                ,(^ingress_alarm.hcw[31: 0])                // even parity
                                ,(^{ingress_alarm.aid                       // even parity
                                   ,(~ingress_alarm.is_ldb_port)            // account for rtype bit being set
                                   ,ingress_alarm_vpp_scaled})
                                ,2'd1                                       // rtype
                                ,ingress_alarm_vpp_scaled                   // rid
                                };
  end

  alarm_reqs_next = 1'b1;

 end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  alarm_hw_synd_v_q       <= '0;
  alarm_hw_synd_more_q    <= '0;
  alarm_hw_synd_q         <= '0;
  alarm_pf_synd_v_q       <= '0;
  alarm_pf_synd_more_q    <= '0;
  alarm_pf_synd_q         <= '0;
  alarm_vf_synd_v_q       <= '0;
  alarm_vf_synd_more_q    <= '0;
  alarm_reqs_q            <= '0;
  alarm_synd_rdata_q      <= '0;
  alarm_synd21_par_q      <= '0;
  alarm_vf_synd0_q        <= '0;
  alarm_vf_synd1_q        <= '0;
  alarm_vf_synd2_q        <= '0;
 end else begin
  alarm_hw_synd_v_q       <= alarm_hw_synd_v_next;
  alarm_hw_synd_more_q    <= alarm_hw_synd_more_next;
  alarm_hw_synd_q         <= alarm_hw_synd_next;
  alarm_pf_synd_v_q       <= alarm_pf_synd_v_next;
  alarm_pf_synd_more_q    <= alarm_pf_synd_more_next;
  alarm_pf_synd_q         <= alarm_pf_synd_next;
  alarm_vf_synd_v_q       <= alarm_vf_synd_v_next;
  alarm_vf_synd_more_q    <= alarm_vf_synd_more_next;
  alarm_reqs_q            <= alarm_reqs_next;
  alarm_synd_rdata_q      <= alarm_synd_rdata_next;
  alarm_synd21_par_q      <= alarm_synd21_par_next;
  if (init_in_progress) begin
   alarm_vf_synd0_q.we    <= 1'b1;
   alarm_vf_synd0_q.waddr <= cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
   alarm_vf_synd1_q.we    <= 1'b1;
   alarm_vf_synd1_q.waddr <= cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
   alarm_vf_synd2_q.we    <= 1'b1;
   alarm_vf_synd2_q.waddr <= cfg_addr_q[HQM_SYSTEM_VDEV_WIDTH-1:0];
  end else begin
   alarm_vf_synd0_q       <= alarm_vf_synd0_next;
   alarm_vf_synd1_q       <= alarm_vf_synd1_next;
   alarm_vf_synd2_q       <= alarm_vf_synd2_next;
  end
 end
end

assign memi_alarm_vf_synd0 = alarm_vf_synd0_q;
assign memi_alarm_vf_synd1 = alarm_vf_synd1_q;
assign memi_alarm_vf_synd2 = alarm_vf_synd2_q;

//-----------------------------------------------------------------------------------------------------
// Pipeline for interrupt LUT access

assign p0_cfg_next   = cfg_re_in_lut | cfg_we_in_lut;

assign p0_v_next     = cfg_taken_lut | cq_occ_int_valid;

assign cfg_taken_lut = p0_cfg_next & ~|{p0_v_q, p1_v_q, p2_v_q};

assign p0_hold = p0_v_q & (p1_hold | (p0_cfg_we_q & ~(&p2_cfg_we_q)));
assign p0_load = p0_v_next;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p0_v_q      <= '0;
  p0_cfg_q    <= '0;
  p0_cfg_we_q <= '0;
 end else if (~p0_hold) begin
  p0_v_q      <= p0_v_next;
  p0_cfg_q    <= p0_cfg_next;
  p0_cfg_we_q <= p0_v_next & cfg_we_in_lut;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p0_load) begin
  if (~p0_cfg_next) p0_data_q <= cq_occ_int;
 end
end

assign cq_occ_int_busy = ~rst_done_q | p0_cfg_next | p0_hold;

assign cq_occ_int_valid = cq_occ_int_v & ~cq_occ_int_busy;

//-----------------------------------------------------------------------------------------------------
// P1

assign p1_hold = p1_v_q &  p2_hold;
assign p1_load = p0_v_q & ~p1_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p1_v_q      <= '0;
  p1_cfg_q    <= '0;
  p1_cfg_we_q <= '0;
 end else if (~p1_hold) begin
  p1_v_q      <= p0_v_q & (~p0_cfg_we_q | (&p2_cfg_we_q));
  p1_cfg_q    <= p0_cfg_q;
  p1_cfg_we_q <= p0_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p1_load) begin
  if (~p0_cfg_q) p1_data_q <= p0_data_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// P2

// Throw away requests with parity errors on the table lookups or input data
// The int_d parity from the core is odd

assign p2_perr  = p2_v_q & ~p2_cfg_q & ~(^p2_data_q);

assign p2_v     = p2_v_q & ~p2_cfg_q & ~(|{lut_perr[1:0], p2_perr});
assign p2_hold  = p2_v   &  p3_hold;
assign p2_load  = p1_v_q & ~p2_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p2_v_q       <= '0;
  p2_cfg_q     <= '0;
  p2_cfg_we_q  <= '0;
  p3_perr_q    <= '0;
 end else begin
  if (~p2_hold) begin
   p2_v_q      <= p1_v_q;
   p2_cfg_q    <= p1_cfg_q;
   p2_cfg_we_q <= {p1_cfg_we_q, p2_cfg_we_q[1]};
  end
  p3_perr_q    <= p2_perr;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p2_load) begin
  if (~p1_cfg_q) p2_data_q <= p1_data_q;
 end
end

assign p3_hold = '0;    // Nothing holds up this pipe

assign alarm_int_error = p3_perr_q;

//-----------------------------------------------------------------------------------------------------
// Interrupt LUTs

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ISR)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ISR)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_ISR)

) i_lut_dir_cq_isr (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[0])

        ,.cfg_re                (cfg_re_v.dir_cq_isr)
        ,.cfg_we                (cfg_we_v.dir_cq_isr)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ISR-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ISR-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_cq_isr)

        ,.memi                  (memi_lut_dir_cq_isr)

        ,.memo                  (memo_lut_dir_cq_isr)

        ,.lut_re                (cq_occ_int_valid)
        ,.lut_addr              (cq_occ_int.cq_occ_cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (cq_occ_int.is_ldb)

        ,.lut_rdata             ({p2_int_code_dir, p2_int_vf_dir, p2_int_vec_dir})
        ,.lut_perr              (lut_perr[0])

        ,.lut_hold              (1'b0)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ISR)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ISR)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_ISR)

) i_lut_ldb_cq_isr (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[1])

        ,.cfg_re                (cfg_re_v.ldb_cq_isr)
        ,.cfg_we                (cfg_we_v.ldb_cq_isr)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ISR-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ISR-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_cq_isr)

        ,.memi                  (memi_lut_ldb_cq_isr)

        ,.memo                  (memo_lut_ldb_cq_isr)

        ,.lut_re                (cq_occ_int_valid)
        ,.lut_addr              (cq_occ_int.cq_occ_cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (~cq_occ_int.is_ldb)

        ,.lut_rdata             ({p2_int_code_ldb, p2_int_vf_ldb, p2_int_vec_ldb})
        ,.lut_perr              (lut_perr[1])

        ,.lut_hold              (1'b0)
);

assign p2_int_code = p2_int_code_ldb | p2_int_code_dir;
assign p2_int_vf   = p2_int_vf_ldb   | p2_int_vf_dir;
assign p2_int_vec  = p2_int_vec_ldb  | p2_int_vec_dir;

// No need to hold up the LUT pipeline since we just set bits in the ai, msix, or msi arbiter input regs

//-----------------------------------------------------------------------------------------------------
// Form AI requests for CQ occupancy

hqm_AW_width_scale #(.A_WIDTH(NUM_DIR_CQ+NUM_LDB_CQ), .Z_WIDTH(1<<AI_VEC_WIDTH)) i_ai_mask_scaled (

     .a         (ims_mask)
    ,.z         (ai_mask_scaled)
);

// Create one-hot IMS pending vector clear from the cfg input fields

hqm_AW_bindec #(.WIDTH(AI_VEC_WIDTH)) i_ai_pend_clear (

     .a         (ims_pend_clear.VEC[AI_VEC_WIDTH-1:0])
    ,.enable    (ims_pend_clear.VALID)

    ,.dec       (ai_pend_clear)
);

// If a mask bit gets turned off for a pending IMS, need to generate a new IMS for that bit
// into the request vector.  Ignore if the software clear is on for the same bit.

assign ai_pend_v  = ai_pend_q & ~ims_mask & ~ai_pend_clear[NUM_DIR_CQ+NUM_LDB_CQ-1:0];

// Using the (unused in IMS mode) VF fields of the ISR table lookup to extend the VEC field
// to support the full range of IMS vectors.

assign ai_int_vec = {p2_int_vf[AI_VEC_WIDTH-$bits(p2_int_vec)-1:0], p2_int_vec};

always_comb begin

 // Default request vector is current vector ORed with any pending bits no longer masked.

 ai_arb_reqs_next = '0;
 ai_arb_reqs_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0] = ai_arb_reqs_q | ai_pend_v;

 for (int i=0; i<(1<<AI_VEC_WIDTH); i=i+1) begin
  if (i<(NUM_DIR_CQ+NUM_LDB_CQ)) begin
   ai_arb_ldb_next[i] = (ai_arb_reqs_q[i]) ? ai_arb_ldb_q[ i] :
                        ((ai_pend_v[   i]) ? ai_pend_ldb_q[i] : '0);
   ai_arb_cq_next[ i] = (ai_arb_reqs_q[i]) ? ai_arb_cq_q[  i] :
                        ((ai_pend_v[   i]) ? ai_pend_cq_q[ i] : '0);
  end else begin
   ai_arb_ldb_next[i] = '0;
   ai_arb_cq_next[ i] = '0;
  end
 end

 // Default pending vector is current vector ANDed with the mask field since any bits with
 // the mask not set will be being pushed into the request vector by ai_pend_v above and we
 // then need to reset those bits.  The software clear can also reset bits.

 ai_pend_next = '0;
 ai_pend_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0] = ai_pend_q & ims_mask & ~ai_pend_clear[NUM_DIR_CQ+NUM_LDB_CQ-1:0];

 // Default of pending ldb/cq bits is to hold

 ai_pend_ldb_next = '0;
 ai_pend_ldb_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0] = ai_pend_ldb_q;

 for (int i=0; i<(1<<AI_VEC_WIDTH); i=i+1) begin
  if (i < (NUM_DIR_CQ+NUM_LDB_CQ)) begin
   ai_pend_cq_next[i] = ai_pend_cq_q[i];
  end else begin
   ai_pend_cq_next[i] = '0;
  end
 end

 // Reset a request bit if the arbiter consumed it.

 if (ai_arb_update) ai_arb_reqs_next[ai_arb_winner] = 1'b0; 

 // If the ISR table lookup says this is an IMS and we are not masked, then set the request
 // vector bit.  If we are masked, set the pending vector bit instead unless the software
 // clear is active for that bit.

 if (p2_v & (p2_int_code == 2'd3)) begin
  if (ai_mask_scaled[ai_int_vec]) begin
   ai_pend_next[    ai_int_vec] = ~ai_pend_clear[ai_int_vec];
   ai_pend_ldb_next[ai_int_vec] = p2_data_q.is_ldb;
   ai_pend_cq_next[ ai_int_vec] = p2_data_q.cq_occ_cq[HQM_SYSTEM_CQ_WIDTH-1:0];
  end else begin
   ai_arb_reqs_next[ai_int_vec] = 1'b1;                 
   ai_arb_ldb_next[ ai_int_vec] = p2_data_q.is_ldb;
   ai_arb_cq_next[  ai_int_vec] = p2_data_q.cq_occ_cq[HQM_SYSTEM_CQ_WIDTH-1:0];
  end
 end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ai_arb_reqs_q <= '0;
  ai_pend_q     <= '0;
 end else begin
  ai_arb_reqs_q <= ai_arb_reqs_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0];
  ai_pend_q     <= ai_pend_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0];
 end
end

always_ff @(posedge hqm_gated_clk) begin
  ai_arb_ldb_q  <= ai_arb_ldb_next[ NUM_DIR_CQ+NUM_LDB_CQ-1:0];
  ai_pend_ldb_q <= ai_pend_ldb_next[NUM_DIR_CQ+NUM_LDB_CQ-1:0];
  for (int i=0; i<(NUM_DIR_CQ+NUM_LDB_CQ); i=i+1) begin
   ai_arb_cq_q[ i] <= ai_arb_cq_next[ i];
   ai_pend_cq_q[i] <= ai_pend_cq_next[i];
  end
end

// Export the IMS pending vector so software can read it in the AI_CTRL.IMS_PEND fields.

assign ims_pend = ai_pend_q;

hqm_AW_rr_arbiter #(.NUM_REQS(NUM_DIR_CQ+NUM_LDB_CQ)) i_ai_arb (

     .clk           (hqm_gated_clk)
    ,.rst_n         (hqm_gated_rst_n)

    ,.mode          (2'd2)
    ,.update        (ai_arb_update)

    ,.reqs          (ai_arb_reqs_q)

    ,.winner_v      (ai_arb_winner_v)
    ,.winner        (ai_arb_winner)
);

assign ai_arb_update = ai_tbl_ack;

assign ai_tbl_req    = ai_arb_winner_v;
assign ai_tbl_vec    = ai_arb_winner;

// This arbitration winner feeds into the AI table lookup pipe to read the AI addr/data, which
// then feeds into the function arbiter to select from either this single AI path or the MSI-X path.

//-----------------------------------------------------------------------------------------------------
// Pipeline for AI table access

assign ai_p0_cfg_next = |{cfg_we_in_ai, cfg_re_in_ai};

assign ai_p0_v_next   = cfg_taken_ai | ai_tbl_ack;

assign cfg_taken_ai   = ai_p0_cfg_next & ~|{ai_p0_v_q, ai_p1_v_q, ai_p2_v_q};

assign ai_p0_hold = ai_p0_v_q & (ai_p1_hold | (ai_p0_cfg_we_q & ~(&ai_p2_cfg_we_q)));
assign ai_p0_load = ai_p0_v_next;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ai_p0_v_q      <= '0;
  ai_p0_cfg_q    <= '0;
  ai_p0_cfg_we_q <= '0;
 end else if (~ai_p0_hold) begin
  ai_p0_v_q      <= ai_p0_v_next;
  ai_p0_cfg_q    <= ai_p0_cfg_next;
  ai_p0_cfg_we_q <= ai_p0_v_next & cfg_we_in_ai;
 end
end

hqm_AW_width_scale #(.A_WIDTH(NUM_DIR_CQ+NUM_LDB_CQ), .Z_WIDTH(1<<AI_VEC_WIDTH)) i_ai_arb_ldb_scaled (

     .a         (ai_arb_ldb_q)
    ,.z         (ai_arb_ldb_scaled)
);

always_comb begin
 for (int i=0; i<(1<<AI_VEC_WIDTH); i=i+1) begin
  if (i < (NUM_DIR_CQ+NUM_LDB_CQ)) begin
   ai_arb_cq_scaled[i] = ai_arb_cq_q[i];
  end else begin
   ai_arb_cq_scaled[i] = '0;
  end
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (ai_p0_load) begin
  ai_p0_vec_q <= ai_tbl_vec;
  ai_p0_ldb_q <= ai_arb_ldb_scaled[ai_arb_winner];
  ai_p0_cq_q  <= ai_arb_cq_scaled[ ai_arb_winner];
 end
end

assign ai_tbl_ack = rst_done_q & ai_tbl_req & ~(ai_p0_cfg_next | ai_p0_hold);

//-----------------------------------------------------------------------------------------------------
// AI P1

assign ai_p1_hold = ai_p1_v_q &  ai_p2_hold;
assign ai_p1_load = ai_p0_v_q & ~ai_p1_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ai_p1_v_q      <= '0;
  ai_p1_cfg_q    <= '0;
  ai_p1_cfg_we_q <= '0;
 end else if (~ai_p1_hold) begin
  ai_p1_v_q      <= ai_p0_v_q & (~ai_p0_cfg_we_q | (&ai_p2_cfg_we_q));
  ai_p1_cfg_q    <= ai_p0_cfg_q;
  ai_p1_cfg_we_q <= ai_p0_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (ai_p1_load) begin
  ai_p1_vec_q <= ai_p0_vec_q;
  ai_p1_ldb_q <= ai_p0_ldb_q;
  ai_p1_cq_q  <= ai_p0_cq_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// AI P2

assign ai_p2_v     = ai_p2_v_q & ~ai_p2_cfg_q;
assign ai_p2_hold  = ai_p2_v   &  ai_tbl_hold;
assign ai_p2_load  = ai_p1_v_q & ~ai_p2_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ai_p2_v_q      <= '0;
  ai_p2_cfg_q    <= '0;
  ai_p2_cfg_we_q <= '0;
 end else if (~ai_p2_hold) begin
  ai_p2_v_q      <= ai_p1_v_q;
  ai_p2_cfg_q    <= ai_p1_cfg_q;
  ai_p2_cfg_we_q <= {ai_p1_cfg_we_q, ai_p2_cfg_we_q[1]};
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (ai_p2_load) begin
  ai_p2_vec_q <= ai_p1_vec_q;
  ai_p2_ldb_q <= ai_p1_ldb_q;
  ai_p2_cq_q  <= ai_p1_cq_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// Since the AI_ADDR_L, AI_ADDR_U, and AI_DATA memories were implemented as separate DIR and LDB
// pairs, and now we are defining them in the RDL as a single structure w/o the DIR/LDB distinction,
// and we don't want to modify the memories, we need to form the separate re and we signals for each
// of the pairs of memories based on the address.

assign cfg_addr_ldb   = cfg_addr_q - NUM_DIR_CQ[7:0];
assign ai_tbl_vec_ldb = ai_tbl_vec - NUM_DIR_CQ[AI_VEC_WIDTH-1:0];

assign cfg_addr_q_dir_cq = (cfg_addr_q < NUM_DIR_CQ[7:0]);
assign cfg_addr_q_ldb_cq = ~cfg_addr_q_dir_cq;

assign cfg_re_dir_cq_ai_addr_l = cfg_re_v.ai_addr_l & cfg_addr_q_dir_cq;
assign cfg_re_ldb_cq_ai_addr_l = cfg_re_v.ai_addr_l & cfg_addr_q_ldb_cq;
assign cfg_we_dir_cq_ai_addr_l = cfg_we_v.ai_addr_l & cfg_addr_q_dir_cq;
assign cfg_we_ldb_cq_ai_addr_l = cfg_we_v.ai_addr_l & cfg_addr_q_ldb_cq;
assign cfg_re_dir_cq_ai_addr_u = cfg_re_v.ai_addr_u & cfg_addr_q_dir_cq;
assign cfg_re_ldb_cq_ai_addr_u = cfg_re_v.ai_addr_u & cfg_addr_q_ldb_cq;
assign cfg_we_dir_cq_ai_addr_u = cfg_we_v.ai_addr_u & cfg_addr_q_dir_cq;
assign cfg_we_ldb_cq_ai_addr_u = cfg_we_v.ai_addr_u & cfg_addr_q_ldb_cq;
assign cfg_re_dir_cq_ai_data   = cfg_re_v.ai_data   & cfg_addr_q_dir_cq;
assign cfg_re_ldb_cq_ai_data   = cfg_re_v.ai_data   & cfg_addr_q_ldb_cq;
assign cfg_we_dir_cq_ai_data   = cfg_we_v.ai_data   & cfg_addr_q_dir_cq;
assign cfg_we_ldb_cq_ai_data   = cfg_we_v.ai_data   & cfg_addr_q_ldb_cq;

assign ai_tbl_dir = (ai_tbl_vec < NUM_DIR_CQ[AI_VEC_WIDTH-1:0]);
assign ai_tbl_ldb = ~ai_tbl_dir;

//-----------------------------------------------------------------------------------------------------

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_L)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_L)

) i_lut_dir_cq_ai_addr_l (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[2])

        ,.cfg_re                (cfg_re_dir_cq_ai_addr_l)
        ,.cfg_we                (cfg_we_dir_cq_ai_addr_l)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_L-1:0])
        ,.cfg_wdata             (cfg_wdata_q[31:(32-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L)])                // left justified

        ,.cfg_rdata             ({cfg_rdata_lut.ai_addr_l[(31-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L):0]     // left justified
                                 ,cfg_rdata_lut.ai_addr_l[31:(32-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L)]    // left justified
                                })

        ,.memi                  (memi_lut_dir_cq_ai_addr_l)

        ,.memo                  (memo_lut_dir_cq_ai_addr_l)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_ldb)

        ,.lut_rdata             (ai_p2_addr_dir[31:2])
        ,.lut_perr              (lut_perr[2])

        ,.lut_hold              (ai_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_U)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_U)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_U)

) i_lut_dir_cq_ai_addr_u (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[3])

        ,.cfg_re                (cfg_re_dir_cq_ai_addr_u)
        ,.cfg_we                (cfg_we_dir_cq_ai_addr_u)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_U-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_U-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ai_addr_u)

        ,.memi                  (memi_lut_dir_cq_ai_addr_u)

        ,.memo                  (memo_lut_dir_cq_ai_addr_u)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_ldb)

        ,.lut_rdata             (ai_p2_addr_dir[63:32])
        ,.lut_perr              (lut_perr[3])

        ,.lut_hold              (ai_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_L)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_L)

) i_lut_ldb_cq_ai_addr_l (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[4])

        ,.cfg_re                (cfg_re_ldb_cq_ai_addr_l)
        ,.cfg_we                (cfg_we_ldb_cq_ai_addr_l)
        ,.cfg_addr              (cfg_addr_ldb[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_L-1:0])
        ,.cfg_wdata             (cfg_wdata_q[31:(32-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L)])                    // left justified

        ,.cfg_rdata             ({cfg_rdata_lut_ai_addr_l_ldb[(31-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L):0]     // left justified
                                 ,cfg_rdata_lut_ai_addr_l_ldb[31:(32-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L)]    // left justified
                                })

        ,.memi                  (memi_lut_ldb_cq_ai_addr_l)

        ,.memo                  (memo_lut_ldb_cq_ai_addr_l)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec_ldb[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_dir)

        ,.lut_rdata             (ai_p2_addr_ldb[31:2])
        ,.lut_perr              (lut_perr[4])

        ,.lut_hold              (ai_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_U)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_U)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_U)

) i_lut_ldb_cq_ai_addr_u (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[5])

        ,.cfg_re                (cfg_re_ldb_cq_ai_addr_u)
        ,.cfg_we                (cfg_we_ldb_cq_ai_addr_u)
        ,.cfg_addr              (cfg_addr_ldb[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_U-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_U-1:0])

        ,.cfg_rdata             (cfg_rdata_lut_ai_addr_u_ldb)

        ,.memi                  (memi_lut_ldb_cq_ai_addr_u)

        ,.memo                  (memo_lut_ldb_cq_ai_addr_u)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec_ldb[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_dir)

        ,.lut_rdata             (ai_p2_addr_ldb[63:32])
        ,.lut_perr              (lut_perr[5])

        ,.lut_hold              (ai_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_DATA)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_DATA)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_DATA)

) i_lut_dir_cq_ai_data (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[6])

        ,.cfg_re                (cfg_re_dir_cq_ai_data)
        ,.cfg_we                (cfg_we_dir_cq_ai_data)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_DATA-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_DATA-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ai_data)

        ,.memi                  (memi_lut_dir_cq_ai_data)

        ,.memo                  (memo_lut_dir_cq_ai_data)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_ldb)

        ,.lut_rdata             (ai_p2_data_dir)
        ,.lut_perr              (lut_perr[6])

        ,.lut_hold              (ai_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_DATA)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_DATA)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_DATA)

) i_lut_ldb_cq_ai_data (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[7])

        ,.cfg_re                (cfg_re_ldb_cq_ai_data)
        ,.cfg_we                (cfg_we_ldb_cq_ai_data)
        ,.cfg_addr              (cfg_addr_ldb[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_DATA-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_DATA-1:0])

        ,.cfg_rdata             (cfg_rdata_lut_ai_data_ldb)

        ,.memi                  (memi_lut_ldb_cq_ai_data)

        ,.memo                  (memo_lut_ldb_cq_ai_data)

        ,.lut_re                (ai_tbl_ack)
        ,.lut_addr              (ai_tbl_vec_ldb[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (ai_tbl_dir)

        ,.lut_rdata             (ai_p2_data_ldb)
        ,.lut_perr              (lut_perr[7])

        ,.lut_hold              (ai_tbl_hold)
);

assign ai_p2_addr  = ai_p2_addr_ldb  | ai_p2_addr_dir;
assign ai_p2_data  = ai_p2_data_ldb  | ai_p2_data_dir;

assign ai_tbl_hold = ai_p2_v & ~(|lut_perr[7:2]) & ~func_arb_winner_dec[1];

//-----------------------------------------------------------------------------------------------------
// Form MSI-X requests for CQ occupancy, alarm, or pending that have become enabled
//
// CQ occupancy int requests should map to PF MSI-X interrupt vectors 1-64
// CWD and alarm int requests should map to PF MSI-X interrupt vector 0

// Force the cq_occ msix vector to 1 in the msix_mode.MODE==1 case
// In this mode all of the following are true:
//  All cq occupancy MSI-X requests are consolidated into MSI-X vector 1.
//  We set msix_ack[1] to indicate MSI-X[1] is pending and to hold off sending out additional
//  MSI-X[1]s until the pending status is cleared by SW.  If the passthrough mode is enabled
//  for MSI-X[1], we will always send out the request even if msix_ack[1] is set.
//  We set a per CQ per dir/ldb bit to indicate which CQs have pending MSI-X[1] requests.
//  SW should clear the bits in those vectors for the CQs it services before clearing the
//  msix_ack[1] bit.  If we have bits set in those vectors when msix_ack[1] is cleared,
//  force an additional MSI-X[1] request into the pipe.

assign p2_int_vec_p1 = (msix_mode.MODE) ? 7'd1 : (p2_int_vec + 7'd1);

hqm_AW_width_scale #(.A_WIDTH(7), .Z_WIDTH(HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)) i_cq_occ_msix_vec (

     .a         (p2_int_vec_p1)
    ,.z         (cq_occ_msix_vec)
);

// CQ occupancy MSI-X request if bottom of isr lookup pipeline is valid, MSI-X is enabled, the
// looked up isr int_code==2, and the interrupt vector is not already pending.  If we are in
// msix_mode.MODE==1, then we will also generate a request on the clearing of msix_ack[1] if we
// have any bits still set in either of the cq_occ_int_status regs.
// Masked if function mask is asserted or per vector mask bit from MSI-X table is set
// Request is valid if not masked; if request is asserted but masked, then set pending bit

assign cq_occ_inta_req  = p2_v & (p2_int_code == 2'd2);
assign cq_occ_msix_req  = cq_occ_inta_req & (~msix_mode.MODE | msix_passthrough[1] |
                            ~(msix_ack[1] | set_msix_ack_q[1] | set_msix_ack_next[1]));
assign cq_occ_msix_mask = pci_cfg_pmsixctl_fm | msix_tbl_mask_scaled[cq_occ_msix_vec];
assign cq_occ_msix_v    = (cq_occ_msix_req | cq_occ_msix_push_req) & ~cq_occ_msix_mask;
assign cq_occ_msix_setp = (cq_occ_msix_req | cq_occ_msix_push_req) &  cq_occ_msix_mask;

assign cq_occ_msix_push_req = msix_mode.MODE & ~cq_occ_ack_q[1] & cq_occ_ack_q[0] &
                                ~cq_occ_msix_req_q &
                                (|{dir_cq_63_32_occ_int_status
                                  ,dir_cq_31_0_occ_int_status
                                  ,ldb_cq_63_32_occ_int_status
                                  ,ldb_cq_31_0_occ_int_status});

hqm_AW_bindec #(.WIDTH(HQM_SYSTEM_CQ_WIDTH)) i_cq_occ_decode_next (

     .a             (p2_data_q.cq_occ_cq[HQM_SYSTEM_CQ_WIDTH-1:0])
    ,.enable        (cq_occ_inta_req)

    ,.dec           (cq_occ_decode_next)
);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cq_occ_decode_q   <= '0;
  cq_occ_is_ldb_q   <= '0;
  cq_occ_ack_q      <= '0;
  cq_occ_msix_req_q <= '0;
 end else begin
  if (|{cq_occ_inta_req, cq_occ_decode_q}) cq_occ_decode_q <= cq_occ_decode_next[HQM_SYSTEM_NUM_CQ-1:0];
  if (cq_occ_inta_req) cq_occ_is_ldb_q <= p2_data_q.is_ldb;
  cq_occ_ack_q      <= {msix_ack[1], cq_occ_ack_q[1]};
  cq_occ_msix_req_q <= cq_occ_msix_req;
 end
end

assign {set_dir_cq_63_32_occ_int_status
       ,set_dir_cq_31_0_occ_int_status} = cq_occ_decode_q[NUM_DIR_CQ-1:0] & ~{NUM_DIR_CQ{cq_occ_is_ldb_q}};

assign {set_ldb_cq_63_32_occ_int_status
       ,set_ldb_cq_31_0_occ_int_status} = cq_occ_decode_q[NUM_LDB_CQ-1:0] &  {NUM_LDB_CQ{cq_occ_is_ldb_q}};

// Alarm MSI-X request if alarm input is valid, MSI-X is enabled and the interrupt vector is not
// already pending
// Masked if function mask is asserted or per vector mask bit from MSI-X table is set
// Request is valid if not masked; if request is asserted but masked, then set pending bit

assign alarm_msix_req   = alarm_reqs_q & (msix_passthrough[0] |
                            ~(msix_ack[0] | set_msix_ack_q[0] | set_msix_ack_next[0]));
assign alarm_msix_mask  = pci_cfg_pmsixctl_fm | msix_tbl_mask_scaled[0];
assign alarm_msix_v     = alarm_msix_req & ~alarm_msix_mask;
assign alarm_msix_setp  = alarm_msix_req &  alarm_msix_mask;

//-----------------------------------------------------------------------------------------------------
// MSI-X pending bits set when a request is valid but masked; they reset when the request is put into
// the MSI-X arbiter's input register.
// Do we need a method for software to be able to clear the pending bits to support polling mode?

always_comb begin

 // Valid PBA MSI-X requests if msix_pba bit is set, MSI-X is enabled, function mask is not asserted,
 // per vector mask is not asserted, and the interrupt vector is not already pending

 msix_pba_v = msix_pba_q & ~msix_tbl_mask & ~msix_arb_reqs_q & {HQM_SYSTEM_NUM_MSIX{(~pci_cfg_pmsixctl_fm)}};

 msix_pba_next = '0;
 msix_pba_next[HQM_SYSTEM_NUM_MSIX-1:0] = msix_pba_q & ~msix_pba_v;

 msix_pba_ldb_next = '0;
 msix_pba_ldb_next[HQM_SYSTEM_NUM_MSIX-1:0] = msix_pba_ldb_q;

 for (int i=0; i<(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD); i=i+1) begin
  if (i<HQM_SYSTEM_NUM_MSIX) begin
   msix_pba_cq_next[i] = msix_pba_cq_q[i];
  end else begin
   msix_pba_cq_next[i] = '0;
  end
 end

 if (alarm_msix_setp) begin
  msix_pba_next[    0] = '1;     
  msix_pba_ldb_next[0] = '0;
  msix_pba_cq_next[ 0] = '0;
 end

 if (cq_occ_msix_setp) begin
  msix_pba_next[    cq_occ_msix_vec] = '1;     
  msix_pba_ldb_next[cq_occ_msix_vec] = p2_data_q.is_ldb;
  msix_pba_cq_next[ cq_occ_msix_vec] = p2_data_q.cq_occ_cq[HQM_SYSTEM_CQ_WIDTH-1:0];
 end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  msix_pba_q <= '0;
 end else begin
  msix_pba_q <= msix_pba_next[HQM_SYSTEM_NUM_MSIX-1:0] & {HQM_SYSTEM_NUM_MSIX{pci_cfg_pmsixctl_msie}} &
                ~cfg_msix_pba_clear;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 msix_pba_ldb_q <= msix_pba_ldb_next[HQM_SYSTEM_NUM_MSIX-1:0];
 msix_pba_cq_q  <= msix_pba_cq_next[ HQM_SYSTEM_NUM_MSIX-1:0];
end

assign msix_pba = msix_pba_q;

//-----------------------------------------------------------------------------------------------------
// MSI-X arbiter input reg's default is to hold current set of requests, setting bits for new requests
// from any of the sources, and only resets a bit when that request has been accepted by the MSI-X
// table lookup pipeline for output to the write buffer.

always_comb begin

 msix_arb_reqs_next = '0;
 msix_arb_reqs_next[HQM_SYSTEM_NUM_MSIX-1:0] = msix_arb_reqs_q |  msix_pba_v;

 for (int i=0; i<(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD); i=i+1) begin
  if (i<HQM_SYSTEM_NUM_MSIX) begin
   msix_arb_ldb_next[i] = (msix_arb_reqs_q[i]) ? msix_arb_ldb_q[i] :
                          ((msix_pba_v[    i]) ? msix_pba_ldb_q[i] : '0);
   msix_arb_cq_next[ i] = (msix_arb_reqs_q[i]) ? msix_arb_cq_q[ i] :
                          ((msix_pba_v[    i]) ? msix_pba_cq_q[ i] : '0);
  end else begin
   msix_arb_ldb_next[i] = '0;
   msix_arb_cq_next[ i] = '0;
  end
 end

 if (msix_tbl_ack) msix_arb_reqs_next[   msix_tbl_vec] = 1'b0;    

 if (alarm_msix_v) begin
  msix_arb_reqs_next[0] = '1;       
  msix_arb_ldb_next[ 0] = '0;
  msix_arb_cq_next[  0] = '0;
 end

 if (cq_occ_msix_v) begin
  msix_arb_reqs_next[cq_occ_msix_vec] = 1'b1;       
  msix_arb_ldb_next[ cq_occ_msix_vec] = p2_data_q.is_ldb;
  msix_arb_cq_next[  cq_occ_msix_vec] = p2_data_q.cq_occ_cq[HQM_SYSTEM_CQ_WIDTH-1:0];
 end

end

assign enable_msix_ack_dec = msix_tbl_ack & (({{(32-HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD){1'b0}}, msix_tbl_vec} == 0)
                         | (msix_mode.MODE & ({{(32-HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD){1'b0}}, msix_tbl_vec} == 1)));

hqm_AW_bindec #(.WIDTH(1)) i_set_msix_ack_next (

     .a             (msix_tbl_vec[0])
    ,.enable        (enable_msix_ack_dec)

    ,.dec           (set_msix_ack_next)
);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  msix_arb_reqs_q <= '0;
  set_msix_ack_q  <= '0;
 end else begin
  msix_arb_reqs_q <= msix_arb_reqs_next[HQM_SYSTEM_NUM_MSIX-1:0] & {HQM_SYSTEM_NUM_MSIX{pci_cfg_pmsixctl_msie}};
  set_msix_ack_q  <= set_msix_ack_next[1:0];
 end
end

always_ff @(posedge hqm_gated_clk) begin
 msix_arb_ldb_q <= msix_arb_ldb_next[HQM_SYSTEM_NUM_MSIX-1:0];
 msix_arb_cq_q  <= msix_arb_cq_next[ HQM_SYSTEM_NUM_MSIX-1:0];
end

assign set_msix_ack = set_msix_ack_q;

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_NUM_MSIX), .Z_WIDTH(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)) i_msix_arb_ldb_scaled (

     .a     (msix_arb_ldb_q)
    ,.z     (msix_arb_ldb_scaled)
);

always_comb begin
 for (int i=0; i<(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD); i=i+1) begin
  if (i < HQM_SYSTEM_NUM_MSIX) begin
   msix_arb_cq_scaled[i] = msix_arb_cq_q[i];
  end else begin
   msix_arb_cq_scaled[i] = '0;
  end
 end
end

//-----------------------------------------------------------------------------------------------------
// MSI-X arbiter

assign msix_arb_update = msix_tbl_ack;

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SYSTEM_NUM_MSIX)) i_msix_arb (

     .clk           (hqm_gated_clk)
    ,.rst_n         (hqm_gated_rst_n)

    ,.mode          (2'd2)
    ,.update        (msix_arb_update)

    ,.reqs          (msix_arb_reqs_q)

    ,.winner_v      (msix_arb_winner_v)
    ,.winner        (msix_arb_winner)
);

assign msix_tbl_req = msix_arb_winner_v;
assign msix_tbl_vec = msix_arb_winner;
assign msix_tbl_ldb = msix_arb_ldb_scaled[msix_arb_winner];
assign msix_tbl_cq  = msix_arb_cq_scaled[ msix_arb_winner];

// This arbitration winner feeds into the MSI-X table lookup pipe to read the MSI-X addr/data, which
// then feeds into the function arbiter to select from either this single MSI-X path or the AI path.

//-----------------------------------------------------------------------------------------------------
// Pipeline for MSI-X table access

assign msix_p0_cfg_next = |{cfg_we_in_msix, cfg_re_in_msix};

assign msix_p0_v_next   = cfg_taken_msix | msix_tbl_ack;

assign cfg_taken_msix   = msix_p0_cfg_next & ~|{msix_p0_v_q, msix_p1_v_q, msix_p2_v_q};

assign msix_p0_hold = msix_p0_v_q & (msix_p1_hold | (msix_p0_cfg_we_q & ~(&msix_p2_cfg_we_q)));
assign msix_p0_load = msix_p0_v_next;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  msix_p0_v_q      <= '0;
  msix_p0_cfg_q    <= '0;
  msix_p0_cfg_we_q <= '0;
 end else if (~msix_p0_hold) begin
  msix_p0_v_q      <= msix_p0_v_next;
  msix_p0_cfg_q    <= msix_p0_cfg_next;
  msix_p0_cfg_we_q <= msix_p0_v_next & cfg_we_in_msix;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (msix_p0_load) begin
  msix_p0_vec_q <= msix_tbl_vec;
  msix_p0_ldb_q <= msix_tbl_ldb;
  msix_p0_cq_q  <= msix_tbl_cq;
 end
end

assign msix_tbl_ack = rst_done_q & msix_tbl_req & ~(msix_p0_cfg_next | msix_p0_hold);

//-----------------------------------------------------------------------------------------------------
// MSIX P1

assign msix_p1_hold = msix_p1_v_q &  msix_p2_hold;
assign msix_p1_load = msix_p0_v_q & ~msix_p1_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  msix_p1_v_q      <= '0;
  msix_p1_cfg_q    <= '0;
  msix_p1_cfg_we_q <= '0;
 end else if (~msix_p1_hold) begin
  msix_p1_v_q      <= msix_p0_v_q & (~msix_p0_cfg_we_q | (&msix_p2_cfg_we_q));
  msix_p1_cfg_q    <= msix_p0_cfg_q;
  msix_p1_cfg_we_q <= msix_p0_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (msix_p1_load) begin
  msix_p1_vec_q <= msix_p0_vec_q;
  msix_p1_ldb_q <= msix_p0_ldb_q;
  msix_p1_cq_q  <= msix_p0_cq_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// MSIX P2

assign msix_p2_v     = msix_p2_v_q & ~msix_p2_cfg_q;
assign msix_p2_hold  = msix_p2_v   &  msix_tbl_hold;
assign msix_p2_load  = msix_p1_v_q & ~msix_p2_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  msix_p2_v_q      <= '0;
  msix_p2_cfg_q    <= '0;
  msix_p2_cfg_we_q <= '0;
 end else if (~msix_p2_hold) begin
  msix_p2_v_q      <= msix_p1_v_q;
  msix_p2_cfg_q    <= msix_p1_cfg_q;
  msix_p2_cfg_we_q <= {msix_p1_cfg_we_q, msix_p2_cfg_we_q[1]};
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (msix_p2_load) begin
  msix_p2_vec_q <= msix_p1_vec_q;
  msix_p2_ldb_q <= msix_p1_ldb_q;
  msix_p2_cq_q  <= msix_p1_cq_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// MSI-X Table
//
// One 32b LUT for each of the first 3 MSI-X table words and local flop storage for the single per
// vector mask bits so we can look at all of them in parallel for deciding if we have pending vectors
// (in the msix_pba) that have become unmasked by software and need to go out.

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_MSIX_TBL_WORD)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)
        ,.PACK                  (HQM_SYSTEM_PACK_MSIX_TBL_WORD)

) i_lut_msix_msg_addr_l (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[8])

        ,.cfg_re                (cfg_re_v.msg_addr_l)
        ,.cfg_we                (cfg_we_v.msg_addr_l)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.msg_addr_l)

        ,.memi                  (memi_msix_tbl_word0i)

        ,.memo                  (memo_msix_tbl_word0i)

        ,.lut_re                (msix_tbl_ack)
        ,.lut_addr              (msix_tbl_vec)
        ,.lut_nord              (1'b0)

        ,.lut_rdata             (msix_tbl_rdata_addr[0 +: HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD])
        ,.lut_perr              (lut_perr[8])

        ,.lut_hold              (msix_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_MSIX_TBL_WORD)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)
        ,.PACK                  (HQM_SYSTEM_PACK_MSIX_TBL_WORD)

) i_lut_msix_msg_addr_u (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[9])

        ,.cfg_re                (cfg_re_v.msg_addr_u)
        ,.cfg_we                (cfg_we_v.msg_addr_u)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.msg_addr_u)

        ,.memi                  (memi_msix_tbl_word1i)

        ,.memo                  (memo_msix_tbl_word1i)

        ,.lut_re                (msix_tbl_ack)
        ,.lut_addr              (msix_tbl_vec)
        ,.lut_nord              (1'b0)

        ,.lut_rdata             (msix_tbl_rdata_addr[HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD +:
                                                     HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD])
        ,.lut_perr              (lut_perr[9])

        ,.lut_hold              (msix_tbl_hold)
);

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_MSIX_TBL_WORD)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)
        ,.PACK                  (HQM_SYSTEM_PACK_MSIX_TBL_WORD)

) i_lut_msix_msg_data (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[10])

        ,.cfg_re                (cfg_re_v.msg_data)
        ,.cfg_we                (cfg_we_v.msg_data)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.msg_data)

        ,.memi                  (memi_msix_tbl_word2i)

        ,.memo                  (memo_msix_tbl_word2i)

        ,.lut_re                (msix_tbl_ack)
        ,.lut_addr              (msix_tbl_vec)
        ,.lut_nord              (1'b0)

        ,.lut_rdata             (msix_tbl_rdata_data)
        ,.lut_perr              (lut_perr[10])

        ,.lut_hold              (msix_tbl_hold)
);

// Since MSIX table is 65 deep, storing first 64 entries for words 0-2 in an RF and
// last entry in a local reg.

logic                                           msix_tbl_word0_ms_re_q;
logic                                           msix_tbl_word1_ms_re_q;
logic                                           msix_tbl_word2_ms_re_q;

logic   [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD-1:0]  msix_tbl_word0_ms_q;
logic   [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD-1:0]  msix_tbl_word1_ms_q;
logic   [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD-1:0]  msix_tbl_word2_ms_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin

  msix_tbl_word0_ms_re_q <= '0;
  msix_tbl_word1_ms_re_q <= '0;
  msix_tbl_word2_ms_re_q <= '0;

  msix_tbl_word0_ms_q    <= '0;
  msix_tbl_word1_ms_q    <= '0;
  msix_tbl_word2_ms_q    <= '0;

 end else begin

  // Save indication that the access was a read to the MS table entry (local reg)

  if (memi_msix_tbl_word0i.re) msix_tbl_word0_ms_re_q <= memi_msix_tbl_word0i.addr[6];
  if (memi_msix_tbl_word1i.re) msix_tbl_word1_ms_re_q <= memi_msix_tbl_word1i.addr[6];
  if (memi_msix_tbl_word2i.re) msix_tbl_word2_ms_re_q <= memi_msix_tbl_word2i.addr[6];

  // If a write to te MS table word, write the local reg

  if (memi_msix_tbl_word0i.we & memi_msix_tbl_word0i.addr[6]) msix_tbl_word0_ms_q <= memi_msix_tbl_word0i.wdata;
  if (memi_msix_tbl_word1i.we & memi_msix_tbl_word1i.addr[6]) msix_tbl_word1_ms_q <= memi_msix_tbl_word1i.wdata;
  if (memi_msix_tbl_word2i.we & memi_msix_tbl_word2i.addr[6]) msix_tbl_word2_ms_q <= memi_msix_tbl_word2i.wdata;

 end
end

always_comb begin

 // Default is to connect internal sigs to external sigs that interface to the RF

 memi_msix_tbl_word0  = memi_msix_tbl_word0i;
 memi_msix_tbl_word1  = memi_msix_tbl_word1i;
 memi_msix_tbl_word2  = memi_msix_tbl_word2i;

 memo_msix_tbl_word0i = memo_msix_tbl_word0;
 memo_msix_tbl_word1i = memo_msix_tbl_word1;
 memo_msix_tbl_word2i = memo_msix_tbl_word2;

 // If access is to MS table word, then nuke access of external RF

 if (memi_msix_tbl_word0i.addr[6]) begin
  memi_msix_tbl_word0.re = '0;
  memi_msix_tbl_word0.we = '0;
 end

 if (memi_msix_tbl_word1i.addr[6]) begin
  memi_msix_tbl_word1.re = '0;
  memi_msix_tbl_word1.we = '0;
 end

 if (memi_msix_tbl_word2i.addr[6]) begin
  memi_msix_tbl_word2.re = '0;
  memi_msix_tbl_word2.we = '0;
 end

 // If read was to MS table word, mux in the local reg instead of the RF rdata

 if (msix_tbl_word0_ms_re_q) memo_msix_tbl_word0i.rdata = msix_tbl_word0_ms_q;
 if (msix_tbl_word1_ms_re_q) memo_msix_tbl_word1i.rdata = msix_tbl_word1_ms_q;
 if (msix_tbl_word2_ms_re_q) memo_msix_tbl_word2i.rdata = msix_tbl_word2_ms_q;

end

hqm_system_lut_rmw #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD3)
        ,.PACK                  (HQM_SYSTEM_PACK_MSIX_TBL_WORD3)
        ,.INIT_VALUE            (1'b1)

) i_lut_msix_vector_ctrl (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[11])

        ,.cfg_re                (cfg_re_v.vector_ctrl)
        ,.cfg_we                (cfg_we_v.vector_ctrl)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD3-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD3-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vector_ctrl)

        ,.memi                  (memi_msix_tbl_word3)

        ,.memo                  (memo_msix_tbl_word3)

        ,.lut_re                (msix_tbl_ack)
        ,.lut_addr              (msix_tbl_vec)
        ,.lut_nord              (1'b0)

        ,.lut_rdata             (msix_tbl_rdata_mask)
        ,.lut_perr              (lut_perr[11])

        ,.lut_hold              (msix_tbl_hold)
);

// Keep the MSI-X Table mask bits in flops so we can access all of them at once

always_ff @(posedge hqm_gated_clk) begin
 if (memi_msix_tbl_word3.re) memo_msix_tbl_word3.rdata <= msix_tbl_mask_q[memi_msix_tbl_word3.addr]; 
 if (memi_msix_tbl_word3.we) msix_tbl_mask_q[memi_msix_tbl_word3.addr] <= memi_msix_tbl_word3.wdata; 
end

always_comb begin: g_mask
 msix_tbl_mask = '0;
 for (int i=0; i<(HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3/HQM_SYSTEM_PACK_MSIX_TBL_WORD3); i=i+1) begin
  msix_tbl_mask[(i*(HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)) +: (HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)] =
   msix_tbl_mask_q[i][0 +: (HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)];
 end
 msix_tbl_mask[((HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3/HQM_SYSTEM_PACK_MSIX_TBL_WORD3)*
                (HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)) +: (HQM_SYSTEM_NUM_MSIX-
               ((HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3/HQM_SYSTEM_PACK_MSIX_TBL_WORD3)*
                (HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)))] =
 msix_tbl_mask_q[HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3/HQM_SYSTEM_PACK_MSIX_TBL_WORD3][0 +: (HQM_SYSTEM_NUM_MSIX-
               ((HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3/HQM_SYSTEM_PACK_MSIX_TBL_WORD3)*
                (HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1)))];
end

hqm_AW_width_scale #(

     .A_WIDTH   (HQM_SYSTEM_NUM_MSIX)
    ,.Z_WIDTH   (1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)

) i_msix_tbl_mask_scaled (

     .a         (msix_tbl_mask)
    ,.z         (msix_tbl_mask_scaled)
);

// This path holds if the its output is valid but doesn't win the function arbitration.
// Can throw away requests with parity errors on the table lookups, so don't hold on parity error

assign msix_tbl_hold = msix_p2_v & ~(|lut_perr[11:8]) & ~func_arb_winner_dec[0];

//-----------------------------------------------------------------------------------------------------
// Function arbitration between single MSI-X path and single AI paths for access to IMS/MSI-X output
// to the SIF PH and PD FIFO paths through the write buffer's output arbiter.
// This is a 2 input arbiter feeding a 2 input arbiter in the write buffer.

assign func_arb_reqs   = {ai_p2_v, msix_p2_v};
assign func_arb_update = func_arb_winner_v & ims_msix_ready;

hqm_AW_rr_arbiter #(.NUM_REQS(2)) i_func_arb (

     .clk           (hqm_gated_clk)
    ,.rst_n         (hqm_gated_rst_n)

    ,.mode          (2'd2)
    ,.update        (func_arb_update)

    ,.reqs          (func_arb_reqs)

    ,.winner_v      (func_arb_winner_v)
    ,.winner        (func_arb_winner)
);

hqm_AW_bindec #(.WIDTH(1)) i_func_arb_winner_dec (

     .a             (func_arb_winner)
    ,.enable        (func_arb_update)

    ,.dec           (func_arb_winner_dec)
);

logic [1:0] msix_tbl_rdata_addr_res;
logic [1:0] ai_p2_addr_res;

hqm_AW_residue_gen #(.WIDTH((2*HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)-2)) i_msix_tbl_rdata_addr_res (

     .a             (msix_tbl_rdata_addr[(2*HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)-1:2])
    ,.r             (msix_tbl_rdata_addr_res)
);

hqm_AW_residue_gen #(.WIDTH(62)) i_ai_p2_addr_res (

     .a             (ai_p2_addr)
    ,.r             (ai_p2_addr_res)
);

always_comb begin: Scale_AD
 for (int i=0; i<2; i=i+1) begin
  if (i == 0) begin
   func_arb_addr[i]     =  msix_tbl_rdata_addr[(2*HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD)-1:2];
   func_arb_addr_res[i] =  msix_tbl_rdata_addr_res;
   func_arb_data[i]     =  msix_tbl_rdata_data;
   func_arb_data_par[i] = ^msix_tbl_rdata_data;
  end else if (i == 1) begin
   func_arb_addr[i]     =  ai_p2_addr[63:2];
   func_arb_addr_res[i] =  ai_p2_addr_res;
   func_arb_data[i]     =  ai_p2_data;
   func_arb_data_par[i] = ^ai_p2_data;
  end else begin
   func_arb_addr[i]     = '0;
   func_arb_addr_res[i] = '0;
   func_arb_data[i]     = '0;
   func_arb_data_par[i] = '0;
  end
 end
end

// Throw away a PF ai or msix request with a LUT parity error.  Doing this here instead of just gating
// msix_p2_v to avoid timing paths from perr back to msi arbiters through the winner decode path.
//
//       SC-IOV POLL | IS_PF RID    PASID           ADDR
//       ------ ---- | ----- ----   --------------- --------------
// MSI-X   0     x   |   1   0      0               {MSI-X Table.addr[vec][63:2], 2'h0}   PF-only
// IMS     0     0   |   1   0      0               {44'hFEE, IMS.addr[cq][19:2], 2'h0}   PF-only
// IMS     1     0   |   1   0      0               {44'hFEE, IMS.addr[cq][19:2], 2'h0}   PF-only  SC-IOV
// IMS     0     1   |   1   0      0               {IMS.addr[cq][63:2],          2'h0}   PF-only  Polling
// IMS     1     1   |   1   0      IMS.data[31:12] {IMS.addr[cq][63:2],          2'h0}   PF-only  SC-IOV Polling

assign ims_poll_mode     =  func_arb_winner_dec[1] & msix_mode.IMS_POLLING;

assign ims_msix_v        = (func_arb_winner_dec[1]) ? ~(|lut_perr[7:2]) :
                          ((func_arb_winner_dec[0]) ? ~(|lut_perr[11:8]) : func_arb_winner_v);
assign ims_msix.ai       =  func_arb_winner_dec[1];
assign ims_msix.addr     =  func_arb_addr[func_arb_winner];
assign ims_msix.addr_res =  func_arb_addr_res[func_arb_winner];
assign ims_msix.data     =  func_arb_data[func_arb_winner];
assign ims_msix.data_par =  func_arb_data_par[func_arb_winner];
assign ims_msix.poll     =  ims_poll_mode;

// CQ is valid if IMS, or MSIX-X AND vector is not 0 (alarm)

assign ims_msix.cq_v     = |{func_arb_winner_dec[1], msix_p2_vec_q};
assign ims_msix.cq_ldb   =  (func_arb_winner_dec[1]) ? ai_p2_ldb_q : msix_p2_ldb_q;
assign ims_msix.cq       =  (func_arb_winner_dec[1]) ? ai_p2_cq_q  : msix_p2_cq_q;

// Traffic class select is function of CQ bits for the IMS cases

assign ims_msix.tc_sel   = (func_arb_winner_dec[1]) ?
                            ((ai_p2_ldb_q) ? ai_p2_cq_q[5:4] :
                                {(^{ai_p2_cq_q[4], ai_p2_cq_q[2], ai_p2_cq_q[0]})
                                ,(^{ai_p2_cq_q[5], ai_p2_cq_q[3], ai_p2_cq_q[1]})}) : 2'd0;

assign ims_msix.parity   = ^{ims_msix.poll
                            ,ims_msix.ai
                            ,ims_msix.cq_v
                            ,ims_msix.cq_ldb
                            ,ims_msix.cq
                            ,ims_msix.tc_sel
                            };

assign ims_msix_vec      = (func_arb_winner_dec[0]) ? msix_p2_vec_q : '0;

hqm_AW_agitate_readyvalid #(.SEED(32'h7243)) i_agitate_ims_msix_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.control           (al_ims_msix_db_agitate_control)
    ,.enable            (1'b1)

    ,.up_v              (ims_msix_v)
    ,.up_ready          (ims_msix_ready)

    ,.down_v            (agg_ims_msix_v)
    ,.down_ready        (agg_ims_msix_ready)
);

hqm_AW_double_buffer #(

     .WIDTH             ($bits(ims_msix)+HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)
    ,.NOT_EMPTY_AT_EOT  (0)

) i_ims_msix_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.status            (ims_msix_db_status)

    ,.in_ready          (agg_ims_msix_ready)

    ,.in_valid          (agg_ims_msix_v)
    ,.in_data           ({ims_msix_vec, ims_msix})

    ,.out_ready         (ims_msix_w_ready)

    ,.out_valid         (ims_msix_w_v)
    ,.out_data          ({ims_msix_w_vec, ims_msix_w})
);

// Individual syndrome bits per MSI/X
// These are set when write is sent to write_buffer and reset by SW (COW1)

assign ims_msix_synd_pf_v_next = ims_msix_w_v & ims_msix_w_ready & ~ims_msix_w.ai;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ims_msix_synd_pf_v_q <= '0;
 end else begin
  ims_msix_synd_pf_v_q <= ims_msix_synd_pf_v_next;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (ims_msix_synd_pf_v_next) begin
  ims_msix_synd_vec_q <= ims_msix_w_vec;
 end
end

hqm_AW_bindec #(.WIDTH(HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)) i_msix_synd_scaled (

     .a                 (ims_msix_synd_vec_q)
    ,.enable            (ims_msix_synd_pf_v_q)

    ,.dec               (msix_synd_scaled)
);

assign msix_synd = msix_synd_scaled[HQM_SYSTEM_NUM_MSIX-1:0];

//-----------------------------------------------------------------------------------------------------
// Handle unused bits due to scaling

generate

 if (HQM_SYSTEM_NUM_MSIX != (1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)) begin: g_unused_msix

  hqm_AW_unused_bits i_unused_msix (        

         .a     (|{msix_pba_next[     (1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:HQM_SYSTEM_NUM_MSIX]
                  ,msix_arb_reqs_next[(1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:HQM_SYSTEM_NUM_MSIX]
                  ,msix_synd_scaled[  (1<<HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD)-1:HQM_SYSTEM_NUM_MSIX]
                })
  );

 end

 if (NUM_DIR_CQ != (1<<HQM_SYSTEM_DIR_CQ_WIDTH)) begin: g_unused_dir

  hqm_AW_unused_bits i_unused_dir (        

        .a      (|cq_occ_decode_next[(1<<HQM_SYSTEM_DIR_CQ_WIDTH)-1:NUM_DIR_CQ])
  );

 end

 if ((NUM_DIR_CQ+NUM_LDB_CQ) != (1<<AI_VEC_WIDTH)) begin: g_unused_ims

  hqm_AW_unused_bits i_unused_ims (        

        .a      (|{ai_arb_reqs_next[(1<<AI_VEC_WIDTH)-1:(NUM_DIR_CQ+NUM_LDB_CQ)]
                  ,ai_pend_next[    (1<<AI_VEC_WIDTH)-1:(NUM_DIR_CQ+NUM_LDB_CQ)]})
  );

 end

endgenerate

//-----------------------------------------------------------------------------------------------------
// These bits are sticky parity error indications.

assign lut_perr_next[0]  = (p2_v_q    | p2_cfg_q    | p2_cfg_we_q[1])    & lut_perr[0];
assign lut_perr_next[1]  = (p2_v_q    | p2_cfg_q    | p2_cfg_we_q[1])    & lut_perr[1];
assign lut_perr_next[2]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[2];
assign lut_perr_next[3]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[3];
assign lut_perr_next[4]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[4];
assign lut_perr_next[5]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[5];
assign lut_perr_next[6]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[6];
assign lut_perr_next[7]  = (ai_p2_v_q | ai_p2_cfg_q | ai_p2_cfg_we_q[1]) & lut_perr[7];
assign lut_perr_next[8]  = ((msix_p2_v_q & func_arb_winner_dec[0]) | msix_p2_cfg_q | msix_p2_cfg_we_q[1]) & lut_perr[8];
assign lut_perr_next[9]  = ((msix_p2_v_q & func_arb_winner_dec[0]) | msix_p2_cfg_q | msix_p2_cfg_we_q[1]) & lut_perr[9];
assign lut_perr_next[10] = ((msix_p2_v_q & func_arb_winner_dec[0]) | msix_p2_cfg_q | msix_p2_cfg_we_q[1]) & lut_perr[10];
assign lut_perr_next[11] = ((msix_p2_v_q & func_arb_winner_dec[0]) | msix_p2_cfg_q | msix_p2_cfg_we_q[1]) & lut_perr[11];
assign lut_perr_next[12] = vf_synd_perr;

assign perr_next = (|lut_perr_next);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  perr_q     <= '0;
  lut_perr_q <= '0;
 end else begin
  perr_q     <= perr_next & ~cfg_parity_off;
  lut_perr_q <= lut_perr_next & ~{$bits(lut_perr_q){cfg_parity_off}};
 end
end

assign alarm_lut_perr = lut_perr_q;
assign alarm_perr     = perr_q;

//-----------------------------------------------------------------------------------------------------
// Status

assign alarm_status.IMS_P2_V    = ai_p2_v_q;
assign alarm_status.IMS_P1_V    = ai_p1_v_q;
assign alarm_status.IMS_P0_V    = ai_p0_v_q;
assign alarm_status.MSIX_P2_V   = msix_p2_v_q;
assign alarm_status.MSIX_P1_V   = msix_p1_v_q;
assign alarm_status.MSIX_P0_V   = msix_p0_v_q;
assign alarm_status.CQ_OCC_P2_V = p2_v_q;
assign alarm_status.CQ_OCC_P1_V = p1_v_q;
assign alarm_status.CQ_OCC_P0_V = p0_v_q;

assign alarm_idle_next = (~(|{msix_p2_v_q
                             ,msix_p1_v_q
                             ,msix_p0_v_q
                             ,p2_v_q
                             ,p1_v_q
                             ,p0_v_q
                             ,ai_p0_v_q
                             ,ai_p1_v_q
                             ,ai_p2_v_q
                             ,cwdi_rx_fifo_status.depth
                             ,sif_alarm_fifo_status.depth
                             ,hqm_alarm_rx_fifo_status.depth
                             ,(~int_idle)
                             ,ims_msix_db_status[1:0]
                             ,alarm_reqs_q
                             ,msix_arb_reqs_q
                             ,ai_arb_reqs_q
                             ,cfg_re_q
                             ,cfg_we_q
})) & init_done_q;

assign system_local_idle_next = &sys_idle_status_reg[$bits(new_SYS_IDLE_STATUS_t)-1:0];

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  alarm_idle_q        <= '0;
  system_local_idle_q <= '0;
 end else begin
  alarm_idle_q        <= alarm_idle_next;
  system_local_idle_q <= system_local_idle_next;
 end
end

assign alarm_idle    = alarm_idle_q;

assign pba_idle_next = ~(|{msix_pba_v, ai_pend_v});

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
 if (~hqm_inp_gated_rst_n) begin
  pba_idle_q <= '0;
 end else begin
  pba_idle_q <= pba_idle_next;
 end
end

// The pba_idle signals need to be ANDed in here as they are on the inp_gated_clk
// while the idle reg and system_local_idle are on the gated_clk and the gated_clk
// may not be running when the pba_idle deasserts.

assign system_local_idle = system_local_idle_q & pba_idle_q;

assign pba_idle          = pba_idle_q;

//-----------------------------------------------------------------------------------------------------

hqm_AW_inc #(.WIDTH(32)) i_sbe_cnt_ls_p1 (.a(sbe_cnt_q[31: 0]), .sum(sbe_cnt_ls_p1));
hqm_AW_inc #(.WIDTH(32)) i_sbe_cnt_ms_p1 (.a(sbe_cnt_q[63:32]), .sum(sbe_cnt_ms_p1));

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin

  sbe_inc_q <= '0;
  sbe_cnt_q <= '0;

 end else begin

  sbe_inc_q <= (cfg_we_v.sbe_cnt_0 | cfg_we_v.sbe_cnt_1) ? 2'd0 :
    {(sbe_in & ((sbe_inc_q[0]) ? (&{sbe_cnt_q[31:1], ~sbe_cnt_q[0]}) : (&sbe_cnt_q[31:0]))), sbe_in};

  if (cfg_we_v.sbe_cnt_0) begin
    sbe_cnt_q[31: 0] <= cfg_wdata_q;
  end else if (sbe_inc_q[0]) begin
    sbe_cnt_q[31: 0] <= sbe_cnt_ls_p1[31:0];
  end
  if (cfg_we_v.sbe_cnt_1) begin
    sbe_cnt_q[63:32] <= cfg_wdata_q;
  end else if (sbe_inc_q[1]) begin
    sbe_cnt_q[63:32] <= sbe_cnt_ms_p1;
  end

 end
end

assign cfg_rdata_lut.sbe_cnt_0  = sbe_cnt_q[31: 0];
assign cfg_rdata_lut.sbe_cnt_1  = sbe_cnt_q[63:32];

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_system_alarm

