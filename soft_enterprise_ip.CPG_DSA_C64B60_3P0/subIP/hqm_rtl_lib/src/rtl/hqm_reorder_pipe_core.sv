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
module hqm_reorder_pipe_core
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(

  input  logic hqm_gated_clk
, input  logic hqm_inp_gated_clk
, input  logic hqm_rst_prep_rop
, input  logic hqm_gated_rst_b_rop
, input  logic hqm_inp_gated_rst_b_rop

, input  logic hqm_gated_rst_b_start_rop
, input  logic hqm_gated_rst_b_active_rop
, output logic hqm_gated_rst_b_done_rop

, output logic rop_clk_idle
, input logic rop_clk_enable

, output logic                          rop_unit_idle
, output logic                          rop_unit_pipeidle
, output logic                          rop_reset_done
                                        
// CFG interface                        
, input  logic                          rop_cfg_req_up_read
, input  logic                          rop_cfg_req_up_write
, input  cfg_req_t                      rop_cfg_req_up
, input  logic                          rop_cfg_rsp_up_ack
, input  cfg_rsp_t                      rop_cfg_rsp_up
, output logic                          rop_cfg_req_down_read
, output logic                          rop_cfg_req_down_write
, output cfg_req_t                      rop_cfg_req_down
, output logic                          rop_cfg_rsp_down_ack
, output cfg_rsp_t                      rop_cfg_rsp_down
                                        
// interrupt interface                  
, input  logic                          rop_alarm_up_v
, output logic                          rop_alarm_up_ready
, input  aw_alarm_t                     rop_alarm_up_data
                                        
, output logic                          rop_alarm_down_v
, input  logic                          rop_alarm_down_ready
, output aw_alarm_t                     rop_alarm_down_data
                                        
                                        
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

// BEGIN HQM_MEMPORT_DECL hqm_reorder_pipe_core
    ,output logic                  rf_dir_rply_req_fifo_mem_re
    ,output logic                  rf_dir_rply_req_fifo_mem_rclk
    ,output logic                  rf_dir_rply_req_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_dir_rply_req_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_dir_rply_req_fifo_mem_waddr
    ,output logic                  rf_dir_rply_req_fifo_mem_we
    ,output logic                  rf_dir_rply_req_fifo_mem_wclk
    ,output logic                  rf_dir_rply_req_fifo_mem_wclk_rst_n
    ,output logic [(      60)-1:0] rf_dir_rply_req_fifo_mem_wdata
    ,input  logic [(      60)-1:0] rf_dir_rply_req_fifo_mem_rdata

    ,output logic                  rf_ldb_rply_req_fifo_mem_re
    ,output logic                  rf_ldb_rply_req_fifo_mem_rclk
    ,output logic                  rf_ldb_rply_req_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ldb_rply_req_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_ldb_rply_req_fifo_mem_waddr
    ,output logic                  rf_ldb_rply_req_fifo_mem_we
    ,output logic                  rf_ldb_rply_req_fifo_mem_wclk
    ,output logic                  rf_ldb_rply_req_fifo_mem_wclk_rst_n
    ,output logic [(      60)-1:0] rf_ldb_rply_req_fifo_mem_wdata
    ,input  logic [(      60)-1:0] rf_ldb_rply_req_fifo_mem_rdata

    ,output logic                  rf_lsp_reordercmp_fifo_mem_re
    ,output logic                  rf_lsp_reordercmp_fifo_mem_rclk
    ,output logic                  rf_lsp_reordercmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_lsp_reordercmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_lsp_reordercmp_fifo_mem_waddr
    ,output logic                  rf_lsp_reordercmp_fifo_mem_we
    ,output logic                  rf_lsp_reordercmp_fifo_mem_wclk
    ,output logic                  rf_lsp_reordercmp_fifo_mem_wclk_rst_n
    ,output logic [(      19)-1:0] rf_lsp_reordercmp_fifo_mem_wdata
    ,input  logic [(      19)-1:0] rf_lsp_reordercmp_fifo_mem_rdata

    ,output logic                  rf_reord_cnt_mem_re
    ,output logic                  rf_reord_cnt_mem_rclk
    ,output logic                  rf_reord_cnt_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_cnt_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_cnt_mem_waddr
    ,output logic                  rf_reord_cnt_mem_we
    ,output logic                  rf_reord_cnt_mem_wclk
    ,output logic                  rf_reord_cnt_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_reord_cnt_mem_wdata
    ,input  logic [(      16)-1:0] rf_reord_cnt_mem_rdata

    ,output logic                  rf_reord_dirhp_mem_re
    ,output logic                  rf_reord_dirhp_mem_rclk
    ,output logic                  rf_reord_dirhp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_dirhp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_dirhp_mem_waddr
    ,output logic                  rf_reord_dirhp_mem_we
    ,output logic                  rf_reord_dirhp_mem_wclk
    ,output logic                  rf_reord_dirhp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_dirhp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_dirhp_mem_rdata

    ,output logic                  rf_reord_dirtp_mem_re
    ,output logic                  rf_reord_dirtp_mem_rclk
    ,output logic                  rf_reord_dirtp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_dirtp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_dirtp_mem_waddr
    ,output logic                  rf_reord_dirtp_mem_we
    ,output logic                  rf_reord_dirtp_mem_wclk
    ,output logic                  rf_reord_dirtp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_dirtp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_dirtp_mem_rdata

    ,output logic                  rf_reord_lbhp_mem_re
    ,output logic                  rf_reord_lbhp_mem_rclk
    ,output logic                  rf_reord_lbhp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_lbhp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_lbhp_mem_waddr
    ,output logic                  rf_reord_lbhp_mem_we
    ,output logic                  rf_reord_lbhp_mem_wclk
    ,output logic                  rf_reord_lbhp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_lbhp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_lbhp_mem_rdata

    ,output logic                  rf_reord_lbtp_mem_re
    ,output logic                  rf_reord_lbtp_mem_rclk
    ,output logic                  rf_reord_lbtp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_lbtp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_lbtp_mem_waddr
    ,output logic                  rf_reord_lbtp_mem_we
    ,output logic                  rf_reord_lbtp_mem_wclk
    ,output logic                  rf_reord_lbtp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_lbtp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_lbtp_mem_rdata

    ,output logic                  rf_reord_st_mem_re
    ,output logic                  rf_reord_st_mem_rclk
    ,output logic                  rf_reord_st_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_st_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_st_mem_waddr
    ,output logic                  rf_reord_st_mem_we
    ,output logic                  rf_reord_st_mem_wclk
    ,output logic                  rf_reord_st_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_reord_st_mem_wdata
    ,input  logic [(      25)-1:0] rf_reord_st_mem_rdata

    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_re
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_rclk
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_chp_rop_hcw_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_rop_chp_rop_hcw_fifo_mem_waddr
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_we
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_wclk
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     204)-1:0] rf_rop_chp_rop_hcw_fifo_mem_wdata
    ,input  logic [(     204)-1:0] rf_rop_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_sn0_order_shft_mem_re
    ,output logic                  rf_sn0_order_shft_mem_rclk
    ,output logic                  rf_sn0_order_shft_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_sn0_order_shft_mem_raddr
    ,output logic [(       4)-1:0] rf_sn0_order_shft_mem_waddr
    ,output logic                  rf_sn0_order_shft_mem_we
    ,output logic                  rf_sn0_order_shft_mem_wclk
    ,output logic                  rf_sn0_order_shft_mem_wclk_rst_n
    ,output logic [(      12)-1:0] rf_sn0_order_shft_mem_wdata
    ,input  logic [(      12)-1:0] rf_sn0_order_shft_mem_rdata

    ,output logic                  rf_sn1_order_shft_mem_re
    ,output logic                  rf_sn1_order_shft_mem_rclk
    ,output logic                  rf_sn1_order_shft_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_sn1_order_shft_mem_raddr
    ,output logic [(       4)-1:0] rf_sn1_order_shft_mem_waddr
    ,output logic                  rf_sn1_order_shft_mem_we
    ,output logic                  rf_sn1_order_shft_mem_wclk
    ,output logic                  rf_sn1_order_shft_mem_wclk_rst_n
    ,output logic [(      12)-1:0] rf_sn1_order_shft_mem_wdata
    ,input  logic [(      12)-1:0] rf_sn1_order_shft_mem_rdata

    ,output logic                  rf_sn_complete_fifo_mem_re
    ,output logic                  rf_sn_complete_fifo_mem_rclk
    ,output logic                  rf_sn_complete_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_sn_complete_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_sn_complete_fifo_mem_waddr
    ,output logic                  rf_sn_complete_fifo_mem_we
    ,output logic                  rf_sn_complete_fifo_mem_wclk
    ,output logic                  rf_sn_complete_fifo_mem_wclk_rst_n
    ,output logic [(      21)-1:0] rf_sn_complete_fifo_mem_wdata
    ,input  logic [(      21)-1:0] rf_sn_complete_fifo_mem_rdata

    ,output logic                  rf_sn_ordered_fifo_mem_re
    ,output logic                  rf_sn_ordered_fifo_mem_rclk
    ,output logic                  rf_sn_ordered_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_sn_ordered_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_sn_ordered_fifo_mem_waddr
    ,output logic                  rf_sn_ordered_fifo_mem_we
    ,output logic                  rf_sn_ordered_fifo_mem_wclk
    ,output logic                  rf_sn_ordered_fifo_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_sn_ordered_fifo_mem_wdata
    ,input  logic [(      13)-1:0] rf_sn_ordered_fifo_mem_rdata

// END HQM_MEMPORT_DECL hqm_reorder_pipe_core
);

localparam HQM_ROP_MULTI_FRAG_ENABLE = 1;

localparam HQM_ROP_NUM_SN = 2048;
localparam HQM_ROP_NUM_SN_B2 = (AW_logb2(HQM_ROP_NUM_SN-1)+1);
// start declarations
logic                  disable_smon ;
assign disable_smon = 1'b0 ;

logic hqm_gated_rst_n_done;
logic pf_reset_active;
logic [ ( HQM_ROP_ALARM_NUM_INF ) -1 : 0]               int_inf_v;
aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_INF ) -1 : 0]      int_inf_data;
logic [ ( HQM_ROP_ALARM_NUM_COR) -1 : 0]                int_cor_v;
aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_COR) -1 : 0]       int_cor_data;
logic [ ( HQM_ROP_ALARM_NUM_UNC ) -1 : 0]               int_unc_v;
aw_alarm_syn_t [ ( HQM_ROP_ALARM_NUM_UNC ) -1 : 0]      int_unc_data;
logic int_idle;
logic [31:0] int_serializer_status;
logic [ ( 32 ) - 1 : 0 ] cfgsc_residue_gen_a ;
logic [ ( 2 ) - 1 : 0 ] cfgsc_residue_gen_r ;
logic hqm_gated_rst_n_start;
cfg_unit_timeout_t               cfg_unit_timeout;

logic [31:0] hqm_rop_target_cfg_syndrome_00_syndrome_data_nc ;
logic [31:0] hqm_rop_target_cfg_syndrome_01_syndrome_data_nc ;


//---------------------------------------------------------------------------------------------------------
// common core - Reset
logic rst_prep;
logic hqm_gated_rst_n;
logic hqm_inp_gated_rst_n;
assign rst_prep             = hqm_rst_prep_rop;
assign hqm_gated_rst_n      = hqm_gated_rst_b_rop;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b_rop;

logic hqm_gated_rst_n_active;
assign hqm_gated_rst_n_start    = hqm_gated_rst_b_start_rop;
assign hqm_gated_rst_n_active   = hqm_gated_rst_b_active_rop;
assign hqm_gated_rst_b_done_rop = hqm_gated_rst_n_done;

//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers 
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_nxt ; //I HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_f ; //O HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0
logic hqm_rop_target_cfg_control_general_0_reg_v ; //I HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_diagnostic_aw_status_status ; //I HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt ; //I HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f ; //O HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_frag_integrity_count_status ; //I HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_nxt ; //I HQM_ROP_TARGET_CFG_GRP_SN_MODE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_f ; //O HQM_ROP_TARGET_CFG_GRP_SN_MODE
logic hqm_rop_target_cfg_grp_sn_mode_reg_v ; //I HQM_ROP_TARGET_CFG_GRP_SN_MODE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_f ; //O HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_rop_target_cfg_hw_agitate_control_reg_v ; //I HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_f ; //O HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_rop_target_cfg_hw_agitate_select_reg_v ; //I HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_interface_status_status ; //I HQM_ROP_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_nxt ; //I HQM_ROP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_f ; //O HQM_ROP_TARGET_CFG_PATCH_CONTROL
logic hqm_rop_target_cfg_patch_control_reg_v ; //I HQM_ROP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp0_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp1_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_dp_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED
logic [ ( 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0
logic [ ( 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp0_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp1_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_dp_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status ; //I HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_nxt ; //I HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_f ; //O HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL
logic hqm_rop_target_cfg_rop_csr_control_reg_v ; //I HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_serializer_status_status ; //I HQM_ROP_TARGET_CFG_SERIALIZER_STATUS
logic hqm_rop_target_cfg_smon_disable_smon ; //I HQM_ROP_TARGET_CFG_SMON
logic [ 16 - 1 : 0 ] hqm_rop_target_cfg_smon_smon_v ; //I HQM_ROP_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_comp ; //I HQM_ROP_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_val ; //I HQM_ROP_TARGET_CFG_SMON
logic hqm_rop_target_cfg_smon_smon_enabled ; //O HQM_ROP_TARGET_CFG_SMON
logic hqm_rop_target_cfg_smon_smon_interrupt ; //O HQM_ROP_TARGET_CFG_SMON
logic hqm_rop_target_cfg_syndrome_00_capture_v ; //I HQM_ROP_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_00_capture_data ; //I HQM_ROP_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_syndrome_00_syndrome_data ; //I HQM_ROP_TARGET_CFG_SYNDROME_00
logic hqm_rop_target_cfg_syndrome_01_capture_v ; //I HQM_ROP_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_01_capture_data ; //I HQM_ROP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_syndrome_01_syndrome_data ; //I HQM_ROP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_nxt ; //I HQM_ROP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_f ; //O HQM_ROP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_nxt ; //I HQM_ROP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_f ; //O HQM_ROP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_version_status ; //I HQM_ROP_TARGET_CFG_UNIT_VERSION
hqm_reorder_pipe_register_pfcsr i_hqm_reorder_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_rop_target_cfg_control_general_0_reg_nxt ( hqm_rop_target_cfg_control_general_0_reg_nxt )
, .hqm_rop_target_cfg_control_general_0_reg_f ( hqm_rop_target_cfg_control_general_0_reg_f )
, .hqm_rop_target_cfg_control_general_0_reg_v (  hqm_rop_target_cfg_control_general_0_reg_v )
, .hqm_rop_target_cfg_diagnostic_aw_status_status ( hqm_rop_target_cfg_diagnostic_aw_status_status )
, .hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f )
, .hqm_rop_target_cfg_frag_integrity_count_status ( hqm_rop_target_cfg_frag_integrity_count_status )
, .hqm_rop_target_cfg_grp_sn_mode_reg_nxt ( hqm_rop_target_cfg_grp_sn_mode_reg_nxt )
, .hqm_rop_target_cfg_grp_sn_mode_reg_f ( hqm_rop_target_cfg_grp_sn_mode_reg_f )
, .hqm_rop_target_cfg_grp_sn_mode_reg_v (  hqm_rop_target_cfg_grp_sn_mode_reg_v )
, .hqm_rop_target_cfg_hw_agitate_control_reg_nxt ( hqm_rop_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_rop_target_cfg_hw_agitate_control_reg_f ( hqm_rop_target_cfg_hw_agitate_control_reg_f )
, .hqm_rop_target_cfg_hw_agitate_control_reg_v (  hqm_rop_target_cfg_hw_agitate_control_reg_v )
, .hqm_rop_target_cfg_hw_agitate_select_reg_nxt ( hqm_rop_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_rop_target_cfg_hw_agitate_select_reg_f ( hqm_rop_target_cfg_hw_agitate_select_reg_f )
, .hqm_rop_target_cfg_hw_agitate_select_reg_v (  hqm_rop_target_cfg_hw_agitate_select_reg_v )
, .hqm_rop_target_cfg_interface_status_status ( hqm_rop_target_cfg_interface_status_status )
, .hqm_rop_target_cfg_patch_control_reg_nxt ( hqm_rop_target_cfg_patch_control_reg_nxt )
, .hqm_rop_target_cfg_patch_control_reg_f ( hqm_rop_target_cfg_patch_control_reg_f )
, .hqm_rop_target_cfg_patch_control_reg_v (  hqm_rop_target_cfg_patch_control_reg_v )
, .hqm_rop_target_cfg_pipe_health_hold_grp0_status ( hqm_rop_target_cfg_pipe_health_hold_grp0_status )
, .hqm_rop_target_cfg_pipe_health_hold_grp1_status ( hqm_rop_target_cfg_pipe_health_hold_grp1_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_dp_status ( hqm_rop_target_cfg_pipe_health_hold_rop_dp_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status ( hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status ( hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status ( hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status )
, .hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status )
, .hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status )
, .hqm_rop_target_cfg_pipe_health_valid_grp0_status ( hqm_rop_target_cfg_pipe_health_valid_grp0_status )
, .hqm_rop_target_cfg_pipe_health_valid_grp1_status ( hqm_rop_target_cfg_pipe_health_valid_grp1_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_dp_status ( hqm_rop_target_cfg_pipe_health_valid_rop_dp_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status ( hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status ( hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status ( hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status )
, .hqm_rop_target_cfg_rop_csr_control_reg_nxt ( hqm_rop_target_cfg_rop_csr_control_reg_nxt )
, .hqm_rop_target_cfg_rop_csr_control_reg_f ( hqm_rop_target_cfg_rop_csr_control_reg_f )
, .hqm_rop_target_cfg_rop_csr_control_reg_v (  hqm_rop_target_cfg_rop_csr_control_reg_v )
, .hqm_rop_target_cfg_serializer_status_status ( hqm_rop_target_cfg_serializer_status_status )
, .hqm_rop_target_cfg_smon_disable_smon ( hqm_rop_target_cfg_smon_disable_smon )
, .hqm_rop_target_cfg_smon_smon_v ( hqm_rop_target_cfg_smon_smon_v )
, .hqm_rop_target_cfg_smon_smon_comp ( hqm_rop_target_cfg_smon_smon_comp )
, .hqm_rop_target_cfg_smon_smon_val ( hqm_rop_target_cfg_smon_smon_val )
, .hqm_rop_target_cfg_smon_smon_enabled ( hqm_rop_target_cfg_smon_smon_enabled )
, .hqm_rop_target_cfg_smon_smon_interrupt ( hqm_rop_target_cfg_smon_smon_interrupt )
, .hqm_rop_target_cfg_syndrome_00_capture_v ( hqm_rop_target_cfg_syndrome_00_capture_v )
, .hqm_rop_target_cfg_syndrome_00_capture_data ( hqm_rop_target_cfg_syndrome_00_capture_data )
, .hqm_rop_target_cfg_syndrome_00_syndrome_data ( hqm_rop_target_cfg_syndrome_00_syndrome_data )
, .hqm_rop_target_cfg_syndrome_01_capture_v ( hqm_rop_target_cfg_syndrome_01_capture_v )
, .hqm_rop_target_cfg_syndrome_01_capture_data ( hqm_rop_target_cfg_syndrome_01_capture_data )
, .hqm_rop_target_cfg_syndrome_01_syndrome_data ( hqm_rop_target_cfg_syndrome_01_syndrome_data )
, .hqm_rop_target_cfg_unit_idle_reg_nxt ( hqm_rop_target_cfg_unit_idle_reg_nxt )
, .hqm_rop_target_cfg_unit_idle_reg_f ( hqm_rop_target_cfg_unit_idle_reg_f )
, .hqm_rop_target_cfg_unit_timeout_reg_nxt ( hqm_rop_target_cfg_unit_timeout_reg_nxt )
, .hqm_rop_target_cfg_unit_timeout_reg_f ( hqm_rop_target_cfg_unit_timeout_reg_f )
, .hqm_rop_target_cfg_unit_version_status ( hqm_rop_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS
// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 8;
localparam CFG_ACCESSIBLE_RAM_REORD_CNT_MEM = 0; // HQM_ROP_TARGET_CFG_REORDER_STATE_CNT
localparam CFG_ACCESSIBLE_RAM_REORD_DIRHP_MEM = 1; // HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP
localparam CFG_ACCESSIBLE_RAM_REORD_DIRTP_MEM = 2; // HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP
localparam CFG_ACCESSIBLE_RAM_REORD_LBHP_MEM = 3; // HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP
localparam CFG_ACCESSIBLE_RAM_REORD_LBTP_MEM = 4; // HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP
localparam CFG_ACCESSIBLE_RAM_REORD_ST_MEM = 5; // HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ
localparam CFG_ACCESSIBLE_RAM_SN0_ORDER_SHFT_MEM = 6; // HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT
localparam CFG_ACCESSIBLE_RAM_SN1_ORDER_SHFT_MEM = 7; // HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT
logic [(  8 *  1)-1:0] cfg_mem_re;
logic [(  8 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [(  8 * 32)-1:0] cfg_mem_rdata;
logic [(  8 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_reorder_pipe_rfw_top_ipar_error;

logic                  func_dir_rply_req_fifo_mem_re; //I
logic [(       3)-1:0] func_dir_rply_req_fifo_mem_raddr; //I
logic [(       3)-1:0] func_dir_rply_req_fifo_mem_waddr; //I
logic                  func_dir_rply_req_fifo_mem_we;    //I
logic [(      60)-1:0] func_dir_rply_req_fifo_mem_wdata; //I
logic [(      60)-1:0] func_dir_rply_req_fifo_mem_rdata;

logic                pf_dir_rply_req_fifo_mem_re;    //I
logic [(       3)-1:0] pf_dir_rply_req_fifo_mem_raddr; //I
logic [(       3)-1:0] pf_dir_rply_req_fifo_mem_waddr; //I
logic                  pf_dir_rply_req_fifo_mem_we;    //I
logic [(      60)-1:0] pf_dir_rply_req_fifo_mem_wdata; //I
logic [(      60)-1:0] pf_dir_rply_req_fifo_mem_rdata;

logic                  rf_dir_rply_req_fifo_mem_error;

logic                  func_ldb_rply_req_fifo_mem_re; //I
logic [(       3)-1:0] func_ldb_rply_req_fifo_mem_raddr; //I
logic [(       3)-1:0] func_ldb_rply_req_fifo_mem_waddr; //I
logic                  func_ldb_rply_req_fifo_mem_we;    //I
logic [(      60)-1:0] func_ldb_rply_req_fifo_mem_wdata; //I
logic [(      60)-1:0] func_ldb_rply_req_fifo_mem_rdata;

logic                pf_ldb_rply_req_fifo_mem_re;    //I
logic [(       3)-1:0] pf_ldb_rply_req_fifo_mem_raddr; //I
logic [(       3)-1:0] pf_ldb_rply_req_fifo_mem_waddr; //I
logic                  pf_ldb_rply_req_fifo_mem_we;    //I
logic [(      60)-1:0] pf_ldb_rply_req_fifo_mem_wdata; //I
logic [(      60)-1:0] pf_ldb_rply_req_fifo_mem_rdata;

logic                  rf_ldb_rply_req_fifo_mem_error;

logic                  func_lsp_reordercmp_fifo_mem_re; //I
logic [(       3)-1:0] func_lsp_reordercmp_fifo_mem_raddr; //I
logic [(       3)-1:0] func_lsp_reordercmp_fifo_mem_waddr; //I
logic                  func_lsp_reordercmp_fifo_mem_we;    //I
logic [(      19)-1:0] func_lsp_reordercmp_fifo_mem_wdata; //I
logic [(      19)-1:0] func_lsp_reordercmp_fifo_mem_rdata;

logic                pf_lsp_reordercmp_fifo_mem_re;    //I
logic [(       3)-1:0] pf_lsp_reordercmp_fifo_mem_raddr; //I
logic [(       3)-1:0] pf_lsp_reordercmp_fifo_mem_waddr; //I
logic                  pf_lsp_reordercmp_fifo_mem_we;    //I
logic [(      19)-1:0] pf_lsp_reordercmp_fifo_mem_wdata; //I
logic [(      19)-1:0] pf_lsp_reordercmp_fifo_mem_rdata;

logic                  rf_lsp_reordercmp_fifo_mem_error;

logic                  func_reord_cnt_mem_re; //I
logic [(      11)-1:0] func_reord_cnt_mem_raddr; //I
logic [(      11)-1:0] func_reord_cnt_mem_waddr; //I
logic                  func_reord_cnt_mem_we;    //I
logic [(      14)-1:0] func_reord_cnt_mem_wdata; //I
logic [(      14)-1:0] func_reord_cnt_mem_rdata;

logic                pf_reord_cnt_mem_re;    //I
logic [(      11)-1:0] pf_reord_cnt_mem_raddr; //I
logic [(      11)-1:0] pf_reord_cnt_mem_waddr; //I
logic                  pf_reord_cnt_mem_we;    //I
logic [(      14)-1:0] pf_reord_cnt_mem_wdata; //I
logic [(      14)-1:0] pf_reord_cnt_mem_rdata;

logic                  rf_reord_cnt_mem_error;

logic                  func_reord_dirhp_mem_re; //I
logic [(      11)-1:0] func_reord_dirhp_mem_raddr; //I
logic [(      11)-1:0] func_reord_dirhp_mem_waddr; //I
logic                  func_reord_dirhp_mem_we;    //I
logic [(      15)-1:0] func_reord_dirhp_mem_wdata; //I
logic [(      15)-1:0] func_reord_dirhp_mem_rdata;

logic                pf_reord_dirhp_mem_re;    //I
logic [(      11)-1:0] pf_reord_dirhp_mem_raddr; //I
logic [(      11)-1:0] pf_reord_dirhp_mem_waddr; //I
logic                  pf_reord_dirhp_mem_we;    //I
logic [(      15)-1:0] pf_reord_dirhp_mem_wdata; //I
logic [(      15)-1:0] pf_reord_dirhp_mem_rdata;

logic                  rf_reord_dirhp_mem_error;

logic                  func_reord_dirtp_mem_re; //I
logic [(      11)-1:0] func_reord_dirtp_mem_raddr; //I
logic [(      11)-1:0] func_reord_dirtp_mem_waddr; //I
logic                  func_reord_dirtp_mem_we;    //I
logic [(      15)-1:0] func_reord_dirtp_mem_wdata; //I
logic [(      15)-1:0] func_reord_dirtp_mem_rdata;

logic                pf_reord_dirtp_mem_re;    //I
logic [(      11)-1:0] pf_reord_dirtp_mem_raddr; //I
logic [(      11)-1:0] pf_reord_dirtp_mem_waddr; //I
logic                  pf_reord_dirtp_mem_we;    //I
logic [(      15)-1:0] pf_reord_dirtp_mem_wdata; //I
logic [(      15)-1:0] pf_reord_dirtp_mem_rdata;

logic                  rf_reord_dirtp_mem_error;

logic                  func_reord_lbhp_mem_re; //I
logic [(      11)-1:0] func_reord_lbhp_mem_raddr; //I
logic [(      11)-1:0] func_reord_lbhp_mem_waddr; //I
logic                  func_reord_lbhp_mem_we;    //I
logic [(      15)-1:0] func_reord_lbhp_mem_wdata; //I
logic [(      15)-1:0] func_reord_lbhp_mem_rdata;

logic                pf_reord_lbhp_mem_re;    //I
logic [(      11)-1:0] pf_reord_lbhp_mem_raddr; //I
logic [(      11)-1:0] pf_reord_lbhp_mem_waddr; //I
logic                  pf_reord_lbhp_mem_we;    //I
logic [(      15)-1:0] pf_reord_lbhp_mem_wdata; //I
logic [(      15)-1:0] pf_reord_lbhp_mem_rdata;

logic                  rf_reord_lbhp_mem_error;

logic                  func_reord_lbtp_mem_re; //I
logic [(      11)-1:0] func_reord_lbtp_mem_raddr; //I
logic [(      11)-1:0] func_reord_lbtp_mem_waddr; //I
logic                  func_reord_lbtp_mem_we;    //I
logic [(      15)-1:0] func_reord_lbtp_mem_wdata; //I
logic [(      15)-1:0] func_reord_lbtp_mem_rdata;

logic                pf_reord_lbtp_mem_re;    //I
logic [(      11)-1:0] pf_reord_lbtp_mem_raddr; //I
logic [(      11)-1:0] pf_reord_lbtp_mem_waddr; //I
logic                  pf_reord_lbtp_mem_we;    //I
logic [(      15)-1:0] pf_reord_lbtp_mem_wdata; //I
logic [(      15)-1:0] pf_reord_lbtp_mem_rdata;

logic                  rf_reord_lbtp_mem_error;

logic                  func_reord_st_mem_re; //I
logic [(      11)-1:0] func_reord_st_mem_raddr; //I
logic [(      11)-1:0] func_reord_st_mem_waddr; //I
logic                  func_reord_st_mem_we;    //I
logic [(      23)-1:0] func_reord_st_mem_wdata; //I
logic [(      23)-1:0] func_reord_st_mem_rdata;

logic                pf_reord_st_mem_re;    //I
logic [(      11)-1:0] pf_reord_st_mem_raddr; //I
logic [(      11)-1:0] pf_reord_st_mem_waddr; //I
logic                  pf_reord_st_mem_we;    //I
logic [(      23)-1:0] pf_reord_st_mem_wdata; //I
logic [(      23)-1:0] pf_reord_st_mem_rdata;

logic                  rf_reord_st_mem_error;

logic                  func_rop_chp_rop_hcw_fifo_mem_re; //I
logic [(       2)-1:0] func_rop_chp_rop_hcw_fifo_mem_raddr; //I
logic [(       2)-1:0] func_rop_chp_rop_hcw_fifo_mem_waddr; //I
logic                  func_rop_chp_rop_hcw_fifo_mem_we;    //I
logic [(     204)-1:0] func_rop_chp_rop_hcw_fifo_mem_wdata; //I
logic [(     204)-1:0] func_rop_chp_rop_hcw_fifo_mem_rdata;

logic                pf_rop_chp_rop_hcw_fifo_mem_re;    //I
logic [(       2)-1:0] pf_rop_chp_rop_hcw_fifo_mem_raddr; //I
logic [(       2)-1:0] pf_rop_chp_rop_hcw_fifo_mem_waddr; //I
logic                  pf_rop_chp_rop_hcw_fifo_mem_we;    //I
logic [(     204)-1:0] pf_rop_chp_rop_hcw_fifo_mem_wdata; //I
logic [(     204)-1:0] pf_rop_chp_rop_hcw_fifo_mem_rdata;

logic                  rf_rop_chp_rop_hcw_fifo_mem_error;

logic                  func_sn0_order_shft_mem_re; //I
logic [(       4)-1:0] func_sn0_order_shft_mem_raddr; //I
logic [(       4)-1:0] func_sn0_order_shft_mem_waddr; //I
logic                  func_sn0_order_shft_mem_we;    //I
logic [(      12)-1:0] func_sn0_order_shft_mem_wdata; //I
logic [(      12)-1:0] func_sn0_order_shft_mem_rdata;

logic                pf_sn0_order_shft_mem_re;    //I
logic [(       4)-1:0] pf_sn0_order_shft_mem_raddr; //I
logic [(       4)-1:0] pf_sn0_order_shft_mem_waddr; //I
logic                  pf_sn0_order_shft_mem_we;    //I
logic [(      12)-1:0] pf_sn0_order_shft_mem_wdata; //I
logic [(      12)-1:0] pf_sn0_order_shft_mem_rdata;

logic                  rf_sn0_order_shft_mem_error;

logic                  func_sn1_order_shft_mem_re; //I
logic [(       4)-1:0] func_sn1_order_shft_mem_raddr; //I
logic [(       4)-1:0] func_sn1_order_shft_mem_waddr; //I
logic                  func_sn1_order_shft_mem_we;    //I
logic [(      12)-1:0] func_sn1_order_shft_mem_wdata; //I
logic [(      12)-1:0] func_sn1_order_shft_mem_rdata;

logic                pf_sn1_order_shft_mem_re;    //I
logic [(       4)-1:0] pf_sn1_order_shft_mem_raddr; //I
logic [(       4)-1:0] pf_sn1_order_shft_mem_waddr; //I
logic                  pf_sn1_order_shft_mem_we;    //I
logic [(      12)-1:0] pf_sn1_order_shft_mem_wdata; //I
logic [(      12)-1:0] pf_sn1_order_shft_mem_rdata;

logic                  rf_sn1_order_shft_mem_error;

logic                  func_sn_complete_fifo_mem_re; //I
logic [(       2)-1:0] func_sn_complete_fifo_mem_raddr; //I
logic [(       2)-1:0] func_sn_complete_fifo_mem_waddr; //I
logic                  func_sn_complete_fifo_mem_we;    //I
logic [(      21)-1:0] func_sn_complete_fifo_mem_wdata; //I
logic [(      21)-1:0] func_sn_complete_fifo_mem_rdata;

logic                pf_sn_complete_fifo_mem_re;    //I
logic [(       2)-1:0] pf_sn_complete_fifo_mem_raddr; //I
logic [(       2)-1:0] pf_sn_complete_fifo_mem_waddr; //I
logic                  pf_sn_complete_fifo_mem_we;    //I
logic [(      21)-1:0] pf_sn_complete_fifo_mem_wdata; //I
logic [(      21)-1:0] pf_sn_complete_fifo_mem_rdata;

logic                  rf_sn_complete_fifo_mem_error;

logic                  func_sn_ordered_fifo_mem_re; //I
logic [(       5)-1:0] func_sn_ordered_fifo_mem_raddr; //I
logic [(       5)-1:0] func_sn_ordered_fifo_mem_waddr; //I
logic                  func_sn_ordered_fifo_mem_we;    //I
logic [(      13)-1:0] func_sn_ordered_fifo_mem_wdata; //I
logic [(      13)-1:0] func_sn_ordered_fifo_mem_rdata;

logic                pf_sn_ordered_fifo_mem_re;    //I
logic [(       5)-1:0] pf_sn_ordered_fifo_mem_raddr; //I
logic [(       5)-1:0] pf_sn_ordered_fifo_mem_waddr; //I
logic                  pf_sn_ordered_fifo_mem_we;    //I
logic [(      13)-1:0] pf_sn_ordered_fifo_mem_wdata; //I
logic [(      13)-1:0] pf_sn_ordered_fifo_mem_rdata;

logic                  rf_sn_ordered_fifo_mem_error;

hqm_reorder_pipe_ram_access i_hqm_reorder_pipe_ram_access (
  .hqm_gated_clk (hqm_gated_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
,.cfg_mem_re          (cfg_mem_re)
,.cfg_mem_we          (cfg_mem_we)
,.cfg_mem_addr        (cfg_mem_addr)
,.cfg_mem_minbit      (cfg_mem_minbit)
,.cfg_mem_maxbit      (cfg_mem_maxbit)
,.cfg_mem_wdata       (cfg_mem_wdata)
,.cfg_mem_rdata       (cfg_mem_rdata)
,.cfg_mem_ack         (cfg_mem_ack)
,.cfg_mem_cc_v        (cfg_mem_cc_v)
,.cfg_mem_cc_value    (cfg_mem_cc_value)
,.cfg_mem_cc_width    (cfg_mem_cc_width)
,.cfg_mem_cc_position (cfg_mem_cc_position)

,.hqm_reorder_pipe_rfw_top_ipar_error (hqm_reorder_pipe_rfw_top_ipar_error)

,.func_dir_rply_req_fifo_mem_re    (func_dir_rply_req_fifo_mem_re)
,.func_dir_rply_req_fifo_mem_raddr (func_dir_rply_req_fifo_mem_raddr)
,.func_dir_rply_req_fifo_mem_waddr (func_dir_rply_req_fifo_mem_waddr)
,.func_dir_rply_req_fifo_mem_we    (func_dir_rply_req_fifo_mem_we)
,.func_dir_rply_req_fifo_mem_wdata (func_dir_rply_req_fifo_mem_wdata)
,.func_dir_rply_req_fifo_mem_rdata (func_dir_rply_req_fifo_mem_rdata)

,.pf_dir_rply_req_fifo_mem_re      (pf_dir_rply_req_fifo_mem_re)
,.pf_dir_rply_req_fifo_mem_raddr (pf_dir_rply_req_fifo_mem_raddr)
,.pf_dir_rply_req_fifo_mem_waddr (pf_dir_rply_req_fifo_mem_waddr)
,.pf_dir_rply_req_fifo_mem_we    (pf_dir_rply_req_fifo_mem_we)
,.pf_dir_rply_req_fifo_mem_wdata (pf_dir_rply_req_fifo_mem_wdata)
,.pf_dir_rply_req_fifo_mem_rdata (pf_dir_rply_req_fifo_mem_rdata)

,.rf_dir_rply_req_fifo_mem_rclk (rf_dir_rply_req_fifo_mem_rclk)
,.rf_dir_rply_req_fifo_mem_rclk_rst_n (rf_dir_rply_req_fifo_mem_rclk_rst_n)
,.rf_dir_rply_req_fifo_mem_re    (rf_dir_rply_req_fifo_mem_re)
,.rf_dir_rply_req_fifo_mem_raddr (rf_dir_rply_req_fifo_mem_raddr)
,.rf_dir_rply_req_fifo_mem_waddr (rf_dir_rply_req_fifo_mem_waddr)
,.rf_dir_rply_req_fifo_mem_wclk (rf_dir_rply_req_fifo_mem_wclk)
,.rf_dir_rply_req_fifo_mem_wclk_rst_n (rf_dir_rply_req_fifo_mem_wclk_rst_n)
,.rf_dir_rply_req_fifo_mem_we    (rf_dir_rply_req_fifo_mem_we)
,.rf_dir_rply_req_fifo_mem_wdata (rf_dir_rply_req_fifo_mem_wdata)
,.rf_dir_rply_req_fifo_mem_rdata (rf_dir_rply_req_fifo_mem_rdata)

,.rf_dir_rply_req_fifo_mem_error (rf_dir_rply_req_fifo_mem_error)

,.func_ldb_rply_req_fifo_mem_re    (func_ldb_rply_req_fifo_mem_re)
,.func_ldb_rply_req_fifo_mem_raddr (func_ldb_rply_req_fifo_mem_raddr)
,.func_ldb_rply_req_fifo_mem_waddr (func_ldb_rply_req_fifo_mem_waddr)
,.func_ldb_rply_req_fifo_mem_we    (func_ldb_rply_req_fifo_mem_we)
,.func_ldb_rply_req_fifo_mem_wdata (func_ldb_rply_req_fifo_mem_wdata)
,.func_ldb_rply_req_fifo_mem_rdata (func_ldb_rply_req_fifo_mem_rdata)

,.pf_ldb_rply_req_fifo_mem_re      (pf_ldb_rply_req_fifo_mem_re)
,.pf_ldb_rply_req_fifo_mem_raddr (pf_ldb_rply_req_fifo_mem_raddr)
,.pf_ldb_rply_req_fifo_mem_waddr (pf_ldb_rply_req_fifo_mem_waddr)
,.pf_ldb_rply_req_fifo_mem_we    (pf_ldb_rply_req_fifo_mem_we)
,.pf_ldb_rply_req_fifo_mem_wdata (pf_ldb_rply_req_fifo_mem_wdata)
,.pf_ldb_rply_req_fifo_mem_rdata (pf_ldb_rply_req_fifo_mem_rdata)

,.rf_ldb_rply_req_fifo_mem_rclk (rf_ldb_rply_req_fifo_mem_rclk)
,.rf_ldb_rply_req_fifo_mem_rclk_rst_n (rf_ldb_rply_req_fifo_mem_rclk_rst_n)
,.rf_ldb_rply_req_fifo_mem_re    (rf_ldb_rply_req_fifo_mem_re)
,.rf_ldb_rply_req_fifo_mem_raddr (rf_ldb_rply_req_fifo_mem_raddr)
,.rf_ldb_rply_req_fifo_mem_waddr (rf_ldb_rply_req_fifo_mem_waddr)
,.rf_ldb_rply_req_fifo_mem_wclk (rf_ldb_rply_req_fifo_mem_wclk)
,.rf_ldb_rply_req_fifo_mem_wclk_rst_n (rf_ldb_rply_req_fifo_mem_wclk_rst_n)
,.rf_ldb_rply_req_fifo_mem_we    (rf_ldb_rply_req_fifo_mem_we)
,.rf_ldb_rply_req_fifo_mem_wdata (rf_ldb_rply_req_fifo_mem_wdata)
,.rf_ldb_rply_req_fifo_mem_rdata (rf_ldb_rply_req_fifo_mem_rdata)

,.rf_ldb_rply_req_fifo_mem_error (rf_ldb_rply_req_fifo_mem_error)

,.func_lsp_reordercmp_fifo_mem_re    (func_lsp_reordercmp_fifo_mem_re)
,.func_lsp_reordercmp_fifo_mem_raddr (func_lsp_reordercmp_fifo_mem_raddr)
,.func_lsp_reordercmp_fifo_mem_waddr (func_lsp_reordercmp_fifo_mem_waddr)
,.func_lsp_reordercmp_fifo_mem_we    (func_lsp_reordercmp_fifo_mem_we)
,.func_lsp_reordercmp_fifo_mem_wdata (func_lsp_reordercmp_fifo_mem_wdata)
,.func_lsp_reordercmp_fifo_mem_rdata (func_lsp_reordercmp_fifo_mem_rdata)

,.pf_lsp_reordercmp_fifo_mem_re      (pf_lsp_reordercmp_fifo_mem_re)
,.pf_lsp_reordercmp_fifo_mem_raddr (pf_lsp_reordercmp_fifo_mem_raddr)
,.pf_lsp_reordercmp_fifo_mem_waddr (pf_lsp_reordercmp_fifo_mem_waddr)
,.pf_lsp_reordercmp_fifo_mem_we    (pf_lsp_reordercmp_fifo_mem_we)
,.pf_lsp_reordercmp_fifo_mem_wdata (pf_lsp_reordercmp_fifo_mem_wdata)
,.pf_lsp_reordercmp_fifo_mem_rdata (pf_lsp_reordercmp_fifo_mem_rdata)

,.rf_lsp_reordercmp_fifo_mem_rclk (rf_lsp_reordercmp_fifo_mem_rclk)
,.rf_lsp_reordercmp_fifo_mem_rclk_rst_n (rf_lsp_reordercmp_fifo_mem_rclk_rst_n)
,.rf_lsp_reordercmp_fifo_mem_re    (rf_lsp_reordercmp_fifo_mem_re)
,.rf_lsp_reordercmp_fifo_mem_raddr (rf_lsp_reordercmp_fifo_mem_raddr)
,.rf_lsp_reordercmp_fifo_mem_waddr (rf_lsp_reordercmp_fifo_mem_waddr)
,.rf_lsp_reordercmp_fifo_mem_wclk (rf_lsp_reordercmp_fifo_mem_wclk)
,.rf_lsp_reordercmp_fifo_mem_wclk_rst_n (rf_lsp_reordercmp_fifo_mem_wclk_rst_n)
,.rf_lsp_reordercmp_fifo_mem_we    (rf_lsp_reordercmp_fifo_mem_we)
,.rf_lsp_reordercmp_fifo_mem_wdata (rf_lsp_reordercmp_fifo_mem_wdata)
,.rf_lsp_reordercmp_fifo_mem_rdata (rf_lsp_reordercmp_fifo_mem_rdata)

,.rf_lsp_reordercmp_fifo_mem_error (rf_lsp_reordercmp_fifo_mem_error)

,.func_reord_cnt_mem_re    (func_reord_cnt_mem_re)
,.func_reord_cnt_mem_raddr (func_reord_cnt_mem_raddr)
,.func_reord_cnt_mem_waddr (func_reord_cnt_mem_waddr)
,.func_reord_cnt_mem_we    (func_reord_cnt_mem_we)
,.func_reord_cnt_mem_wdata (func_reord_cnt_mem_wdata)
,.func_reord_cnt_mem_rdata (func_reord_cnt_mem_rdata)

,.pf_reord_cnt_mem_re      (pf_reord_cnt_mem_re)
,.pf_reord_cnt_mem_raddr (pf_reord_cnt_mem_raddr)
,.pf_reord_cnt_mem_waddr (pf_reord_cnt_mem_waddr)
,.pf_reord_cnt_mem_we    (pf_reord_cnt_mem_we)
,.pf_reord_cnt_mem_wdata (pf_reord_cnt_mem_wdata)
,.pf_reord_cnt_mem_rdata (pf_reord_cnt_mem_rdata)

,.rf_reord_cnt_mem_rclk (rf_reord_cnt_mem_rclk)
,.rf_reord_cnt_mem_rclk_rst_n (rf_reord_cnt_mem_rclk_rst_n)
,.rf_reord_cnt_mem_re    (rf_reord_cnt_mem_re)
,.rf_reord_cnt_mem_raddr (rf_reord_cnt_mem_raddr)
,.rf_reord_cnt_mem_waddr (rf_reord_cnt_mem_waddr)
,.rf_reord_cnt_mem_wclk (rf_reord_cnt_mem_wclk)
,.rf_reord_cnt_mem_wclk_rst_n (rf_reord_cnt_mem_wclk_rst_n)
,.rf_reord_cnt_mem_we    (rf_reord_cnt_mem_we)
,.rf_reord_cnt_mem_wdata (rf_reord_cnt_mem_wdata)
,.rf_reord_cnt_mem_rdata (rf_reord_cnt_mem_rdata)

,.rf_reord_cnt_mem_error (rf_reord_cnt_mem_error)

,.func_reord_dirhp_mem_re    (func_reord_dirhp_mem_re)
,.func_reord_dirhp_mem_raddr (func_reord_dirhp_mem_raddr)
,.func_reord_dirhp_mem_waddr (func_reord_dirhp_mem_waddr)
,.func_reord_dirhp_mem_we    (func_reord_dirhp_mem_we)
,.func_reord_dirhp_mem_wdata (func_reord_dirhp_mem_wdata)
,.func_reord_dirhp_mem_rdata (func_reord_dirhp_mem_rdata)

,.pf_reord_dirhp_mem_re      (pf_reord_dirhp_mem_re)
,.pf_reord_dirhp_mem_raddr (pf_reord_dirhp_mem_raddr)
,.pf_reord_dirhp_mem_waddr (pf_reord_dirhp_mem_waddr)
,.pf_reord_dirhp_mem_we    (pf_reord_dirhp_mem_we)
,.pf_reord_dirhp_mem_wdata (pf_reord_dirhp_mem_wdata)
,.pf_reord_dirhp_mem_rdata (pf_reord_dirhp_mem_rdata)

,.rf_reord_dirhp_mem_rclk (rf_reord_dirhp_mem_rclk)
,.rf_reord_dirhp_mem_rclk_rst_n (rf_reord_dirhp_mem_rclk_rst_n)
,.rf_reord_dirhp_mem_re    (rf_reord_dirhp_mem_re)
,.rf_reord_dirhp_mem_raddr (rf_reord_dirhp_mem_raddr)
,.rf_reord_dirhp_mem_waddr (rf_reord_dirhp_mem_waddr)
,.rf_reord_dirhp_mem_wclk (rf_reord_dirhp_mem_wclk)
,.rf_reord_dirhp_mem_wclk_rst_n (rf_reord_dirhp_mem_wclk_rst_n)
,.rf_reord_dirhp_mem_we    (rf_reord_dirhp_mem_we)
,.rf_reord_dirhp_mem_wdata (rf_reord_dirhp_mem_wdata)
,.rf_reord_dirhp_mem_rdata (rf_reord_dirhp_mem_rdata)

,.rf_reord_dirhp_mem_error (rf_reord_dirhp_mem_error)

,.func_reord_dirtp_mem_re    (func_reord_dirtp_mem_re)
,.func_reord_dirtp_mem_raddr (func_reord_dirtp_mem_raddr)
,.func_reord_dirtp_mem_waddr (func_reord_dirtp_mem_waddr)
,.func_reord_dirtp_mem_we    (func_reord_dirtp_mem_we)
,.func_reord_dirtp_mem_wdata (func_reord_dirtp_mem_wdata)
,.func_reord_dirtp_mem_rdata (func_reord_dirtp_mem_rdata)

,.pf_reord_dirtp_mem_re      (pf_reord_dirtp_mem_re)
,.pf_reord_dirtp_mem_raddr (pf_reord_dirtp_mem_raddr)
,.pf_reord_dirtp_mem_waddr (pf_reord_dirtp_mem_waddr)
,.pf_reord_dirtp_mem_we    (pf_reord_dirtp_mem_we)
,.pf_reord_dirtp_mem_wdata (pf_reord_dirtp_mem_wdata)
,.pf_reord_dirtp_mem_rdata (pf_reord_dirtp_mem_rdata)

,.rf_reord_dirtp_mem_rclk (rf_reord_dirtp_mem_rclk)
,.rf_reord_dirtp_mem_rclk_rst_n (rf_reord_dirtp_mem_rclk_rst_n)
,.rf_reord_dirtp_mem_re    (rf_reord_dirtp_mem_re)
,.rf_reord_dirtp_mem_raddr (rf_reord_dirtp_mem_raddr)
,.rf_reord_dirtp_mem_waddr (rf_reord_dirtp_mem_waddr)
,.rf_reord_dirtp_mem_wclk (rf_reord_dirtp_mem_wclk)
,.rf_reord_dirtp_mem_wclk_rst_n (rf_reord_dirtp_mem_wclk_rst_n)
,.rf_reord_dirtp_mem_we    (rf_reord_dirtp_mem_we)
,.rf_reord_dirtp_mem_wdata (rf_reord_dirtp_mem_wdata)
,.rf_reord_dirtp_mem_rdata (rf_reord_dirtp_mem_rdata)

,.rf_reord_dirtp_mem_error (rf_reord_dirtp_mem_error)

,.func_reord_lbhp_mem_re    (func_reord_lbhp_mem_re)
,.func_reord_lbhp_mem_raddr (func_reord_lbhp_mem_raddr)
,.func_reord_lbhp_mem_waddr (func_reord_lbhp_mem_waddr)
,.func_reord_lbhp_mem_we    (func_reord_lbhp_mem_we)
,.func_reord_lbhp_mem_wdata (func_reord_lbhp_mem_wdata)
,.func_reord_lbhp_mem_rdata (func_reord_lbhp_mem_rdata)

,.pf_reord_lbhp_mem_re      (pf_reord_lbhp_mem_re)
,.pf_reord_lbhp_mem_raddr (pf_reord_lbhp_mem_raddr)
,.pf_reord_lbhp_mem_waddr (pf_reord_lbhp_mem_waddr)
,.pf_reord_lbhp_mem_we    (pf_reord_lbhp_mem_we)
,.pf_reord_lbhp_mem_wdata (pf_reord_lbhp_mem_wdata)
,.pf_reord_lbhp_mem_rdata (pf_reord_lbhp_mem_rdata)

,.rf_reord_lbhp_mem_rclk (rf_reord_lbhp_mem_rclk)
,.rf_reord_lbhp_mem_rclk_rst_n (rf_reord_lbhp_mem_rclk_rst_n)
,.rf_reord_lbhp_mem_re    (rf_reord_lbhp_mem_re)
,.rf_reord_lbhp_mem_raddr (rf_reord_lbhp_mem_raddr)
,.rf_reord_lbhp_mem_waddr (rf_reord_lbhp_mem_waddr)
,.rf_reord_lbhp_mem_wclk (rf_reord_lbhp_mem_wclk)
,.rf_reord_lbhp_mem_wclk_rst_n (rf_reord_lbhp_mem_wclk_rst_n)
,.rf_reord_lbhp_mem_we    (rf_reord_lbhp_mem_we)
,.rf_reord_lbhp_mem_wdata (rf_reord_lbhp_mem_wdata)
,.rf_reord_lbhp_mem_rdata (rf_reord_lbhp_mem_rdata)

,.rf_reord_lbhp_mem_error (rf_reord_lbhp_mem_error)

,.func_reord_lbtp_mem_re    (func_reord_lbtp_mem_re)
,.func_reord_lbtp_mem_raddr (func_reord_lbtp_mem_raddr)
,.func_reord_lbtp_mem_waddr (func_reord_lbtp_mem_waddr)
,.func_reord_lbtp_mem_we    (func_reord_lbtp_mem_we)
,.func_reord_lbtp_mem_wdata (func_reord_lbtp_mem_wdata)
,.func_reord_lbtp_mem_rdata (func_reord_lbtp_mem_rdata)

,.pf_reord_lbtp_mem_re      (pf_reord_lbtp_mem_re)
,.pf_reord_lbtp_mem_raddr (pf_reord_lbtp_mem_raddr)
,.pf_reord_lbtp_mem_waddr (pf_reord_lbtp_mem_waddr)
,.pf_reord_lbtp_mem_we    (pf_reord_lbtp_mem_we)
,.pf_reord_lbtp_mem_wdata (pf_reord_lbtp_mem_wdata)
,.pf_reord_lbtp_mem_rdata (pf_reord_lbtp_mem_rdata)

,.rf_reord_lbtp_mem_rclk (rf_reord_lbtp_mem_rclk)
,.rf_reord_lbtp_mem_rclk_rst_n (rf_reord_lbtp_mem_rclk_rst_n)
,.rf_reord_lbtp_mem_re    (rf_reord_lbtp_mem_re)
,.rf_reord_lbtp_mem_raddr (rf_reord_lbtp_mem_raddr)
,.rf_reord_lbtp_mem_waddr (rf_reord_lbtp_mem_waddr)
,.rf_reord_lbtp_mem_wclk (rf_reord_lbtp_mem_wclk)
,.rf_reord_lbtp_mem_wclk_rst_n (rf_reord_lbtp_mem_wclk_rst_n)
,.rf_reord_lbtp_mem_we    (rf_reord_lbtp_mem_we)
,.rf_reord_lbtp_mem_wdata (rf_reord_lbtp_mem_wdata)
,.rf_reord_lbtp_mem_rdata (rf_reord_lbtp_mem_rdata)

,.rf_reord_lbtp_mem_error (rf_reord_lbtp_mem_error)

,.func_reord_st_mem_re    (func_reord_st_mem_re)
,.func_reord_st_mem_raddr (func_reord_st_mem_raddr)
,.func_reord_st_mem_waddr (func_reord_st_mem_waddr)
,.func_reord_st_mem_we    (func_reord_st_mem_we)
,.func_reord_st_mem_wdata (func_reord_st_mem_wdata)
,.func_reord_st_mem_rdata (func_reord_st_mem_rdata)

,.pf_reord_st_mem_re      (pf_reord_st_mem_re)
,.pf_reord_st_mem_raddr (pf_reord_st_mem_raddr)
,.pf_reord_st_mem_waddr (pf_reord_st_mem_waddr)
,.pf_reord_st_mem_we    (pf_reord_st_mem_we)
,.pf_reord_st_mem_wdata (pf_reord_st_mem_wdata)
,.pf_reord_st_mem_rdata (pf_reord_st_mem_rdata)

,.rf_reord_st_mem_rclk (rf_reord_st_mem_rclk)
,.rf_reord_st_mem_rclk_rst_n (rf_reord_st_mem_rclk_rst_n)
,.rf_reord_st_mem_re    (rf_reord_st_mem_re)
,.rf_reord_st_mem_raddr (rf_reord_st_mem_raddr)
,.rf_reord_st_mem_waddr (rf_reord_st_mem_waddr)
,.rf_reord_st_mem_wclk (rf_reord_st_mem_wclk)
,.rf_reord_st_mem_wclk_rst_n (rf_reord_st_mem_wclk_rst_n)
,.rf_reord_st_mem_we    (rf_reord_st_mem_we)
,.rf_reord_st_mem_wdata (rf_reord_st_mem_wdata)
,.rf_reord_st_mem_rdata (rf_reord_st_mem_rdata)

,.rf_reord_st_mem_error (rf_reord_st_mem_error)

,.func_rop_chp_rop_hcw_fifo_mem_re    (func_rop_chp_rop_hcw_fifo_mem_re)
,.func_rop_chp_rop_hcw_fifo_mem_raddr (func_rop_chp_rop_hcw_fifo_mem_raddr)
,.func_rop_chp_rop_hcw_fifo_mem_waddr (func_rop_chp_rop_hcw_fifo_mem_waddr)
,.func_rop_chp_rop_hcw_fifo_mem_we    (func_rop_chp_rop_hcw_fifo_mem_we)
,.func_rop_chp_rop_hcw_fifo_mem_wdata (func_rop_chp_rop_hcw_fifo_mem_wdata)
,.func_rop_chp_rop_hcw_fifo_mem_rdata (func_rop_chp_rop_hcw_fifo_mem_rdata)

,.pf_rop_chp_rop_hcw_fifo_mem_re      (pf_rop_chp_rop_hcw_fifo_mem_re)
,.pf_rop_chp_rop_hcw_fifo_mem_raddr (pf_rop_chp_rop_hcw_fifo_mem_raddr)
,.pf_rop_chp_rop_hcw_fifo_mem_waddr (pf_rop_chp_rop_hcw_fifo_mem_waddr)
,.pf_rop_chp_rop_hcw_fifo_mem_we    (pf_rop_chp_rop_hcw_fifo_mem_we)
,.pf_rop_chp_rop_hcw_fifo_mem_wdata (pf_rop_chp_rop_hcw_fifo_mem_wdata)
,.pf_rop_chp_rop_hcw_fifo_mem_rdata (pf_rop_chp_rop_hcw_fifo_mem_rdata)

,.rf_rop_chp_rop_hcw_fifo_mem_rclk (rf_rop_chp_rop_hcw_fifo_mem_rclk)
,.rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n (rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n)
,.rf_rop_chp_rop_hcw_fifo_mem_re    (rf_rop_chp_rop_hcw_fifo_mem_re)
,.rf_rop_chp_rop_hcw_fifo_mem_raddr (rf_rop_chp_rop_hcw_fifo_mem_raddr)
,.rf_rop_chp_rop_hcw_fifo_mem_waddr (rf_rop_chp_rop_hcw_fifo_mem_waddr)
,.rf_rop_chp_rop_hcw_fifo_mem_wclk (rf_rop_chp_rop_hcw_fifo_mem_wclk)
,.rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n (rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n)
,.rf_rop_chp_rop_hcw_fifo_mem_we    (rf_rop_chp_rop_hcw_fifo_mem_we)
,.rf_rop_chp_rop_hcw_fifo_mem_wdata (rf_rop_chp_rop_hcw_fifo_mem_wdata)
,.rf_rop_chp_rop_hcw_fifo_mem_rdata (rf_rop_chp_rop_hcw_fifo_mem_rdata)

,.rf_rop_chp_rop_hcw_fifo_mem_error (rf_rop_chp_rop_hcw_fifo_mem_error)

,.func_sn0_order_shft_mem_re    (func_sn0_order_shft_mem_re)
,.func_sn0_order_shft_mem_raddr (func_sn0_order_shft_mem_raddr)
,.func_sn0_order_shft_mem_waddr (func_sn0_order_shft_mem_waddr)
,.func_sn0_order_shft_mem_we    (func_sn0_order_shft_mem_we)
,.func_sn0_order_shft_mem_wdata (func_sn0_order_shft_mem_wdata)
,.func_sn0_order_shft_mem_rdata (func_sn0_order_shft_mem_rdata)

,.pf_sn0_order_shft_mem_re      (pf_sn0_order_shft_mem_re)
,.pf_sn0_order_shft_mem_raddr (pf_sn0_order_shft_mem_raddr)
,.pf_sn0_order_shft_mem_waddr (pf_sn0_order_shft_mem_waddr)
,.pf_sn0_order_shft_mem_we    (pf_sn0_order_shft_mem_we)
,.pf_sn0_order_shft_mem_wdata (pf_sn0_order_shft_mem_wdata)
,.pf_sn0_order_shft_mem_rdata (pf_sn0_order_shft_mem_rdata)

,.rf_sn0_order_shft_mem_rclk (rf_sn0_order_shft_mem_rclk)
,.rf_sn0_order_shft_mem_rclk_rst_n (rf_sn0_order_shft_mem_rclk_rst_n)
,.rf_sn0_order_shft_mem_re    (rf_sn0_order_shft_mem_re)
,.rf_sn0_order_shft_mem_raddr (rf_sn0_order_shft_mem_raddr)
,.rf_sn0_order_shft_mem_waddr (rf_sn0_order_shft_mem_waddr)
,.rf_sn0_order_shft_mem_wclk (rf_sn0_order_shft_mem_wclk)
,.rf_sn0_order_shft_mem_wclk_rst_n (rf_sn0_order_shft_mem_wclk_rst_n)
,.rf_sn0_order_shft_mem_we    (rf_sn0_order_shft_mem_we)
,.rf_sn0_order_shft_mem_wdata (rf_sn0_order_shft_mem_wdata)
,.rf_sn0_order_shft_mem_rdata (rf_sn0_order_shft_mem_rdata)

,.rf_sn0_order_shft_mem_error (rf_sn0_order_shft_mem_error)

,.func_sn1_order_shft_mem_re    (func_sn1_order_shft_mem_re)
,.func_sn1_order_shft_mem_raddr (func_sn1_order_shft_mem_raddr)
,.func_sn1_order_shft_mem_waddr (func_sn1_order_shft_mem_waddr)
,.func_sn1_order_shft_mem_we    (func_sn1_order_shft_mem_we)
,.func_sn1_order_shft_mem_wdata (func_sn1_order_shft_mem_wdata)
,.func_sn1_order_shft_mem_rdata (func_sn1_order_shft_mem_rdata)

,.pf_sn1_order_shft_mem_re      (pf_sn1_order_shft_mem_re)
,.pf_sn1_order_shft_mem_raddr (pf_sn1_order_shft_mem_raddr)
,.pf_sn1_order_shft_mem_waddr (pf_sn1_order_shft_mem_waddr)
,.pf_sn1_order_shft_mem_we    (pf_sn1_order_shft_mem_we)
,.pf_sn1_order_shft_mem_wdata (pf_sn1_order_shft_mem_wdata)
,.pf_sn1_order_shft_mem_rdata (pf_sn1_order_shft_mem_rdata)

,.rf_sn1_order_shft_mem_rclk (rf_sn1_order_shft_mem_rclk)
,.rf_sn1_order_shft_mem_rclk_rst_n (rf_sn1_order_shft_mem_rclk_rst_n)
,.rf_sn1_order_shft_mem_re    (rf_sn1_order_shft_mem_re)
,.rf_sn1_order_shft_mem_raddr (rf_sn1_order_shft_mem_raddr)
,.rf_sn1_order_shft_mem_waddr (rf_sn1_order_shft_mem_waddr)
,.rf_sn1_order_shft_mem_wclk (rf_sn1_order_shft_mem_wclk)
,.rf_sn1_order_shft_mem_wclk_rst_n (rf_sn1_order_shft_mem_wclk_rst_n)
,.rf_sn1_order_shft_mem_we    (rf_sn1_order_shft_mem_we)
,.rf_sn1_order_shft_mem_wdata (rf_sn1_order_shft_mem_wdata)
,.rf_sn1_order_shft_mem_rdata (rf_sn1_order_shft_mem_rdata)

,.rf_sn1_order_shft_mem_error (rf_sn1_order_shft_mem_error)

,.func_sn_complete_fifo_mem_re    (func_sn_complete_fifo_mem_re)
,.func_sn_complete_fifo_mem_raddr (func_sn_complete_fifo_mem_raddr)
,.func_sn_complete_fifo_mem_waddr (func_sn_complete_fifo_mem_waddr)
,.func_sn_complete_fifo_mem_we    (func_sn_complete_fifo_mem_we)
,.func_sn_complete_fifo_mem_wdata (func_sn_complete_fifo_mem_wdata)
,.func_sn_complete_fifo_mem_rdata (func_sn_complete_fifo_mem_rdata)

,.pf_sn_complete_fifo_mem_re      (pf_sn_complete_fifo_mem_re)
,.pf_sn_complete_fifo_mem_raddr (pf_sn_complete_fifo_mem_raddr)
,.pf_sn_complete_fifo_mem_waddr (pf_sn_complete_fifo_mem_waddr)
,.pf_sn_complete_fifo_mem_we    (pf_sn_complete_fifo_mem_we)
,.pf_sn_complete_fifo_mem_wdata (pf_sn_complete_fifo_mem_wdata)
,.pf_sn_complete_fifo_mem_rdata (pf_sn_complete_fifo_mem_rdata)

,.rf_sn_complete_fifo_mem_rclk (rf_sn_complete_fifo_mem_rclk)
,.rf_sn_complete_fifo_mem_rclk_rst_n (rf_sn_complete_fifo_mem_rclk_rst_n)
,.rf_sn_complete_fifo_mem_re    (rf_sn_complete_fifo_mem_re)
,.rf_sn_complete_fifo_mem_raddr (rf_sn_complete_fifo_mem_raddr)
,.rf_sn_complete_fifo_mem_waddr (rf_sn_complete_fifo_mem_waddr)
,.rf_sn_complete_fifo_mem_wclk (rf_sn_complete_fifo_mem_wclk)
,.rf_sn_complete_fifo_mem_wclk_rst_n (rf_sn_complete_fifo_mem_wclk_rst_n)
,.rf_sn_complete_fifo_mem_we    (rf_sn_complete_fifo_mem_we)
,.rf_sn_complete_fifo_mem_wdata (rf_sn_complete_fifo_mem_wdata)
,.rf_sn_complete_fifo_mem_rdata (rf_sn_complete_fifo_mem_rdata)

,.rf_sn_complete_fifo_mem_error (rf_sn_complete_fifo_mem_error)

,.func_sn_ordered_fifo_mem_re    (func_sn_ordered_fifo_mem_re)
,.func_sn_ordered_fifo_mem_raddr (func_sn_ordered_fifo_mem_raddr)
,.func_sn_ordered_fifo_mem_waddr (func_sn_ordered_fifo_mem_waddr)
,.func_sn_ordered_fifo_mem_we    (func_sn_ordered_fifo_mem_we)
,.func_sn_ordered_fifo_mem_wdata (func_sn_ordered_fifo_mem_wdata)
,.func_sn_ordered_fifo_mem_rdata (func_sn_ordered_fifo_mem_rdata)

,.pf_sn_ordered_fifo_mem_re      (pf_sn_ordered_fifo_mem_re)
,.pf_sn_ordered_fifo_mem_raddr (pf_sn_ordered_fifo_mem_raddr)
,.pf_sn_ordered_fifo_mem_waddr (pf_sn_ordered_fifo_mem_waddr)
,.pf_sn_ordered_fifo_mem_we    (pf_sn_ordered_fifo_mem_we)
,.pf_sn_ordered_fifo_mem_wdata (pf_sn_ordered_fifo_mem_wdata)
,.pf_sn_ordered_fifo_mem_rdata (pf_sn_ordered_fifo_mem_rdata)

,.rf_sn_ordered_fifo_mem_rclk (rf_sn_ordered_fifo_mem_rclk)
,.rf_sn_ordered_fifo_mem_rclk_rst_n (rf_sn_ordered_fifo_mem_rclk_rst_n)
,.rf_sn_ordered_fifo_mem_re    (rf_sn_ordered_fifo_mem_re)
,.rf_sn_ordered_fifo_mem_raddr (rf_sn_ordered_fifo_mem_raddr)
,.rf_sn_ordered_fifo_mem_waddr (rf_sn_ordered_fifo_mem_waddr)
,.rf_sn_ordered_fifo_mem_wclk (rf_sn_ordered_fifo_mem_wclk)
,.rf_sn_ordered_fifo_mem_wclk_rst_n (rf_sn_ordered_fifo_mem_wclk_rst_n)
,.rf_sn_ordered_fifo_mem_we    (rf_sn_ordered_fifo_mem_we)
,.rf_sn_ordered_fifo_mem_wdata (rf_sn_ordered_fifo_mem_wdata)
,.rf_sn_ordered_fifo_mem_rdata (rf_sn_ordered_fifo_mem_rdata)

,.rf_sn_ordered_fifo_mem_error (rf_sn_ordered_fifo_mem_error)

);
// END HQM_RAM_ACCESS


//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [31:0] unit_cfg_rsp_rdata ;
aw_fifo_status_t rop_cfg_ring_top_rx_fifo_status;
logic cfg_idle;
logic cfg_rx_idle;


hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_ROP_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_ROP_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_ROP_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_ROP_CFG_UNIT_NUM_TGTS )
) i_hqm_aw_cfg_ring_top (
          .hqm_inp_gated_clk           ( hqm_inp_gated_clk )
        , .hqm_inp_gated_rst_n         ( hqm_inp_gated_rst_n )
        , .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )
        , .rst_prep                    ( rst_prep )

        , .cfg_rx_enable               ( rop_clk_enable ) // I
        , .cfg_rx_idle                 ( cfg_rx_idle ) // O
        , .cfg_rx_fifo_status          ( rop_cfg_ring_top_rx_fifo_status )

        , .cfg_idle                    ( cfg_idle )

        , .up_cfg_req_write            ( rop_cfg_req_up_write )
        , .up_cfg_req_read             ( rop_cfg_req_up_read )
        , .up_cfg_req                  ( rop_cfg_req_up )
        , .up_cfg_rsp_ack              ( rop_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( rop_cfg_rsp_up )

        , .down_cfg_req_write          ( rop_cfg_req_down_write )
        , .down_cfg_req_read           ( rop_cfg_req_down_read )
        , .down_cfg_req                ( rop_cfg_req_down )
        , .down_cfg_rsp_ack            ( rop_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( rop_cfg_rsp_down )

        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )
) ;
//------------------------------------------------------------------------------------------------------------------

logic cfg_req_idlepipe ;
logic cfg_req_ready ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read_nc ;



hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_ROP_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_ROP_CFG_UNIT_NUM_TGTS )
        , .NUM_CFG_ACCESSIBLE_RAM      ( NUM_CFG_ACCESSIBLE_RAM )
) i_hqm_AW_cfg_sc (
          .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )

        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )

        , .pfcsr_cfg_req_write          ( pfcsr_cfg_req_write )
        , .pfcsr_cfg_req_read           ( pfcsr_cfg_req_read )
        , .pfcsr_cfg_req                ( pfcsr_cfg_req )
        , .pfcsr_cfg_rsp_ack            ( pfcsr_cfg_rsp_ack )
        , .pfcsr_cfg_rsp_err            ( pfcsr_cfg_rsp_err )
        , .pfcsr_cfg_rsp_rdata          ( pfcsr_cfg_rsp_rdata )

        , .cfg_mem_re                  ( cfg_mem_re )
        , .cfg_mem_we                  ( cfg_mem_we )
        , .cfg_mem_wdata               ( cfg_mem_wdata )
        , .cfg_mem_rdata               ( cfg_mem_rdata )
        , .cfg_req_idlepipe            ( cfg_req_idlepipe )
        , .cfg_req_ready               ( cfg_req_ready )
        , .cfg_req_write               ( cfg_req_write )
        , .cfg_req_read                ( cfg_req_read_nc )

        ,.cfg_mem_addr                 ( cfg_mem_addr )
        ,.cfg_mem_minbit               ( cfg_mem_minbit )
        ,.cfg_mem_maxbit               ( cfg_mem_maxbit )
        ,.cfg_mem_ack                  ( cfg_mem_ack )

        ,.cfg_timout_enable            ( cfg_unit_timeout.ENABLE )
        ,.cfg_timout_threshold         ( cfg_unit_timeout.THRESHOLD )


);

hqm_reorder_pipe_func i_hqm_reorder_pipe_func (

  . hqm_gated_clk             ( hqm_gated_clk )    // I
                              
, .pf_reset_active            ( pf_reset_active )

, .rop_clk_idle               ( rop_clk_idle )    // O
, .cfg_rx_idle                ( cfg_rx_idle ) // I
, .cfg_idle                   ( cfg_idle )
                              
, .rop_unit_idle              ( rop_unit_idle )     // O
, .rop_unit_pipeidle          ( rop_unit_pipeidle ) // O
, .rop_reset_done             ( rop_reset_done )    // O
// from hqm_AW_reset_core
, .hqm_gated_rst_n_active     ( hqm_gated_rst_n_active )
, .rst_prep                   ( rst_prep )
, .hqm_gated_rst_n            ( hqm_gated_rst_n)

, .cfg_unit_timeout           ( cfg_unit_timeout )
, .rop_cfg_ring_top_rx_fifo_status ( rop_cfg_ring_top_rx_fifo_status )
, .cfg_req_idlepipe           ( cfg_req_idlepipe )
, .cfg_req_ready              ( cfg_req_ready )

, .int_inf_v                  ( int_inf_v )
, .int_inf_data               ( int_inf_data )
, .int_cor_v                  ( int_cor_v )
, .int_cor_data               ( int_cor_data )
, .int_unc_v                  ( int_unc_v )
, .int_unc_data               ( int_unc_data )
, .int_idle                   ( int_idle )
, .int_serializer_status      ( int_serializer_status )
                                            
// CFG interface                            
//, .rop_cfg_req_up_read        ( rop_cfg_req_up_read )  // I
//, .rop_cfg_req_up_write       ( rop_cfg_req_up_write ) // I
//, .rop_cfg_req_up             ( rop_cfg_req_up ) // I 
//, .rop_cfg_rsp_up_ack         ( rop_cfg_rsp_up_ack ) // I
//, .rop_cfg_rsp_up             ( rop_cfg_rsp_up ) // I
//, .rop_cfg_req_down_read      ( rop_cfg_req_down_read ) // O
//, .rop_cfg_req_down_write     ( rop_cfg_req_down_write ) // O
//, .rop_cfg_req_down           ( rop_cfg_req_down ) // O
//, .rop_cfg_rsp_down_ack       ( rop_cfg_rsp_down_ack ) // O
//, .rop_cfg_rsp_down           ( rop_cfg_rsp_down ) // O
                                            
, .rop_alarm_up_v             ( rop_alarm_up_v )            // I
, .rop_alarm_up_ready         ( rop_alarm_up_ready )        // O
//, .rop_alarm_up_data          ( rop_alarm_up_data )         // I
                                            
, .rop_alarm_down_v           ( rop_alarm_down_v )          // O
, .rop_alarm_down_ready       ( rop_alarm_down_ready )      // I
//, .rop_alarm_down_data        ( rop_alarm_down_data )       // O
                                            
, .chp_rop_hcw_v              ( chp_rop_hcw_v )             // I
, .chp_rop_hcw_ready          ( chp_rop_hcw_ready )         // O
, .chp_rop_hcw_data           ( chp_rop_hcw_data )          // I
                                        
, .rop_dp_enq_v               ( rop_dp_enq_v )             // O
, .rop_dp_enq_ready           ( rop_dp_enq_ready )         // I
, .rop_dp_enq_data            ( rop_dp_enq_data )          // O
                                           
, .rop_nalb_enq_v             ( rop_nalb_enq_v )            // O
, .rop_nalb_enq_ready         ( rop_nalb_enq_ready )        // I
, .rop_nalb_enq_data          ( rop_nalb_enq_data )         // O
                                                            
, .rop_qed_dqed_enq_v         ( rop_qed_dqed_enq_v )        // O
, .rop_qed_enq_ready          ( rop_qed_enq_ready )         // I
, .rop_dqed_enq_ready         ( rop_dqed_enq_ready )        // I
, .rop_qed_dqed_enq_data      ( rop_qed_dqed_enq_data )     // O
, .rop_qed_force_clockon      ( rop_qed_force_clockon )     // O
                                        
// rop_lsp_reordercmp interface        
, .rop_lsp_reordercmp_v               ( rop_lsp_reordercmp_v )      // O
, .rop_lsp_reordercmp_ready           ( rop_lsp_reordercmp_ready ) // I
, .rop_lsp_reordercmp_data            ( rop_lsp_reordercmp_data )  // O
                                      
, .func_reord_dirhp_mem_re            ( func_reord_dirhp_mem_re )
, .func_reord_dirhp_mem_raddr         ( func_reord_dirhp_mem_raddr )
, .func_reord_dirhp_mem_waddr         ( func_reord_dirhp_mem_waddr )
, .func_reord_dirhp_mem_we            ( func_reord_dirhp_mem_we )
, .func_reord_dirhp_mem_wdata         ( func_reord_dirhp_mem_wdata )
, .func_reord_dirhp_mem_rdata         ( func_reord_dirhp_mem_rdata )
, .func_lsp_reordercmp_fifo_mem_re    ( func_lsp_reordercmp_fifo_mem_re )
, .func_lsp_reordercmp_fifo_mem_raddr ( func_lsp_reordercmp_fifo_mem_raddr )
, .func_lsp_reordercmp_fifo_mem_waddr ( func_lsp_reordercmp_fifo_mem_waddr )
, .func_lsp_reordercmp_fifo_mem_we    ( func_lsp_reordercmp_fifo_mem_we )
, .func_lsp_reordercmp_fifo_mem_wdata ( func_lsp_reordercmp_fifo_mem_wdata )
, .func_lsp_reordercmp_fifo_mem_rdata ( func_lsp_reordercmp_fifo_mem_rdata )
, .func_sn1_order_shft_mem_re         ( func_sn1_order_shft_mem_re )
, .func_sn1_order_shft_mem_raddr      ( func_sn1_order_shft_mem_raddr )
, .func_sn1_order_shft_mem_waddr      ( func_sn1_order_shft_mem_waddr )
, .func_sn1_order_shft_mem_we         ( func_sn1_order_shft_mem_we )
, .func_sn1_order_shft_mem_wdata      ( func_sn1_order_shft_mem_wdata )
, .func_sn1_order_shft_mem_rdata      ( func_sn1_order_shft_mem_rdata )
, .func_sn_ordered_fifo_mem_re        ( func_sn_ordered_fifo_mem_re )
, .func_sn_ordered_fifo_mem_raddr     ( func_sn_ordered_fifo_mem_raddr )
, .func_sn_ordered_fifo_mem_waddr     ( func_sn_ordered_fifo_mem_waddr )
, .func_sn_ordered_fifo_mem_we        ( func_sn_ordered_fifo_mem_we )
, .func_sn_ordered_fifo_mem_wdata     ( func_sn_ordered_fifo_mem_wdata )
, .func_sn_ordered_fifo_mem_rdata     ( func_sn_ordered_fifo_mem_rdata )
, .func_ldb_rply_req_fifo_mem_re      ( func_ldb_rply_req_fifo_mem_re )
, .func_ldb_rply_req_fifo_mem_raddr   ( func_ldb_rply_req_fifo_mem_raddr )
, .func_ldb_rply_req_fifo_mem_waddr   ( func_ldb_rply_req_fifo_mem_waddr )
, .func_ldb_rply_req_fifo_mem_we      ( func_ldb_rply_req_fifo_mem_we )
, .func_ldb_rply_req_fifo_mem_wdata   ( func_ldb_rply_req_fifo_mem_wdata )
, .func_ldb_rply_req_fifo_mem_rdata   ( func_ldb_rply_req_fifo_mem_rdata )
, .func_sn_complete_fifo_mem_re       ( func_sn_complete_fifo_mem_re )
, .func_sn_complete_fifo_mem_raddr    ( func_sn_complete_fifo_mem_raddr )
, .func_sn_complete_fifo_mem_waddr    ( func_sn_complete_fifo_mem_waddr )
, .func_sn_complete_fifo_mem_we       ( func_sn_complete_fifo_mem_we )
, .func_sn_complete_fifo_mem_wdata    ( func_sn_complete_fifo_mem_wdata )
, .func_sn_complete_fifo_mem_rdata    ( func_sn_complete_fifo_mem_rdata )
, .func_dir_rply_req_fifo_mem_re      ( func_dir_rply_req_fifo_mem_re )
, .func_dir_rply_req_fifo_mem_raddr   ( func_dir_rply_req_fifo_mem_raddr )
, .func_dir_rply_req_fifo_mem_waddr   ( func_dir_rply_req_fifo_mem_waddr )
, .func_dir_rply_req_fifo_mem_we      ( func_dir_rply_req_fifo_mem_we )
, .func_dir_rply_req_fifo_mem_wdata   ( func_dir_rply_req_fifo_mem_wdata )
, .func_dir_rply_req_fifo_mem_rdata   ( func_dir_rply_req_fifo_mem_rdata )
, .func_chp_rop_hcw_fifo_mem_re       ( func_rop_chp_rop_hcw_fifo_mem_re )
, .func_chp_rop_hcw_fifo_mem_raddr    ( func_rop_chp_rop_hcw_fifo_mem_raddr )
, .func_chp_rop_hcw_fifo_mem_waddr    ( func_rop_chp_rop_hcw_fifo_mem_waddr )
, .func_chp_rop_hcw_fifo_mem_we       ( func_rop_chp_rop_hcw_fifo_mem_we )
, .func_chp_rop_hcw_fifo_mem_wdata    ( func_rop_chp_rop_hcw_fifo_mem_wdata )
, .func_chp_rop_hcw_fifo_mem_rdata    ( func_rop_chp_rop_hcw_fifo_mem_rdata )
, .func_reord_cnt_mem_re              ( func_reord_cnt_mem_re )
, .func_reord_cnt_mem_raddr           ( func_reord_cnt_mem_raddr )
, .func_reord_cnt_mem_waddr           ( func_reord_cnt_mem_waddr )
, .func_reord_cnt_mem_we              ( func_reord_cnt_mem_we )
, .func_reord_cnt_mem_wdata           ( func_reord_cnt_mem_wdata )
, .func_reord_cnt_mem_rdata           ( func_reord_cnt_mem_rdata )
, .func_reord_dirtp_mem_re            ( func_reord_dirtp_mem_re )
, .func_reord_dirtp_mem_raddr         ( func_reord_dirtp_mem_raddr )
, .func_reord_dirtp_mem_waddr         ( func_reord_dirtp_mem_waddr )
, .func_reord_dirtp_mem_we            ( func_reord_dirtp_mem_we )
, .func_reord_dirtp_mem_wdata         ( func_reord_dirtp_mem_wdata )
, .func_reord_dirtp_mem_rdata         ( func_reord_dirtp_mem_rdata )
, .func_reord_st_mem_re               ( func_reord_st_mem_re )
, .func_reord_st_mem_raddr            ( func_reord_st_mem_raddr )
, .func_reord_st_mem_waddr            ( func_reord_st_mem_waddr )
, .func_reord_st_mem_we               ( func_reord_st_mem_we )
, .func_reord_st_mem_wdata            ( func_reord_st_mem_wdata )
, .func_reord_st_mem_rdata            ( func_reord_st_mem_rdata )
, .func_reord_lbtp_mem_re             ( func_reord_lbtp_mem_re )
, .func_reord_lbtp_mem_raddr          ( func_reord_lbtp_mem_raddr )
, .func_reord_lbtp_mem_waddr          ( func_reord_lbtp_mem_waddr )
, .func_reord_lbtp_mem_we             ( func_reord_lbtp_mem_we )
, .func_reord_lbtp_mem_wdata          ( func_reord_lbtp_mem_wdata )
, .func_reord_lbtp_mem_rdata          ( func_reord_lbtp_mem_rdata )
, .func_sn0_order_shft_mem_re         ( func_sn0_order_shft_mem_re )
, .func_sn0_order_shft_mem_raddr      ( func_sn0_order_shft_mem_raddr )
, .func_sn0_order_shft_mem_waddr      ( func_sn0_order_shft_mem_waddr )
, .func_sn0_order_shft_mem_we         ( func_sn0_order_shft_mem_we )
, .func_sn0_order_shft_mem_wdata      ( func_sn0_order_shft_mem_wdata )
, .func_sn0_order_shft_mem_rdata      ( func_sn0_order_shft_mem_rdata )
, .func_reord_lbhp_mem_re             ( func_reord_lbhp_mem_re )
, .func_reord_lbhp_mem_raddr          ( func_reord_lbhp_mem_raddr )
, .func_reord_lbhp_mem_waddr          ( func_reord_lbhp_mem_waddr )
, .func_reord_lbhp_mem_we             ( func_reord_lbhp_mem_we )
, .func_reord_lbhp_mem_wdata          ( func_reord_lbhp_mem_wdata )
, .func_reord_lbhp_mem_rdata          ( func_reord_lbhp_mem_rdata )
, .hqm_reorder_pipe_rfw_top_ipar_error( hqm_reorder_pipe_rfw_top_ipar_error )
, .rf_reord_dirhp_mem_error           ( rf_reord_dirhp_mem_error )
, .rf_lsp_reordercmp_fifo_mem_error   ( rf_lsp_reordercmp_fifo_mem_error )
, .rf_sn1_order_shft_mem_error        ( rf_sn1_order_shft_mem_error )
, .rf_sn_ordered_fifo_mem_error       ( rf_sn_ordered_fifo_mem_error )
, .rf_ldb_rply_req_fifo_mem_error     ( rf_ldb_rply_req_fifo_mem_error )
, .rf_sn_complete_fifo_mem_error      ( rf_sn_complete_fifo_mem_error )
, .rf_dir_rply_req_fifo_mem_error     ( rf_dir_rply_req_fifo_mem_error )
, .rf_chp_rop_hcw_fifo_mem_error      ( rf_rop_chp_rop_hcw_fifo_mem_error )
, .rf_reord_cnt_mem_error             ( rf_reord_cnt_mem_error ) 
, .rf_reord_dirtp_mem_error           ( rf_reord_dirtp_mem_error )
, .rf_reord_st_mem_error              ( rf_reord_st_mem_error )
, .rf_reord_lbtp_mem_error            ( rf_reord_lbtp_mem_error )
, .rf_sn0_order_shft_mem_error        ( rf_sn0_order_shft_mem_error )
, .rf_reord_lbhp_mem_error            ( rf_reord_lbhp_mem_error )

, .hqm_rop_target_cfg_control_general_0_reg_v ( hqm_rop_target_cfg_control_general_0_reg_v )
, .hqm_rop_target_cfg_control_general_0_reg_nxt ( hqm_rop_target_cfg_control_general_0_reg_nxt )
, .hqm_rop_target_cfg_control_general_0_reg_f ( hqm_rop_target_cfg_control_general_0_reg_f )
, .hqm_rop_target_cfg_diagnostic_aw_status_status ( hqm_rop_target_cfg_diagnostic_aw_status_status )
, .hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f )
, .hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt )
, .hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f )
, .hqm_rop_target_cfg_frag_integrity_count_status ( hqm_rop_target_cfg_frag_integrity_count_status )
, .hqm_rop_target_cfg_grp_sn_mode_reg_v ( hqm_rop_target_cfg_grp_sn_mode_reg_v )
, .hqm_rop_target_cfg_grp_sn_mode_reg_nxt ( hqm_rop_target_cfg_grp_sn_mode_reg_nxt )
, .hqm_rop_target_cfg_grp_sn_mode_reg_f ( hqm_rop_target_cfg_grp_sn_mode_reg_f )
, .hqm_rop_target_cfg_hw_agitate_control_reg_v ( hqm_rop_target_cfg_hw_agitate_control_reg_v )
, .hqm_rop_target_cfg_hw_agitate_control_reg_nxt ( hqm_rop_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_rop_target_cfg_hw_agitate_control_reg_f ( hqm_rop_target_cfg_hw_agitate_control_reg_f )
, .hqm_rop_target_cfg_hw_agitate_select_reg_v ( hqm_rop_target_cfg_hw_agitate_select_reg_v )
, .hqm_rop_target_cfg_hw_agitate_select_reg_nxt ( hqm_rop_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_rop_target_cfg_hw_agitate_select_reg_f ( hqm_rop_target_cfg_hw_agitate_select_reg_f )
, .hqm_rop_target_cfg_interface_status_status ( hqm_rop_target_cfg_interface_status_status )
, .hqm_rop_target_cfg_patch_control_reg_v ( hqm_rop_target_cfg_patch_control_reg_v )
, .hqm_rop_target_cfg_patch_control_reg_nxt ( hqm_rop_target_cfg_patch_control_reg_nxt )
, .hqm_rop_target_cfg_patch_control_reg_f ( hqm_rop_target_cfg_patch_control_reg_f )
, .hqm_rop_target_cfg_pipe_health_hold_grp0_status ( hqm_rop_target_cfg_pipe_health_hold_grp0_status )
, .hqm_rop_target_cfg_pipe_health_hold_grp1_status ( hqm_rop_target_cfg_pipe_health_hold_grp1_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_dp_status ( hqm_rop_target_cfg_pipe_health_hold_rop_dp_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status ( hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status ( hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status )
, .hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status ( hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status )
, .hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status )
, .hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status )
, .hqm_rop_target_cfg_pipe_health_valid_grp0_status ( hqm_rop_target_cfg_pipe_health_valid_grp0_status )
, .hqm_rop_target_cfg_pipe_health_valid_grp1_status ( hqm_rop_target_cfg_pipe_health_valid_grp1_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_dp_status ( hqm_rop_target_cfg_pipe_health_valid_rop_dp_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status ( hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status ( hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status )
, .hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status ( hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status )
, .hqm_rop_target_cfg_rop_csr_control_reg_v ( hqm_rop_target_cfg_rop_csr_control_reg_v )
, .hqm_rop_target_cfg_rop_csr_control_reg_nxt ( hqm_rop_target_cfg_rop_csr_control_reg_nxt )
, .hqm_rop_target_cfg_rop_csr_control_reg_f ( hqm_rop_target_cfg_rop_csr_control_reg_f )
, .hqm_rop_target_cfg_serializer_status_status ( hqm_rop_target_cfg_serializer_status_status )
, .hqm_rop_target_cfg_smon_disable_smon ( hqm_rop_target_cfg_smon_disable_smon )
, .hqm_rop_target_cfg_smon_smon_v ( hqm_rop_target_cfg_smon_smon_v )
, .hqm_rop_target_cfg_smon_smon_comp ( hqm_rop_target_cfg_smon_smon_comp )
, .hqm_rop_target_cfg_smon_smon_val ( hqm_rop_target_cfg_smon_smon_val )
, .hqm_rop_target_cfg_smon_smon_enabled ( hqm_rop_target_cfg_smon_smon_enabled )
, .hqm_rop_target_cfg_smon_smon_interrupt ( hqm_rop_target_cfg_smon_smon_interrupt )
, .hqm_rop_target_cfg_syndrome_00_capture_v ( hqm_rop_target_cfg_syndrome_00_capture_v )
, .hqm_rop_target_cfg_syndrome_00_capture_data ( hqm_rop_target_cfg_syndrome_00_capture_data )
, .hqm_rop_target_cfg_syndrome_01_capture_v ( hqm_rop_target_cfg_syndrome_01_capture_v )
, .hqm_rop_target_cfg_syndrome_01_capture_data ( hqm_rop_target_cfg_syndrome_01_capture_data )
, .hqm_rop_target_cfg_unit_idle_reg_nxt ( hqm_rop_target_cfg_unit_idle_reg_nxt )
, .hqm_rop_target_cfg_unit_idle_reg_f ( hqm_rop_target_cfg_unit_idle_reg_f )
, .hqm_rop_target_cfg_unit_timeout_reg_nxt ( hqm_rop_target_cfg_unit_timeout_reg_nxt )
, .hqm_rop_target_cfg_unit_timeout_reg_f ( hqm_rop_target_cfg_unit_timeout_reg_f )
, .hqm_rop_target_cfg_unit_version_status ( hqm_rop_target_cfg_unit_version_status )


);

// this module performs the pf init function for hqm_reorder_pipe
//
hqm_reorder_pipe_pf_init i_hqm_reorder_pipe_pf_init (
  .hqm_gated_clk        ( hqm_gated_clk )
, .hqm_gated_rst_n      ( hqm_gated_rst_n )
, .hqm_gated_rst_n_done ( hqm_gated_rst_n_done )
, .pf_reset_active      ( pf_reset_active )
, .hqm_gated_rst_n_start  ( hqm_gated_rst_n_start )

, .pf_reord_dirhp_mem_re ( pf_reord_dirhp_mem_re )
, .pf_reord_dirhp_mem_raddr ( pf_reord_dirhp_mem_raddr )
, .pf_reord_dirhp_mem_waddr ( pf_reord_dirhp_mem_waddr )
, .pf_reord_dirhp_mem_we ( pf_reord_dirhp_mem_we )
, .pf_reord_dirhp_mem_wdata ( pf_reord_dirhp_mem_wdata )
, .pf_reord_dirhp_mem_rdata ( pf_reord_dirhp_mem_rdata )
, .pf_lsp_reordercmp_fifo_mem_re ( pf_lsp_reordercmp_fifo_mem_re )
, .pf_lsp_reordercmp_fifo_mem_raddr ( pf_lsp_reordercmp_fifo_mem_raddr )
, .pf_lsp_reordercmp_fifo_mem_waddr ( pf_lsp_reordercmp_fifo_mem_waddr )
, .pf_lsp_reordercmp_fifo_mem_we ( pf_lsp_reordercmp_fifo_mem_we )
, .pf_lsp_reordercmp_fifo_mem_wdata ( pf_lsp_reordercmp_fifo_mem_wdata )
, .pf_lsp_reordercmp_fifo_mem_rdata ( pf_lsp_reordercmp_fifo_mem_rdata )
, .pf_sn1_order_shft_mem_re ( pf_sn1_order_shft_mem_re )
, .pf_sn1_order_shft_mem_raddr ( pf_sn1_order_shft_mem_raddr )
, .pf_sn1_order_shft_mem_waddr ( pf_sn1_order_shft_mem_waddr )
, .pf_sn1_order_shft_mem_we ( pf_sn1_order_shft_mem_we )
, .pf_sn1_order_shft_mem_wdata ( pf_sn1_order_shft_mem_wdata )
, .pf_sn1_order_shft_mem_rdata ( pf_sn1_order_shft_mem_rdata )
, .pf_sn_ordered_fifo_mem_re ( pf_sn_ordered_fifo_mem_re )
, .pf_sn_ordered_fifo_mem_raddr ( pf_sn_ordered_fifo_mem_raddr )
, .pf_sn_ordered_fifo_mem_waddr ( pf_sn_ordered_fifo_mem_waddr )
, .pf_sn_ordered_fifo_mem_we ( pf_sn_ordered_fifo_mem_we )
, .pf_sn_ordered_fifo_mem_wdata ( pf_sn_ordered_fifo_mem_wdata )
, .pf_sn_ordered_fifo_mem_rdata ( pf_sn_ordered_fifo_mem_rdata )
, .pf_ldb_rply_req_fifo_mem_re ( pf_ldb_rply_req_fifo_mem_re )
, .pf_ldb_rply_req_fifo_mem_raddr ( pf_ldb_rply_req_fifo_mem_raddr )
, .pf_ldb_rply_req_fifo_mem_waddr ( pf_ldb_rply_req_fifo_mem_waddr )
, .pf_ldb_rply_req_fifo_mem_we ( pf_ldb_rply_req_fifo_mem_we )
, .pf_ldb_rply_req_fifo_mem_wdata ( pf_ldb_rply_req_fifo_mem_wdata )
, .pf_ldb_rply_req_fifo_mem_rdata ( pf_ldb_rply_req_fifo_mem_rdata )
, .pf_sn_complete_fifo_mem_re ( pf_sn_complete_fifo_mem_re )
, .pf_sn_complete_fifo_mem_raddr ( pf_sn_complete_fifo_mem_raddr )
, .pf_sn_complete_fifo_mem_waddr ( pf_sn_complete_fifo_mem_waddr )
, .pf_sn_complete_fifo_mem_we ( pf_sn_complete_fifo_mem_we )
, .pf_sn_complete_fifo_mem_wdata ( pf_sn_complete_fifo_mem_wdata )
, .pf_sn_complete_fifo_mem_rdata ( pf_sn_complete_fifo_mem_rdata )
, .pf_dir_rply_req_fifo_mem_re ( pf_dir_rply_req_fifo_mem_re )
, .pf_dir_rply_req_fifo_mem_raddr ( pf_dir_rply_req_fifo_mem_raddr )
, .pf_dir_rply_req_fifo_mem_waddr ( pf_dir_rply_req_fifo_mem_waddr )
, .pf_dir_rply_req_fifo_mem_we ( pf_dir_rply_req_fifo_mem_we )
, .pf_dir_rply_req_fifo_mem_wdata ( pf_dir_rply_req_fifo_mem_wdata )
, .pf_dir_rply_req_fifo_mem_rdata ( pf_dir_rply_req_fifo_mem_rdata )
, .pf_chp_rop_hcw_fifo_mem_re ( pf_rop_chp_rop_hcw_fifo_mem_re )
, .pf_chp_rop_hcw_fifo_mem_raddr ( pf_rop_chp_rop_hcw_fifo_mem_raddr )
, .pf_chp_rop_hcw_fifo_mem_waddr ( pf_rop_chp_rop_hcw_fifo_mem_waddr )
, .pf_chp_rop_hcw_fifo_mem_we ( pf_rop_chp_rop_hcw_fifo_mem_we )
, .pf_chp_rop_hcw_fifo_mem_wdata ( pf_rop_chp_rop_hcw_fifo_mem_wdata )
, .pf_chp_rop_hcw_fifo_mem_rdata ( pf_rop_chp_rop_hcw_fifo_mem_rdata )
, .pf_reord_cnt_mem_re ( pf_reord_cnt_mem_re )
, .pf_reord_cnt_mem_raddr ( pf_reord_cnt_mem_raddr )
, .pf_reord_cnt_mem_waddr ( pf_reord_cnt_mem_waddr )
, .pf_reord_cnt_mem_we ( pf_reord_cnt_mem_we )
, .pf_reord_cnt_mem_wdata ( pf_reord_cnt_mem_wdata )
, .pf_reord_cnt_mem_rdata ( pf_reord_cnt_mem_rdata )
, .pf_reord_dirtp_mem_re ( pf_reord_dirtp_mem_re )
, .pf_reord_dirtp_mem_raddr ( pf_reord_dirtp_mem_raddr )
, .pf_reord_dirtp_mem_waddr ( pf_reord_dirtp_mem_waddr )
, .pf_reord_dirtp_mem_we ( pf_reord_dirtp_mem_we )
, .pf_reord_dirtp_mem_wdata ( pf_reord_dirtp_mem_wdata )
, .pf_reord_dirtp_mem_rdata ( pf_reord_dirtp_mem_rdata )
, .pf_reord_st_mem_re ( pf_reord_st_mem_re )
, .pf_reord_st_mem_raddr ( pf_reord_st_mem_raddr )
, .pf_reord_st_mem_waddr ( pf_reord_st_mem_waddr )
, .pf_reord_st_mem_we ( pf_reord_st_mem_we )
, .pf_reord_st_mem_wdata ( pf_reord_st_mem_wdata )
, .pf_reord_st_mem_rdata ( pf_reord_st_mem_rdata )
, .pf_reord_lbtp_mem_re ( pf_reord_lbtp_mem_re )
, .pf_reord_lbtp_mem_raddr ( pf_reord_lbtp_mem_raddr )
, .pf_reord_lbtp_mem_waddr ( pf_reord_lbtp_mem_waddr )
, .pf_reord_lbtp_mem_we ( pf_reord_lbtp_mem_we )
, .pf_reord_lbtp_mem_wdata ( pf_reord_lbtp_mem_wdata )
, .pf_reord_lbtp_mem_rdata ( pf_reord_lbtp_mem_rdata )
, .pf_sn0_order_shft_mem_re ( pf_sn0_order_shft_mem_re )
, .pf_sn0_order_shft_mem_raddr ( pf_sn0_order_shft_mem_raddr )
, .pf_sn0_order_shft_mem_waddr ( pf_sn0_order_shft_mem_waddr )
, .pf_sn0_order_shft_mem_we ( pf_sn0_order_shft_mem_we )
, .pf_sn0_order_shft_mem_wdata ( pf_sn0_order_shft_mem_wdata )
, .pf_sn0_order_shft_mem_rdata ( pf_sn0_order_shft_mem_rdata )
, .pf_reord_lbhp_mem_re ( pf_reord_lbhp_mem_re )
, .pf_reord_lbhp_mem_raddr ( pf_reord_lbhp_mem_raddr )
, .pf_reord_lbhp_mem_waddr ( pf_reord_lbhp_mem_waddr )
, .pf_reord_lbhp_mem_we ( pf_reord_lbhp_mem_we )
, .pf_reord_lbhp_mem_wdata ( pf_reord_lbhp_mem_wdata )
, .pf_reord_lbhp_mem_rdata ( pf_reord_lbhp_mem_rdata )

);



//---------------------------------------------------------------------------------------------------------
// common core - Interrupt serializer. Capture all interrutps from unit and send on interrupt ring
logic   [ ( $bits(rop_alarm_down_data.unit) -1 ) : 0]   rop_unit;

assign rop_unit = HQM_ROP_CFG_UNIT_ID; 


hqm_AW_int_serializer # (
         .NUM_INF ( HQM_ROP_ALARM_NUM_INF )
        ,.NUM_COR ( HQM_ROP_ALARM_NUM_COR )
        ,.NUM_UNC ( HQM_ROP_ALARM_NUM_UNC )
) i_int_serializer (

         .hqm_inp_gated_clk ( hqm_inp_gated_clk )
        ,.hqm_inp_gated_rst_n (hqm_inp_gated_rst_n )
        ,.rst_prep       ( rst_prep )

        ,.unit           ( rop_unit )

        ,.inf_v          ( int_inf_v )
        ,.inf_data       ( int_inf_data )

        ,.cor_v          ( int_cor_v )
        ,.cor_data       ( int_cor_data )

        ,.unc_v          ( int_unc_v )
        ,.unc_data       ( int_unc_data )

        ,.int_up_v       ( rop_alarm_up_v )
        ,.int_up_data    ( rop_alarm_up_data )
        ,.int_up_ready   ( rop_alarm_up_ready )

        ,.int_down_v     ( rop_alarm_down_v )
        ,.int_down_data  ( rop_alarm_down_data )
        ,.int_down_ready ( rop_alarm_down_ready )

        ,.status         ( int_serializer_status )

        ,.int_idle       ( int_idle )
);

always_comb begin

    //CFG correction code logic
    cfg_mem_cc_v                                = '0;
    cfg_mem_cc_value                            = '0;
    cfg_mem_cc_width                            = '0;
    cfg_mem_cc_position                         = '0;
    cfgsc_residue_gen_a = '0 ;

    if ( cfg_req_write [ HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT* 1 +: 1 ]  ) begin
      cfgsc_residue_gen_a = { { ( 32 - 10 ) { 1'b0 } }
                            , cfg_mem_wdata [ 10 - 1 : 0 ] } ;
      cfg_mem_cc_v = 1'b1 ;
      cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
      cfg_mem_cc_width = 4'd2 ;
      cfg_mem_cc_position = 12'd10;
    end

    if ( cfg_req_write [ HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT* 1 +: 1 ]  ) begin
      cfgsc_residue_gen_a = { { ( 32 - 10 ) { 1'b0 } }
                            , cfg_mem_wdata [ 10 - 1 : 0 ] } ;
      cfg_mem_cc_v = 1'b1 ;
      cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
      cfg_mem_cc_width = 4'd2 ;
      cfg_mem_cc_position = 12'd10;
    end

end

 hqm_AW_residue_gen # (
    .WIDTH                               ( 32 )
 ) i_residue_gen_freelist (
    .a                                   ( cfgsc_residue_gen_a )
  , .r                                   ( cfgsc_residue_gen_r )
 ) ;

// start done this way to address linra 0527 messages
assign hqm_rop_target_cfg_syndrome_00_syndrome_data_nc = hqm_rop_target_cfg_syndrome_00_syndrome_data ;
assign hqm_rop_target_cfg_syndrome_01_syndrome_data_nc = hqm_rop_target_cfg_syndrome_01_syndrome_data ;
// end done this way to address linra 0527 messages

endmodule // hqm_reorder_pipe_core
// 
