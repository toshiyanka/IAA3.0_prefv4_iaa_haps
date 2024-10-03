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
module hqm_reorder_pipe
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
, input  logic [BITS_CFG_REQ_T-1:0]     rop_cfg_req_up
, input  logic                          rop_cfg_rsp_up_ack
, input  logic [BITS_CFG_RSP_T-1:0]     rop_cfg_rsp_up
, output logic                          rop_cfg_req_down_read
, output logic                          rop_cfg_req_down_write
, output logic [BITS_CFG_REQ_T-1:0]     rop_cfg_req_down
, output logic                          rop_cfg_rsp_down_ack
, output logic [BITS_CFG_RSP_T-1:0]     rop_cfg_rsp_down
                                        
// interrupt interface                  
, input  logic                          rop_alarm_up_v
, output logic                          rop_alarm_up_ready
, input  logic [BITS_AW_ALARM_T-1:0]    rop_alarm_up_data
                                        
, output logic                          rop_alarm_down_v
, input  logic                          rop_alarm_down_ready
, output logic [BITS_AW_ALARM_T-1:0]    rop_alarm_down_data
                                        
                                        
// chp_rop_hcw interface                
, input  logic                          chp_rop_hcw_v
, output logic                          chp_rop_hcw_ready
, input  logic [BITS_CHP_ROP_HCW_T-1:0]     chp_rop_hcw_data
                                        
// rop_dp_enq interface                 
, output logic                          rop_dp_enq_v
, input  logic                          rop_dp_enq_ready
, output logic [BITS_ROP_DP_ENQ_T-1:0]  rop_dp_enq_data
                                        
// rop_nalb_enq interface               
, output logic                          rop_nalb_enq_v
, input  logic                          rop_nalb_enq_ready
, output logic [BITS_ROP_NALB_ENQ_T-1:0]    rop_nalb_enq_data
                                        
// rop_qed_dqed_enq interface           
, output logic                          rop_qed_dqed_enq_v
, input  logic                          rop_qed_enq_ready
, input  logic                          rop_dqed_enq_ready
, output logic [BITS_ROP_QED_DQED_ENQ_T-1:0]    rop_qed_dqed_enq_data
, output logic                          rop_qed_force_clockon
                                        
// rop_lsp_reordercmp interface        
, output logic                          rop_lsp_reordercmp_v
, input  logic                          rop_lsp_reordercmp_ready
, output logic [BITS_ROP_LSP_REORDERCMP_T-1:0]  rop_lsp_reordercmp_data

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

`ifndef HQM_VISA_ELABORATE

// collage-pragma translate_off

hqm_reorder_pipe_core i_hqm_reorder_pipe_core (.*);

// collage-pragma translate_on

`endif

endmodule // hqm_reorder_pipe
