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
//  Module sberep_tgt : Repeater instance for target used in sbendpoint.
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514

module hqm_sberep_tgt
#(
  parameter INTERNALPLDBIT               = 31
//  parameter SAIWIDTH                     = 15, // SAI field width - MAX=15
//  parameter RSWIDTH                      = 3  // RS field width - MAX=3
 )(

      agent_clk,
      agent_rst_b,
   
   // Target interface to the AGENT block
      sbi_sbe_tmsg_pcfree_ip,    
      sbi_sbe_tmsg_npfree_ip,    
      sbi_sbe_tmsg_npclaim_ip,   
      sbe_sbi_tmsg_pcput_ip,     
      sbe_sbi_tmsg_npput_ip,     
      sbe_sbi_tmsg_pcmsgip_ip,  
      sbe_sbi_tmsg_npmsgip_ip,   
      sbe_sbi_tmsg_pceom_ip,     
      sbe_sbi_tmsg_npeom_ip,     
      sbe_sbi_tmsg_pcparity_ip, 
      sbe_sbi_tmsg_npparity_ip,
      sbe_sbi_tmsg_pcpayload_ip, 
      sbe_sbi_tmsg_nppayload_ip, 
      sbe_sbi_tmsg_pccmpl_ip,    
      sbe_sbi_tmsg_pcvalid_ip,
      sbe_sbi_tmsg_npvalid_ip,

  //    ur_csairs_valid_ip,  
  //    ur_csai_ip,          
  //    ur_crs_ip,           
  //    ur_rx_sairs_valid_ip,
  //    ur_rx_sai_ip,        
  //    ur_rx_rs_ip,         

   // Target interface to EP
      sbi_sbe_tmsg_pcfree_ep,    
      sbi_sbe_tmsg_npfree_ep,    
      sbi_sbe_tmsg_npclaim_ep,   
      sbe_sbi_tmsg_pcput_ep,     
      sbe_sbi_tmsg_npput_ep,     
      sbe_sbi_tmsg_pcmsgip_ep,  
      sbe_sbi_tmsg_npmsgip_ep,   
      sbe_sbi_tmsg_pceom_ep,     
      sbe_sbi_tmsg_npeom_ep,     
      sbe_sbi_tmsg_pcparity_ep,
      sbe_sbi_tmsg_npparity_ep, 
      sbe_sbi_tmsg_pcpayload_ep, 
      sbe_sbi_tmsg_nppayload_ep, 
      sbe_sbi_tmsg_pccmpl_ep,    
      sbe_sbi_tmsg_pcvalid_ep,
      sbe_sbi_tmsg_npvalid_ep,
      empty_tgt

   //   ur_csairs_valid_ep,  
   //   ur_csai_ep,          
   //   ur_crs_ep,           
   //   ur_rx_sairs_valid_ep,
    //  ur_rx_sai_ep,        
    //  ur_rx_rs_ep         
  );

  input     agent_clk;
  input     agent_rst_b;
  
  // interface to IP

  input  logic          sbi_sbe_tmsg_pcfree_ip;   
  input  logic           sbi_sbe_tmsg_npfree_ip;   
  input  logic           sbi_sbe_tmsg_npclaim_ip;   
  output logic                        sbe_sbi_tmsg_pcput_ip;   
  output logic                        sbe_sbi_tmsg_npput_ip;    
  output logic                        sbe_sbi_tmsg_pcmsgip_ip;  
  output logic                        sbe_sbi_tmsg_npmsgip_ip;  
  output logic                        sbe_sbi_tmsg_pceom_ip;     
  output logic                        sbe_sbi_tmsg_npeom_ip;     
  output logic                        sbe_sbi_tmsg_pcparity_ip;     
  output logic                        sbe_sbi_tmsg_npparity_ip;     
  output logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload_ip;
  output logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload_ip; 
  output logic                        sbe_sbi_tmsg_pccmpl_ip;    
  output logic                        sbe_sbi_tmsg_pcvalid_ip;
  output logic                        sbe_sbi_tmsg_npvalid_ip;
/*
  input  logic                        ur_csairs_valid_ip;   
  input  logic           [SAIWIDTH:0] ur_csai_ip;           
  input  logic           [ RSWIDTH:0] ur_crs_ip;            
  output logic                        ur_rx_sairs_valid_ip; 
  output logic           [SAIWIDTH:0] ur_rx_sai_ip;         
  output logic           [ RSWIDTH:0] ur_rx_rs_ip;          
*/

  // interface to EP

  output  logic          sbi_sbe_tmsg_pcfree_ep;   
  output  logic          sbi_sbe_tmsg_npfree_ep;   
  output  logic          sbi_sbe_tmsg_npclaim_ep;   
  input logic                        sbe_sbi_tmsg_pcput_ep;   
  input logic                        sbe_sbi_tmsg_npput_ep;    
  input logic                        sbe_sbi_tmsg_pcmsgip_ep;  
  input logic                        sbe_sbi_tmsg_npmsgip_ep;  
  input logic                        sbe_sbi_tmsg_pceom_ep;     
  input logic                        sbe_sbi_tmsg_npeom_ep;     
  input logic                        sbe_sbi_tmsg_pcparity_ep;     
  input logic                        sbe_sbi_tmsg_npparity_ep;     
  input logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload_ep;
  input logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload_ep; 
  input logic                        sbe_sbi_tmsg_pccmpl_ep;    
  input logic                        sbe_sbi_tmsg_pcvalid_ep;
  input logic                        sbe_sbi_tmsg_npvalid_ep;
  output logic [1:0] 		empty_tgt;
 
  localparam LOG_FIFO_DEPTH = 1; // ceil(log2(FIFO_DEPTH))
  localparam FIFO_WIDTH = (LOG_FIFO_DEPTH + 1 + INTERNALPLDBIT + 1 + 5); // capture, pccmpl, eom, valid, put, parity, payload
  localparam FIFO_DEPTH = 2;
  

  logic      fence_off_np;
  logic [LOG_FIFO_DEPTH:0] wptr_capture_np, wptr_tag_np;
  
// Target interface FIFO  
  logic [1:0][FIFO_WIDTH-1:0] din_tgt;
  logic [1:0] 		push_tgt;  
  logic [1:0][FIFO_WIDTH-1:0] dout_tgt;
  logic [1:0] 		pop_tgt;
  
  
  // flops  
  logic [1:0] 		full_tgt;

  logic [1:0][LOG_FIFO_DEPTH:0] wptr_tgt;
  logic [1:0][LOG_FIFO_DEPTH:0] rptr_tgt;
  
  // wires  
  logic [1:0][LOG_FIFO_DEPTH:0] wptr_next_tgt;
  logic [1:0][LOG_FIFO_DEPTH:0] rptr_next_tgt;  
  logic [1:0] 		wptr_moves_tgt;
  logic [1:0] 		rptr_moves_tgt;
  logic [1:0][FIFO_DEPTH-1:0][FIFO_WIDTH-1:0]    mem_tgt;
  logic [1:0] 		wren_tgt; 

  genvar 		i;
  generate
    for (i=0; i<=1; i++) // lintra s-2056
      begin : tgt_fifo  		
	
  // TGT FIFO LOGIC
  assign 			 wren_tgt[i]      = push_tgt[i] && !full_tgt[i];
	
  assign 			 wptr_next_tgt[i] = (wptr_tgt[i][LOG_FIFO_DEPTH-1:0]==(FIFO_DEPTH-1)) ? ({~wptr_tgt[i][LOG_FIFO_DEPTH],{LOG_FIFO_DEPTH{1'b0}}}) : (wptr_tgt[i] + 1);
  assign 			 rptr_next_tgt[i] = (rptr_tgt[i][LOG_FIFO_DEPTH-1:0]==(FIFO_DEPTH-1)) ? ({~rptr_tgt[i][LOG_FIFO_DEPTH],{LOG_FIFO_DEPTH{1'b0}}}) : (rptr_tgt[i] + 1);
	
  assign 			 wptr_moves_tgt[i] = push_tgt[i] && !full_tgt[i];
  assign 			 rptr_moves_tgt[i] = pop_tgt[i] && !empty_tgt[i];
	
  always_ff @(posedge agent_clk or negedge agent_rst_b)
	  if (!agent_rst_b) wptr_tgt[i] <= '0;
	  else if (wptr_moves_tgt[i]) wptr_tgt[i] <= wptr_next_tgt[i];
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) rptr_tgt[i] <= '0;
    else if (rptr_moves_tgt[i]) rptr_tgt[i] <= rptr_next_tgt[i];
  
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) full_tgt[i] <= 1'b0;
    else if (wptr_moves_tgt[i] && (!rptr_moves_tgt[i]) && (wptr_next_tgt[i][LOG_FIFO_DEPTH-1:0]==rptr_tgt[i][LOG_FIFO_DEPTH-1:0])) full_tgt[i] <= 1'b1;
    else if (rptr_moves_tgt[i] && !wptr_moves_tgt[i]) full_tgt[i] <= 1'b0;
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) empty_tgt[i] <= 1'b1;
    else if (rptr_moves_tgt[i] && (!wptr_moves_tgt[i]) && (rptr_next_tgt[i][LOG_FIFO_DEPTH-1:0]==wptr_tgt[i][LOG_FIFO_DEPTH-1:0])) empty_tgt[i] <= 1'b1;
    else if (wptr_moves_tgt[i] && !rptr_moves_tgt[i]) empty_tgt[i] <= 1'b0;
  
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (!agent_rst_b) mem_tgt[i] <= '0;
    else if (wren_tgt[i]) mem_tgt[i][(wptr_tgt[i][LOG_FIFO_DEPTH-1:0])] <= din_tgt[i];   
  
  
  assign dout_tgt[i] = mem_tgt[i][(rptr_tgt[i][LOG_FIFO_DEPTH-1:0])];
  // coverage off
   `ifdef INTEL_SIMONLY  
   //`ifdef INTEL_INST_ON // SynTranlateOff  
  assert property (@(posedge agent_clk) disable iff (~agent_rst_b)
                   pop_tgt[i] |-> ~empty_tgt[i])
    else
  $display("%0t: %m: ERROR: target queue underflow; pop asserted when queue is empty.", $time);
  
  assert property (@(posedge agent_clk) disable iff (~agent_rst_b)
                   push_tgt[i] |-> ~full_tgt[i] | pop_tgt[i])
    else
  $display("%0t: %m: ERROR: target queue overflow; push asserted when queue is full.", $time);  
  // coverage on
   `endif // SynTranlateOn

end // block: tgt_fifo
endgenerate   


  assign  push_tgt[0]  = (sbe_sbi_tmsg_pcput_ep | sbe_sbi_tmsg_pcvalid_ep ) & !full_tgt[0];
  assign  push_tgt[1]  = (sbe_sbi_tmsg_npput_ep | sbe_sbi_tmsg_npvalid_ep ) & ! full_tgt[1];
   

  assign  pop_tgt[0]  = ((dout_tgt[0][INTERNALPLDBIT + 2] & sbi_sbe_tmsg_pcfree_ip)                | (!dout_tgt[0][INTERNALPLDBIT + 2] & dout_tgt[0][INTERNALPLDBIT + 3])) & !empty_tgt[0];
  assign  pop_tgt[1]  = ((dout_tgt[1][INTERNALPLDBIT + 2] & sbi_sbe_tmsg_npfree_ip & fence_off_np) | (!dout_tgt[1][INTERNALPLDBIT + 2] & dout_tgt[1][INTERNALPLDBIT + 3] & fence_off_np)) & !empty_tgt[1];



  assign    din_tgt[0] = {wptr_capture_np, sbe_sbi_tmsg_pccmpl_ep, sbe_sbi_tmsg_pceom_ep, sbe_sbi_tmsg_pcvalid_ep, sbe_sbi_tmsg_pcput_ep, sbe_sbi_tmsg_pcparity_ep, sbe_sbi_tmsg_pcpayload_ep};
  assign    din_tgt[1] =                                          {sbe_sbi_tmsg_npeom_ep, sbe_sbi_tmsg_npvalid_ep, sbe_sbi_tmsg_npput_ep, sbe_sbi_tmsg_npparity_ep, sbe_sbi_tmsg_nppayload_ep};

   
always_ff @(posedge agent_clk or negedge agent_rst_b) begin
    if (!agent_rst_b) begin
      sbi_sbe_tmsg_pcfree_ep <= '0;
      sbi_sbe_tmsg_npfree_ep <= '0;
      sbi_sbe_tmsg_npclaim_ep <= '0; 
    end
    else begin
      sbi_sbe_tmsg_pcfree_ep <= sbi_sbe_tmsg_pcfree_ip;
        sbi_sbe_tmsg_npfree_ep <= sbi_sbe_tmsg_npfree_ip & fence_off_np;
      sbi_sbe_tmsg_npclaim_ep <= sbi_sbe_tmsg_npclaim_ip;
    end
end
  
   
  assign sbe_sbi_tmsg_pcput_ip = pop_tgt[0] ? (dout_tgt[0][INTERNALPLDBIT + 2]) : '0;
  assign sbe_sbi_tmsg_npput_ip = pop_tgt[1] ? (dout_tgt[1][INTERNALPLDBIT + 2]) : '0;
  assign sbe_sbi_tmsg_pceom_ip = dout_tgt[0][INTERNALPLDBIT + 4];
  assign sbe_sbi_tmsg_npeom_ip = dout_tgt[1][INTERNALPLDBIT + 4];
  assign sbe_sbi_tmsg_pcparity_ip = dout_tgt[0][INTERNALPLDBIT + 1];
  assign sbe_sbi_tmsg_npparity_ip = dout_tgt[1][INTERNALPLDBIT + 1];				
  assign sbe_sbi_tmsg_pcpayload_ip = dout_tgt[0][INTERNALPLDBIT:0];
  assign sbe_sbi_tmsg_nppayload_ip = dout_tgt[1][INTERNALPLDBIT:0];  
  assign sbe_sbi_tmsg_pccmpl_ip    = (dout_tgt[0][INTERNALPLDBIT + 5] & !empty_tgt[0]);
  assign sbe_sbi_tmsg_pcvalid_ip   = (dout_tgt[0][INTERNALPLDBIT + 3] & !empty_tgt[0]);
  assign sbe_sbi_tmsg_npvalid_ip   = (dout_tgt[1][INTERNALPLDBIT + 3] & !empty_tgt[1]);
  
logic  pc_last_byte;
logic  np_last_byte;

generate
if (INTERNALPLDBIT == 31)
    begin: gen_be_31

        always_comb  pc_last_byte   = 1'b1;
        always_comb  np_last_byte   = 1'b1;
    end
else begin: gen_be_15_7
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        sbebytecount_pc (
            .side_clk           (agent_clk),
            .side_rst_b         (agent_rst_b),
            .valid              (sbe_sbi_tmsg_pcput_ip),
            .first_byte         (),
            .second_byte        (),
            .third_byte         (),
            .last_byte          ( pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        sbebytecount_np (
            .side_clk           (agent_clk),
            .side_rst_b         (agent_rst_b),
            .valid              (sbe_sbi_tmsg_npput_ip),
            .first_byte         (),
            .second_byte        (),
            .third_byte         (),
            .last_byte          ( np_last_byte)
        );
    end
endgenerate 
  
  
  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (~agent_rst_b)
      begin
        sbe_sbi_tmsg_pcmsgip_ip <= '0; // 1: Posted message in progress
        sbe_sbi_tmsg_npmsgip_ip <= '0; // 1: Non-posted message in progress
      end
    else
      begin
        
        // In-progess indicators are updated when a flit transfer occurs and is
        // set to 0 if it is the eom, 1 otherwise.
        if (sbe_sbi_tmsg_pcput_ip) begin
          if (~sbe_sbi_tmsg_pceom_ip &  pc_last_byte) sbe_sbi_tmsg_pcmsgip_ip <= '1;
          if (sbe_sbi_tmsg_pceom_ip &  pc_last_byte)  sbe_sbi_tmsg_pcmsgip_ip <= '0;
        end
        if (sbe_sbi_tmsg_npput_ip) begin
          if (~sbe_sbi_tmsg_npeom_ip &  np_last_byte) sbe_sbi_tmsg_npmsgip_ip <= '1;
          if (sbe_sbi_tmsg_npeom_ip &  np_last_byte)  sbe_sbi_tmsg_npmsgip_ip <= '0;
        end
      end // else: !if(~agent_rst_b)
   
assign wptr_capture_np = push_tgt[1] ? wptr_next_tgt[1] : wptr_tgt[1];
     
assign wptr_tag_np = dout_tgt[0][(FIFO_WIDTH -1) : (FIFO_WIDTH -2)];
 
assign fence_off_np = ((wptr_tag_np != rptr_tgt[1]) || empty_tgt[0] || empty_tgt[1]);
 

 endmodule
 
