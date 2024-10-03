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
// hqm_reorder_pipe_pf_init
//
//
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_reorder_pipe_pf_init
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
  input   logic                          hqm_gated_clk
, input   logic                          hqm_gated_rst_n
, output  logic                          hqm_gated_rst_n_done
, output  logic                          pf_reset_active
, input   logic                          hqm_gated_rst_n_start

, output  logic pf_reord_dirhp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_dirhp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_dirhp_mem_waddr
, output  logic pf_reord_dirhp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] pf_reord_dirhp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] pf_reord_dirhp_mem_rdata
, output  logic pf_lsp_reordercmp_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] pf_lsp_reordercmp_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] pf_lsp_reordercmp_fifo_mem_waddr
, output  logic pf_lsp_reordercmp_fifo_mem_we
, output  logic [ ( 19 ) - 1 : 0 ] pf_lsp_reordercmp_fifo_mem_wdata
, input   logic [ ( 19 ) - 1 : 0 ] pf_lsp_reordercmp_fifo_mem_rdata
, output  logic pf_sn1_order_shft_mem_re
, output  logic [ ( 4 ) - 1 : 0 ] pf_sn1_order_shft_mem_raddr
, output  logic [ ( 4 ) - 1 : 0 ] pf_sn1_order_shft_mem_waddr
, output  logic pf_sn1_order_shft_mem_we
, output  logic [ ( 12 ) - 1 : 0 ] pf_sn1_order_shft_mem_wdata
, input   logic [ ( 12 ) - 1 : 0 ] pf_sn1_order_shft_mem_rdata
, output  logic pf_sn_ordered_fifo_mem_re
, output  logic [ ( 5 ) - 1 : 0 ] pf_sn_ordered_fifo_mem_raddr
, output  logic [ ( 5 ) - 1 : 0 ] pf_sn_ordered_fifo_mem_waddr
, output  logic pf_sn_ordered_fifo_mem_we
, output  logic [ ( 13 ) - 1 : 0 ] pf_sn_ordered_fifo_mem_wdata
, input   logic [ ( 13 ) - 1 : 0 ] pf_sn_ordered_fifo_mem_rdata
, output  logic pf_ldb_rply_req_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] pf_ldb_rply_req_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] pf_ldb_rply_req_fifo_mem_waddr
, output  logic pf_ldb_rply_req_fifo_mem_we
, output  logic [ ( 60 ) - 1 : 0 ] pf_ldb_rply_req_fifo_mem_wdata
, input   logic [ ( 60 ) - 1 : 0 ] pf_ldb_rply_req_fifo_mem_rdata
, output  logic pf_sn_complete_fifo_mem_re
, output  logic [ ( 2 ) - 1 : 0 ] pf_sn_complete_fifo_mem_raddr
, output  logic [ ( 2 ) - 1 : 0 ] pf_sn_complete_fifo_mem_waddr
, output  logic pf_sn_complete_fifo_mem_we
, output  logic [ ( 21 ) - 1 : 0 ] pf_sn_complete_fifo_mem_wdata
, input   logic [ ( 21 ) - 1 : 0 ] pf_sn_complete_fifo_mem_rdata
, output  logic pf_dir_rply_req_fifo_mem_re
, output  logic [ ( 3 ) - 1 : 0 ] pf_dir_rply_req_fifo_mem_raddr
, output  logic [ ( 3 ) - 1 : 0 ] pf_dir_rply_req_fifo_mem_waddr
, output  logic pf_dir_rply_req_fifo_mem_we
, output  logic [ ( 60 ) - 1 : 0 ] pf_dir_rply_req_fifo_mem_wdata
, input   logic [ ( 60 ) - 1 : 0 ] pf_dir_rply_req_fifo_mem_rdata
, output  logic pf_chp_rop_hcw_fifo_mem_re
, output  logic [ ( 2 ) - 1 : 0 ] pf_chp_rop_hcw_fifo_mem_raddr
, output  logic [ ( 2 ) - 1 : 0 ] pf_chp_rop_hcw_fifo_mem_waddr
, output  logic pf_chp_rop_hcw_fifo_mem_we
, output  logic [ ( 204 ) - 1 : 0 ] pf_chp_rop_hcw_fifo_mem_wdata
, input   logic [ ( 204 ) - 1 : 0 ] pf_chp_rop_hcw_fifo_mem_rdata
, output  logic pf_reord_cnt_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_cnt_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_cnt_mem_waddr
, output  logic pf_reord_cnt_mem_we
, output  logic [ ( 14 ) - 1 : 0 ] pf_reord_cnt_mem_wdata
, input   logic [ ( 14 ) - 1 : 0 ] pf_reord_cnt_mem_rdata
, output  logic pf_reord_dirtp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_dirtp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_dirtp_mem_waddr
, output  logic pf_reord_dirtp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] pf_reord_dirtp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] pf_reord_dirtp_mem_rdata
, output  logic pf_reord_st_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_st_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_st_mem_waddr
, output  logic pf_reord_st_mem_we
, output  logic [ ( 23 ) - 1 : 0 ] pf_reord_st_mem_wdata
, input   logic [ ( 23 ) - 1 : 0 ] pf_reord_st_mem_rdata
, output  logic pf_reord_lbtp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_lbtp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_lbtp_mem_waddr
, output  logic pf_reord_lbtp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] pf_reord_lbtp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] pf_reord_lbtp_mem_rdata
, output  logic pf_sn0_order_shft_mem_re
, output  logic [ ( 4 ) - 1 : 0 ] pf_sn0_order_shft_mem_raddr
, output  logic [ ( 4 ) - 1 : 0 ] pf_sn0_order_shft_mem_waddr
, output  logic pf_sn0_order_shft_mem_we
, output  logic [ ( 12 ) - 1 : 0 ] pf_sn0_order_shft_mem_wdata
, input   logic [ ( 12 ) - 1 : 0 ] pf_sn0_order_shft_mem_rdata
, output  logic pf_reord_lbhp_mem_re
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_lbhp_mem_raddr
, output  logic [ ( 11 ) - 1 : 0 ] pf_reord_lbhp_mem_waddr
, output  logic pf_reord_lbhp_mem_we
, output  logic [ ( 15 ) - 1 : 0 ] pf_reord_lbhp_mem_wdata
, input   logic [ ( 15 ) - 1 : 0 ] pf_reord_lbhp_mem_rdata

);


localparam HQM_ROP_NUM_SN = 2048;
localparam HQM_ROP_NUM_SN_B2 = (AW_logb2(HQM_ROP_NUM_SN-1)+1);

logic [ (32) -1 : 0 ]  reset_pf_counter_nxt, reset_pf_counter_f ;
logic hw_init_done_f, hw_init_done_nxt ;
logic reset_pf_active_f , reset_pf_active_nxt ;
logic reset_pf_done_f , reset_pf_done_nxt ;

assign hqm_gated_rst_n_done = reset_pf_done_f ;

logic [((HQM_NUM_SN_GRP*1) -1) : 0]    pf_sn_order_shft_mem_we;
logic [((HQM_NUM_SN_GRP*5) -1) : 0]    pf_sn_order_shft_mem_waddr;
logic [((HQM_NUM_SN_GRP*12) -1) : 0]   pf_sn_order_shft_mem_wdata_nnc;
logic [((HQM_NUM_SN_GRP*12) -1) : 0]   pf_sn_order_shft_mem_rdata_nc;


// pf functions
generate
if (HQM_NUM_SN_GRP>0) begin
assign pf_sn0_order_shft_mem_re    = '0;
assign pf_sn0_order_shft_mem_raddr = '0;  
assign pf_sn0_order_shft_mem_waddr = pf_sn_order_shft_mem_waddr[0*5  +:  4]; 
assign pf_sn0_order_shft_mem_we    = pf_sn_order_shft_mem_we     [0*1  +:  1];  
assign pf_sn0_order_shft_mem_wdata = pf_sn_order_shft_mem_wdata_nnc[0*12 +: 12]; 
assign pf_sn_order_shft_mem_rdata_nc [0*12 +: 12] = pf_sn0_order_shft_mem_rdata;
end else begin
assign pf_sn0_order_shft_mem_re    = '0;
assign pf_sn0_order_shft_mem_raddr = '0;  
assign pf_sn0_order_shft_mem_waddr = '0;
assign pf_sn0_order_shft_mem_we    = '0;
assign pf_sn0_order_shft_mem_wdata = '0;
end

if (HQM_NUM_SN_GRP>1) begin
assign pf_sn1_order_shft_mem_re    = '0;
assign pf_sn1_order_shft_mem_raddr = '0;  
assign pf_sn1_order_shft_mem_waddr = pf_sn_order_shft_mem_waddr[1*5  +:  4]; 
assign pf_sn1_order_shft_mem_we    = pf_sn_order_shft_mem_we     [1*1  +:  1];  
assign pf_sn1_order_shft_mem_wdata = pf_sn_order_shft_mem_wdata_nnc[1*12 +: 12]; 
assign pf_sn_order_shft_mem_rdata_nc [1*12 +: 12] = pf_sn1_order_shft_mem_rdata;
end else begin
assign pf_sn1_order_shft_mem_re    = '0;
assign pf_sn1_order_shft_mem_raddr = '0;  
assign pf_sn1_order_shft_mem_waddr = '0; 
assign pf_sn1_order_shft_mem_we    = '0;  
assign pf_sn1_order_shft_mem_wdata = '0; 
end

endgenerate

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
    reset_pf_counter_f <= '0 ;
    reset_pf_active_f <= 1'b1 ;
    reset_pf_done_f <= '0 ;
    hw_init_done_f <= '0 ;
  end
  else begin
    reset_pf_counter_f <= reset_pf_counter_nxt ;
    reset_pf_active_f <= reset_pf_active_nxt ;
    reset_pf_done_f <= reset_pf_done_nxt ;
    hw_init_done_f <= hw_init_done_nxt ;
  end
end


always_comb begin

        reset_pf_counter_nxt = reset_pf_counter_f ;
        reset_pf_active_nxt = reset_pf_active_f ;
        reset_pf_done_nxt = reset_pf_done_f ;
        hw_init_done_nxt = hw_init_done_f ;

         //....................................................................................................
         // PF reset
         pf_reord_st_mem_re             = '0 ;
         pf_reord_st_mem_raddr        = '0 ;
         pf_reord_st_mem_we = '0 ;
         pf_reord_st_mem_waddr = '0 ;
         pf_reord_st_mem_wdata = '0 ;
         pf_reord_lbhp_mem_re = '0 ;
         pf_reord_lbhp_mem_raddr        = '0 ;
         pf_reord_lbhp_mem_we = '0 ;
         pf_reord_lbhp_mem_waddr = '0 ;
         pf_reord_lbhp_mem_wdata = '0 ;
         pf_reord_lbtp_mem_re = '0 ;
         pf_reord_lbtp_mem_raddr = '0 ;
         pf_reord_lbtp_mem_we = '0 ;
         pf_reord_lbtp_mem_waddr = '0 ;
         pf_reord_lbtp_mem_wdata = '0 ;
         pf_reord_dirhp_mem_re = '0 ;
         pf_reord_dirhp_mem_raddr = '0 ;
         pf_reord_dirhp_mem_we = '0 ;
         pf_reord_dirhp_mem_waddr = '0 ;
         pf_reord_dirhp_mem_wdata = '0 ;
         pf_reord_dirtp_mem_re = '0 ;
         pf_reord_dirtp_mem_raddr = '0 ;
         pf_reord_dirtp_mem_we = '0 ;
         pf_reord_dirtp_mem_waddr = '0 ;
         pf_reord_dirtp_mem_wdata = '0 ;
         pf_reord_cnt_mem_re = '0 ;
         pf_reord_cnt_mem_raddr = '0 ;
         pf_reord_cnt_mem_we = '0 ;
         pf_reord_cnt_mem_waddr = '0 ;
         pf_reord_cnt_mem_wdata = '0 ;
         pf_sn_order_shft_mem_we = '0 ;
         pf_sn_order_shft_mem_waddr = '0 ;
         pf_sn_order_shft_mem_wdata_nnc = '0 ;
         pf_lsp_reordercmp_fifo_mem_re = '0 ;
         pf_lsp_reordercmp_fifo_mem_raddr = '0 ;
         pf_lsp_reordercmp_fifo_mem_waddr = '0 ;
         pf_lsp_reordercmp_fifo_mem_we = '0 ;
         pf_lsp_reordercmp_fifo_mem_wdata = '0 ;
         pf_sn_complete_fifo_mem_re = '0 ;
         pf_sn_complete_fifo_mem_raddr = '0 ;
         pf_sn_complete_fifo_mem_waddr = '0 ;
         pf_sn_complete_fifo_mem_we = '0 ;
         pf_sn_complete_fifo_mem_wdata = '0 ;
         pf_ldb_rply_req_fifo_mem_re = '0 ;
         pf_ldb_rply_req_fifo_mem_raddr = '0 ;
         pf_ldb_rply_req_fifo_mem_waddr = '0 ;
         pf_ldb_rply_req_fifo_mem_we = '0 ;
         pf_ldb_rply_req_fifo_mem_wdata = '0 ;
         pf_sn_ordered_fifo_mem_re = '0 ;
         pf_sn_ordered_fifo_mem_raddr = '0 ;
         pf_sn_ordered_fifo_mem_waddr = '0 ;
         pf_sn_ordered_fifo_mem_we = '0 ;
         pf_sn_ordered_fifo_mem_wdata = '0 ;
         pf_chp_rop_hcw_fifo_mem_re = '0 ;
         pf_chp_rop_hcw_fifo_mem_raddr = '0 ;
         pf_chp_rop_hcw_fifo_mem_waddr = '0 ;
         pf_chp_rop_hcw_fifo_mem_we = '0 ;
         pf_chp_rop_hcw_fifo_mem_wdata = '0 ;
         pf_dir_rply_req_fifo_mem_re = '0 ;
         pf_dir_rply_req_fifo_mem_raddr = '0 ;
         pf_dir_rply_req_fifo_mem_waddr = '0 ;
         pf_dir_rply_req_fifo_mem_we = '0 ;
         pf_dir_rply_req_fifo_mem_wdata = '0 ;
         pf_reset_active = '0 ;

         if ( hqm_gated_rst_n_start & reset_pf_active_f & ~hw_init_done_f ) begin
             pf_reset_active = 1'b1 ;
             reset_pf_counter_nxt                   = reset_pf_counter_f + 32'd1;

             if ( reset_pf_counter_f < HQM_ROP_NUM_SN ) begin
 
                pf_reord_st_mem_we            = 1'b1; 
                pf_reord_st_mem_waddr       = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0] ;
                pf_reord_st_mem_wdata       = '0;
                                                     
                pf_reord_lbhp_mem_we          = 1'b1;
                pf_reord_lbhp_mem_waddr     = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0];  
                pf_reord_lbhp_mem_wdata     = '0;
                                        
                pf_reord_lbtp_mem_we          = 1'b1;
                pf_reord_lbtp_mem_waddr     = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0];
                pf_reord_lbtp_mem_wdata     = '0;
                                                     
                pf_reord_dirhp_mem_we         = 1'b1;
                pf_reord_dirhp_mem_waddr    = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0] ;
                pf_reord_dirhp_mem_wdata    = '0 ;
                                                     
                pf_reord_dirtp_mem_we         = 1'b1;
                pf_reord_dirtp_mem_waddr    = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0] ;
                pf_reord_dirtp_mem_wdata    = '0;
                                                     
                pf_reord_cnt_mem_we           = 1'b1;
                pf_reord_cnt_mem_waddr      = reset_pf_counter_f[HQM_ROP_NUM_SN_B2 -1 : 0] ;
                pf_reord_cnt_mem_wdata      = '0;

                pf_sn_order_shft_mem_we       = {HQM_NUM_SN_GRP{1'b1}};
                pf_sn_order_shft_mem_waddr  = {HQM_NUM_SN_GRP{1'b0,reset_pf_counter_f[3:0]}};
                pf_sn_order_shft_mem_wdata_nnc  = '0;

             end
             else begin
                hw_init_done_nxt                    = 1'b1 ;
                reset_pf_counter_nxt                = '0 ;
             end
         end

         if ( reset_pf_active_f ) begin
             if ( hw_init_done_f ) begin
               reset_pf_counter_nxt = 32'd0 ;
               reset_pf_active_nxt = 1'b0 ;
               reset_pf_done_nxt = 1'b1 ;
               hw_init_done_nxt = 1'b0 ;
             end
         end
end

logic hqm_reorder_pipe_pf_init_nc;
assign hqm_reorder_pipe_pf_init_nc = (|pf_reord_dirhp_mem_rdata) | 
                                     (|pf_lsp_reordercmp_fifo_mem_rdata) |
                                     (|pf_sn_ordered_fifo_mem_rdata ) |
                                     (|pf_ldb_rply_req_fifo_mem_rdata ) |
                                     (|pf_sn_complete_fifo_mem_rdata ) |
                                     (|pf_dir_rply_req_fifo_mem_rdata ) |
                                     (|pf_chp_rop_hcw_fifo_mem_rdata ) |
                                     (|pf_reord_cnt_mem_rdata ) |
                                     (|pf_reord_dirtp_mem_rdata ) |
                                     (|pf_reord_st_mem_rdata ) |
                                     (|pf_reord_lbtp_mem_rdata ) |
                                     (|pf_reord_lbhp_mem_rdata );

endmodule // hqm_reorder_pipe_pf_init
// 
