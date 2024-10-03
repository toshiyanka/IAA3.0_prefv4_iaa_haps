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
module hqm_AW_multi_fifo
  import hqm_AW_pkg::*;
# (
  parameter NUM_FIFOS   = 8
, parameter DEPTH       = 1024
, parameter DWIDTH      = 64
, parameter AWIDTH      = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHWIDTH  = ( AW_logb2 ( DEPTH ) + 1 )
, parameter WMWIDTH     = ( AW_logb2 ( DEPTH + 1 ) + 1 )
, parameter NFWIDTH     = ( AW_logb2 ( NUM_FIFOS - 1 ) + 1 )
) (
  input  logic                  clk
, input  logic                  rst_n
, output logic                  status
//----------------------------------------------------------------------------------------
// Functional commands
, input  logic                  cmd_v
, input  aw_multi_fifo_cmd_t    cmd
, input  logic [NFWIDTH-1:0]    fifo_num
, input  logic [DWIDTH-1:0]     push_data
, input  logic [DEPTHWIDTH-1:0] push_offset
, output logic [DWIDTH-1:0]     pop_data
, output logic                  pop_data_v      // Output data valid - includes READ cmd
, output logic                  pop_data_last   // Pop caused the FIFO to go empty
//----------------------------------------------------------------------------------------
// Pipeline valids / holds
, output logic                  p0_v_f
, input  logic                  p0_hold
, output logic                  p1_v_f
, input  logic                  p1_hold
, output logic                  p2_v_f
, input  logic                  p2_hold
, output logic                  p3_v_f
, input  logic                  p3_hold
//----------------------------------------------------------------------------------------
// Error reporting
, output logic [NFWIDTH-1:0]    err_rid                 // Resource id (ultimately identify the VF)
  // The following are internally gated with the pipe valid signal
, output logic                  err_uflow
, output logic                  err_oflow
, output logic                  err_residue
, output logic                  err_residue_cfg         // Residue error detected on config read
//----------------------------------------------------------------------------------------
// Pointer mem interface (dual-port regfile)
, output logic                  ptr_mem_re
, output logic [NFWIDTH-1:0]    ptr_mem_raddr
, output logic                  ptr_mem_we
, output logic [NFWIDTH-1:0]    ptr_mem_waddr
, output logic [(2*(AWIDTH+3))-1:0]     ptr_mem_wdata   // 2*(residue,gen,ptr)
, input  logic [(2*(AWIDTH+3))-1:0]     ptr_mem_rdata   // 2*(residue,gen,ptr)
//----------------------------------------------------------------------------------------
// Min/max mem interface (single-port regfile)
, output logic                  minmax_mem_re
, output logic [NFWIDTH-1:0]    minmax_mem_addr
, output logic                  minmax_mem_we
, output logic [(2*(AWIDTH+2))-1:0]     minmax_mem_wdata // 2*(residue,ptr)
, input  logic [(2*(AWIDTH+2))-1:0]     minmax_mem_rdata // 2*(residue,ptr)
//----------------------------------------------------------------------------------------
// FIFO mem interface (single-port sram)
, output logic                  fifo_mem_re
, output logic [AWIDTH-1:0]     fifo_mem_addr
, output logic                  fifo_mem_we
, output logic [DWIDTH-1:0]     fifo_mem_wdata
, input  logic [DWIDTH-1:0]     fifo_mem_rdata
) ;

logic [4:0]             cfg_ack_nc ;
logic [4:0]             cfg_err_nc ;
logic [(5*32)-1:0]      cfg_rdata_nc ;
logic                   fifo_aempty_nc ;
logic [3:0]             fifo_depth_nc ;
logic [NUM_FIFOS-1:0]   fifo_empty_nc ;

hqm_AW_multi_fifo_wm_wtcfg # (
  .NUM_FIFOS ( NUM_FIFOS )
, .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
, .EMPTY_RESET_VAL ( 1'b1 )
) i_mf (
  .clk ( clk )
, .rst_n ( rst_n )
, .status ( status )
, .cmd_v ( cmd_v )
, .cmd ( cmd )
, .fifo_num ( fifo_num )
, .push_data ( push_data )
, .push_offset ( push_offset )
, .pop_data ( pop_data )
, .pop_data_v ( pop_data_v )
, .pop_data_last ( pop_data_last )
, .fifo_low_wm ( { WMWIDTH { 1'b0 } } )
, .fifo_aempty ( fifo_aempty_nc )
, .fifo_depth ( fifo_depth_nc )
, .fifo_empty ( fifo_empty_nc )
, .cfg_req ( '0 )
, .cfg_req_write ( 5'h0 )
, .cfg_req_read ( 5'h0 )
, .cfg_ack ( cfg_ack_nc )
, .cfg_err ( cfg_err_nc )
, .cfg_rdata ( cfg_rdata_nc )
, .p0_v_f ( p0_v_f )
, .p0_hold ( p0_hold )
, .p1_v_f ( p1_v_f )
, .p1_hold ( p1_hold )
, .p2_v_f ( p2_v_f )
, .p2_hold ( p2_hold )
, .p3_v_f ( p3_v_f )
, .p3_hold ( p3_hold )
, .err_rid ( err_rid )
, .err_uflow ( err_uflow )
, .err_oflow ( err_oflow )
, .err_residue ( err_residue )
, .err_residue_cfg ( err_residue_cfg )
, .ptr_mem_re ( ptr_mem_re )
, .ptr_mem_raddr ( ptr_mem_raddr )
, .ptr_mem_we ( ptr_mem_we )
, .ptr_mem_waddr ( ptr_mem_waddr )
, .ptr_mem_wdata ( ptr_mem_wdata )
, .ptr_mem_rdata ( ptr_mem_rdata )
, .minmax_mem_re ( minmax_mem_re )
, .minmax_mem_addr ( minmax_mem_addr )
, .minmax_mem_we ( minmax_mem_we )
, .minmax_mem_wdata ( minmax_mem_wdata )
, .minmax_mem_rdata ( minmax_mem_rdata )
, .fifo_mem_re ( fifo_mem_re )
, .fifo_mem_addr ( fifo_mem_addr )
, .fifo_mem_we ( fifo_mem_we )
, .fifo_mem_wdata ( fifo_mem_wdata )
, .fifo_mem_rdata ( fifo_mem_rdata )
) ;

endmodule
