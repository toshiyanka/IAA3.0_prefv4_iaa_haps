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
// if POP>1 then need to use fifo_pop_datav[0] first, then fifo_pop_datav[1] ...
//
//-----------------------------------------------------------------------------------------------------
module hqm_jg_addrdata_fifo
  import hqm_AW_pkg::*;
#(
  parameter DEPTH_ADDR                                 = 8 
, parameter DWIDTH_ADDR                                = 20
, parameter DEPTH_DATA                                 = 16
, parameter DWIDTH_DATA                                = 100
, parameter BEAT_DATA                                  = 2
, parameter DWIDTH_ID                                  = 2 * ( ( AW_logb2 ( DEPTH_ADDR - 1 ) + 1 ) + ( AW_logb2 ( DEPTH_DATA - 1 ) + 1 ) )
, parameter PROTOCOL                                   = 0
//..................................................
, parameter DEPTH_ADDRB2                               = ( AW_logb2 ( DEPTH_ADDR - 1 ) + 1 )
, parameter DEPTH_DATAB2                               = ( AW_logb2 ( DEPTH_DATA - 1 ) + 1 )
) (
  input  logic                                         clk 
, input  logic                                         rst_n 

, output logic                                         full

, input  logic                                         fifo_addr_push 
, input  logic [ ( DWIDTH_ADDR ) - 1 : 0 ]             fifo_addr_push_data 
, input  logic [ ( BEAT_DATA ) - 1 : 0 ]               fifo_data_push     
, input  logic [ ( BEAT_DATA * DWIDTH_DATA ) - 1 : 0 ] fifo_data_push_data

, input  logic                                         fifo_addr_pop 
, output logic                                         fifo_addr_pop_datav 
, output logic [ ( DWIDTH_ADDR ) - 1 : 0 ]             fifo_addr_pop_data 
, input  logic                                         fifo_data_pop                
, output logic                                         fifo_data_pop_datav                
, output logic [ ( DWIDTH_DATA ) - 1 : 0 ]             fifo_data_pop_data

);

logic [ ( DWIDTH_ID ) - 1 : 0 ] in_id_f , in_id_nxt , out_id_f , out_id_nxt ;
logic fifo_addr_pop_f , fifo_addr_pop_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    in_id_f <= '0 ;
    out_id_f <= '0 ;
    fifo_addr_pop_f <= '0 ;
  end
  else begin
    in_id_f <= in_id_nxt ;
    out_id_f <= out_id_nxt ;
    fifo_addr_pop_f <= fifo_addr_pop_nxt ;
  end
end
assign fifo_addr_pop_nxt = fifo_addr_pop ? 1'b1 : fifo_addr_pop_f ;

logic wire_fifo_addr_push ;
logic [ ( DWIDTH_ADDR + DWIDTH_ID ) - 1 : 0 ] wire_fifo_addr_push_data ;
logic wire_fifo_addr_pop ;
logic wire_fifo_addr_pop_datav ;
logic [ ( DWIDTH_ADDR + DWIDTH_ID ) - 1 : 0 ] wire_fifo_addr_pop_data ;
logic [ ( DWIDTH_ADDR ) - 1 : 0 ] wire_fifo_addr_pop_data_data ;
logic [ ( DWIDTH_ID ) - 1 : 0 ] wire_fifo_addr_pop_data_id ;
logic [ ( DEPTH_ADDRB2+1 ) - 1 : 0 ] wire_fifo_addr_size ;
logic wire_fifo_addr_error ;
hqm_AW_flopfifo_core #(
  .DEPTH ( DEPTH_ADDR )
, .DWIDTH ( DWIDTH_ADDR + DWIDTH_ID )
, .PUSH ( 1 )
, .POP ( 1 )
) i_addr (
  .clk ( clk )
, .rst_n ( rst_n )
, .fifo_push ( wire_fifo_addr_push )
, .fifo_push_data ( wire_fifo_addr_push_data )
, .fifo_pop ( wire_fifo_addr_pop )
, .fifo_pop_datav ( wire_fifo_addr_pop_datav )
, .fifo_pop_data ( wire_fifo_addr_pop_data )
, .fifo_size ( wire_fifo_addr_size )
, .status_idle (  )
, .error ( wire_fifo_addr_error )
, .fifo_push_id ( '0 )
, .fifo_byp ( '0 )
, .fifo_byp_id ( '0 )
, .fifo_byp_data ( '0 )
) ;

logic [ ( BEAT_DATA ) - 1 : 0 ] wire_fifo_data_push ;
logic [ ( BEAT_DATA * ( DWIDTH_DATA + DWIDTH_ID ) ) - 1 : 0 ] wire_fifo_data_push_data ;
logic wire_fifo_data_pop ;
logic wire_fifo_data_pop_datav ;
logic [ ( DWIDTH_DATA + DWIDTH_ID ) - 1 : 0 ] wire_fifo_data_pop_data ;
logic [ ( DWIDTH_DATA ) - 1 : 0 ] wire_fifo_data_pop_data_id ;
logic [ ( DWIDTH_ID ) - 1 : 0 ] wire_fifo_data_pop_data_data ;
logic [ ( DEPTH_DATAB2+1 ) - 1 : 0 ] wire_fifo_data_size ;
logic wire_fifo_data_error ;
hqm_AW_flopfifo_core #(
  .DEPTH ( DEPTH_DATA )
, .DWIDTH ( DWIDTH_DATA + DWIDTH_ID )
, .PUSH ( BEAT_DATA )
, .POP ( 1 )
) i_data ( 
  .clk ( clk )
, .rst_n ( rst_n )
, .fifo_push ( wire_fifo_data_push )
, .fifo_push_data ( wire_fifo_data_push_data )
, .fifo_pop ( wire_fifo_data_pop )
, .fifo_pop_datav ( wire_fifo_data_pop_datav )
, .fifo_pop_data ( wire_fifo_data_pop_data )
, .fifo_size ( wire_fifo_data_size )
, .status_idle (  )
, .error ( wire_fifo_data_error )
, .fifo_push_id ( '0 )
, .fifo_byp ( '0 )
, .fifo_byp_id ( '0 )
, .fifo_byp_data ( '0 )
) ;

always_comb begin

  //send full indication to stop sending addr and data channel
  full                     = ( ( wire_fifo_addr_size == DEPTH_ADDR ) 
                             | ( wire_fifo_data_size == DEPTH_DATA )
                             ) ;

  //Address channel FIFO PUSH
  wire_fifo_addr_push      = fifo_addr_push ;
  in_id_nxt                = fifo_addr_push ? ( in_id_f + 1'b1 ) : in_id_f ;
  wire_fifo_addr_push_data = { in_id_nxt , fifo_addr_push_data } ;

  //data channel FIFO PUSH (multiple beats)
  wire_fifo_data_push      = fifo_data_push ;
  wire_fifo_data_push_data = { BEAT_DATA { in_id_nxt , fifo_addr_push_data } } ;


  //Address channel FIFO POP
  { wire_fifo_addr_pop_data_id
  , wire_fifo_addr_pop_data_data
  }                        = wire_fifo_addr_pop_data ;
  fifo_addr_pop_datav      = wire_fifo_addr_pop_datav ;
  fifo_addr_pop_data       = wire_fifo_addr_pop_data_data ;
  wire_fifo_addr_pop       = fifo_addr_pop ;
  out_id_nxt               = fifo_addr_pop ? ( wire_fifo_addr_pop_data_id ) : out_id_f ;

  //data channel FIFO POP
  { wire_fifo_data_pop_data_id
  , wire_fifo_data_pop_data_data
  }                        = wire_fifo_data_pop_data ;
  wire_fifo_data_pop       = fifo_data_pop ;

  fifo_data_pop_datav = '0 ;
// PRIM ORDER
// issue addr first and then issue data beats starting the next cycle
if ( PROTOCOL == 0 ) begin
  fifo_data_pop_datav      = ( wire_fifo_data_pop_datav 
                             & fifo_addr_pop_f
                             & ( wire_fifo_data_pop_data_id <= out_id_f )
                             ) ;
end

//AXI ORDER  
//data & addr can be issued in any order
if ( PROTOCOL == 1 ) begin
  fifo_data_pop_datav      = ( wire_fifo_data_pop_datav
                             ) ;
end

//AXI ORDER  addrress channel dominant
//data & addr for a single transaction be issued in any order, dont allow data transfer to get ahead of current address 
if ( PROTOCOL == 2 ) begin    
  fifo_data_pop_datav      = ( wire_fifo_data_pop_datav
                             & ( wire_fifo_data_pop_data_id <= wire_fifo_addr_pop_data_id )
                             ) ;
end



//SYSTEM pdata/phdr ORDER
//  2 beat : D0 then H+D1
//  1 beat : H+D0
if ( PROTOCOL == 3 ) begin

  if ( wire_fifo_addr_pop_datav
     & wire_fifo_data_pop_datav
     & ( ~ wire_fifo_data_pop_data_data [264] ) //eop
     ) begin
    fifo_addr_pop_datav = 1'b0 ;
    fifo_data_pop_datav = 1'b1 ; 
  end

  if ( wire_fifo_addr_pop_datav
     & wire_fifo_data_pop_datav
     & (   wire_fifo_data_pop_data_data [264] ) //eop
     ) begin
    fifo_addr_pop_datav = 1'b1 ;
    fifo_data_pop_datav = 1'b1 ;
  end

end



  fifo_data_pop_data       = wire_fifo_data_pop_data_data ;





end
//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  jg_addrdata_fifo__check_fifo_addr : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | wire_fifo_addr_error ) ) else begin
   $display ("\nERROR: %t: %m: jg_addrdata_fifo error detected : wire_fifo_addr_error !!!\n",$time ) ;
  end
  jg_addrdata_fifo__check_fifo_data : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | wire_fifo_data_error ) ) else begin
   $display ("\nERROR: %t: %m: jg_addrdata_fifo error detected : wire_fifo_data_error !!!\n",$time ) ;
  end
`endif

endmodule // hqm_AW_flopfifo
