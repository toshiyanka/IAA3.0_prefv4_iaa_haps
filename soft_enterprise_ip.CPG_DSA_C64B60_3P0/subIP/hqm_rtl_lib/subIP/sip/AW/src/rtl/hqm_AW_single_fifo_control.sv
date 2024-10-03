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
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_single_fifo_control
  import hqm_AW_pkg::*;
# (
  parameter DEPTH               = 1024
, parameter DWIDTH              = 64
// Note: the following parameter values should not be specified where this module is instantiated
, parameter PTRWIDTH            = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHWIDTH          = ( AW_logb2 ( DEPTH ) + 1 )
) (
  input  logic                  clk
, input  logic                  rst_n
, output logic                  full
, output logic                  empty
, output logic                  err_uf
, output logic                  err_of
//----------------------------------------------------------------------------------------
// Functional commands
, input  logic                  cmd_v
, input  aw_multi_fifo_cmd_t    cmd
, input  logic [DWIDTH-1:0]     push_data
, output logic [DWIDTH-1:0]     pop_data

//----------------------------------------------------------------------------------------
// FIFO mem interface (single-port sram)
, output logic                  fifo_mem_re
, output logic [PTRWIDTH-1:0]   fifo_mem_addr
, output logic                  fifo_mem_we
, output logic [DWIDTH-1:0]     fifo_mem_wdata
, input  logic [DWIDTH-1:0]     fifo_mem_rdata
) ;

typedef struct packed {
  logic                  err_uf ;
  logic                  err_of ;
  aw_multi_fifo_cmd_t    cmd ;
  logic [DWIDTH-1:0]     data ;
  logic [PTRWIDTH-1:0]   addr ;
} pipe_data_t ;

pipe_data_t p0_pipedata_f , p0_pipedata_nxt , p1_pipedata_f , p1_pipedata_nxt , p2_pipedata_f , p2_pipedata_nxt ;
logic p0_pipev_f , p0_pipev_nxt , p1_pipev_f , p1_pipev_nxt , p2_pipev_f , p2_pipev_nxt ;
logic [ ( DEPTHWIDTH ) - 1 : 0 ] size_nxt , size_f ;
logic [ ( PTRWIDTH ) - 1 : 0 ] wp_nxt , wp_f , rp_nxt , rp_f ;
logic full_nxt , full_f ;
logic empty_nxt , empty_f ;
logic push ;
logic pop ;

always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ! rst_n ) begin
    p0_pipev_f                  <= '0 ;
    p1_pipev_f                  <= '0 ;
    p2_pipev_f                  <= '0 ;
    size_f                      <= '0 ;
    wp_f                        <= '0 ;
    rp_f                        <= '0 ;
    empty_f                     <= '1 ;
    full_f                      <= '0 ;
  end
  else begin
    p0_pipev_f                  <= p0_pipev_nxt ;
    p1_pipev_f                  <= p1_pipev_nxt ;
    p2_pipev_f                  <= p2_pipev_nxt ;
    size_f                      <= size_nxt ;
    wp_f                        <= wp_nxt ;
    rp_f                        <= rp_nxt ;
    empty_f                     <= empty_nxt ;
    full_f                      <= full_nxt ;
  end
end

always_ff @ ( posedge clk ) begin
    p0_pipedata_f               <= p0_pipedata_nxt ;
    p1_pipedata_f               <= p1_pipedata_nxt ;
    p2_pipedata_f               <= p2_pipedata_nxt ;
end

//drive status outputs
assign full_nxt                = ( size_nxt == DEPTH [ ( DEPTHWIDTH ) - 1 : 0 ] ) ;
assign full                    = full_f ;
assign empty_nxt               = ( size_nxt == { DEPTHWIDTH { 1'b0 } } ) ;
assign empty                   = empty_f ;

// P2 output drives pop data &  synchronious uf/of
assign err_uf                  = p2_pipev_f & p2_pipedata_f.err_uf ;
assign err_of                  = p2_pipev_f & p2_pipedata_f.err_of ;
assign pop_data                = p2_pipedata_f.data ;

//decode input command into push/pop for cleaner code
assign push                    = ( cmd == HQM_AW_MF_PUSH ) ;
assign pop                     = ( cmd == HQM_AW_MF_POP ) ;

always_comb begin

  //output default
  fifo_mem_re = '0 ;
  fifo_mem_addr = '0 ;
  fifo_mem_we = '0 ;
  fifo_mem_wdata = '0 ;
  //register default for clock gating
  p0_pipev_nxt = '0 ;
  p0_pipedata_nxt = p0_pipedata_f ;
  p1_pipev_nxt = '0 ;
  p1_pipedata_nxt = p1_pipedata_f ;
  p2_pipev_nxt = '0 ;
  p2_pipedata_nxt = p2_pipedata_f ;
  size_nxt = size_f ;
  wp_nxt = wp_f ;
  rp_nxt = rp_f ;

  //capture input command into p0
  // - decode uf/of
  // - if no error then update size, wp, and rp
  if ( cmd_v ) begin
    p0_pipev_nxt                = 1'b1 ;
    p0_pipedata_nxt.err_uf      = ( pop & ( size_f == { DEPTHWIDTH { 1'b0 } } ) ) ;
    p0_pipedata_nxt.err_of      = ( push & ( size_f == DEPTH [ ( DEPTHWIDTH ) - 1 : 0 ] ) ) ;
    p0_pipedata_nxt.cmd         = cmd ;
    p0_pipedata_nxt.addr        = pop ? rp_f : wp_f ;
    p0_pipedata_nxt.data        = push_data ;
    if ( ~ p0_pipedata_nxt.err_uf & ~ p0_pipedata_nxt.err_of ) begin
      size_nxt                  = ( size_f
                                  + { { ( DEPTHWIDTH - 1 ) { 1'b0 } } , push }
                                  - { { ( DEPTHWIDTH - 1 ) { 1'b0 } } , pop }
                                  ) ;
      wp_nxt                    = ( wp_f
                                  + { { ( PTRWIDTH - 1 ) { 1'b0 } } , push }
                                  ) ;
      rp_nxt                    = ( rp_f
                                  + { { ( PTRWIDTH - 1 ) { 1'b0 } } , pop }
                                  ) ;
    end
  end

  //P0 output captured into P1.
  // issues RAM access when no error
  if ( p0_pipev_f ) begin
    p1_pipev_nxt                = 1'b1 ;
    p1_pipedata_nxt             = p0_pipedata_f ;
    if ( ~ p0_pipedata_f.err_uf & ~ p0_pipedata_f.err_of ) begin
      fifo_mem_re               = ( p0_pipedata_f.cmd == HQM_AW_MF_POP ) ;
      fifo_mem_addr             = ( p0_pipedata_f.addr ) ;
      fifo_mem_we               = ( p0_pipedata_f.cmd == HQM_AW_MF_PUSH ) ;
      fifo_mem_wdata            = ( p0_pipedata_f.data ) ;
    end
  end

  //P1 output captured into P2 and P2 output is driven to outputs
  // capture RAM read responce
  if ( p1_pipev_f ) begin
    p2_pipev_nxt                = 1'b1 ;
    p2_pipedata_nxt             = p1_pipedata_f ;
    p2_pipedata_nxt.data        = fifo_mem_rdata ;
  end

end

endmodule
