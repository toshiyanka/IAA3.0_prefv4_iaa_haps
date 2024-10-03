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
module hqm_reorder_pipe_tx_sync
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter DP_WIDTH = 32
  ,parameter NALB_WIDTH = 32 
  ,parameter QED_DQED_WIDTH = 32
) (
   input  logic                          hqm_gated_clk
 , input  logic                          hqm_gated_rst_n
 
 , output logic                          idle
 , input  logic                          rst_prep

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

 // rop_dp_enq related
 , input  logic                          rop_dp_enq_rr_arb_winner_v
 , input  dp_enq_pipe_t                  p1_rop_dp_enq_nxt
 , output dp_enq_pipe_t                  p1_rop_dp_enq_f
 , output pipe_ctl_t                     p1_rop_dp_enq_ctl              
 , output logic                          p1_rop_dp_enq_hold_stall
 , output pipe_ctl_t                     p2_rop_dp_enq_ctl
 , output dp_enq_pipe_t                  p2_rop_dp_enq_f

 // rop_nalb_enq related
 , input  logic                          rop_nalb_enq_rr_arb_winner_v 
 , input  nalb_enq_pipe_t                p1_rop_nalb_enq_nxt
 , output nalb_enq_pipe_t                p1_rop_nalb_enq_f
 , output pipe_ctl_t                     p1_rop_nalb_enq_ctl
 , output logic                          p1_rop_nalb_enq_hold_stall
 , output pipe_ctl_t                     p2_rop_nalb_enq_ctl
 , output nalb_enq_pipe_t                p2_rop_nalb_enq_f

 // rop_qed_dqed_enq related
 , output qed_dqed_enq_pipe_t            p1_qed_dqed_enq_nxt             
 , output qed_dqed_enq_pipe_t            p1_qed_dqed_enq_f
 , output pipe_ctl_t                     p1_qed_dqed_enq_ctl
 , input  qed_dqed_enq_pipe_t            p0_qed_dqed_enq_f

);

dp_enq_pipe_t                            p2_rop_dp_enq_nxt;

nalb_enq_pipe_t                          p2_rop_nalb_enq_nxt;

logic                                    p2_rop_dp_enq_hold_stall;
logic                                    p2_rop_nalb_enq_hold_stall;
logic                                    dqed_cmd_pipe_stall;
logic                                    qed_cmd_pipe_stall;

//set stall bit only when there is valid data in p1_qed_dqed_enq_f.v
assign dqed_cmd_pipe_stall = p1_qed_dqed_enq_f.v & ( (((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR_NOOP) ) & ~rop_dqed_enq_ready) | 
                                                     (((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB_NOOP) ) & ~rop_qed_enq_ready)) ;  //set stall bit only when there is valid data in p1_qed_dqed_enq_f.v

assign qed_cmd_pipe_stall = p1_qed_dqed_enq_f.v & ( (((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB_NOOP)) & ~rop_qed_enq_ready) | 
                                                    (((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR_NOOP)) & ~rop_dqed_enq_ready));  //set stall bit only when there is valid data in p1_qed_dqed_enq_f.v

always_comb begin

         p2_rop_dp_enq_nxt.data     = p2_rop_dp_enq_f.data;

         p2_rop_dp_enq_ctl.hold     = p2_rop_dp_enq_f.v & ~rop_dp_enq_ready;
         p2_rop_dp_enq_hold_stall   = (p2_rop_dp_enq_ctl.hold | dqed_cmd_pipe_stall);

         p1_rop_dp_enq_ctl.hold     = p1_rop_dp_enq_f.v & p2_rop_dp_enq_hold_stall;
         p1_rop_dp_enq_hold_stall   = (p1_rop_dp_enq_ctl.hold | dqed_cmd_pipe_stall);

         p2_rop_dp_enq_ctl.enable   = p1_rop_dp_enq_f.v & ~p2_rop_dp_enq_hold_stall;
         p1_rop_dp_enq_ctl.enable   = rop_dp_enq_rr_arb_winner_v & ~p1_rop_dp_enq_hold_stall;

         p2_rop_dp_enq_nxt.v        = (p1_rop_dp_enq_f.v & ~p2_rop_dp_enq_hold_stall) | p2_rop_dp_enq_ctl.hold;

         if (p2_rop_dp_enq_ctl.enable ) begin
            p2_rop_dp_enq_nxt.data     = p1_rop_dp_enq_f.data;
         end

end


// rop_nalb_enq pipe line controls
always_comb begin

         p2_rop_nalb_enq_nxt.data         = p2_rop_nalb_enq_f.data;

         p2_rop_nalb_enq_ctl.hold         = p2_rop_nalb_enq_f.v & ~rop_nalb_enq_ready;
         p2_rop_nalb_enq_hold_stall       = ( p2_rop_nalb_enq_ctl.hold | qed_cmd_pipe_stall );

         p1_rop_nalb_enq_ctl.hold         = p1_rop_nalb_enq_f.v & p2_rop_nalb_enq_hold_stall;
         p1_rop_nalb_enq_hold_stall       = ( p1_rop_nalb_enq_ctl.hold | qed_cmd_pipe_stall );

         p2_rop_nalb_enq_ctl.enable       = p1_rop_nalb_enq_f.v & ~p2_rop_nalb_enq_hold_stall;
         p1_rop_nalb_enq_ctl.enable       = rop_nalb_enq_rr_arb_winner_v & ~p1_rop_nalb_enq_hold_stall;

         p2_rop_nalb_enq_nxt.v            = ( p1_rop_nalb_enq_f.v & ~p2_rop_nalb_enq_hold_stall ) | p2_rop_nalb_enq_ctl.hold;

         if (p2_rop_nalb_enq_ctl.enable) begin
             p2_rop_nalb_enq_nxt.data = p1_rop_nalb_enq_f.data;
         end

end

// qed_dqed_enq pipe line controls
always_comb begin

         p1_qed_dqed_enq_nxt.data = p1_qed_dqed_enq_f.data;

         p1_qed_dqed_enq_ctl.hold   = p1_qed_dqed_enq_f.v & ( (~rop_qed_enq_ready  & ((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_LB_NOOP  ) ) ) |
                                                            (~rop_dqed_enq_ready & ((p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR) | (p1_qed_dqed_enq_f.data.cmd == ROP_QED_DQED_ENQ_DIR_NOOP) ) )  ) ;

         p1_qed_dqed_enq_ctl.enable = p0_qed_dqed_enq_f.v & (~p1_qed_dqed_enq_ctl.hold) ;
         p1_qed_dqed_enq_nxt.v      = p1_qed_dqed_enq_ctl.enable | p1_qed_dqed_enq_ctl.hold;

         if (p1_qed_dqed_enq_ctl.enable) begin
             p1_qed_dqed_enq_nxt.data = p0_qed_dqed_enq_f.data;
         end
end


// flop the state
always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (hqm_gated_rst_n == 1'b0) begin

    p1_qed_dqed_enq_f            <= '0;

    p1_rop_dp_enq_f              <= '0;
    p2_rop_dp_enq_f              <= '0;

    p1_rop_nalb_enq_f            <= '0;
    p2_rop_nalb_enq_f            <= '0;

  end
  else begin

    p1_qed_dqed_enq_f            <= p1_qed_dqed_enq_nxt;

    p1_rop_dp_enq_f              <= p1_rop_dp_enq_nxt;
    p2_rop_dp_enq_f              <= p2_rop_dp_enq_nxt;

    p1_rop_nalb_enq_f            <= p1_rop_nalb_enq_nxt;
    p2_rop_nalb_enq_f            <= p2_rop_nalb_enq_nxt;

  end // if (hqm_gated_rst_n == 1'b0) begin
end  // always_ff

assign idle = ( p1_qed_dqed_enq_f.v == 1'b0) & 
              ( p1_rop_dp_enq_f.v == 1'b0 ) & 
              ( p2_rop_dp_enq_f.v == 1'b0 ) & 
              ( p1_rop_nalb_enq_f.v == 1'b0 ) & 
              ( p2_rop_nalb_enq_f.v == 1'b0 );

assign rop_dp_enq_v = rst_prep ? 1'b0 : p2_rop_dp_enq_f.v;
assign rop_nalb_enq_v = rst_prep ? 1'b0 : p2_rop_nalb_enq_f.v;
assign rop_qed_dqed_enq_v = rst_prep ? 1'b0 : p1_qed_dqed_enq_f.v;
assign rop_qed_dqed_enq_data = p1_qed_dqed_enq_f.data;
assign rop_dp_enq_data = p2_rop_dp_enq_f.data;
assign rop_nalb_enq_data = p2_rop_nalb_enq_f.data;

endmodule // hqm_reorder_pipe_tx_sync
