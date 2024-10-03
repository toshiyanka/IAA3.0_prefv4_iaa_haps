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
// hqm_AW_int_serializer
//
// This module is responsible for accepting a paramterized number of interrupts with associated data,
// latching the data in parallel, and serializing the interrupts into a string of single interrupt
// events that are double buffered to be pulled one at a time by downstream logic.  An upstream
// interface allows these modules to be chained together to propagate the interrupts downstream.
//
// The following parameters are supported:
//
//  NUM_INTS    Number of interrupts
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_int_serializer

       import hqm_AW_pkg::*;
#(
     parameter NUM_INF      = 16
    ,parameter NUM_COR      = 16
    ,parameter NUM_UNC      = 16
    ,parameter UNIT_WIDTH   = 4
) (

    input logic hqm_inp_gated_clk
  , input logic hqm_inp_gated_rst_n
  , input logic rst_prep

    ,input  logic   [UNIT_WIDTH-1:0]        unit

    ,input  logic   [NUM_INF-1:0]           inf_v
    ,input  aw_alarm_syn_t  [NUM_INF-1:0]   inf_data

    ,input  logic   [NUM_COR-1:0]           cor_v
    ,input  aw_alarm_syn_t  [NUM_COR-1:0]   cor_data

    ,input  logic   [NUM_UNC-1:0]           unc_v
    ,input  aw_alarm_syn_t  [NUM_UNC-1:0]   unc_data

    ,input  logic                           int_up_v
    ,input  aw_alarm_t                      int_up_data
    ,output logic                           int_up_ready

    ,output logic                           int_down_v
    ,output aw_alarm_t                      int_down_data
    ,input  logic                           int_down_ready

    ,output logic   [31:0]                  status
    , output logic                          int_idle
);

localparam NUM_INTS     = NUM_INF+NUM_COR+NUM_UNC;
localparam IWIDTH       = AW_logb2(NUM_INTS-1)+1;
localparam AID_WIDTH    = $bits(int_up_data.aid);

//-----------------------------------------------------------------------------------------------------

logic                           db_up_v;
aw_alarm_t                      db_up_data;
logic                           db_up_ready;

logic   [NUM_INTS-1:0]          int_in_v;
aw_alarm_syn_t                  int_in_data[NUM_INTS-1:0];

logic   [NUM_INTS-1:0]          int_v_next;
logic   [NUM_INTS-1:0]          int_v_q;
aw_alarm_syn_t                  int_data_q[NUM_INTS-1:0];
logic   [NUM_INTS-1:0]          int_v_masked;

logic   [NUM_INTS-1:0]          int_ss_mask;
logic   [NUM_INTS-1:0]          int_ss_masked;
logic   [NUM_INTS-1:0]          int_ss_next;
logic   [NUM_INTS-1:0]          int_ss_q;
logic                           int_ss_any;
logic   [IWIDTH-1:0]            int_ss_aid_in;
logic   [IWIDTH-1:0]            int_ss_aid;
logic   [AID_WIDTH-1:0]         int_ss_aid_scaled;
logic                           int_ss_ready;
logic   [1:0]                   int_ss_class;

logic                           db_down_sel;
logic                           tog_q;
logic                           db_down_v;
aw_alarm_t                      db_down_data;
logic                           db_down_ready;

genvar                          g;

//-----------------------------------------------------------------------------------------------------
// Double buffer upstream interrupt input

hqm_AW_double_buffer #(.WIDTH($bits(int_up_data)), .NOT_EMPTY_AT_EOT(0), .RESET_DATAPATH(1)) i_db_up (

         .clk       (hqm_inp_gated_clk)
        ,.rst_n     (hqm_inp_gated_rst_n)

        ,.status    (status[6:0])

        ,.in_ready  (int_up_ready)

        ,.in_valid  (int_up_v)
        ,.in_data   (int_up_data)

        ,.out_ready (db_up_ready)

        ,.out_valid (db_up_v)
        ,.out_data  (db_up_data)
);

//-----------------------------------------------------------------------------------------------------
// Local interrupt latching and serialization

generate
 for (g=0; g<NUM_INF; g=g+1) begin: g_inf
  assign int_in_v[   g] = inf_v[   g];
  assign int_in_data[g] = inf_data[g];
 end
 for (g=0; g<NUM_COR; g=g+1) begin: g_cor
  assign int_in_v[   NUM_INF+g] = cor_v[   g];
  assign int_in_data[NUM_INF+g] = cor_data[g];
 end
 for (g=0; g<NUM_UNC; g=g+1) begin: g_unc
  assign int_in_v[   NUM_INF+NUM_COR+g] = unc_v[   g];
  assign int_in_data[NUM_INF+NUM_COR+g] = unc_data[g];
 end
endgenerate

assign int_v_next  = int_in_v | int_v_masked;
assign int_ss_next = (|int_ss_masked) ? int_ss_masked : int_v_next;

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
 if (~hqm_inp_gated_rst_n) begin
  int_v_q  <= {NUM_INTS{1'd0}};
  int_ss_q <= {NUM_INTS{1'd0}};
 end else begin
  if (|{int_in_v, int_v_q}) int_v_q <= int_v_next;
  if (|{int_in_v, int_v_q, int_ss_q}) int_ss_q <= int_ss_next;
 end
end

assign int_v_masked  = int_v_q  & ~int_ss_mask;
assign int_ss_masked = int_ss_q & ~int_ss_mask;

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
  if (~hqm_inp_gated_rst_n) begin
    for (int i=0; i<NUM_INTS; i=i+1) begin
     int_data_q[i] <= '0;
    end // for i
  end else begin
    for (int i=0; i<NUM_INTS; i=i+1) begin
      if (int_in_v[i] & ~int_v_masked[i]) int_data_q[i] <= int_in_data[i];
    end // for i
  end
end

hqm_AW_binenc #(.WIDTH(NUM_INTS)) i_AW_binenc (

     .a         (int_ss_q)
    ,.enc       (int_ss_aid_in)
    ,.any       (int_ss_any)
);

assign int_ss_mask = {{(NUM_INTS-1){1'd0}},int_ss_ready} << int_ss_aid_in;

always_comb begin

 if ({{(32-IWIDTH){1'd0}}, int_ss_aid_in} >= (NUM_INF+NUM_COR)) begin
  int_ss_class = 2'd2;
  int_ss_aid   = int_ss_aid_in - (NUM_INF[IWIDTH-1:0] + NUM_COR[IWIDTH-1:0]);
 end else if ({{(32-IWIDTH){1'd0}}, int_ss_aid_in} >= NUM_INF) begin
  int_ss_class = 2'd1;
  int_ss_aid   = int_ss_aid_in - NUM_INF[IWIDTH-1:0];
 end else begin
  int_ss_class = 2'd0;
  int_ss_aid   = int_ss_aid_in;
 end

end
  
hqm_AW_width_scale #(.A_WIDTH(IWIDTH), .Z_WIDTH(AID_WIDTH)) u_int_ss_aid_scaled (

     .a         (int_ss_aid)
    ,.z         (int_ss_aid_scaled)
);

//-----------------------------------------------------------------------------------------------------
// Select between upstream and local paths

assign db_down_sel  = db_up_v & ~(int_ss_any & tog_q);

assign db_down_v    = int_ss_any | db_up_v;
assign db_down_data = (db_down_sel) ? db_up_data : {unit
                                                   ,int_ss_aid_scaled
                                                   ,int_ss_class
                                                   ,int_data_q[int_ss_aid_in]};         // max value of (encoded) int_ss_aid_in is NUM_INTS-1

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
 if (~hqm_inp_gated_rst_n) begin
  tog_q <= 1'b0;
 end else begin
  if (int_ss_any & db_up_v & db_down_ready) tog_q <= ~tog_q;
 end
end

assign int_ss_ready = int_ss_any & ~db_down_sel & db_down_ready;
assign db_up_ready  = db_up_v    &  db_down_sel & db_down_ready;

//-----------------------------------------------------------------------------------------------------
// Double buffer the downstream interface

logic out_valid ;
hqm_AW_double_buffer #(.WIDTH($bits(db_down_data)), .NOT_EMPTY_AT_EOT(0)) i_db_down (

         .clk       (hqm_inp_gated_clk)
        ,.rst_n     (hqm_inp_gated_rst_n)

        ,.status    (status[13:7])

        ,.in_ready  (db_down_ready)

        ,.in_valid  (db_down_v)
        ,.in_data   (db_down_data)

        ,.out_ready (int_down_ready)

        ,.out_valid (out_valid)
        ,.out_data  (int_down_data)
);

assign int_down_v = rst_prep ? 1'b0 : out_valid ;

assign status[31:14] = 18'd0;

assign int_idle = ( status [ 1 : 0 ] == 2'd0 ) & ( status [ 8 : 7 ] == 2'd0 ) ;

endmodule // AW_int_serializer

