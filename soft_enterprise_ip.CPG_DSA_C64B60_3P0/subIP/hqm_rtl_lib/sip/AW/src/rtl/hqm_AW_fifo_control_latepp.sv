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
//
// AW_fifo_control : start with  hqm_AW_fifo_control_big.sv & overlap incr, decr, and compare with the pop/push detection to minimize depth
//
// Extended from the existing AW_fifo_ctrl. Updated to remove all input port to RAM timing paths.
// To reduce size the bypass register is removed and the RAM output is connected directly to the
// pop data output. THere is a bypass condition to support a pop issued the clock after a push
// to an empty FIFO. The RAM is always written even when the data is bypassed, but the logic
// prevents a read and write to the same address in RAM.
//
//
// This is a parametized FIFO controller for a DEPTH deep by DWIDTH wide FIFO memory.
// The fifo_size field must be wide enough to hold the value of DEPTH
// The cfg_high_wm and cfg_low_wm fields must be wide enough to the value of DEPTH
//
// The following parameters are supported:
//
//      DEPTH                   Depth of the external memory (actual FIFO depth is DEPTH+1).
//      DWIDTH                  Width of the FIFO and datapath.
//      MEMRE_POWER_OPT         Controls whether memory reads are issued only when needed (1)
//                              or if memory reads are always issued if the fifo size is > 1 (0).
//                              The default is the latter, which eliminates a path from pop to mem_re.
//
// The fifo_status output is defined in the aw_fifo_status_t structure:
//
//      [31:8]:                 FIFO depth
//      [7]:                    FIFO full         (FIFO depth == FIFO size)
//      [6]:                    FIFO almost full  (FIFO depth >= high watermark)
//      [5]:                    Reserved
//      [4]:                    FIFO empty        (FIFO depth == 0)
//      [3]:                    Reserved
//      [2]:                    FIFO parity error (always 0)
//      [1]:                    FIFO overflow     (push while FIFO full)
//      [0]:                    FIFO underflow    (pop  while FIFO empty)
//
// It is recommended that the entire set of fifo_status information be accessible through the
// configuration interface as read-only status.  It is required that at least the full, empty,
// overflow, and underflow bits be made available.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// Push and pop are the basic FIFO operations.
// The memory interface is designed to interface to a 2-port memory, be it a register file (1
// write port and 1 read port) or a full 2-port SRAM (2 R/W ports).
// The push_data input must be valid at the same time as the push input.
// The pop_data output is valid whenever the fifo_empty signal is not asserted.
// High and low watermark inputs are provided and the corresponding fifo_afull
// outputs are set whenever fifo_size >= high or <= low.
// Push while full without pop and pop while empty conditions are flagged by the fifo_overflow
// and fifo_underflow fields of the fifo_status output.
// The fifo_overflow and fifo_underflow are pulse signals and must be captures in a ISR register
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// push operation timing
//                    _____       _____       _____
// clk          _____|     |_____|     |_____|
//                       ___________
// push         ________|           |______________
//                       ___________
// push_data    --------X___________X--------------
//                                _________________
// pop_data     -----------------X___valid_data____
//              _________________ _________________
// fifo_size   _________________X_________________
//              _________________
// fifo_empty                    |_________________
//
//                                _________________
// fifo_full    _________________|
// fifo_afull
// fifo_overflow
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// pop operation timing
//                    _____       _____       _____
// clk          _____|     |_____|     |_____|
//              _________________ _________________
// pop_data     ___valid_data____X___next_data_____
//                       ___________
// pop          ________|           |______________
//              _________________ _________________
// fifo_size   _________________X_________________
//              _________________
// fifo_full                     |_________________
// fifo_afull
//                                _________________
// fifo_empty   _________________|
//
// fifo_underflow
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_latepp
import hqm_AW_pkg::* ;
# (
    parameter DEPTH                     = 8
  , parameter DWIDTH                    = 16
  //...............................................................................................................................................
  , parameter DEPTHB2                   = ( AW_logb2 ( DEPTH -1 ) + 1 )
  , parameter DEPTHWIDTH                = ( AW_logb2 ( DEPTH    ) + 1 )
  , parameter WMWIDTH                   = ( AW_logb2 ( DEPTH +1 ) + 1 )
  , parameter MEMRE_POWER_OPT           = 0
  ) (
    input  logic                        clk
  , input  logic                        rst_n

  , input  logic [( 1 ) -1 : 0]         push
  , input  logic [( DWIDTH ) -1 : 0]    push_data
  , input  logic [( 1 ) -1 : 0]         pop
  , output logic [( DWIDTH ) -1 : 0]    pop_data

  , input  logic [( WMWIDTH ) -1 : 0] cfg_high_wm

  , output logic [( 1 ) -1 : 0]         mem_we
  , output logic [( DEPTHB2 ) -1 : 0]   mem_waddr
  , output logic [( DWIDTH ) -1 : 0]    mem_wdata
  , output logic [( 1 ) -1 : 0]         mem_re
  , output logic [( DEPTHB2 ) -1 : 0]   mem_raddr
  , input  logic [( DWIDTH ) -1 : 0]    mem_rdata

  , output aw_fifo_status_t             fifo_status
  , output logic [( 1 ) -1 : 0]         fifo_full
  , output logic [( 1 ) -1 : 0]         fifo_afull
  , output logic [( 1 ) -1 : 0]         fifo_empty
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
// local paramters & typedefs

typedef struct packed {
logic [ ( 1 ) -1 : 0 ] mem_re ;
logic [ ( 1 ) -1 : 0 ] mem_we ;
logic [ ( DEPTHWIDTH ) -1 : 0 ] fifo_size ;
logic [ ( DEPTHWIDTH ) -1 : 0 ] fifo_sizep1 ;
logic [ ( DEPTHWIDTH ) -1 : 0 ] fifo_sizem1 ;
logic [ ( 1 ) -1 : 0 ] fifo_full ;
logic [ ( 1 ) -1 : 0 ] fifo_afull ;
logic [ ( 1 ) -1 : 0 ] fifo_empty ;
logic [ ( 1 ) -1 : 0 ] fifo_overflow ;
logic [ ( 1 ) -1 : 0 ] fifo_underflow ;
} pipe_state_t ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers

logic   pop_enbl;       // pop and not empty
logic   push_enbl;      // push and not full

logic [ ( 1 ) -1 : 0 ]          p0_push_data_v_f , p0_push_data_v_nxt ; // valid push data in register (held for 1 cycle only)
logic [ ( DWIDTH ) -1 : 0 ]     p0_push_data_f ,   p0_push_data_nxt ;   // push data

logic [ ( DEPTHWIDTH ) -1 : 0 ] nxt_fifo_sizem2 , nxt_fifo_sizem1 , nxt_fifo_size , nxt_fifo_sizep1 , nxt_fifo_sizep2 ; // calculated next fifo size
logic fifo_full_push ,fifo_afull_push , fifo_empty_push ;
logic fifo_full_pop , fifo_afull_pop , fifo_empty_pop ;

pipe_state_t p0_state_f , p0_state_nxt ;        // current and next fifo state

logic [ ( DEPTHB2 ) -1 : 0 ] wp_nxt ;           // write pointer (increment when pushing and have to write to memory)
logic [ ( DEPTHB2 ) -1 : 0 ] wp_f ;
logic [ ( DEPTHB2 ) -1 : 0 ] rp_nxt ;           // read pointer (increment when have to read memory after a pop)
logic [ ( DEPTHB2 ) -1 : 0 ] rp_f ;

logic [ ( DEPTHB2 +1 ) -1 : 0 ] wp_nxt_mux ;           // write pointer (increment when pushing and have to write to memory)
logic [ ( DEPTHB2 +1 ) -1 : 0 ] rp_nxt_mux ;           // read pointer (increment when have to read memory after a pop)

logic [( DWIDTH ) -1 : 0]    pop_data_f;        // hold pop_data for case when pop_data not taken

logic                        mem_re_bypass;     // detect memory read bypass if reading the same addressing as writing
logic                        mem_re_bypass_f;
logic                        mem_re_block;      // block memory reads if read and write address are the same (eliminate mem-to-mem path)
logic [( DWIDTH ) -1 : 0]    mem_rdata_bypass_f;  // remember write data when bypassing

assign pop_enbl         = pop  & ~p0_state_f.fifo_empty;
assign push_enbl        = push & ~p0_state_f.fifo_full;

assign p0_push_data_nxt         = push_enbl ? push_data : p0_push_data_f;       // update if push_enbl
assign p0_push_data_v_nxt       = push_enbl;

always_comb
begin

  nxt_fifo_sizem2 = ( p0_state_f.fifo_sizem1 - { {(DEPTHWIDTH-1){1'b0}} , 1'd1 } ) ;
  nxt_fifo_sizem1 = ( p0_state_f.fifo_sizem1 ) ;
  nxt_fifo_size   = ( p0_state_f.fifo_size ) ;
  nxt_fifo_sizep1 = ( p0_state_f.fifo_sizep1 ) ;
  nxt_fifo_sizep2 = ( p0_state_f.fifo_sizep1 + { {(DEPTHWIDTH-1){1'b0}} , 1'd1 } ) ;

  fifo_full_push  = ( p0_state_f.fifo_sizep1 == (DEPTH + 32'd1) ) ;
  fifo_afull_push = ( p0_state_f.fifo_sizep1 >= cfg_high_wm ) ;
  fifo_empty_push = ( p0_state_f.fifo_sizep1 == '0 ) ;
  fifo_full_pop   = ( p0_state_f.fifo_sizem1 == (DEPTH + 32'd1) ) ;
  fifo_afull_pop  = ( p0_state_f.fifo_sizem1 >= cfg_high_wm ) ;
  fifo_empty_pop  = ( p0_state_f.fifo_sizem1 == '0 ) ;

  //..............................................................................................................................................
  //default output values
  p0_state_nxt                          = p0_state_f ;
  p0_state_nxt.mem_re                   = 1'd0;
  p0_state_nxt.mem_we                   = 1'd0;

  if ( ~pop_enbl & push_enbl ) begin
    p0_state_nxt.fifo_sizem1            = nxt_fifo_size ;
    p0_state_nxt.fifo_size              = nxt_fifo_sizep1 ;
    p0_state_nxt.fifo_sizep1            = nxt_fifo_sizep2 ;
  end
  if ( pop_enbl & ~push_enbl ) begin
    p0_state_nxt.fifo_sizem1            = nxt_fifo_sizem2 ;
    p0_state_nxt.fifo_size              = nxt_fifo_sizem1 ;
    p0_state_nxt.fifo_sizep1            = nxt_fifo_size ;
  end

  //..............................................................................................................................................
  // p0 pop pipeline
  p0_state_nxt.fifo_underflow           = ( ( pop == 1'd1 ) & p0_state_f.fifo_empty );

  if ( pop_enbl & (p0_state_f.fifo_size > 1) )  // read memory if pop and there is greater than 1 entry in fifo (not including a new push)
  begin
    p0_state_nxt.mem_re                 = 1'd1;
  end

  //..............................................................................................................................................
  // p0 push pipeline
  p0_state_nxt.fifo_overflow            = ( ( push == 1'd1 ) & p0_state_f.fifo_full );

  // write memory if push, the fifo is not empty, and either not popping or more than 1 entry in fifo (not including a new push)
  if ( push_enbl & ~p0_state_f.fifo_empty & (~pop_enbl | (p0_state_f.fifo_size > 1) ) )
  begin
    p0_state_nxt.mem_we                 = 1'd1;
  end

  //..............................................................................................................................................
  // update p0 pipeline control flags
  if ( ~pop_enbl & push_enbl ) begin
    p0_state_nxt.fifo_full              = fifo_full_push ;
    p0_state_nxt.fifo_afull             = fifo_afull_push ;
    p0_state_nxt.fifo_empty             = fifo_empty_push ;
  end
  if ( pop_enbl & ~push_enbl ) begin
    p0_state_nxt.fifo_full              = fifo_full_pop ;
    p0_state_nxt.fifo_afull             = fifo_afull_pop ;
    p0_state_nxt.fifo_empty             = fifo_empty_pop ;
  end

end

assign wp_nxt_mux = mem_we ? ( {1'b0,wp_f} + {{(DEPTHB2){1'b0}},1'b1} ) : {1'b0,wp_f} ;                  // update if writing memory
assign rp_nxt_mux = p0_state_nxt.mem_re ? ( {1'b0,rp_f} + {{(DEPTHB2){1'b0}},1'b1} ) : {1'b0,rp_f} ;     // update if reading memory (ignore bypass check)


assign wp_nxt = (wp_nxt_mux >= DEPTH[DEPTHB2:0]) ? {DEPTHB2{1'b0}} : wp_nxt_mux[DEPTHB2-1:0];
assign rp_nxt = (rp_nxt_mux >= DEPTH[DEPTHB2:0]) ? {DEPTHB2{1'b0}} : rp_nxt_mux[DEPTHB2-1:0];

assign mem_re_bypass = p0_state_nxt.mem_re & p0_state_f.mem_we & (rp_f == wp_f);        // detect read/write bypass case
assign mem_re_block = (rp_f == wp_f) & mem_we;        // similar to mem_re_bypass but used to block the mem_re to avoid R & W to same address

// The pop_data output will be either the read bypass data, memory read data, push data, or the last pop_data.
//   * If a bypass condition is detected, use mem_rdata_bypass_f (previous cycle memory write data).
//   * If not a bypass condition and a memory read was done, use mem_rdata.
//   * If there a memory read was not needed, there is valid push data, and there is only 1 entry in the fifo use the push data.
//   * If none of the other cases are met, use pop_data_f (the value of pop_data the previous cycle).
//
// Note that if a pop was done the previous cycle and there is more than 1 entry in the fifo a memory read will be requested.
// When there was not a pop done, pop_data can either be new push data, or the previous pop_data.
assign pop_data = mem_re_bypass_f ? mem_rdata_bypass_f :
                                    ((p0_state_f.mem_re) ? mem_rdata :
                                                         ((p0_push_data_v_f & (p0_state_f.fifo_size == 1)) ? p0_push_data_f :
                                                                                                             pop_data_f));

assign mem_we                                = p0_state_f.mem_we ;                      // do memory write due to a push (if needed)
assign mem_waddr                             = wp_f;
assign mem_wdata                             = p0_push_data_f ;                         // memory write data always comes from the push data
assign mem_re                                = (MEMRE_POWER_OPT ? p0_state_nxt.mem_re : (p0_state_f.fifo_size > 1)) &
                                               ~mem_re_block;    // do not do a read if block case detected
assign mem_raddr                             = rp_f;

// resetable register
always_ff @ ( posedge clk or negedge rst_n )
begin
  if ( rst_n == 1'd0 )
  begin
    p0_state_f.mem_re <= 1'b0 ;
    p0_state_f.mem_we <= 1'b0 ;
    p0_state_f.fifo_size <= '0 ;
    p0_state_f.fifo_sizep1 <= { {(DEPTHWIDTH-1){1'b0}} , 1'd1 } ;
    p0_state_f.fifo_sizem1 <= '1 ;
    p0_state_f.fifo_full <= 1'b0 ;
    p0_state_f.fifo_afull <= 1'b0 ;
    p0_state_f.fifo_empty <= 1'b1 ;
    p0_state_f.fifo_overflow <= 1'b0 ;
    p0_state_f.fifo_underflow <= 1'b0 ;
    wp_f <= '0;
    rp_f <= '0;
    p0_push_data_v_f <= 1'b0;
    mem_re_bypass_f <= 1'b0;
  end
  else
  begin
    p0_state_f <= p0_state_nxt ;
    wp_f <= wp_nxt;
    rp_f <= rp_nxt;
    p0_push_data_v_f <= p0_push_data_v_nxt;
    mem_re_bypass_f <= mem_re_bypass;
  end
end

// non-resetable register
always_ff @ ( posedge clk )
begin
  p0_push_data_f <= p0_push_data_nxt ;
  pop_data_f <= pop_data;
  if (mem_re_bypass) begin
    mem_rdata_bypass_f <= mem_wdata;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
always_comb
begin
  //default output values
  fifo_full                             = p0_state_f.fifo_full;
  fifo_afull                            = p0_state_f.fifo_afull;
  fifo_empty                            = p0_state_f.fifo_empty;
  fifo_status.depth                     = { { ( 32 - DEPTHWIDTH - 8 ) { 1'b0 } } , p0_state_f.fifo_size } ;
  fifo_status.full                      = p0_state_f.fifo_full ;
  fifo_status.afull                     = p0_state_f.fifo_afull ;
  fifo_status.empty                     = p0_state_f.fifo_empty ;
  fifo_status.aempty                    = 1'b0 ;
  fifo_status.rsvd3                     = 1'b0 ;
  fifo_status.parity_err                = 1'b0 ;
  fifo_status.overflow                  = p0_state_f.fifo_overflow ;
  fifo_status.underflow                 = p0_state_f.fifo_underflow ;

end

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_underflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
  !( p0_state_f.fifo_underflow )) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_overflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
  !( p0_state_f.fifo_overflow )) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (push while full) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule
