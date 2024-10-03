//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_lifo_control_rw
  import hqm_AW_pkg::*;
#(
  parameter DEPTH                                 = 4
, parameter DWIDTH                                = 3
, parameter MSGWIDTH                              = 1
//
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DWIDTHB2                              = ( AW_logb2 ( DWIDTH - 1 ) + 1 )
, parameter MSGWIDTHB2                            = ( AW_logb2 ( MSGWIDTH - 1 ) + 1 )
) (
  input  logic                                    clk 
, input  logic                                    rst_n 

, output logic                                    mem_re
, output logic                                    mem_we 
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_addr 
, input  logic [ ( DWIDTH ) - 1 : 0 ]   mem_rdata 
, output logic [ ( DWIDTH ) - 1 : 0 ]   mem_wdata 

, input  logic                                    rw_in_v 
, input  aw_rwpipe_cmd_t                          rw_in_cmd 
, input  logic [ ( DWIDTH ) - 1 : 0 ]             rw_in_data 
, input  logic [ ( DEPTHB2 ) - 1 : 0 ]            rw_in_addr 
, input  logic [ ( MSGWIDTH ) - 1 : 0 ]           rw_in_msg 

, output logic                                    rw_out_v 
, output aw_rwpipe_cmd_t                          rw_out_cmd 
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            rw_out_addr 
, output logic [ ( DWIDTH ) - 1 : 0 ]             rw_out_data 
, output logic [ ( MSGWIDTH ) - 1 : 0 ]           rw_out_msg 

, output logic                                    status_idle 
);

//////////////////////////////////////////////////
typedef struct packed {
  aw_rwpipe_cmd_t cmd ;
  logic [ ( DEPTHB2 ) - 1 : 0 ] addr ;
  logic [ ( DWIDTH ) - 1 : 0 ] data ;
  logic [ ( MSGWIDTH ) - 1 : 0 ] msg ;
} pipe_struct_t ;
logic p0_v_nxt , p0_v_f , p1_v_nxt , p1_v_f , p2_v_nxt , p2_v_f ;
pipe_struct_t p0_data_nxt , p0_data_f , p1_data_nxt , p1_data_f , p2_data_nxt , p2_data_f ;
always_ff @( posedge clk or negedge rst_n ) begin: L001
  if ( ~ rst_n ) begin
    p0_v_f <= '0 ;
    p1_v_f <= '0 ;
    p2_v_f <= '0 ;
  end else begin
    p0_v_f <= p0_v_nxt ;
    p1_v_f <= p1_v_nxt ;
    p2_v_f <= p2_v_nxt ;
  end
end
always_ff @(posedge clk) begin
    p0_data_f <= p0_data_nxt ;
    p1_data_f <= p1_data_nxt ;
    p2_data_f <= p2_data_nxt ;
end


//drive outputs
assign mem_re                    = p0_v_f & ( p0_data_f.cmd == HQM_AW_RWPIPE_READ ) ;
assign mem_we                    = p0_v_f & ( p0_data_f.cmd == HQM_AW_RWPIPE_WRITE ) ;
assign mem_addr                  = p0_data_f.addr ;
assign mem_wdata            = p0_data_f.data ;
assign rw_out_v                  = p2_v_f ;
assign rw_out_cmd                = p2_data_f.cmd ;
assign rw_out_addr               = p2_data_f.addr ;
assign rw_out_data               = p2_data_f.data ;
assign rw_out_msg                = p2_data_f.msg ;
assign status_idle               = ~ ( p0_v_f | p1_v_f | p2_v_f ) ;

always_comb begin
  //pipeline data registers hold unless there is a new command to process
  p0_v_nxt                       = 1'b0 ;
  p1_v_nxt                       = p0_v_f ;
  p2_v_nxt                       = p1_v_f ;
  p0_data_nxt                    = p0_data_f ;
  p1_data_nxt                    = p0_v_f ? p0_data_f : p1_data_f ;
  p2_data_nxt                    = p1_v_f ? p1_data_f : p2_data_f ;

  // capture input read/write/noop & initialze pipeline with new command
  p0_v_nxt                       = rw_in_v ;
  if ( p0_v_nxt ) begin
    p0_data_nxt.cmd                = rw_in_cmd ;
    p0_data_nxt.addr               = rw_in_addr ;
    p0_data_nxt.data               = rw_in_data ;
    p0_data_nxt.msg                = rw_in_msg ;
  end

  //capture mem read return
  if ( p1_v_f & ( p1_data_f.cmd == HQM_AW_RWPIPE_READ ) ) begin
    p2_data_nxt.data             = mem_rdata ;
  end
end

endmodule // hqm_aw_rw_core
