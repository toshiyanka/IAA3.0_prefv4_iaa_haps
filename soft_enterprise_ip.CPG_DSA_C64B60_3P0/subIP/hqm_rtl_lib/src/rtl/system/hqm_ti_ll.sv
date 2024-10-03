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
//----------------------------------------------------------------------------------------------------

module hqm_ti_ll

     import hqm_AW_pkg::*, hqm_sif_pkg::*, hqm_sif_csr_pkg::*;
(

     input  logic                                           prim_nonflr_clk
    ,input  logic                                           prim_gated_rst_b

    ,input  MSTR_LL_CTL_t                                   cfg_mstr_ll_ctl     // Linked list status control

    ,output new_MSTR_FL_STATUS_t                            mstr_fl_status      // Freelist status
    ,output new_MSTR_LL_STATUS_t                            mstr_ll_status      // Linked list status

    ,input  logic                                           fl2ll_v             // Pop FL, push LL
    ,input  logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]              fl2ll_ll            // LL to push

    ,input  logic                                           ll_pop              // Pop LL
    ,input  logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]              ll_pop_ll           // LL to pop

    ,input  logic                                           fl_push             // Push FL
    ,input  logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]             fl_push_ptr         // Ptr to push

    ,output logic                                           fl_empty            // FL empty
    ,output logic                                           fl_aempty           // FL <= limit
    ,output logic                                           fl_full             // FL full
    ,output logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]             fl_hptr             // FL head pointer

    ,output logic [HQM_MSTR_NUM_LLS-1:0]                    ll_v                // LL valids
    ,output logic [(HQM_MSTR_NUM_LLS *
                    HQM_MSTR_FL_DEPTH_WIDTH)-1:0]           ll_hptr             // LL head pointers

    ,input  logic [HQM_MSTR_FL_DEPTH-1:0]                   blk_v_q             // Block valid status
    ,input  logic [HQM_MSTR_FL_DEPTH-1:0]                   msix_v_q            // MSIX  valid status

    ,input  logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]         hpa_v_scaled        // HPA valid status
    ,input  logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]         hpa_err_scaled      // HPA error flag
    ,input  logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]         hpa_pnd_scaled      // HPA pending flag

    ,output logic                                           clr_hpa_err         // Clear the HPA error
    ,output logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]              clr_hpa_err_cq      //  for VAS reset
);

//----------------------------------------------------------------------------------------------------

localparam HQM_MSTR_FL_DEPTH_M1  = HQM_MSTR_FL_DEPTH-1;

// Linked list blocks

logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       blk_ptr_next[HQM_MSTR_FL_DEPTH-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       blk_ptr_q[HQM_MSTR_FL_DEPTH-1:0];

// Freelist

logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       fl_hptr_next;
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       fl_hptr_q;
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       fl_tptr_next;
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       fl_tptr_q;
logic   [HQM_MSTR_FL_CNT_WIDTH-1:0]         fl_cnt_next;
logic   [HQM_MSTR_FL_CNT_WIDTH-1:0]         fl_cnt_q;
logic                                       fl_cnt_inc;
logic                                       fl_cnt_dec;
logic                                       fl_empty_next;
logic                                       fl_empty_q;
logic                                       fl_aempty_next;
logic                                       fl_aempty_q;
logic                                       fl_full_next;
logic                                       fl_full_q;

// Individual Linked Lists

logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_hptr_next[HQM_MSTR_NUM_LLS-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_hptr_q[HQM_MSTR_NUM_LLS-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_hptr_scaled[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_tptr_next[HQM_MSTR_NUM_LLS-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_tptr_q[HQM_MSTR_NUM_LLS-1:0];
logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]       ll_tptr_scaled[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0];
logic   [HQM_MSTR_NUM_LLS-1:0]              ll_v_next;
logic   [HQM_MSTR_NUM_LLS-1:0]              ll_v_q;
logic   [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]   ll_v_scaled;

new_MSTR_LL_STATUS_t                        mstr_ll_status_next;
new_MSTR_LL_STATUS_t                        mstr_ll_status_q;
logic [3:0]                                 mstr_ll_ctl_q;

//----------------------------------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  for (int i=0; i<(HQM_MSTR_FL_DEPTH-1); i=i+1) blk_ptr_q[i] <= i+1;
  blk_ptr_q[HQM_MSTR_FL_DEPTH-1] <= '0;
  fl_hptr_q   <= '0;
  fl_tptr_q   <= HQM_MSTR_FL_DEPTH_M1[HQM_MSTR_FL_DEPTH_WIDTH-1:0];
  fl_cnt_q    <= HQM_MSTR_FL_DEPTH[HQM_MSTR_FL_CNT_WIDTH-1:0];
  fl_empty_q  <= '0;
  fl_aempty_q <= '0;
  fl_full_q   <= '1;
  for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin
   ll_hptr_q[i] <= '0;
   ll_tptr_q[i] <= '0;
  end
  ll_v_q      <= '0;
 end else begin
  blk_ptr_q   <= blk_ptr_next;
  fl_hptr_q   <= fl_hptr_next;
  fl_tptr_q   <= fl_tptr_next;
  fl_cnt_q    <= fl_cnt_next;
  fl_empty_q  <= fl_empty_next;
  fl_aempty_q <= fl_aempty_next;
  fl_full_q   <= fl_full_next;
  ll_hptr_q   <= ll_hptr_next;
  ll_tptr_q   <= ll_tptr_next;
  ll_v_q      <= ll_v_next;
 end
end

//----------------------------------------------------------------------------------------------------
// On an input from the TI, a block is popped from the FL HP and pushed onto the appropriate LL TP.
// When an LL is valid for arbitration (LL not empty and any other conditions met) and wins, the block
// is popped from the winning LL HP and pushed onto the appropriate RL TP at the same time the request
// is sent to the interface.  When the request is granted, a block is popped from the granted RL HP
// and pushed back onto the FL TP completing the use of the block.
// So blocks are only moved from FL to LL[n], from LL[n] to RL[rtype], and from RL[rtype] back to FL.

always_comb begin

 blk_ptr_next = blk_ptr_q;

 fl_hptr_next = fl_hptr_q;
 fl_tptr_next = fl_tptr_q;
 fl_cnt_next  = fl_cnt_q;
 fl_cnt_inc   = '0;
 fl_cnt_dec   = '0;

 ll_hptr_next = ll_hptr_q;
 ll_tptr_next = ll_tptr_q;
 ll_v_next    = ll_v_q;

 //---------------------------------------------------------------------------------------------------

 if (fl2ll_v) begin // FL Pop

  // Pop a block off the FL HP and push it onto the referenced LL TP.
  // Need to update the referenced LL TP (and HP/V if LL is currently empty), update the FL HP, and
  // decrement the FL count.  If the LL is currently not empty, also need to update the block pointer
  // at the LL TP to link to the newly popped block.

  fl_hptr_next = blk_ptr_q[fl_hptr_q];
  fl_cnt_dec   = '1;

  if (ll_v_q[fl2ll_ll] & // Existing LL
      (~ll_pop | (fl2ll_ll != ll_pop_ll) | (ll_hptr_q[ll_pop_ll] != ll_tptr_q[ll_pop_ll]))) begin

   // If LL already exists, and not simultaneously consuming the single block currently on the LL
   // then link FL block at LL TP location and update LL TP

   blk_ptr_next[ll_tptr_q[fl2ll_ll]] = fl_hptr_q;
   ll_tptr_next[          fl2ll_ll]  = fl_hptr_q;

  end // Existing LL

  else begin // New LL

   // Make the LL valid and set the LL HP and TP to the FL block popped

   ll_v_next[   fl2ll_ll] = '1;
   ll_hptr_next[fl2ll_ll] = fl_hptr_q;
   ll_tptr_next[fl2ll_ll] = fl_hptr_q;

  end // New LL

 end // FL Pop

 //---------------------------------------------------------------------------------------------------

 if (ll_pop) begin // LL pop

  // If this is the last block in the LL, reset the LL valid

  if (ll_hptr_q[ll_pop_ll] == ll_tptr_q[ll_pop_ll]) begin // Last LL block


   if (~fl2ll_v | (fl2ll_ll != ll_pop_ll)) begin // No LL push

    // If another block is not being pushed to the same LL, reset the LL valid

    ll_v_next[ll_pop_ll] = '0;

   end // No LL push

  end // Last LL block

  else begin // More LL blocks

   // Update the LL HP to point at the next block

   ll_hptr_next[ll_pop_ll] = blk_ptr_q[ll_hptr_q[ll_pop_ll]];

  end // More LL blocks

 end // LL pop

 //---------------------------------------------------------------------------------------------------

 if (fl_push) begin // FL push

  // Push a block onto the FL TP.
  // Need to update the FL TP (and HP if the FL is currently empty or being emptied this cycle), and
  // increment the FL count.
  // If the FL is not empty (and not being emptied this cycle), need to update the block pointer at
  // the FL TP to link to the pushed block.

  fl_tptr_next = fl_push_ptr;
  fl_cnt_inc   = '1;

  if (fl_empty_q |
      (fl2ll_v & (fl_cnt_q == {{(HQM_MSTR_FL_CNT_WIDTH-1){1'b0}}, 1'b1}))) begin // FL empty

   fl_hptr_next = fl_push_ptr;

  end // FL empty

  else begin // FL not empty

   // Update block pointer at the FL TP to link in the block

   blk_ptr_next[fl_tptr_q] = fl_push_ptr;

  end // FL not empty

 end // FL push

 //---------------------------------------------------------------------------------------------------
 // Handle simultaneous FL pop and push

 if (fl_cnt_dec & ~fl_cnt_inc) begin
  fl_cnt_next = fl_cnt_q - {{(HQM_MSTR_FL_CNT_WIDTH-1){1'b0}},1'b1};
 end else if (fl_cnt_inc & ~fl_cnt_dec) begin
  fl_cnt_next = fl_cnt_q + {{(HQM_MSTR_FL_CNT_WIDTH-1){1'b0}},1'b1};
 end

 fl_empty_next  = ~(|fl_cnt_next);
 fl_aempty_next = (fl_cnt_next <= {1'b0, cfg_mstr_ll_ctl.CQ_LL_LIMIT});
 fl_full_next   = (fl_cnt_next == HQM_MSTR_FL_DEPTH[HQM_MSTR_FL_CNT_WIDTH-1:0]);

 //---------------------------------------------------------------------------------------------------

 fl_hptr      = fl_hptr_q;
 fl_empty     = fl_empty_q;
 fl_aempty    = fl_aempty_q;
 fl_full      = fl_full_q;
 ll_v         = ll_v_q;

 for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin
  ll_hptr[(i*HQM_MSTR_FL_DEPTH_WIDTH) +: HQM_MSTR_FL_DEPTH_WIDTH] = ll_hptr_q[i];
 end

end

//----------------------------------------------------------------------------------------------------
// Status


always_comb begin

 mstr_fl_status.FL_FULL   = fl_full_q;
 mstr_fl_status.FL_AEMPTY = fl_aempty_q;
 mstr_fl_status.FL_EMPTY  = fl_empty_q;
 mstr_fl_status.FL_CNT    = fl_cnt_q;
 mstr_fl_status.FL_HPTR   = fl_hptr_q;

 mstr_ll_status_next      = mstr_ll_status_q;

 for (int i=0; i<(1<<HQM_MSTR_NUM_LLS_WIDTH); i=i+1) begin
  if (i<HQM_MSTR_NUM_LLS) begin
   ll_v_scaled[i]    = ll_v_q[i];
   ll_hptr_scaled[i] = ll_hptr_q[i];
   ll_tptr_scaled[i] = ll_tptr_q[i];
  end else begin
   ll_v_scaled[i]    = '0;
   ll_hptr_scaled[i] = '0;
   ll_tptr_scaled[i] = '0;
  end
 end

 // Sharing one status output to read all this state

 // Only update status output reg on the rising edge of the read bits

 if (cfg_mstr_ll_ctl.RD_BLK & ~mstr_ll_ctl_q[2]) begin // Read blk pointer

  mstr_ll_status_next = {1'd0
                        ,1'd0
                        ,1'd0
                        ,{(HQM_MSTR_FL_DEPTH_WIDTH-2){1'b0}}
                        ,blk_v_q[  cfg_mstr_ll_ctl.PTR]
                        ,msix_v_q[ cfg_mstr_ll_ctl.PTR]
                        ,blk_ptr_q[cfg_mstr_ll_ctl.PTR]
                        };

 end else if (cfg_mstr_ll_ctl.RD_LL & ~mstr_ll_ctl_q[0]) begin // Read LL info

  mstr_ll_status_next = {hpa_v_scaled[  cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        ,hpa_err_scaled[cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        ,hpa_pnd_scaled[cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        ,ll_v_scaled[   cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        ,ll_hptr_scaled[cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        ,ll_tptr_scaled[cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_LLS_WIDTH-1:0]]
                        };
 end

 clr_hpa_err    = '0;
 clr_hpa_err_cq = cfg_mstr_ll_ctl.PTR[HQM_MSTR_NUM_CQS_WIDTH-1:0];

 if (cfg_mstr_ll_ctl.CLR_HPA_ERR & ~mstr_ll_ctl_q[3]) begin // Clear HPA error

  clr_hpa_err   = '1;

 end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  mstr_ll_ctl_q    <= '0;
  mstr_ll_status_q <= '0;
 end else begin
  mstr_ll_ctl_q    <= {cfg_mstr_ll_ctl.CLR_HPA_ERR, cfg_mstr_ll_ctl.RD_BLK, cfg_mstr_ll_ctl.RD_RL, cfg_mstr_ll_ctl.RD_LL};
  mstr_ll_status_q <= mstr_ll_status_next;
 end
end

assign mstr_ll_status = mstr_ll_status_q;

//----------------------------------------------------------------------------------------------------

// TBD: Do we need to be able to reduce FL size through CFG?

endmodule // hqm_ti_ll

