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
//  Module sbetregsplitter : The hierarchical header splitter to separate the header 
//                           from the local payload on target tmsg-treg interface
//------------------------------------------------------------------------------

module hqm_sbetregsplitter #(
    parameter   INTERNALPLDBIT      = 0
)(
    input   logic                           side_clk,
    input   logic                           side_rst_b,
// Inputs from the target TMSG of SBEBASE)
    input   logic                           tmsg_pcput,
    input   logic                           tmsg_npput,
    input   logic                           tmsg_pcmsgip,
    input   logic                           tmsg_npmsgip,
    input   logic                           tmsg_pceom,
    input   logic                           tmsg_npeom,
    input   logic                           tmsg_pcparity, // lintra s-70036, s-0527
    input   logic                           tmsg_npparity, // lintra s-70036, s-0527
    input   logic [INTERNALPLDBIT:0]        tmsg_pcpayload,
    input   logic [INTERNALPLDBIT:0]        tmsg_nppayload,
// Outputs to TREG
// Hier HDR specific outputs,
    output	logic [INTERNALPLDBIT:0]        tmsg_hdr_pcpayload,
    output	logic							tmsg_hdr_pcput,
    output	logic							tmsg_hdr_pcmsgip,
    output	logic							tmsg_hdr_pceom,
    output	logic							tmsg_hdr_pcparity,
    output	logic [INTERNALPLDBIT:0]		tmsg_hdr_nppayload,
    output	logic							tmsg_hdr_npput,
    output	logic							tmsg_hdr_npmsgip,
    output	logic							tmsg_hdr_npeom,
    output	logic							tmsg_hdr_npparity,
//	 Non header "Local LCL" outputs,
    output	logic [INTERNALPLDBIT:0]		tmsg_lcl_pcpayload,
    output	logic							tmsg_lcl_pcput,
    output	logic							tmsg_lcl_pcmsgip,
    output	logic							tmsg_lcl_pceom,
    output	logic							tmsg_lcl_pcparity,
    output	logic [INTERNALPLDBIT:0]		tmsg_lcl_nppayload,
    output	logic							tmsg_lcl_npput,
    output	logic							tmsg_lcl_npmsgip,
    output	logic							tmsg_lcl_npeom,
    output	logic							tmsg_lcl_npparity
);

logic split_pc_last_byte;
logic split_np_last_byte;
logic pc_hdr_done, lcl_pcmsgip;
logic np_hdr_done, lcl_npmsgip;

generate
// when payload width = 31, the first put will be the global routing header
    if (INTERNALPLDBIT == 31) begin : gen_31_lastbyte
        always_comb split_pc_last_byte = tmsg_pcput;
        always_comb split_np_last_byte = tmsg_npput;
    end
// Use the bytecount fub to get the last byte indicator
    else begin : gen_15_7_lastbyte
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_split_pc (
                .side_clk           (side_clk),
                .side_rst_b         (side_rst_b),
                .valid              (tmsg_pcput),
                .first_byte         (),
                .second_byte        (),
                .third_byte         (),
                .last_byte          (split_pc_last_byte)
            );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_split_np (
                .side_clk           (side_clk),
                .side_rst_b         (side_rst_b),
                .valid              (tmsg_npput),
                .first_byte         (),
                .second_byte        (),
                .third_byte         (),
                .last_byte          (split_np_last_byte)
            );
    end
endgenerate

// Create flag to reroute/split the outputs on different channels 
// when the flag is set, route the payload on hier channel 
// when not set, route it on local payload channel

// Once last byte with Put is recieved, it would mean the first 32 bit of the hier header are done
// set the hdr_done flag when lastbyte and put and reset hdr_done at the end of message (if its set)
// hier hdr message must atleast be 2 DW. 1st DW with the header and 2nd DW with the actual message payload.
// which is used here to differentiate between hier header and other payload 

always_ff @ (posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b)
        pc_hdr_done <= '0;
    else begin
        if (tmsg_pcput & split_pc_last_byte & ~tmsg_pceom)
            pc_hdr_done <= 1'b1;
        else if (tmsg_pcput & tmsg_pceom & pc_hdr_done)
            pc_hdr_done <= 1'b0;
    end
end

always_ff @ (posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b)
        lcl_pcmsgip <= '0;
    else begin
        if (tmsg_pcput & split_pc_last_byte & pc_hdr_done)
            lcl_pcmsgip  <= ~tmsg_pceom;
    end
end

always_ff @ (posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b)
        np_hdr_done <= '0;
    else begin
        if (tmsg_npput & split_np_last_byte & ~tmsg_npeom)
            np_hdr_done <= 1'b1;
        else if (tmsg_npput & tmsg_npeom & np_hdr_done)
            np_hdr_done <= 1'b0;
    end
end
always_ff @ (posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b)
        lcl_npmsgip <= '0;
    else begin
        if (tmsg_npput & split_np_last_byte & np_hdr_done)
            lcl_npmsgip <= ~tmsg_npeom;
    end
end

always_comb begin
    if (~pc_hdr_done) begin // PC hier header routing happens here
        tmsg_hdr_pcpayload  = tmsg_pcpayload;
        tmsg_hdr_pcput      = tmsg_pcput;
        tmsg_hdr_pcmsgip    = tmsg_pcmsgip;
        tmsg_hdr_pceom      = tmsg_pceom;
        tmsg_hdr_pcparity   = tmsg_pcparity;
        tmsg_lcl_pcpayload  = '0;
        tmsg_lcl_pcput      = '0;
        tmsg_lcl_pcmsgip    = '0;
        tmsg_lcl_pceom      = '0;
        tmsg_lcl_pcparity   = '0;
    end    
    else begin // PC hier header routing is done, local payload being router here
        tmsg_hdr_pcpayload  = '0;
        tmsg_hdr_pcput      = '0;
        tmsg_hdr_pcmsgip    = '0;
        tmsg_hdr_pceom      = '0;
        tmsg_hdr_pcparity   = '0;
        tmsg_lcl_pcpayload  = tmsg_pcpayload;
        tmsg_lcl_pcput      = tmsg_pcput;
        tmsg_lcl_pcmsgip    = lcl_pcmsgip;
        tmsg_lcl_pceom      = tmsg_pceom;
        tmsg_lcl_pcparity   = tmsg_pcparity;

    end
    if (~np_hdr_done) begin// NP hier header routing happens here
        tmsg_hdr_nppayload  = tmsg_nppayload;
        tmsg_hdr_npput      = tmsg_npput;
        tmsg_hdr_npmsgip    = tmsg_npmsgip;
        tmsg_hdr_npeom      = tmsg_npeom;
        tmsg_hdr_npparity   = tmsg_npparity;
        tmsg_lcl_nppayload  = '0;
        tmsg_lcl_npput      = '0;
        tmsg_lcl_npmsgip    = '0;
        tmsg_lcl_npeom      = '0;
        tmsg_lcl_npparity   = '0;
    end
    else begin // NP hier header routing is done, local payload being router here
        tmsg_hdr_nppayload  = '0;
        tmsg_hdr_npput      = '0;
        tmsg_hdr_npmsgip    = '0;
        tmsg_hdr_npeom      = '0;
        tmsg_hdr_npparity   = '0;
        tmsg_lcl_nppayload  = tmsg_nppayload;
        tmsg_lcl_npput      = tmsg_npput;
        tmsg_lcl_npmsgip    = lcl_npmsgip;
        tmsg_lcl_npeom      = tmsg_npeom;
        tmsg_lcl_npparity   = tmsg_npparity;    
    end
end

endmodule

	
