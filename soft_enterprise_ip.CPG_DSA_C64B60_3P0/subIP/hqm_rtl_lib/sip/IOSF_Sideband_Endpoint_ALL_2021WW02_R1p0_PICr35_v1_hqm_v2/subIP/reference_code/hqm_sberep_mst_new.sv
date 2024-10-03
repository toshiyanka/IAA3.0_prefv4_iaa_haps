//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  Module sberep_mst_new : Repeater instance for master used in sbendpoint.
//
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514

module hqm_sberep_mst_new # (
parameter INTERNALPLDBIT = 31
)
(
      agent_clk,
      agent_rst_b,

 // Master interface to the AGENT block
      sbi_sbe_mmsg_pcirdy_ip,
      sbi_sbe_mmsg_npirdy_ip,
      sbi_sbe_mmsg_pceom_ip,
      sbi_sbe_mmsg_npeom_ip,
      sbi_sbe_mmsg_pcparity_ip,
      sbi_sbe_mmsg_npparity_ip,
      sbi_sbe_mmsg_pcpayload_ip,
      sbi_sbe_mmsg_nppayload_ip,

 // Master interface to EP
      sbi_sbe_mmsg_pcirdy_ep,
      sbi_sbe_mmsg_npirdy_ep,
      sbi_sbe_mmsg_pceom_ep,
      sbi_sbe_mmsg_npeom_ep,
      sbi_sbe_mmsg_pcparity_ep,
      sbi_sbe_mmsg_npparity_ep,
      sbi_sbe_mmsg_pcpayload_ep,
      sbi_sbe_mmsg_nppayload_ep,
      sbe_sbi_mmsg_pctrdy_ep,
      sbe_sbi_mmsg_nptrdy_ep,
      sbe_sbi_mmsg_pcsel_ep,
      sbe_sbi_mmsg_npsel_ep,
      empty_mst,
	  full_mst
  );

  input     agent_clk;
  input     agent_rst_b;

  input  logic           sbi_sbe_mmsg_pcirdy_ip;
  input  logic           sbi_sbe_mmsg_npirdy_ip;
  input  logic           sbi_sbe_mmsg_pceom_ip;
  input  logic           sbi_sbe_mmsg_npeom_ip;
  input  logic           sbi_sbe_mmsg_pcparity_ip;
  input  logic           sbi_sbe_mmsg_npparity_ip;
  input  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload_ip;
  input  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload_ip;

  output  logic           sbi_sbe_mmsg_pcirdy_ep;
  output  logic           sbi_sbe_mmsg_npirdy_ep;
  output  logic           sbi_sbe_mmsg_pceom_ep;
  output  logic           sbi_sbe_mmsg_npeom_ep;
  output  logic           sbi_sbe_mmsg_pcparity_ep;
  output  logic           sbi_sbe_mmsg_npparity_ep;
  output  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload_ep;
  output  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload_ep;
  
  input logic                        sbe_sbi_mmsg_pctrdy_ep;
  input logic                        sbe_sbi_mmsg_nptrdy_ep;
  input logic           sbe_sbi_mmsg_pcsel_ep;
  input logic           sbe_sbi_mmsg_npsel_ep;

  output logic [1:0] 		empty_mst;
  output logic [1:0] 		full_mst;

  
  localparam FIFO_DEPTH = 2;
  localparam LOG_FIFO_DEPTH = 1; // ceil(log2(FIFO_DEPTH))
  localparam FIFO_WIDTH = LOG_FIFO_DEPTH + 3 + INTERNALPLDBIT + 1 + 1; // capture, irdy, eom, parity, payload;
  
  logic      fence_off_np;
  logic [LOG_FIFO_DEPTH:0] wptr_capture_np, wptr_tag_np;

// Master interface FIFO   
  logic [1:0][FIFO_WIDTH-1:0] din_mst;
  logic [1:0] 		push_mst;
  logic [1:0][FIFO_WIDTH-1:0] dout_mst;
  logic [1:0] 		pop_mst;
  
  // flops  
   
  logic [1:0][LOG_FIFO_DEPTH:0] wptr_mst;
  logic [1:0][LOG_FIFO_DEPTH:0] rptr_mst;
  
  // wires  
  logic [1:0][LOG_FIFO_DEPTH:0] wptr_next_mst;
  logic [1:0][LOG_FIFO_DEPTH:0] rptr_next_mst;
  logic [1:0] 		wptr_moves_mst;
  logic [1:0] 		rptr_moves_mst;
  logic [1:0][FIFO_DEPTH-1:0][FIFO_WIDTH-1:0]    mem_mst;
  logic [1:0] 		wren_mst;

  logic sbe_sbi_mmsg_pctrdy_ip_int, sbe_sbi_mmsg_nptrdy_ip_int;
  genvar   i;
  generate
    for (i=0; i<=1; i++) // lintra s-2056
      begin : mst_fifo

  // MST FIFO LOGIC
  assign        wren_mst[i]      = push_mst[i] && !full_mst[i];

  assign        wptr_next_mst[i] = (wptr_mst[i][LOG_FIFO_DEPTH-1:0]==(FIFO_DEPTH-1)) ? ({~wptr_mst[i][LOG_FIFO_DEPTH],{LOG_FIFO_DEPTH{1'b0}}}) : (wptr_mst[i] + 1);
  assign        rptr_next_mst[i] = (rptr_mst[i][LOG_FIFO_DEPTH-1:0]==(FIFO_DEPTH-1)) ? ({~rptr_mst[i][LOG_FIFO_DEPTH],{LOG_FIFO_DEPTH{1'b0}}}) : (rptr_mst[i] + 1);

  assign        wptr_moves_mst[i] = push_mst[i] && !full_mst[i];
  assign        rptr_moves_mst[i] = pop_mst[i] && !empty_mst[i];

  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) wptr_mst[i] <= '0;
    else if (wptr_moves_mst[i]) wptr_mst[i] <= wptr_next_mst[i];
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) rptr_mst[i] <= '0;
    else if (rptr_moves_mst[i]) rptr_mst[i] <= rptr_next_mst[i];
  
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) full_mst[i] <= 1'b0;
    else if (wptr_moves_mst[i] && (!rptr_moves_mst[i]) && (wptr_next_mst[i][LOG_FIFO_DEPTH-1:0]==rptr_mst[i][LOG_FIFO_DEPTH-1:0])) full_mst[i] <= 1'b1;
    else if (rptr_moves_mst[i] && !wptr_moves_mst[i]) full_mst[i] <= 1'b0;
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) empty_mst[i] <= 1'b1;
    else if (rptr_moves_mst[i] && (!wptr_moves_mst[i]) && (rptr_next_mst[i][LOG_FIFO_DEPTH-1:0]==wptr_mst[i][LOG_FIFO_DEPTH-1:0])) empty_mst[i] <= 1'b1;
    else if (wptr_moves_mst[i] && !rptr_moves_mst[i]) empty_mst[i] <= 1'b0;
  
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) mem_mst[i] <= '0;
    else if (wren_mst[i]) mem_mst[i][(wptr_mst[i][LOG_FIFO_DEPTH-1:0])] <= din_mst[i];
  
  assign dout_mst[i] = mem_mst[i][(rptr_mst[i][LOG_FIFO_DEPTH-1:0])];
  
  // coverage off
   `ifdef INTEL_SIMONLY  
   //`ifdef INTEL_INST_ON // SynTranlateOff  
  assert property (@(posedge agent_clk) disable iff (~agent_rst_b)
                   pop_mst[i] |-> ~empty_mst[i])
    else
  $display("%0t: %m: ERROR: target queue underflow; pop asserted when queue is empty.", $time);
  
  assert property (@(posedge agent_clk) disable iff (~agent_rst_b)
                   push_mst[i] |-> ~full_mst[i] | pop_mst[i])
    else
  $display("%0t: %m: ERROR: target queue overflow; push asserted when queue is full.", $time);
  // coverage on
   `endif // SynTranlateOn

end // block: mst_fifo
endgenerate    

// need two fifo's we can have np and pc asserted in the same clock; keep the logic simple.
  
  assign        din_mst[0]  = {wptr_capture_np, sbi_sbe_mmsg_pcirdy_ip,  sbi_sbe_mmsg_pceom_ip,  sbi_sbe_mmsg_pcparity_ip, sbi_sbe_mmsg_pcpayload_ip};
  assign        push_mst[0] = (sbi_sbe_mmsg_pcirdy_ip)  &  !full_mst[0];
  assign        pop_mst[0]  =  sbe_sbi_mmsg_pctrdy_ep   & sbe_sbi_mmsg_pcsel_ep;
  
  assign        din_mst[1]  = {sbi_sbe_mmsg_npirdy_ip,  sbi_sbe_mmsg_npeom_ip, sbi_sbe_mmsg_npparity_ip, sbi_sbe_mmsg_nppayload_ip};
  assign        push_mst[1] = (sbi_sbe_mmsg_npirdy_ip)  &  !full_mst[1];
  assign        pop_mst[1]  =  sbe_sbi_mmsg_nptrdy_ep   &  sbe_sbi_mmsg_npsel_ep;
  
  assign        sbe_sbi_mmsg_pctrdy_ip_int = !full_mst[0];
  assign        sbe_sbi_mmsg_nptrdy_ip_int = !full_mst[1];
  

    assign sbi_sbe_mmsg_pcpayload_ep= !empty_mst[0]                 ? dout_mst[0][INTERNALPLDBIT  :0] : '0;
    assign sbi_sbe_mmsg_pcparity_ep = !empty_mst[0]                 ? dout_mst[0][INTERNALPLDBIT + 1] : '0;
    assign sbi_sbe_mmsg_pceom_ep    = !empty_mst[0]                 ? dout_mst[0][INTERNALPLDBIT + 2] : '0;
    assign sbi_sbe_mmsg_pcirdy_ep   = !empty_mst[0]                 ? dout_mst[0][INTERNALPLDBIT + 3] : '0;	
    assign sbi_sbe_mmsg_nppayload_ep= !empty_mst[1]                 ? dout_mst[1][INTERNALPLDBIT  :0] : '0;
    assign sbi_sbe_mmsg_npparity_ep = !empty_mst[1]                 ? dout_mst[1][INTERNALPLDBIT + 1] : '0;
    assign sbi_sbe_mmsg_npeom_ep    = !empty_mst[1]                 ? dout_mst[1][INTERNALPLDBIT + 2] : '0;
    assign sbi_sbe_mmsg_npirdy_ep   = (!empty_mst[1] & fence_off_np)? dout_mst[1][INTERNALPLDBIT + 3] : '0;
    assign wptr_capture_np          = push_mst[1]                   ? wptr_next_mst[1]                : wptr_mst[1];
    assign wptr_tag_np              = dout_mst[0][(FIFO_WIDTH -1) : (FIFO_WIDTH -2)];
    assign fence_off_np             = (wptr_tag_np != rptr_mst[1]) || empty_mst[0] ;
endmodule 
