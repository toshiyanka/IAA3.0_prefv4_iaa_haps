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
// hqm_AW_fifo_control_jdc_core
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_gdc_core
  import hqm_AW_pkg::*;
#(
  parameter DEPTH                         = 2 
, parameter DWIDTH                        = 2 
, parameter SYNC_POP                      = 0 // Status synced to clk_push(0) or clk_pop(1)
//////////
, parameter AWIDTH                        = ( AW_logb2 ( DEPTH - 1 ) + 1 ) 
, parameter GRAYWIDTH                     = AWIDTH + 1 
, parameter DEPTHWIDTH                    = ( ( ( 2 ** AWIDTH ) == DEPTH ) ? ( AWIDTH + 1 ) : AWIDTH ) 
) (
  input  logic                            clk_push 
, input  logic                            rst_push_n 
, input  logic                            clk_pop 
, input  logic                            rst_pop_n 

, input  logic [ ( DEPTHWIDTH - 1 ) : 0 ] cfg_high_wm 
, input  logic [ ( DEPTHWIDTH - 1 ) : 0 ] cfg_low_wm 

, input  logic                            fifo_enable 
, input  logic                            clear_pop_state 

, input  logic                            push 
, input  logic [ ( DWIDTH - 1 ) : 0 ]     push_data 

, input  logic                            pop 
, output logic [ ( DWIDTH - 1 ) : 0 ]     pop_data 

, output logic                            mem_we 
, output logic [ ( AWIDTH - 1 ) : 0 ]     mem_waddr 
, output logic [ ( DWIDTH - 1 ) : 0 ]     mem_wdata 
, output logic                            mem_re 
, output logic [ ( AWIDTH - 1 ) : 0 ]     mem_raddr 
, input  logic [ ( DWIDTH - 1 ) : 0 ]     mem_rdata 

, output logic [ ( DEPTHWIDTH - 1 ) : 0 ] fifo_push_depth 
, output logic                            fifo_push_full 
, output logic                            fifo_push_afull 
, output logic                            fifo_push_empty 
, output logic                            fifo_push_aempty 

, output logic [ ( DEPTHWIDTH - 1 ) : 0]  fifo_pop_depth 
, output logic                            fifo_pop_aempty 
, output logic                            fifo_pop_empty 

, output logic [ ( 32 - 1 ) : 0 ]         fifo_status 
);

logic push_gctr_rptr_incr ;
logic [ ( GRAYWIDTH - 1 ) : 0 ] push_gctr_rptr ;
logic push_gctr_wptr_incr ;
logic [ ( GRAYWIDTH - 1 ) : 0 ] push_gctr_wptr , sync_push_gctr_wptr ;
logic [ ( AWIDTH - 1 ) : 0 ] push_wptr_nxt , push_wptr_f ;
logic [ ( DEPTHWIDTH - 1 ) : 0 ] push_depth_nxt , push_depth_f ;
logic push_empty_nxt , push_empty_f ;
logic push_full_nxt , push_full_f ;
logic push_afull_nxt , push_afull_f ;
logic push_overflow_nxt , push_overflow_f ;
always_ff @( posedge clk_push or negedge rst_push_n ) begin: L000
 if ( ~ rst_push_n ) begin
   push_wptr_f <= '0 ;
   push_depth_f <= '0 ;
   push_empty_f <= '1 ;
   push_full_f <= '0 ;
   push_afull_f <= '0 ;
   push_overflow_f <= '0 ;
 end else begin
   push_wptr_f <= push_wptr_nxt ;
   push_depth_f <= push_depth_nxt ;
   push_empty_f <= push_empty_nxt ;
   push_full_f <= push_full_nxt ;
   push_afull_f <= push_afull_nxt ;
   push_overflow_f <= push_overflow_nxt ;
 end
end
hqm_AW_grayinc #( .WIDTH ( GRAYWIDTH ) ) i_push_gctr_rptr (
  .clk            ( clk_push )
, .rst_n          ( rst_push_n )
, .clear          ( 1'b0 )
, .incr           ( push_gctr_rptr_incr )
, .gray           ( push_gctr_rptr )
) ;
hqm_AW_grayinc #( .WIDTH ( GRAYWIDTH ) ) i_push_gctr_wptr (
  .clk            ( clk_push )
, .rst_n          ( rst_push_n )
, .clear          ( 1'b0 )
, .incr           ( push_gctr_wptr_incr )
, .gray           ( push_gctr_wptr )
) ;
hqm_AW_sync_rst0 #( .WIDTH ( GRAYWIDTH ) ) i_push_gctr_wptr_sync (
  .clk            ( clk_pop )
, .rst_n          ( rst_pop_n )
, .data           ( push_gctr_wptr )
, .data_sync      ( sync_push_gctr_wptr )
);

logic pop_gctr_rptr_incr ;
logic [ ( GRAYWIDTH - 1 ) : 0 ] pop_gctr_rptr , sync_pop_gctr_rptr ;
logic pop_gctr_wptr_incr ;
logic [ ( GRAYWIDTH - 1 ) : 0 ] pop_gctr_wptr ;
logic [ ( AWIDTH - 1 ) : 0 ] pop_rptr_nxt , pop_rptr_f ;
logic [ ( DEPTHWIDTH - 1 ) : 0 ] pop_depth_nxt , pop_depth_f ;
logic pop_empty_nxt , pop_empty_f ;
logic pop_underflow_nxt , pop_underflow_f ;
logic do_push , do_pop ;
always_ff @( posedge clk_pop or negedge rst_pop_n ) begin : L100
 if ( ~ rst_pop_n ) begin
    pop_rptr_f <= '0 ;
    pop_depth_f <= '0 ;
    pop_empty_f <= '1 ;
    pop_underflow_f <= '0 ;
 end else if ( clear_pop_state ) begin
    pop_rptr_f <= '0 ;
    pop_depth_f <= '0 ;
    pop_empty_f <= '1 ;
    pop_underflow_f <= '0 ;
 end else if ( fifo_enable ) begin
    pop_rptr_f <= pop_rptr_nxt ;
    pop_depth_f <= pop_depth_nxt ;
    pop_empty_f <= pop_empty_nxt ;
    pop_underflow_f <= pop_underflow_nxt ;
 end
end
hqm_AW_grayinc #( .WIDTH ( GRAYWIDTH ) ) i_pop_gctr_rptr (
  .clk            ( clk_pop ) 
, .rst_n          ( rst_pop_n )
, .clear          ( clear_pop_state )
, .incr           ( pop_gctr_rptr_incr )
, .gray           ( pop_gctr_rptr )
) ;
hqm_AW_grayinc #( .WIDTH ( GRAYWIDTH ) ) i_pop_gctr_wptr (
  .clk            ( clk_pop )
, .rst_n          ( rst_pop_n )
, .clear          ( clear_pop_state )
, .incr           ( pop_gctr_wptr_incr )
, .gray           ( pop_gctr_wptr )
) ;
hqm_AW_sync_rst0 #( .WIDTH ( GRAYWIDTH ) ) i_pop_gctr_rptr_sync (
  .clk            ( clk_push )
, .rst_n          ( rst_push_n )
, .data           ( pop_gctr_rptr )
, .data_sync      ( sync_pop_gctr_rptr)
);

//..................................................
// Interface 
assign mem_we              = do_push ;
assign mem_waddr           = push_wptr_f ;
assign mem_wdata           = push_data ;
assign mem_re              = ~ pop_empty_nxt ;
assign mem_raddr           = pop_rptr_nxt ;
assign pop_data            = mem_rdata ;

assign fifo_push_depth     = push_depth_f ;
assign fifo_push_full      = push_full_f ;
assign fifo_push_afull     = push_afull_f ;
assign fifo_push_empty     = push_empty_f ;
assign fifo_push_aempty    = '0 ;
assign fifo_pop_depth      = pop_depth_f ;
assign fifo_pop_aempty     = '0 ;
assign fifo_pop_empty      = pop_empty_f | ~ fifo_enable ;

//..................................................
//PUSH
// when push=1
//   * detect overflow(pulse) if currently full
//   * increment push writePtr
//   * increment push depth
//   * increment johnson writePtr and sync to POP
// when push readPtr does not match synced pop readPtr (sync pop)
//   * decrement push depth
//   * increment johnson readPtr
// create output push_empty, push_full, push_afull using updated pushdepth
assign push_overflow_nxt   = ( push & push_full_f ) ;
assign do_push             = ( push & ~ push_full_f ) ;
assign push_gctr_wptr_incr = ( do_push ) ;
assign push_gctr_rptr_incr = ( push_gctr_rptr != sync_pop_gctr_rptr ) ;
assign push_wptr_nxt       = ( push_wptr_f
                             + { {(AWIDTH-1){1'b0}} , do_push }
                             ) ;
assign push_depth_nxt      = ( push_depth_f
                             + { {(DEPTHWIDTH-1){1'b0}} , do_push }
                             - { {(DEPTHWIDTH-1){1'b0}} , push_gctr_rptr_incr }
                             ) ;
assign push_empty_nxt      = ( push_depth_nxt == {(DEPTHWIDTH){1'b0}} ) ;
assign push_full_nxt       = ( push_depth_nxt == DEPTH [ ( DEPTHWIDTH - 1 ) : 0 ] ) ;
assign push_afull_nxt      = ( push_depth_nxt >= cfg_high_wm ) ;

//..................................................
//POP
// when pop writePtr does not match synced push writePtr (sync push)
//   * increment pop depth
//   * increment johnson writePtr
// when pop=1
//   * detect underflow(pulse) if currently empty
//   * increment pop readPtr
//   * decrement pop depth
//   * increment johnson readPtr and sync to PUSH
// create output pop_empty using updated pop depth
assign pop_underflow_nxt   = ( pop & ~clear_pop_state &   pop_empty_f ) ;
assign do_pop              = ( pop & ~clear_pop_state & ~ pop_empty_f ) ;
assign pop_gctr_rptr_incr  = ( do_pop ) ;
assign pop_gctr_wptr_incr  = fifo_enable & ~clear_pop_state & ( pop_gctr_wptr != sync_push_gctr_wptr ) ;
assign pop_rptr_nxt        = ( pop_rptr_f
                             + { {(AWIDTH-1){1'b0}} , do_pop }
                             ) ;
assign pop_depth_nxt       = ( pop_depth_f
                             + { {(DEPTHWIDTH-1){1'b0}} , pop_gctr_wptr_incr }
                             - { {(DEPTHWIDTH-1){1'b0}} , do_pop }
                             ) ;
assign pop_empty_nxt       = ( pop_depth_nxt == {(DEPTHWIDTH){1'b0}} ) ;

//..................................................
//FIFO STATUS
generate
  if ( SYNC_POP == 0 ) begin : Sync_to_clk_push
    logic [ 1 - 1 : 0 ] fifo_status_sync ;
    hqm_AW_sync_rst0 #( .WIDTH ( 1 ) ) i_fifo_status (
      .clk            ( clk_push )
    , .rst_n          ( rst_push_n )
    , .data           ( {  pop_underflow_f } )
    , .data_sync      ( fifo_status_sync )
    );
    assign fifo_status     = { {(32-DEPTHWIDTH-8){1'b0}}
                             , push_depth_f
                             , push_full_f
                             , push_afull_f
                             , push_empty_f
                             , push_empty_f
                             , 2'd0
                             , push_overflow_f
                             , fifo_status_sync [ 0 ]
                             } ;
 end else begin : Sync_to_clk_pop
    logic [ 3 - 1 : 0 ] fifo_status_sync ;
    hqm_AW_sync_rst0 #( .WIDTH ( 3 ) ) i_fifo_status (
      .clk            ( clk_pop ) 
    , .rst_n          ( rst_pop_n )
    , .data           ( { push_full_f , push_afull_f , push_overflow_f } )
    , .data_sync      ( fifo_status_sync )
    );
    assign fifo_status     = { {(32-DEPTHWIDTH-8){1'b0}}
                             , pop_depth_f
                             , fifo_status_sync [ 2 ]
                             , fifo_status_sync [ 1 ]
                             , pop_empty_f
                             , pop_empty_f
                             , 2'd0
                             , fifo_status_sync [ 0 ]
                             , pop_underflow_f
                             } ;
 end
endgenerate

logic unused_nc ;       // avoid lint warning
assign unused_nc        = | cfg_low_wm ;

//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  logic         first_clk_push_occurred;

  // $past produces "x" on first clock, can cause bogus assertion failures where used below
  always_ff @(posedge clk_push or negedge rst_push_n) begin
    if (~rst_push_n) begin
      first_clk_push_occurred <= '0 ;
    end else begin
      first_clk_push_occurred <= '1 ;
    end
  end

  check_underflow: assert property (@( posedge clk_pop ) disable iff ( rst_pop_n !== 1'b1 )
  !( pop_underflow_f ) ) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected !!!\n",$time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_overflow: assert property (@( posedge clk_push ) disable iff ( rst_push_n !== 1'b1 )
  !( push_overflow_f ) ) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected !!!\n",$time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

//can assert in reg test if HWM is configured to zero:   | ( fifo_push_afull & fifo_push_empty )
  check_push_status: assert property (@( posedge clk_push ) disable iff ( rst_push_n !== 1'b1 )
  !( ( fifo_push_full & fifo_push_empty )
   | ( fifo_push_full & ( fifo_push_depth == 1'b0 ) )
   | ( fifo_push_empty & ( fifo_push_depth > 1'b0 ) )
   | ( ~ fifo_push_empty & ( fifo_push_depth == 1'b0 ) )
   ) ) else begin
   $display ("\nERROR: %t: %m: FIFO push status invalid !!!\n",$time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_pop_status: assert property (@( posedge clk_pop ) disable iff ( rst_pop_n !== 1'b1 )
  !( ( fifo_enable & fifo_pop_empty & ( fifo_pop_depth > 1'b0 ) )
   | ( fifo_enable & ~ fifo_pop_empty & ( fifo_pop_depth == 1'b0 ) )
   ) ) else begin
   $display ("\nERROR: %t: %m: FIFO pop status invalid !!!\n",$time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_full2empty: assert property (@( posedge clk_push ) disable iff ( ( rst_push_n !== 1'b1 ) | ( DEPTH == 1 ) )
  !( $past(fifo_push_full,1) & fifo_push_empty & first_clk_push_occurred ) ) else begin
   $display ("\nERROR: %t: %m: FIFO full to empty !!!\n",$time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule
