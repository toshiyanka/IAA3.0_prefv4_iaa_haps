//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
// hqm_AW_async_pulses
//
// This module is responsible for ensuring that a series of pulses is seen across a clock domain crossing.
// It is limited in the number of pulses it will handle based on the clock ratio and the width of the
// counter that counts the number of input pulses.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_async_pulses #(

     parameter WIDTH = 2
) (
     input  logic   clk_src
    ,input  logic   rst_src_n
    ,input  logic   data

    ,input  logic   fscan_rstbypen
    ,input  logic   fscan_byprst_b

    ,input  logic   clk_dst
    ,input  logic   rst_dst_n
    ,output logic   data_sync
);

//-----------------------------------------------------------------------------------------------------

logic                   rst_n;
logic                   rst_src_int_n;
logic                   rst_dst_int_n;
logic                   rst_src_cnt_in_n;
logic                   rst_dst_cnt_in_n;
logic                   rst_src_cnt_n;
logic                   rst_dst_cnt_n;
logic   [WIDTH-1:0]     data_scaled;
logic   [WIDTH-1:0]     bin_cnt;
logic   [WIDTH-1:0]     bin_cnt_next;
logic   [WIDTH-1:0]     gray_cnt_next;
logic   [WIDTH-1:0]     gray_cnt_q;
logic   [WIDTH-1:0]     gray_cnt_sync_q;
logic   [WIDTH-1:0]     rcv_cnt;
logic   [WIDTH-1:0]     sent_cnt_next;
logic   [WIDTH-1:0]     sent_cnt_q;
logic                   cnt_ne;
logic   [WIDTH-1:0]     cnt_ne_scaled;

//-----------------------------------------------------------------------------------------------------
// Flop and hold source.  Reset only after seen by the destination.

hqm_AW_gray2bin #(.WIDTH(WIDTH)) u_bin_cnt (.gray(gray_cnt_q), .binary(bin_cnt));

hqm_AW_width_scale #(.A_WIDTH(1), .Z_WIDTH(WIDTH)) i_data_scaled (.a(data), .z(data_scaled));

assign bin_cnt_next = bin_cnt + data_scaled;

hqm_AW_bin2gray #(.WIDTH(WIDTH)) u_gray_cnt_next (.binary(bin_cnt_next), .gray(gray_cnt_next));

assign rst_n = rst_src_n | rst_dst_n;

hqm_AW_reset_sync_scan u_rst_src_int_n (

     .clk               (clk_src)
    ,.rst_n             (rst_n)

    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    
    ,.rst_n_sync        (rst_src_int_n)
);

assign rst_src_cnt_in_n = rst_src_n | rst_src_int_n;

hqm_AW_reset_mux u_rst_src_cnt_n (

     .rst_in_n          (rst_src_cnt_in_n)

    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)

    ,.rst_out_n         (rst_src_cnt_n)
);

always_ff @(posedge clk_src or negedge rst_src_cnt_n) begin
 if (~rst_src_cnt_n) begin
  gray_cnt_q <= {WIDTH{1'b0}};
 end else begin
  gray_cnt_q <= gray_cnt_next;
 end
end

// Sync source to destination

hqm_AW_reset_sync_scan u_rst_dst_int_n (

     .clk               (clk_dst)
    ,.rst_n             (rst_n)

    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    
    ,.rst_n_sync        (rst_dst_int_n)
);

assign rst_dst_cnt_in_n = rst_dst_n | rst_dst_int_n;

hqm_AW_reset_mux u_rst_dst_cnt_n (

     .rst_in_n          (rst_dst_cnt_in_n)

    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)

    ,.rst_out_n         (rst_dst_cnt_n)
);

hqm_AW_sync_rst0 #(.WIDTH(WIDTH)) u_gray_cnt_sync_q (

     .clk               (clk_dst)
    ,.rst_n             (rst_dst_cnt_n)
    ,.data              (gray_cnt_q)
    ,.data_sync         (gray_cnt_sync_q)
);

// Generate single pulse in destination domain

hqm_AW_gray2bin #(.WIDTH(WIDTH)) u_rcv_cnt (.gray(gray_cnt_sync_q), .binary(rcv_cnt));

hqm_AW_width_scale #(.A_WIDTH(1), .Z_WIDTH(WIDTH)) i_cnt_ne_scaled (.a(cnt_ne), .z(cnt_ne_scaled));

assign sent_cnt_next = sent_cnt_q + cnt_ne_scaled;

always_ff @(posedge clk_dst or negedge rst_dst_cnt_n) begin
 if (~rst_dst_cnt_n) begin
  sent_cnt_q <= {WIDTH{1'b0}};
 end else begin
  sent_cnt_q <= sent_cnt_next;
 end
end

assign cnt_ne = (sent_cnt_q != rcv_cnt);

assign data_sync = cnt_ne;

`ifndef INTEL_SVA_OFF

 int    sendcnt;
 int    rcvcnt;
 int    rcvcnt_s1;
 int    rcvcnt_s2;

 always_ff @(negedge clk_src or negedge rst_src_cnt_n or negedge rst_dst_cnt_n) begin
 if (~rst_src_cnt_n | ~rst_dst_cnt_n) begin
   rcvcnt <= 0;
  end else begin
   rcvcnt <= rcvcnt + data;
  end
 end

 always_ff @(negedge clk_dst or negedge rst_dst_cnt_n or negedge rst_src_cnt_n) begin
  if (~rst_dst_cnt_n | ~rst_src_cnt_n) begin
   sendcnt   <= 0;
   rcvcnt_s1 <= 0;
   rcvcnt_s2 <= 0;
  end else begin
   sendcnt   <= sendcnt + cnt_ne;
   rcvcnt_s1 <= rcvcnt;
   rcvcnt_s2 <= rcvcnt_s1;
  end
 end

 check_overflow: assert property (@(posedge clk_dst) disable iff ((rst_dst_cnt_n !== 1'b1) || (rst_src_cnt_n !== 1'b1)) !((rcvcnt_s2-sendcnt)>((1<<WIDTH)-1))) else begin
    $display ("\nERROR: %t: %m: Received more data pulses than the WIDTH=%0d wide counter can handle !!!\n",$time,WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
 end

`endif

endmodule // hqm_AW_async_pulses
