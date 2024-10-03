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
//  Module sbebytecount: Counter module used in sbendpoint.
//
//------------------------------------------------------------------------------


module hqm_sbcheaderdecoder
#(
    parameter   INTERNALPLDBIT = 7 // Maximum payload bit, should be 7, 15 or 31
)(
    input   logic                       side_clk,
    input   logic                       side_rst_b,
    input   logic                       header_valid,
    input   logic [INTERNALPLDBIT:0]    data,            //
  
    output  logic   [7:0]               src_id,
    output  logic   [7:0]               dst_id,
    output  logic   [7:0]               opcode,
    output  logic   [7:0]               tag,             // lintra s-70036

    output  logic                       last_byte    
);

logic       valid;
logic[1:0]  byte_count;
logic       first_byte;
logic       second_byte;
logic       third_byte;

logic   [7:0]               src_id_int;
logic   [7:0]               dst_id_int;
logic   [7:0]               opcode_int;
logic   [7:0]               tag_int;



always_comb valid = header_valid;

// bytes can be 8, 16 or 32 bits and no of bytes  per message will be 4(3 in binary counts), 2(1) or 1(0) respectively
// reset bytes when it reaches end of message accordingly and set the last byte indicator
// And'ing the enables with valid makes sure they are set only for 1 clk width
always_comb
    begin
        unique casez (INTERNALPLDBIT)
            31  : begin
                    second_byte             = first_byte;
                    third_byte              = first_byte;
                    last_byte               = first_byte;
                  end
            15  : begin
                    second_byte             = first_byte;
                    third_byte              = (byte_count == 2'b01);
                    last_byte               = (byte_count == 2'b01);
                  end
        default : begin
                    second_byte             = (byte_count == 2'b01);
                    third_byte              = (byte_count == 2'b10);
                    last_byte               = (byte_count == 2'b11);
                  end
        endcase
    end

// start counting bytes when there is a valid and reset it when its either last byte or reset
always_ff @ ( posedge side_clk or negedge side_rst_b ) 
    begin
        if ( !side_rst_b ) 
            begin
                byte_count   <= '0;
            end
        else 
            begin
                if  (last_byte & valid) byte_count   <= '0; // wait till the last byte is valid and then reset
                else if (valid) byte_count   <= byte_count + 2'b01;
                else            byte_count   <= byte_count;
    end
end

// first byte is when the byte counter resets
always_comb first_byte = (byte_count == '0)  & valid;


always_ff @(posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b) begin
        dst_id  <= '0;
        src_id   <= '0;
        opcode   <= '0;
        tag   <= '0;        
    end
    else begin
        if ( valid & first_byte)        dst_id <= dst_id_int;
        if ( valid & second_byte)       src_id <= src_id_int;
        if ( valid & third_byte)        opcode <= opcode_int;
        if ( valid & last_byte)         tag <= tag_int;
    end
end

generate
    if (INTERNALPLDBIT ==31) begin: gen_hdr_dec_31
        always_comb begin
            dst_id_int = data[7:0];
            src_id_int = data[15:8];
            opcode_int = data[23:16];
            tag_int = data[31:24];
        end
    end
    else if (INTERNALPLDBIT == 15) begin: gen_hdr_dec_15
        always_comb begin
            dst_id_int = data[7:0] & {8{first_byte}};
            src_id_int = data[15:8] & {8{second_byte}};
            opcode_int = data[7:0] & {8{third_byte}};
            tag_int = data[15:8] & {8{last_byte}};
        end
    end
    else begin: gen_hdr_dec_7
        always_comb begin
            dst_id_int = data[7:0] & {8{first_byte}};
            src_id_int = data[7:0] & {8{second_byte}};
            opcode_int = data[7:0] & {8{third_byte}};
            tag_int = data[7:0] & {8{last_byte}};
        end
    end
 endgenerate


endmodule


