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
//  Module sbehierinsert : The hierarchical header completion block generates the hierarchical
//                       header for the completions going out of two target modules -TMSG and TREG blocks 
//                       to the fabric.
//------------------------------------------------------------------------------

// lintra push -70036_simple

module hqm_sbehierinsert # (
    parameter INTERNALPLDBIT = 0
)(
    input   logic                           side_clk,
    input   logic                           side_rst_b,
// Completions input from TREG
    input   logic                           in_pcsel,
    input   logic                           in_pctrdy,
    input   logic                           in_pcirdy,
    input   logic                           in_pceom,
    input   logic [INTERNALPLDBIT:0]        in_pcpayload,
    input   logic                           in_pcparity,
// hier hdr inputs
    input   logic [7:0]                     in_hier_dest,
    input   logic [7:0]                     in_hier_src,
// Outputs after header is inserted on completions
    output  logic                           out_pcirdy,
    output  logic                           out_pctrdy,
    output  logic                           out_pceom,
    output  logic [INTERNALPLDBIT:0]        out_pcpayload,
    output  logic                           out_pcparity
);

// control signals for modifying the payload
logic hier_put; // lintra s-70036 "used only when pldbit = 15,7"
logic hier_irdy, hier_parity;
logic [INTERNALPLDBIT:0] hier_payload;
logic out_put, out_lb;
logic hier_mmsg_fb, hier_mmsg_sb, hier_mmsg_tb, hier_mmsg_lb; // lintra s-0531 "used only when pldbit = 15,7"
logic out_pcmsgip;
/////////////////////////////////////////////
////////      Completions               /////
/////////////////////////////////////////////
// Masking/stealing the incoming trdy (going to either TMSG or TREG) will force the target blocks to retain their
// irdy, payload and eom until they are trdy'd.Use the masked trdy to send out the hierarchical header.
// Mask 1/2/4 trdy's depending on payload width and send the remaining downstream
// TRDY that is sent out to TREG and TMSG will not be asserted during the hier_irdy (when hdr is inserted)
always_comb out_pctrdy = in_pctrdy & ~hier_irdy;

always_comb out_put = in_pcirdy & in_pcsel & in_pctrdy;

// this is just for uniformity across other signals
always_comb out_pcirdy = in_pcirdy;

// byte enalbes are needed to create msgip
generate
    if (INTERNALPLDBIT == 31) begin: gen_in_be_31
        always_comb out_lb = 1'b1;
    end
    else begin : gen_in_be_15_7

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_outpc (
                .side_clk           (side_clk),
                .side_rst_b         (side_rst_b),
                .valid              (out_put),
                .first_byte         (),
                .second_byte        (),
                .third_byte         (),
                .last_byte          (out_lb)
            );
    end
endgenerate

// sometimes in_pceom stays asserted, even before irdy (when incoming completion is only 1DW and back2back)
// and at times it is only asserted during the last payload of incoming completion.
// set msgip only when its not set just after 1st dw (lb) and use this to create the hier_irdy (which eventually is used to mask trdy)

always_ff @ (posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b) begin
        out_pcmsgip <= '0;
    end
    else begin
        if (out_put & out_lb) begin  // set msgip after first dw header
            if (~out_pcmsgip)
                out_pcmsgip <= 1'b1;
            else
                out_pcmsgip <= ~in_pceom; // if msgip is set, reset it on in_eom
        end
    end
end // always

// for the same reason as in msgip(eom might be asserted from earlier). When msgip is asserted, implies the hdr is already sent out and remaining payload is being pushed out
// use that to mask the in_pceom, so that only the correct last payload gets eom.

always_comb out_pceom = in_pceom & out_pcmsgip;

// control signals for modifying the payload
always_comb hier_irdy   = in_pcirdy & ~out_pcmsgip;
always_comb hier_put    = hier_irdy & in_pctrdy & in_pcsel;

// create the hier payload depending on payload width
// swapping of the hier source/hier dest is done when this module is instantiated
// the wires connected at the top level are interchanged/swapped

generate
    if (INTERNALPLDBIT == 31) begin: gen_hier_be_31
        always_comb hier_payload = {16'h0000, in_hier_src, in_hier_dest};
    end
    else begin : gen_hier_be_15_7
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
                i_sbebytecount_hier_mmsg (
                    .side_clk           (side_clk),
                    .side_rst_b         (side_rst_b),
                    .valid              (hier_put),
                    .first_byte         (hier_mmsg_fb),
                    .second_byte        (hier_mmsg_sb),
                    .third_byte         (hier_mmsg_tb),
                    .last_byte          (hier_mmsg_lb)
                );
        if (INTERNALPLDBIT == 15) begin: gen_hier_15
            always_comb hier_payload = (hier_mmsg_tb|hier_mmsg_lb) ? '0 : {in_hier_src, in_hier_dest};
        end
        else begin : gen_hier_7
            always_comb hier_payload = (hier_mmsg_tb|hier_mmsg_lb) ? '0 : (hier_mmsg_sb ? in_hier_src : in_hier_dest);
        end
    end
endgenerate

// Calculate parity for just the header bits with eom as 0 since eom cannot be 0 when hier headers are being transferred
always_comb hier_parity  = ^{hier_payload,1'b0};

// Final payload to mux the hier payload and latched version of original payload
always_comb out_pcpayload   = hier_irdy ? hier_payload  : in_pcpayload;
always_comb out_pcparity    = hier_irdy ? hier_parity   : in_pcparity;

endmodule

// lintra pop
