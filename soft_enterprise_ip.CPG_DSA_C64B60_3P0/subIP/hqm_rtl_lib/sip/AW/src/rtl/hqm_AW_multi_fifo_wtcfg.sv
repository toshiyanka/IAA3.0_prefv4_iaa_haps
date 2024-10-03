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
// hqm_AW_multi_fifo_wtcfg
//
// Control for multiple FIFOs sharing a single, single-port RAM.  Includes support for config accesses
// to each internal RAM structure.  Read vs. write collisions on pointers and min/max addresses are
// managed by the rmw AW.  Because the push/pop pointers are stored in a shared RAM, as are the
// min/max addresses, an rmw is required for config writes to any of these.  If the FIFO RAM is wider
// than 32 bits, it is assumed that for config purposes the FIFO RAM appears as a series of "n"
// 32-bit words on a power-of-2 config word address boundary.
//
// It is REQUIRED that while a given cfg access is in progress that there be no functional access or
// additional cfg access attempted.
//
// The shared FIFO memory includes no hardware error checking; it is assumed that the parent module is
// including a parity bit or ECC bits as data.  The other memories are covered with residue checking.
// On configuration writes correct residue is generated internally.  A residue error on this shared
// structure can only be due to a hardware failure and will require a pf reset; there is no attempt
// to block a push/pop and/or FIFO memory read/write on a residue error due to delay concerns.  A
// FIFO overflow/underflow can be caused by bad software or a "system error", so they block push/pop
// pointer advances.
//
// Parameters that may be specified:
// NUM_FIFOS = number of individual, logical FIFOs which the multi FIFO is to be divided into
// DEPTH = depth of the shared RAM
// DWIDTH = width of data stored in shared RAM, including parity (if any)
//
// Config access to the 5 logical RAM structures uses the following target map:
// 0: push_ptr
// 1: pop_ptr
// 2: min_addr
// 3: max_addr
// 4: fmem
//
// Pipeline stages are:
// p0: input stage (read pointers/minmax)               <== inputs are registered here
// p1: pointers/minmax read data
// p2: read/write FIFO RAM
// p3: FIFO RAM read data; write pointers/minmax        <== output appears here
//-----------------------------------------------------------------------------------------------------

// 
module hqm_AW_multi_fifo_wtcfg
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
// Config access to memories for push/pop ptrs (ptr), min/max address (minmax) or FIFO mem (fmem)
, input  cfg_req_t              cfg_req
, input  logic [4:0]            cfg_req_write
, input  logic [4:0]            cfg_req_read
, output logic [4:0]            cfg_ack
, output logic [4:0]            cfg_err
, output logic [(5*32)-1:0]     cfg_rdata
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

logic fifo_aempty_nc ;
logic [3:0] fifo_depth_nc ;
logic [NUM_FIFOS-1:0] fifo_empty_nc ;

hqm_AW_multi_fifo_wm_wtcfg # (
    .NUM_FIFOS                          ( NUM_FIFOS )
  , .DEPTH                              ( DEPTH )
  , .DWIDTH                             ( DWIDTH )
  , .EMPTY_RESET_VAL                    ( 1'b1 )
) i_hqm_AW_multi_fifo_wm_wtcfg (
    .clk                                ( clk )
  , .rst_n                              ( rst_n )
  , .status                             ( status )
//----------------------------------------------------------------------------------------
// Functional commands
  , .cmd_v                              ( cmd_v )
  , .cmd                                ( cmd )
  , .fifo_num                           ( fifo_num )
  , .push_data                          ( push_data )
  , .push_offset                        ( push_offset )
  , .pop_data                           ( pop_data )
  , .pop_data_v                         ( pop_data_v )
  , .pop_data_last                      ( pop_data_last )
  , .fifo_low_wm                        ( { WMWIDTH { 1'b0 } } )
  , .fifo_aempty                        ( fifo_aempty_nc )
  , .fifo_depth                         ( fifo_depth_nc )
  , .fifo_empty                         ( fifo_empty_nc )
//----------------------------------------------------------------------------------------
// Config access to memories for push/pop ptrs (ptr), min/max address (minmax) or FIFO mem (fmem)
  , .cfg_req                            ( cfg_req )
  , .cfg_req_write                      ( cfg_req_write )
  , .cfg_req_read                       ( cfg_req_read )
  , .cfg_ack                            ( cfg_ack )
  , .cfg_err                            ( cfg_err )
  , .cfg_rdata                          ( cfg_rdata )
//----------------------------------------------------------------------------------------
// Pipeline valids / holds
  , .p0_v_f                             ( p0_v_f )
  , .p0_hold                            ( p0_hold )
  , .p1_v_f                             ( p1_v_f )
  , .p1_hold                            ( p1_hold )
  , .p2_v_f                             ( p2_v_f )
  , .p2_hold                            ( p2_hold )
  , .p3_v_f                             ( p3_v_f )
  , .p3_hold                            ( p3_hold )
//----------------------------------------------------------------------------------------
// Error reporting
  , .err_rid                            ( err_rid )
  , .err_uflow                          ( err_uflow )
  , .err_oflow                          ( err_oflow )
  , .err_residue                        ( err_residue )
  , .err_residue_cfg                    ( err_residue_cfg )
//----------------------------------------------------------------------------------------
// Pointer mem interface (dual-port regfile)
  , .ptr_mem_re                         ( ptr_mem_re )
  , .ptr_mem_raddr                      ( ptr_mem_raddr )
  , .ptr_mem_we                         ( ptr_mem_we )
  , .ptr_mem_waddr                      ( ptr_mem_waddr )
  , .ptr_mem_wdata                      ( ptr_mem_wdata )
  , .ptr_mem_rdata                      ( ptr_mem_rdata )
//----------------------------------------------------------------------------------------
// Min/max mem interface (single-port regfile)
  , .minmax_mem_re                      ( minmax_mem_re )
  , .minmax_mem_addr                    ( minmax_mem_addr )
  , .minmax_mem_we                      ( minmax_mem_we )
  , .minmax_mem_wdata                   ( minmax_mem_wdata )
  , .minmax_mem_rdata                   ( minmax_mem_rdata )
//----------------------------------------------------------------------------------------
// FIFO mem interface (single-port sram)
  , .fifo_mem_re                        ( fifo_mem_re )
  , .fifo_mem_addr                      ( fifo_mem_addr )
  , .fifo_mem_we                        ( fifo_mem_we )
  , .fifo_mem_wdata                     ( fifo_mem_wdata )
  , .fifo_mem_rdata                     ( fifo_mem_rdata )
) ;

endmodule // hqm_AW_multi_fifo_wtcfg
// 
