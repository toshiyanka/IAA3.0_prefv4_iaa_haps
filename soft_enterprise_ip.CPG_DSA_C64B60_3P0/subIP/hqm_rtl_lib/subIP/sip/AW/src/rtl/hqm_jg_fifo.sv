//
// common design to be used in assertion code
//
//--------------------------------------------------
module hqm_jg_fifo
 import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
//...............................................................................................................................................
, parameter DEPTHB2 = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1 = DEPTHB2 + 1
) (
input logic clk
, input logic rst_n
, output logic empty
, output logic full
, input logic push
, input logic [ ( DWIDTH ) - 1 : 0 ] push_data
, input logic pop
, output logic [ ( DWIDTH ) - 1 : 0 ] pop_data
);

logic fifo_pop_datav ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] fifo_size ;
logic fifo_status_idle ;
logic fifo_error ;
logic fifo_push_id ;
logic fifo_byp ;
logic fifo_byp_id ;
logic [ ( DWIDTH ) - 1 : 0 ] fifo_byp_data ;
hqm_AW_flopfifo_core #(
  .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
, .IDV ( 0 )
, .IDWIDTH ( 1 )
) i_fifo (
  .clk ( clk )
, .rst_n ( rst_n )
, .fifo_push ( push )
, .fifo_push_data ( push_data )
, .fifo_pop ( pop )
, .fifo_pop_datav ( fifo_pop_datav )
, .fifo_pop_data (  pop_data )
, .fifo_size ( fifo_size )
, .status_idle ( fifo_status_idle )
, .error ( fifo_error )
, .fifo_push_id ( fifo_push_id )
, .fifo_byp ( fifo_byp )
, .fifo_byp_id ( fifo_byp_id )
, .fifo_byp_data ( fifo_byp_data )
) ;

assign full = ( fifo_size == DEPTH ) ;
assign empty = ~ fifo_pop_datav ;
assign fifo_push_id = '0 ;
assign fifo_byp = '0 ;
assign fifo_byp_id = '0 ;
assign fifo_byp_data = '0 ;
//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  jg_fifo__check_fifo: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( fifo_error ) ) else begin
   $display ("\nERROR: %t: %m: jg_fifo error detected : fifo_error !!!\n",$time ) ;
  end
`endif

endmodule
