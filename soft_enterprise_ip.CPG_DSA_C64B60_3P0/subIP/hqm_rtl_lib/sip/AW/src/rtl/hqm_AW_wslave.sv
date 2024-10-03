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
// hqm_AW_wslave
//
//                         +--------+
//      core request <---- |        | <---- axi request (AW, W channel) single beat request only
//     core response ----> |        | ----> axi response (B channel)
//                         +--------+
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_wslave
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
  ,input logic core_awready
  ,output logic core_awvalid
  ,output logic [ID_WIDTH-1:0] core_awid
  ,output logic [ADDR_WIDTH-1:0] core_awaddr
  ,output logic [AWUSER_WIDTH-1:0] core_awuser
  ,input logic core_wready
  ,output logic core_wvalid
  ,output logic [ID_WIDTH-1:0] core_wid
  ,output logic [DATA_WIDTH-1:0] core_wdata
  ,output logic [WUSER_WIDTH-1:0] core_wuser
  ,output logic awready
  ,input logic awvalid
  ,input logic [ID_WIDTH-1:0] awid
  ,input logic [ADDR_WIDTH-1:0] awaddr
  ,input logic [AWUSER_WIDTH-1:0] awuser
  ,output logic wready
  ,input logic wvalid
  ,input logic [ID_WIDTH-1:0] wid
  ,input logic [DATA_WIDTH-1:0] wdata
  ,input logic [WUSER_WIDTH-1:0] wuser
  ,input logic bready
  ,output logic bvalid
  ,output logic [ID_WIDTH-1:0] bid
  ,output logic [1:0] bresp
  ,output logic [BUSER_WIDTH-1:0] buser
  ,output logic core_bready
  ,input logic core_bvalid
  ,input logic [ID_WIDTH-1:0] core_bid
  ,input logic [1:0] core_bresp
  ,input logic [BUSER_WIDTH-1:0] core_buser

  ,output logic [20:0] wslave_db_status
);

localparam AXI_AW_DB_DATA_WIDTH = $bits(awid) +
                                  $bits(awaddr) +
                                  $bits(awuser);
localparam AXI_W_DB_DATA_WIDTH = $bits(wid) +
                                 $bits(wdata) +
                                 $bits(wuser);
localparam CORE_B_DB_DATA_WIDTH = $bits(core_bid) +
                                  $bits(core_bresp) +
                                  $bits(core_buser);


logic axi_aw_db_in_ready;
logic axi_aw_db_in_valid;
logic [(AXI_AW_DB_DATA_WIDTH-1):0] axi_aw_db_in_data;
logic axi_aw_db_out_ready;
logic axi_aw_db_out_valid;
logic [(AXI_AW_DB_DATA_WIDTH-1):0] axi_aw_db_out_data; 
logic axi_w_db_in_ready;
logic axi_w_db_in_valid;
logic [(AXI_W_DB_DATA_WIDTH-1):0] axi_w_db_in_data;
logic axi_w_db_out_ready;
logic axi_w_db_out_valid;
logic [(AXI_W_DB_DATA_WIDTH-1):0] axi_w_db_out_data; 
logic core_awvalid_taken_next;
logic core_wvalid_taken_next;
logic core_awvalid_taken_q;
logic core_wvalid_taken_q;
logic core_b_db_in_ready;
logic core_b_db_in_valid;
logic [(CORE_B_DB_DATA_WIDTH-1):0] core_b_db_in_data;
logic core_b_db_out_ready;
logic core_b_db_out_valid;
logic [(CORE_B_DB_DATA_WIDTH-1):0] core_b_db_out_data; 

logic [6:0] aw_db_status;
logic [6:0] w_db_status;
logic [6:0] b_db_status;

assign wslave_db_status = {
                           b_db_status
                          ,w_db_status
                          ,aw_db_status
                         };

hqm_AW_double_buffer #( 
   .WIDTH(AXI_AW_DB_DATA_WIDTH)
) i_axi_aw_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(aw_db_status)
  ,.in_ready(axi_aw_db_in_ready)
  ,.in_valid(axi_aw_db_in_valid)
  ,.in_data(axi_aw_db_in_data)
  ,.out_ready(axi_aw_db_out_ready)
  ,.out_valid(axi_aw_db_out_valid)
  ,.out_data(axi_aw_db_out_data)
) ;

hqm_AW_double_buffer #( 
   .WIDTH(AXI_W_DB_DATA_WIDTH)
) i_axi_w_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(w_db_status)
  ,.in_ready(axi_w_db_in_ready)
  ,.in_valid(axi_w_db_in_valid)
  ,.in_data(axi_w_db_in_data)
  ,.out_ready(axi_w_db_out_ready)
  ,.out_valid(axi_w_db_out_valid)
  ,.out_data(axi_w_db_out_data)
) ;

hqm_AW_double_buffer #( 
   .WIDTH(CORE_B_DB_DATA_WIDTH)
) i_core_b_db (
   .clk(clk) 
  ,.rst_n(rst_n)
  ,.status(b_db_status)
  ,.in_ready(core_b_db_in_ready)
  ,.in_valid(core_b_db_in_valid)
  ,.in_data(core_b_db_in_data)
  ,.out_ready(core_b_db_out_ready)
  ,.out_valid(core_b_db_out_valid)
  ,.out_data(core_b_db_out_data)
) ;

always_comb begin
   awready = axi_aw_db_in_ready;
   axi_aw_db_in_valid = awvalid;
   axi_aw_db_in_data = {awid
                       ,awaddr
                       ,awuser
                       };
   wready = axi_w_db_in_ready;
   axi_w_db_in_valid = wvalid;
   axi_w_db_in_data = {wid
                      ,wdata
                      ,wuser
                      };
   core_awvalid = axi_aw_db_out_valid && axi_w_db_out_valid && !core_awvalid_taken_q;
   {core_awid
   ,core_awaddr
   ,core_awuser
   } = axi_aw_db_out_data;
   core_wvalid = axi_aw_db_out_valid && axi_w_db_out_valid && !core_wvalid_taken_q;
   {core_wid
   ,core_wdata
   ,core_wuser
   } = axi_w_db_out_data;
   core_awvalid_taken_next = core_awvalid_taken_q;
   core_wvalid_taken_next = core_wvalid_taken_q;
   axi_aw_db_out_ready = 1'b0;
   axi_w_db_out_ready = 1'b0;
   if (core_awready && core_wready) begin
      core_awvalid_taken_next = 1'b0;
      core_wvalid_taken_next = 1'b0;
      axi_aw_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid;
      axi_w_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid;
   end
   else begin
      if (core_awready) begin
         core_awvalid_taken_next = axi_aw_db_out_valid && !core_wvalid_taken_q;
         axi_aw_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid && core_wvalid_taken_q;
         axi_w_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid && core_wvalid_taken_q;
      end
      if (core_wready) begin
         core_wvalid_taken_next = axi_aw_db_out_valid && !core_awvalid_taken_q;
         axi_aw_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid && core_awvalid_taken_q;
         axi_w_db_out_ready = axi_aw_db_out_valid && axi_w_db_out_valid && core_awvalid_taken_q;
      end
   end
   core_bready = core_b_db_in_ready;
   core_b_db_in_valid = core_bvalid;
   core_b_db_in_data = {core_bid
                       ,core_bresp
                       ,core_buser
                       };
   core_b_db_out_ready = bready;
   bvalid = core_b_db_out_valid;
   {bid
   ,bresp
   ,buser
   } = core_b_db_out_data;

end // always_comb

always_ff @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      core_awvalid_taken_q <= 1'b0;
      core_wvalid_taken_q <= 1'b0;
   end
   else begin
      core_awvalid_taken_q <= core_awvalid_taken_next;
      core_wvalid_taken_q <= core_wvalid_taken_next;
   end
end // always_ff

endmodule // hqm_AW_wslave
