//
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
//  Module sbedoserrmstr : The parity master interface block within the sideband interface
//                   base endpoint (sbebase).
//
//------------------------------------------------------------------------------

// lintra push -70036_simple

module hqm_sbedoserrmstr #(
  parameter INTERNALPLDBIT              = 7, // Maximum payload bit, should be 7, 15 or 31	 
  parameter TX_EXT_HEADER_SUPPORT       = 0,
  parameter SAIWIDTH                    = 15,// SAI field width - MAX=15
  parameter RSWIDTH                     = 3  // RS field width - MAX=3
)(
  // Clock/Reset Signals
  input  logic                      ungated_agent_clk, // only flag uses ungated agent clk
  input  logic                      agent_side_clk, // all other logic needs to run on sideclk if sync, gated agent clk if async
  input  logic                      side_rst_b,

  // Master Interface Signals (from IP)
  input  logic                [7:0] do_serr_srcid_strap,
  input  logic                [7:0] do_serr_dstid_strap,
  input  logic                [2:0] do_serr_tag_strap,
  input  logic                      do_serr_sairs_valid, // lintra s-0527, s-70036 "it is used, no idea why lintra doesnt think so"
  input  logic         [SAIWIDTH:0] do_serr_sai,
  input  logic         [ RSWIDTH:0] do_serr_rs,

  // Base Interface input signals
  input  logic                      mmsg_pctrdy,
  input  logic                      mmsg_pcsel,

  // Endpoint Interface Signals
  input  logic                      send_do_serr, //input from parity checks to send out err message
  output logic                      mmsg_pcirdy, //outputs to send out do_serr message packets
  output logic                      mmsg_pceom,
  output logic                      mmsg_pcparity,
  output logic   [INTERNALPLDBIT:0] mmsg_pcpayload //rename to similar signals from mreg or mmsg (remove parmstr)
);

logic[31:0]     parmstr_data;
logic           parmstr_first_byte;
logic           parmstr_second_byte;
logic           parmstr_third_byte;
logic           parmstr_last_byte;
logic           flag, flag_f;
logic           parmstr_pmsgip; //lintra s-70036 "might be needed later"
logic           send_eh;
logic[15:0]     sai;
logic[3:0]      rs;
logic[31:0]     eh_data;
logic           pcount;

localparam SAIZERO = 15-SAIWIDTH;
localparam RSZERO = 3-RSWIDTH;

always_comb begin
    send_eh = do_serr_sairs_valid && (TX_EXT_HEADER_SUPPORT == 1);
    sai     = {{15-SAIWIDTH{1'b0}},do_serr_sai};
    rs      = {{3-RSWIDTH{1'b0}}, do_serr_rs};
    eh_data = {4'h0, rs, sai, 8'h00};
end


// Create the message with src, dst, error opcode -88, tag
always_comb parmstr_data = pcount ? eh_data : {send_eh, 4'b0000, do_serr_tag_strap, 8'h88, do_serr_srcid_strap, do_serr_dstid_strap};

//set flag when do_serr and reset only on reset
always_ff @ (posedge ungated_agent_clk or negedge side_rst_b) begin
    if (~side_rst_b)        flag <= '0;
    else if (send_do_serr)  flag <= 1'b1;
 end

// once flag is set, latch it to agent_side_clk (irrespective of ASYNC or SYNC mode) and create a pulse on agent_side_clk
// use the pulse to send do_serr

always_ff @ (posedge agent_side_clk or negedge side_rst_b) begin
    if (~side_rst_b)        flag_f <= '0;
    else if (flag)  flag_f <= 1'b1;
 end

    
always_ff @ (posedge agent_side_clk or negedge side_rst_b)
    if (~side_rst_b) begin
        mmsg_pcirdy         <= '0;
    end
    else begin
// set irdy when send_do_serr is asserted, reset only when trdy is recieved back for the last byte and when this fub is selected by the master
// ~flag makes sure irdy is asserted only once (until all packets are sent out) even though send_do_serr is asserted throughout
        mmsg_pcirdy         <= mmsg_pcirdy ? ~(mmsg_pctrdy & parmstr_last_byte & mmsg_pcsel & mmsg_pceom) : (flag & ~flag_f);
    end

generate
    if (INTERNALPLDBIT ==31) begin: gen_parmstr_be_31
        always_comb parmstr_first_byte  = 1'b1;
        always_comb parmstr_second_byte = 1'b1;
        always_comb parmstr_third_byte  = 1'b1;
        always_comb parmstr_last_byte   = 1'b1;
    end
    else begin: gen_parmstr_be_15_7
        logic parmstr_valid;
            
        always_comb parmstr_valid = mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel;

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_parmstr (
            .side_clk           (agent_side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (parmstr_valid),
            .first_byte         (parmstr_first_byte),
            .second_byte        (parmstr_second_byte),
            .third_byte         (parmstr_third_byte),
            .last_byte          (parmstr_last_byte)
        );

    end
endgenerate

//instead of flopping 32 bit data and then sending out flits, just send out flits directly

generate
    if (INTERNALPLDBIT ==31) begin: gen_parmstr_databus_31
        always_comb mmsg_pcpayload  =   parmstr_data;
    end
    else if (INTERNALPLDBIT ==15) begin: gen_parmstr_databus_15
        always_comb mmsg_pcpayload  =   parmstr_last_byte ? parmstr_data[31:16] : parmstr_data[15:0];
    end
    else begin: gen_parmstr_databus_7
        always_comb mmsg_pcpayload  =   parmstr_second_byte ? parmstr_data[15:8] : (parmstr_third_byte ? parmstr_data[23:16] : (parmstr_last_byte ? parmstr_data[31:24] : parmstr_data[7:0]));
    end
endgenerate

//  when send_eh, eom = (pcount = 1), else when there is no eh, eom =( pcount = 0)
always_comb mmsg_pceom = ~(send_eh ^ pcount) & parmstr_last_byte;
always_comb mmsg_pcparity = ^{mmsg_pcpayload, mmsg_pceom};


always_ff @(posedge agent_side_clk or negedge side_rst_b) begin
    if (!side_rst_b) begin
        parmstr_pmsgip  <= '0;
        pcount <= '0;
    end
    else if (mmsg_pcirdy & mmsg_pctrdy & parmstr_last_byte & mmsg_pcsel) begin
        parmstr_pmsgip <= ~mmsg_pceom;

        if (mmsg_pceom | pcount) // reset pcount on eom or when pcount = 1 (2nd DW data packet)
            pcount <= '0;
        else if (send_eh)
            pcount <= '1;
    end
end

endmodule

// lintra pop
