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
// This module hqm_chp_wd_clkreq handled transfer of wd cq expiry events from pgcb_clk domain to hqm_gated_clock domai.
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_wd_clkreq 
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_NUM_TIM_CQ = 128
 // derived
 ,parameter HQM_NUM_TIM_CQ_B2 = (AW_logb2 ( HQM_NUM_TIM_CQ -1 ) + 1)

) (
    input  logic                                       hqm_pgcb_clk
  , input  logic                                       hqm_pgcb_rst_n
                                                       
  , input  logic                                       hqm_gated_clk
  , input  logic                                       hqm_gated_rst_n

  , output logic                                       wd_clkreq

  , input  logic [HQM_NUM_TIM_CQ-1:0]                  expiry

  , output logic [HQM_NUM_TIM_CQ-1:0]                  cq_expiry_dest

  , input  logic                                       hqm_flr_prep_b_sync_pgcb_clk
                                           
);


logic [HQM_NUM_TIM_CQ-1:0]      expiry_f;
logic [HQM_NUM_TIM_CQ-1:0]      expiry_arb;
logic [HQM_NUM_TIM_CQ-1:0]      expiry_nxt;
logic                           exp_arb_update;
logic                           exp_arb_winner_v;
logic [HQM_NUM_TIM_CQ_B2-1:0]   exp_arb_winner;
logic                           data_nxt, data_f;
logic [HQM_NUM_TIM_CQ_B2-1:0]   data_cq_f;

logic [HQM_NUM_TIM_CQ-1:0]      expiry_clear;

logic                           data_reset_src_f;
logic                           data_reset;
logic                           data_reset_f;
logic                           data_sync;
logic                           data_f_sync;
logic                           data_f_sync_dest_f;
logic                           data_reset_done;

// these flops are added to address spyglass cdc warning about glitches
logic [HQM_NUM_TIM_CQ_B2-1:0]   destination_cq_f;
logic [HQM_NUM_TIM_CQ_B2-1:0]   destination_cq_nxt;
logic                           destination_cq_v_f;

// set request when we have expiry events or we have arbitrated for cq and have valid entry in the flops
assign wd_clkreq = ((|expiry_nxt) && ~hqm_flr_prep_b_sync_pgcb_clk) || (data_nxt && ~hqm_flr_prep_b_sync_pgcb_clk);

always_comb begin
  expiry_nxt = (expiry_f | expiry) & ~expiry_clear;
  expiry_arb = expiry_f & {HQM_NUM_TIM_CQ{data_reset_done}}; // gate of input to arbiter if we have vlid cq being xfered
  data_nxt = (exp_arb_winner_v | data_f) & ~data_reset;
end

hqm_AW_rr_arb # (
    .NUM_REQS ( HQM_NUM_TIM_CQ )
) i_exp_arb (
    .clk                                (hqm_pgcb_clk)
  , .rst_n                              (hqm_pgcb_rst_n)
  , .reqs                               (expiry_arb)
  , .update                             (exp_arb_update)
  , .winner_v                           (exp_arb_winner_v )
  , .winner                             (exp_arb_winner )
) ;

assign exp_arb_update = exp_arb_winner_v ;

generate
if (HQM_NUM_TIM_CQ>64) begin : scaled_0_cq_gt_64
logic [(128-HQM_NUM_TIM_CQ)-1:0]      expiry_clear_nc;
hqm_AW_bindec #( .WIDTH ( HQM_NUM_TIM_CQ_B2 ) ) i_exp_arb_update (.a (exp_arb_winner) ,.enable (exp_arb_update) ,.dec ({expiry_clear_nc,expiry_clear}));
end else begin : scaled_0_cq_le_64
hqm_AW_bindec #( .WIDTH ( HQM_NUM_TIM_CQ_B2 ) ) i_exp_arb_update (.a (exp_arb_winner) ,.enable (exp_arb_update) ,.dec (expiry_clear));
end

endgenerate


// register and hold source valid and cq and reset only when seen in destination
always_ff @(posedge hqm_pgcb_clk or negedge hqm_pgcb_rst_n) begin
  if (~hqm_pgcb_rst_n) begin
    expiry_f <= '0; 
    data_cq_f <= '0;
    data_f <= '0;
    data_reset_src_f <= '0;
  end else begin
    expiry_f <= expiry_nxt; 
    data_cq_f <= exp_arb_winner_v ? exp_arb_winner : data_cq_f; // hold data and load it once per xfer
    data_f <= data_nxt; 
    data_reset_src_f <= data_reset_f;
  end
end

assign data_reset = data_reset_f & ~data_reset_src_f;
assign data_reset_done = ~data_f & ~data_reset_f & ~data_reset_src_f; // we are ok to arbitrate for another event only when the data_f=0 has propagated all the way around pgcb_clk->hqm_gated_clk->pgcb_clk.

// sync src valid to destination
hqm_AW_sync_rst0 #(.WIDTH(1)) u_data_f_sync (
        .clk            (hqm_gated_clk),
        .rst_n          (hqm_gated_rst_n),
        .data           (data_f),
        .data_sync      (data_f_sync)
);

assign destination_cq_nxt = data_sync ? data_cq_f : destination_cq_f;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
      data_f_sync_dest_f <= 1'b0; 
      destination_cq_f <= '0;
      destination_cq_v_f <= 1'b0;
  end else begin
      data_f_sync_dest_f <= data_f_sync; 
      destination_cq_f <= destination_cq_nxt;
      destination_cq_v_f <= data_sync;
  end
end

// use edge detect to generate valud in destination domain
assign data_sync = data_f_sync & ~data_f_sync_dest_f;

// Sync destination back to source as the reset trigger
hqm_AW_sync_rst0 #(.WIDTH(1)) u_data_reset_q (
        .clk            (hqm_pgcb_clk),
        .rst_n          (hqm_pgcb_rst_n),
        .data           (data_f_sync),
        .data_sync      (data_reset_f)
);

generate
if (HQM_NUM_TIM_CQ>64) begin : scaled_1_cq_gt_64
  logic [(128-HQM_NUM_TIM_CQ)-1:0]                      cq_expiry_dest_nc;
hqm_AW_bindec #( .WIDTH ( HQM_NUM_TIM_CQ_B2 ) ) i_cq_dec (.a (destination_cq_f) ,.enable (destination_cq_v_f) ,.dec ({cq_expiry_dest_nc,cq_expiry_dest}));
end else begin : scaled_1_cq_le_64
hqm_AW_bindec #( .WIDTH ( HQM_NUM_TIM_CQ_B2 ) ) i_cq_dec (.a (destination_cq_f) ,.enable (destination_cq_v_f) ,.dec (cq_expiry_dest));
end
endgenerate

endmodule // hqm_chp_wd_clkreq
