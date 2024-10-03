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
// hqm_AW_wmaster
//
//                         +--------+
//      core request ----> |        | ----> axi request (AW, W channel) single beat request only
//     core response <---- |        | <---- axi response (B channel)               
//                         +--------+
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_wmaster
   import hqm_AW_pkg::*
; #(
   parameter ID_WIDTH = 6
  ,parameter ADDR_WIDTH = 12
  ,parameter DATA_WIDTH = 128
  ,parameter AWUSER_WIDTH = 6
  ,parameter WUSER_WIDTH = 6
  ,parameter BUSER_WIDTH = 6
) (
   input logic clk
  ,input logic rst_n
  ,output logic core_awready
  ,input logic core_awvalid
  ,input logic [ID_WIDTH-1:0] core_awid
  ,input logic [ADDR_WIDTH-1:0] core_awaddr
  ,input logic [AWUSER_WIDTH-1:0] core_awuser
  ,output logic core_wready 
  ,input logic core_wvalid
  ,input logic [ID_WIDTH-1:0] core_wid
  ,input logic [DATA_WIDTH-1:0] core_wdata
  ,input logic [WUSER_WIDTH-1:0] core_wuser
  ,input logic awready
  ,output logic awvalid
  ,output logic [ID_WIDTH-1:0] awid 
  ,output logic [ADDR_WIDTH-1:0] awaddr
  ,output logic [AWUSER_WIDTH-1:0] awuser
  ,input logic wready
  ,output logic wvalid
  ,output logic [ID_WIDTH-1:0] wid
  ,output logic [DATA_WIDTH-1:0] wdata
  ,output logic [WUSER_WIDTH-1:0] wuser
  ,output logic bready
  ,input logic bvalid
  ,input logic [ID_WIDTH-1:0] bid
  ,input logic [1:0] bresp
  ,input logic [BUSER_WIDTH-1:0] buser
  ,input logic core_bready
  ,output logic core_bvalid
  ,output logic [ID_WIDTH-1:0] core_bid
  ,output logic [1:0] core_bresp
  ,output logic [BUSER_WIDTH-1:0] core_buser
  ,output logic [20:0] wmaster_db_status  // {b, w, aw } 
);

localparam CORE_AW_DB_DATA_WIDTH = $bits(core_awid) +
                                   $bits(core_awaddr) +
                                   $bits(core_awuser);
localparam CORE_W_DB_DATA_WIDTH = $bits(core_wid) +
                                  $bits(core_wdata) +
                                  $bits(core_wuser);
localparam AXI_B_DB_DATA_WIDTH = $bits(bid) +
                                 $bits(bresp) +
                                 $bits(buser);

logic core_aw_db_in_ready;
logic core_aw_db_in_valid;
logic [(CORE_AW_DB_DATA_WIDTH-1):0] core_aw_db_in_data;
logic core_aw_db_out_ready;
logic core_aw_db_out_valid;
logic [(CORE_AW_DB_DATA_WIDTH-1):0] core_aw_db_out_data; 
logic core_w_db_in_ready;
logic core_w_db_in_valid;
logic [(CORE_W_DB_DATA_WIDTH-1):0] core_w_db_in_data;
logic core_w_db_out_ready;
logic core_w_db_out_valid;
logic [(CORE_W_DB_DATA_WIDTH-1):0] core_w_db_out_data; 
logic awvalid_taken_next;
logic wvalid_taken_next;
logic awvalid_taken_q;
logic wvalid_taken_q;
logic axi_b_db_in_ready;
logic axi_b_db_in_valid;
logic [(AXI_B_DB_DATA_WIDTH-1):0] axi_b_db_in_data;
logic axi_b_db_out_ready;
logic axi_b_db_out_valid;
logic [(AXI_B_DB_DATA_WIDTH-1):0] axi_b_db_out_data; 

hqm_AW_double_buffer #( 
   .WIDTH(CORE_AW_DB_DATA_WIDTH)
) i_core_aw_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(wmaster_db_status[6:0])
  ,.in_ready(core_aw_db_in_ready)
  ,.in_valid(core_aw_db_in_valid)
  ,.in_data(core_aw_db_in_data)
  ,.out_ready(core_aw_db_out_ready)
  ,.out_valid(core_aw_db_out_valid)
  ,.out_data(core_aw_db_out_data)
) ;

hqm_AW_double_buffer #( 
   .WIDTH(CORE_W_DB_DATA_WIDTH)
) i_core_w_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(wmaster_db_status[13:7])
  ,.in_ready(core_w_db_in_ready)
  ,.in_valid(core_w_db_in_valid)
  ,.in_data(core_w_db_in_data)
  ,.out_ready(core_w_db_out_ready)
  ,.out_valid(core_w_db_out_valid)
  ,.out_data(core_w_db_out_data)
) ;

hqm_AW_double_buffer #( 
   .WIDTH(AXI_B_DB_DATA_WIDTH)
) i_axi_b_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(wmaster_db_status[20:14])
  ,.in_ready(axi_b_db_in_ready)
  ,.in_valid(axi_b_db_in_valid)
  ,.in_data(axi_b_db_in_data)
  ,.out_ready(axi_b_db_out_ready)
  ,.out_valid(axi_b_db_out_valid)
  ,.out_data(axi_b_db_out_data)
) ;

always_comb begin
   core_awready = core_aw_db_in_ready; 
   core_aw_db_in_valid = core_awvalid;
   core_aw_db_in_data = {core_awid 
                        ,core_awaddr
                        ,core_awuser
                        };
   core_wready = core_w_db_in_ready;
   core_w_db_in_valid = core_wvalid;
   core_w_db_in_data = {core_wid 
                       ,core_wdata
                       ,core_wuser
                       };
   awvalid = core_aw_db_out_valid && !awvalid_taken_q;
   {awid
   ,awaddr
   ,awuser
   } = core_aw_db_out_data;
   wvalid = core_aw_db_out_valid && !wvalid_taken_q;
   {wid
   ,wdata
   ,wuser
   } = core_w_db_out_data;
   awvalid_taken_next = awvalid_taken_q;
   wvalid_taken_next = wvalid_taken_q;
   core_aw_db_out_ready = 1'b0;
   core_w_db_out_ready = 1'b0;
   if (awready && wready) begin
      awvalid_taken_next = 1'b0;
      wvalid_taken_next = 1'b0;
      core_aw_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid;
      core_w_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid;
   end
   else begin
      if (awready) begin
         if (wvalid_taken_q) begin
            awvalid_taken_next = 1'b0;
            wvalid_taken_next = 1'b0;
         end
         else begin
            awvalid_taken_next = core_aw_db_out_valid;
            wvalid_taken_next = 1'b0; 
         end
         core_aw_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid && wvalid_taken_q;
         core_w_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid && wvalid_taken_q;
      end
      if (wready) begin
         if (awvalid_taken_q) begin
            awvalid_taken_next = 1'b0;
            wvalid_taken_next = 1'b0;
         end
         else begin
            awvalid_taken_next = 1'b0; 
            wvalid_taken_next = core_aw_db_out_valid;
         end
         core_aw_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid && awvalid_taken_q;
         core_w_db_out_ready = core_aw_db_out_valid && core_w_db_out_valid && awvalid_taken_q;
      end
   end
   bready = axi_b_db_in_ready;
   axi_b_db_in_valid = bvalid;
   axi_b_db_in_data = {bid
                      ,bresp
                      ,buser
                      };
   axi_b_db_out_ready = core_bready;
   core_bvalid = axi_b_db_out_valid;
   {core_bid
   ,core_bresp
   ,core_buser
   } = axi_b_db_out_data;

end // always_comb

always_ff @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      awvalid_taken_q <= 1'b0;
      wvalid_taken_q <= 1'b0;
   end
   else begin
      awvalid_taken_q <= awvalid_taken_next;
      wvalid_taken_q <= wvalid_taken_next;
   end
end // always_ff


endmodule // hqm_AW_wmaster
