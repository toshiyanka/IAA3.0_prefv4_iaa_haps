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
// hqm_AW_rmw_mem_pipe
//
//          p0 p1 p2 p3
//       wr xx xx xx xx
//       wr wr xx xx xx             first write req
//  t0   rd wr wr xx xx             second write req
//  t1   xx rd wr wr xx             read req. first and second rmw in progress
//  t2   xx xx rd wr wr             read data select
//  t3   xx xx xx rd wr             read data valid, 
//
// cmd[0] is used internally as read or write indication.
// cmd[n-1:1] are not used internally. These are pipelined and provide for external use only.
//
//                               +------+                                      +-------+
//                cmd_v/cmd ---->| pipe |                                      |  mem  |
//                               |      |----> p0_mem_rd_v,p0_mem_rd_addr ---->|       |<-----+
//                               |      |                                      |       |      |
//                               |      |<---- p1_mem_rd_data -----------------|       |      |
//                               |      |                                      +-------+      |
//  p2_mem_rd_v,p2_mem_wr_v <----|      |                                                     |
//                               |      |                                                     |
//          +- p2_mem_rd_data ---|      |                                                     |
//          |                    |      |                                                     |
//      +---v---+ p2_write_data  |      |                                                     |
//      |       |--------------->|      |                                                     |
//      +-------+                |      |                                                     |
//                               |      |                                                     |                   
//                               |      |----> p3_mem_wr_v,p3_mem_wr_addr,p3_mem_wr_data -----+
//                               +------+
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_rmw_mem_pipe 
   import hqm_AW_pkg::* 
; #(
   parameter CMD_WIDTH = 1
  ,parameter ADDR_WIDTH = 8
  ,parameter DATA_WIDTH = 8
) (
   input logic clk
  ,input logic rst_n
  ,input logic cmd_v
  ,input logic [(CMD_WIDTH-1):0] cmd
  ,input logic [(ADDR_WIDTH-1):0] addr
  ,output logic p0_cmd_v_f
  ,output logic [(CMD_WIDTH-1):0] p0_cmd_f
  ,output logic p0_mem_rd_v_f
  ,output logic p0_mem_wr_v_f
  ,output logic [(ADDR_WIDTH-1):0] p0_mem_rd_addr_f
  ,output logic p1_cmd_v_f
  ,output logic [(CMD_WIDTH-1):0] p1_cmd_f
  ,input logic [(DATA_WIDTH-1):0] p1_mem_rd_data
  ,output logic p2_cmd_v_f
  ,output logic [(CMD_WIDTH-1):0] p2_cmd_f
  ,output logic p2_mem_rd_v_f
  ,output logic p2_mem_wr_v_f
  ,output logic [(ADDR_WIDTH-1):0] p2_mem_rd_addr_f
  ,output logic [(DATA_WIDTH-1):0] p2_mem_rd_data_f
  ,input logic [(DATA_WIDTH-1):0] p2_write_data
  ,output logic p3_cmd_v_f
  ,output logic [(CMD_WIDTH-1):0] p3_cmd_f
  ,output logic p3_mem_wr_v_f
  ,output logic [(ADDR_WIDTH-1):0] p3_mem_wr_addr_f
  ,output logic [(DATA_WIDTH-1):0] p3_mem_wr_data_f
); 

logic read;
logic write;


logic p1_mem_rd_v_f;
logic p1_mem_wr_v_f;
logic [(ADDR_WIDTH-1):0] p1_mem_rd_addr_f;


logic p2_mem_rd_data_sel_f;
logic p3_mem_rd_data_sel_f;

always_comb begin
   read = cmd_v && !cmd[0];
   write = cmd_v && cmd[0];
end // always_comb

always_ff @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      p0_cmd_v_f <= 1'b0;
      p0_mem_rd_v_f <= 1'b0;
      p0_mem_wr_v_f <= 1'b0;

      p1_cmd_v_f <= 1'b0;
      p1_mem_rd_v_f <= 1'b0;
      p1_mem_wr_v_f <= 1'b0;

      p2_cmd_v_f <= 1'b0;
      p2_mem_rd_v_f <= 1'b0;
      p2_mem_wr_v_f <= 1'b0;
      p2_mem_rd_data_sel_f <= 1'b0;

      p3_cmd_v_f <= 1'b0;
      p3_mem_wr_v_f <= 1'b0;
      p3_mem_rd_data_sel_f <= 1'b0;
   end
   else begin
      p0_cmd_v_f <= cmd_v;
      p0_mem_rd_v_f <= read || write;
      p0_mem_wr_v_f <= write;

      p1_cmd_v_f <= p0_cmd_v_f;
      p1_mem_rd_v_f <= p0_mem_rd_v_f;
      p1_mem_wr_v_f <= p0_mem_wr_v_f;

      p2_cmd_v_f <= p1_cmd_v_f;
      p2_mem_rd_v_f <= p1_mem_rd_v_f;
      p2_mem_wr_v_f <= p1_mem_wr_v_f;
      p2_mem_rd_data_sel_f <= p1_mem_wr_v_f && (p1_mem_rd_addr_f==p0_mem_rd_addr_f);

      p3_cmd_v_f <= p2_cmd_v_f;
      p3_mem_wr_v_f <= p2_mem_wr_v_f;
      p3_mem_rd_data_sel_f <= p2_mem_wr_v_f && (p2_mem_rd_addr_f==p0_mem_rd_addr_f);
   end
end // always_ff

always_ff @(posedge clk) begin
   p0_cmd_f <= cmd_v ? cmd : p0_cmd_f;
   p0_mem_rd_addr_f <= (read ^ write) ? addr : p0_mem_rd_addr_f;

   p1_cmd_f <= p0_cmd_v_f ? p0_cmd_f : p1_cmd_f;
   p1_mem_rd_addr_f <= p0_mem_rd_v_f ? p0_mem_rd_addr_f : p1_mem_rd_addr_f;

   p2_cmd_f <= p1_cmd_v_f ? p1_cmd_f : p2_cmd_f;
   p2_mem_rd_addr_f <= p1_mem_rd_v_f ? p1_mem_rd_addr_f : p2_mem_rd_addr_f;
   p2_mem_rd_data_f <= p1_mem_rd_v_f && p2_mem_rd_data_sel_f ? p2_write_data :
                       p1_mem_rd_v_f && p3_mem_rd_data_sel_f ? p3_mem_wr_data_f :
                       p1_mem_rd_v_f ? p1_mem_rd_data :
                       p2_mem_rd_data_f;

   p3_cmd_f <= p2_cmd_v_f ? p2_cmd_f : p3_cmd_f;
   p3_mem_wr_addr_f <= p2_mem_wr_v_f ? p2_mem_rd_addr_f : p3_mem_wr_addr_f;
   p3_mem_wr_data_f <= p2_mem_wr_v_f ? p2_write_data : p3_mem_wr_data_f;
end // always_ff

endmodule // hqm_AW_rmw_mem_pipe
