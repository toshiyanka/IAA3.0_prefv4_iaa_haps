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
// hqm_reorder_pipe
//
//  chp_rop_hcw ----->+-----------------------+-------------------+------------------+--------------------+
//                    |                       |                   |                  |                    |
//                    |                       |                   |                  |                    |
//                    |    +--------------+   |   +-----------+   |   +----------+   |   +------------+   |   +---------+                    
//                    +--->| NALB_SYS_ENQ |   +-->| SN_OLDEST |   +-->| SN_STATE |   +-->| DP_SYS_ENQ |   +-->| HCW_ENQ |
//                         |              |       |           |------>|          |       |            |       |         | 
//                         |              |<--+   |           |       |          |--+--->|            |       |         | 
//                         |              |   |   |           |       |          |  |    |            |       |         | 
//                         |              |   |   |           |       |          |  |    |            |       |         | 
//                         +--------------+   |   +-----------+       +----------+  |    +------------+       +---------+
//                             |      |       +-------------------------------------+            |                   |
//                             |      |                                                          |                   | 
//                             |      |                                                          |                   +-----> rop_qed_dqed_enq
//                             |      |                                                          |      
//                             |      |                                                          +-------------------------> rop_dp_enq
//                             |      |
//                             |      +------------------------------------------------------------------------------------> rop_nalb_enq
//                             |
//                             +-------------------------------------------------------------------------------------------> rop_lsp_reordercmp
//
//
// The reorder pipe has 5 independent pipe lines with common source where the incoming HCW types determine which pipe to choose
//       HCW_ENQ      - new hcw get issued on this path and requests to to either dqed for directed HCWs and qed for
//                        load balanced HCWs (UNORDERED, ORDERED, ATOMIC)
//                      
//       DP_SYS_ENQ   - new HCWs and replay HCWs get issued on this pipe. The second state of the pipe also handles selection of any
//                        ordered replays from the SN_STSTE logic 
//
//       NALB_SYS_ENQ - new HCWs and replay HCWs get issued on this pipe. The second state of the pipe also handles selection of any 
//                        ordered replays from the SN_STATE logic
//   
//       SN_OLDEST    - HCW completions for ordered type HCWs get issued on this pipe to be managed. When the SN associated with the completion
//                      becomese the oldest it is scheduled and replay information for SN is looked un in SN_STATE and signaled for selection
//                      by DP_SYS_ENQ pipe line or NALB_SYS_ENQ pipe line or both
//       SN_STATE     - HCW fragments are issued on this pipe and fragment state is managed. Count of directed or load balanced HCW is managed
//
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_reorder_pipe_func
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
  input  logic                          hqm_gated_clk

, input  logic                          pf_reset_active 

, input  logic                         hqm_gated_rst_n
, input  logic                         hqm_gated_rst_n_active
, input  logic                         rst_prep

, output logic rop_clk_idle
, input  logic                         cfg_rx_idle
, input  logic                            cfg_idle

// alarm interface to int serializer
, output logic [ ( HQM_ROP_ALARM_NUM_INF ) -1 : 0]          int_inf_v
, output aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_INF ) -1 : 0] int_inf_data
, output logic [ ( HQM_ROP_ALARM_NUM_COR) -1 : 0]           int_cor_v
, output aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_COR) -1 : 0]  int_cor_data
, output logic [ ( HQM_ROP_ALARM_NUM_UNC ) -1 : 0]          int_unc_v
, output aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_UNC ) -1 : 0] int_unc_data
, input  logic                                              int_idle
                                                        
, input  logic [ ( 32 ) -1 : 0]           int_serializer_status
                                          
, output logic                            rop_unit_idle
, output logic                            rop_unit_pipeidle
, output logic                            rop_reset_done

, output cfg_unit_timeout_t               cfg_unit_timeout
, input  aw_fifo_status_t                 rop_cfg_ring_top_rx_fifo_status
, input  logic                            cfg_req_idlepipe
, output logic                            cfg_req_ready                                        
// CFG interface                        
//, input  logic                          rop_cfg_req_up_read
//, input  logic                          rop_cfg_req_up_write
//, input  cfg_req_t                      rop_cfg_req_up
//, input  logic                          rop_cfg_rsp_up_ack
//, input  cfg_rsp_t                      rop_cfg_rsp_up
//, output logic                          rop_cfg_req_down_read
//, output logic                          rop_cfg_req_down_write
//, output cfg_req_t                      rop_cfg_req_down
//, output logic                          rop_cfg_rsp_down_ack
//, output cfg_rsp_t                      rop_cfg_rsp_down
                                        
// interrupt interface                  
, input  logic                          rop_alarm_up_v
, input  logic                          rop_alarm_up_ready
                                        
, input  logic                          rop_alarm_down_v
, input  logic                          rop_alarm_down_ready
                                        
// chp_rop_hcw interface                
, input  logic                          chp_rop_hcw_v
, output logic                          chp_rop_hcw_ready
, input  chp_rop_hcw_t                  chp_rop_hcw_data
                                        
// rop_dp_enq interface                 
, output logic                          rop_dp_enq_v
, input  logic                          rop_dp_enq_ready
, output rop_dp_enq_t                   rop_dp_enq_data
                                        
// rop_nalb_enq interface               
, output logic                          rop_nalb_enq_v
, input  logic                          rop_nalb_enq_ready
, output rop_nalb_enq_t                 rop_nalb_enq_data
                                        
// rop_qed_dqed_enq interface           
, output logic                          rop_qed_dqed_enq_v
, input  logic                          rop_qed_enq_ready
, input  logic                          rop_dqed_enq_ready
, output rop_qed_dqed_enq_t             rop_qed_dqed_enq_data
, output logic                          rop_qed_force_clockon
                                        
// rop_lsp_reordercmp interface        
, output logic                          rop_lsp_reordercmp_v
, input  logic                          rop_lsp_reordercmp_ready
, output rop_lsp_reordercmp_t           rop_lsp_reordercmp_data

//, output  logic [ ( 4 * 1 ) -1 : 0 ] cfg_mem_re 
//, output  logic [ ( 4 * 1 ) -1 : 0 ] cfg_mem_we 
//, output  logic [ ( 20 ) - 1 : 0 ] cfg_mem_addr 
//, output  logic [ ( 12 ) - 1 : 0 ] cfg_mem_minbit 
//, output  logic [ ( 12 ) - 1 : 0 ] cfg_mem_maxbit 
//, output  logic [ ( 32 ) - 1 : 0 ] cfg_mem_wdata 
//, input   logic [ ( 4 * 32 ) - 1 : 0 ] cfg_mem_rdata
//, input   logic [ ( 4 * 1 ) - 1 : 0 ] cfg_mem_ack
, output  logic func_reord_dirhp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_dirhp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_dirhp_mem_waddr
, output  logic func_reord_dirhp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] func_reord_dirhp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] func_reord_dirhp_mem_rdata
, input   logic rf_reord_dirhp_mem_error
, output  logic func_lsp_reordercmp_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] func_lsp_reordercmp_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] func_lsp_reordercmp_fifo_mem_waddr
, output  logic func_lsp_reordercmp_fifo_mem_we
, output  logic [ ( 19 ) - 1 : 0 ] func_lsp_reordercmp_fifo_mem_wdata
, input   logic [ ( 19 ) - 1 : 0 ] func_lsp_reordercmp_fifo_mem_rdata
, input   logic rf_lsp_reordercmp_fifo_mem_error
, output  logic func_sn1_order_shft_mem_re
, output  logic [ ( 4 ) - 1 : 0 ] func_sn1_order_shft_mem_raddr
, output  logic [ ( 4 ) - 1 : 0 ] func_sn1_order_shft_mem_waddr
, output  logic func_sn1_order_shft_mem_we
, output  logic [ ( 12 ) - 1 : 0 ] func_sn1_order_shft_mem_wdata
, input   logic [ ( 12 ) - 1 : 0 ] func_sn1_order_shft_mem_rdata
, input   logic rf_sn1_order_shft_mem_error
, output  logic func_sn_ordered_fifo_mem_re
, output  logic [ ( 5 ) - 1 : 0 ] func_sn_ordered_fifo_mem_raddr
, output  logic [ ( 5 ) - 1 : 0 ] func_sn_ordered_fifo_mem_waddr
, output  logic func_sn_ordered_fifo_mem_we
, output  logic [ ( 13 ) - 1 : 0 ] func_sn_ordered_fifo_mem_wdata
, input   logic [ ( 13 ) - 1 : 0 ] func_sn_ordered_fifo_mem_rdata
, input   logic rf_sn_ordered_fifo_mem_error
, output  logic func_ldb_rply_req_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] func_ldb_rply_req_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] func_ldb_rply_req_fifo_mem_waddr
, output  logic func_ldb_rply_req_fifo_mem_we
, output  logic [ ( 60 ) - 1 : 0 ] func_ldb_rply_req_fifo_mem_wdata
, input   logic [ ( 60 ) - 1 : 0 ] func_ldb_rply_req_fifo_mem_rdata
, input   logic rf_ldb_rply_req_fifo_mem_error
, output  logic func_sn_complete_fifo_mem_re
, output  logic [ ( 2 ) - 1 : 0 ] func_sn_complete_fifo_mem_raddr
, output  logic [ ( 2 ) - 1 : 0 ] func_sn_complete_fifo_mem_waddr
, output  logic func_sn_complete_fifo_mem_we
, output  logic [ ( 21 ) - 1 : 0 ] func_sn_complete_fifo_mem_wdata
, input   logic [ ( 21 ) - 1 : 0 ] func_sn_complete_fifo_mem_rdata
, input   logic rf_sn_complete_fifo_mem_error
, output  logic func_dir_rply_req_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] func_dir_rply_req_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] func_dir_rply_req_fifo_mem_waddr
, output  logic func_dir_rply_req_fifo_mem_we
, output  logic [ ( 60 ) - 1 : 0 ] func_dir_rply_req_fifo_mem_wdata
, input   logic [ ( 60 ) - 1 : 0 ] func_dir_rply_req_fifo_mem_rdata
, input   logic rf_dir_rply_req_fifo_mem_error
, output  logic func_chp_rop_hcw_fifo_mem_re
, output  logic [ ( 2 ) - 1 : 0 ] func_chp_rop_hcw_fifo_mem_raddr
, output  logic [ ( 2 ) - 1 : 0 ] func_chp_rop_hcw_fifo_mem_waddr
, output  logic func_chp_rop_hcw_fifo_mem_we
, output  logic [ ( 204 ) - 1 : 0 ] func_chp_rop_hcw_fifo_mem_wdata
, input   logic [ ( 204 ) - 1 : 0 ] func_chp_rop_hcw_fifo_mem_rdata
, input   logic rf_chp_rop_hcw_fifo_mem_error
, output  logic func_reord_cnt_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_cnt_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_cnt_mem_waddr
, output  logic func_reord_cnt_mem_we
, output  logic [ ( 14 ) - 1 : 0 ] func_reord_cnt_mem_wdata
, input   logic [ ( 14 ) - 1 : 0 ] func_reord_cnt_mem_rdata
, input   logic rf_reord_cnt_mem_error
, output  logic func_reord_dirtp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_dirtp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_dirtp_mem_waddr
, output  logic func_reord_dirtp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] func_reord_dirtp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] func_reord_dirtp_mem_rdata
, input   logic rf_reord_dirtp_mem_error
, output  logic func_reord_st_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_st_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_st_mem_waddr
, output  logic func_reord_st_mem_we
, output  logic [ ( 23 ) - 1 : 0 ] func_reord_st_mem_wdata
, input   logic [ ( 23 ) - 1 : 0 ] func_reord_st_mem_rdata
, input   logic rf_reord_st_mem_error
, output  logic func_reord_lbtp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_lbtp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_lbtp_mem_waddr
, output  logic func_reord_lbtp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] func_reord_lbtp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] func_reord_lbtp_mem_rdata
, input   logic rf_reord_lbtp_mem_error
, output  logic func_sn0_order_shft_mem_re
, output  logic [ ( 4 ) - 1 : 0 ] func_sn0_order_shft_mem_raddr
, output  logic [ ( 4 ) - 1 : 0 ] func_sn0_order_shft_mem_waddr
, output  logic func_sn0_order_shft_mem_we
, output  logic [ ( 12 ) - 1 : 0 ] func_sn0_order_shft_mem_wdata
, input   logic [ ( 12 ) - 1 : 0 ] func_sn0_order_shft_mem_rdata
, input   logic rf_sn0_order_shft_mem_error
, output  logic func_reord_lbhp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_lbhp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] func_reord_lbhp_mem_waddr
, output  logic func_reord_lbhp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] func_reord_lbhp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] func_reord_lbhp_mem_rdata
, input   logic rf_reord_lbhp_mem_error

, input   logic hqm_reorder_pipe_rfw_top_ipar_error


// register_pfcsr interface
//, output logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write
//, output logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read
//, output cfg_req_t pfcsr_cfg_req  
//, input  logic pfcsr_cfg_rsp_ack 
//, input  logic pfcsr_cfg_rsp_err  
//, input  logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata 
, output logic hqm_rop_target_cfg_control_general_0_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_diagnostic_aw_status_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_frag_integrity_count_status
, output logic hqm_rop_target_cfg_grp_sn_mode_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_f
, output logic hqm_rop_target_cfg_hw_agitate_control_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_f
, output logic hqm_rop_target_cfg_hw_agitate_select_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_interface_status_status
, output logic hqm_rop_target_cfg_patch_control_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp0_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp1_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_dp_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status
, output logic [ ( 1 * 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status
, output logic [ ( 1 * 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp0_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp1_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_dp_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status
, output logic hqm_rop_target_cfg_rop_csr_control_reg_v
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_serializer_status_status
, output logic hqm_rop_target_cfg_smon_disable_smon
, output logic [ 16 - 1 : 0 ] hqm_rop_target_cfg_smon_smon_v
, output logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_comp
, output logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_val
, input logic hqm_rop_target_cfg_smon_smon_enabled
, input logic hqm_rop_target_cfg_smon_smon_interrupt
, output logic hqm_rop_target_cfg_syndrome_00_capture_v
, output logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_00_capture_data
, output logic hqm_rop_target_cfg_syndrome_01_capture_v
, output logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_01_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_nxt
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_f
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_version_status

);

localparam HQM_ROP_MULTI_FRAG_ENABLE = 1;

localparam HQM_ROP_NUM_SN = 2048;
localparam HQM_ROP_NUM_SN_B2 = (AW_logb2(HQM_ROP_NUM_SN-1)+1);
// start declarations
logic                  disable_smon ;
assign disable_smon = 1'b0 ;

logic                                  lsp_reordercmp_tx_idle ;
logic                                  chp_rop_hcw_fifo_push;
errors_plus_chp_rop_hcw_t              chp_rop_hcw_fifo_push_data;
logic                                  chp_rop_hcw_fifo_push_parity;
logic                                  chp_rop_hcw_fifo_pop;
errors_plus_chp_rop_hcw_t              chp_rop_hcw_fifo_pop_data;
logic                                  chp_rop_hcw_fifo_pop_parity;
logic                                  chp_rop_hcw_fifo_parity_error_nxt;
logic                                  chp_rop_hcw_fifo_parity_error_f;

logic                                  chp_rop_hcw_fifo_afull;
logic                                  chp_rop_hcw_fifo_full_nc;
logic                                  chp_rop_hcw_fifo_empty;
                                                   
// dir_rply_req fifo related declarations          
logic                                  dir_rply_req_fifo_push;
dp_rply_data_t                         dir_rply_req_fifo_push_data;
logic                                  dir_rply_req_fifo_push_parity;
logic                                  dir_rply_req_fifo_pop;
dp_rply_data_t                         dir_rply_req_fifo_pop_data;
logic                                  dir_rply_req_fifo_pop_parity;
logic                                  dir_rply_req_fifo_parity_error_nxt;
logic                                  dir_rply_req_fifo_parity_error_f;
                                       
logic                                  dir_rply_req_fifo_afull;
logic                                  dir_rply_req_fifo_full_nc;
logic                                  dir_rply_req_fifo_empty;
                                                   
// ldb_rply_req fifo related declarations           
logic                                  ldb_rply_req_fifo_push;
nalb_rply_data_t                       ldb_rply_req_fifo_push_data;
logic                                  ldb_rply_req_fifo_push_parity;
logic                                  ldb_rply_req_fifo_pop;
nalb_rply_data_t                       ldb_rply_req_fifo_pop_data;
logic                                  ldb_rply_req_fifo_pop_parity;
logic                                  ldb_rply_req_fifo_parity_error_nxt;
logic                                  ldb_rply_req_fifo_parity_error_f;
                                       
logic                                  ldb_rply_req_fifo_afull;
logic                                  ldb_rply_req_fifo_full_nc;
logic                                  ldb_rply_req_fifo_empty;

logic                                  dir_rply_req_fifo_pop_data_cq_parity;
logic                                  ldb_rply_req_fifo_pop_data_cq_parity;
                                       
// sn_ordered fifo related declarations
logic                                  sn_ordered_fifo_push;
logic [(12 -1) : 0]                    sn_ordered_fifo_push_data;
logic                                  sn_ordered_fifo_push_parity;
logic                                  sn_ordered_fifo_pop;
logic [(12 -1) : 0]                    sn_ordered_fifo_pop_data;
logic                                  sn_ordered_fifo_pop_parity;
logic                                  sn_ordered_fifo_parity_error_nxt;
logic                                  sn_ordered_fifo_parity_error_f;
                                       
logic                                  sn_ordered_fifo_afull;
logic                                  sn_ordered_fifo_full_nc;
logic                                  sn_ordered_fifo_empty;
                                                        
// sn_complete fifo related declarations                
logic                                  sn_complete_fifo_push;
sn_complete_t                          sn_complete_fifo_push_data;
logic                                  sn_complete_fifo_push_parity;
logic                                  sn_complete_fifo_pop;
sn_complete_t                          sn_complete_fifo_pop_data;
logic                                  sn_complete_fifo_pop_parity;
logic                                  sn_complete_fifo_parity_error_nxt;
logic                                  sn_complete_fifo_parity_error_f;
                                       
logic                                  sn_complete_fifo_afull;
logic                                  sn_complete_fifo_full_nc;
logic                                  sn_complete_fifo_empty;

// slp_reordercmp fifo related declarations                
logic                                  lsp_reordercmp_fifo_push;
rop_lsp_reordercmp_t                   lsp_reordercmp_fifo_push_data;
logic                                  lsp_reordercmp_fifo_push_parity;
logic                                  lsp_reordercmp_fifo_pop;
rop_lsp_reordercmp_t                   lsp_reordercmp_fifo_pop_data;
logic                                  lsp_reordercmp_fifo_pop_parity;
logic                                  lsp_reordercmp_fifo_parity_error_nxt;
logic                                  lsp_reordercmp_fifo_parity_error_f;
                                       
logic                                  lsp_reordercmp_fifo_afull;
logic                                  lsp_reordercmp_fifo_full_nc;
logic                                  lsp_reordercmp_fifo_empty;

logic [6:0]                            lsp_reordercmp_db_status_pnc;
logic                                  lsp_reordercmp_db_in_ready;
logic                                  lsp_reordercmp_db_in_valid;
rop_lsp_reordercmp_t                   lsp_reordercmp_db_in_data;
logic                                  lsp_reordercmp_db_out_ready;
logic                                  lsp_reordercmp_db_out_valid;
rop_lsp_reordercmp_t                   lsp_reordercmp_db_out_data;


//-----                                       
                                       
logic                                  chp_rop_hcw_db_out_valid;
chp_rop_hcw_t                          chp_rop_hcw_db_out_data;
logic                                  chp_rop_hcw_db_out_ready;

logic                                  chp_rop_hcw_db_out_valid_and_ready_f;
logic [7:0]                            chp_rop_hcw_db_out_data_cq_hcw_msg_info_qid_f;
logic [6:0]                            chp_rop_hcw_db_status_pnc;
                                       
logic [6:0]                            chp_rop_hcw_db2_status_pnc;
logic                                  chp_rop_hcw_db2_in_ready;
logic                                  chp_rop_hcw_db2_in_v;   
errors_plus_chp_rop_hcw_t              chp_rop_hcw_db2_in_data;   
logic                                  chp_rop_hcw_db2_out_ready;
logic                                  chp_rop_hcw_db2_out_valid;
errors_plus_chp_rop_hcw_t              chp_rop_hcw_db2_out_data;

logic                                  chp_rop_hcw_db2_out_valid_ready_f;
qtype_t                                chp_rop_hcw_db2_out_data_hist_qtype_f;
                                       
logic                                  chp_rop_hcw_db2_out_valid_req;
logic                                  chp_rop_hcw_db2_hist_list_info_parity_error_nxt;
logic                                  chp_rop_hcw_db2_hist_list_info_parity_error_f;

logic                                  rop_parity_type;
                                       
logic [122:0]                          ecc_check_hcw_dout;
logic [1:0]                            ecc_check_hcw_err_sb;
logic [1:0]                            ecc_check_hcw_err_mb;

logic                                  access_sn_integrity_err_nxt;
logic                                  access_sn_integrity_err_f;

logic                                  frag_integrity_cnt_nxt_tmp0_underflow_f;
logic                                  frag_integrity_cnt_nxt_tmp1_underflow_f;
logic                                  frag_integrity_cnt_nxt_tmp2_overflow_f;

// first pipe state out of the fifo. This is to hide the ram timing out of the FIFO

// qed_dqed_enq pipeline declarations                   
pipe_ctl_t                             p0_qed_dqed_enq_ctl;
qed_dqed_enq_pipe_t                    p0_qed_dqed_enq_f;
qed_dqed_enq_pipe_t                    p0_qed_dqed_enq_nxt;
                                         
pipe_ctl_t                             p1_qed_dqed_enq_ctl;
qed_dqed_enq_pipe_t                    p1_qed_dqed_enq_f;
qed_dqed_enq_pipe_t                    p1_qed_dqed_enq_nxt;
                                       
// nalb_enq pipeline declarations      
pipe_ctl_t                             p0_rop_nalb_enq_ctl;
nalb_enq_pipe_t                        p0_rop_nalb_enq_f;
nalb_enq_pipe_t                        p0_rop_nalb_enq_nxt;
                                       
pipe_ctl_t                             p1_rop_nalb_enq_ctl;
nalb_enq_pipe_t                        p1_rop_nalb_enq_f;
nalb_enq_pipe_t                        p1_rop_nalb_enq_nxt;
                                       
pipe_ctl_t                             p2_rop_nalb_enq_ctl;
nalb_enq_pipe_t                        p2_rop_nalb_enq_f;

// dp_enq pipeline declarations        
pipe_ctl_t                             p0_rop_dp_enq_ctl;
dp_enq_pipe_t                          p0_rop_dp_enq_f;
dp_enq_pipe_t                          p0_rop_dp_enq_nxt;
                                          
pipe_ctl_t                             p1_rop_dp_enq_ctl;
dp_enq_pipe_t                          p1_rop_dp_enq_f;
dp_enq_pipe_t                          p1_rop_dp_enq_nxt;
                                       
pipe_ctl_t                             p2_rop_dp_enq_ctl;
dp_enq_pipe_t                          p2_rop_dp_enq_f;

//....................................................................................................
// SMON logic
logic [15 : 0]                         smon_0_v ;
logic [(16 * 32) -1 : 0]               smon_0_comp ;
logic [(16 * 32) -1 : 0]               smon_0_val ;
                                       
logic                                  smon_enabled_nxt ;
logic                                  smon_enabled_f;

logic                                  chp_rop_hcw_v_f;
logic                                  rop_dp_enq_v_f;
logic                                  rop_nalb_enq_v_f;
logic                                  rop_qed_dqed_enq_v_f;
logic                                  rop_lsp_reordercmp_v_f;

logic                                  invalid_hcw_cmd_err; // got invalid hcw cmd in the rop
logic                                  frag_hist_list_qtype_not_ordered;

logic                                  ldb_type;
logic                                  dir_type;
logic                                  cmd_update_sn_order_state;
frag_op_t                              cmd_update_sn_order_state_frag_op;
logic                                  cmd_noop;
logic                                  cmd_hcw_enq;
logic                                  cmd_sys_enq;
logic                                  cmd_sys_enq_frag;
logic                                  cmd_start_sn_reorder;
logic                                  cmd_start_sn_reorder_f;
logic [6:0]                            sn_reorder_qid_f;
                                       
// reorder state pipe line regs        
logic                                  reord_st_rmw_mem_4pipe_status_nxt;
logic                                  reord_st_rmw_mem_4pipe_status_f;
                                       
logic                                  p0_reord_st_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_st_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_st_addr_nxt;
reord_st_t                             p0_reord_st_write_data_nxt;
                                       
logic                                  p0_reord_st_hold;
logic                                  p0_reord_st_v_f;
aw_rmwpipe_cmd_t                       p0_reord_st_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_st_addr_f;
reord_st_t                             p0_reord_st_data_f;
                                       
logic                                  p1_reord_st_hold;
                                       
logic                                  p1_reord_st_v_f;
aw_rmwpipe_cmd_t                       p1_reord_st_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_st_addr_f;
reord_st_t                             p1_reord_st_data_f;

logic                                  p2_reord_st_hold;
                                                                
logic                                  p2_reord_st_v_f;
aw_rmwpipe_cmd_t                       p2_reord_st_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_st_addr_f;
reord_st_t                             p2_reord_st_data_f;
                                       
logic                                  p3_reord_st_hold_nc;
logic                                  p3_reord_st_bypsel_nxt;
reord_st_t                             p3_reord_st_bypdata_nxt;
                                                                   
logic                                  p3_reord_st_v_f;
aw_rmwpipe_cmd_t                       p3_reord_st_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_st_addr_f;
reord_st_t                             p3_reord_st_data_f;
                                                                
///-------------------------           
logic                                  reord_lbhp_rmw_mem_4pipe_status_nxt;
logic                                  reord_lbhp_rmw_mem_4pipe_status_f;
                                       
logic                                  p0_reord_lbhp_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_lbhp_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_lbhp_addr_nxt;
logic [((14 -1) +1): 0]                p0_reord_lbhp_write_data_nxt;
                                       
logic                                  p0_reord_lbhp_hold;
logic                                  p0_reord_lbhp_v_f;
aw_rmwpipe_cmd_t                       p0_reord_lbhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_lbhp_addr_f;
logic [((14 -1) +1) : 0]               p0_reord_lbhp_data_f;
                                       
logic                                  p1_reord_lbhp_hold;
                                       
logic                                  p1_reord_lbhp_v_f;
aw_rmwpipe_cmd_t                       p1_reord_lbhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_lbhp_addr_f;
logic [((14 -1) +1): 0]                p1_reord_lbhp_data_f;
                                       
logic                                  p2_reord_lbhp_hold;
                                                                                 
logic                                  p2_reord_lbhp_v_f;
aw_rmwpipe_cmd_t                       p2_reord_lbhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_lbhp_addr_f;
logic [((14 -1) +1) : 0]               p2_reord_lbhp_data_f;
                                       
logic                                  p3_reord_lbhp_hold_nc;
logic                                  p3_reord_lbhp_bypsel_nxt;
logic [((14 -1) +1) :  0]              p3_reord_lbhp_bypdata_nxt;
                                                                
logic                                  p3_reord_lbhp_v_f;
aw_rmwpipe_cmd_t                       p3_reord_lbhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_lbhp_addr_f;
logic [((14 -1) +1) : 0]               p3_reord_lbhp_data_f;
                                                  
logic                                  reord_lbtp_rmw_mem_4pipe_status_nxt;
logic                                  reord_lbtp_rmw_mem_4pipe_status_f;
                                       
logic                                  p0_reord_lbtp_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_lbtp_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_lbtp_addr_nxt;
logic [((14 -1) +1) : 0]               p0_reord_lbtp_write_data_nxt;
logic                                  p0_reord_lbtp_v_nxt_mfrag;
aw_rmwpipe_cmd_t                       p0_reord_lbtp_rw_nxt_mfrag;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_lbtp_addr_nxt_mfrag;
logic [((14 -1) +1) : 0]               p0_reord_lbtp_write_data_nxt_mfrag;
                                       
logic                                  p0_reord_lbtp_hold;
logic                                  p0_reord_lbtp_v_f;
aw_rmwpipe_cmd_t                       p0_reord_lbtp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_lbtp_addr_f;
logic [((14 -1)  +1) :0]               p0_reord_lbtp_data_f;
                                       
logic                                  p1_reord_lbtp_hold;
                                                        
logic                                  p1_reord_lbtp_v_f;
aw_rmwpipe_cmd_t                       p1_reord_lbtp_rw_f_nc;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_lbtp_addr_f_nc;
logic [((14 -1) +1) : 0]               p1_reord_lbtp_data_f_nc;
                                       
logic                                  p2_reord_lbtp_hold;
                                                                
logic                                  p2_reord_lbtp_v_f;
aw_rmwpipe_cmd_t                       p2_reord_lbtp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_lbtp_addr_f;
logic [((14 -1) +1) : 0]               p2_reord_lbtp_data_f;
                                       
logic                                  p3_reord_lbtp_hold_nc;
logic                                  p3_reord_lbtp_bypsel_nxt;
logic [((14 -1) +1) : 0]               p3_reord_lbtp_bypdata_nxt;
                                                                
logic                                  p3_reord_lbtp_v_f;
aw_rmwpipe_cmd_t                       p3_reord_lbtp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_lbtp_addr_f;
logic [((14 -1) +1) : 0]               p3_reord_lbtp_data_f;
                                                                
logic                                  reord_dirhp_rmw_mem_4pipe_status_nxt;
logic                                  reord_dirhp_rmw_mem_4pipe_status_f;
                                        
logic                                  p0_reord_dirhp_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_dirhp_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirhp_addr_nxt;
logic [((14-1) +1) : 0]                p0_reord_dirhp_write_data_nxt;
logic                                  p0_reord_dirhp_v_nxt_mfrag;
aw_rmwpipe_cmd_t                       p0_reord_dirhp_rw_nxt_mfrag;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirhp_addr_nxt_mfrag;
logic [((14-1) +1) : 0]                p0_reord_dirhp_write_data_nxt_mfrag;
                                       
logic                                  p0_reord_dirhp_hold;
logic                                  p0_reord_dirhp_v_f;
aw_rmwpipe_cmd_t                       p0_reord_dirhp_rw_f_nc;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirhp_addr_f_nc;
logic [((14-1)  +1): 0]                p0_reord_dirhp_data_f_nc;
                                       
logic                                  p1_reord_dirhp_hold;
                                       
logic                                  p1_reord_dirhp_v_f;
aw_rmwpipe_cmd_t                       p1_reord_dirhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_dirhp_addr_f;
logic [((14-1) +1) : 0]                p1_reord_dirhp_data_f;
                                       
logic                                  p2_reord_dirhp_hold;
                                                                
logic                                  p2_reord_dirhp_v_f;
aw_rmwpipe_cmd_t                       p2_reord_dirhp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_dirhp_addr_f;
logic [((14-1) +1) : 0]                p2_reord_dirhp_data_f;
                                       
logic                                  p3_reord_dirhp_hold_nc;
logic                                  p3_reord_dirhp_bypsel_nxt;
logic [((14-1) +1) : 0]                p3_reord_dirhp_bypdata_nxt;
                                                          
logic                                  p3_reord_dirhp_v_f;
aw_rmwpipe_cmd_t                       p3_reord_dirhp_rw_f_nc;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_dirhp_addr_f_nc;
logic [((14-1) +1) : 0]                p3_reord_dirhp_data_f;
                                                                           
logic                                  reord_dirtp_rmw_mem_4pipe_status_nxt;
logic                                  reord_dirtp_rmw_mem_4pipe_status_f;
                                       
logic                                  p0_reord_dirtp_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_dirtp_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirtp_addr_nxt;
logic [((14 -1) +1) : 0]               p0_reord_dirtp_write_data_nxt;
logic                                  p0_reord_dirtp_v_nxt_mfrag;
aw_rmwpipe_cmd_t                       p0_reord_dirtp_rw_nxt_mfrag;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirtp_addr_nxt_mfrag;
logic [((14 -1) +1) : 0]               p0_reord_dirtp_write_data_nxt_mfrag;
                                       
logic                                  p0_reord_dirtp_hold;
logic                                  p0_reord_dirtp_v_f;
aw_rmwpipe_cmd_t                       p0_reord_dirtp_rw_f_nc;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_dirtp_addr_f_nc;
logic [((14 -1) +1) : 0]               p0_reord_dirtp_data_f_nc;
                                       
logic                                  p1_reord_dirtp_hold;
                                       
logic                                  p1_reord_dirtp_v_f;
aw_rmwpipe_cmd_t                       p1_reord_dirtp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_dirtp_addr_f;
logic [((14 -1) +1) : 0]               p1_reord_dirtp_data_f;
                                       
logic                                  p2_reord_dirtp_hold;
                                                                
logic                                  p2_reord_dirtp_v_f;
aw_rmwpipe_cmd_t                       p2_reord_dirtp_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_dirtp_addr_f;
logic [((14 -1) +1) : 0]               p2_reord_dirtp_data_f;
                                       
logic                                  p3_reord_dirtp_hold_nc;
logic                                  p3_reord_dirtp_bypsel_nxt;
logic [((14 -1) +1) : 0]               p3_reord_dirtp_bypdata_nxt;
                                                               
logic                                  p3_reord_dirtp_v_f;
aw_rmwpipe_cmd_t                       p3_reord_dirtp_rw_f_nc;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_dirtp_addr_f_nc;
logic [((14 -1) +1) : 0]               p3_reord_dirtp_data_f;
                                                                 
///-----------------                                       
logic                                  reord_cnt_rmw_mem_4pipe_status_nxt;
logic                                  reord_cnt_rmw_mem_4pipe_status_f;
                                       
logic                                  p0_reord_cnt_v_nxt;
aw_rmwpipe_cmd_t                       p0_reord_cnt_rw_nxt;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_cnt_addr_nxt;
cnt_residue_t                          p0_reord_cnt_write_data_nxt;
logic                                  p0_reord_cnt_v_nxt_mfrag;
aw_rmwpipe_cmd_t                       p0_reord_cnt_rw_nxt_mfrag;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_cnt_addr_nxt_mfrag;
cnt_residue_t                          p0_reord_cnt_write_data_nxt_mfrag;
                                       
logic                                  p0_reord_cnt_hold;
logic                                  p0_reord_cnt_v_f;
aw_rmwpipe_cmd_t                       p0_reord_cnt_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p0_reord_cnt_addr_f;
cnt_residue_t                          p0_reord_cnt_data_f;
                                       
logic                                  p1_reord_cnt_hold;
                                       
logic                                  p1_reord_cnt_v_f;
aw_rmwpipe_cmd_t                       p1_reord_cnt_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p1_reord_cnt_addr_f;
cnt_residue_t                          p1_reord_cnt_data_f;
                                       
logic                                  p2_reord_cnt_hold;
                                                                
logic                                  p2_reord_cnt_v_f;
aw_rmwpipe_cmd_t                       p2_reord_cnt_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p2_reord_cnt_addr_f;
cnt_residue_t                          p2_reord_cnt_data_f;
                                       
logic                                  p3_reord_cnt_hold_nc;
logic                                  p3_reord_cnt_bypsel_nxt;
cnt_residue_t                          p3_reord_cnt_bypdata_nxt;
                                                               
logic                                  p3_reord_cnt_v_f;
aw_rmwpipe_cmd_t                       p3_reord_cnt_rw_f;
logic [(HQM_ROP_NUM_SN_B2 - 1) : 0]    p3_reord_cnt_addr_f;
cnt_residue_t                          p3_reord_cnt_data_f;

///-----------------                                       

pipe_ctl_t                             p0_reord_ctl;
reord_frag_t                           p0_reord_f;
reord_frag_t                           p0_reord_nxt;
                                       
pipe_ctl_t                             p1_reord_ctl;
reord_frag_t                           p1_reord_f;
reord_frag_t                           p1_reord_nxt;
                                       
pipe_ctl_t                             p2_reord_ctl;
reord_frag_t                           p2_reord_f;
reord_frag_t                           p2_reord_nxt;
                                       
pipe_ctl_t                             p3_reord_ctl;
                                       
logic                                  syndrome_00_capture_v;
logic [ 30 : 0 ]                       syndrome_00_capture_data;
                                       
logic                                  syndrome_01_capture_v;
logic [ 30 : 0 ]                       syndrome_01_capture_data;

cnt_residue_t                          rply_cnt;
cnt_residue_t                          rply_cnt_nxt;

logic                                  rply_frag_cnt_gt_16;
logic                                  rply_frag_cnt_gt_16_nxt;
logic                                  rply_frag_cnt_gt_16_f;
logic [6:0]                            rply_frag_cnt_gt_16_qid_f;
logic [6:0]                            rply_frag_cnt_gt_16_qid_nxt;

logic [1:0]                            residue_add_a;
logic [1:0]                            residue_add_b;
logic [1:0]                            residue_add_r;
                                                        
// need to check if I need to pass down the qid to associate the errro with incoming qid
logic                                  rply_cnt_residue_chk_lb_err;  // residue error on lb frag replay cnt
logic                                  rply_cnt_residue_chk_dir_err; // residue error on dir frag replay cnt
                                       
logic                                  reord_st_parity;


logic [((HQM_NUM_SN_GRP*1) -1) : 0]    func_sn_order_shft_mem_we;
logic [((HQM_NUM_SN_GRP*5) -1) : 0]    func_sn_order_shft_mem_waddr;
logic [((HQM_NUM_SN_GRP*12) -1) : 0]   func_sn_order_shft_mem_wdata;
logic [((HQM_NUM_SN_GRP*1) -1) : 0]    func_sn_order_shft_mem_re;
logic [((HQM_NUM_SN_GRP*5) -1) : 0]    func_sn_order_shft_mem_raddr;
logic [((HQM_NUM_SN_GRP*12) -1) : 0]   func_sn_order_shft_mem_rdata;

logic [((HQM_NUM_SN_GRP*1) -1) : 0]    sn_order_rmw_mem_3pipe_status_nxt;
logic [((HQM_NUM_SN_GRP*1) -1) : 0]    sn_order_rmw_mem_3pipe_status_f;

logic [((HQM_NUM_SN_GRP*1) -1) : 0]    sn_state_err_any_f;

//....................................................................................................
// CFG REGSITERS
logic [31 : 0]                         cfg_csr_control_f , cfg_csr_control_nxt ;
logic [31 : 0]                         cfg_control_general_0_f , cfg_control_general_0_nxt ;
                                       
logic [31 : 0]                         cfg_serializer_status_f, cfg_serializer_status_nxt;
                                       
idle_status_t                          cfg_unit_idle_f , cfg_unit_idle_nxt ;
                                       
logic [31 : 0]                         cfg_pipe_health_valid_rop_nalb_nxt; 
logic [31 : 0]                         cfg_pipe_health_valid_rop_nalb_f;
logic [31 : 0]                         cfg_pipe_health_hold_rop_nalb_nxt;
logic [31 : 0]                         cfg_pipe_health_hold_rop_nalb_f;
logic [31 : 0]                         cfg_pipe_health_valid_rop_dp_nxt;
logic [31 : 0]                         cfg_pipe_health_valid_rop_dp_f;
logic [31 : 0]                         cfg_pipe_health_hold_rop_dp_nxt;
logic [31 : 0]                         cfg_pipe_health_hold_rop_dp_f;
logic [31 : 0]                         cfg_pipe_health_valid_rop_qed_dqed_nxt;
logic [31 : 0]                         cfg_pipe_health_valid_rop_qed_dqed_f;
logic [31 : 0]                         cfg_pipe_health_hold_rop_qed_dqed_nxt;
logic [31 : 0]                         cfg_pipe_health_hold_rop_qed_dqed_f;

logic [31 : 0]                         cfg_pipe_health_valid_rop_lsp_reordercmp_nxt;
logic [31 : 0]                         cfg_pipe_health_valid_rop_lsp_reordercmp_f;
logic [31 : 0]                         cfg_pipe_health_hold_rop_lsp_reordercmp_nxt;
logic [31 : 0]                         cfg_pipe_health_hold_rop_lsp_reordercmp_f;

logic [31 : 0]                         cfg_grp_sn_mode_nxt, cfg_grp_sn_mode_f;
logic [31 : 0]                         cfg_grp_sn_mode_copy_f;

logic [7:3]                            cfg_grp_sn_mode_copy_f_7_3_nc;
logic [15:11]                          cfg_grp_sn_mode_copy_f_15_11_nc;
logic [23:19]                          cfg_grp_sn_mode_copy_f_23_19_nc;
logic [31:27]                          cfg_grp_sn_mode_copy_f_31_27_nc;

logic [31 : 0]                         cfg_pipe_health_valid_grp0_nxt, cfg_pipe_health_valid_grp0_f;
logic [31 : 0]                         cfg_pipe_health_valid_grp1_nxt, cfg_pipe_health_valid_grp1_f;
                                                        
logic [31 : 0]                         cfg_pipe_health_hold_grp0_nxt, cfg_pipe_health_hold_grp0_f;
logic [31 : 0]                         cfg_pipe_health_hold_grp1_nxt, cfg_pipe_health_hold_grp1_f;
                                                        
logic [31 : 0]                         cfg_interface_f , cfg_interface_nxt ;
                                       
logic [31 : 0]                         cfg_agitate_control_nxt , cfg_agitate_control_f ;
logic [31 : 0]                         cfg_agitate_select_nxt , cfg_agitate_select_f ;

logic [HQM_NUM_SN_GRP-1:0]             hqm_aw_sn_order_select;
logic [HQM_NUM_SN_GRP-1:0]             hqm_aw_sn_order_select_f;
logic [9:0]                            hqm_aw_sn_order_select_sn_f;

logic [HQM_NUM_SN_GRP-1:0]             hqm_aw_sn_ready;
                                       
logic [HQM_NUM_SN_GRP-1:0]             sn_order_shft_data_residue_check_err;
logic [HQM_NUM_SN_GRP-1:0]             sn_order_shft_data_residue_check_err_f;
                                       
logic [((HQM_NUM_SN_GRP*1024) -1) : 0] sn_order_pipe_health_sn_state_f;
logic [((HQM_NUM_SN_GRP*32) -1) : 0]   sn_order_pipe_health_valid;
logic [((HQM_NUM_SN_GRP*32) -1) : 0]   sn_order_pipe_health_hold;
                                       
logic                                  replay_sn_update;
logic                                  replay_sn_winner_v;
logic [HQM_NUM_SN_GRP_WIDTH-1:0]       replay_sn_winner;
                                       
logic [HQM_NUM_SN_GRP-1:0]             replay_v;
logic [HQM_NUM_SN_GRP-1:0]             replay_selected_dec;
logic [HQM_NUM_SN_GRP-1:0]             replay_selected;

logic [(HQM_NUM_SN_GRP*10) -1 : 0]     replay_sequence;
logic [(HQM_NUM_SN_GRP*10) -1 : 0]     replay_sequence_f;
logic [ HQM_NUM_SN_GRP-1 : 0 ]         replay_sequence_v;
logic [ HQM_NUM_SN_GRP-1 : 0 ]         replay_sequence_v_f;

logic                                  cfg_control_general_0_single_op_chp_rop_hcw;
logic                                  cfg_control_general_0_sn_start_get_rr_enable;

logic [(($bits(hist_list_info_t) -1) -1) : 0] nalb_sys_enq_parity_data; // data vector used for parity generation
logic                                         nalb_sys_enq_parity_data_parity;


logic [(($bits(hist_list_info_t) -1) -1) : 0] dp_sys_enq_parity_data; // data vector used for parity generation
logic                                         dp_sys_enq_parity_data_parity;

logic                                         rop_nalb_enq_f;        // timing fix
logic [6:0]                                   rop_nalb_enq_data_qid_f; // timing fix
enum_cmd_rop_nalb_enq_t                       rop_nalb_enq_data_cmd_f; // timing fix

logic                                         rop_dp_enq_f;
logic [6:0]                                   rop_dp_enq_data_qid_f;
enum_cmd_rop_dp_enq_t                         rop_dp_enq_data_cmd_f;

logic                                         rop_qed_dqed_enq_rop_dqed_enq_ready_f;
logic                                         rop_qed_dqed_enq_rop_qed_enq_ready_f;
logic [6:0]                                   rop_qed_dqed_enq_data_qid_f;

logic                                         rop_lsp_reordercmp_f;
logic [7:0]                                   rop_lsp_reordercmp_data_cq_f;
logic [6:0]                                   rop_lsp_reordercmp_data_qid_f;
logic                                         rop_lsp_reordercmp_data_user_f;

// frag and cmp counters

  logic                                       smon_reord_frag_cnt_nxt;
  logic                                       smon_reord_frag_cnt_f;
  logic [6:0]                                 smon_reord_frag_cnt_qid_nxt;
  logic [6:0]                                 smon_reord_frag_cnt_qid_f;
                                              
  logic                                       smon_reord_cmp_cnt_nxt;
  logic                                       smon_reord_cmp_cnt_f;
  logic [6:0]                                 smon_reord_cmp_cnt_qid_nxt;
  logic [6:0]                                 smon_reord_cmp_cnt_qid_f;

//-----------------------------------------------------------------------------------------------------
// Alarm Interface
                                                        
logic                                                   lsp_reordercmp_qidix_qpri_parity;
                                                        
sn_hazard_t                                             sn_hazard_nxt;
sn_hazard_t                                             sn_hazard_f;
                                                        
logic                                                   sn_hazard_detected;
logic                                                   mem_access_error_f;
logic                                                   mem_access_error_nxt;
                                                        
logic [15:0]                                            frag_integrity_cnt_nxt_tmp0; // increment when frag received, decrement when DIR/LDB_ENQ_REORDER_HCW sent to dp or nalb 
logic [15:0]                                            frag_integrity_cnt_nxt_tmp1; // increment when frag received, decrement when DIR/LDB_ENQ_REORDER_HCW sent to dp or nalb 
logic [15:0]                                            frag_integrity_cnt_nxt_tmp2; // increment when frag received, decrement when DIR/LDB_ENQ_REORDER_HCW sent to dp or nalb 
                                                        
logic [15:0]                                            frag_integrity_cnt_nxt; // increment when frag received, decrement when DIR/LDB_ENQ_REORDER_HCW sent to dp or nalb 
logic [15:0]                                            frag_integrity_cnt_f;
                                                        
logic [4:0]                                            frag_integrity_cnt_dec_dp_nxt; 
logic [4:0]                                            frag_integrity_cnt_dec_dp_f; 
                                                        
logic [4:0]                                            frag_integrity_cnt_dec_nalb_nxt; 
logic [4:0]                                            frag_integrity_cnt_dec_nalb_f; 
                                                        
logic                                                   frag_integrity_cnt_inc_nxt;
logic                                              frag_integrity_cnt_inc_f;
                                                   
aw_fifo_status_t chp_rop_hcw_fifo_status;
logic [ HQM_ROP_CHP_ROP_HCW_FIFO_DEPTHWIDTH - 1 : 0 ] chp_rop_hcw_fifo_cfg_high_wm ;
aw_fifo_status_t dir_rply_req_fifo_status;
logic [ HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTHWIDTH - 1 : 0 ] dir_rply_req_fifo_cfg_high_wm;
aw_fifo_status_t ldb_rply_req_fifo_status;
logic [ HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTHWIDTH - 1 : 0 ] ldb_rply_req_fifo_cfg_high_wm;
aw_fifo_status_t sn_ordered_fifo_status;
logic [ HQM_ROP_SN_ORDERED_FIFO_DEPTHWIDTH - 1 : 0 ] sn_ordered_fifo_cfg_high_wm;
aw_fifo_status_t sn_complete_fifo_status;
logic [ HQM_ROP_SN_COMPLETE_FIFO_DEPTHWIDTH- 1 : 0 ] sn_complete_fifo_cfg_high_wm;
aw_fifo_status_t lsp_reordercmp_fifo_status;
logic [ HQM_ROP_LSP_REORDERCMP_FIFO_DEPTHWIDTH- 1 : 0 ] lsp_reordercmp_fifo_cfg_high_wm;
logic rop_nalb_enq_rr_arb_update;
logic rop_nalb_enq_rr_arb_winner_v;
logic rop_nalb_enq_rr_arb_winner;
 

logic p1_rop_dp_enq_hold_stall;
logic p1_rop_nalb_enq_hold_stall;

logic rop_dp_enq_rr_arb_update;
logic rop_dp_enq_rr_arb_winner_v;
logic rop_dp_enq_rr_arb_winner;

logic    hcw_enq_sys_enq_start_reorder_last_nxt;
logic    hcw_enq_sys_enq_start_reorder_last_f;

logic    start_reorder_update_order_st_last_nxt;
logic    start_reorder_update_order_st_last_f;

//
// below 5-bit fields are only valid  when chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW
//
typedef enum logic [4:0] {
    UPDATE_ORDER_ST                                               = 5'b00001,
    START_REORDER_UPDATE_ORDER_ST                                 = 5'b00011, 
    HCW_ENQ_SYS_ENQ                                               = 5'b01100,   
    HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST                               = 5'b01101, // JP 02_28_2016 
    HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST                 = 5'b01111, // JP 02_29_2016
    SN_GET_ORDER_ST                                               = 5'b10000, // - pull from sn_order fifo to get SN ordering information
    SN_GET_ORDER_ST_START_REORDER_UPDATE_ORDER_ST                 = 5'b10011,
    SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ                               = 5'b11100,
    SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST               = 5'b11101, // UPDATE_ORDER_ST and SN_GET_ORDER_ST selected rr fashion using last serviced bit
    SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST = 5'b11111,  // UPDATE_ORDER_ST and SN_GET_ORDER_ST selected rr fashion using last serviced bit
    NVC0                                                          = 5'b00000,  // NVC not valid combination
    NVC2                                                          = 5'b00010,  // NVC not valid combination
    NVC5                                                          = 5'b00101,  // NVC not valid combinatino
    NVC6                                                          = 5'b00110,  // NVC not valid combination 
    NVC7                                                          = 5'b00111,  // NVC not valid combination
    NVC4                                                          = 5'b00100,  // NVC not valid combination SYS_ENQ
    NVC8                                                          = 5'b01000,  // NVC not valid combination                 
    NVC9                                                          = 5'b01001,  // NVC not valid combination //HCW_ENQ_UPDATE_ORDER_ST
    NVC10                                                         = 5'b01010,  // NVC not valid combination 
    NVC11                                                         = 5'b01011,  // NVC not valid combination
    NVC14                                                         = 5'b01110,  // NVC not valid combination //HCW_ENQ_SYS_ENQ_START_REORDER
    NVC17                                                         = 5'b10001,  // NVC not valid combination //SN_GET_ORDER_ST_UPDATE_ORDER_ST
    NVC18                                                         = 5'b10010,  // NVC not valid combination//SN_GET_ORDER_ST_START_REORDER
    NVC20                                                         = 5'b10100,  // NVC not valid combination//SN_GET_ORDER_ST_SYS_ENQ
    NVC21                                                         = 5'b10101,  // NVC not valid combination
    NVC22                                                         = 5'b10110,  // NVC not valid combination//SN_GET_ORDER_ST_SYS_ENQ_START_REORDER
    NVC23                                                         = 5'b10111,  // NVC not valid combination
    NVC24                                                         = 5'b11000,  // NVC not valid combination
    NVC25                                                         = 5'b11001,  // NVC not valid combination //SN_GET_ORDER_ST_HCW_ENQ_UPDATE_ORDER_ST
    NVC26                                                         = 5'b11010,  // NVC not valid combination //SN_GET_ORDER_ST_HCW_ENQ_START_REORDER
    NVC27                                                         = 5'b11011,  // NVC not valid combination
    NVC30                                                         = 5'b11110   // NVC not valid combination //SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_START_REORDER
} request_dec_t;

typedef struct packed {
    logic sn_ordered_ready;
    logic cmd_hcw_enq;
    logic cmd_sys_enq;
    logic cmd_start_sn_reorder;
    logic cmd_update_sn_order_state;
} request_bit_t;

typedef union packed {
    request_dec_t request_dec;
    request_bit_t request_bit;
} request_t;

request_t                                                request_state;

logic                                                    hqm_reorder_pipe_tx_sync_idle;


logic [30:0] err_hw_class_01_nxt, err_hw_class_01_f;
logic        err_hw_class_01_v_nxt, err_hw_class_01_v_f;
logic [30:0] err_hw_class_02_nxt, err_hw_class_02_f;
logic        err_hw_class_02_v_nxt, err_hw_class_02_v_f;

logic chp_rop_hcw_fifo_of;
logic chp_rop_hcw_fifo_uf;

logic dir_rply_req_fifo_of;
logic dir_rply_req_fifo_uf;

logic ldb_rply_req_fifo_of;
logic ldb_rply_req_fifo_uf;

logic sn_ordered_fifo_of;
logic sn_ordered_fifo_uf;

logic sn_complete_fifo_of;
logic sn_complete_fifo_uf;

logic lsp_reordercmp_fifo_of;
logic lsp_reordercmp_fifo_uf;

logic rop_cfg_ring_top_rx_fifo_uf;
logic rop_cfg_ring_top_rx_fifo_of;

logic rop_multi_frag_enable ;

generate
  if ( HQM_ROP_MULTI_FRAG_ENABLE == 1 ) begin : GEN_MULTI_FRAG_1
    assign rop_multi_frag_enable        = 1'b1 ;
  end
  else begin : GEN_MULTI_FRAG_0
    assign rop_multi_frag_enable        = 1'b0 ;
  end
endgenerate

//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: BEGIN common core interfaces
//*****************************************************************************************************
//*****************************************************************************************************

localparam NUM_CFG_ACCESSIBLE_RAM = 4 ;
//localparam CFG_ACCESSIBLE_RAM_REORD_LBHP_MEM = 0 ; // HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP
//localparam CFG_ACCESSIBLE_RAM_REORD_ST_MEM = 1 ; // HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ
//localparam CFG_ACCESSIBLE_RAM_SN0_ORDER_SHFT_MEM = 2 ; // HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT
//localparam CFG_ACCESSIBLE_RAM_SN1_ORDER_SHFT_MEM = 3 ; // HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT

assign mem_access_error_nxt = (
                            rf_reord_dirhp_mem_error |
                            rf_lsp_reordercmp_fifo_mem_error |
                            rf_sn_ordered_fifo_mem_error |
                            rf_sn1_order_shft_mem_error |
                            rf_ldb_rply_req_fifo_mem_error |
                            rf_sn_complete_fifo_mem_error |
                            rf_dir_rply_req_fifo_mem_error |
                            rf_chp_rop_hcw_fifo_mem_error |
                            rf_reord_cnt_mem_error |
                            rf_reord_dirtp_mem_error |
                            rf_reord_st_mem_error |
                            rf_reord_lbtp_mem_error |
                            rf_reord_lbhp_mem_error |
                            rf_sn0_order_shft_mem_error
                          );

//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

hqm_AW_double_buffer #(
         .WIDTH($bits(chp_rop_hcw_data))    
        ,.NOT_EMPTY_AT_EOT(0)
) i_chp_rop_hcw_db (
         .clk           ( hqm_gated_clk )
        ,.rst_n         ( hqm_gated_rst_n )

        ,.status        ( chp_rop_hcw_db_status_pnc )

        ,.in_ready      (chp_rop_hcw_ready)

        ,.in_valid      (chp_rop_hcw_v)
        ,.in_data       (chp_rop_hcw_data)

        ,.out_ready     (chp_rop_hcw_db_out_ready)
 
        ,.out_valid     (chp_rop_hcw_db_out_valid)
        ,.out_data      (chp_rop_hcw_db_out_data)
);

hqm_AW_tx_sync #( 
   .WIDTH  ( $bits(rop_lsp_reordercmp_t) )
) i_lsp_reordercmp_tx (
   .hqm_gated_clk               ( hqm_gated_clk ) // I
  ,.hqm_gated_rst_n             ( hqm_gated_rst_n ) // I

  ,.status                      ( lsp_reordercmp_db_status_pnc ) // O 6-bits
  ,.idle                        ( lsp_reordercmp_tx_idle ) // O
  ,.rst_prep                    ( rst_prep ) // I

  ,.in_ready                    ( lsp_reordercmp_db_in_ready ) // O
  ,.in_valid                    ( lsp_reordercmp_db_in_valid ) // I
  ,.in_data                     ( lsp_reordercmp_db_in_data ) // I
  ,.out_ready                   ( lsp_reordercmp_db_out_ready ) // I
  ,.out_valid                   ( lsp_reordercmp_db_out_valid ) // O
  ,.out_data                    ( lsp_reordercmp_db_out_data ) // O
) ;

hqm_reorder_pipe_tx_sync #(
   .DP_WIDTH ( $bits(dp_enq_pipe_t)  )
  ,.NALB_WIDTH ( $bits(nalb_enq_pipe_t) ) 
  ,.QED_DQED_WIDTH  ( $bits(qed_dqed_enq_pipe_t) )
) i_hqm_reorder_pipe_tx_sync (
   .hqm_gated_clk                  ( hqm_gated_clk ) // I
  ,.hqm_gated_rst_n                ( hqm_gated_rst_n ) // I

  ,.idle                           ( hqm_reorder_pipe_tx_sync_idle ) // O
  ,.rst_prep                       ( rst_prep ) // I 
 
  // rop_dp_enq interface                 
  ,.rop_dp_enq_v                   ( rop_dp_enq_v ) // O
  ,.rop_dp_enq_ready               ( rop_dp_enq_ready ) // I
  ,.rop_dp_enq_data                ( rop_dp_enq_data ) // O
 
  // rop_nalb_enq interface               
  ,.rop_nalb_enq_v                 ( rop_nalb_enq_v ) // O
  ,.rop_nalb_enq_ready             ( rop_nalb_enq_ready ) // I
  ,.rop_nalb_enq_data              ( rop_nalb_enq_data ) // O

  // rop_qed_dqed_enq interface           
  ,.rop_qed_dqed_enq_v             ( rop_qed_dqed_enq_v ) // O
  ,.rop_qed_enq_ready              ( rop_qed_enq_ready ) // I
  ,.rop_dqed_enq_ready             ( rop_dqed_enq_ready ) // I
  ,.rop_qed_dqed_enq_data          ( rop_qed_dqed_enq_data ) // O

  // rop_dp related
  ,.rop_dp_enq_rr_arb_winner_v     ( rop_dp_enq_rr_arb_winner_v ) // I 
  ,.p1_rop_dp_enq_nxt              ( p1_rop_dp_enq_nxt ) // I
  ,.p1_rop_dp_enq_f                ( p1_rop_dp_enq_f ) // O
  ,.p1_rop_dp_enq_ctl              ( p1_rop_dp_enq_ctl )// O
  ,.p1_rop_dp_enq_hold_stall       ( p1_rop_dp_enq_hold_stall ) // O

  ,.p2_rop_dp_enq_ctl              ( p2_rop_dp_enq_ctl ) // O
  ,.p2_rop_dp_enq_f                ( p2_rop_dp_enq_f ) // O

  // rop_nalb related
  ,.rop_nalb_enq_rr_arb_winner_v   ( rop_nalb_enq_rr_arb_winner_v )  // I
  ,.p1_rop_nalb_enq_nxt            ( p1_rop_nalb_enq_nxt ) // I
  ,.p1_rop_nalb_enq_f              ( p1_rop_nalb_enq_f ) // O 
  ,.p1_rop_nalb_enq_ctl            ( p1_rop_nalb_enq_ctl ) // O
  ,.p1_rop_nalb_enq_hold_stall     ( p1_rop_nalb_enq_hold_stall ) // O
  ,.p2_rop_nalb_enq_ctl            ( p2_rop_nalb_enq_ctl ) // O
  ,.p2_rop_nalb_enq_f              ( p2_rop_nalb_enq_f ) // O

  // rop_qed_dqed_enq related
  ,.p1_qed_dqed_enq_nxt            ( p1_qed_dqed_enq_nxt ) // O
  ,.p1_qed_dqed_enq_f              ( p1_qed_dqed_enq_f ) // O
  ,.p1_qed_dqed_enq_ctl            ( p1_qed_dqed_enq_ctl ) // O
  ,.p0_qed_dqed_enq_f              ( p0_qed_dqed_enq_f ) // I

);

assign rop_qed_force_clockon = p0_qed_dqed_enq_f.v | p1_qed_dqed_enq_f.v;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

assign rop_cfg_ring_top_rx_fifo_uf = rop_cfg_ring_top_rx_fifo_status.underflow;
assign rop_cfg_ring_top_rx_fifo_of = rop_cfg_ring_top_rx_fifo_status.overflow;


//------------------------------------------------------------------------------------------------------------------
// Common BCAST/VF Reset logic
logic [4:0] timeout_nc;
assign hqm_rop_target_cfg_unit_timeout_reg_nxt = {hqm_rop_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_rop_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_rop_target_cfg_unit_timeout_reg_f[4:0] ;
//
localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_rop_target_cfg_unit_version_status = cfg_unit_version;
//
////------------------------------------------------------------------------------------------------------------------

//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces 
//*****************************************************************************************************
//*****************************************************************************************************


assign hqm_rop_target_cfg_patch_control_reg_v = 1'b0 ;
assign hqm_rop_target_cfg_patch_control_reg_nxt = hqm_rop_target_cfg_patch_control_reg_f ;


generate

if (HQM_NUM_SN_GRP>0) begin
assign func_sn0_order_shft_mem_re    = func_sn_order_shft_mem_re     [0*1  +:  1];
assign func_sn0_order_shft_mem_raddr = func_sn_order_shft_mem_raddr [0*5  +:  4];  
assign func_sn0_order_shft_mem_waddr = func_sn_order_shft_mem_waddr[0*5  +:  4]; 
assign func_sn0_order_shft_mem_we    = func_sn_order_shft_mem_we     [0*1  +:  1];  
assign func_sn0_order_shft_mem_wdata = func_sn_order_shft_mem_wdata[0*12 +: 12]; 
assign func_sn_order_shft_mem_rdata [0*12 +: 12] = func_sn0_order_shft_mem_rdata;
end else begin
assign func_sn0_order_shft_mem_re    ='0 ;
assign func_sn0_order_shft_mem_raddr = '0;  
assign func_sn0_order_shft_mem_waddr = '0; 
assign func_sn0_order_shft_mem_we    = '0;  
assign func_sn0_order_shft_mem_wdata = '0; 

end

if (HQM_NUM_SN_GRP>1) begin
assign func_sn1_order_shft_mem_re    = func_sn_order_shft_mem_re     [1*1  +:  1];
assign func_sn1_order_shft_mem_raddr = func_sn_order_shft_mem_raddr [1*5  +:  4];  
assign func_sn1_order_shft_mem_waddr = func_sn_order_shft_mem_waddr[1*5  +:  4]; 
assign func_sn1_order_shft_mem_we    = func_sn_order_shft_mem_we     [1*1  +:  1];  
assign func_sn1_order_shft_mem_wdata = func_sn_order_shft_mem_wdata[1*12 +: 12]; 
assign func_sn_order_shft_mem_rdata [1*12 +: 12] = func_sn1_order_shft_mem_rdata;
end else begin
assign func_sn1_order_shft_mem_re    = '0;
assign func_sn1_order_shft_mem_raddr =  '0;
assign func_sn1_order_shft_mem_waddr = '0;
assign func_sn1_order_shft_mem_we    =   '0;
assign func_sn1_order_shft_mem_wdata = '0;
end

endgenerate

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
    err_hw_class_01_f <= '0; 
    err_hw_class_01_v_f <= '0; 
    err_hw_class_02_f <= '0; 
    err_hw_class_02_v_f <= '0; 
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt;
    err_hw_class_02_f <= err_hw_class_02_nxt;
    err_hw_class_02_v_f <= err_hw_class_02_v_nxt;
  end
end


assign request_state.request_bit.sn_ordered_ready =  (!sn_ordered_fifo_empty & !sn_hazard_detected);
assign request_state.request_bit.cmd_hcw_enq =  cmd_hcw_enq;
assign request_state.request_bit.cmd_sys_enq =  cmd_sys_enq;
assign request_state.request_bit.cmd_start_sn_reorder =  cmd_start_sn_reorder;
assign request_state.request_bit.cmd_update_sn_order_state = cmd_update_sn_order_state;

 
// end declarations

assign rop_parity_type = 1'b1; // odd 









//INITIAL

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin

    chp_rop_hcw_db2_out_valid_ready_f <= '0;
    chp_rop_hcw_db2_out_data_hist_qtype_f <= ATOMIC;


    reord_st_rmw_mem_4pipe_status_f <= '0;
    reord_lbhp_rmw_mem_4pipe_status_f <= '0;
    reord_lbtp_rmw_mem_4pipe_status_f <= '0;
    reord_dirhp_rmw_mem_4pipe_status_f <= '0;
    reord_dirtp_rmw_mem_4pipe_status_f <= '0;
    reord_cnt_rmw_mem_4pipe_status_f <= '0;
    sn_order_rmw_mem_3pipe_status_f <= '0;

    rop_nalb_enq_f        <= '0;
    rop_nalb_enq_data_qid_f <= '0;
    rop_nalb_enq_data_cmd_f <= ROP_NALB_ENQ_LB_ENQ_NEW_HCW;

    rop_dp_enq_f        <= '0;
    rop_dp_enq_data_qid_f <= '0;
    rop_dp_enq_data_cmd_f <= ROP_DP_ENQ_DIR_ENQ_NEW_HCW ;

    rop_qed_dqed_enq_data_qid_f <= '0;
    rop_qed_dqed_enq_rop_dqed_enq_ready_f <= '0;
    rop_qed_dqed_enq_rop_qed_enq_ready_f <= '0;

    rop_lsp_reordercmp_f <= '0;
    rop_lsp_reordercmp_data_cq_f <= '0;
    rop_lsp_reordercmp_data_qid_f <= '0;
    rop_lsp_reordercmp_data_user_f <= '0;

    access_sn_integrity_err_f <= '0;

    frag_integrity_cnt_nxt_tmp0_underflow_f <= '0; // frag_integrity_cnt_nxt_tmp0[15] underflow
    frag_integrity_cnt_nxt_tmp1_underflow_f <= '0; // frag_integrity_cnt_nxt_tmp1[15] underflow
    frag_integrity_cnt_nxt_tmp2_overflow_f <= '0;  // frag_integrity_cnt_nxt_tmp2[15] overflow
    sn_hazard_f <= '0;

    chp_rop_hcw_db2_hist_list_info_parity_error_f <= '0;

    rply_frag_cnt_gt_16_qid_f <= '0;
    rply_frag_cnt_gt_16_f <= '0; 

    smon_enabled_f <= '0;

    hqm_aw_sn_order_select_f <= '0;
    hqm_aw_sn_order_select_sn_f <= '0;

    sn_order_shft_data_residue_check_err_f <= '0;

    cmd_start_sn_reorder_f <= '0;
    sn_reorder_qid_f <= '0;
    replay_sequence_f <= '0;
    replay_sequence_v_f <= '0;

    sn_ordered_fifo_parity_error_f <= '0;
    sn_complete_fifo_parity_error_f <= '0;
    lsp_reordercmp_fifo_parity_error_f <= '0;
    ldb_rply_req_fifo_parity_error_f <= '0;
    dir_rply_req_fifo_parity_error_f <= '0;
    chp_rop_hcw_fifo_parity_error_f <= '0;

    chp_rop_hcw_v_f <= 1'b0;
    rop_dp_enq_v_f <= 1'b0;
    rop_nalb_enq_v_f <= 1'b0;
    rop_qed_dqed_enq_v_f <= 1'b0;
    rop_lsp_reordercmp_v_f <= 1'b0;

    smon_reord_frag_cnt_f <= '0;
    smon_reord_frag_cnt_qid_f <= '0;

    smon_reord_cmp_cnt_f <= '0;
    smon_reord_cmp_cnt_qid_f <= '0;

  end
  else begin

    chp_rop_hcw_db2_out_valid_ready_f <= chp_rop_hcw_db2_out_valid & chp_rop_hcw_db2_out_ready;
    chp_rop_hcw_db2_out_data_hist_qtype_f <= chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype;

    reord_st_rmw_mem_4pipe_status_f <= reord_st_rmw_mem_4pipe_status_nxt;
    reord_lbhp_rmw_mem_4pipe_status_f <= reord_lbhp_rmw_mem_4pipe_status_nxt;
    reord_lbtp_rmw_mem_4pipe_status_f <= reord_lbtp_rmw_mem_4pipe_status_nxt;
    reord_dirhp_rmw_mem_4pipe_status_f <= reord_dirhp_rmw_mem_4pipe_status_nxt;
    reord_dirtp_rmw_mem_4pipe_status_f <= reord_dirtp_rmw_mem_4pipe_status_nxt;
    reord_cnt_rmw_mem_4pipe_status_f <= reord_cnt_rmw_mem_4pipe_status_nxt;
    sn_order_rmw_mem_3pipe_status_f <= sn_order_rmw_mem_3pipe_status_nxt;

    rop_nalb_enq_f <= rop_nalb_enq_v & rop_nalb_enq_ready;
    rop_nalb_enq_data_qid_f <= { 1'b0 , rop_nalb_enq_data.hist_list_info.qid };
    rop_nalb_enq_data_cmd_f <= rop_nalb_enq_data.cmd;

    rop_dp_enq_f <= rop_dp_enq_v & rop_dp_enq_ready;
    rop_dp_enq_data_qid_f <= { 1'b0 , rop_dp_enq_data.hist_list_info.qid };
    rop_dp_enq_data_cmd_f <= rop_dp_enq_data.cmd;

    rop_qed_dqed_enq_data_qid_f <= rop_qed_dqed_enq_data.cq_hcw.msg_info.qid;
    rop_qed_dqed_enq_rop_dqed_enq_ready_f <= rop_qed_dqed_enq_v & rop_dqed_enq_ready;
    rop_qed_dqed_enq_rop_qed_enq_ready_f <= rop_qed_dqed_enq_v & rop_qed_enq_ready; 

    rop_lsp_reordercmp_f <= rop_lsp_reordercmp_v & rop_lsp_reordercmp_ready;
    rop_lsp_reordercmp_data_cq_f <= rop_lsp_reordercmp_data.cq[7:0];
    rop_lsp_reordercmp_data_qid_f <= rop_lsp_reordercmp_data.qid;
    rop_lsp_reordercmp_data_user_f <= rop_lsp_reordercmp_data.user;

    access_sn_integrity_err_f <= access_sn_integrity_err_nxt;

    frag_integrity_cnt_nxt_tmp0_underflow_f <= frag_integrity_cnt_nxt_tmp0[15];
    frag_integrity_cnt_nxt_tmp1_underflow_f <= frag_integrity_cnt_nxt_tmp1[15];
    frag_integrity_cnt_nxt_tmp2_overflow_f <= frag_integrity_cnt_nxt_tmp2[15];
    sn_hazard_f <= sn_hazard_nxt;

    chp_rop_hcw_db2_hist_list_info_parity_error_f <= ( chp_rop_hcw_db2_hist_list_info_parity_error_nxt & (cmd_sys_enq_frag | cmd_start_sn_reorder) );

    rply_frag_cnt_gt_16_f <= rply_frag_cnt_gt_16_nxt;
    rply_frag_cnt_gt_16_qid_f <= rply_frag_cnt_gt_16_qid_nxt;

    smon_enabled_f <= smon_enabled_nxt;

    hqm_aw_sn_order_select_f <= hqm_aw_sn_order_select; 
    hqm_aw_sn_order_select_sn_f <= sn_complete_fifo_pop_data.sn[9:0]; 

    sn_order_shft_data_residue_check_err_f <= sn_order_shft_data_residue_check_err;

    cmd_start_sn_reorder_f <= cmd_start_sn_reorder;
    sn_reorder_qid_f <= { 1'b0 , rop_dp_enq_data.hist_list_info.qid };

    replay_sequence_f <= replay_sequence;
    replay_sequence_v_f <= replay_sequence_v;

    sn_ordered_fifo_parity_error_f <= sn_ordered_fifo_parity_error_nxt;
    sn_complete_fifo_parity_error_f <= sn_complete_fifo_parity_error_nxt;
    lsp_reordercmp_fifo_parity_error_f <= lsp_reordercmp_fifo_parity_error_nxt;
    ldb_rply_req_fifo_parity_error_f <= ldb_rply_req_fifo_parity_error_nxt;
    dir_rply_req_fifo_parity_error_f <= dir_rply_req_fifo_parity_error_nxt;
    chp_rop_hcw_fifo_parity_error_f <= chp_rop_hcw_fifo_parity_error_nxt;

    chp_rop_hcw_v_f <= chp_rop_hcw_v;
    rop_dp_enq_v_f <= rop_dp_enq_v;
    rop_nalb_enq_v_f <= rop_nalb_enq_v;
    rop_qed_dqed_enq_v_f <= rop_qed_dqed_enq_v;
    rop_lsp_reordercmp_v_f <= rop_lsp_reordercmp_v;

    smon_reord_frag_cnt_f <= smon_reord_frag_cnt_nxt;
    smon_reord_frag_cnt_qid_f <= smon_reord_frag_cnt_qid_nxt;

    smon_reord_cmp_cnt_f <= smon_reord_cmp_cnt_nxt;
    smon_reord_cmp_cnt_qid_f <= smon_reord_cmp_cnt_qid_nxt;

  end
end



localparam HQM_ROP_VAS_RESET_DISABLE = 30;


always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
    chp_rop_hcw_db_out_valid_and_ready_f <= '0;
    chp_rop_hcw_db_out_data_cq_hcw_msg_info_qid_f <= '0;
  end
  else begin
    chp_rop_hcw_db_out_valid_and_ready_f <= chp_rop_hcw_db_out_valid & chp_rop_hcw_db_out_ready;
    chp_rop_hcw_db_out_data_cq_hcw_msg_info_qid_f <= {1'd0,chp_rop_hcw_db_out_data.cq_hcw.msg_info.qid};
  end
end


    assign err_hw_class_01_nxt[0] = chp_rop_hcw_fifo_of;
    assign err_hw_class_01_nxt[1] = chp_rop_hcw_fifo_uf;
    assign err_hw_class_01_nxt[2] = dir_rply_req_fifo_uf;  
    assign err_hw_class_01_nxt[3] = dir_rply_req_fifo_of; 
    assign err_hw_class_01_nxt[4] = ldb_rply_req_fifo_uf;
    assign err_hw_class_01_nxt[5] = ldb_rply_req_fifo_of;
    assign err_hw_class_01_nxt[6] = sn_ordered_fifo_uf;
    assign err_hw_class_01_nxt[7] = sn_ordered_fifo_of;
    assign err_hw_class_01_nxt[8] = sn_complete_fifo_uf;
    assign err_hw_class_01_nxt[9] = sn_complete_fifo_of;
    assign err_hw_class_01_nxt[10] = lsp_reordercmp_fifo_uf;
    assign err_hw_class_01_nxt[11] = lsp_reordercmp_fifo_of;
    assign err_hw_class_01_nxt[12] = rop_cfg_ring_top_rx_fifo_uf; 
    assign err_hw_class_01_nxt[13] = rop_cfg_ring_top_rx_fifo_of; 
    assign err_hw_class_01_nxt[14] = chp_rop_hcw_db2_hist_list_info_parity_error_f; 
    assign err_hw_class_01_nxt[15] = (frag_hist_list_qtype_not_ordered & chp_rop_hcw_db2_out_ready);  // got frag qith qtype!=ordered
    assign err_hw_class_01_nxt[16] = frag_integrity_cnt_nxt_tmp0_underflow_f;
    assign err_hw_class_01_nxt[17] = frag_integrity_cnt_nxt_tmp1_underflow_f;
    assign err_hw_class_01_nxt[18] = frag_integrity_cnt_nxt_tmp2_overflow_f;
    assign err_hw_class_01_nxt[19] = access_sn_integrity_err_f;
    assign err_hw_class_01_nxt[20] = invalid_hcw_cmd_err; // corruption in chp causing it to send unsupported cmd
    assign err_hw_class_01_nxt[21] = (chp_rop_hcw_db2_out_data.flid_parity_err & chp_rop_hcw_db2_out_ready);
    assign err_hw_class_01_nxt[22] = chp_rop_hcw_fifo_parity_error_f; 
    assign err_hw_class_01_nxt[23] = dir_rply_req_fifo_parity_error_f;
    assign err_hw_class_01_nxt[24] = ldb_rply_req_fifo_parity_error_f;
    assign err_hw_class_01_nxt[25] = sn_ordered_fifo_parity_error_f; 
    assign err_hw_class_01_nxt[26] = sn_complete_fifo_parity_error_f; 
    assign err_hw_class_01_nxt[27] = lsp_reordercmp_fifo_parity_error_f; 
    assign err_hw_class_01_nxt[30:28] =  3'd1; // code
    assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

    assign err_hw_class_02_nxt[0]  = reord_st_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[1]  = reord_lbhp_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[2]  = reord_lbtp_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[3]  = reord_dirhp_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[4]  = reord_dirtp_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[5]  = reord_cnt_rmw_mem_4pipe_status_f;
    assign err_hw_class_02_nxt[6]  = sn_order_rmw_mem_3pipe_status_f[0];
    assign err_hw_class_02_nxt[7]  = sn_order_rmw_mem_3pipe_status_f[1];
    assign err_hw_class_02_nxt[8]  = mem_access_error_f; 
    assign err_hw_class_02_nxt[9]  = sn_order_shft_data_residue_check_err_f[0];
    assign err_hw_class_02_nxt[10] = sn_order_shft_data_residue_check_err_f[1];
    assign err_hw_class_02_nxt[11] = sn_state_err_any_f[0];
    assign err_hw_class_02_nxt[12] = sn_state_err_any_f[1];
    assign err_hw_class_02_nxt[13] = rply_cnt_residue_chk_lb_err; 
    assign err_hw_class_02_nxt[14] = rply_cnt_residue_chk_dir_err;
    assign err_hw_class_02_nxt[15] = hqm_reorder_pipe_rfw_top_ipar_error;
    assign err_hw_class_02_nxt[16] = '0;
    assign err_hw_class_02_nxt[17] = '0;
    assign err_hw_class_02_nxt[18] = '0;
    assign err_hw_class_02_nxt[19] = '0;                     // rply_cnt_lb_eq_16_v_f;
    assign err_hw_class_02_nxt[20] = rply_frag_cnt_gt_16_f;  // rply_cnt_dir_eq_16_v_f;
    assign err_hw_class_02_nxt[27:21] = rply_frag_cnt_gt_16_f ? rply_frag_cnt_gt_16_qid_f : '0; // rply_cnt_eq_16_qid_f; // qid valid only when rply_cnt_lb_eq_16_v_f or rply_cnt_dir_eq_16_v_f set
    assign err_hw_class_02_nxt[30:28] =  3'd2; // code
    assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 18 : 0 ] ) ;

always_comb begin 

     int_inf_v = '0;
     int_inf_data = '0;

     int_unc_v = '0;
     int_unc_data = '0;

     int_cor_v = '0;
     int_cor_data = '0; 

     syndrome_01_capture_v = '0;
     syndrome_01_capture_data = '0;

     syndrome_00_capture_v = '0;
     syndrome_00_capture_data = '0;

    if ( err_hw_class_01_v_f & cfg_csr_control_f[0] ) begin

          int_inf_v[0]                          = 1'b1;
          int_inf_data[0].msix_map              = HQM_ALARM ;

          syndrome_01_capture_v              = cfg_csr_control_f[1];
          syndrome_01_capture_data           = err_hw_class_01_f;

     end

     if ( err_hw_class_02_v_f & cfg_csr_control_f[2] ) begin

          int_inf_v[0]                          = 1'b1;
          int_inf_data[0].msix_map              = HQM_ALARM ;

          syndrome_01_capture_v              = cfg_csr_control_f[3];
          syndrome_01_capture_data           = err_hw_class_02_f;

     end

     if ( (|ecc_check_hcw_err_mb) & cfg_csr_control_f[4] ) begin

          int_unc_v[0]                          = 1'b1; // the *err_mb wll result in hcw drop
          int_unc_data[0].rtype                 = 2'd0 ;
          int_unc_data[0].rid                   = 8'h0;
          int_unc_data[0].msix_map              = HQM_ALARM ;

          syndrome_00_capture_v                = cfg_csr_control_f[5];
          syndrome_00_capture_data             = 31'h00000004;
          
     end

     if ( (|ecc_check_hcw_err_sb) & cfg_csr_control_f[6] ) begin
 
          int_cor_v[0]                          = 1'b1;
          int_cor_data[0].rtype                 = 2'd0 ;
          int_cor_data[0].rid                   = 8'h0;
          int_cor_data[0].msix_map              = HQM_ALARM ;

          syndrome_00_capture_v                = cfg_csr_control_f[7];
          syndrome_00_capture_data             = 31'h00000008;

     end

end 

//....................................................................................................
// ECC logic

// For DIR chp_rop_hcw includes extra 6 bits for ppid in ms bits which must be included in ECC.

// check & correct hcw ecc. Done as 2 chunks
hqm_AW_ecc_check #(
         .DATA_WIDTH                          ( 64 )
        ,.ECC_WIDTH                           ( 8 )
) i_ecc_check_hcw_dir_l (
         .din_v                               ( chp_rop_hcw_fifo_push )
        ,.din                                 ( chp_rop_hcw_db_out_data.cq_hcw[0*64 +: 64] )
        ,.ecc                                 ( chp_rop_hcw_db_out_data.cq_hcw_ecc[0*8 +: 8] )
        ,.enable                              ( 1'b1 )
        ,.correct                             ( 1'b1 )
        ,.dout                                ( ecc_check_hcw_dout[0*64 +: 64])
        ,.error_sb                            ( ecc_check_hcw_err_sb[0] )
        ,.error_mb                            ( ecc_check_hcw_err_mb[0] )
) ;

hqm_AW_ecc_check #(
         .DATA_WIDTH                          ( 59 )
        ,.ECC_WIDTH                           ( 8 )
) i_ecc_check_hcw_dir_h (
         .din_v                               ( chp_rop_hcw_fifo_push )
        ,.din                                 ( chp_rop_hcw_db_out_data.cq_hcw[1*64 +: 59] )
        ,.ecc                                 ( chp_rop_hcw_db_out_data.cq_hcw_ecc[1*8 +: 8] )
        ,.enable                              ( 1'b1 )
        ,.correct                             ( 1'b1 )
        ,.dout                                ( ecc_check_hcw_dout[1*64 +: 59] )
        ,.error_sb                            ( ecc_check_hcw_err_sb[1] )
        ,.error_mb                            ( ecc_check_hcw_err_mb[1] )
);

logic chp_rop_flid_parity_chk_en ;

always_comb begin
  case ( chp_rop_hcw_db_out_data.cmd )
    CHP_ROP_ENQ_REPLAY_HCW : chp_rop_flid_parity_chk_en = 1'b1 ;
    CHP_ROP_ENQ_NEW_HCW    :
      case ( chp_rop_hcw_db_out_data.hcw_cmd )
          HQM_CMD_ENQ_NEW
        , HQM_CMD_ENQ_NEW_TOK_RET
        , HQM_CMD_ENQ_COMP
        , HQM_CMD_ENQ_COMP_TOK_RET
        , HQM_CMD_ENQ_FRAG
        , HQM_CMD_ENQ_FRAG_TOK_RET : chp_rop_flid_parity_chk_en = 1'b1 ;
          default                  : chp_rop_flid_parity_chk_en = 1'b0 ;
      endcase // hcw_cmd
    default : chp_rop_flid_parity_chk_en = 1'b0 ;
  endcase // cmd
end

hqm_AW_parity_check #( 
         .WIDTH (15) 
) i_flid_parity_check ( 
         .p( chp_rop_hcw_db_out_data.flid_parity )
        ,.d( chp_rop_hcw_db_out_data.flid )
        ,.e( chp_rop_flid_parity_chk_en )
        ,.odd( rop_parity_type )
        ,.err( chp_rop_hcw_fifo_push_data.flid_parity_err )
);


assign chp_rop_hcw_fifo_push                                 = !chp_rop_hcw_fifo_afull & chp_rop_hcw_db_out_valid;
assign chp_rop_hcw_db_out_ready                              = chp_rop_hcw_fifo_push;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.cmd            = chp_rop_hcw_db_out_data.cmd;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.flid           = chp_rop_hcw_db_out_data.flid;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.flid_parity    = chp_rop_hcw_db_out_data.flid_parity;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.hist_list_info = chp_rop_hcw_db_out_data.hist_list_info;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.hcw_cmd        = chp_rop_hcw_db_out_data.hcw_cmd;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.hcw_cmd_parity = chp_rop_hcw_db_out_data.hcw_cmd_parity;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.cq_hcw         = ecc_check_hcw_dout;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.cq_hcw_ecc     = chp_rop_hcw_db_out_data.cq_hcw_ecc;
assign chp_rop_hcw_fifo_push_data.hcw_ecc_mb_err             = |ecc_check_hcw_err_mb;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.cq_hcw_no_dec  = chp_rop_hcw_db_out_data.cq_hcw_no_dec ;


assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.parity         = chp_rop_hcw_db_out_data.parity;
assign chp_rop_hcw_fifo_push_data.chp_rop_hcw.pp_parity      = chp_rop_hcw_db_out_data.pp_parity;

hqm_AW_parity_gen #(
      .WIDTH($bits(chp_rop_hcw_fifo_push_data))
) i_chp_rop_hcw_fifo_parity_gen ( 
        .d     ( chp_rop_hcw_fifo_push_data )
       ,.odd   ( rop_parity_type )
       ,.p     ( chp_rop_hcw_fifo_push_parity ) 
);

hqm_AW_parity_check #(
        .WIDTH($bits(chp_rop_hcw_fifo_pop_data))
) i_chp_rop_hcw_fifo_parity_check ( 
        .p     ( chp_rop_hcw_fifo_pop_parity )
       ,.d     ( chp_rop_hcw_fifo_pop_data )
       ,.e     ( chp_rop_hcw_fifo_pop )
       ,.odd   ( rop_parity_type )
       ,.err   ( chp_rop_hcw_fifo_parity_error_nxt ) 
);


// FIFO for holding chp requests to rop


assign chp_rop_hcw_fifo_uf = chp_rop_hcw_fifo_status[0];
assign chp_rop_hcw_fifo_of = chp_rop_hcw_fifo_status[1];
assign chp_rop_hcw_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f[ HQM_ROP_CHP_ROP_HCW_FIFO_DEPTHWIDTH -1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt = {chp_rop_hcw_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f[7:0]};

hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_CHP_ROP_HCW_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(chp_rop_hcw_fifo_push_data)+1) )
) i_chp_rop_hcw_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( chp_rop_hcw_fifo_cfg_high_wm )

  , .fifo_status                        ( chp_rop_hcw_fifo_status )

  , .fifo_full                          ( chp_rop_hcw_fifo_full_nc )
  , .fifo_afull                         ( chp_rop_hcw_fifo_afull )
  , .fifo_empty                         ( chp_rop_hcw_fifo_empty )

  , .push                               ( chp_rop_hcw_fifo_push )
  , .push_data                          ( {chp_rop_hcw_fifo_push_parity,chp_rop_hcw_fifo_push_data} )
  , .pop                                ( chp_rop_hcw_fifo_pop )
  , .pop_data                           ( {chp_rop_hcw_fifo_pop_parity,chp_rop_hcw_fifo_pop_data} )

  , .mem_we                             ( func_chp_rop_hcw_fifo_mem_we )
  , .mem_waddr                          ( func_chp_rop_hcw_fifo_mem_waddr )
  , .mem_wdata                          ( func_chp_rop_hcw_fifo_mem_wdata )
  , .mem_re                             ( func_chp_rop_hcw_fifo_mem_re )
  , .mem_raddr                          ( func_chp_rop_hcw_fifo_mem_raddr )
  , .mem_rdata                          ( func_chp_rop_hcw_fifo_mem_rdata )
) ;

assign chp_rop_hcw_db2_in_v = ~chp_rop_hcw_fifo_empty & chp_rop_hcw_db2_in_ready;
assign chp_rop_hcw_fifo_pop = chp_rop_hcw_db2_in_v;
assign chp_rop_hcw_db2_in_data = chp_rop_hcw_fifo_pop_data;

hqm_AW_double_buffer #(
         .WIDTH($bits(errors_plus_chp_rop_hcw_t))    
        ,.NOT_EMPTY_AT_EOT(0)
) i_chp_rop_hcw_db2 (
         .clk           ( hqm_gated_clk )
        ,.rst_n         ( hqm_gated_rst_n )

        ,.status        ( chp_rop_hcw_db2_status_pnc )

        ,.in_ready      ( chp_rop_hcw_db2_in_ready )

        ,.in_valid      ( chp_rop_hcw_db2_in_v )
        ,.in_data       ( chp_rop_hcw_db2_in_data )

        ,.out_ready     ( chp_rop_hcw_db2_out_ready )
 
        ,.out_valid     ( chp_rop_hcw_db2_out_valid )
        ,.out_data      ( chp_rop_hcw_db2_out_data )
);

// check parity on the hist_list_info_

hqm_AW_parity_check #(
         .WIDTH( ($bits(chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info) -1) ) // parity only over the fields (no parity bit)
) i_chp_rop_hcw_db2_hist_list_info_parity_check ( 
         .p     ( chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.parity )
        ,.d     ( {                                                // this is messy because someone decided to include parity field in the struct
                   chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.reord_mode
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.reord_slot
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid
                 } )
        ,.e     ( chp_rop_hcw_db2_out_ready ) // reay only asserted when doing pull
        ,.odd   ( rop_parity_type )
        ,.err   ( chp_rop_hcw_db2_hist_list_info_parity_error_nxt ) 
);

hqm_AW_parity_gen #(
         .WIDTH($bits(dir_rply_req_fifo_push_data))
) i_dir_rply_req_fifo_parity_gen ( 
         .d     ( dir_rply_req_fifo_push_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( dir_rply_req_fifo_push_parity ) 
);

hqm_AW_parity_check #(
         .WIDTH($bits(dir_rply_req_fifo_pop_data))
) i_dir_rply_req_fifo_parity_check ( 
         .p     ( dir_rply_req_fifo_pop_parity )
        ,.d     ( dir_rply_req_fifo_pop_data )
        ,.e     ( dir_rply_req_fifo_pop )
        ,.odd   ( rop_parity_type )
        ,.err   ( dir_rply_req_fifo_parity_error_nxt ) 
);


// FIFO for holding chp requests to rop

assign dir_rply_req_fifo_uf = dir_rply_req_fifo_status[0];
assign dir_rply_req_fifo_of = dir_rply_req_fifo_status[1];
assign dir_rply_req_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f[ HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTHWIDTH -1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt = {dir_rply_req_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f[7:0]};


hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(dir_rply_req_fifo_push_data)+1) )
) i_dir_rply_req_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( dir_rply_req_fifo_cfg_high_wm )

  , .fifo_status                        ( dir_rply_req_fifo_status )

  , .fifo_full                          ( dir_rply_req_fifo_full_nc )
  , .fifo_afull                         ( dir_rply_req_fifo_afull )
  , .fifo_empty                         ( dir_rply_req_fifo_empty )

  , .push                               ( dir_rply_req_fifo_push )
  , .push_data                          ( {dir_rply_req_fifo_push_parity,dir_rply_req_fifo_push_data} )
  , .pop                                ( dir_rply_req_fifo_pop)
  , .pop_data                           ( {dir_rply_req_fifo_pop_parity,dir_rply_req_fifo_pop_data} )

  , .mem_we                             ( func_dir_rply_req_fifo_mem_we )
  , .mem_waddr                          ( func_dir_rply_req_fifo_mem_waddr )
  , .mem_wdata                          ( func_dir_rply_req_fifo_mem_wdata )
  , .mem_re                             ( func_dir_rply_req_fifo_mem_re )
  , .mem_raddr                          ( func_dir_rply_req_fifo_mem_raddr )
  , .mem_rdata                          ( func_dir_rply_req_fifo_mem_rdata )
) ;

hqm_AW_parity_gen #(
         .WIDTH($bits(ldb_rply_req_fifo_push_data))
) i_ldb_rply_req_fifo_parity_gen ( 
         .d     ( ldb_rply_req_fifo_push_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( ldb_rply_req_fifo_push_parity ) 
);


// FIFO for holding chp requests to rop
assign ldb_rply_req_fifo_uf = ldb_rply_req_fifo_status[0];
assign ldb_rply_req_fifo_of = ldb_rply_req_fifo_status[1];
assign ldb_rply_req_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f[ HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTHWIDTH - 1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt = {ldb_rply_req_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f[7:0]};

hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(ldb_rply_req_fifo_push_data)+1) )
) i_ldb_rply_req_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( ldb_rply_req_fifo_cfg_high_wm )

  , .fifo_status                        ( ldb_rply_req_fifo_status )

  , .fifo_full                          ( ldb_rply_req_fifo_full_nc )
  , .fifo_afull                         ( ldb_rply_req_fifo_afull )
  , .fifo_empty                         ( ldb_rply_req_fifo_empty )

  , .push                               ( ldb_rply_req_fifo_push )
  , .push_data                          ( {ldb_rply_req_fifo_push_parity,ldb_rply_req_fifo_push_data} )
  , .pop                                ( ldb_rply_req_fifo_pop )
  , .pop_data                           ( {ldb_rply_req_fifo_pop_parity,ldb_rply_req_fifo_pop_data} )

  , .mem_we                             ( func_ldb_rply_req_fifo_mem_we )
  , .mem_waddr                          ( func_ldb_rply_req_fifo_mem_waddr )
  , .mem_wdata                          ( func_ldb_rply_req_fifo_mem_wdata )
  , .mem_re                             ( func_ldb_rply_req_fifo_mem_re )
  , .mem_raddr                          ( func_ldb_rply_req_fifo_mem_raddr )
  , .mem_rdata                          ( func_ldb_rply_req_fifo_mem_rdata )
) ;

hqm_AW_parity_check #(
         .WIDTH($bits(ldb_rply_req_fifo_pop_data))
) i_ldb_rply_req_fifo_parity_check ( 
         .p     ( ldb_rply_req_fifo_pop_parity )
        ,.d     ( ldb_rply_req_fifo_pop_data )
        ,.e     ( ldb_rply_req_fifo_pop )
        ,.odd   ( rop_parity_type )
        ,.err   ( ldb_rply_req_fifo_parity_error_nxt ) 
);

hqm_AW_parity_gen #(
         .WIDTH($bits(sn_ordered_fifo_push_data))
) i_sn_ordered_fifo_parity_gen ( 
         .d     ( sn_ordered_fifo_push_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( sn_ordered_fifo_push_parity ) 
);

// FIFO for holding chp requests to rop

assign sn_ordered_fifo_uf = sn_ordered_fifo_status[0];
assign sn_ordered_fifo_of = sn_ordered_fifo_status[1];
assign sn_ordered_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f[ HQM_ROP_SN_ORDERED_FIFO_DEPTHWIDTH - 1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt = {sn_ordered_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f[7:0]};

hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_SN_ORDERED_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(sn_ordered_fifo_push_data)+1) )
) i_sn_ordered_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( sn_ordered_fifo_cfg_high_wm )

  , .fifo_status                        ( sn_ordered_fifo_status )

  , .fifo_full                          ( sn_ordered_fifo_full_nc )
  , .fifo_afull                         ( sn_ordered_fifo_afull )
  , .fifo_empty                         ( sn_ordered_fifo_empty )

  , .push                               ( sn_ordered_fifo_push )
  , .push_data                          ( {sn_ordered_fifo_push_parity,sn_ordered_fifo_push_data} )
  , .pop                                ( sn_ordered_fifo_pop )
  , .pop_data                           ( {sn_ordered_fifo_pop_parity,sn_ordered_fifo_pop_data} )

  , .mem_we                             ( func_sn_ordered_fifo_mem_we )
  , .mem_waddr                          ( func_sn_ordered_fifo_mem_waddr )
  , .mem_wdata                          ( func_sn_ordered_fifo_mem_wdata )
  , .mem_re                             ( func_sn_ordered_fifo_mem_re )
  , .mem_raddr                          ( func_sn_ordered_fifo_mem_raddr )
  , .mem_rdata                          ( func_sn_ordered_fifo_mem_rdata )
) ;

hqm_AW_parity_check #(
         .WIDTH($bits(sn_ordered_fifo_pop_data))
) i_sn_ordered_fifo_parity_check ( 
         .p     ( sn_ordered_fifo_pop_parity )
        ,.d     ( sn_ordered_fifo_pop_data )
        ,.e     ( sn_ordered_fifo_pop )
        ,.odd   ( rop_parity_type )
        ,.err   ( sn_ordered_fifo_parity_error_nxt ) 
);

hqm_AW_parity_gen #(
         .WIDTH($bits(sn_complete_fifo_push_data))
) i_sn_complete_fifo_parity_gen ( 
         .d     ( sn_complete_fifo_push_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( sn_complete_fifo_push_parity ) 
);

// FIFO for sn complete events

assign sn_complete_fifo_uf = sn_complete_fifo_status[0];
assign sn_complete_fifo_of = sn_complete_fifo_status[1];
assign sn_complete_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f[ HQM_ROP_SN_COMPLETE_FIFO_DEPTHWIDTH -1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt = {sn_complete_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f[7:0]};

hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_SN_COMPLETE_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(sn_complete_fifo_push_data)+1) )
) i_sn_complete_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( sn_complete_fifo_cfg_high_wm )

  , .fifo_status                        ( sn_complete_fifo_status )

  , .fifo_full                          ( sn_complete_fifo_full_nc )
  , .fifo_afull                         ( sn_complete_fifo_afull )
  , .fifo_empty                         ( sn_complete_fifo_empty )

  , .push                               ( sn_complete_fifo_push )
  , .push_data                          ( {sn_complete_fifo_push_parity,sn_complete_fifo_push_data} )
  , .pop                                ( sn_complete_fifo_pop )
  , .pop_data                           ( {sn_complete_fifo_pop_parity,sn_complete_fifo_pop_data} )

  , .mem_we                             ( func_sn_complete_fifo_mem_we )
  , .mem_waddr                          ( func_sn_complete_fifo_mem_waddr )
  , .mem_wdata                          ( func_sn_complete_fifo_mem_wdata )
  , .mem_re                             ( func_sn_complete_fifo_mem_re )
  , .mem_raddr                          ( func_sn_complete_fifo_mem_raddr )
  , .mem_rdata                          ( func_sn_complete_fifo_mem_rdata )
) ;

hqm_AW_parity_check #(
         .WIDTH($bits(sn_complete_fifo_push_data))
) i_sn_complete_fifo_parity_check ( 
         .p     ( sn_complete_fifo_pop_parity )
        ,.d     ( sn_complete_fifo_pop_data)
        ,.e     ( sn_complete_fifo_pop )
        ,.odd   ( rop_parity_type )
        ,.err   ( sn_complete_fifo_parity_error_nxt ) 
);

hqm_AW_parity_gen #(
         .WIDTH($bits(lsp_reordercmp_fifo_push_data))
) i_slp_reordercmp_fifo_parity_gen ( 
         .d     ( lsp_reordercmp_fifo_push_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( lsp_reordercmp_fifo_push_parity ) 
);

// FIFO for lsp reordercmp events

assign lsp_reordercmp_fifo_uf = lsp_reordercmp_fifo_status[0];
assign lsp_reordercmp_fifo_of = lsp_reordercmp_fifo_status[1];
assign lsp_reordercmp_fifo_cfg_high_wm = hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f[ HQM_ROP_LSP_REORDERCMP_FIFO_DEPTHWIDTH -1 :0];
assign hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt = {lsp_reordercmp_fifo_status[23:0],hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f[7:0]};

hqm_AW_fifo_control #(
    .DEPTH                              ( HQM_ROP_LSP_REORDERCMP_FIFO_DEPTH )
  , .DWIDTH                             ( ($bits(lsp_reordercmp_fifo_push_data)+1) )
) i_lsp_reordercmp_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )

  , .cfg_high_wm                        ( lsp_reordercmp_fifo_cfg_high_wm )

  , .fifo_status                        ( lsp_reordercmp_fifo_status )

  , .fifo_full                          ( lsp_reordercmp_fifo_full_nc )
  , .fifo_afull                         ( lsp_reordercmp_fifo_afull )
  , .fifo_empty                         ( lsp_reordercmp_fifo_empty )

  , .push                               ( lsp_reordercmp_fifo_push )
  , .push_data                          ( {lsp_reordercmp_fifo_push_parity,lsp_reordercmp_fifo_push_data} )
  , .pop                                ( lsp_reordercmp_fifo_pop )
  , .pop_data                           ( {lsp_reordercmp_fifo_pop_parity,lsp_reordercmp_fifo_pop_data} )

  , .mem_we                             ( func_lsp_reordercmp_fifo_mem_we )
  , .mem_waddr                          ( func_lsp_reordercmp_fifo_mem_waddr )
  , .mem_wdata                          ( func_lsp_reordercmp_fifo_mem_wdata [17:0] )
  , .mem_re                             ( func_lsp_reordercmp_fifo_mem_re )
  , .mem_raddr                          ( func_lsp_reordercmp_fifo_mem_raddr )
  , .mem_rdata                          ( func_lsp_reordercmp_fifo_mem_rdata [17:0] )
) ;

assign func_lsp_reordercmp_fifo_mem_wdata [ 18 ] = 1'b0 ; 

hqm_AW_parity_check #(
         .WIDTH($bits(lsp_reordercmp_fifo_push_data))
) i_lsp_reordercmp_fifo_parity_check ( 
         .p     ( lsp_reordercmp_fifo_pop_parity )
        ,.d     ( lsp_reordercmp_fifo_pop_data)
        ,.e     ( lsp_reordercmp_fifo_pop )
        ,.odd   ( rop_parity_type )
        ,.err   ( lsp_reordercmp_fifo_parity_error_nxt ) 
);

assign lsp_reordercmp_db_in_valid = (lsp_reordercmp_db_in_ready & !lsp_reordercmp_fifo_empty);
assign lsp_reordercmp_db_in_data  = lsp_reordercmp_fifo_pop_data;

assign lsp_reordercmp_fifo_pop    = lsp_reordercmp_db_in_valid;

assign lsp_reordercmp_db_out_ready = rop_lsp_reordercmp_ready;

// drive the rop_lsp_reordercmp to lsp
assign rop_lsp_reordercmp_v       = lsp_reordercmp_db_out_valid;
assign rop_lsp_reordercmp_data    = lsp_reordercmp_db_out_data;

// New requests are selected when available
// With single issue mode set only 1 request can be active
// CFG ram access has highest priority. Pipe line will be stalled until the rd/wr completes. Pipe has to be completely idle for the rd/wr to occur
assign chp_rop_hcw_db2_out_valid_req = chp_rop_hcw_db2_out_valid & 
                                       ! ( cfg_control_general_0_single_op_chp_rop_hcw & !cfg_unit_idle_nxt.pipe_idle ) & 
                                         ( ~ cfg_req_idlepipe );
                                       

always_comb begin

   invalid_hcw_cmd_err               = 1'b0;
   frag_hist_list_qtype_not_ordered  = 1'b0;
                                     
   ldb_type                          = 1'b0;
   dir_type                          = 1'b0;
                                     
   cmd_update_sn_order_state         = 1'b0; // incoming NEW_HCW is fragment
   cmd_update_sn_order_state_frag_op = REORD_COMP; // REORD_FRAG, REORD_READ_CLEAR, REORD_COMP 

   cmd_noop                          = 1'b0; // when set incoming hcw has noop cmd
   cmd_hcw_enq                       = 1'b0; // 
   cmd_start_sn_reorder              = 1'b0; // send down ordering pipe
   cmd_sys_enq                       = 1'b0;
   cmd_sys_enq_frag                  = 1'b0;

   p0_qed_dqed_enq_nxt.data = p0_qed_dqed_enq_f.data;
   p0_rop_nalb_enq_nxt.data = p0_rop_nalb_enq_f.data;
   p0_rop_dp_enq_nxt.data   = p0_rop_dp_enq_f.data;

   p0_rop_dp_enq_nxt.data.frag_list_info.hptr_parity = 1'b1; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_dp_enq_nxt.data.frag_list_info.hptr = '0;
   p0_rop_dp_enq_nxt.data.frag_list_info.tptr_parity = 1'b1; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_dp_enq_nxt.data.frag_list_info.tptr = '0;
   p0_rop_dp_enq_nxt.data.frag_list_info.cnt_residue = '0; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_dp_enq_nxt.data.frag_list_info.cnt = '0;
   p0_rop_nalb_enq_nxt.data.frag_list_info.hptr_parity = 1'b1; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_nalb_enq_nxt.data.frag_list_info.hptr = '0;
   p0_rop_nalb_enq_nxt.data.frag_list_info.tptr_parity = 1'b1; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_nalb_enq_nxt.data.frag_list_info.tptr = '0;
   p0_rop_nalb_enq_nxt.data.frag_list_info.cnt_residue = '0; // this is doen here to avoid errors reported in dir pipe when data on this interface is not valid
   p0_rop_nalb_enq_nxt.data.frag_list_info.cnt = '0;

   nalb_sys_enq_parity_data = '0;
   dp_sys_enq_parity_data = '0;

   // if there are requests from CHP process them in this way
   // cmd==NEW_HCW - enque the qe and send 

   // moved here to allow tool to insert cg cell
   if (p0_qed_dqed_enq_ctl.enable) begin
         p0_qed_dqed_enq_nxt.data.flid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
         p0_qed_dqed_enq_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
         p0_qed_dqed_enq_nxt.data.cq_hcw      = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw;
         p0_qed_dqed_enq_nxt.data.cq_hcw_ecc  = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_ecc;
   end

   if ( chp_rop_hcw_db2_out_valid_req ) begin


     case(chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qtype[1:0])
           ATOMIC : begin ldb_type = 1'b1; end
        UNORDERED : begin ldb_type = 1'b1; end
          ORDERED : begin ldb_type = 1'b1; end
           DIRECT : begin dir_type = 1'b1; end
          default : begin dir_type = 1'b0; ldb_type = 1'b0; end
     endcase

     if (chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) begin 

     case(chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0])
                      HQM_CMD_NOOP : begin // 4'b0000
                                           cmd_hcw_enq = 1'b1;
                                           cmd_noop = 1'b1;
                                           cmd_sys_enq = 1'b1;
                                     end
              HQM_CMD_COMP                 // 4'b0010
             ,HQM_CMD_COMP_TOK_RET : begin // 4'b0011, enq the hcw and if hist_list qyte==ORDERED terminate the seqnum
                                            cmd_start_sn_reorder = 1'b1;
                                            cmd_update_sn_order_state = 1'b1;
                                            cmd_update_sn_order_state_frag_op = REORD_COMP;  // REORD_FRAG JP 02_29_2016

                                            if (chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype != ORDERED) begin
                                              frag_hist_list_qtype_not_ordered = 1'b1; // It is an error to get completion for qtype stored in hist list other than ORDERED 
                                            end
                                     end
           HQM_CMD_ENQ_NEW                 // 4'b1000 
          ,HQM_CMD_ENQ_NEW_TOK_RET : begin // 4'b1001
                                           cmd_hcw_enq = 1'b1;
                                           cmd_sys_enq = 1'b1; 
                                     end

          HQM_CMD_ENQ_COMP                 // 4'b1010 
        , HQM_CMD_ENQ_COMP_TOK_RET : begin // 4'b1011
                                       if (chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype == ORDERED) begin // this is case of RENQ which can be last frag with completion or first and last frag with completion
                                            cmd_hcw_enq = 1'b1;
                                            cmd_sys_enq = 1'b1; 
                                            cmd_sys_enq_frag = 1'b1;  // JP 03_14_2016
                                            cmd_update_sn_order_state = 1'b1;
                                            cmd_update_sn_order_state_frag_op = REORD_FRAG_COMP;
                                            cmd_start_sn_reorder = 1'b1; 
                                       end
                                       else begin
                                            cmd_hcw_enq = 1'b1;
                                            cmd_sys_enq = 1'b1; 
                                       end

                                     end

          // If HQM_ROP_MULTI_FRAG_ENABLE=0, these commands should be screened by system and not make it here
          HQM_CMD_ENQ_FRAG                 // 4'b1100
         ,HQM_CMD_ENQ_FRAG_TOK_RET : begin // 4'b1100
                                           cmd_hcw_enq = 1'b1; 
                                           cmd_sys_enq = 1'b1; 
                                           cmd_sys_enq_frag = 1'b1; 
                                           cmd_update_sn_order_state = 1'b1;
                                           cmd_update_sn_order_state_frag_op = REORD_FRAG;
  
                                           if ( chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype != ORDERED ) begin
                                             frag_hist_list_qtype_not_ordered = 1'b1;
                                           end
                                      end

                           default : begin // HQM_CMD_BAT_TOK_RET;HQM_CMD_ILLEGAL_CMD_4;HQM_CMD_ILLEGAL_CMD_5;HQM_CMD_ILLEGAL_CMD_6;HQM_CMD_ILLEGAL_CMD_7;HQM_CMD_ILLEGAL_CMD_14;HQM_CMD_ILLEGAL_CMD_15
                                           invalid_hcw_cmd_err = 1'b1; 
                                     end
       endcase

       // special case modify the hcw enq cmd when incoming NEW_HCW is NOOP
  
       if (p0_qed_dqed_enq_ctl.enable) begin

           if (ldb_type) begin p0_qed_dqed_enq_nxt.data.cmd = cmd_noop ? ROP_QED_DQED_ENQ_LB_NOOP : ROP_QED_DQED_ENQ_LB; end
           if (dir_type) begin p0_qed_dqed_enq_nxt.data.cmd = cmd_noop ? ROP_QED_DQED_ENQ_DIR_NOOP : ROP_QED_DQED_ENQ_DIR; end

       end 

       if ( ldb_type & cmd_sys_enq) begin // send over cmd, flid, flid_ecc, qid, qpri and qtype

           if (p0_rop_nalb_enq_ctl.enable) begin 

               p0_rop_nalb_enq_nxt.data.cmd = cmd_noop ? ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP : 
                                              cmd_sys_enq_frag ? ROP_NALB_ENQ_LB_ENQ_REORDER_HCW : ROP_NALB_ENQ_LB_ENQ_NEW_HCW;
               
               p0_rop_nalb_enq_nxt.data.flid                      = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid; 
               p0_rop_nalb_enq_nxt.data.flid_parity               = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity ;
               p0_rop_nalb_enq_nxt.data.cq                        = { 1'h0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid } ;
               p0_rop_nalb_enq_nxt.data.hist_list_info.reord_mode = '0; // not needed
               p0_rop_nalb_enq_nxt.data.hist_list_info.reord_slot = '0; // not needed

               if ( cmd_sys_enq_frag ) begin
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qidix_msb  = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qidix      = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.sn_fid     = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid; // used for hazard detection to stop SN from progressing when bp on rp_nalb_enq
               end 
               else begin
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qtype;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qpri;
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qid [ 5 : 0 ];
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qidix_msb  = '0; // not needed
                  p0_rop_nalb_enq_nxt.data.hist_list_info.qidix      = '0; // not needed
                  p0_rop_nalb_enq_nxt.data.hist_list_info.sn_fid     = '0; // not needed
               end

               nalb_sys_enq_parity_data = {
                                       p0_rop_nalb_enq_nxt.data.hist_list_info.qtype
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.qpri
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.qid
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.qidix_msb
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.qidix
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.reord_mode
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.reord_slot
                                      ,p0_rop_nalb_enq_nxt.data.hist_list_info.sn_fid
                                     };

               p0_rop_nalb_enq_nxt.data.hist_list_info.parity     = nalb_sys_enq_parity_data_parity;

           end

       end 
       else if ( dir_type & cmd_sys_enq ) begin // send over cmd, flid, flid_ecc, qid, qpri and qtype

           if (p0_rop_dp_enq_ctl.enable) begin

               p0_rop_dp_enq_nxt.data.cmd = cmd_noop ?  ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP : 
                                            cmd_sys_enq_frag ? ROP_DP_ENQ_DIR_ENQ_REORDER_HCW : ROP_DP_ENQ_DIR_ENQ_NEW_HCW;
               
               p0_rop_dp_enq_nxt.data.flid                      = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid; 
               p0_rop_dp_enq_nxt.data.flid_parity               = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
               p0_rop_dp_enq_nxt.data.cq                        = { 1'h0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid } ;
               p0_rop_dp_enq_nxt.data.hist_list_info.reord_mode = '0; // not needed
               p0_rop_dp_enq_nxt.data.hist_list_info.reord_slot = '0; // not needed

               if ( cmd_sys_enq_frag ) begin
                  p0_rop_dp_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qidix_msb  = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qidix      = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                  p0_rop_dp_enq_nxt.data.hist_list_info.sn_fid     = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid; // used for hazard detection to stop SN from progressing when bp on rp_dp_enq*
               end 
               else begin
                  p0_rop_dp_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qtype;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qpri;
                  p0_rop_dp_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qid [ 5 : 0 ];
                  p0_rop_dp_enq_nxt.data.hist_list_info.qidix_msb  = '0; // not needed
                  p0_rop_dp_enq_nxt.data.hist_list_info.qidix      = '0; // not needed
                  p0_rop_dp_enq_nxt.data.hist_list_info.sn_fid     = '0; // not needed
               end

               dp_sys_enq_parity_data = {
                                       p0_rop_dp_enq_nxt.data.hist_list_info.qtype
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.qpri
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.qid
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.qidix_msb
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.qidix
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.reord_mode
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.reord_slot
                                      ,p0_rop_dp_enq_nxt.data.hist_list_info.sn_fid
                                     };

               p0_rop_dp_enq_nxt.data.hist_list_info.parity     = dp_sys_enq_parity_data_parity; // parity generated just on data

           end 

       end // if ( ldb_type ) begin

     end 
     else if ((chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_REPLAY_HCW) ) begin

       if (ldb_type) begin

           if (p0_rop_nalb_enq_ctl.enable) begin 
         p0_rop_nalb_enq_nxt.data.cmd                     = ROP_NALB_ENQ_LB_ENQ_NEW_HCW;

        p0_rop_nalb_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qtype;
        p0_rop_nalb_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qpri;
        p0_rop_nalb_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qid [ 5 : 0 ];
        p0_rop_nalb_enq_nxt.data.hist_list_info.reord_mode = '0; // not needed
        p0_rop_nalb_enq_nxt.data.hist_list_info.reord_slot = '0; // not needed
        p0_rop_nalb_enq_nxt.data.hist_list_info.sn_fid     = '0; // not needed

         nalb_sys_enq_parity_data = {
                                 p0_rop_nalb_enq_nxt.data.hist_list_info.qtype
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.qpri
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.qid
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.qidix_msb
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.qidix
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.reord_mode
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.reord_slot
                                ,p0_rop_nalb_enq_nxt.data.hist_list_info.sn_fid
                               };

         p0_rop_nalb_enq_nxt.data.hist_list_info.parity = nalb_sys_enq_parity_data_parity; // parity generated just on data
         p0_rop_nalb_enq_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
         p0_rop_nalb_enq_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
         p0_rop_nalb_enq_nxt.data.cq = { 1'h0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid } ;
          end

       end 
       else if (dir_type) begin

           if (p0_rop_dp_enq_ctl.enable) begin
         p0_rop_dp_enq_nxt.data.cmd = ROP_DP_ENQ_DIR_ENQ_NEW_HCW;

         p0_rop_dp_enq_nxt.data.hist_list_info.qtype      = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qtype;
         p0_rop_dp_enq_nxt.data.hist_list_info.qpri       = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qpri;
         p0_rop_dp_enq_nxt.data.hist_list_info.qid        = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.msg_info.qid [ 5 : 0 ];
         p0_rop_dp_enq_nxt.data.hist_list_info.reord_mode = '0; // not needed
         p0_rop_dp_enq_nxt.data.hist_list_info.reord_slot = '0; // not needed
         p0_rop_dp_enq_nxt.data.hist_list_info.sn_fid     = '0; // not needed

         dp_sys_enq_parity_data = {
                                 p0_rop_dp_enq_nxt.data.hist_list_info.qtype
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.qpri
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.qid
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.qidix_msb
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.qidix
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.reord_mode
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.reord_slot
                                ,p0_rop_dp_enq_nxt.data.hist_list_info.sn_fid
                               };
 
         p0_rop_dp_enq_nxt.data.hist_list_info.parity = dp_sys_enq_parity_data_parity; 
         p0_rop_dp_enq_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
         p0_rop_dp_enq_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
         p0_rop_dp_enq_nxt.data.cq = { 1'h0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid } ;
          end

       end // if (ldb_type) begin

     end // if (chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) begin

  end // if (chp_rop_hcw_db2_out_valid) begin

end // always_comb

// generate parity on hist_list_info for the rop_dp_enq at first stage of the pipe line
hqm_AW_parity_gen #(
         .WIDTH( ($bits(hist_list_info_t) -1) )
) i_rop_nalb_enq_parity_gen  (
         .d     ( nalb_sys_enq_parity_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( nalb_sys_enq_parity_data_parity )
);

hqm_AW_parity_gen #(
         .WIDTH( ($bits(hist_list_info_t) -1) )
) i_rop_dp_enq_parity_gen  (
         .d     ( dp_sys_enq_parity_data )
        ,.odd   ( rop_parity_type )
        ,.p     ( dp_sys_enq_parity_data_parity )
);

hqm_AW_rr_arb #(
    .NUM_REQS ( 2 )
) i_rop_nalb_enq_rr_arb (
    .clk      ( hqm_gated_clk )
  , .rst_n    ( hqm_gated_rst_n )
  , .reqs     ( {p0_rop_nalb_enq_f.v,~ldb_rply_req_fifo_empty} )
  , .update   ( rop_nalb_enq_rr_arb_update )
  , .winner_v ( rop_nalb_enq_rr_arb_winner_v ) 
  , .winner   ( rop_nalb_enq_rr_arb_winner )
) ;

// rop_nalb_enq pipe line controls
always_comb begin

         ldb_rply_req_fifo_pop            = 1'b0;
         rop_nalb_enq_rr_arb_update       = 1'b0;

         p1_rop_nalb_enq_nxt.data         = p1_rop_nalb_enq_f.data;

         p0_rop_nalb_enq_ctl.hold         = p0_rop_nalb_enq_f.v & ( p1_rop_nalb_enq_hold_stall | ~(rop_nalb_enq_rr_arb_winner_v & (rop_nalb_enq_rr_arb_winner==1) )) ; 

          p1_rop_nalb_enq_nxt.v            = ( rop_nalb_enq_rr_arb_winner_v & ~p1_rop_nalb_enq_hold_stall ) | p1_rop_nalb_enq_ctl.hold;
                                          
         if (p1_rop_nalb_enq_ctl.enable) begin 
            rop_nalb_enq_rr_arb_update = 1'b1;
            case(rop_nalb_enq_rr_arb_winner)
              1'b0 : begin 
                 p1_rop_nalb_enq_nxt.data.cmd                  = ROP_NALB_ENQ_LB_ENQ_REORDER_LIST;
                 p1_rop_nalb_enq_nxt.data.hist_list_info       = '0; // .qtype, .reord_mode, .reord_slot, .sn_fid not used on this interface
                 p1_rop_nalb_enq_nxt.data.hist_list_info.qid   = ldb_rply_req_fifo_pop_data.qid [ 5 : 0 ];
                 p1_rop_nalb_enq_nxt.data.hist_list_info.qpri  = ldb_rply_req_fifo_pop_data.qpri;
                 p1_rop_nalb_enq_nxt.data.hist_list_info.qidix_msb = ldb_rply_req_fifo_pop_data.qidix_msb;
                 p1_rop_nalb_enq_nxt.data.hist_list_info.qidix = ldb_rply_req_fifo_pop_data.qidix;
                 p1_rop_nalb_enq_nxt.data.hist_list_info.parity = ( ldb_rply_req_fifo_pop_data.parity ~^ ldb_rply_req_fifo_pop_data_cq_parity );
                 p1_rop_nalb_enq_nxt.data.frag_list_info       = ldb_rply_req_fifo_pop_data.frag_list_info;
                 p1_rop_nalb_enq_nxt.data.cq                   = { 1'b0 , ldb_rply_req_fifo_pop_data.cq };
                 ldb_rply_req_fifo_pop                         = 1'b1; // pop the ldb_rply_req_fifo note that system always wins 

             end
              1'b1 : begin 
                        p1_rop_nalb_enq_nxt.data = p0_rop_nalb_enq_f.data;
                     end
            endcase
         end
end

// the parity over the cq will be subracted out of the parity coming out of the rply_req_fifo
// and used as parity going on the reorder_list inteface
hqm_AW_parity_gen #( .WIDTH(8) ) i_ldb_rply_req_fifo_pop_data_cq_gen (
         .d     ( { 1'b0 , ldb_rply_req_fifo_pop_data.cq } ) // cq from fifo
        ,.odd   ( rop_parity_type )
        ,.p     ( ldb_rply_req_fifo_pop_data_cq_parity )
);

// rop_dp_enq pipe line controls
// new hcw (not fragment) 
// issue hcw enq request to (nalb/dp) and issue system enq request (nalb/dp)
// handle special case - always ensure that hcw enq request go out before or simulataneously with system enq requests
// 
// new hcw (fragment)
// issue hcw enq request to (nalb/dp 
// update reorder state and place the fragment into replay list
// if last fragment or termination request start completion process 

hqm_AW_rr_arb #(
    .NUM_REQS ( 2 )
) i_rop_dp_enq_rr_arb (
    .clk      ( hqm_gated_clk )
  , .rst_n    ( hqm_gated_rst_n )
  , .reqs     ( { p0_rop_dp_enq_f.v ,~dir_rply_req_fifo_empty } )
  , .update   ( rop_dp_enq_rr_arb_update )
  , .winner_v ( rop_dp_enq_rr_arb_winner_v ) 
  , .winner   ( rop_dp_enq_rr_arb_winner )
) ;

always_comb begin

         dir_rply_req_fifo_pop      = 1'b0;
         rop_dp_enq_rr_arb_update   = 1'b0;

         p1_rop_dp_enq_nxt.data     = p1_rop_dp_enq_f.data;

         p0_rop_dp_enq_ctl.hold     = p0_rop_dp_enq_f.v & ( p1_rop_dp_enq_hold_stall | ~(rop_dp_enq_rr_arb_winner_v & (rop_dp_enq_rr_arb_winner==1)));

         p1_rop_dp_enq_nxt.v        = (rop_dp_enq_rr_arb_winner_v & ~p1_rop_dp_enq_hold_stall) | p1_rop_dp_enq_ctl.hold;
         
         if (p1_rop_dp_enq_ctl.enable) begin
            rop_dp_enq_rr_arb_update = 1'b1;
            case(rop_dp_enq_rr_arb_winner)
              1'b0 : begin 
                p1_rop_dp_enq_nxt.data.cmd                  = ROP_DP_ENQ_DIR_ENQ_REORDER_LIST;
                p1_rop_dp_enq_nxt.data.hist_list_info       = '0; // .qtype, .reord_mode, .reord_slot, .sn_fid not used
                p1_rop_dp_enq_nxt.data.hist_list_info.qpri  = dir_rply_req_fifo_pop_data.qpri;
                p1_rop_dp_enq_nxt.data.hist_list_info.qid   = dir_rply_req_fifo_pop_data.qid [ 5 : 0 ];
                p1_rop_dp_enq_nxt.data.hist_list_info.qidix_msb = dir_rply_req_fifo_pop_data.qidix_msb;
                p1_rop_dp_enq_nxt.data.hist_list_info.qidix = dir_rply_req_fifo_pop_data.qidix;
                p1_rop_dp_enq_nxt.data.hist_list_info.parity = (dir_rply_req_fifo_pop_data.parity ~^dir_rply_req_fifo_pop_data_cq_parity);
                p1_rop_dp_enq_nxt.data.frag_list_info       = dir_rply_req_fifo_pop_data.frag_list_info;
                p1_rop_dp_enq_nxt.data.cq                   = { 1'b0 , dir_rply_req_fifo_pop_data.cq };
                dir_rply_req_fifo_pop                       = 1'b1; // pop the dir_rply_req_fifo

                     end 
              1'b1 : begin 
                        p1_rop_dp_enq_nxt.data = p0_rop_dp_enq_f.data;
            end
            endcase
         end

end







// the parity over the cq will be subracted out of the parity coming out of the rply_req_fifo
// and used as parity going on the reorder_list inteface
hqm_AW_parity_gen #( .WIDTH(8) ) i_dir_rply_req_fifo_pop_data_cq_gen (
         .d     (  { 1'b0 , dir_rply_req_fifo_pop_data.cq } ) // cq from fifo
        ,.odd   ( rop_parity_type )
        ,.p     ( dir_rply_req_fifo_pop_data_cq_parity )
);

// qed_dqed_enq pipe line controls
always_comb begin

         p0_qed_dqed_enq_ctl.hold   = p0_qed_dqed_enq_f.v & p1_qed_dqed_enq_ctl.hold;
end

//------------------------------------------------------------------
// PIPE controls
//------------------------------------------------------------------
// The incoming chp_rop_hcw is used to load these pipelines
// 
// qed_dqed_enq     pipe line
// rop_nalb_enq     pipe line
// rop_dp_enq       pipe line
// reord            pipe line 
// reord_st         pipe line
// reord_lbhp       pipe line
// reord_lbtp       pipe line
// reord_dirhp      pipe line
// reord_dirtp      pipe line
// reord_cnt        pipe line

always_comb begin

         sn_ordered_fifo_pop = 1'b0;

         p0_qed_dqed_enq_ctl.enable = 1'b0;
         p0_rop_nalb_enq_ctl.enable = 1'b0;
         p0_rop_dp_enq_ctl.enable = 1'b0;

         p0_reord_nxt.data = p0_reord_f.data;
         p0_reord_ctl.enable = 1'b0;
         
         p0_reord_st_v_nxt = 1'b0;
         p0_reord_cnt_v_nxt = '0;
         
         p0_reord_lbhp_v_nxt = '0;
         p0_reord_lbtp_v_nxt = '0;
         
         p0_reord_dirhp_v_nxt = '0;
         p0_reord_dirtp_v_nxt = '0;

         p0_reord_st_write_data_nxt = '0;
         p0_reord_st_write_data_nxt.parity = 1'b1;
         p0_reord_cnt_write_data_nxt = '0;

         p0_reord_lbhp_write_data_nxt = 15'h7ead;
         p0_reord_lbtp_write_data_nxt = '0;

         p0_reord_dirhp_write_data_nxt = 15'h7ead;
         p0_reord_dirtp_write_data_nxt = '0;
         
         p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_NOOP;
         p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_NOOP;

         p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
         p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;

         p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
         p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;

         p0_reord_st_addr_nxt    = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];
         p0_reord_cnt_addr_nxt   = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];

         p0_reord_lbhp_addr_nxt  = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];
         p0_reord_lbtp_addr_nxt  = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];

         p0_reord_dirhp_addr_nxt = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];
         p0_reord_dirtp_addr_nxt = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn[HQM_ROP_NUM_SN_B2-1:0];

         sn_complete_fifo_push = 1'b0;

         sn_complete_fifo_push_data.sn = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn;
         sn_complete_fifo_push_data.grp_mode = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.reord_mode;
         sn_complete_fifo_push_data.grp_slt = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.reord_slot;


         smon_reord_cmp_cnt_nxt = 1'b0;
         smon_reord_cmp_cnt_qid_nxt = { 1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};

         smon_reord_frag_cnt_nxt = 1'b0;
         smon_reord_frag_cnt_qid_nxt = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};

         chp_rop_hcw_db2_out_ready = 1'b0;

         hcw_enq_sys_enq_start_reorder_last_nxt = hcw_enq_sys_enq_start_reorder_last_f;
         start_reorder_update_order_st_last_nxt = start_reorder_update_order_st_last_f;

         if ( ( chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_REPLAY_HCW ) & chp_rop_hcw_db2_out_valid_req ) begin

              if (ldb_type & ~p0_rop_nalb_enq_ctl.hold) begin
                   chp_rop_hcw_db2_out_ready = 1'b1;
                   p0_rop_nalb_enq_ctl.enable = 1'b1;
              end 
              else if (dir_type & ~p0_rop_dp_enq_ctl.hold) begin
                   chp_rop_hcw_db2_out_ready = 1'b1;
                   p0_rop_dp_enq_ctl.enable = 1'b1;
              end

              // Issue the request only if there are enought head room in the dir/ldb replay FIFOs.
              // This is done to avoid hold blocking issue in the main pipeline
              if ( request_state.request_bit.sn_ordered_ready ) begin
                 if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull) ) begin
                     sn_ordered_fifo_pop = 1'b1;
                 
                     // fetch the SN replay state information
                
                     p0_reord_ctl.enable = 1'b1; 
                     p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                 
                     p0_reord_dirhp_v_nxt = 1'b1;
                     p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                     p0_reord_dirtp_v_nxt = 1'b1;
                     p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                     p0_reord_lbhp_v_nxt = 1'b1;
                     p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                     p0_reord_lbtp_v_nxt = 1'b1;
                     p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                     p0_reord_st_v_nxt = 1'b1;
                     p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                     p0_reord_cnt_v_nxt = 1'b1;
                     p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                     p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                 
                 end
              end
         end
         else if ( (( chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW ) & chp_rop_hcw_db2_out_valid_req) | request_state.request_bit.sn_ordered_ready  ) begin // new hcw coming in and hcw command is legal: check if ordering state needs updating

                 case ( request_state.request_dec ) 

                               UPDATE_ORDER_ST : begin // 5'b00001 - incoming request ordered fragment 
            
                                                     if ( !p0_reord_ctl.hold ) begin
                   
                                                         chp_rop_hcw_db2_out_ready = 1'b1; // pull next data in db
                   
                                                         p0_reord_ctl.enable = 1'b1;
                                                         
                                                         if (p0_reord_ctl.enable) begin 

                                                             p0_reord_nxt.data.frag_op = cmd_update_sn_order_state_frag_op;
                                                             p0_reord_nxt.data.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid}; // needed to id qid when frag_cnt error is detected 
                                                         
                                                             p0_reord_nxt.data.frag_type = ldb_type ? REORD_FRAG_LB : REORD_FRAG_DIR;
                                                             p0_reord_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
                                                             p0_reord_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;

                                                         end
                                                         
                                                         // increment frag cnt
                                                         smon_reord_frag_cnt_nxt = 1'b1;
                                                         
                                                         // set of increment the lb/dir counter 
                                                         p0_reord_cnt_v_nxt = 1'b1;
                                                         p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         
                                                         p0_reord_st_v_nxt = 1'b1;
                                                         p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_WRITE; // we will re-write state on every frag
                                                         p0_reord_st_write_data_nxt.parity = reord_st_parity;
                                                         p0_reord_st_write_data_nxt.reord_st_valid = 1'b1;
                                                         p0_reord_st_write_data_nxt.reord_st.user = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec; // don't care but included for parity generation
                                                         p0_reord_st_write_data_nxt.reord_st.qid = { 1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid };
                                                         p0_reord_st_write_data_nxt.reord_st.qidix = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                                                         //p0_reord_st_write_data_nxt.reord_st.is_ldb = ldb_type ;
                                                         //p0_reord_st_write_data_nxt.reord_st.nz_count = 1'b1 ;
                                                         p0_reord_st_write_data_nxt.reord_st.qidix_msb = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                                                         p0_reord_st_write_data_nxt.reord_st.cq = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid;
                                                         p0_reord_st_write_data_nxt.reord_st.qpri = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;

                                                         //--------------------------------------------------------------------------------------------------
                                                         if ( rop_multi_frag_enable ) begin
                                                          if ( ldb_type ) begin 
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                        
                                                             p0_reord_lbtp_v_nxt = 1'b1;
                                                             p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end 
                                                          else if (dir_type ) begin
                                                             p0_reord_dirhp_v_nxt = 1'b1;
                                                             p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                              
                                                             p0_reord_dirtp_v_nxt = 1'b1;
                                                             p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_dirtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end
                                                         end // if rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                         else begin
                                                          if ( ldb_type ) begin 
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end 
                                                          else if (dir_type ) begin
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end
                                                         end // else rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                     end
                                                 end
                  START_REORDER_UPDATE_ORDER_ST : begin // 5'b00011 - update order state and start SN reorder process
          
                                                      if ( !( sn_complete_fifo_afull  | p0_reord_ctl.hold ) ) begin
                                                 
                                                           chp_rop_hcw_db2_out_ready = 1'b1; // pull next data in db
                                                 
                                                           sn_complete_fifo_push = 1'b1; // start the sequence reorder process
                                                 
                                                           p0_reord_ctl.enable = 1'b1;
                                                           
                                                           if ( p0_reord_ctl.enable ) begin 
                                                               p0_reord_nxt.data.frag_op = cmd_update_sn_order_state_frag_op;
                                                               p0_reord_nxt.data.qid = { 1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid }; // needed to id qid when frag_cnt error is detected 
                                                               p0_reord_nxt.data.frag_type = ldb_type ? REORD_FRAG_LB : REORD_FRAG_DIR;
                                                               p0_reord_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
                                                               p0_reord_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
                                                           end
                                                          
                                                           // increment cmp cnt 
                                                           smon_reord_cmp_cnt_nxt = 1'b1;
                                                          
                                                           // Dont increment the cnt ldb/dir counter 
                                                           p0_reord_cnt_v_nxt = 1'b1;
                                                           p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_NOOP; // just update order_state info
                                                           
                                                           p0_reord_st_v_nxt = 1'b1;
                                                           p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                           p0_reord_st_write_data_nxt.parity = reord_st_parity;
                                                           p0_reord_st_write_data_nxt.reord_st_valid = 1'b1;
                                                           p0_reord_st_write_data_nxt.reord_st.user = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec;
                                                           p0_reord_st_write_data_nxt.reord_st.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};
                                                           p0_reord_st_write_data_nxt.reord_st.qidix = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                                                           //p0_reord_st_write_data_nxt.reord_st.is_ldb = ldb_type ;
                                                           //p0_reord_st_write_data_nxt.reord_st.nz_count = 1'b0 ;        // Not incrementing the count
                                                           p0_reord_st_write_data_nxt.reord_st.qidix_msb = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                                                           p0_reord_st_write_data_nxt.reord_st.cq = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid;
                                                           p0_reord_st_write_data_nxt.reord_st.qpri = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                                                            
                                                           //--------------------------------------------------------------------------------------------------
                                                           if ( rop_multi_frag_enable ) begin
                                                             if ( ldb_type ) begin
                                                                p0_reord_lbhp_v_nxt = 1'b1;
                                                                p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;

                                                                p0_reord_lbtp_v_nxt = 1'b1;
                                                                p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                                p0_reord_lbtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                             end
                                                             else if (dir_type ) begin
                                                                p0_reord_dirhp_v_nxt = 1'b1;
                                                                p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;

                                                                p0_reord_dirtp_v_nxt = 1'b1;
                                                                p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                                p0_reord_dirtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                             end
                                                           end // if rop_multi_frag_enable
                                                           //--------------------------------------------------------------------------------------------------
                                                           else begin
                                                             if ( ldb_type ) begin
                                                                p0_reord_lbhp_v_nxt = 1'b1;
                                                                p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                                p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                             end
                                                             else if (dir_type ) begin
                                                                p0_reord_lbhp_v_nxt = 1'b1;
                                                                p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                                p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                             end
                                                           end // else rop_multi_frag_enable
                                                           //--------------------------------------------------------------------------------------------------
                                                       end
                                                   end
            
                                                         // 5'b00100 - NVC not valid combination
                                                         // 5'b00101 - NVC not valid combination cmd_sys_enq and cmd_update_sn_order_state not possible
                                                         // 5'b00110 - NVC not valid combination cmd_sys_enq and cmd_start_sn_reorder not possible
                                                         // 5'b00111 - NVC not valid combination cmd_sys_enq and cmd_start_sn_reorder and cmd_update_sn_order_state not possible
                                                         // 5'b01000 - NVC not valid combination
                                                         // 5'b11001 - NVC not valid combination
                                                         // 5'b01001 - NVC not valid combination
                                                         // 5'b01010 - NVC not valid combination
                                                         // 5'b01011 - NVC not valid combination
                                 HCW_ENQ_SYS_ENQ : begin // 5'b01100
                                                       if (ldb_type) begin 
                                                           if ( ~p0_qed_dqed_enq_ctl.hold & ~p0_rop_nalb_enq_ctl.hold ) begin
                                                               chp_rop_hcw_db2_out_ready = 1'b1;
                                                               p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                               p0_rop_nalb_enq_ctl.enable = 1'b1;
                                                           end 
                                                       end
                                                       else if (dir_type) begin
                                                           if ( ~p0_qed_dqed_enq_ctl.hold & ~p0_rop_dp_enq_ctl.hold ) begin
                                                       
                                                               chp_rop_hcw_db2_out_ready = 1'b1;
                                                               p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                               p0_rop_dp_enq_ctl.enable = 1'b1;
                                                           end
                                                       end
                                                   end
                 HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST,
 SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST : begin // 5'b01101 - UPDATE_ORDER_ST always wins over S_GET_ORDER_ST
          
                                                     if ( request_state.request_bit.sn_ordered_ready & 
                                                          hcw_enq_sys_enq_start_reorder_last_f & 
                                                          !(ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull ) ) begin
                                                                   
                                                              hcw_enq_sys_enq_start_reorder_last_nxt = 1'b0;

                                                                 if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull) ) begin
                                                                     sn_ordered_fifo_pop = 1'b1;
                                                                           
                                                                     // fetch the SN replay state information
                                                                     p0_reord_ctl.enable = 1'b1;
                                                                           
                                                                     p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                                                                     
                                                                     p0_reord_dirhp_v_nxt = 1'b1;
                                                                     p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                     
                                                                     p0_reord_dirtp_v_nxt = 1'b1;
                                                                     p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                     
                                                                     p0_reord_lbhp_v_nxt = 1'b1;
                                                                     p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                     
                                                                     p0_reord_lbtp_v_nxt = 1'b1;
                                                                     p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                     
                                                                     p0_reord_st_v_nxt = 1'b1;
                                                                     p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                     
                                                                     p0_reord_cnt_v_nxt = 1'b1;
                                                                     p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                     p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];

                                                                  end
                                                     end else begin

                                                     if (ldb_type) begin 
                                                         if ( !(p0_qed_dqed_enq_ctl.hold | p0_rop_nalb_enq_ctl.hold | p0_reord_ctl.hold) ) begin
                                               
                                                             chp_rop_hcw_db2_out_ready = 1'b1;
                                               
                                                             p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                             p0_rop_nalb_enq_ctl.enable = 1'b1;
                                                             p0_reord_ctl.enable = 1'b1;

                                                     p0_reord_cnt_v_nxt = 1'b1;
                                                     p0_reord_st_v_nxt = 1'b1;

                                                         //--------------------------------------------------------------------------------------------------
                                                         if ( rop_multi_frag_enable ) begin
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                      
                                                             p0_reord_lbtp_v_nxt = 1'b1;
                                                             p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                         end // if rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                         else begin
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                         end // else rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------

                                                            // increment frag cnt
                                                            smon_reord_frag_cnt_nxt = 1'b1;

                                                         end 
                                                     end
                                                     else if (dir_type) begin
                                                         if ( !( p0_qed_dqed_enq_ctl.hold | p0_rop_dp_enq_ctl.hold | p0_reord_ctl.hold ) ) begin
                                               
                                                             chp_rop_hcw_db2_out_ready = 1'b1;
                                               
                                                             p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                             p0_rop_dp_enq_ctl.enable = 1'b1;
                                                             p0_reord_ctl.enable = 1'b1;

                                                     p0_reord_cnt_v_nxt = 1'b1;
                                                     p0_reord_st_v_nxt = 1'b1;

                                                         //--------------------------------------------------------------------------------------------------
                                                         if ( rop_multi_frag_enable ) begin
                                                             p0_reord_dirhp_v_nxt = 1'b1;
                                                             p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                  
                                                             p0_reord_dirtp_v_nxt = 1'b1;
                                                             p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_dirtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                         end // if rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                         else begin
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                         end // else rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------

                                                             // increment frag cnt
                                                             smon_reord_frag_cnt_nxt = 1'b1;

                                                         end
                                                     end



                                                     if (p0_reord_ctl.enable) begin

                                                             p0_reord_nxt.data.frag_op = cmd_update_sn_order_state_frag_op;
                                                             p0_reord_nxt.data.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid}; // needed to id qid when frag_cnt error is detected 
                                                         
                                                             p0_reord_nxt.data.frag_type = ldb_type ? REORD_FRAG_LB : REORD_FRAG_DIR;
                                                             p0_reord_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
                                                             p0_reord_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;

                                                             hcw_enq_sys_enq_start_reorder_last_nxt = 1'b1; 

                                                     end 
                                                           
                                                     // set of increment the lb/dir counter 
                                                     p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                           
                                                     p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                         p0_reord_st_write_data_nxt.parity = reord_st_parity;
                                                         p0_reord_st_write_data_nxt.reord_st_valid = 1'b1;
                                                         p0_reord_st_write_data_nxt.reord_st.user = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec; // don't care but included for parity generation 
                                                         p0_reord_st_write_data_nxt.reord_st.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};
                                                         p0_reord_st_write_data_nxt.reord_st.qidix = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                                                         //p0_reord_st_write_data_nxt.reord_st.is_ldb = ldb_type ;
                                                         //p0_reord_st_write_data_nxt.reord_st.nz_count = 1'b1 ;
                                                         p0_reord_st_write_data_nxt.reord_st.qidix_msb = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                                                         p0_reord_st_write_data_nxt.reord_st.cq = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid;
                                                         p0_reord_st_write_data_nxt.reord_st.qpri = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                                                  end

                                                 end 
                                                                      // 5'b01110 
                HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST,
SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST : begin // 5'b01111 - UPDATE_ORDER_ST always wins over SN_GET_ORDER_ST

                                                                if ( request_state.request_bit.sn_ordered_ready & 
                                                                     hcw_enq_sys_enq_start_reorder_last_f & 
                                                                     !(ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull ) ) begin
                                                                   
                                                                     hcw_enq_sys_enq_start_reorder_last_nxt = 1'b0;

                                                                     if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull) ) begin
                                                                           sn_ordered_fifo_pop = 1'b1;
                                                                           
                                                                           // fetch the SN replay state information
                                                                           p0_reord_ctl.enable = 1'b1;
                                                                           
                                                                           p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                                                                           
                                                                           p0_reord_dirhp_v_nxt = 1'b1;
                                                                           p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                           
                                                                           p0_reord_dirtp_v_nxt = 1'b1;
                                                                           p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                           
                                                                           p0_reord_lbhp_v_nxt = 1'b1;
                                                                           p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                           
                                                                           p0_reord_lbtp_v_nxt = 1'b1;
                                                                           p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                           
                                                                           p0_reord_st_v_nxt = 1'b1;
                                                                           p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                                           
                                                                           p0_reord_cnt_v_nxt = 1'b1;
                                                                           p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                           p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];

                                                                     end

                                                                end else begin

                                                                   if (ldb_type) begin 
                                                                       if ( !(p0_qed_dqed_enq_ctl.hold | p0_rop_nalb_enq_ctl.hold | p0_reord_ctl.hold | sn_complete_fifo_afull ) ) begin
                                                               
                                                                           chp_rop_hcw_db2_out_ready = 1'b1;
                                                               
                                                                           p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                                           p0_rop_nalb_enq_ctl.enable = 1'b1;
                                                                           sn_complete_fifo_push = 1'b1;  
                                                                           p0_reord_ctl.enable = 1'b1;
                                                                           p0_reord_cnt_v_nxt = 1'b1;
                                                                           p0_reord_st_v_nxt = 1'b1;
                                                               
                                                                           //--------------------------------------------------------------------------------------------------
                                                                           if ( rop_multi_frag_enable ) begin
                                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;

                                                                             p0_reord_lbtp_v_nxt = 1'b1;
                                                                             p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                                             p0_reord_lbtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                                           end // if rop_multi_frag_enable
                                                                           //--------------------------------------------------------------------------------------------------
                                                                           else begin
                                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                                           end // else rop_multi_frag_enable
                                                                           //--------------------------------------------------------------------------------------------------
                                                               
                                                                           // increment frag cnt 
                                                                           smon_reord_frag_cnt_nxt = 1'b1;
                                                                           // increment cmp cnt 
                                                                           smon_reord_cmp_cnt_nxt = 1'b1;
                                                                         
                                                                       end 
                                                                   end
                                                                   else if (dir_type) begin
                                                                       if ( !( p0_qed_dqed_enq_ctl.hold | p0_rop_dp_enq_ctl.hold | p0_reord_ctl.hold |sn_complete_fifo_afull ) ) begin
                                                               
                                                                           chp_rop_hcw_db2_out_ready = 1'b1;
                                                               
                                                                           p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                                           p0_rop_dp_enq_ctl.enable = 1'b1;
                                                                           sn_complete_fifo_push = 1'b1;  
                                                                           p0_reord_ctl.enable = 1'b1;
                                                                           p0_reord_cnt_v_nxt = 1'b1;
                                                                           p0_reord_st_v_nxt = 1'b1;
                                                               
                                                               
                                                                           //--------------------------------------------------------------------------------------------------
                                                                           if ( rop_multi_frag_enable ) begin
                                                                             p0_reord_dirhp_v_nxt = 1'b1;
                                                                             p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;

                                                                             p0_reord_dirtp_v_nxt = 1'b1;
                                                                             p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                                             p0_reord_dirtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                                           end // if rop_multi_frag_enable
                                                                           //--------------------------------------------------------------------------------------------------
                                                                           else begin
                                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                                             p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                                           end // else rop_multi_frag_enable
                                                                           //--------------------------------------------------------------------------------------------------



                                                                           // increment frag cnt 
                                                                           smon_reord_frag_cnt_nxt = 1'b1;
                                                                           // increment cmp cnt 
                                                                           smon_reord_cmp_cnt_nxt = 1'b1;


                                                                       end
                                                                   end

                                                                   if (p0_reord_ctl.enable) begin
                                                                   
                                                                           p0_reord_nxt.data.frag_op = cmd_update_sn_order_state_frag_op;
                                                                           p0_reord_nxt.data.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid}; // needed to id qid when frag_cnt error is detected 
                                                                       
                                                                           p0_reord_nxt.data.frag_type = ldb_type ? REORD_FRAG_LB : REORD_FRAG_DIR;
                                                                           p0_reord_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
                                                                           p0_reord_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;

                                                                           hcw_enq_sys_enq_start_reorder_last_nxt = 1'b1;
                                                                   
                                                                   end 
                                                                         
                                                                   // set of increment the lb/dir counter 
                                                                   p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                                         
                                                                   p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                                   p0_reord_st_write_data_nxt.parity = reord_st_parity;
                                                                   p0_reord_st_write_data_nxt.reord_st_valid = 1'b1;
                                                                   p0_reord_st_write_data_nxt.reord_st.user = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec;
                                                                   p0_reord_st_write_data_nxt.reord_st.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};
                                                                   p0_reord_st_write_data_nxt.reord_st.qidix = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                                                                   //p0_reord_st_write_data_nxt.reord_st.is_ldb = ldb_type ;
                                                                   //p0_reord_st_write_data_nxt.reord_st.nz_count = 1'b1 ;
                                                                   p0_reord_st_write_data_nxt.reord_st.qidix_msb = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                                                                   p0_reord_st_write_data_nxt.reord_st.cq = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid;
                                                                   p0_reord_st_write_data_nxt.reord_st.qpri = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                                                                end
                                                 end 
                               SN_GET_ORDER_ST : begin // 5'b10000 - pull from sn_order fifo to get SN ordering information

                                                     // Issue the request only if there are enought head room in the dir/ldb replay FIFOs. 
                                                     // This is done to avoid hold blocking issue in the main pipeline
                                                     if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull) ) begin
                                                         sn_ordered_fifo_pop = 1'b1;
                                                         
                                                         // fetch the SN replay state information
                                                         p0_reord_ctl.enable = 1'b1;

                                                         p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                                                         
                                                         p0_reord_dirhp_v_nxt = 1'b1;
                                                         p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                         
                                                         p0_reord_dirtp_v_nxt = 1'b1;
                                                         p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                         
                                                         p0_reord_lbhp_v_nxt = 1'b1;
                                                         p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                         
                                                         p0_reord_lbtp_v_nxt = 1'b1;
                                                         p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                         
                                                         p0_reord_st_v_nxt = 1'b1;
                                                         p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                         
                                                         p0_reord_cnt_v_nxt = 1'b1;
                                                         p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                         p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];

                                                     end
                                                 end 
                                                       //  5'b10001 - NVC
 SN_GET_ORDER_ST_START_REORDER_UPDATE_ORDER_ST : begin //  5'b10011      

                                                     if ( ~(sn_complete_fifo_afull  | p0_reord_ctl.hold) & 
                                                           ( (start_reorder_update_order_st_last_f==1'b0) | ( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull ) ) ) begin

                                                          start_reorder_update_order_st_last_nxt = cfg_control_general_0_sn_start_get_rr_enable ? 1'b1 : 1'b0; // when rr enabled set to 1 otherwise keep it 0.
                                                
                                                          chp_rop_hcw_db2_out_ready = 1'b1; // pull next data in db
                                                
                                                          sn_complete_fifo_push = 1'b1; // start SN reorder process
                                                
                                                          // increment cmp cnt
                                                          smon_reord_cmp_cnt_nxt = 1'b1;

                                                          p0_reord_ctl.enable = 1'b1;
                                                          
                                                          if (p0_reord_ctl.enable) begin 
                                                              p0_reord_nxt.data.frag_op = cmd_update_sn_order_state_frag_op;
                                                              p0_reord_nxt.data.qid = {1'b0 , chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid}; // needed to id qid when frag_cnt error is detected 
                                                              p0_reord_nxt.data.frag_type = ldb_type ? REORD_FRAG_LB : REORD_FRAG_DIR;
                                                              p0_reord_nxt.data.flid = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid;
                                                              p0_reord_nxt.data.flid_parity = chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity;
                                                          end
                                                          
                                                          // Don't increment the lb/dir counter 
                                                          p0_reord_cnt_v_nxt = 1'b1;
                                                          p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                          
                                                          p0_reord_st_v_nxt = 1'b1;
                                                          p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_WRITE;
                                                         p0_reord_st_write_data_nxt.parity = reord_st_parity;
                                                         p0_reord_st_write_data_nxt.reord_st_valid = 1'b1;
                                                         p0_reord_st_write_data_nxt.reord_st.user = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec;
                                                         p0_reord_st_write_data_nxt.reord_st.qid = {1'b0,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid};
                                                         p0_reord_st_write_data_nxt.reord_st.qidix = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix;
                                                         //p0_reord_st_write_data_nxt.reord_st.is_ldb = ldb_type ;
                                                         //p0_reord_st_write_data_nxt.reord_st.nz_count = 1'b0 ;        // Not incrementing the count
                                                         p0_reord_st_write_data_nxt.reord_st.qidix_msb = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb;
                                                         p0_reord_st_write_data_nxt.reord_st.cq = chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid;
                                                         p0_reord_st_write_data_nxt.reord_st.qpri = chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri;
                                                          
                                                         //--------------------------------------------------------------------------------------------------
                                                         if ( rop_multi_frag_enable ) begin
                                                          if ( ldb_type ) begin 
                                                              p0_reord_lbhp_v_nxt = 1'b1;
                                                              p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                         
                                                              p0_reord_lbtp_v_nxt = 1'b1;
                                                              p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                              p0_reord_lbtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end 
                                                          else if (dir_type ) begin
                                                              p0_reord_dirhp_v_nxt = 1'b1;
                                                              p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                               
                                                              p0_reord_dirtp_v_nxt = 1'b1;
                                                              p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                              p0_reord_dirtp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end
                                                         end // if rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                         else begin
                                                          if ( ldb_type ) begin
                                                              p0_reord_lbhp_v_nxt = 1'b1;
                                                              p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                              p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end
                                                          else if (dir_type ) begin
                                                              p0_reord_lbhp_v_nxt = 1'b1;
                                                              p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_NOOP;
                                                              p0_reord_lbhp_write_data_nxt = {chp_rop_hcw_db2_out_data.chp_rop_hcw.flid_parity,chp_rop_hcw_db2_out_data.chp_rop_hcw.flid[13:0]};
                                                          end
                                                         end // else rop_multi_frag_enable
                                                         //--------------------------------------------------------------------------------------------------
                                                     end
                                                     else begin
                                                         // Issue the request only if there are enought head room in the dir/ldb replay FIFOs. 
                                                         // This is done to avoid hold blocking issue in the main pipeline
                                                         if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull | p0_reord_ctl.hold ) ) begin
                                                             start_reorder_update_order_st_last_nxt = 1'b0;
    
                                                             sn_ordered_fifo_pop = 1'b1; 

                                                             // fetch the SN replay state information
                                                             p0_reord_ctl.enable = 1'b1;
                                                             p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                                                             
                                                             p0_reord_dirhp_v_nxt = 1'b1;
                                                             p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_dirtp_v_nxt = 1'b1;
                                                             p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                             
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_lbtp_v_nxt = 1'b1;
                                                             p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                             
                                                             p0_reord_st_v_nxt = 1'b1;
                                                             p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_cnt_v_nxt = 1'b1;
                                                             p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                         end

                                                     end
                                                 end 
                                                       // 5'b10100 - NVC
                                                       // 5'b10101 - NVC not valid combination
                                                       // 5'b10110 - NVC not valid combination
                                                       // 5'b10111 - NVC not valid combination
                                                       // 5'b11000 - NVC not valid combination
                                                       // 5'b11010 - NVC not valid combination
                                                       // 5'b11011 - NVC not valid combination
               SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ : begin // 5'b11100,
                                                     if (ldb_type) begin 
                                                         if ( ~p0_qed_dqed_enq_ctl.hold & ~p0_rop_nalb_enq_ctl.hold ) begin
                                                             chp_rop_hcw_db2_out_ready = 1'b1;
                                                             p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                             p0_rop_nalb_enq_ctl.enable = 1'b1;
                                                         end 
                                                     end
                                                     else if (dir_type) begin
                                                         if ( ~p0_qed_dqed_enq_ctl.hold & ~p0_rop_dp_enq_ctl.hold ) begin
                                                     
                                                             chp_rop_hcw_db2_out_ready = 1'b1;
                                                             p0_qed_dqed_enq_ctl.enable = 1'b1;
                                                             p0_rop_dp_enq_ctl.enable = 1'b1;
                                                         end
                                                     end
                                                         // Issue the request only if there are enought head room in the dir/ldb replay FIFOs. 
                                                         // This is done to avoid hold blocking issue in the main pipeline
                                                         if ( !( ldb_rply_req_fifo_afull | dir_rply_req_fifo_afull | lsp_reordercmp_fifo_afull) ) begin
    
                                                             sn_ordered_fifo_pop = 1'b1; 
          
                                                             // fetch the SN replay state information
                                                             p0_reord_ctl.enable = 1'b1;
                                                             p0_reord_nxt.data.frag_op = REORD_READ_CLEAR; // clear contents for this sequence number to 0's
                                                             
                                                             p0_reord_dirhp_v_nxt = 1'b1;
                                                             p0_reord_dirhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_dirhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_dirtp_v_nxt = 1'b1;
                                                             p0_reord_dirtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_dirtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                             
                                                             p0_reord_lbhp_v_nxt = 1'b1;
                                                             p0_reord_lbhp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_lbhp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_lbtp_v_nxt = 1'b1;
                                                             p0_reord_lbtp_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_lbtp_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0]; 
                                                             
                                                             p0_reord_st_v_nxt = 1'b1;
                                                             p0_reord_st_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_st_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];
                                                             
                                                             p0_reord_cnt_v_nxt = 1'b1;
                                                             p0_reord_cnt_rw_nxt = HQM_AW_RMWPIPE_RMW;
                                                             p0_reord_cnt_addr_nxt = sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0];

                                                          end
          
                                                 end
                     
                                                       // 5'b11101 - NVC not valid combination
                                                       // 5'b11110 - NVC not valid combination
                                                       // 5'b11111 - NVC not valid combination
                                       default : begin chp_rop_hcw_db2_out_ready = '0; end
                                      endcase
           end // if (chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) begin

end // always_comb begin

// generate the valids

assign p0_qed_dqed_enq_nxt.v = p0_qed_dqed_enq_ctl.enable | p0_qed_dqed_enq_ctl.hold;
assign p0_rop_dp_enq_nxt.v   = p0_rop_dp_enq_ctl.enable | p0_rop_dp_enq_ctl.hold;
assign p0_rop_nalb_enq_nxt.v = p0_rop_nalb_enq_ctl.enable | p0_rop_nalb_enq_ctl.hold;

assign p0_reord_nxt.v = p0_reord_ctl.enable | p0_reord_ctl.hold;

hqm_AW_parity_gen #( .WIDTH(20) ) i_reord_st_parity_gen (
         .d     ( {
                 //hqmv2  chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.user
                   chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw_no_dec
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qpri
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix_msb
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix
                  // hqmv2,chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.pp} )
                  ,chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw.ppid} )
        ,.odd   ( rop_parity_type )
        ,.p     ( reord_st_parity ) 
);

// Tha parity going into lsp_reodercmp fifo will not be generated but the parity out of the reorder st ram be adjusted by
// removeing the qidix and user . The equation will be something like this new_parity = parity ~^ parity({qidix,qpri,user});
hqm_AW_parity_gen #( .WIDTH(8) ) i_reord_st_parity_qidix_qpri_gen (
         .d     ( {p2_reord_st_data_f.reord_st.qidix
                  ,p2_reord_st_data_f.reord_st.qidix_msb
                  ,p2_reord_st_data_f.reord_st.qpri
                  ,p2_reord_st_data_f.reord_st.user} ) // qidix/qpri/user field from st ram
        ,.odd   ( rop_parity_type )
        ,.p     ( lsp_reordercmp_qidix_qpri_parity ) 
);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (hqm_gated_rst_n == 1'b0) begin

    p0_qed_dqed_enq_f <= '0;
    p0_rop_dp_enq_f <= '0;
    p0_rop_nalb_enq_f <= '0;
    p0_reord_f <= '0;
    p1_reord_f <= '0;
    p2_reord_f <= '0;
    hcw_enq_sys_enq_start_reorder_last_f <= '0;
    start_reorder_update_order_st_last_f <= '0;
    mem_access_error_f <= '0;

  end 
  else begin

    p0_qed_dqed_enq_f <= p0_qed_dqed_enq_nxt;
    p0_rop_dp_enq_f <= p0_rop_dp_enq_nxt;
    p0_rop_nalb_enq_f <= p0_rop_nalb_enq_nxt;
    p0_reord_f <= p0_reord_nxt;
    p1_reord_f <= p1_reord_nxt;
    p2_reord_f <= p2_reord_nxt;
    hcw_enq_sys_enq_start_reorder_last_f <= hcw_enq_sys_enq_start_reorder_last_nxt;
    start_reorder_update_order_st_last_f <= start_reorder_update_order_st_last_nxt;
    mem_access_error_f <= mem_access_error_nxt;

  end // if (rst_n == 1'b0) begin
end  // always_ff

// The ROP maintains per sequence number (SN) reorder state in rams. There are 2048 entries in these rams.
// When CQ sends fragments in response to the ordered reqeusts this pipe line does the following. There are several cases to consider:
// 
// 
// 1 - processing lb fragment (if first_frag bit is set write the qid/qidix/cq into state ram)
//       - read lb frag_cnt, if frag_cnt==0->write the flid into lb.hptr field, othwerwise write the flid into lb.tptr field
// 2 - processing dir fragment (if frst_frag bit is set write the qid/qidix/cq into state ram)
//       - read dir frag_cnt, if frag_cnt==0-> write the flid ito dir.hptr field, otherwise write the flid into dir.tptr field

assign rply_frag_cnt_gt_16 = ((rply_cnt.lb_cnt + rply_cnt.dir_cnt) > 16);

always_comb begin


        p3_reord_st_hold_nc    = 1'b0;          // end of pipe line; never hold
        p2_reord_st_hold    = p2_reord_st_v_f & p3_reord_st_hold_nc; 
        p1_reord_st_hold    = p1_reord_st_v_f & p2_reord_st_hold; 
        p0_reord_st_hold    = p0_reord_st_v_f & p1_reord_st_hold; 

        p3_reord_dirhp_hold_nc = 1'b0;       // end of pipe line; never hold 
        p2_reord_dirhp_hold = p2_reord_dirhp_v_f & p3_reord_dirhp_hold_nc; 
        p1_reord_dirhp_hold = p1_reord_dirhp_v_f & p2_reord_dirhp_hold; 
        p0_reord_dirhp_hold = p0_reord_dirhp_v_f & p1_reord_dirhp_hold; 

        p3_reord_dirtp_hold_nc = 1'b0;       // end of pipe line; never hold
        p2_reord_dirtp_hold = p2_reord_dirtp_v_f & p3_reord_dirtp_hold_nc; 
        p1_reord_dirtp_hold = p1_reord_dirtp_v_f & p2_reord_dirtp_hold; 
        p0_reord_dirtp_hold = p0_reord_dirtp_v_f & p1_reord_dirtp_hold; 

        p3_reord_lbhp_hold_nc  = 1'b0;        // end of pipe line; never hold
        p2_reord_lbhp_hold  = p2_reord_lbhp_v_f & p3_reord_lbhp_hold_nc; 
        p1_reord_lbhp_hold  = p1_reord_lbhp_v_f & p2_reord_lbhp_hold; 
        p0_reord_lbhp_hold  = p0_reord_lbhp_v_f & p1_reord_lbhp_hold; 

        p3_reord_lbtp_hold_nc  = 1'b0;        // end of pipe line; never hold
        p2_reord_lbtp_hold  = p2_reord_lbtp_v_f & p3_reord_lbtp_hold_nc; 
        p1_reord_lbtp_hold  = p1_reord_lbtp_v_f & p2_reord_lbtp_hold; 
        p0_reord_lbtp_hold  = p0_reord_lbtp_v_f & p1_reord_lbtp_hold; 

        p3_reord_cnt_hold_nc   = 1'b0;         // end of pipe line; never hold
        p2_reord_cnt_hold   = p2_reord_cnt_v_f & p3_reord_cnt_hold_nc; 
        p1_reord_cnt_hold   = p1_reord_cnt_v_f & p2_reord_cnt_hold; 
        p0_reord_cnt_hold   = p0_reord_cnt_v_f & p1_reord_cnt_hold; 

        p3_reord_ctl.hold   = 1'b0;         // end of pipe line; never hold
        p2_reord_ctl.hold   = p2_reord_f.v & p3_reord_ctl.hold;
        p1_reord_ctl.hold   = p1_reord_f.v & p2_reord_ctl.hold;
        p0_reord_ctl.hold   = p0_reord_f.v & p1_reord_ctl.hold; // hold if p0 has valid data and p1 is holding

        p3_reord_ctl.enable = 1'b0;
        p2_reord_ctl.enable = p1_reord_f.v & (~p2_reord_ctl.hold | ~p2_reord_f.v); 
        p1_reord_ctl.enable = p0_reord_f.v & (~p1_reord_ctl.hold | ~p1_reord_f.v);

        p1_reord_nxt = p1_reord_f;
        p2_reord_nxt = p2_reord_f;

        p1_reord_nxt.v = p0_reord_f.v | p1_reord_ctl.hold;
        p2_reord_nxt.v = p1_reord_f.v | p3_reord_ctl.hold;

        if (p1_reord_ctl.enable) begin p1_reord_nxt.data = p0_reord_f.data; end
        if (p2_reord_ctl.enable) begin p2_reord_nxt.data = p1_reord_f.data; end

        p3_reord_st_bypsel_nxt = 1'b0;
        p3_reord_st_bypdata_nxt = '0; 
        p3_reord_st_bypdata_nxt.parity = 1'b1; // od parity

        p3_reord_dirhp_bypsel_nxt = 1'b0;
        p3_reord_dirhp_bypdata_nxt = '0; 

        p3_reord_dirtp_bypsel_nxt = 1'b0;
        p3_reord_dirtp_bypdata_nxt = '0; 

        p3_reord_lbhp_bypsel_nxt = 1'b0;
        p3_reord_lbhp_bypdata_nxt = '0; 

        p3_reord_lbtp_bypsel_nxt = 1'b0;
        p3_reord_lbtp_bypdata_nxt = '0; 

        p3_reord_cnt_bypsel_nxt = 1'b0;
        p3_reord_cnt_bypdata_nxt = '0; 

        rply_cnt     = p2_reord_cnt_data_f;
        rply_cnt_nxt = p2_reord_cnt_data_f;

        rply_frag_cnt_gt_16_nxt = 1'b0;
        rply_frag_cnt_gt_16_qid_nxt = '0;

        residue_add_a = '0;
        residue_add_b = '0;

        ldb_rply_req_fifo_push = 1'b0;
        ldb_rply_req_fifo_push_data = '0;

        lsp_reordercmp_fifo_push = 1'b0;
        lsp_reordercmp_fifo_push_data = '0;

        dir_rply_req_fifo_push = 1'b0;
        dir_rply_req_fifo_push_data = '0;

        access_sn_integrity_err_nxt = 1'b0;

        if (p2_reord_f.v) begin 

            if ( p2_reord_f.data.frag_type == REORD_FRAG_LB ) begin
                rply_cnt_nxt.lb_cnt = rply_frag_cnt_gt_16 ? rply_cnt.lb_cnt : (rply_cnt.lb_cnt + 5'd1);    
                residue_add_a = rply_cnt.lb_residue;
                residue_add_b = 2'b01;
                rply_cnt_nxt.lb_residue = residue_add_r;
                 
            end 

            if ( p2_reord_f.data.frag_type == REORD_FRAG_DIR ) begin
                rply_cnt_nxt.dir_cnt = rply_frag_cnt_gt_16 ? rply_cnt.dir_cnt : (rply_cnt.dir_cnt + 5'd1);    
                residue_add_a = rply_cnt.dir_residue;
                residue_add_b = 2'b01;
                rply_cnt_nxt.dir_residue = residue_add_r;
            end

        end
     
        if (p2_reord_f.v ) begin

           case(p2_reord_f.data.frag_op)

              REORD_FRAG,
         REORD_FRAG_COMP : begin // write qid, qidix, cq; write lb/dir hp and tp; update cnt; check for cnt!=0. ON first enq this cnt should be 0 
        
                               rply_frag_cnt_gt_16_nxt = rply_frag_cnt_gt_16;
                               rply_frag_cnt_gt_16_qid_nxt = p2_reord_f.data.qid;

                               // since we don't know if this is first or intermediate or last frag we need to check frag counters 
                               case ( {(p2_reord_f.data.frag_type == REORD_FRAG_LB),(p2_reord_f.data.frag_type == REORD_FRAG_DIR),(rply_cnt.lb_cnt == '0),(rply_cnt.dir_cnt== '0) } )

                                 4'b1000 
                                ,4'b1001 : begin // MID_OR_LST_LB 
                                               // update the frag counters
                                               p3_reord_cnt_bypsel_nxt = 1'b1;
                                               p3_reord_cnt_bypdata_nxt = rply_cnt_nxt;
                                               // 
                                               // NOTE: st and tp information written on every frag
                                               // 
                                           end
                                 4'b0100 
                                ,4'b0110 : begin // MID_OR_LST_DIR
                                               // update the frag counters
                                               p3_reord_cnt_bypsel_nxt = 1'b1;
                                               p3_reord_cnt_bypdata_nxt = rply_cnt_nxt;
                                               
                                               // 
                                               // NOTE: st and tp information written on every frag
                                               // 
                                           end
                                 4'b1010
                                ,4'b1011 : begin // FIRST_LB 
                                               // update the frag counters
                                               p3_reord_cnt_bypsel_nxt = 1'b1;
                                               p3_reord_cnt_bypdata_nxt = rply_cnt_nxt;
                                               // update lb hp and tp; note tp is written unconditionally
                                               p3_reord_lbhp_bypsel_nxt = 1'b1;
                                               p3_reord_lbhp_bypdata_nxt = {p2_reord_f.data.flid_parity,p2_reord_f.data.flid[13:0]};
                                           end
                                 4'b0101 
                                ,4'b0111 : begin // FIRST_DIR
                                               // update the frag counters
                                               p3_reord_cnt_bypsel_nxt = 1'b1;
                                               p3_reord_cnt_bypdata_nxt = rply_cnt_nxt;
                                               // update dr hp and tp; note tp is written unconditionally

                                               //--------------------------------------------------------------------------------------------------
                                               if ( rop_multi_frag_enable ) begin
                                                 p3_reord_dirhp_bypsel_nxt = 1'b1;
                                                 p3_reord_dirhp_bypdata_nxt = {p2_reord_f.data.flid_parity,p2_reord_f.data.flid[13:0]};
                                               end // if rop_multi_frag_enable
                                               //--------------------------------------------------------------------------------------------------
                                               else begin
                                                 p3_reord_lbhp_bypsel_nxt = 1'b1;
                                                 p3_reord_lbhp_bypdata_nxt = {p2_reord_f.data.flid_parity,p2_reord_f.data.flid[13:0]};
                                               end // else rop_multi_frag_enable
                                               //--------------------------------------------------------------------------------------------------

                                           end 
                                 default : begin
                                               p3_reord_st_hold_nc    = 1'b0;
                                               p3_reord_dirhp_hold_nc = 1'b0;
                                               p3_reord_dirtp_hold_nc = 1'b0;
                                               p3_reord_lbhp_hold_nc  = 1'b0;
                                               p3_reord_lbtp_hold_nc  = 1'b0;
                                               p3_reord_cnt_hold_nc   = 1'b0;
                                               p3_reord_ctl.hold   = 1'b0;
                                               p3_reord_ctl.enable = 1'b0;
                                           end
                               endcase
                           end
        REORD_READ_CLEAR : begin // on completion read the ram contents and clear the reorder state

                                         if (p2_reord_cnt_data_f.dir_cnt != '0) begin
                                             dir_rply_req_fifo_push                                 = 1'b1;
                                             dir_rply_req_fifo_push_data.frag_list_info.hptr        = p2_reord_dirhp_data_f[13:0];
                                             dir_rply_req_fifo_push_data.frag_list_info.hptr_parity = p2_reord_dirhp_data_f[14];
                                             dir_rply_req_fifo_push_data.frag_list_info.tptr        = p2_reord_dirtp_data_f[13:0];
                                             dir_rply_req_fifo_push_data.frag_list_info.tptr_parity = p2_reord_dirtp_data_f[14];
                                             dir_rply_req_fifo_push_data.frag_list_info.cnt         = p2_reord_cnt_data_f.dir_cnt;
                                             dir_rply_req_fifo_push_data.frag_list_info.cnt_residue = p2_reord_cnt_data_f.dir_residue;

                                             dir_rply_req_fifo_push_data.qpri                       = p2_reord_st_data_f.reord_st.qpri;
                                             dir_rply_req_fifo_push_data.qid                        = p2_reord_st_data_f.reord_st.qid; // [17:11];
                                             dir_rply_req_fifo_push_data.qidix                      = p2_reord_st_data_f.reord_st.qidix; // [10:8];
                                             dir_rply_req_fifo_push_data.qidix_msb                  = p2_reord_st_data_f.reord_st.qidix_msb; // [7];
                                             dir_rply_req_fifo_push_data.cq                         = { 1'h0 , p2_reord_st_data_f.reord_st.cq } ; // [6:0];
                                             dir_rply_req_fifo_push_data.parity                     = p2_reord_st_data_f.parity ^ p2_reord_st_data_f.reord_st.user; // subtract out user from parity

                                         end
                                
                                         if (p2_reord_cnt_data_f.lb_cnt != '0) begin
                                             ldb_rply_req_fifo_push = 1'b1;
                                             ldb_rply_req_fifo_push_data.frag_list_info.hptr        = p2_reord_lbhp_data_f[13:0];
                                             ldb_rply_req_fifo_push_data.frag_list_info.hptr_parity = p2_reord_lbhp_data_f[14];
                                             ldb_rply_req_fifo_push_data.frag_list_info.tptr        = p2_reord_lbtp_data_f[13:0];
                                             ldb_rply_req_fifo_push_data.frag_list_info.tptr_parity = p2_reord_lbtp_data_f[14];
                                             ldb_rply_req_fifo_push_data.frag_list_info.cnt         = p2_reord_cnt_data_f.lb_cnt;
                                             ldb_rply_req_fifo_push_data.frag_list_info.cnt_residue = p2_reord_cnt_data_f.lb_residue;

                                             ldb_rply_req_fifo_push_data.qpri                       = p2_reord_st_data_f.reord_st.qpri;
                                             ldb_rply_req_fifo_push_data.qid                        = p2_reord_st_data_f.reord_st.qid; // [17:11];
                                             ldb_rply_req_fifo_push_data.qidix                      = p2_reord_st_data_f.reord_st.qidix; // [10:8];
                                             ldb_rply_req_fifo_push_data.qidix_msb                  = p2_reord_st_data_f.reord_st.qidix_msb; // [7] 
                                             ldb_rply_req_fifo_push_data.cq                         = { 1'h0 , p2_reord_st_data_f.reord_st.cq } ; // [6:0];
                                             ldb_rply_req_fifo_push_data.parity                     = p2_reord_st_data_f.parity ^ p2_reord_st_data_f.reord_st.user; // subtract out user from parity

                                         end

                                         lsp_reordercmp_fifo_push = 1'b1;
                                         lsp_reordercmp_fifo_push_data.user = p2_reord_st_data_f.reord_st.user;
                                         lsp_reordercmp_fifo_push_data.qid = p2_reord_st_data_f.reord_st.qid;
                                         lsp_reordercmp_fifo_push_data.cq  = { 2'h0 , p2_reord_st_data_f.reord_st.cq } ;
                                         lsp_reordercmp_fifo_push_data.parity = p2_reord_st_data_f.parity ~^ lsp_reordercmp_qidix_qpri_parity; // parity adjusted by subractin out the qidix 

                                         if (!p2_reord_st_data_f.reord_st_valid) begin access_sn_integrity_err_nxt = 1'b1; end // sn accessed with reord_st_valid=0, this is illegal case


                                         p3_reord_cnt_bypsel_nxt = 1'b1;
                                         p3_reord_cnt_bypdata_nxt = '0; // for value of 0, the residue is 0 

                                         p3_reord_lbhp_bypsel_nxt = 1'b1;
                                         p3_reord_lbhp_bypdata_nxt = {1'b1,14'd0}; // odd parity

                                         p3_reord_lbtp_bypsel_nxt = 1'b1;
                                         p3_reord_lbtp_bypdata_nxt = {1'b1,14'd0}; // odd parity

                                         p3_reord_dirhp_bypsel_nxt = 1'b1;
                                         p3_reord_dirhp_bypdata_nxt = {1'b1,14'd0}; // odd parity
                                         p3_reord_dirtp_bypsel_nxt = 1'b1;
                                         p3_reord_dirtp_bypdata_nxt = {1'b1,14'd0}; // odd parity
                                         p3_reord_st_bypsel_nxt = 1'b1;
                                         p3_reord_st_bypdata_nxt = '0;
                                         p3_reord_st_bypdata_nxt.parity = 1'b1; // odd parity
                                end
                      default : begin 
                                         p3_reord_st_hold_nc    = 1'b0;
                                         p3_reord_dirhp_hold_nc = 1'b0;
                                         p3_reord_dirtp_hold_nc = 1'b0;
                                         p3_reord_lbhp_hold_nc  = 1'b0;
                                         p3_reord_lbtp_hold_nc  = 1'b0;
                                         p3_reord_cnt_hold_nc   = 1'b0;
                                         p3_reord_ctl.hold   = 1'b0;
                                         p3_reord_ctl.enable = 1'b0;
                                 end
           endcase
         end
end // always_comb

logic rply_cnt_residue_chk_en;
logic unit_idle_hqm_clk_inp_gated ;

// When the cnt ram is read the residue is checked on both
// cnt values (lb/dir)
hqm_AW_residue_check #( 
     .WIDTH ( $bits(rply_cnt.lb_cnt) ) 
) i_cnt_residue_check_lb (
     .r( rply_cnt.lb_residue )
    ,.d( rply_cnt.lb_cnt )
    ,.e( rply_cnt_residue_chk_en )
    ,.err( rply_cnt_residue_chk_lb_err )
);

hqm_AW_residue_check #( 
     .WIDTH ( $bits(rply_cnt.dir_cnt)  ) 
) i_cnt_residue_check_dir (
     .r( rply_cnt.dir_residue )
    ,.d( rply_cnt.dir_cnt )
    ,.e( rply_cnt_residue_chk_en )
    ,.err( rply_cnt_residue_chk_dir_err )
);

// on increment residue is adjusting by adding
// residue of the increment (1'b1) addend to the residue value from memory.
hqm_AW_residue_add
i_residue_add (
     .a   ( residue_add_a ) 
    ,.b   ( residue_add_b )
    ,.r   ( residue_add_r )
);


// Note: if HQM_ROP_MULTI_FRAG_ENABLE == 0 the AW rmw for the extra memories should be optimized out
//generate
//  if ( HQM_ROP_MULTI_FRAG_ENABLE == 1 ) begin : GEN_RMW_MULTI_FRAG_1
    assign  rply_cnt_residue_chk_en             = (p2_reord_cnt_v_f && (p2_reord_cnt_rw_f != HQM_AW_RMWPIPE_NOOP));

    assign p0_reord_lbtp_v_nxt_mfrag            = p0_reord_lbtp_v_nxt ;
    assign p0_reord_lbtp_rw_nxt_mfrag           = p0_reord_lbtp_rw_nxt ;
    assign p0_reord_lbtp_addr_nxt_mfrag         = p0_reord_lbtp_addr_nxt ;
    assign p0_reord_lbtp_write_data_nxt_mfrag   = p0_reord_lbtp_write_data_nxt ;
    assign p0_reord_dirhp_v_nxt_mfrag           = p0_reord_dirhp_v_nxt ;
    assign p0_reord_dirhp_rw_nxt_mfrag          = p0_reord_dirhp_rw_nxt ;
    assign p0_reord_dirhp_addr_nxt_mfrag        = p0_reord_dirhp_addr_nxt ;
    assign p0_reord_dirhp_write_data_nxt_mfrag  = p0_reord_dirhp_write_data_nxt ;
    assign p0_reord_dirtp_v_nxt_mfrag           = p0_reord_dirtp_v_nxt ;
    assign p0_reord_dirtp_rw_nxt_mfrag          = p0_reord_dirtp_rw_nxt ;
    assign p0_reord_dirtp_addr_nxt_mfrag        = p0_reord_dirtp_addr_nxt ;
    assign p0_reord_dirtp_write_data_nxt_mfrag  = p0_reord_dirtp_write_data_nxt ;
    assign p0_reord_cnt_v_nxt_mfrag             = p0_reord_cnt_v_nxt ;
    assign p0_reord_cnt_rw_nxt_mfrag            = p0_reord_cnt_rw_nxt ;
    assign p0_reord_cnt_addr_nxt_mfrag          = p0_reord_cnt_addr_nxt ;
    assign p0_reord_cnt_write_data_nxt_mfrag    = p0_reord_cnt_write_data_nxt ;

//  end // if HQM_ROP_MULTI_FRAG_ENABLE
//  else begin : GEN_RMW_MULTI_FRAG_0
//    assign  rply_cnt_residue_chk_en             = (p2_reord_st_v_f && (p2_reord_st_rw_f != HQM_AW_RMWPIPE_NOOP));       // "count" is stored in st RAM
//
//    assign p0_reord_lbtp_v_nxt_mfrag            = 1'b0 ;
//    assign p0_reord_lbtp_rw_nxt_mfrag           = HQM_AW_RMWPIPE_NOOP ;
//    assign p0_reord_lbtp_addr_nxt_mfrag         = '0 ;
//    assign p0_reord_lbtp_write_data_nxt_mfrag   = '0 ;
//    assign p0_reord_dirhp_v_nxt_mfrag           = 1'b0 ;
//    assign p0_reord_dirhp_rw_nxt_mfrag          = HQM_AW_RMWPIPE_NOOP ;
//    assign p0_reord_dirhp_addr_nxt_mfrag        = '0 ;
//    assign p0_reord_dirhp_write_data_nxt_mfrag  = '0 ;
//    assign p0_reord_dirtp_v_nxt_mfrag           = 1'b0 ;
//    assign p0_reord_dirtp_rw_nxt_mfrag          = HQM_AW_RMWPIPE_NOOP ;
//    assign p0_reord_dirtp_addr_nxt_mfrag        = '0 ;
//    assign p0_reord_dirtp_write_data_nxt_mfrag  = '0 ;
//    assign p0_reord_cnt_v_nxt_mfrag             = 1'b0 ;
//    assign p0_reord_cnt_rw_nxt_mfrag            = HQM_AW_RMWPIPE_NOOP ;
//    assign p0_reord_cnt_addr_nxt_mfrag          = '0 ;
//    assign p0_reord_cnt_write_data_nxt_mfrag    = '0 ;

//    assign p3_reord_lbtp_bypsel_nxt_mfrag       = '0 ;
//    assign p3_reord_lbtp_bypdata_nxt_mfrag      = '0 ;
//    assign p3_reord_dirhp_bypsel_nxt_mfrag      = '0 ;
//    assign p3_reord_dirhp_bypdata_nxt_mfrag     = '0 ;
//    assign p3_reord_dirtp_bypsel_nxt_mfrag      = '0 ;
//    assign p3_reord_dirtp_bypdata_nxt_mfrag     = '0 ;

//    assign p2_reord_lbtp_data_f_mfrag           = p2_reord_lbhp_data_f ;
//    assign p2_reord_dirhp_data_f_mfrag          = { p2_reord_lbhp_data_f[14] , p2_reord_lbhp_data_f[13:0] } ;
//    assign p2_reord_dirtp_data_f_mfrag          = { p2_reord_lbhp_data_f[14] , p2_reord_lbhp_data_f[13:0] } ;
//    always_comb begin
//      if ( p2_reord_st_data_f.reord_st.is_ldb ) begin
//        p2_reord_cnt_data_f_mfrag.lb_residue    = { 1'b0 , p2_reord_st_data_f.reord_st.nz_count } ;
//        p2_reord_cnt_data_f_mfrag.lb_cnt        = { 14'h0 , p2_reord_st_data_f.reord_st.nz_count } ;
//        p2_reord_cnt_data_f_mfrag.dir_residue   = 2'h0 ;
//        p2_reord_cnt_data_f_mfrag.dir_cnt       = 13'h0 ;
//      end
//      else begin
//        p2_reord_cnt_data_f_mfrag.lb_residue    = 2'h0 ;
//        p2_reord_cnt_data_f_mfrag.lb_cnt        = 15'h0 ;
//        p2_reord_cnt_data_f_mfrag.dir_residue   = { 1'b0 , p2_reord_st_data_f.reord_st.nz_count } ;
//        p2_reord_cnt_data_f_mfrag.dir_cnt       = { 12'h0 , p2_reord_st_data_f.reord_st.nz_count } ;
//      end
//    end // always
//  end // else HQM_ROP_MULTI_FRAG_ENABLE
//endgenerate


// reorder state pipe for managing qid, qidix and cq assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( ($bits(reord_st_t)) ) // old_qid, old_qidx, cq
) i_reord_st (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_st_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_st_v_nxt             ) // i_
        ,.p0_rw_nxt         ( p0_reord_st_rw_nxt            ) // i_
        ,.p0_addr_nxt       ( p0_reord_st_addr_nxt          ) // i_
        ,.p0_write_data_nxt ( p0_reord_st_write_data_nxt    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_st_hold              ) // i_
        ,.p0_v_f            ( p0_reord_st_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_st_rw_f              ) // o_
        ,.p0_addr_f         ( p0_reord_st_addr_f            ) // o_
        ,.p0_data_f         ( p0_reord_st_data_f            ) // o_
                                                             
        ,.p1_hold           ( p1_reord_st_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_st_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_st_rw_f              ) // o_
        ,.p1_addr_f         ( p1_reord_st_addr_f            ) // o_
        ,.p1_data_f         ( p1_reord_st_data_f            ) // o_
                                                             
        ,.p2_hold           ( p2_reord_st_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_st_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_st_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_st_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_st_data_f            ) // o_ 
                                                             
        ,.p3_hold           ( p3_reord_st_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_st_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_st_bypdata_nxt       ) // i_
                                                                                          
        ,.p3_v_f            ( p3_reord_st_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_st_rw_f              ) // o_
        ,.p3_addr_f         ( p3_reord_st_addr_f            ) // o_
        ,.p3_data_f         ( p3_reord_st_data_f            ) // o_
                                                                                     
        ,.mem_write         ( func_reord_st_mem_we         ) // o_
        ,.mem_write_addr    ( func_reord_st_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_st_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_st_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_st_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_st_mem_rdata     ) // i_
                                 
);

// reorder lbhp pipe for managing lb head ptr assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( 15 ) 
) i_reord_lbhp (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_lbhp_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_lbhp_v_nxt             ) // i_
        ,.p0_rw_nxt         ( p0_reord_lbhp_rw_nxt            ) // i_
        ,.p0_addr_nxt       ( p0_reord_lbhp_addr_nxt          ) // i_
        ,.p0_write_data_nxt ( p0_reord_lbhp_write_data_nxt    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_lbhp_hold              ) // i_
        ,.p0_v_f            ( p0_reord_lbhp_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_lbhp_rw_f              ) // o_
        ,.p0_addr_f         ( p0_reord_lbhp_addr_f            ) // o_
        ,.p0_data_f         ( p0_reord_lbhp_data_f            ) // o_
                                                             
        ,.p1_hold           ( p1_reord_lbhp_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_lbhp_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_lbhp_rw_f              ) // o_
        ,.p1_addr_f         ( p1_reord_lbhp_addr_f            ) // o_
        ,.p1_data_f         ( p1_reord_lbhp_data_f            ) // o_
                                                             
        ,.p2_hold           ( p2_reord_lbhp_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_lbhp_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_lbhp_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_lbhp_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_lbhp_data_f            ) // o_
                                                             
        ,.p3_hold           ( p3_reord_lbhp_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_lbhp_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_lbhp_bypdata_nxt       ) // i_
                                                                     
        ,.p3_v_f            ( p3_reord_lbhp_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_lbhp_rw_f              ) // o_
        ,.p3_addr_f         ( p3_reord_lbhp_addr_f            ) // o_
        ,.p3_data_f         ( p3_reord_lbhp_data_f            ) // o_
                                                                     
        ,.mem_write         ( func_reord_lbhp_mem_we         ) // o_  
        ,.mem_write_addr    ( func_reord_lbhp_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_lbhp_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_lbhp_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_lbhp_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_lbhp_mem_rdata     ) // i_
                                 
);

// reorder lbhp pipe for managing non-atomic load balanced type head ptr assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( 15 ) 
) i_reord_lbtp (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_lbtp_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_lbtp_v_nxt_mfrag             ) // i_
        ,.p0_rw_nxt         ( p0_reord_lbtp_rw_nxt_mfrag            ) // i_
        ,.p0_addr_nxt       ( p0_reord_lbtp_addr_nxt_mfrag          ) // i_
        ,.p0_write_data_nxt ( p0_reord_lbtp_write_data_nxt_mfrag    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_lbtp_hold              ) // i_
        ,.p0_v_f            ( p0_reord_lbtp_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_lbtp_rw_f              ) // o_
        ,.p0_addr_f         ( p0_reord_lbtp_addr_f            ) // o_
        ,.p0_data_f         ( p0_reord_lbtp_data_f            ) // o_
                                                             
        ,.p1_hold           ( p1_reord_lbtp_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_lbtp_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_lbtp_rw_f_nc           ) // o_
        ,.p1_addr_f         ( p1_reord_lbtp_addr_f_nc         ) // o_
        ,.p1_data_f         ( p1_reord_lbtp_data_f_nc         ) // o_
                                                             
        ,.p2_hold           ( p2_reord_lbtp_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_lbtp_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_lbtp_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_lbtp_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_lbtp_data_f            ) // o_
                                                             
        ,.p3_hold           ( p3_reord_lbtp_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_lbtp_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_lbtp_bypdata_nxt       ) // i_
                                                                     
        ,.p3_v_f            ( p3_reord_lbtp_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_lbtp_rw_f              ) // o_
        ,.p3_addr_f         ( p3_reord_lbtp_addr_f            ) // o_
        ,.p3_data_f         ( p3_reord_lbtp_data_f            ) // o_
                                                                     
        ,.mem_write         ( func_reord_lbtp_mem_we         ) // o_  
        ,.mem_write_addr    ( func_reord_lbtp_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_lbtp_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_lbtp_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_lbtp_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_lbtp_mem_rdata     ) // i_
                                 
);

// reorder dirhp pipe for managing directed type head ptr assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( 15 ) 
) i_reord_dirhp (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_dirhp_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_dirhp_v_nxt_mfrag             ) // i_
        ,.p0_rw_nxt         ( p0_reord_dirhp_rw_nxt_mfrag            ) // i_
        ,.p0_addr_nxt       ( p0_reord_dirhp_addr_nxt_mfrag          ) // i_
        ,.p0_write_data_nxt ( p0_reord_dirhp_write_data_nxt_mfrag    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_dirhp_hold              ) // i_
        ,.p0_v_f            ( p0_reord_dirhp_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_dirhp_rw_f_nc           ) // o_
        ,.p0_addr_f         ( p0_reord_dirhp_addr_f_nc         ) // o_
        ,.p0_data_f         ( p0_reord_dirhp_data_f_nc         ) // o_
                                                             
        ,.p1_hold           ( p1_reord_dirhp_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_dirhp_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_dirhp_rw_f              ) // o_
        ,.p1_addr_f         ( p1_reord_dirhp_addr_f            ) // o_
        ,.p1_data_f         ( p1_reord_dirhp_data_f            ) // o_
                                                             
        ,.p2_hold           ( p2_reord_dirhp_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_dirhp_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_dirhp_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_dirhp_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_dirhp_data_f            ) // o_
                                                             
        ,.p3_hold           ( p3_reord_dirhp_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_dirhp_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_dirhp_bypdata_nxt       ) // i_
                                                                      
        ,.p3_v_f            ( p3_reord_dirhp_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_dirhp_rw_f_nc              ) // o_
        ,.p3_addr_f         ( p3_reord_dirhp_addr_f_nc            ) // o_
        ,.p3_data_f         ( p3_reord_dirhp_data_f            ) // o_
                                                                      
        ,.mem_write         ( func_reord_dirhp_mem_we         ) // o_  
        ,.mem_write_addr    ( func_reord_dirhp_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_dirhp_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_dirhp_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_dirhp_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_dirhp_mem_rdata     ) // i_
                                 
);

// reorder dirtp pipe for managing directed type tail ptr assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( 15 ) 
) i_reord_dirtp (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_dirtp_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_dirtp_v_nxt_mfrag             ) // i_
        ,.p0_rw_nxt         ( p0_reord_dirtp_rw_nxt_mfrag            ) // i_
        ,.p0_addr_nxt       ( p0_reord_dirtp_addr_nxt_mfrag          ) // i_
        ,.p0_write_data_nxt ( p0_reord_dirtp_write_data_nxt_mfrag    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_dirtp_hold              ) // i_
        ,.p0_v_f            ( p0_reord_dirtp_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_dirtp_rw_f_nc           ) // o_
        ,.p0_addr_f         ( p0_reord_dirtp_addr_f_nc         ) // o_
        ,.p0_data_f         ( p0_reord_dirtp_data_f_nc         ) // o_
                                                             
        ,.p1_hold           ( p1_reord_dirtp_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_dirtp_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_dirtp_rw_f              ) // o_
        ,.p1_addr_f         ( p1_reord_dirtp_addr_f            ) // o_
        ,.p1_data_f         ( p1_reord_dirtp_data_f            ) // o_
                                                             
        ,.p2_hold           ( p2_reord_dirtp_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_dirtp_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_dirtp_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_dirtp_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_dirtp_data_f            ) // o_
                                                             
        ,.p3_hold           ( p3_reord_dirtp_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_dirtp_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_dirtp_bypdata_nxt       ) // i_
                                                                      
        ,.p3_v_f            ( p3_reord_dirtp_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_dirtp_rw_f_nc              ) // o_
        ,.p3_addr_f         ( p3_reord_dirtp_addr_f_nc            ) // o_
        ,.p3_data_f         ( p3_reord_dirtp_data_f            ) // o_
                                                                      
        ,.mem_write         ( func_reord_dirtp_mem_we         ) // o_  
        ,.mem_write_addr    ( func_reord_dirtp_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_dirtp_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_dirtp_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_dirtp_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_dirtp_mem_rdata     ) // i_
                                 
);

// reorder dirtp pipe for managing directed type tail ptr assigned to seqnum
hqm_AW_rmw_mem_4pipe #(
         .DEPTH( 2048 )
        ,.WIDTH( $bits(cnt_residue_t) ) 
) i_reord_cnt (
         .clk               ( hqm_gated_clk )
        ,.rst_n             ( hqm_gated_rst_n )

        ,.status            ( reord_cnt_rmw_mem_4pipe_status_nxt ) // o_

        ,.p0_v_nxt          ( p0_reord_cnt_v_nxt_mfrag             ) // i_
        ,.p0_rw_nxt         ( p0_reord_cnt_rw_nxt_mfrag            ) // i_
        ,.p0_addr_nxt       ( p0_reord_cnt_addr_nxt_mfrag          ) // i_
        ,.p0_write_data_nxt ( p0_reord_cnt_write_data_nxt_mfrag    ) // i_
                                                             
        ,.p0_hold           ( p0_reord_cnt_hold              ) // i_
        ,.p0_v_f            ( p0_reord_cnt_v_f               ) // o_
        ,.p0_rw_f           ( p0_reord_cnt_rw_f              ) // o_
        ,.p0_addr_f         ( p0_reord_cnt_addr_f            ) // o_
        ,.p0_data_f         ( p0_reord_cnt_data_f            ) // o_
                                                             
        ,.p1_hold           ( p1_reord_cnt_hold              ) // i_
                                                             
        ,.p1_v_f            ( p1_reord_cnt_v_f               ) // o_
        ,.p1_rw_f           ( p1_reord_cnt_rw_f              ) // o_
        ,.p1_addr_f         ( p1_reord_cnt_addr_f            ) // o_
        ,.p1_data_f         ( p1_reord_cnt_data_f            ) // o_
                                                             
        ,.p2_hold           ( p2_reord_cnt_hold              ) // i_
                                                             
        ,.p2_v_f            ( p2_reord_cnt_v_f               ) // o_
        ,.p2_rw_f           ( p2_reord_cnt_rw_f              ) // o_
        ,.p2_addr_f         ( p2_reord_cnt_addr_f            ) // o_
        ,.p2_data_f         ( p2_reord_cnt_data_f            ) // o_
                                                             
        ,.p3_hold           ( p3_reord_cnt_hold_nc              ) // i_
        ,.p3_bypsel_nxt     ( p3_reord_cnt_bypsel_nxt        ) // i_
        ,.p3_bypdata_nxt    ( p3_reord_cnt_bypdata_nxt       ) // i_
                                                                    
        ,.p3_v_f            ( p3_reord_cnt_v_f               ) // o_
        ,.p3_rw_f           ( p3_reord_cnt_rw_f              ) // o_
        ,.p3_addr_f         ( p3_reord_cnt_addr_f            ) // o_
        ,.p3_data_f         ( p3_reord_cnt_data_f            ) // o_
                                                                    
        ,.mem_write         ( func_reord_cnt_mem_we         ) // o_  
        ,.mem_write_addr    ( func_reord_cnt_mem_waddr    ) // o_
        ,.mem_write_data    ( func_reord_cnt_mem_wdata    ) // o_
        ,.mem_read          ( func_reord_cnt_mem_re          ) // o_
        ,.mem_read_addr     ( func_reord_cnt_mem_raddr     ) // o_
        ,.mem_read_data     ( func_reord_cnt_mem_rdata     ) // i_
                                 
);

assign hqm_rop_target_cfg_diagnostic_aw_status_status = 
                                                        {
                                                           20'd0
                                                          ,3'd0 
                                                          ,chp_rop_hcw_db2_status_pnc[2:0]        //  8:6
                                                          ,lsp_reordercmp_db_status_pnc[2:0]      //  5:3 
                                                          ,chp_rop_hcw_db_status_pnc[2:0]         //  2:0
                                                         };


assign hqm_rop_target_cfg_smon_disable_smon = disable_smon;
assign hqm_rop_target_cfg_smon_smon_v = smon_0_v;
assign hqm_rop_target_cfg_smon_smon_comp = smon_0_comp;
assign hqm_rop_target_cfg_smon_smon_val = smon_0_val;
assign smon_enabled_nxt = hqm_rop_target_cfg_smon_smon_enabled;

assign hqm_rop_target_cfg_syndrome_00_capture_v = syndrome_00_capture_v;
assign hqm_rop_target_cfg_syndrome_00_capture_data = syndrome_00_capture_data;

assign hqm_rop_target_cfg_syndrome_01_capture_v = syndrome_01_capture_v;
assign hqm_rop_target_cfg_syndrome_01_capture_data = syndrome_01_capture_data;

//-----------------------------------------------------------------------------------------------------
// rp rf wrapper
// the rop_unit_pipeidle is used to indicate to system that rop unit is idle.
// To generate this signal all pipe line valids will be ored together and result inverted.
always_comb begin


        cfg_grp_sn_mode_nxt = cfg_grp_sn_mode_f;  // {RSVZ3[31:26]; sn_mode_3[26:24]; RSVZ2[23:18]; sn_mode_2[18:16]; RSVZ1[15:11]; sn_mode_1[10:8]; RSVZ0[7:3]; sn_mode_0[2:0]}
                                                      
        cfg_unit_idle_nxt                             = cfg_unit_idle_f;

        cfg_csr_control_nxt                           = cfg_csr_control_f;
        cfg_control_general_0_nxt                     = cfg_control_general_0_f;

        cfg_pipe_health_valid_rop_nalb_nxt            = {16'd0
                                                         ,4'd0

                                                         ,4'd0
                                          
                                                         ,4'd0

                                                         ,1'b0 
                                                         ,p2_rop_nalb_enq_f.v     
                                                         ,p1_rop_nalb_enq_f.v     
                                                         ,p0_rop_nalb_enq_f.v};

        cfg_pipe_health_hold_rop_nalb_nxt             = {16'd0
                                                        ,4'd0
                                                        ,4'd0
                              
                                                        ,4'd0

                                                        ,1'b0
                                                        ,p2_rop_nalb_enq_ctl.hold
                                                        ,p1_rop_nalb_enq_ctl.hold
                                                        ,p0_rop_nalb_enq_ctl.hold};
                                                               
        cfg_pipe_health_valid_rop_dp_nxt              = {29'd0,p2_rop_dp_enq_f.v,p1_rop_dp_enq_f.v,p0_rop_dp_enq_f.v};
        cfg_pipe_health_hold_rop_dp_nxt               = {29'd0,p2_rop_dp_enq_ctl.hold,p1_rop_dp_enq_ctl.hold,p0_rop_dp_enq_ctl.hold};
                                                     
        cfg_pipe_health_valid_rop_qed_dqed_nxt        = {30'd0,p1_qed_dqed_enq_f.v,p0_qed_dqed_enq_f.v};
        cfg_pipe_health_hold_rop_qed_dqed_nxt         = {30'd0                          ,p1_qed_dqed_enq_ctl.hold,p0_qed_dqed_enq_ctl.hold};

        cfg_pipe_health_valid_rop_lsp_reordercmp_nxt  = {
                                                           1'b0                      ,p2_reord_f.v              ,p1_reord_f.v              ,p0_reord_f.v
                                                          ,p3_reord_cnt_v_f          ,p2_reord_cnt_v_f          ,p1_reord_cnt_v_f          ,p0_reord_cnt_v_f
                                                          ,p3_reord_dirtp_v_f        ,p2_reord_dirtp_v_f        ,p1_reord_dirtp_v_f        ,p0_reord_dirtp_v_f
                                                          ,p3_reord_dirhp_v_f        ,p2_reord_dirhp_v_f        ,p1_reord_dirhp_v_f        ,p0_reord_dirhp_v_f
                                                          ,p3_reord_lbtp_v_f         ,p2_reord_lbtp_v_f         ,p1_reord_lbtp_v_f         ,p0_reord_lbtp_v_f
                                                          ,p3_reord_lbhp_v_f         ,p2_reord_lbhp_v_f         ,p1_reord_lbhp_v_f         ,p0_reord_lbhp_v_f
                                                          ,p3_reord_st_v_f           ,p2_reord_st_v_f           ,p1_reord_st_v_f           ,p0_reord_st_v_f
                                                          ,1'b0                      ,1'b0                      ,1'b0                      ,1'b0};


        cfg_pipe_health_hold_rop_lsp_reordercmp_nxt   = {
                                                           p3_reord_ctl.hold         ,p2_reord_ctl.hold         ,p1_reord_ctl.hold         ,p0_reord_ctl.hold
                                                          ,p3_reord_cnt_hold_nc         ,p2_reord_cnt_hold         ,p1_reord_cnt_hold         ,p0_reord_cnt_hold
                                                          ,p3_reord_dirtp_hold_nc       ,p2_reord_dirtp_hold       ,p1_reord_dirtp_hold       ,p0_reord_dirtp_hold
                                                          ,p3_reord_dirhp_hold_nc       ,p2_reord_dirhp_hold       ,p1_reord_dirhp_hold       ,p0_reord_dirhp_hold
                                                          ,p3_reord_lbtp_hold_nc        ,p2_reord_lbtp_hold        ,p1_reord_lbtp_hold        ,p0_reord_lbtp_hold
                                                          ,p3_reord_lbhp_hold_nc        ,p2_reord_lbhp_hold        ,p1_reord_lbhp_hold        ,p0_reord_lbhp_hold
                                                          ,p3_reord_st_hold_nc          ,p2_reord_st_hold          ,p1_reord_st_hold          ,p0_reord_st_hold
                                                          ,1'b0                      ,1'b0                      ,1'b0                      ,1'b0};
                                                               
        cfg_serializer_status_nxt                = {18'd0,int_serializer_status[13:0]};
                                                                    
         cfg_interface_nxt                            = { ~ int_idle
                                                         ,17'd0
                                                         ,rop_lsp_reordercmp_v
                                                         ,rop_lsp_reordercmp_ready
                                                         ,rop_qed_dqed_enq_v
                                                         ,rop_qed_enq_ready
                                                         ,rop_nalb_enq_v
                                                         ,rop_nalb_enq_ready
                                                         ,rop_dp_enq_v
                                                         ,rop_dp_enq_ready
                                                         ,chp_rop_hcw_v
                                                         ,chp_rop_hcw_ready
                                                         ,rop_alarm_down_v
                                                         ,rop_alarm_down_ready
                                                         ,rop_alarm_up_v
                                                         ,rop_alarm_up_ready
                                                        } ;

        cfg_unit_idle_nxt.pipe_idle                   = ~( (|cfg_pipe_health_valid_rop_nalb_nxt) | 
                                                           (|cfg_pipe_health_valid_rop_dp_nxt) |
                                                           (|cfg_pipe_health_valid_rop_qed_dqed_nxt) |
                                                           (|cfg_pipe_health_valid_rop_lsp_reordercmp_nxt) |
                                                           (|cfg_pipe_health_valid_grp0_nxt[9:0]) |
                                                           (|cfg_pipe_health_valid_grp1_nxt[9:0]) |
                                                           (sn_complete_fifo_empty == 0) |
                                                           (dir_rply_req_fifo_empty == 0) | 
                                                           (ldb_rply_req_fifo_empty == 0) |
                                                           (sn_ordered_fifo_empty == 0) |
                                                           (lsp_reordercmp_fifo_empty == 0)
                                                         );

         cfg_unit_idle_nxt.unit_idle                  = ( ( cfg_unit_idle_nxt.pipe_idle ) &
                                                               ( chp_rop_hcw_fifo_empty ) &
                                                              ( dir_rply_req_fifo_empty ) &
                                                              ( ldb_rply_req_fifo_empty ) &
                                                                ( sn_ordered_fifo_empty ) &
                                                               ( sn_complete_fifo_empty ) &
                                                            ( lsp_reordercmp_fifo_empty ) & 
                                                ( rop_cfg_ring_top_rx_fifo_status.empty ) &
                                              ( chp_rop_hcw_db2_status_pnc[1:0] == 2'd0 ) &
                                            ( lsp_reordercmp_db_status_pnc[1:0] == 2'd0 ) &
                                               ( chp_rop_hcw_db_status_pnc[1:0] == 2'd0 ) &

                                                          (hqm_reorder_pipe_tx_sync_idle) &

                                                   ( cfg_serializer_status_f[1:0]==2'd0 ) &

                                                   ( cfg_serializer_status_f[8:7]==2'd0 ) &

                                                                    ( ~ chp_rop_hcw_v_f ) &
                                                                     ( ~ rop_dp_enq_v_f ) &
                                                                   ( ~ rop_nalb_enq_v_f ) &
                                                               ( ~ rop_qed_dqed_enq_v_f ) &
                                                             ( ~ rop_lsp_reordercmp_v_f ) &

                                                             ( ~ hqm_gated_rst_n_active )
                                                        );

         cfg_unit_idle_nxt.cfg_ready                   = (cfg_unit_idle_nxt.pipe_idle ) ;
         cfg_req_ready = cfg_unit_idle_f.cfg_ready ;

// top level ports , NOTE: dont use 'hqm_gated_rst_n_active' in "local" rop_unit_idle since LSP turns clocks on, only send indication that PF reset is running
// hqm_gated_rst_n_active is included into cfg_unit_idle_f.unit_idle to cover gap after hqm_gated_clk is on (from chp) until PF reset SM starts
unit_idle_hqm_clk_inp_gated                        = ( 
                                                     ( cfg_idle )
                                                   & ( int_idle )
                                                   ) ;
rop_reset_done = ~ ( hqm_gated_rst_n_active ) ;
rop_unit_idle = cfg_unit_idle_f.unit_idle &  ~ ( pf_reset_active ) & unit_idle_hqm_clk_inp_gated ;

//CHP controls clock for rop
// send rop_clk_idle to indicate that hqm_gated_clk pipeline is active or need to turn on clocks for CFG access or RX_SYNC
rop_clk_idle = cfg_unit_idle_f.unit_idle & cfg_rx_idle;

end

//....................................................................................................
// CFG REGISTER

assign cfg_control_general_0_single_op_chp_rop_hcw = cfg_control_general_0_f[0];
assign cfg_control_general_0_sn_start_get_rr_enable = cfg_control_general_0_f[1];

//....................................................................................................
//HW AGITATE
assign hqm_rop_target_cfg_hw_agitate_control_reg_v = 1'b0;
assign hqm_rop_target_cfg_hw_agitate_control_reg_nxt = cfg_agitate_control_nxt;
assign cfg_agitate_control_f = hqm_rop_target_cfg_hw_agitate_control_reg_f;
assign cfg_agitate_control_nxt = cfg_agitate_control_f ;

assign hqm_rop_target_cfg_hw_agitate_select_reg_v = 1'b0;
assign hqm_rop_target_cfg_hw_agitate_select_reg_nxt = cfg_agitate_select_nxt;
assign cfg_agitate_select_f = hqm_rop_target_cfg_hw_agitate_select_reg_f;
assign cfg_agitate_select_nxt = cfg_agitate_select_f ;
assign hqm_rop_target_cfg_rop_csr_control_reg_v = 1'b0;
assign hqm_rop_target_cfg_rop_csr_control_reg_nxt = cfg_csr_control_nxt;
assign cfg_csr_control_f = hqm_rop_target_cfg_rop_csr_control_reg_f;
assign hqm_rop_target_cfg_control_general_0_reg_v = 1'b0;
assign hqm_rop_target_cfg_control_general_0_reg_nxt = cfg_control_general_0_nxt;
assign cfg_control_general_0_f = hqm_rop_target_cfg_control_general_0_reg_f;

assign hqm_rop_target_cfg_frag_integrity_count_status = {16'd0,frag_integrity_cnt_nxt};
assign hqm_rop_target_cfg_serializer_status_status = cfg_serializer_status_f;

assign hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status = cfg_pipe_health_valid_rop_nalb_f;
assign hqm_rop_target_cfg_pipe_health_valid_rop_dp_status = cfg_pipe_health_valid_rop_dp_f;
assign hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status = cfg_pipe_health_hold_rop_nalb_f;
assign hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status = cfg_pipe_health_valid_rop_qed_dqed_f;

assign hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status = cfg_pipe_health_hold_rop_qed_dqed_f;
assign hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status = cfg_pipe_health_valid_rop_lsp_reordercmp_f;
assign hqm_rop_target_cfg_pipe_health_valid_grp0_status = cfg_pipe_health_valid_grp0_f;
assign hqm_rop_target_cfg_pipe_health_valid_grp1_status = cfg_pipe_health_valid_grp1_f;

assign hqm_rop_target_cfg_grp_sn_mode_reg_v = 1'b0;
assign hqm_rop_target_cfg_grp_sn_mode_reg_nxt = cfg_grp_sn_mode_nxt;
assign cfg_grp_sn_mode_f = hqm_rop_target_cfg_grp_sn_mode_reg_f;

assign hqm_rop_target_cfg_pipe_health_hold_rop_dp_status = cfg_pipe_health_hold_rop_dp_f;
assign hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status = cfg_pipe_health_hold_rop_lsp_reordercmp_f;
assign hqm_rop_target_cfg_pipe_health_hold_grp0_status = cfg_pipe_health_hold_grp0_f;
assign hqm_rop_target_cfg_pipe_health_hold_grp1_status = cfg_pipe_health_hold_grp1_f;

assign hqm_rop_target_cfg_interface_status_status = cfg_interface_f;
assign hqm_rop_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_nxt;
assign cfg_unit_idle_f = hqm_rop_target_cfg_unit_idle_reg_f;

//pop only when the selected  hqm_AW_sn_order instance can take it. 
// Note that his can head of line block the others. In worst case each group can take request every other clock
assign sn_complete_fifo_pop = |(hqm_aw_sn_order_select & hqm_aw_sn_ready);

logic sn_complete_fifo_pop_data_sn_bit_11_nc;
assign sn_complete_fifo_pop_data_sn_bit_11_nc = sn_complete_fifo_pop_data.sn[11];

hqm_AW_bindec #(
   .WIDTH(1)
  ,.DWIDTH(2)
) i_hqm_group_bindec ( 
   .a      ( sn_complete_fifo_pop_data.sn[10:10] )  
  ,.enable ( ~sn_complete_fifo_empty )
  ,.dec    ( hqm_aw_sn_order_select ) 
);

genvar HQM_SN_GRP;

generate

for (HQM_SN_GRP=0; HQM_SN_GRP<HQM_NUM_SN_GRP; HQM_SN_GRP=HQM_SN_GRP+1) begin : FOR_HQM_SN_GRP 

    hqm_AW_sn_order i_hqm_aw_sn_order (

         .clk                            ( hqm_gated_clk )
        ,.rst_n                          ( hqm_gated_rst_n ) 
        
        // completion request for sequence
        ,.cmp_v                          ( hqm_aw_sn_order_select[HQM_SN_GRP]                     ) // i_
        ,.cmp_sn                         ( sn_complete_fifo_pop_data.sn[9:0]                      ) // i_ 
        ,.cmp_slt                        ( sn_complete_fifo_pop_data.grp_slt[4:0]                 ) // i_
        ,.cmp_ready                      ( hqm_aw_sn_ready[HQM_SN_GRP]                            ) // o_
                                                                                                  
        // group x sequence number ready to be replayed                                           
        ,.replay_v                       ( replay_v[HQM_SN_GRP]                                   ) // o_
        ,.replay_selected                ( replay_selected[HQM_SN_GRP]                          ) // i_
                                                                                                  
        ,.replay_sequence_v              ( replay_sequence_v[HQM_SN_GRP]                          ) // o_
        ,.replay_sequence                ( replay_sequence[(HQM_SN_GRP*10) +: 10]                 ) // o_
                                                                                                  
        // configured sn mode                                                                     
        ,.sn_mode                        ( cfg_grp_sn_mode_copy_f [(HQM_SN_GRP *8) +: 3]               ) // i_
                                                                                                  
        // hqm_AW_rmw_mem_3pipe status
        ,.rmw_mem_3pipe_status           ( sn_order_rmw_mem_3pipe_status_nxt  [HQM_SN_GRP]            ) // o_
       
        // ram ports
        ,.p2_shft_mem_write              ( func_sn_order_shft_mem_we     [(HQM_SN_GRP*1)  +:  1] ) // o_
        ,.p2_shft_mem_write_addr         ( func_sn_order_shft_mem_waddr[(HQM_SN_GRP*5)  +:  5] ) // o_
        ,.p2_shft_mem_write_data         ( func_sn_order_shft_mem_wdata[(HQM_SN_GRP*12) +: 12] ) // o_
        ,.p0_shft_mem_read               ( func_sn_order_shft_mem_re      [(HQM_SN_GRP*1)  +:  1] ) // o_
        ,.p0_shft_mem_read_addr          ( func_sn_order_shft_mem_raddr [(HQM_SN_GRP*5)  +:  5] ) // o_
        ,.p1_shft_mem_read_data          ( func_sn_order_shft_mem_rdata [(HQM_SN_GRP*12) +: 12] ) // i_
        
        // residue check error on shift
        ,.p2_shft_data_residue_check_err ( sn_order_shft_data_residue_check_err[(HQM_SN_GRP*1) +: 1] ) // o_
       
        // these are debug related ports
        ,.pipe_health_sn_state_f         ( sn_order_pipe_health_sn_state_f [(HQM_SN_GRP*1024) +: 1024]   ) // o_
        ,.pipe_health_valid              ( sn_order_pipe_health_valid      [(HQM_SN_GRP*32) +: 32]      ) // o_
        ,.pipe_health_hold               ( sn_order_pipe_health_hold       [(HQM_SN_GRP*32) +: 32]        ) // o_

        ,.sn_state_err_any_f             ( sn_state_err_any_f              [(HQM_SN_GRP*1)  +:  1] ) // o_
    ) ;

  if (HQM_SN_GRP==0) begin
    assign hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status = sn_order_pipe_health_sn_state_f[ 0*1024 +: 1024] ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0
    assign cfg_pipe_health_valid_grp0_nxt                = sn_order_pipe_health_valid[(0*32) +: 32];
    assign cfg_pipe_health_hold_grp0_nxt                 = sn_order_pipe_health_hold[(0*32) +: 32];
  end
  if (HQM_SN_GRP==1) begin
    assign hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status = sn_order_pipe_health_sn_state_f[ 1*1024 +: 1024] ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1
    assign cfg_pipe_health_valid_grp1_nxt                = sn_order_pipe_health_valid[(1*32) +: 32];
    assign cfg_pipe_health_hold_grp1_nxt                 = sn_order_pipe_health_hold[(1*32) +: 32];
  end

end // for (HQM_SN_GRP=0

endgenerate

// arbiter to select completed sequence numbers from the AW_sn_order instances. The instance is used to generate the full 12-bit sequence number.
// Once selected the sequence number is pushed into the FIFO. 
hqm_AW_rr_arb #(
   .NUM_REQS ( HQM_NUM_SN_GRP )
) i_replay_request_select (
   .clk       ( hqm_gated_clk )
  ,.rst_n     ( hqm_gated_rst_n )
  ,.reqs      ( replay_v )
  ,.update    ( replay_sn_update )
  ,.winner_v  ( replay_sn_winner_v )
  ,.winner    ( replay_sn_winner )
) ;

hqm_AW_bindec #(
   .WIDTH(HQM_NUM_SN_GRP_WIDTH)
) i_rplay_sn_winner_bindec (
   .a      ( replay_sn_winner )
  ,.enable ( replay_sn_winner_v )
  ,.dec    ( replay_selected_dec )
);

assign replay_selected = (replay_selected_dec & {HQM_NUM_SN_GRP{replay_sn_update}}); // this is done this way to avoid lint error 6008 (functional logic on port)

// the arbiter will grant requests only when there is enough headroom in the sn_ordered_fifo 
always_comb begin

    replay_sn_update = 1'b0;

    if ( ~sn_ordered_fifo_afull & replay_sn_winner_v) begin
      replay_sn_update = 1'b1;
    end 

end

// the ordered SNs arrive 2 clocks later and they are one hot meaning that there can be one valid per group per clock
generate
if (HQM_NUM_SN_GRP==4) begin
always_comb begin

    sn_ordered_fifo_push = 1'b0; 
    sn_ordered_fifo_push_data = '0; 

    case ( replay_sequence_v )
       4'b0001 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd0,replay_sequence[(0 * 10) +: 10] }; end
       4'b0010 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd1,replay_sequence[(1 * 10) +: 10] }; end
       4'b0100 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd2,replay_sequence[(2 * 10) +: 10] }; end
       4'b1000 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd3,replay_sequence[(3 * 10) +: 10] }; end
       default : begin sn_ordered_fifo_push = 1'b0; end
    endcase

end
end

if (HQM_NUM_SN_GRP==2) begin
always_comb begin

    sn_ordered_fifo_push = 1'b0; 
    sn_ordered_fifo_push_data = '0; 

    case ( replay_sequence_v )
       2'b01 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd0,replay_sequence[(0 * 10) +: 10] }; end
       2'b10 : begin sn_ordered_fifo_push = 1'b1; sn_ordered_fifo_push_data = { 2'd1,replay_sequence[(1 * 10) +: 10] }; end
       default : begin sn_ordered_fifo_push = 1'b0; end
    endcase

end
end

endgenerate

assign cfg_grp_sn_mode_copy_f_7_3_nc = cfg_grp_sn_mode_copy_f[7:3];
assign cfg_grp_sn_mode_copy_f_15_11_nc = cfg_grp_sn_mode_copy_f[15:11];
assign cfg_grp_sn_mode_copy_f_23_19_nc = cfg_grp_sn_mode_copy_f[23:19];
assign cfg_grp_sn_mode_copy_f_31_27_nc = cfg_grp_sn_mode_copy_f[31:27];

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
    if (~hqm_gated_rst_n) begin
      cfg_serializer_status_f <= '0;

      cfg_pipe_health_valid_rop_nalb_f <= '0;
      cfg_pipe_health_hold_rop_nalb_f <= '0;

      cfg_pipe_health_valid_rop_dp_f <= '0;
      cfg_pipe_health_hold_rop_dp_f <= '0;

      cfg_pipe_health_valid_rop_lsp_reordercmp_f  <= '0;
      cfg_pipe_health_hold_rop_lsp_reordercmp_f  <= '0;

      cfg_pipe_health_valid_rop_qed_dqed_f <= '0;
      cfg_pipe_health_hold_rop_qed_dqed_f <= '0;

      cfg_pipe_health_valid_grp0_f <= '0;
      cfg_pipe_health_valid_grp1_f <= '0;

      cfg_pipe_health_hold_grp0_f <= '0;
      cfg_pipe_health_hold_grp1_f <= '0;

      cfg_interface_f <= '0;

      cfg_grp_sn_mode_copy_f <= '0;

      frag_integrity_cnt_f <= '0;

    end 
    else begin

      cfg_serializer_status_f <= cfg_serializer_status_nxt;

      cfg_pipe_health_valid_rop_nalb_f <= cfg_pipe_health_valid_rop_nalb_nxt;
      cfg_pipe_health_hold_rop_nalb_f <= cfg_pipe_health_hold_rop_nalb_nxt;

      cfg_pipe_health_valid_rop_dp_f <= cfg_pipe_health_valid_rop_dp_nxt;
      cfg_pipe_health_hold_rop_dp_f <= cfg_pipe_health_hold_rop_dp_nxt;

      cfg_pipe_health_valid_rop_lsp_reordercmp_f <= cfg_pipe_health_valid_rop_lsp_reordercmp_nxt;
      cfg_pipe_health_hold_rop_lsp_reordercmp_f <= cfg_pipe_health_hold_rop_lsp_reordercmp_nxt;

      cfg_pipe_health_valid_rop_qed_dqed_f <= cfg_pipe_health_valid_rop_qed_dqed_nxt;
      cfg_pipe_health_hold_rop_qed_dqed_f <= cfg_pipe_health_hold_rop_qed_dqed_nxt;
      cfg_pipe_health_valid_grp0_f <= cfg_pipe_health_valid_grp0_nxt;
      cfg_pipe_health_valid_grp1_f <= cfg_pipe_health_valid_grp1_nxt;
      cfg_pipe_health_hold_grp0_f <= cfg_pipe_health_hold_grp0_nxt;
      cfg_pipe_health_hold_grp1_f <= cfg_pipe_health_hold_grp1_nxt;
      cfg_interface_f <= cfg_interface_nxt;
      cfg_grp_sn_mode_copy_f <= cfg_grp_sn_mode_nxt;

      frag_integrity_cnt_f <= frag_integrity_cnt_nxt;

    end
end

  //....................................................................................................
  // SMON
  assign smon_0_v[ 0 * 1 +: 1 ]                                  = smon_enabled_f ? ( chp_rop_hcw_db_out_valid_and_ready_f ) : 1'b0; 
  assign smon_0_comp[ 0 * 32 +: 32 ]                             = { 24'd0 , chp_rop_hcw_db_out_data_cq_hcw_msg_info_qid_f } ;
  assign smon_0_val[ 0 * 32 +: 32 ]                              = 32'd1 ;

  assign smon_0_v[ 1 * 1 +: 1 ]                                  = smon_enabled_f ? ( rop_dp_enq_f & ( rop_dp_enq_data_cmd_f == ROP_DP_ENQ_DIR_ENQ_NEW_HCW) ) : 1'b0;
  assign smon_0_comp[ 1 * 32 +: 32 ]                             = { 25'd0, rop_dp_enq_data_qid_f } ;
  assign smon_0_val[ 1 * 32 +: 32 ]                              = 32'd1 ;

  assign smon_0_v[ 2 * 1 +: 1 ]                                  = smon_enabled_f ? ( rop_nalb_enq_f & (rop_nalb_enq_data_cmd_f == ROP_NALB_ENQ_LB_ENQ_NEW_HCW) ) : 1'b0;
  assign smon_0_comp[ 2 * 32 +: 32 ]                             = { 25'd0,rop_nalb_enq_data_qid_f } ;
  assign smon_0_val[ 2 * 32 +: 32 ]                              = 32'd1 ;
         
  assign smon_0_v[ 3 * 1 +: 1 ]                                  = smon_enabled_f ? ( rop_qed_dqed_enq_rop_qed_enq_ready_f ) : 1'b0;
  assign smon_0_comp[ 3 * 32 +: 32 ]                             = { 25'd0,rop_qed_dqed_enq_data_qid_f } ;
  assign smon_0_val[ 3 * 32 +: 32 ]                              = 32'd1 ;

  assign smon_0_v[ 4 * 1 +: 1 ]                                  = smon_enabled_f ? ( rop_qed_dqed_enq_rop_dqed_enq_ready_f ) : 1'b0;
  assign smon_0_comp[ 4 * 32 +: 32 ]                             = { 25'd0,rop_qed_dqed_enq_data_qid_f } ;
  assign smon_0_val[ 4 * 32 +: 32 ]                              = 32'd1 ;
         
  assign smon_0_v[ 5 * 1 +: 1 ]                                  = smon_enabled_f ? ( rop_lsp_reordercmp_f )  : 1'b0;
  assign smon_0_comp[ 5 * 32 +: 32 ]                             = { 25'd0,rop_lsp_reordercmp_data_qid_f } ;
  assign smon_0_val[ 5 * 32 +: 32 ]                              = 32'd1 ;

  assign smon_0_v[ 6 * 1 +: 1 ]                                  = smon_enabled_f ? replay_sequence_v_f[0] : 1'b0;
  assign smon_0_comp[ 6 * 32 +: 32 ]                             = {20'd0,2'd0,replay_sequence_f[(0*10) +: 10]};
  assign smon_0_val[ 6 * 32 +: 32 ]                              = 32'd1 ;
         
  assign smon_0_v[ 7 * 1 +: 1 ]                                  = smon_enabled_f ? replay_sequence_v_f[1] : 1'b0;
  assign smon_0_comp[ 7 * 32 +: 32 ]                             = {20'd0,2'd1,replay_sequence_f[(1*10) +: 10]}; 
  assign smon_0_val[ 7 * 32 +: 32 ]                              = 32'd1 ;

  assign smon_0_v[ 8 * 1 +: 1 ]                                  = smon_enabled_f ? chp_rop_hcw_db2_out_valid_ready_f : 1'b0; 
  assign smon_0_comp[ 8 * 32 +: 32 ]                             = {30'd0,chp_rop_hcw_db2_out_data_hist_qtype_f}; 
  assign smon_0_val[ 8 * 32 +: 32 ]                              = 32'd1; 

  assign smon_0_v[ 9 * 1 +: 1 ]                                  = smon_enabled_f ? cmd_start_sn_reorder_f : 1'b0; 
  assign smon_0_comp[ 9 * 32 +: 32 ]                             = {25'd0, sn_reorder_qid_f };
  assign smon_0_val[ 9 * 32 +: 32 ]                              = 32'd1; 

  assign smon_0_v[ 10 * 1 +: 1 ]                                 = smon_enabled_f ? ( rop_lsp_reordercmp_f ) : 1'b0;
  assign smon_0_comp[ 10 * 32 +: 32 ]                            = { 24'd0,rop_lsp_reordercmp_data_cq_f[7:0] };
  assign smon_0_val[ 10 * 32 +: 32 ]                             = 32'd1 ;
         
  assign smon_0_v[ 11 * 1 +: 1 ]                                 = smon_enabled_f ? ( rop_nalb_enq_f ) : 1'b0;
  assign smon_0_comp[ 11 * 32 +: 32 ]                            = { 29'd0, rop_nalb_enq_data_cmd_f[2:0]};
  assign smon_0_val[ 11 * 32 +: 32 ]                             = 32'd1 ;


  assign smon_0_v[ 12 * 1 +: 1 ]                                 = smon_enabled_f ? ( rop_dp_enq_f ) : 1'b0;
  assign smon_0_comp[ 12 * 32 +: 32 ]                            = { 29'd0,rop_dp_enq_data_cmd_f[2:0] }  ;
  assign smon_0_val[ 12 * 32 +: 32 ]                             = 32'd1 ;

  assign smon_0_v[ 13 * 1 +: 1 ]                                 = smon_enabled_f ? (rop_lsp_reordercmp_f & rop_lsp_reordercmp_data_user_f) : 1'b0;
  assign smon_0_comp[ 13 * 32 +: 32 ]                            = { 25'd0,rop_lsp_reordercmp_data_qid_f } ;
  assign smon_0_val[ 13 * 32 +: 32 ]                             = 32'd1 ;

  assign smon_0_v[ 14 * 1 +: 1 ]                                 = smon_enabled_f ? smon_reord_frag_cnt_f : 1'b0;
  assign smon_0_comp[ 14 * 32 +: 32 ]                            = { 25'd0,smon_reord_frag_cnt_qid_f } ;
  assign smon_0_val[ 14 * 32 +: 32 ]                             = 32'd1 ;

  assign smon_0_v[ 15 * 1 +: 1 ]                                 = smon_enabled_f ? smon_reord_cmp_cnt_f : 1'b0;
  assign smon_0_comp[ 15 * 32 +: 32 ]                            = { 25'd0,smon_reord_cmp_cnt_qid_f } ;
  assign smon_0_val[ 15 * 32 +: 32 ]                             = 32'd1 ;

assign rop_unit_pipeidle = cfg_unit_idle_f.pipe_idle;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin

     frag_integrity_cnt_dec_dp_f <= '0;
     frag_integrity_cnt_dec_nalb_f <= '0;
     frag_integrity_cnt_inc_f <= '0;

  end 
  else begin

     frag_integrity_cnt_dec_dp_f <= frag_integrity_cnt_dec_dp_nxt;
     frag_integrity_cnt_dec_nalb_f <= frag_integrity_cnt_dec_nalb_nxt;
     frag_integrity_cnt_inc_f <= frag_integrity_cnt_inc_nxt;

  end
end 

// integrity counter
// incremented when fragment is received
// decremented when REORDER_HCW is sent to dp or nalb
// The counter needs to concurrently handle increment by 1 and two decrementes by up to 16.

assign frag_integrity_cnt_dec_dp_nxt = (rop_dp_enq_v & rop_dp_enq_ready & (rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_LIST)) ? rop_dp_enq_data.frag_list_info.cnt : 5'd0;
assign frag_integrity_cnt_dec_nalb_nxt = (rop_nalb_enq_v & rop_nalb_enq_ready & (rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_LIST)) ? rop_nalb_enq_data.frag_list_info.cnt : 5'd0;
assign frag_integrity_cnt_inc_nxt = cmd_sys_enq_frag & chp_rop_hcw_db2_out_valid_req & chp_rop_hcw_db2_out_ready;

assign frag_integrity_cnt_nxt_tmp0 = frag_integrity_cnt_f        - {11'd0,frag_integrity_cnt_dec_dp_f};   // frag_integrity_cnt_nxt_tmp0[15] underflow
assign frag_integrity_cnt_nxt_tmp1 = frag_integrity_cnt_nxt_tmp0 - {11'd0,frag_integrity_cnt_dec_nalb_f}; // frag_integrity_cnt_nxt_tmp1[15] underflow
assign frag_integrity_cnt_nxt_tmp2 = frag_integrity_cnt_nxt_tmp1 + {15'd0,frag_integrity_cnt_inc_f};      // frag_integrity_cnt_nxt_tmp2[15] overflow
assign frag_integrity_cnt_nxt      = frag_integrity_cnt_nxt_tmp2;

// hazard detection
// Need to detect case where fragment is being held due to bp in p0_rop*{dp/ldb}_enq and SN associated with this enq is in flight to be re-ordered
// The compare of SN will be done on the output of the sn_ordered_fifo pop interface

assign sn_hazard_nxt.dp_sn_v = p0_rop_dp_enq_f.v & (p0_rop_dp_enq_f.data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_HCW);
assign sn_hazard_nxt.dp_sn = p0_rop_dp_enq_f.data.hist_list_info.sn_fid[HQM_ROP_NUM_SN_B2-1:0];
assign sn_hazard_nxt.nalb_sn_v = p0_rop_nalb_enq_f.v & (p0_rop_nalb_enq_f.data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_HCW);
assign sn_hazard_nxt.nalb_sn = p0_rop_nalb_enq_f.data.hist_list_info.sn_fid[HQM_ROP_NUM_SN_B2-1:0];

assign sn_hazard_detected = !sn_ordered_fifo_empty & ( (sn_hazard_f.dp_sn_v & ( sn_hazard_f.dp_sn == sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0] )) | 
                                                       (sn_hazard_f.nalb_sn_v & ( sn_hazard_f.nalb_sn == sn_ordered_fifo_pop_data[HQM_ROP_NUM_SN_B2-1:0] )));

//tieoff 
logic tieoff_nc ;
assign tieoff_nc = 
//reuse modules inserted by script cannot include _nc
  ( | lsp_reordercmp_tx_idle )
| ( | hqm_rop_target_cfg_smon_smon_interrupt )
| ( | p1_qed_dqed_enq_nxt )
| ( | p0_reord_st_rw_f )
| ( | p0_reord_st_addr_f )
| ( | p0_reord_st_data_f )
| ( | p1_reord_st_rw_f )
| ( | p1_reord_st_addr_f )
| ( | p1_reord_st_data_f )
| ( | p2_reord_st_rw_f )
| ( | p2_reord_st_addr_f )
| ( | p3_reord_st_hold_nc )
| ( | p3_reord_st_rw_f [1:0]  )
| ( | p3_reord_st_addr_f [10:0] )
| ( | p3_reord_st_data_f [22:0] )
| ( | p0_reord_lbhp_rw_f [1:0] )
| ( | p0_reord_lbhp_addr_f [10:0]  )
| ( | p0_reord_lbhp_data_f [14:0]  )
| ( | p1_reord_lbhp_rw_f [1:0] )
| ( | p1_reord_lbhp_addr_f [10:0]  )
| ( | p1_reord_lbhp_data_f [14:0]  )
| ( | p2_reord_lbhp_rw_f [1:0]  )
| ( | p2_reord_lbhp_addr_f [10:0]  )
| ( | p3_reord_lbhp_hold_nc  )
| ( | p3_reord_lbhp_rw_f [1:0] )
| ( | p3_reord_lbhp_addr_f [10:0]  )
| ( | p3_reord_lbhp_data_f [14:0]  )
| ( | p0_reord_lbtp_rw_f [1:0] )
| ( | p0_reord_lbtp_addr_f [10:0]  )
| ( | p0_reord_lbtp_data_f [14:0]  )
| ( | p2_reord_lbtp_rw_f [1:0] )
| ( | p2_reord_lbtp_addr_f [10:0]  )
| ( | p3_reord_lbtp_hold_nc )
| ( | p3_reord_lbtp_rw_f [1:0] )
| ( | p3_reord_lbtp_addr_f [10:0]  )
| ( | p3_reord_lbtp_data_f [14:0]  )
| ( | p1_reord_dirhp_rw_f [1:0] )
| ( | p1_reord_dirhp_addr_f [10:0] )
| ( | p1_reord_dirhp_data_f [14:0] )
| ( | p2_reord_dirhp_rw_f [1:0] )
| ( | p2_reord_dirhp_addr_f [10:0] )
| ( | p3_reord_dirhp_hold_nc )
| ( | p3_reord_dirhp_data_f [14:0] )
| ( | p1_reord_dirtp_rw_f [1:0] )
| ( | p1_reord_dirtp_addr_f [10:0] )
| ( | p1_reord_dirtp_data_f [14:0] )
| ( | p2_reord_dirtp_rw_f [1:0] )
| ( | p2_reord_dirtp_addr_f [10:0] )
| ( | p3_reord_dirtp_hold_nc )
| ( | p3_reord_dirtp_data_f [14:0] )
| ( | p0_reord_cnt_rw_f [1:0] )
| ( | p0_reord_cnt_addr_f [10:0] )
| ( | p0_reord_cnt_data_f [13:0] )
| ( | p1_reord_cnt_rw_f [1:0] )
| ( | p1_reord_cnt_addr_f [10:0] )
| ( | p1_reord_cnt_data_f [13:0] )
| ( | p2_reord_cnt_addr_f [10:0] )
| ( | p3_reord_cnt_hold_nc )
| ( | p3_reord_cnt_rw_f [1:0] )
| ( | p3_reord_cnt_addr_f [10:0] )
| ( | p3_reord_cnt_data_f [13:0] )
| ( | hqm_aw_sn_order_select_f )
| ( | hqm_aw_sn_order_select_sn_f )
| ( | func_lsp_reordercmp_fifo_mem_rdata[18] ) // bit 18 unused
;
endmodule // hqm_reorder_pipe_func
