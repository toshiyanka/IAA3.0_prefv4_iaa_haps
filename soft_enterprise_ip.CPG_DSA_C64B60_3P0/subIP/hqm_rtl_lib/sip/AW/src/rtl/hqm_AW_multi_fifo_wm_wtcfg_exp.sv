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
// hqm_AW_multi_fifo_wm_wtcfg_exp
//
// Same as hqm_AW_multi_fifo_wm_wtcfg but with additional p0 level empty/full vectors to support expanded mode.
//
//-----------------------------------------------------------------------------------------------------

// 
module hqm_AW_multi_fifo_wm_wtcfg_exp
  import hqm_AW_pkg::*;
# (
  parameter NUM_FIFOS   = 8
, parameter DEPTH       = 1024
, parameter DWIDTH      = 64
, parameter WRAP_RESET_VAL     = 1'b0
, parameter EMPTY_RESET_VAL     = 1'b1
// Note: the following parameter values should not be specified where this module is instantiated
, parameter AWIDTH      = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHWIDTH  = ( AW_logb2 ( DEPTH ) + 1 )
, parameter WMWIDTH     = DEPTHWIDTH                    // No reason to be different than DEPTHWIDTH
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
, input  logic [WMWIDTH-1:0]    fifo_low_wm 
, output logic                  fifo_aempty 
, output logic [3:0]            fifo_depth
, output logic [NUM_FIFOS-1:0]  fifo_empty      // One bit per FIFO, updated when push/pop pointers written
                                                // Can NOT be used to dynamically indicate if ok to pop
, output logic [NUM_FIFOS-1:0]  p0_fifo_re_wrap  
, output logic [NUM_FIFOS-1:0]  p0_fifo_we_wrap  
, output logic [NUM_FIFOS-1:0]  p0_fifo_full  
, output logic [NUM_FIFOS-1:0]  p0_fifo_empty  
//----------------------------------------------------------------------------------------
// Config access to memories for push/pop ptrs (ptr), min/max address (minmax) or FIFO mem (fmem)
, input  cfg_req_t              cfg_req                 // Note: only some fields used
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

// Number of additional config address bits needed to access a full FIFO memory location.
localparam CFG_MUX_DEGREE       = ( AW_logb2 ( DWIDTH - 1 ) < 4 ) ? 0 : ( AW_logb2 ( DWIDTH - 1 ) - 4 ) ;

localparam CFG_MUX_DEGREE_POW2  = ( 1 << CFG_MUX_DEGREE ) ;
localparam DWIDTH_ROUNDUP       = CFG_MUX_DEGREE_POW2 * 32 ;
// CDWIDTH needs to be at least 32 to support cfg writes (data padded with 0 if needed).  If
// DWIDTH is larger then needs to be that large.  AWIDTH > 31 not needed and not supported.
localparam CDWIDTH              = ( DWIDTH > 32 ) ? DWIDTH : 32 ;
localparam CAWIDTH              = AWIDTH + CFG_MUX_DEGREE ;

typedef enum logic [3:0] {              
  CMD_NOOP      = 4'h0
, CMD_PUSH      = 4'h1
, CMD_POP       = 4'h2
, CMD_READ      = 4'h3
, CMD_INIT_PTRS = 4'h4
, CMD_APPEND    = 4'h5
, CFG_PUSH_PTR  = 4'h6
, CFG_POP_PTR   = 4'h7
, CFG_MIN_ADDR  = 4'h8
, CFG_MAX_ADDR  = 4'h9
, CFG_FMEM      = 4'ha
, CMD_UNDEF0    = 4'hb
, CMD_UNDEF1    = 4'hc
, CMD_UNDEF2    = 4'hd
, CMD_UNDEF3    = 4'he
, CMD_UNDEF4    = 4'hf
} cmd_t ;

typedef enum logic {                    
  CFG_RD          = 1'b0
, CFG_WR          = 1'b1
} cfg_cmd_rw_t ;

typedef struct packed {                 
  cmd_t                 cmd ;
  cfg_cmd_rw_t          cfg_rw ;
  logic                 cfg_err ;
  logic [CDWIDTH-1:0]   data ;
  logic [CAWIDTH-1:0]   addr ;
} cmd_pipe_t ; 

typedef struct packed {                 
  logic [1:0]                   off_res ;
  logic [DEPTHWIDTH-1:0]        off ;
} off_pipe_t ; 

typedef union packed {
  logic [AWIDTH+2:0]  ptr_all ;
  struct packed {
    logic [1:0]         ptr_res ;
    logic               ptr_gen ;
    logic [AWIDTH-1:0]  ptr ;
  } pa ;
} ptr_t ;

typedef struct packed {
  aw_rmwpipe_cmd_t      rw_cmd ;
  logic [NFWIDTH-1:0]   addr ;
  ptr_t                 push_ptr ;
  ptr_t                 pop_ptr ;
} ptr_pipe_t ;

typedef union packed {
  logic [AWIDTH+1:0]    bounds_all ;
  struct packed {
    logic [1:0]         bounds_res ;
    logic [AWIDTH-1:0]  bounds ;
  } ba ;
} bounds_t ;

typedef struct packed {
  aw_rmwpipe_cmd_t      rw_cmd ;
  logic [NFWIDTH-1:0]   addr ;
  bounds_t              max_addr ;
  bounds_t              min_addr ;
} bounds_pipe_t ;

typedef enum logic [1:0] {              
  UFLOW         = 2'b00
, OFLOW         = 2'b01
, RERR          = 2'b10
, RERR_CFG      = 2'b11                 // residue error on config read
} err_type_t ;

//----------------------------------------------------------------------------------------
logic                           cfg_cmd_v ;
logic [4:0]                     cfg_req_either ;
logic                           cfg_req_read_any ;
logic                           cfg_req_write_any ;
logic                           cfg_req_addr_error ;


cmd_pipe_t                      p0_cmd_pipe_nxt ;
cmd_pipe_t                      p0_cmd_pipe_f ;
logic                           p0_v_first_f ;
logic                           p0_v_first_nnc ;                // Note: lint tool says this is nc if DWIDTH <= 32
logic                           p0_hold_aggregate ;
logic                           p0_enable ;
cmd_pipe_t                      p1_cmd_pipe_nxt ;
cmd_pipe_t                      p1_cmd_pipe_f ;
logic                           p1_enable ;
logic                           p1_hold_aggregate ;
cmd_pipe_t                      p2_cmd_pipe_nxt ;
cmd_pipe_t                      p2_cmd_pipe_f ;
logic                           p2_oflow_nxt ;
logic                           p2_oflow_f ;
logic                           p2_enable ;
logic                           p2_hold_aggregate ;
logic                           p2_v_first_f ;
cmd_pipe_t                      p3_cmd_pipe_nxt ;
cmd_pipe_t                      p3_cmd_pipe_f ;
logic                           p3_enable ;
logic                           p3_hold_aggregate ;
logic                           p3_v_first_f ;

logic                           p3_fifo_aempty_nxt ;
logic                           p3_fifo_aempty_f ;
logic [3:0]                     p3_fifo_depth_nxt ;             // May want to scale this by DEPTHWIDTH in the future
logic [3:0]                     p3_fifo_depth_f ;               // May want to scale this by DEPTHWIDTH in the future
logic [NUM_FIFOS-1:0]           fifo_empty_nxt ;
logic [NUM_FIFOS-1:0]           fifo_empty_f ;

logic [DEPTHWIDTH-1:0]          p2_fifo_size ;
logic [NUM_FIFOS-1:0]           fifo_full_nxt ;
logic [NUM_FIFOS-1:0]           fifo_full_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_push_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_push_f ;
logic [NUM_FIFOS-1:0]           p1_fifo_push_nxt ;
logic [NUM_FIFOS-1:0]           p1_fifo_push_f ;
logic [NUM_FIFOS-1:0]           p2_fifo_push_nxt ;
logic [NUM_FIFOS-1:0]           p2_fifo_push_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_pop_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_pop_f ;
logic [NUM_FIFOS-1:0]           p1_fifo_pop_nxt ;
logic [NUM_FIFOS-1:0]           p1_fifo_pop_f ;
logic [NUM_FIFOS-1:0]           p2_fifo_pop_nxt ;
logic [NUM_FIFOS-1:0]           p2_fifo_pop_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_re_wrap_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_re_wrap_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_we_wrap_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_we_wrap_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_full_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_full_f ;
logic [NUM_FIFOS-1:0]           p0_fifo_empty_nxt ;
logic [NUM_FIFOS-1:0]           p0_fifo_empty_f ;
logic [NUM_FIFOS-1:0]           fifo_re_m4_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_re_m4_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_re_m3_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_re_m3_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_re_m2_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_re_m2_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_re_m1_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_re_m1_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_we_m4_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_we_m4_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_we_m3_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_we_m3_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_we_m2_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_we_m2_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_we_m1_wrap_nxt ;
logic [NUM_FIFOS-1:0]           fifo_we_m1_wrap_f ;
logic [NUM_FIFOS-1:0]           fifo_m4_full_nxt ;
logic [NUM_FIFOS-1:0]           fifo_m4_full_f ;
logic [NUM_FIFOS-1:0]           fifo_m3_full_nxt ;
logic [NUM_FIFOS-1:0]           fifo_m3_full_f ;
logic [NUM_FIFOS-1:0]           fifo_m2_full_nxt ;
logic [NUM_FIFOS-1:0]           fifo_m2_full_f ;
logic [NUM_FIFOS-1:0]           fifo_m1_full_nxt ;
logic [NUM_FIFOS-1:0]           fifo_m1_full_f ;
logic [NUM_FIFOS-1:0]           fifo_depth_4_nxt ;
logic [NUM_FIFOS-1:0]           fifo_depth_4_f ;
logic [NUM_FIFOS-1:0]           fifo_depth_3_nxt ;
logic [NUM_FIFOS-1:0]           fifo_depth_3_f ;
logic [NUM_FIFOS-1:0]           fifo_depth_2_nxt ;
logic [NUM_FIFOS-1:0]           fifo_depth_2_f ;
logic [NUM_FIFOS-1:0]           fifo_depth_1_nxt ;
logic [NUM_FIFOS-1:0]           fifo_depth_1_f ;

ptr_pipe_t                      p0_ptr_pipe_nxt ;
ptr_pipe_t                      p0_ptr_pipe_f ;
ptr_pipe_t                      p2_ptr_pipe_f ;
ptr_t                           p2_ptr_pipe_pop_ptr_nxt_pnc ;
ptr_t                           p2_ptr_pipe_push_ptr_nxt_pnc ;
aw_rmwpipe_cmd_t                p2_ptr_pipe_rw_cmd_f_nc ;
logic                           p3_ptr_pipe_bypsel_nxt ;
ptr_t                           p3_ptr_pipe_bypdata_push_ptr_nxt ;
ptr_t                           p3_ptr_pipe_bypdata_pop_ptr_nxt ;
ptr_t                           p3_ptr_pipe_push_ptr_f ;
ptr_t                           p3_ptr_pipe_pop_ptr_f ;
logic [1:0]                     p3_ptr_pipe_push_ptr_res_f_nc ;
logic [1:0]                     p3_ptr_pipe_pop_ptr_res_f_nc ;

aw_rmwpipe_cmd_t                p1_ptr_pipe_rw_f_nc ;
logic [NFWIDTH-1:0]             p1_ptr_pipe_addr_f ;
ptr_t                           p1_ptr_pipe_min_addr_nc ;
ptr_t                           p1_ptr_pipe_max_addr_nc ;
aw_rmwpipe_cmd_t                p3_ptr_pipe_rw_f_nc ;
logic [NFWIDTH-1:0]             p3_ptr_pipe_addr_f_nc ;

bounds_pipe_t                   p0_bounds_pipe_nxt ;
bounds_pipe_t                   p0_bounds_pipe_f ;
bounds_pipe_t                   p2_bounds_pipe_f ;
aw_rmwpipe_cmd_t                p2_bounds_pipe_rw_cmd_f_nc ;
logic                           p3_bounds_pipe_bypsel_nxt ;
bounds_t                        p3_bounds_pipe_bypdata_max_addr_nxt ;
bounds_t                        p3_bounds_pipe_bypdata_min_addr_nxt ;
logic [NFWIDTH-1:0]             minmax_mem_waddr ;
logic [NFWIDTH-1:0]             minmax_mem_raddr ;

logic                           bounds_pipe_status_nc ;
logic                           p0_bounds_pipe_v_f_nc ;
logic                           p1_bounds_pipe_v_f_nc ;
aw_rmwpipe_cmd_t                p1_bounds_pipe_rw_f_nc ;
logic [NFWIDTH-1:0]             p1_bounds_pipe_addr_f_nc ;
bounds_t                        p1_bounds_pipe_min_addr_nc ;
bounds_t                        p1_bounds_pipe_max_addr_nc ;
logic                           p2_bounds_pipe_v_f_nc ;
logic                           p3_bounds_pipe_v_f_nc ;
aw_rmwpipe_cmd_t                p3_bounds_pipe_rw_f_nc ;
logic [NFWIDTH-1:0]             p3_bounds_pipe_addr_f_nc ;
bounds_t                        p3_bounds_pipe_min_addr_nc ;
bounds_t                        p3_bounds_pipe_max_addr_nc ;

logic [WMWIDTH-1:0]             p0_fifo_low_wm_nxt ;
logic [WMWIDTH-1:0]             p0_fifo_low_wm_f ;
logic [WMWIDTH-1:0]             p1_fifo_low_wm_nxt ;
logic [WMWIDTH-1:0]             p1_fifo_low_wm_f ;
logic [WMWIDTH-1:0]             p2_fifo_low_wm_nxt ;
logic [WMWIDTH-1:0]             p2_fifo_low_wm_f ;

off_pipe_t                      p0_off_pipe_nxt ;
off_pipe_t                      p0_off_pipe_f ;
off_pipe_t                      p1_off_pipe_nxt ;
off_pipe_t                      p1_off_pipe_f ;
off_pipe_t                      p2_off_pipe_nxt ;
off_pipe_t                      p2_off_pipe_f ;
logic [1:0]                     p1_off_pipe_gen_res ;
ptr_t                           p2_init_ptr ;
logic                           p2_init_ptr_wrap ;
logic [DEPTHWIDTH:0]            p2_ptr_min_plus_off ;
logic [1:0]                     p2_init_ptr_gen_upd_res ;
logic [1:0]                     p2_init_ptr_off_res ;

ptr_t                           p2_append_ptr ;
logic                           p2_append_ptr_wrap ;
logic [DEPTHWIDTH:0]            p2_ptr_push_plus_off ;
logic [DEPTHWIDTH+1:0]          p2_ptr_push_plus_off_plus_min ;
logic [DEPTHWIDTH+1:0]          p2_append_ptr_wrap_ptr_pnc ;                // No borrow possible

logic [1:0]                     p2_ptr_push_plus_off_res ;
logic [1:0]                     p2_ptr_max_p1_res ;
logic [1:0]                     p2_ptr_push_plus_off_plus_min_res ;
logic [1:0]                     p2_append_ptr_wrap_ptr_nadj_res ;       // Not yet adjusted for gen bit
logic [1:0]                     p2_append_ptr_gen_upd_res ;
logic [1:0]                     p2_append_ptr_wrap_ptr_res ;

logic                           p3_poprd_v_first ;
logic [DWIDTH-1:0]              p3_fifo_mem_rdata_save_nxt ;
logic [DWIDTH-1:0]              p3_fifo_mem_rdata_save_f ;
logic [DWIDTH-1:0]              fifo_mem_rdata_pipe ;

logic                           p0_v_nxt ;
logic                           p2_err_v ;
logic                           p3_err_v_nxt ;
logic                           p3_err_v_f ;
logic [NFWIDTH-1:0]             p3_err_rid_nxt ;
logic [NFWIDTH-1:0]             p3_err_rid_f ;
err_type_t                      p3_err_aid_nxt ;
err_type_t                      p3_err_aid_f ;


ptr_t                           p2_cfg_rdata ;
logic [AWIDTH:0]                p3_cfg_rdata_nxt ;
logic [AWIDTH:0]                p3_cfg_rdata_f ;
logic [31:0]                    p3_cfg_rdata_padded ;


ptr_t                           p2_fifo_addr ;
logic                           p2_func_residue_chk_en ;
logic                           p2_cfg_residue_chk_en ;
logic                           p2_fifo_oflow ;
logic                           p2_fifo_uflow ;
logic                           p2_fifo_addr_inc ;
logic [NFWIDTH-1:0]             p2_cfg_addr ;

logic                           p2_residue_chk_en ;
ptr_t                           p2_residue_check_ptr ;
logic [1:0]                     p2_cfg_wdata_generated_res ;
logic                           p2_ptr_residue_err_cond ;
logic                           p2_ptr_wrap ;
logic                           p2_bounds_residue_chk_en ;
logic                           p2_bounds_residue_err_cond ;
logic [AWIDTH-1:0]              p2_fifo_addr_p1 ;               // Wrap OK
logic                           p2_fifo_addr_gen_upd ;
logic [1:0]                     p2_fifo_addr_res_p1 ;
logic [1:0]                     p2_fifo_addr_gen_upd_res ;
logic [1:0]                     p2_fifo_addr_res_wrap ;
ptr_t                           p2_ptr_upd ;
logic                           p2_fifo_depth_lt_wm_adj ;
logic [DEPTHWIDTH-1:0]          p2_fifo_depth ;
logic [AWIDTH:0]                p2_fifo_depth_padded ;
logic [WMWIDTH-1:0]             p2_fifo_low_wm_adj ;
logic [WMWIDTH-1:0]             p2_fifo_low_wm_p1 ;
logic [WMWIDTH-1:0]             p2_fifo_low_wm_p2 ;

logic                           cmd_err_nc ;
logic                           p2_cmd_noop_nc ;
logic                           p2_cmd_fmem_nc ;
logic                           p2_cmd_not_fmem_nc ;
logic                           p3_cmd_not_fmem_nc ;
logic                           p2_cmd_err_nc ;
logic                           p2_cmd_low_wm_nc ;

//----------------------------------------------------------------------------------------
// FIFO memory config access
logic                           fifo_mem_re_pre ;
logic [AWIDTH-1:0]              fifo_mem_addr_pre ;
logic                           p0_cfg_fmem_rmw ;
logic                           p1_cfg_fmem_rmw_nxt ;
logic                           p1_cfg_fmem_rmw_f ;
logic [DWIDTH-1:0]              p2_cfg_fmem_rmw_data_nxt ;
logic [DWIDTH-1:0]              p2_cfg_fmem_rmw_data_f ;
logic [DWIDTH_ROUNDUP-1:0]      fifo_mem_rdata_padded ;
logic [31:0]                    fifo_mem_rdata_ar [CFG_MUX_DEGREE_POW2-1:0];
logic [31:0]                    p2_cfg_fmem_rmw_data_ar [CFG_MUX_DEGREE_POW2-1:0];
logic [DWIDTH_ROUNDUP-1:0]      p2_cfg_fmem_rmw_data_padded ;
logic [DWIDTH_ROUNDUP-1:0]      p2_cfg_fmem_wdata_pnc ;         // ms bit not connected if DWIDTH not multiple of 32
logic [31:0]                    p3_cfg_fmem_rdata_selected ;

//----------------------------------------------------------------------------------------
// p0 nxt - Combine functional and config requests (at most 1 total) into a single pipe cmd
assign cfg_req_either           = cfg_req_read | cfg_req_write ;        // Bitwise

// cfg command decoding
assign cfg_req_read_any         = | cfg_req_read ;
assign cfg_req_write_any        = | cfg_req_write ;

assign cfg_cmd_v                = cfg_req_read_any | cfg_req_write_any ;

assign p0_v_nxt                 = cmd_v | cfg_cmd_v ;

assign p0_enable                = p0_v_nxt & ~ p0_hold_aggregate ;
assign p1_enable                = p0_v_f & ~ p1_hold_aggregate ;
assign p2_enable                = p1_v_f & ~ p2_hold_aggregate ;
assign p3_enable                = p2_v_f & ~ p3_hold ;

// External hold doesn't look at internal valid; external pipe may have a valid command which
// does not involve the multi-fifo.
assign p0_hold_aggregate         = p0_hold | ( p0_v_f & p1_hold_aggregate ) ;
assign p1_hold_aggregate         = p1_hold | ( p1_v_f & p2_hold_aggregate ) ;
assign p2_hold_aggregate         = p2_hold | ( p2_v_f & p3_hold_aggregate ) ;
assign p3_hold_aggregate         = p3_hold ;                                  // p3_hold implies (external) p3_v_f

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    p3_err_v_f                  <= 1'b0 ;
    p0_v_first_f                <= 1'b0 ;
    p2_v_first_f                <= 1'b0 ;
    p3_v_first_f                <= 1'b0 ;
  end
  else begin
    p3_err_v_f                  <= p3_err_v_nxt ;
    p0_v_first_f                <= p0_enable ;  // p0_v_f=1 because of initial load, not from a hold - first clock
    p2_v_first_f                <= p2_enable ;  // p2_v_f=1 because of initial load, not from a hold - first clock
    p3_v_first_f                <= p3_enable ;  // p3_v_f=1 because of initial load, not from a hold - first clock
  end
end // always

logic [2:0] fifo_push_count ;
logic [2:0] fifo_pop_count ;

hqm_AW_count_ones #(
  .WIDTH ( 4 )
) i_hqm_AW_fifo_push_count (
  .a ( { ( p0_enable & cmd_v & ( cmd == HQM_AW_MF_PUSH ) & ~ p0_fifo_full_f [ fifo_num ] ) 
       , p0_fifo_push_f [ fifo_num ]
       , p1_fifo_push_f [ fifo_num ]
       , p2_fifo_push_f [ fifo_num ] } )
, .z ( fifo_push_count )
) ;

hqm_AW_count_ones #(
  .WIDTH ( 4 )
) i_hqm_AW_fifo_pop_count (
  .a ( { ( p0_enable & cmd_v & ( cmd == HQM_AW_MF_POP ) & ~ p0_fifo_empty_f [ fifo_num ] ) 
       , p0_fifo_pop_f [ fifo_num ]
       , p1_fifo_pop_f [ fifo_num ]
       , p2_fifo_pop_f [ fifo_num ] } )
, .z ( fifo_pop_count )
) ;

always_comb begin
  for ( int i = 0 ; i < NUM_FIFOS ; i = i + 1 ) begin
    p0_fifo_re_wrap_nxt [ i ] = ( p0_enable & cmd_v & ( cmd == HQM_AW_MF_POP ) & ( fifo_num == i ) & 
                                  ( ( fifo_re_m4_wrap_f [ i ] & ( fifo_pop_count == 3'd4 ) ) |
                                    ( fifo_re_m3_wrap_f [ i ] & ( fifo_pop_count == 3'd3 ) ) |
                                    ( fifo_re_m2_wrap_f [ i ] & ( fifo_pop_count == 3'd2 ) ) |
                                    ( fifo_re_m1_wrap_f [ i ] & ( fifo_pop_count == 3'd1 ) ) ) ) |
                                ( p0_fifo_re_wrap_f [ i ] & ~ ( p2_v_f & ( p2_cmd_pipe_f.cmd == CMD_POP ) & ( p2_ptr_pipe_f.addr == i ) & ( p2_fifo_addr.pa.ptr == p2_bounds_pipe_f.min_addr.ba.bounds ) ) ) ;
    p0_fifo_we_wrap_nxt [ i ] = ( p0_enable & cmd_v & ( cmd == HQM_AW_MF_PUSH ) & ( fifo_num == i ) & 
                                  ( ( fifo_we_m4_wrap_f [ i ] & ( fifo_push_count == 3'd4 ) ) |
                                    ( fifo_we_m3_wrap_f [ i ] & ( fifo_push_count == 3'd3 ) ) |
                                    ( fifo_we_m2_wrap_f [ i ] & ( fifo_push_count == 3'd2 ) ) |
                                    ( fifo_we_m1_wrap_f [ i ] & ( fifo_push_count == 3'd1 ) ) ) ) |
                                ( p0_fifo_we_wrap_f [ i ] & ~ ( p2_v_f & ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( p2_ptr_pipe_f.addr == i ) & ( p2_fifo_addr.pa.ptr == p2_bounds_pipe_f.min_addr.ba.bounds ) ) ) ;
    p0_fifo_full_nxt [ i ] = p0_enable & cmd_v & ( ( cmd == HQM_AW_MF_PUSH ) | ( cmd == HQM_AW_MF_POP) ) & ( fifo_num == i ) ? 
                             ( ( fifo_pop_count >  fifo_push_count ) ? 1'd0 :
                               ( fifo_pop_count == fifo_push_count ) ? fifo_full_f [ i ] & ~ ( cmd == HQM_AW_MF_POP ) : 
                               ( ( fifo_m1_full_f [ i ] & ( ( fifo_push_count - fifo_pop_count ) == 3'd1 ) ) |
                                 ( fifo_m2_full_f [ i ] & ( ( fifo_push_count - fifo_pop_count ) == 3'd2 ) ) |
                                 ( fifo_m3_full_f [ i ] & ( ( fifo_push_count - fifo_pop_count ) == 3'd3 ) ) |
                                 ( fifo_m4_full_f [ i ] & ( ( fifo_push_count - fifo_pop_count ) == 3'd4 ) ) ) ) :
                             p0_fifo_full_f [ i ] ;

    p0_fifo_empty_nxt [ i ] = p0_enable & cmd_v & ( ( cmd == HQM_AW_MF_PUSH ) | ( cmd == HQM_AW_MF_POP ) ) & ( fifo_num == i ) ? 
                              ( ( fifo_push_count >  fifo_pop_count ) ? 1'd0 :
                                ( fifo_push_count == fifo_pop_count ) ? fifo_empty_f [ i ] & ~ ( cmd == HQM_AW_MF_PUSH ) :
                                ( ( fifo_depth_1_f [ i ] & ( ( fifo_pop_count - fifo_push_count ) == 3'd1 ) ) |
                                  ( fifo_depth_2_f [ i ] & ( ( fifo_pop_count - fifo_push_count ) == 3'd2 ) ) |
                                  ( fifo_depth_3_f [ i ] & ( ( fifo_pop_count - fifo_push_count ) == 3'd3 ) ) |
                                  ( fifo_depth_4_f [ i ] & ( ( fifo_pop_count - fifo_push_count ) == 3'd4 ) ) ) ) :
                              p0_fifo_empty_f [ i ] ;
  end
end 

always_comb begin
  p1_cmd_pipe_nxt               = p1_cmd_pipe_f ;
  p2_cmd_pipe_nxt               = p2_cmd_pipe_f ;
  p2_oflow_nxt                  = p2_oflow_f ;
  p3_cmd_pipe_nxt               = p3_cmd_pipe_f ;
  p3_cfg_rdata_nxt              = p3_cfg_rdata_f ;
  p0_off_pipe_nxt               = p0_off_pipe_f ;
  p1_off_pipe_nxt               = p1_off_pipe_f ;
  p2_off_pipe_nxt               = p2_off_pipe_f ;
  p0_fifo_low_wm_nxt            = p0_fifo_low_wm_f ;
  p1_fifo_low_wm_nxt            = p1_fifo_low_wm_f ;
  p2_fifo_low_wm_nxt            = p2_fifo_low_wm_f ;
  p0_fifo_push_nxt              = p0_hold_aggregate & p0_fifo_push_f ;
  p1_fifo_push_nxt              = p1_hold_aggregate & p1_fifo_push_f ;
  p2_fifo_push_nxt              = p2_hold_aggregate & p2_fifo_push_f ;
  p0_fifo_pop_nxt               = p0_hold_aggregate & p0_fifo_pop_f ;
  p1_fifo_pop_nxt               = p1_hold_aggregate & p1_fifo_pop_f ;
  p2_fifo_pop_nxt               = p2_hold_aggregate & p2_fifo_pop_f ;

  if ( p0_enable ) begin
    p0_off_pipe_nxt             = { 2'h0 , push_offset } ;      // generate residue later
    p0_fifo_low_wm_nxt          = fifo_low_wm ;
    p0_fifo_push_nxt            = 'h0 ;
    p0_fifo_push_nxt [ fifo_num ] = cmd_v ? ( cmd == HQM_AW_MF_PUSH ) & ~ p0_fifo_full_f [ fifo_num ] : 1'b0 ; 
    p0_fifo_pop_nxt             = 'h0 ;
    p0_fifo_pop_nxt [ fifo_num ] = cmd_v ? ( cmd == HQM_AW_MF_POP ) & ~ p0_fifo_empty_f [ fifo_num ] : 1'b0 ; 
  end
  if ( p1_enable ) begin
    p1_cmd_pipe_nxt             = p0_cmd_pipe_f ;
    p1_off_pipe_nxt             = p0_off_pipe_f ;
    p1_fifo_low_wm_nxt          = p0_fifo_low_wm_f ;
    p1_fifo_push_nxt            = 'h0 ;
    p1_fifo_push_nxt [ p0_ptr_pipe_f.addr ] = p0_v_f ? p0_fifo_push_f [ p0_ptr_pipe_f.addr ] : 1'b0 ;
    p1_fifo_pop_nxt             = 'h0 ;
    p1_fifo_pop_nxt [ p0_ptr_pipe_f.addr ] = p0_v_f ? p0_fifo_pop_f [ p0_ptr_pipe_f.addr ] : 1'b0 ;

  end
  if ( p2_enable ) begin
    p2_cmd_pipe_nxt             = p1_cmd_pipe_f ;
    p2_oflow_nxt                = ( p1_cmd_pipe_f.cmd == CMD_PUSH ) &
                                  ( p2_ptr_pipe_pop_ptr_nxt_pnc.pa.ptr == p2_ptr_pipe_push_ptr_nxt_pnc.pa.ptr ) &
                                  ~ ( p2_ptr_pipe_pop_ptr_nxt_pnc.pa.ptr_gen == p2_ptr_pipe_push_ptr_nxt_pnc.pa.ptr_gen ) ;
    p2_off_pipe_nxt.off         = p1_off_pipe_f.off ;
    p2_off_pipe_nxt.off_res     = p1_off_pipe_gen_res ;
    p2_fifo_low_wm_nxt          = p1_fifo_low_wm_f ;
    p2_fifo_push_nxt = 'h0 ;
    p2_fifo_push_nxt [ p1_ptr_pipe_addr_f ] = p1_v_f ? p1_fifo_push_f [ p1_ptr_pipe_addr_f ] : 1'b0 ;
    p2_fifo_pop_nxt = 'h0 ;
    p2_fifo_pop_nxt [ p1_ptr_pipe_addr_f ] = p1_v_f ? p1_fifo_pop_f [ p1_ptr_pipe_addr_f ] : 1'b0 ;
  end
  if ( p3_enable ) begin
    p3_cmd_pipe_nxt             = p2_cmd_pipe_f ;
    p3_cfg_rdata_nxt            = { p2_cfg_rdata.pa.ptr_gen , p2_cfg_rdata.pa.ptr } ;
  end
end // always

always_ff @( posedge clk ) begin
  p0_cmd_pipe_f                 <= p0_cmd_pipe_nxt ;
  p1_cmd_pipe_f                 <= p1_cmd_pipe_nxt ;
  p2_cmd_pipe_f                 <= p2_cmd_pipe_nxt ;
  p2_oflow_f                    <= p2_oflow_nxt ;
  p3_cmd_pipe_f                 <= p3_cmd_pipe_nxt ;
  p3_cfg_rdata_f                <= p3_cfg_rdata_nxt ;
  p3_err_rid_f                  <= p3_err_rid_nxt ;
  p3_err_aid_f                  <= p3_err_aid_nxt ;
  p0_off_pipe_f                 <= p0_off_pipe_nxt ;
  p1_off_pipe_f                 <= p1_off_pipe_nxt ;
  p2_off_pipe_f                 <= p2_off_pipe_nxt ;
  p0_fifo_low_wm_f              <= p0_fifo_low_wm_nxt ;
  p1_fifo_low_wm_f              <= p1_fifo_low_wm_nxt ;
  p2_fifo_low_wm_f              <= p2_fifo_low_wm_nxt ;
end // always

assign cfg_req_addr_error       = ( cfg_req.addr.offset >= NUM_FIFOS ) ;

// commands and cfg requests are exclusive, so priority here doesn't matter
always_comb begin
  p0_cmd_pipe_nxt                       = p0_cmd_pipe_f ;
  p0_ptr_pipe_nxt                       = p0_ptr_pipe_f ;
  p0_bounds_pipe_nxt                    = p0_bounds_pipe_f ;
  cmd_err_nc                            = 1'b0 ;
  //------------------------------------
  if ( p0_enable ) begin
    p0_ptr_pipe_nxt.rw_cmd              = HQM_AW_RMWPIPE_NOOP ;
    p0_ptr_pipe_nxt.addr                = fifo_num ;
    p0_ptr_pipe_nxt.push_ptr            = { $bits(ptr_t) { 1'b0 } } ;           // Not used
    p0_ptr_pipe_nxt.pop_ptr             = { $bits(ptr_t) { 1'b0 } } ;           // Not used
    p0_bounds_pipe_nxt.rw_cmd           = HQM_AW_RMWPIPE_NOOP ;
    p0_bounds_pipe_nxt.addr             = fifo_num ;
    p0_bounds_pipe_nxt.min_addr         = { $bits(bounds_t) { 1'b0 } } ;        // Not used
    p0_bounds_pipe_nxt.max_addr         = { $bits(bounds_t) { 1'b0 } } ;        // Not used
    if ( cmd_v ) begin
      p0_cmd_pipe_nxt.cmd               = CMD_NOOP ;
      p0_cmd_pipe_nxt.cfg_rw            = CFG_RD ;                      // Unused unless cfg access
      p0_cmd_pipe_nxt.cfg_err           = 1'b0 ;
      p0_cmd_pipe_nxt.data              = { CDWIDTH { 1'b0 } } ;
      p0_cmd_pipe_nxt.data [DWIDTH-1:0] = push_data ;
      p0_cmd_pipe_nxt.addr              = { CAWIDTH { 1'b0 } } ;        // Unused unless cfg access
      case ( cmd )                      
        HQM_AW_MF_PUSH : begin
          p0_cmd_pipe_nxt.cmd           = CMD_PUSH ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        end
        HQM_AW_MF_POP : begin
          p0_cmd_pipe_nxt.cmd           = CMD_POP ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        end
        HQM_AW_MF_READ : begin
          p0_cmd_pipe_nxt.cmd           = CMD_READ ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_READ ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        end
        HQM_AW_MF_INIT_PTRS : begin
          p0_cmd_pipe_nxt.cmd           = CMD_INIT_PTRS ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        end
        HQM_AW_MF_APPEND : begin
          p0_cmd_pipe_nxt.cmd           = CMD_APPEND ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        end
        HQM_AW_MF_NOOP : begin
          p0_cmd_pipe_nxt.cmd           = CMD_NOOP ;
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_NOOP ;
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_NOOP ;
        end
        HQM_AW_MF_UNDEF0 ,
        HQM_AW_MF_UNDEF1 : begin
          cmd_err_nc                    = 1'b1 ;                        // Should never get an undefined command
        end
      endcase
    end // if cmd_v

    if ( cfg_cmd_v ) begin
      p0_cmd_pipe_nxt.cmd               = CFG_PUSH_PTR ;
      p0_cmd_pipe_nxt.cfg_rw            = ( cfg_req_write_any ) ? CFG_WR : CFG_RD ;
      p0_cmd_pipe_nxt.cfg_err           = 1'b0 ;
      p0_cmd_pipe_nxt.data              = { CDWIDTH { 1'b0 } } ;
      p0_cmd_pipe_nxt.addr              = { CAWIDTH { 1'b0 } } ;
      //----------------------------------
      p0_ptr_pipe_nxt.rw_cmd            = HQM_AW_RMWPIPE_NOOP ;
      //----------------------------------
      p0_bounds_pipe_nxt.rw_cmd         = HQM_AW_RMWPIPE_NOOP ;
      //----------------------------------
      if ( cfg_req_either [0] ) begin
        p0_cmd_pipe_nxt.cmd             = CFG_PUSH_PTR ;
        p0_cmd_pipe_nxt.data [AWIDTH:0] = cfg_req.wdata [AWIDTH:0] ;    // gen, ptr
        p0_cmd_pipe_nxt.cfg_err         = cfg_req_addr_error ;
        //--------------------------------
        if ( cfg_req_addr_error )
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_NOOP ;
        else if ( cfg_req_write_any )
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
        else
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_READ ;
        p0_ptr_pipe_nxt.addr            = cfg_req.addr.offset [NFWIDTH-1:0] ;
        p0_ptr_pipe_nxt.push_ptr        = { $bits(ptr_t) { 1'b0 } } ;   // Not used
        p0_ptr_pipe_nxt.pop_ptr         = { $bits(ptr_t) { 1'b0 } } ;   // Not used
        //--------------------------------
        // bounds pipe not used
        //--------------------------------
      end
      else if ( cfg_req_either [1] ) begin
        p0_cmd_pipe_nxt.cmd             = CFG_POP_PTR ;
        p0_cmd_pipe_nxt.data [AWIDTH:0] = cfg_req.wdata [AWIDTH:0] ;    // gen, ptr
        p0_cmd_pipe_nxt.cfg_err         = cfg_req_addr_error ;
        //--------------------------------
        if ( cfg_req_addr_error )
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_NOOP ;
        else if ( cfg_req_write_any )
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_RMW ;
        else
          p0_ptr_pipe_nxt.rw_cmd        = HQM_AW_RMWPIPE_READ ;
        p0_ptr_pipe_nxt.addr            = cfg_req.addr.offset [NFWIDTH-1:0] ;
        p0_ptr_pipe_nxt.push_ptr        = { $bits(ptr_t) { 1'b0 } } ;   // Not used
        p0_ptr_pipe_nxt.pop_ptr         = { $bits(ptr_t) { 1'b0 } } ;   // Not used
        //--------------------------------
        // bounds pipe not used
        //--------------------------------
      end
      else if ( cfg_req_either [2] ) begin
        p0_cmd_pipe_nxt.cmd               = CFG_MIN_ADDR ;
        p0_cmd_pipe_nxt.data [AWIDTH-1:0] = cfg_req.wdata [AWIDTH-1:0] ;    // ptr
        p0_cmd_pipe_nxt.cfg_err           = cfg_req_addr_error ;
        //--------------------------------
        // ptr pipe not used
        //--------------------------------
        if ( cfg_req_addr_error )
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_NOOP ;
        else if ( cfg_req_write_any )
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_RMW ;
        else
          p0_bounds_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
        p0_bounds_pipe_nxt.addr         = cfg_req.addr.offset [NFWIDTH-1:0] ;
        p0_bounds_pipe_nxt.min_addr     = { $bits(bounds_t) { 1'b0 } } ;        // Not used
        p0_bounds_pipe_nxt.max_addr     = { $bits(bounds_t) { 1'b0 } } ;        // Not used
        //--------------------------------
      end
      else if ( cfg_req_either [3] ) begin
        p0_cmd_pipe_nxt.cmd               = CFG_MAX_ADDR ;
        p0_cmd_pipe_nxt.data [AWIDTH-1:0] = cfg_req.wdata [AWIDTH-1:0] ;    // ptr
        p0_cmd_pipe_nxt.cfg_err           = cfg_req_addr_error ;
        //--------------------------------
        // ptr pipe not used
        //--------------------------------
        p0_bounds_pipe_nxt.rw_cmd       = ( cfg_req_write_any ) ? HQM_AW_RMWPIPE_RMW : HQM_AW_RMWPIPE_READ ;
        p0_bounds_pipe_nxt.addr         = cfg_req.addr.offset [NFWIDTH-1:0] ;
        p0_bounds_pipe_nxt.min_addr     = { $bits(bounds_t) { 1'b0 } } ;        // Not used
        p0_bounds_pipe_nxt.max_addr     = { $bits(bounds_t) { 1'b0 } } ;        // Not used
        //--------------------------------
      end
      else if ( cfg_req_either [4] ) begin
        p0_cmd_pipe_nxt.cmd                = CFG_FMEM ;
        p0_cmd_pipe_nxt.data [31:0]        = cfg_req.wdata [31:0] ;        // fifo RAM data (rmw done below)
        p0_cmd_pipe_nxt.cfg_err            = ( { 16'h0 , cfg_req.addr.offset } >= ( DEPTH * ( CFG_MUX_DEGREE + 1 ) ) ) ;
        p0_cmd_pipe_nxt.addr [CAWIDTH-1:0] = cfg_req.addr.offset [CAWIDTH-1:0] ;  // fifo RAM address
        // ptr pipe not used
        // bounds pipe not used
      end
    end
  end // if p0_enable
end // always

// ptr_pipe
hqm_AW_rmw_mem_4pipe_core #(
          .DEPTH                ( NUM_FIFOS )
        , .WIDTH                ( $bits ( ptr_mem_wdata ) )
) i_rmw_ptr_pipe (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .status               ( status )

        // cmd input
        , .p0_v_nxt             ( p0_v_nxt )
        , .p0_rw_nxt            ( p0_ptr_pipe_nxt.rw_cmd )
        , .p0_addr_nxt          ( p0_ptr_pipe_nxt.addr )
        , .p0_write_data_nxt    ( { p0_ptr_pipe_nxt.pop_ptr , p0_ptr_pipe_nxt.push_ptr } )

        , .p0_byp_v_nxt                 ( '0 )
        , .p0_byp_rw_nxt                ( HQM_AW_RMWPIPE_NOOP )
        , .p0_byp_addr_nxt              ( '0 )
        , .p0_byp_write_data_nxt        ( '0 )

        , .p0_hold              ( p0_hold_aggregate )
        , .p0_v_f               ( p0_v_f )
        , .p0_rw_f              ( p0_ptr_pipe_f.rw_cmd )
        , .p0_addr_f            ( p0_ptr_pipe_f.addr )
        , .p0_data_f            ( { p0_ptr_pipe_f.pop_ptr , p0_ptr_pipe_f.push_ptr } )

        , .p1_hold              ( p1_hold_aggregate )
        , .p1_v_f               ( p1_v_f )
        , .p1_rw_f              ( p1_ptr_pipe_rw_f_nc )
        , .p1_addr_f            ( p1_ptr_pipe_addr_f )
        , .p1_data_f            ( { p1_ptr_pipe_max_addr_nc , p1_ptr_pipe_min_addr_nc } )

        , .p2_hold              ( p2_hold_aggregate )
        , .p2_v_f               ( p2_v_f )
        , .p2_rw_f              ( p2_ptr_pipe_f.rw_cmd )
        , .p2_addr_f            ( p2_ptr_pipe_f.addr )
        , .p2_data_nxt          ( { p2_ptr_pipe_pop_ptr_nxt_pnc , p2_ptr_pipe_push_ptr_nxt_pnc } )
        , .p2_data_f            ( { p2_ptr_pipe_f.pop_ptr , p2_ptr_pipe_f.push_ptr } )

        , .p3_hold              ( p3_hold_aggregate )
        , .p3_bypdata_sel_nxt   ( p3_ptr_pipe_bypsel_nxt )
        , .p3_bypdata_nxt       ( { p3_ptr_pipe_bypdata_pop_ptr_nxt , p3_ptr_pipe_bypdata_push_ptr_nxt } )
        , .p3_bypaddr_sel_nxt   ( p3_ptr_pipe_bypsel_nxt )
        , .p3_bypaddr_nxt       ( p2_ptr_pipe_f.addr )
        , .p3_v_f               ( p3_v_f )
        , .p3_rw_f              ( p3_ptr_pipe_rw_f_nc )
        , .p3_addr_f            ( p3_ptr_pipe_addr_f_nc )
        , .p3_data_f            ( { p3_ptr_pipe_pop_ptr_f , p3_ptr_pipe_push_ptr_f } )

        // mem intf
        , .mem_write            ( ptr_mem_we )
        , .mem_read             ( ptr_mem_re )
        , .mem_write_addr       ( ptr_mem_waddr )
        , .mem_read_addr        ( ptr_mem_raddr )
        , .mem_write_data       ( ptr_mem_wdata )
        , .mem_read_data        ( ptr_mem_rdata )
) ;

assign p2_ptr_pipe_rw_cmd_f_nc          = p2_ptr_pipe_f.rw_cmd ;
assign p3_ptr_pipe_push_ptr_res_f_nc    = p3_ptr_pipe_push_ptr_f.pa.ptr_res ;
assign p3_ptr_pipe_pop_ptr_res_f_nc     = p3_ptr_pipe_pop_ptr_f.pa.ptr_res ;

// bounds_pipe
hqm_AW_rmw_mem_4pipe #(
          .DEPTH                ( NUM_FIFOS )
        , .WIDTH                ( $bits ( minmax_mem_wdata ) )
) i_rmw_bounds_pipe (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .status               ( bounds_pipe_status_nc )               // Same as ptr_pipe

        // cmd input
        , .p0_v_nxt             ( p0_v_nxt )
        , .p0_rw_nxt            ( p0_bounds_pipe_nxt.rw_cmd )
        , .p0_addr_nxt          ( p0_bounds_pipe_nxt.addr )
        , .p0_write_data_nxt    ( { p0_bounds_pipe_nxt.max_addr , p0_bounds_pipe_nxt.min_addr } )
        , .p0_hold              ( p0_hold_aggregate )
        , .p0_v_f               ( p0_bounds_pipe_v_f_nc )               // Same as ptr_pipe
        , .p0_rw_f              ( p0_bounds_pipe_f.rw_cmd )
        , .p0_addr_f            ( p0_bounds_pipe_f.addr )
        , .p0_data_f            ( { p0_bounds_pipe_f.max_addr , p0_bounds_pipe_f.min_addr } )

        , .p1_hold              ( p1_hold_aggregate )
        , .p1_v_f               ( p1_bounds_pipe_v_f_nc )               // Same as ptr_pipe
        , .p1_rw_f              ( p1_bounds_pipe_rw_f_nc )
        , .p1_addr_f            ( p1_bounds_pipe_addr_f_nc )
        , .p1_data_f            ( { p1_bounds_pipe_max_addr_nc , p1_bounds_pipe_min_addr_nc } )

        , .p2_hold              ( p2_hold_aggregate )
        , .p2_v_f               ( p2_bounds_pipe_v_f_nc )               // Same as ptr_pipe
        , .p2_rw_f              ( p2_bounds_pipe_f.rw_cmd )
        , .p2_addr_f            ( p2_bounds_pipe_f.addr )
        , .p2_data_f            ( { p2_bounds_pipe_f.max_addr , p2_bounds_pipe_f.min_addr } )

        , .p3_hold              ( p3_hold_aggregate )
        , .p3_bypsel_nxt        ( p3_bounds_pipe_bypsel_nxt  )
        , .p3_bypdata_nxt       ( { p3_bounds_pipe_bypdata_max_addr_nxt , p3_bounds_pipe_bypdata_min_addr_nxt } )
        , .p3_v_f               ( p3_bounds_pipe_v_f_nc )               // Same as ptr_pipe
        , .p3_rw_f              ( p3_bounds_pipe_rw_f_nc )
        , .p3_addr_f            ( p3_bounds_pipe_addr_f_nc )
        , .p3_data_f            ( { p3_bounds_pipe_max_addr_nc , p3_bounds_pipe_min_addr_nc } )

        // mem intf
        , .mem_write            ( minmax_mem_we )
        , .mem_read             ( minmax_mem_re )
        , .mem_write_addr       ( minmax_mem_waddr )
        , .mem_read_addr        ( minmax_mem_raddr )
        , .mem_write_data       ( minmax_mem_wdata )
        , .mem_read_data        ( minmax_mem_rdata )
) ;

assign p2_bounds_pipe_rw_cmd_f_nc       = p2_bounds_pipe_f.rw_cmd ;

// Writes only occur with config, pipe is otherwise idle, no read vs. write collisions.
// Need rmw pipe because for config write need to do rmw because of shared RAM.
assign minmax_mem_addr  = ( minmax_mem_we ) ? minmax_mem_waddr : minmax_mem_raddr ;

hqm_AW_residue_gen #( .WIDTH ( DEPTHWIDTH ) ) i_resgen_off (
          .a                            ( p1_off_pipe_f.off )
        , .r                            ( p1_off_pipe_gen_res )
) ;

//----------------------------------------------------------------------------------------
// p2

always_comb begin
  p2_fifo_addr                                  = p2_ptr_pipe_f.push_ptr ;
  p2_func_residue_chk_en                        = 1'b0 ;
  p2_cfg_residue_chk_en                         = 1'b0 ;
  p2_fifo_oflow                                 = 1'b0 ;
  p2_fifo_uflow                                 = 1'b0 ;
  p2_fifo_addr_inc                              = 1'b0 ;
  p2_cfg_addr                                   = p2_ptr_pipe_f.addr ;
  p2_cfg_rdata                                  = p2_ptr_pipe_f.push_ptr ;
  p3_ptr_pipe_bypsel_nxt                        = 1'b0 ;
  p3_ptr_pipe_bypdata_push_ptr_nxt              = p2_ptr_pipe_f.push_ptr ;
  p3_ptr_pipe_bypdata_pop_ptr_nxt               = p2_ptr_pipe_f.pop_ptr ;
  p3_bounds_pipe_bypsel_nxt                     = 1'b0 ;
  p3_bounds_pipe_bypdata_max_addr_nxt           = p2_bounds_pipe_f.max_addr ;
  p3_bounds_pipe_bypdata_min_addr_nxt           = p2_bounds_pipe_f.min_addr ;
  p2_cmd_noop_nc                                = 1'b0 ;
  p2_cmd_fmem_nc                                = 1'b0 ;
  p2_cmd_err_nc                                 = 1'b0 ;
  if ( p2_v_f ) begin
    case ( p2_cmd_pipe_f.cmd )          
      CMD_NOOP : begin
        p2_cmd_noop_nc                          = 1'b1 ;                // Nothing to do if NOOP
      end
      CMD_PUSH : begin  // Write FIFO RAM, check and update push pointer
        p2_fifo_addr                            = p2_ptr_pipe_f.push_ptr ;
        p2_func_residue_chk_en                  = 1'b1 ;
        p2_fifo_oflow                           = ( p2_ptr_pipe_f.push_ptr.pa.ptr == p2_ptr_pipe_f.pop_ptr.pa.ptr ) &
                                                  ~ ( p2_ptr_pipe_f.push_ptr.pa.ptr_gen == p2_ptr_pipe_f.pop_ptr.pa.ptr_gen ) ;
        if ( ~ p2_fifo_oflow ) begin
          p2_fifo_addr_inc                      = 1'b1 ;
          p3_ptr_pipe_bypdata_push_ptr_nxt      = p2_ptr_upd ;
        end
        p3_ptr_pipe_bypsel_nxt                  = ~ p2_hold_aggregate ;
      end
      CMD_POP : begin  // Read FIFO RAM, check and update pop pointer
        p2_fifo_addr                            = p2_ptr_pipe_f.pop_ptr ;
        p2_func_residue_chk_en                  = 1'b1 ;
        p2_fifo_uflow                           = ( p2_ptr_pipe_f.push_ptr.pa.ptr == p2_ptr_pipe_f.pop_ptr.pa.ptr ) &
                                                  ( p2_ptr_pipe_f.push_ptr.pa.ptr_gen == p2_ptr_pipe_f.pop_ptr.pa.ptr_gen ) ;
        if ( ~ p2_fifo_uflow ) begin
          p2_fifo_addr_inc                      = 1'b1 ;
          p3_ptr_pipe_bypdata_pop_ptr_nxt       = p2_ptr_upd ;
        end
        p3_ptr_pipe_bypsel_nxt                  = ~ p2_hold_aggregate ;
      end
      CMD_READ : begin  // Read FIFO RAM, check but don't update pop pointer
        p2_fifo_addr                            = p2_ptr_pipe_f.pop_ptr ;
        p2_func_residue_chk_en                  = 1'b1 ;
        p2_fifo_uflow                           = ( p2_ptr_pipe_f.push_ptr.pa.ptr == p2_ptr_pipe_f.pop_ptr.pa.ptr ) &
                                                  ( p2_ptr_pipe_f.push_ptr.pa.ptr_gen == p2_ptr_pipe_f.pop_ptr.pa.ptr_gen ) ;
      end
      CMD_INIT_PTRS : begin  // Read minmax mem, set {gen,pop} to 0,min and {gen,push} to min plus offset mod (1+max-min)
        p3_ptr_pipe_bypsel_nxt                          = ~ p2_hold_aggregate ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_res     = p2_init_ptr.pa.ptr_res ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_gen     = p2_init_ptr.pa.ptr_gen ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr         = p2_init_ptr.pa.ptr ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_res      = p2_bounds_pipe_f.min_addr.ba.bounds_res ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_gen      = 1'b0 ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr          = p2_bounds_pipe_f.min_addr.ba.bounds ;
      end
      CMD_APPEND : begin  // Read minmax mem, set {gen,push} to push plus offset mod (1+max-min)
        p3_ptr_pipe_bypsel_nxt                          = ~ p2_hold_aggregate ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_res     = p2_append_ptr.pa.ptr_res ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_gen     = p2_append_ptr.pa.ptr_gen ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr         = p2_append_ptr.pa.ptr ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt                 = p2_ptr_pipe_f.pop_ptr ;               // Hold
      end
      CFG_PUSH_PTR : begin  // Cfg read pointers, update push ptr if write, check if read
        p2_cfg_residue_chk_en                   = ( p2_cmd_pipe_f.cfg_rw == CFG_RD ) ;
        p2_cfg_rdata                            = p2_ptr_pipe_f.push_ptr ;
        p3_ptr_pipe_bypsel_nxt                  = ~ p2_hold_aggregate ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_res     = p2_cfg_wdata_generated_res ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_gen     = p2_cmd_pipe_f.data [AWIDTH] ;
        p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr         = p2_cmd_pipe_f.data [AWIDTH-1:0] ;
      end
      CFG_POP_PTR : begin  // Cfg read pointers, update pop ptr if write, check if read
        p2_cfg_residue_chk_en                   = ( p2_cmd_pipe_f.cfg_rw == CFG_RD ) ;
        p2_cfg_rdata                            = p2_ptr_pipe_f.pop_ptr ;
        p3_ptr_pipe_bypsel_nxt                  = ~ p2_hold_aggregate ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_res      = p2_cfg_wdata_generated_res ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_gen      = p2_cmd_pipe_f.data [AWIDTH] ;
        p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr          = p2_cmd_pipe_f.data [AWIDTH-1:0] ;
      end
      CFG_MIN_ADDR : begin  // Cfg read bounds, update min addr if write, check if read
        p2_cfg_residue_chk_en                   = ( p2_cmd_pipe_f.cfg_rw == CFG_RD ) ;
        p2_cfg_rdata.pa.ptr_res                 = p2_bounds_pipe_f.min_addr.ba.bounds_res ;
        p2_cfg_rdata.pa.ptr_gen                 = 1'b0 ;        // Don't mess up residue check
        p2_cfg_rdata.pa.ptr                     = p2_bounds_pipe_f.min_addr.ba.bounds ;
        p2_cfg_addr                             = p2_bounds_pipe_f.addr ;
        p3_bounds_pipe_bypsel_nxt               = ~ p2_hold_aggregate ;
        p3_bounds_pipe_bypdata_min_addr_nxt.ba.bounds_res       = p2_cfg_wdata_generated_res ;
        p3_bounds_pipe_bypdata_min_addr_nxt.ba.bounds           = p2_cmd_pipe_f.data [AWIDTH-1:0] ;
      end
      CFG_MAX_ADDR : begin  // Cfg read bounds, update max addr if write, check if read
        p2_cfg_residue_chk_en                   = ( p2_cmd_pipe_f.cfg_rw == CFG_RD ) ;
        p2_cfg_rdata.pa.ptr_res                 = p2_bounds_pipe_f.max_addr.ba.bounds_res ;
        p2_cfg_rdata.pa.ptr_gen                 = 1'b0 ;        // Don't mess up residue check
        p2_cfg_rdata.pa.ptr                     = p2_bounds_pipe_f.max_addr.ba.bounds ;
        p2_cfg_addr                             = p2_bounds_pipe_f.addr ;
        p3_bounds_pipe_bypsel_nxt               = ~ p2_hold_aggregate ;
        p3_bounds_pipe_bypdata_max_addr_nxt.ba.bounds_res       = p2_cfg_wdata_generated_res ;
        p3_bounds_pipe_bypdata_max_addr_nxt.ba.bounds           = p2_cmd_pipe_f.data [AWIDTH-1:0] ;
      end
      CFG_FMEM : begin
        p2_cmd_fmem_nc                          = 1'b1 ;        // This always block does not assign fifo mem wires; nothing to do otherwise
      end
      CMD_UNDEF0 ,
      CMD_UNDEF1 ,
      CMD_UNDEF2 ,
      CMD_UNDEF3 ,
      CMD_UNDEF4 : begin
        p2_cmd_err_nc                           = 1'b1 ;        // Should never get undefined command
      end
    endcase
  end // if p2_v_f
end // always

always_comb begin
  fifo_mem_re_pre                               = 1'b0 ;
  fifo_mem_we                                   = 1'b0 ;
  fifo_mem_addr_pre                             = p2_fifo_addr.pa.ptr ;
  fifo_mem_wdata                                = p2_cmd_pipe_f.data [DWIDTH-1:0] ;
  p2_cmd_not_fmem_nc                            = 1'b0 ;
  if ( p2_v_f ) begin   // Like AW rmw, no attempt to save power by blocking read if p2 holding - don't want port -> memory paths
    case ( p2_cmd_pipe_f.cmd )
      CMD_PUSH : begin  // Write FIFO RAM, check and update push pointer
        fifo_mem_we                             = p2_v_first_f & ~ p2_oflow_f ;         // Only write on first clock if holding
      end
      CMD_POP : begin   // Read FIFO RAM, check and update pop pointer
        fifo_mem_re_pre                         = p2_v_f ;
      end
      CMD_READ : begin  // Read FIFO RAM, check but don't update pop pointer
        fifo_mem_re_pre                         = p2_v_f ;
      end
      CFG_FMEM : begin  // Cfg read/write FIFO memory, no checks
        fifo_mem_re_pre                         = ( p2_cmd_pipe_f.cfg_rw == CFG_RD ) & ~ p2_cmd_pipe_f.cfg_err & p2_v_f ;
        fifo_mem_we                             = ( p2_cmd_pipe_f.cfg_rw == CFG_WR ) & ~ p2_cmd_pipe_f.cfg_err & p2_v_first_f ;
        fifo_mem_addr_pre                       = p2_cmd_pipe_f.addr [ CFG_MUX_DEGREE +: AWIDTH ] ;
        fifo_mem_wdata                          = p2_cfg_fmem_wdata_pnc [DWIDTH-1:0] ;
      end
      default : begin
        p2_cmd_not_fmem_nc                      = 1'b1 ;        // This always block only assigns wires for fifo mem; nothing to do otherwise
      end
    endcase
  end // if p2_v_f
end // always

// Generate residue on the config write data.  Don't try to share the generate part of
// the checker - extra mux delay and logic not worth it, and could introduce what may
// appear to tools as a timing loop.
hqm_AW_residue_gen #( .WIDTH ( AWIDTH+1 ) ) i_resgen (      // Data includes gen bit, zeroed if bounds
          .a                            ( p2_cmd_pipe_f.data [AWIDTH:0] )
        , .r                            ( p2_cfg_wdata_generated_res )
) ;

assign p2_residue_chk_en                = p2_func_residue_chk_en | p2_cfg_residue_chk_en ;

// Mux the cfg data into the residue checker if doing a cfg read
always_comb begin
  if ( p2_cfg_residue_chk_en )
    p2_residue_check_ptr                = p2_cfg_rdata ;
  else
    p2_residue_check_ptr                = p2_fifo_addr ;
end // always

hqm_AW_residue_check #( .WIDTH ( AWIDTH+1 ) ) i_rescheck (      // Check includes gen, zeroed if bounds
          .r                            ( p2_residue_check_ptr.pa.ptr_res )
        , .d                            ( { p2_residue_check_ptr.pa.ptr_gen , p2_residue_check_ptr.pa.ptr } )
        , .e                            ( p2_residue_chk_en )
        , .err                          ( p2_ptr_residue_err_cond )
) ;

assign p2_bounds_residue_chk_en = p2_fifo_addr_inc ;            // If incrementing, must be comparing with bounds, so check bounds

hqm_AW_residue_check #( .WIDTH ( AWIDTH ) ) i_bounds_rescheck (
          .r                            ( p2_bounds_pipe_f.max_addr.ba.bounds_res )
        , .d                            ( p2_bounds_pipe_f.max_addr.ba.bounds )
        , .e                            ( p2_bounds_residue_chk_en )
        , .err                          ( p2_bounds_residue_err_cond )
) ;

assign p2_ptr_wrap              = p2_fifo_addr_inc & ( p2_fifo_addr.pa.ptr == p2_bounds_pipe_f.max_addr.ba.bounds ) ;
assign p2_ptr_first             = p2_fifo_addr_inc & ( p2_fifo_addr.pa.ptr == 'd0 ) ;

// Wrap OK - must = max if wrap so unused
assign p2_fifo_addr_p1          = p2_fifo_addr.pa.ptr + { { (AWIDTH-1) { 1'b0 } } , 1'b1 } ;

assign p2_fifo_addr_gen_upd     = ~ p2_fifo_addr.pa.ptr_gen ;   // Toggle if wrap

hqm_AW_residue_add i_res_inc (
          .a                            ( p2_fifo_addr.pa.ptr_res )
        , .b                            ( 2'h1 )
        , .r                            ( p2_fifo_addr_res_p1 )
) ;

// Need to calculate the residue of the value being loaded into the pointer when wrapping.
// Equals the value of the min addr residue plus the adjusted value of the updated gen bit; if gen=1
// this is either 1 or 2 depending on if it is at an even or odd bit position.
assign p2_fifo_addr_gen_upd_res = ( ( AWIDTH % 2 ) == 1 )
                                    ? { p2_fifo_addr_gen_upd , 1'b0 }   // *2 because an odd bit
                                    : { 1'b0 , p2_fifo_addr_gen_upd } ;
hqm_AW_residue_add i_res_wrap (
          .a                            ( p2_bounds_pipe_f.min_addr.ba.bounds_res )
        , .b                            ( p2_fifo_addr_gen_upd_res )        // Add 1 or 2 if upd_gen=1
        , .r                            ( p2_fifo_addr_res_wrap )
) ;

always_comb begin
  if ( p2_ptr_wrap ) begin      // Load the min address, updated (toggled) gen, and adjusted min address residue
    p2_ptr_upd.pa.ptr           = p2_bounds_pipe_f.min_addr.ba.bounds ;
    p2_ptr_upd.pa.ptr_gen       = p2_fifo_addr_gen_upd ;
    p2_ptr_upd.pa.ptr_res       = p2_fifo_addr_res_wrap ;
  end
  else begin                    // Load the incremented pointer, same gen, and incremented residue
    p2_ptr_upd.pa.ptr           = p2_fifo_addr_p1 ;
    p2_ptr_upd.pa.ptr_gen       = p2_fifo_addr.pa.ptr_gen ;
    p2_ptr_upd.pa.ptr_res       = p2_fifo_addr_res_p1 ;
  end
end // always

//----------------------------------------------------------------------------------------
// ptr init

// If wrap, either legal case (offset = configured depth), or illegal case (min+offset would exceed max).
// Assume legal case if wrap, set push pointer to min with gen=1 and residue adjusted assuming that.  Min
// residue plus residue of gen bit; residue of gen depends on bit position which depends on AWIDTH.
// Illegal case should not occur (hw error) - if it does, will result in a residue error 2/3 of the time;
// Note this is not conditioned on p2 cmd == INIT; but result is only looked at if INIT.
// To keep lint happy, anywhere where something scaled by DEPTHWIDTH combines with something scaled by AWIDTH, need to pad the AWIDTH bus.
generate
  if ( DEPTHWIDTH > AWIDTH ) begin : gen_init_pow2      // Only true if DEPTH is power of 2; if so, DEPTHWIDTH = AWIDTH + 1
    logic [AWIDTH:0]            min_bounds_padded ;
    logic [AWIDTH:0]            max_bounds_padded ;

    assign min_bounds_padded    = { 1'b0 , p2_bounds_pipe_f.min_addr.ba.bounds } ;
    assign max_bounds_padded    = { 1'b0 , p2_bounds_pipe_f.max_addr.ba.bounds } ;
    assign p2_ptr_min_plus_off  = { 1'b0 , min_bounds_padded } + { 1'b0 , p2_off_pipe_f.off } ;
    assign p2_init_ptr_wrap     = ( p2_ptr_min_plus_off > { 1'b0 , max_bounds_padded } ) ;
  end
  else begin : gen_init_not_pow2                        // Only true if not power of 2; if so, DEPTHWIDTH = AWIDTH
    logic [AWIDTH-1:0]          min_bounds_padded ;
    logic [AWIDTH-1:0]          max_bounds_padded ;

    assign min_bounds_padded    = p2_bounds_pipe_f.min_addr.ba.bounds ;
    assign max_bounds_padded    = p2_bounds_pipe_f.max_addr.ba.bounds ;
    assign p2_ptr_min_plus_off  = { 1'b0 , min_bounds_padded } + { 1'b0 , p2_off_pipe_f.off } ;
    assign p2_init_ptr_wrap     = ( p2_ptr_min_plus_off > { 1'b0 , max_bounds_padded } ) ;
  end

endgenerate

assign p2_init_ptr_gen_upd_res  = ( ( AWIDTH % 2 ) == 1 ) ? 2'h2 : 2'h1 ;

always_comb begin
  if ( p2_init_ptr_wrap ) begin                                                 // Assume legal case:
    p2_init_ptr.pa.ptr          = p2_bounds_pipe_f.min_addr.ba.bounds ;         // - wrap to min (offset "wraps" to 0)
    p2_init_ptr.pa.ptr_gen      = 1'b1 ;                                        // - depth = "full"
    p2_init_ptr_off_res         = p2_init_ptr_gen_upd_res ;                     // - just add in gen bit res
  end
  else begin
    p2_init_ptr.pa.ptr          = p2_ptr_min_plus_off [AWIDTH-1:0] ;            // Add the offset
    p2_init_ptr.pa.ptr_gen      = 1'b0 ;
    p2_init_ptr_off_res         = p2_off_pipe_f.off_res ;                       // Add the offset residue
  end
end // always

hqm_AW_residue_add i_init_ptr_res (
          .a                            ( p2_bounds_pipe_f.min_addr.ba.bounds_res )
        , .b                            ( p2_init_ptr_off_res )
        , .r                            ( p2_init_ptr.pa.ptr_res )
) ;

//----------------------------------------------------------------------------------------
// Append
// No hw check for (illegal) case where push pointer is advanced beyond the pop pointer.
// In wrap case, want to set push pointer to (((push+off)-max)-1)+min.  Reorder these terms
// to (push+off+min)-(max+1) to save a level of add/sub.

hqm_AW_residue_add i_append_ptr_push_plus_off_res (
          .a                            ( p2_ptr_pipe_f.push_ptr.pa.ptr_res )
        , .b                            ( p2_off_pipe_f.off_res )
        , .r                            ( p2_ptr_push_plus_off_res )
) ;

hqm_AW_residue_add i_append_ptr_max_p1_res (
          .a                            ( p2_bounds_pipe_f.max_addr.ba.bounds_res )
        , .b                            ( 2'h1 )
        , .r                            ( p2_ptr_max_p1_res )
) ;

hqm_AW_residue_add i_append_ptr_push_plus_off_plus_min_res (
          .a                            ( p2_ptr_push_plus_off_res )
        , .b                            ( p2_bounds_pipe_f.min_addr.ba.bounds_res )
        , .r                            ( p2_ptr_push_plus_off_plus_min_res )
) ;

hqm_AW_residue_sub i_append_ptr_wrap_nadj_res (
          .a                            ( p2_ptr_max_p1_res )
        , .b                            ( p2_ptr_push_plus_off_plus_min_res )
        , .r                            ( p2_append_ptr_wrap_ptr_nadj_res )     // Not yet adjusted for gen bit
) ;

hqm_AW_residue_add i_append_ptr_wrap_res (
          .a                            ( p2_append_ptr_wrap_ptr_nadj_res )
        , .b                            ( p2_append_ptr_gen_upd_res )           // Adjust for gen bit
        , .r                            ( p2_append_ptr_wrap_ptr_res )
) ;


// To keep lint happy, anywhere where something scaled by DEPTHWIDTH combines with something scaled by AWIDTH, need to pad the AWIDTH bus.
generate
  if ( DEPTHWIDTH > AWIDTH ) begin : gen_append_pow2    // Only true if DEPTH is power of 2; if so, DEPTHWIDTH = AWIDTH + 1
    logic [AWIDTH:0]            push_ptr_padded ;
    logic [AWIDTH:0]            append_min_bounds_padded ;
    logic [AWIDTH:0]            append_max_bounds_padded ;
    logic [AWIDTH+1:0]          append_max_bounds_p1_padded ;

    assign push_ptr_padded              = { 1'b0 , p2_ptr_pipe_f.push_ptr.pa.ptr } ;
    assign append_min_bounds_padded     = { 1'b0 , p2_bounds_pipe_f.min_addr.ba.bounds } ;
    assign append_max_bounds_padded     = { 1'b0 , p2_bounds_pipe_f.max_addr.ba.bounds } ;
    assign append_max_bounds_p1_padded  = { 1'b0 , append_max_bounds_padded } + { { (AWIDTH+1) { 1'b0 } } , 1'b1 } ;

    assign p2_ptr_push_plus_off                 = { 1'b0 , push_ptr_padded } + { 1'b0 , p2_off_pipe_f.off } ;
    assign p2_ptr_push_plus_off_plus_min        = { 1'b0 , p2_ptr_push_plus_off } + { 1'b0 , append_min_bounds_padded } ;
    assign p2_append_ptr_wrap_ptr_pnc           = p2_ptr_push_plus_off_plus_min - { 1'b0 , append_max_bounds_p1_padded } ;         // Borrow not possible
    assign p2_append_ptr_wrap                   = ( p2_ptr_push_plus_off > { 1'b0 , append_max_bounds_padded } ) ;
  end
  else begin : gen_append_not_pow2                      // Only true if not power of 2; if so, DEPTHWIDTH = AWIDTH
    logic [AWIDTH-1:0]          push_ptr_padded ;
    logic [AWIDTH-1:0]          append_min_bounds_padded ;
    logic [AWIDTH-1:0]          append_max_bounds_padded ;
    logic [AWIDTH:0]            append_max_bounds_p1_padded ;

    assign push_ptr_padded              = p2_ptr_pipe_f.push_ptr.pa.ptr ;
    assign append_min_bounds_padded     = p2_bounds_pipe_f.min_addr.ba.bounds ;
    assign append_max_bounds_padded     = p2_bounds_pipe_f.max_addr.ba.bounds ;
    assign append_max_bounds_p1_padded  = { 1'b0 , append_max_bounds_padded } + { { AWIDTH { 1'b0 } } , 1'b1 } ;

    assign p2_ptr_push_plus_off                 = { 1'b0 , push_ptr_padded } + { 1'b0 , p2_off_pipe_f.off } ;
    assign p2_ptr_push_plus_off_plus_min        = { 1'b0 , p2_ptr_push_plus_off } + { 1'b0 , append_min_bounds_padded } ;
    assign p2_append_ptr_wrap_ptr_pnc           = p2_ptr_push_plus_off_plus_min - { 1'b0 , append_max_bounds_p1_padded } ;         // Borrow not possible
    assign p2_append_ptr_wrap                   = ( p2_ptr_push_plus_off > { 1'b0 , append_max_bounds_padded } ) ;
  end
endgenerate

// If even number of bits: if gen is toggling from 0 to 1 = +1, else toggling from 1 to 0 = -1 = +2
// If odd  number of bits: if gen is toggling from 0 to 1 = +2, else toggling from 1 to 0 = -2 = +1
assign p2_append_ptr_gen_upd_res        = ( ( ( AWIDTH % 2 ) == 1 ) ^ p2_ptr_pipe_f.push_ptr.pa.ptr_gen ) ? 2'h2 : 2'h1 ;

always_comb begin
  if ( p2_append_ptr_wrap ) begin
    p2_append_ptr.pa.ptr        = p2_append_ptr_wrap_ptr_pnc [AWIDTH-1:0] ;     // Wrap to min plus n; math is arranged so that OK to truncate
    p2_append_ptr.pa.ptr_gen    = ~ p2_ptr_pipe_f.push_ptr.pa.ptr_gen ;         // Wrap, so toggle gen
    p2_append_ptr.pa.ptr_res    = p2_append_ptr_wrap_ptr_res ;                  // Wrap to r(min) plus r(n), adjust for gen toggle
  end
  else begin
    p2_append_ptr.pa.ptr        = p2_ptr_push_plus_off [AWIDTH-1:0] ;           // Add the offset
    p2_append_ptr.pa.ptr_gen    = p2_ptr_pipe_f.push_ptr.pa.ptr_gen ;           // No wrap so do not toggle
    p2_append_ptr.pa.ptr_res    = p2_ptr_push_plus_off_res ;                    // Add the offset residue, no adjustment for gen
  end
end // always

//----------------------------------------------------------------------------------------
// Arbitrate error conditions - residue errors take priority over oflow/uflow since
// a residue error can cause an oflow/uflow.
assign p2_err_v                 = p2_v_f & (
                                      ( p2_cfg_residue_chk_en & p2_ptr_residue_err_cond )
                                    | ( p2_ptr_residue_err_cond | p2_bounds_residue_err_cond )
                                    | p2_fifo_oflow | p2_fifo_uflow
                                  ) ;

assign p3_err_v_nxt             = ( p2_err_v & ~ p2_hold_aggregate ) | ( p3_err_v_f & p3_hold_aggregate ) ;

always_comb begin
  p3_err_rid_nxt                = p3_err_rid_f ;
  p3_err_aid_nxt                = p3_err_aid_f ;
  if ( p3_enable ) begin
    if ( p2_cfg_residue_chk_en & p2_ptr_residue_err_cond ) begin
      p3_err_rid_nxt            = p2_cfg_addr ;
      p3_err_aid_nxt            = RERR_CFG ;
    end
    else if ( p2_ptr_residue_err_cond | p2_bounds_residue_err_cond ) begin
      p3_err_rid_nxt            = p2_ptr_pipe_f.addr ;  // addr is same for ptr and bounds
      p3_err_aid_nxt            = RERR ;
    end
    else if ( p2_fifo_oflow ) begin
      p3_err_rid_nxt            = p2_ptr_pipe_f.addr ;
      p3_err_aid_nxt            = OFLOW ;
    end
    else if ( p2_fifo_uflow ) begin
      p3_err_rid_nxt            = p2_ptr_pipe_f.addr ;
      p3_err_aid_nxt            = UFLOW ;
    end
  end // if p3_enable
end // always

//----------------------------------------------------------------------------------------
// p3

assign p3_poprd_v_first           = p3_v_first_f & ( ( p3_cmd_pipe_f.cmd == CMD_POP ) | ( p3_cmd_pipe_f.cmd == CMD_READ ) ) ;

// Only load save register if pop is active this clock (1 clock only, even if holding) and
// it is possible that p3 will be holding after this clock.
always_comb begin
  p3_fifo_mem_rdata_save_nxt    = p3_fifo_mem_rdata_save_f ;
  if ( p3_poprd_v_first & p3_hold_aggregate ) begin
    p3_fifo_mem_rdata_save_nxt  = fifo_mem_rdata ;
  end
end // always

always_ff @( posedge clk ) begin
  p3_fifo_mem_rdata_save_f      <= p3_fifo_mem_rdata_save_nxt ;
end // always

// If error, don't allow VF to potentially see another VF's data (e.g. bounds corrupted).
// Assume there is external odd parity checking, try to avoid inducing an extraneous parity error.
always_comb begin
  if ( pop_data_v & ~ p3_poprd_v_first )
    fifo_mem_rdata_pipe         = p3_fifo_mem_rdata_save_f ;    // Get from save if no pop active this clock
  else
    fifo_mem_rdata_pipe         = fifo_mem_rdata ;

  if ( p3_err_v_f ) begin
    pop_data                    = { 1'b1 , { ( DWIDTH-1 ) { 1'b0 } } } ;
  end
  else begin
    pop_data                    = fifo_mem_rdata_pipe ;         // From save register if p3 is holding
  end

  p3_cfg_rdata_padded                   = 32'h0 ;
  if ( ~ p3_cmd_pipe_f.cfg_err )
    p3_cfg_rdata_padded [AWIDTH:0]      = p3_cfg_rdata_f ;
end // always

assign pop_data_v               = p3_v_f & ( ( p3_cmd_pipe_f.cmd == CMD_POP ) | ( p3_cmd_pipe_f.cmd == CMD_READ ) ) ;
assign pop_data_last            = p3_v_f & ( p3_cmd_pipe_f.cmd == CMD_POP ) &
                                  ( p3_ptr_pipe_push_ptr_f.pa.ptr == p3_ptr_pipe_pop_ptr_f.pa.ptr ) &
                                  ( p3_ptr_pipe_push_ptr_f.pa.ptr_gen == p3_ptr_pipe_pop_ptr_f.pa.ptr_gen ) ;

always_comb begin
  cfg_ack                       = 5'h0 ;
  cfg_err                       = 5'h0 ;
  cfg_rdata                     = { 5 { p3_cfg_rdata_padded } } ;
  p3_cmd_not_fmem_nc            = 1'b0 ;
  case ( p3_cmd_pipe_f.cmd )
    CFG_PUSH_PTR  : begin cfg_ack [0]   = p3_v_f & ~ p3_hold_aggregate ; cfg_err [0] = p3_cmd_pipe_f.cfg_err ; end
    CFG_POP_PTR   : begin cfg_ack [1]   = p3_v_f & ~ p3_hold_aggregate ; cfg_err [1] = p3_cmd_pipe_f.cfg_err ; end
    CFG_MIN_ADDR  : begin cfg_ack [2]   = p3_v_f & ~ p3_hold_aggregate ; cfg_err [2] = p3_cmd_pipe_f.cfg_err ; end
    CFG_MAX_ADDR  : begin cfg_ack [3]   = p3_v_f & ~ p3_hold_aggregate ; cfg_err [3] = p3_cmd_pipe_f.cfg_err ; end
    CFG_FMEM      : begin
      cfg_ack [4]                       = p3_v_f & ~ p3_hold_aggregate ;
      cfg_err [4]                       = p3_cmd_pipe_f.cfg_err ;
      if ( p3_cmd_pipe_f.cfg_err )
        cfg_rdata [ (4*32) +: 32 ]      = 32'h0 ;
      else
        cfg_rdata [ (4*32) +: 32 ]      = p3_cfg_fmem_rdata_selected ;
    end
    default   : begin
      p3_cmd_not_fmem_nc                = 1'b1 ;                // This always block only assigns wires for fifo mem; nothing to do otherwise
    end
  endcase
end // always

//----------------------------------------------------------------------------------------
// fifo_aempty is a dynamic indicator (pulse) in sync with the pipe indicating that the FIFO which
// was pushed/popped has a depth <= the low watermark.
// Push pointer is next loc to be written, pop pointer is next loc to be read, full is distinguished from empty
// by the gen bit.

assign p2_fifo_low_wm_p1        = p2_fifo_low_wm_f + { { ( WMWIDTH-1 ) { 1'b0 } } , 1'b1 } ;
assign p2_fifo_low_wm_p2        = p2_fifo_low_wm_f + { { ( WMWIDTH-2 ) { 1'b0 } } , 2'h2 } ;

// Do wm math in parallel with depth calc to reduce long path
always_comb begin
  p2_fifo_low_wm_adj            = p2_fifo_low_wm_f ;
  p2_cmd_low_wm_nc              = 1'b0 ;
  case ( p2_cmd_pipe_f.cmd )
    CMD_POP:    p2_fifo_low_wm_adj      = p2_fifo_low_wm_p2 ;
    CMD_PUSH:   p2_fifo_low_wm_adj      = p2_fifo_low_wm_f ;
    CMD_READ:   p2_fifo_low_wm_adj      = p2_fifo_low_wm_p1 ;
    default   : begin
      p2_cmd_low_wm_nc                  = 1'b1 ;                // This always block only assigns wires for low wm; nothing to do otherwise
    end
  endcase
end // always

assign p2_fifo_size = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_bounds_pipe_f.min_addr.ba.bounds + 1'b1 ) ;

assign p2_fifo_depth_padded     = ( p2_ptr_pipe_f.push_ptr.pa.ptr_gen == p2_ptr_pipe_f.pop_ptr.pa.ptr_gen )
                                    ?  ( { 1'b0 , p2_ptr_pipe_f.push_ptr.pa.ptr }
                                         -
                                         { 1'b0 , p2_ptr_pipe_f.pop_ptr.pa.ptr } )
                                    :  ( (   { 1'b0 , p2_ptr_pipe_f.push_ptr.pa.ptr }
                                             -
                                             { 1'b0 , p2_bounds_pipe_f.min_addr.ba.bounds } )
                                         + 
                                         (   { 1'b0 , p2_bounds_pipe_f.max_addr.ba.bounds }
                                             -
                                             { 1'b0 , p2_ptr_pipe_f.pop_ptr.pa.ptr } )
                                         +
                                         { { ( AWIDTH ) { 1'b0 } } , 1'b1 } ) ;

generate
  if ( DEPTHWIDTH > AWIDTH ) begin : gen_depth_pow2     // Only true if DEPTH is power of 2; if so, DEPTHWIDTH = AWIDTH + 1
    assign p2_fifo_depth        = p2_fifo_depth_padded ;
    assign p2_fifo_depth_lt_wm_adj  = p2_fifo_depth < p2_fifo_low_wm_adj ;
  end
  else begin : gen_depth_not_pow2                       // Only true if not power of 2; if so, DEPTHWIDTH = AWIDTH
    assign p2_fifo_depth        = p2_fifo_depth_padded [DEPTHWIDTH-1:0] ;
    assign p2_fifo_depth_lt_wm_adj  = p2_fifo_depth < p2_fifo_low_wm_adj ;
  end
endgenerate

// Set p3 aempty and fifo_depth as a pipe "data" bit - parent logic must (only) look at them when cmd reaches p3 level.
always_comb begin
  p3_fifo_aempty_nxt            = p3_fifo_aempty_f ;
  p3_fifo_depth_nxt             = p3_fifo_depth_f ;
  if ( p2_v_f & ~p2_hold_aggregate ) begin
    p3_fifo_aempty_nxt          = p2_fifo_depth_lt_wm_adj &
                                  ( ( p2_cmd_pipe_f.cmd == CMD_POP ) | ( p2_cmd_pipe_f.cmd == CMD_PUSH ) | ( p2_cmd_pipe_f.cmd == CMD_READ ) ) ;
    p3_fifo_depth_nxt           = p2_fifo_depth[3:0] ;
  end
end // always

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    p3_fifo_aempty_f            <= 1'b0 ;
  end
  else begin
    p3_fifo_aempty_f            <= p3_fifo_aempty_nxt ; 
  end
end // always

always_ff @( posedge clk ) begin
  p3_fifo_depth_f               <= p3_fifo_depth_nxt ;
end // always

// Extra gating should be redundant with external logic: parent should no be looking at aempty if p3 is not valid, and
// should not be reacting to it if p3_hold = 1.  But keep the AW output interface clean as long as it's not a delay issue.
assign fifo_aempty              = p3_v_f & ~p3_hold_aggregate & p3_fifo_aempty_f ;
assign fifo_depth               = p3_fifo_depth_f ;

//----------------------------------------------------------------------------------------
// fifo_empty is a per-FIFO status vector indicating the empty status of each FIFO as of the most recent push/pop/read.
always_comb begin
  fifo_empty_nxt                        = fifo_empty_f ;
  if ( p3_ptr_pipe_bypsel_nxt ) begin
    fifo_empty_nxt [ p2_ptr_pipe_f.addr ]       = ( p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_gen == p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_gen ) &
                                                  ( p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr     == p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr ) ;
  end
  fifo_full_nxt                         = fifo_full_f ;
  if ( p3_ptr_pipe_bypsel_nxt ) begin
    fifo_full_nxt [ p2_ptr_pipe_f.addr ]        = ~ ( p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr_gen == p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr_gen ) &
                                                    ( p3_ptr_pipe_bypdata_push_ptr_nxt.pa.ptr     == p3_ptr_pipe_bypdata_pop_ptr_nxt.pa.ptr ) ;
  end
  fifo_re_m4_wrap_nxt                   = fifo_re_m4_wrap_f ;
  fifo_re_m3_wrap_nxt                   = fifo_re_m3_wrap_f ;
  fifo_re_m2_wrap_nxt                   = fifo_re_m2_wrap_f ;
  fifo_re_m1_wrap_nxt                   = fifo_re_m1_wrap_f ;
  fifo_we_m4_wrap_nxt                   = fifo_we_m4_wrap_f ;
  fifo_we_m3_wrap_nxt                   = fifo_we_m3_wrap_f ;
  fifo_we_m2_wrap_nxt                   = fifo_we_m2_wrap_f ;
  fifo_we_m1_wrap_nxt                   = fifo_we_m1_wrap_f ;
  fifo_m4_full_nxt                      = fifo_m4_full_f ;
  fifo_m3_full_nxt                      = fifo_m3_full_f ;
  fifo_m2_full_nxt                      = fifo_m2_full_f ;
  fifo_m1_full_nxt                      = fifo_m1_full_f ;
  fifo_depth_4_nxt                      = fifo_depth_4_f ;
  fifo_depth_3_nxt                      = fifo_depth_3_f ;
  fifo_depth_2_nxt                      = fifo_depth_2_f ;
  fifo_depth_1_nxt                      = fifo_depth_1_f ;
  if ( p3_ptr_pipe_bypsel_nxt ) begin
    if ( ( p2_cmd_pipe_f.cmd == CMD_POP ) & ~ p2_fifo_uflow ) begin
      fifo_re_m4_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd4 ; 
      fifo_re_m3_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd3 ; 
      fifo_re_m2_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd2 ; 
      fifo_re_m1_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd1 ; 
    end
    if ( ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ~ p2_fifo_oflow ) begin
      fifo_we_m4_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd4 ; 
      fifo_we_m3_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd3 ; 
      fifo_we_m2_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd2 ; 
      fifo_we_m1_wrap_nxt [ p2_ptr_pipe_f.addr ]  = ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_fifo_addr.pa.ptr ) == 'd1 ; 
    end
    fifo_m4_full_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd5 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd3 ) ; 
    fifo_m3_full_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd4 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd2 ) ; 
    fifo_m2_full_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd3 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd1 ) ; 
    fifo_m1_full_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd2 ) | 
                                                  ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( ( p2_fifo_size - p2_fifo_depth ) == 'd0 ) ; 

    fifo_depth_4_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( (                p2_fifo_depth ) == 'd5 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( (                p2_fifo_depth ) == 'd3 ) ; 
    fifo_depth_3_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( (                p2_fifo_depth ) == 'd4 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( (                p2_fifo_depth ) == 'd2 ) ; 
    fifo_depth_2_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( (                p2_fifo_depth ) == 'd3 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( (                p2_fifo_depth ) == 'd1 ) ; 
    fifo_depth_1_nxt [ p2_ptr_pipe_f.addr ]     = ( p2_cmd_pipe_f.cmd == CMD_POP  ) & ( (                p2_fifo_depth ) == 'd2 ) |
                                                  ( p2_cmd_pipe_f.cmd == CMD_PUSH ) & ( (                p2_fifo_depth ) == 'd0 ) ; 
  end
end // always

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    fifo_empty_f                <= { NUM_FIFOS { EMPTY_RESET_VAL } } ;
    fifo_full_f                 <= { NUM_FIFOS { 1'b0 } } ;
    p0_fifo_re_wrap_f           <= { NUM_FIFOS { WRAP_RESET_VAL } } ;
    p0_fifo_we_wrap_f           <= { NUM_FIFOS { WRAP_RESET_VAL } } ;
    p0_fifo_full_f              <= { NUM_FIFOS { 1'b0 } } ;
    p0_fifo_empty_f             <= { NUM_FIFOS { EMPTY_RESET_VAL } } ;
    p0_fifo_push_f              <= { NUM_FIFOS { 1'b0 } } ;
    p1_fifo_push_f              <= { NUM_FIFOS { 1'b0 } } ;
    p2_fifo_push_f              <= { NUM_FIFOS { 1'b0 } } ;
    p0_fifo_pop_f               <= { NUM_FIFOS { 1'b0 } } ;
    p1_fifo_pop_f               <= { NUM_FIFOS { 1'b0 } } ;
    p2_fifo_pop_f               <= { NUM_FIFOS { 1'b0 } } ;
    fifo_re_m4_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_re_m3_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_re_m2_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_re_m1_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_we_m4_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_we_m3_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_we_m2_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_we_m1_wrap_f           <= { NUM_FIFOS { 1'b0 } } ;
    fifo_m4_full_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_m3_full_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_m2_full_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_m1_full_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_depth_4_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_depth_3_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_depth_2_f              <= { NUM_FIFOS { 1'b0 } } ;
    fifo_depth_1_f              <= { NUM_FIFOS { 1'b0 } } ;
  end
  else begin
    fifo_empty_f                <= fifo_empty_nxt ;
    fifo_full_f                 <= fifo_full_nxt ;
    p0_fifo_re_wrap_f           <= p0_fifo_re_wrap_nxt ;
    p0_fifo_we_wrap_f           <= p0_fifo_we_wrap_nxt ;
    p0_fifo_full_f              <= p0_fifo_full_nxt ;
    p0_fifo_empty_f             <= p0_fifo_empty_nxt ;
    p0_fifo_push_f              <= p0_fifo_push_nxt ;
    p1_fifo_push_f              <= p1_fifo_push_nxt ;
    p2_fifo_push_f              <= p2_fifo_push_nxt ;
    p0_fifo_pop_f               <= p0_fifo_pop_nxt ;
    p1_fifo_pop_f               <= p1_fifo_pop_nxt ;
    p2_fifo_pop_f               <= p2_fifo_pop_nxt ;
    fifo_re_m4_wrap_f           <= fifo_re_m4_wrap_nxt ;
    fifo_re_m3_wrap_f           <= fifo_re_m3_wrap_nxt ;
    fifo_re_m2_wrap_f           <= fifo_re_m2_wrap_nxt ;
    fifo_re_m1_wrap_f           <= fifo_re_m1_wrap_nxt ;
    fifo_we_m4_wrap_f           <= fifo_we_m4_wrap_nxt ;
    fifo_we_m3_wrap_f           <= fifo_we_m3_wrap_nxt ;
    fifo_we_m2_wrap_f           <= fifo_we_m2_wrap_nxt ;
    fifo_we_m1_wrap_f           <= fifo_we_m1_wrap_nxt ;
    fifo_m4_full_f              <= fifo_m4_full_nxt ;
    fifo_m3_full_f              <= fifo_m3_full_nxt ;
    fifo_m2_full_f              <= fifo_m2_full_nxt ;
    fifo_m1_full_f              <= fifo_m1_full_nxt ;
    fifo_depth_4_f              <= fifo_depth_4_nxt ;
    fifo_depth_3_f              <= fifo_depth_3_nxt ;
    fifo_depth_2_f              <= fifo_depth_2_nxt ;
    fifo_depth_1_f              <= fifo_depth_1_nxt ;
  end
end // always

assign p0_fifo_re_wrap          = p0_fifo_re_wrap_f ;
assign p0_fifo_we_wrap          = p0_fifo_we_wrap_f ;
assign p0_fifo_full             = p0_fifo_full_f ;
assign p0_fifo_empty            = p0_fifo_empty_f ;
assign fifo_empty               = fifo_empty_f ;

//----------------------------------------------------------------------------------------
// Error reporting
assign err_rid                  = p3_err_rid_f ;

always_comb begin
  err_uflow             = 1'b0 ;
  err_oflow             = 1'b0 ;
  err_residue           = 1'b0 ;
  err_residue_cfg       = 1'b0 ;
  case ( p3_err_aid_f )
    UFLOW       : err_uflow             = p3_err_v_f ;
    OFLOW       : err_oflow             = p3_err_v_f ;
    RERR        : err_residue           = p3_err_v_f ;
    RERR_CFG    : err_residue_cfg       = p3_err_v_f ;
  endcase
end // always

//----------------------------------------------------------------------------------------
// Special logic to handle config read/write of FIFO memory if > 32 bits.  Need to do
// rmw if writing > 32 bits.
// Because the pipeline is idle before attempting a config access, there can be no
// conflict between this rmw and any other FIFO memory access.  And because there can only
// be at most one config access in the pipe at a time, there can be no conflict between
// multiple config accesses.

// Only do rmw read on first clock if p0 is holding, capture read data in p2 register which
// only loads if an rmw read is performed.
assign p0_cfg_fmem_rmw  = p0_v_first_f & ( DWIDTH > 32 ) & ~ p0_cmd_pipe_f.cfg_err &
                          ( p0_cmd_pipe_f.cmd == CFG_FMEM ) & ( p0_cmd_pipe_f.cfg_rw == CFG_WR ) ;
assign p0_v_first_nnc   = p0_v_first_f ;                // lint says this is nc if DWIDTH <= 32

always_comb begin
  if ( p0_cfg_fmem_rmw ) begin
    fifo_mem_re                 = 1'b1 ;
    fifo_mem_addr               = p0_cmd_pipe_f.addr [ CFG_MUX_DEGREE +: AWIDTH ] ;
  end
  else begin
    fifo_mem_re                 = fifo_mem_re_pre ;
    fifo_mem_addr               = fifo_mem_addr_pre ;
  end

  p1_cfg_fmem_rmw_nxt           = p0_cfg_fmem_rmw ;     // 1-clock pulse even if holding
end // always

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    p1_cfg_fmem_rmw_f           <= 1'b0 ;
  end
  else begin
    p1_cfg_fmem_rmw_f           <= p1_cfg_fmem_rmw_nxt ;
  end
end // always

always_comb begin
  p2_cfg_fmem_rmw_data_nxt      = p2_cfg_fmem_rmw_data_f ;
  if ( p1_cfg_fmem_rmw_f ) begin
    p2_cfg_fmem_rmw_data_nxt    = fifo_mem_rdata ;      // Capture on first clock if holding
  end
end // always

always_ff @( posedge clk ) begin
  p2_cfg_fmem_rmw_data_f        <= p2_cfg_fmem_rmw_data_nxt ;
end // always

always_comb begin
  fifo_mem_rdata_padded                         = { DWIDTH_ROUNDUP { 1'b0 } } ;
  fifo_mem_rdata_padded [DWIDTH-1:0]            = fifo_mem_rdata_pipe ;
  p2_cfg_fmem_rmw_data_padded                   = { DWIDTH_ROUNDUP { 1'b0 } } ;
  p2_cfg_fmem_rmw_data_padded [DWIDTH-1:0]      = p2_cfg_fmem_rmw_data_f ;
end // always

generate
  if ( CFG_MUX_DEGREE == 0 ) begin : gen_if_fmem
    logic [31:0]                                p2_cfg_fmem_rmw_data_nc ;       // if <= 32 no need for read data for rmw

    always_comb begin
      fifo_mem_rdata_ar [0]                     = fifo_mem_rdata_padded [ 0 +: 32 ] ;
      p2_cfg_fmem_rmw_data_ar [0]               = p2_cfg_fmem_rmw_data_padded [ 0 +: 32 ] ;
      p2_cfg_fmem_wdata_pnc [ 0 +: 32 ]         = p2_cmd_pipe_f.data [31:0] ; 
      p3_cfg_fmem_rdata_selected                = fifo_mem_rdata_ar [0] ;

      p2_cfg_fmem_rmw_data_nc                   = p2_cfg_fmem_rmw_data_ar [0] ;
    end // always
  end
  else begin : gen_else_fmem
    for ( genvar i = 0 ; i < CFG_MUX_DEGREE_POW2 ; i = i + 1 ) begin : gen_for_fmem
      always_comb begin
        fifo_mem_rdata_ar [i]                   = fifo_mem_rdata_padded [ (32*i) +: 32 ] ;
        p2_cfg_fmem_rmw_data_ar [i]             = p2_cfg_fmem_rmw_data_padded [ (32*i) +: 32 ] ;
        if ( p2_cmd_pipe_f.addr [CFG_MUX_DEGREE-1:0] == i )
          p2_cfg_fmem_wdata_pnc [ (32*i) +: 32 ]        = p2_cmd_pipe_f.data [31:0] ; 
        else
          p2_cfg_fmem_wdata_pnc [ (32*i) +: 32 ]        = p2_cfg_fmem_rmw_data_ar [i] ; 
      end // always
    end // for
    always_comb begin
      p3_cfg_fmem_rdata_selected                = fifo_mem_rdata_ar [ p3_cmd_pipe_f.addr [CFG_MUX_DEGREE-1:0] ] ;
    end
  end // else
endgenerate

//-----------------------------------------------------------------------------------------------------
// Assertions - may want to move to separate file eventually
`ifndef INTEL_SVA_OFF
logic   dbg_init_ptrs_err ;

assign dbg_init_ptrs_err        = ( p2_v_f & ~ p2_hold_aggregate &
                                    ( p2_cmd_pipe_f.cmd == 4 ) &                // CMD_INIT_PTRS
                                    ( p2_off_pipe_f.off >
                                       ( ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_bounds_pipe_f.min_addr.ba.bounds ) + 1 ) ) ) ;

logic   dbg_append_err ;

assign dbg_append_err           = ( p2_v_f & ~ p2_hold_aggregate &
                                    ( p2_cmd_pipe_f.cmd == 5 ) &                // CMD_APPEND
                                    ( ( p2_fifo_depth + p2_off_pipe_f.off ) >
                                       ( ( p2_bounds_pipe_f.max_addr.ba.bounds - p2_bounds_pipe_f.min_addr.ba.bounds ) + 1 ) ) ) ;

logic   dbg_base_limit_cfg_err ;

assign dbg_base_limit_cfg_err   = ( p2_v_f & ~ p2_hold_aggregate &
                                    (   ( p2_cmd_pipe_f.cmd == 1 ) |            // CMD_PUSH
                                        ( p2_cmd_pipe_f.cmd == 2 ) |            // CMD_POP
                                        ( p2_cmd_pipe_f.cmd == 4 ) |            // CMD_INIT_PTRS
                                        ( p2_cmd_pipe_f.cmd == 5 ) ) &          // CMD_APPEND
                                     ( p2_bounds_pipe_f.max_addr.ba.bounds < p2_bounds_pipe_f.min_addr.ba.bounds )
                                  ) ;

    hqm_AW_multi_fifo_wm_wtcfg_exp_assert i_hqm_AW_multi_fifo_wm_wtcfg_exp_assert (.*) ;
`endif

endmodule // hqm_AW_multi_fifo_wm_wtcfg_exp

`ifndef INTEL_SVA_OFF

module hqm_AW_multi_fifo_wm_wtcfg_exp_assert import hqm_AW_pkg::*; (
          input logic clk
        , input logic rst_n
        , input logic cmd_v
        , input logic cfg_req_read_any
        , input logic cfg_req_write_any
        , input logic dbg_init_ptrs_err
        , input logic dbg_append_err
        , input logic dbg_base_limit_cfg_err
);

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_func_cfg_collision
                      , ( cmd_v & ( cfg_req_read_any | cfg_req_write_any ) )
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_func_cfg_collision: ")
                        , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_init_ptrs_out_of_range
                      , dbg_init_ptrs_err
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_init_ptrs_out_of_range: ")
                        , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_append_out_of_range
                      , dbg_append_err
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_append_out_of_range: ")
                        , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_base_limit_cfg_err
                      , dbg_base_limit_cfg_err
                      , clk
                     , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_base_limit_cfg_err: ")
                        , SDG_SVA_SOC_SIM
                      ) 


endmodule // hqm_AW_multi_fifo_wm_wtcfg_exp_assert
`endif
// 
