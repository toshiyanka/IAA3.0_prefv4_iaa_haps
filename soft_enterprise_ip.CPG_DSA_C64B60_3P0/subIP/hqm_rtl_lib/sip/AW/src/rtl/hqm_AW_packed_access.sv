//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// need to read before writing the packed RAM, data stored locally with required bypass conditions
//   does not support write on same clock read data is returned, assume ATLEAST 1 clock to capture RAM output
// only support packed depth < unpacked depth
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_packed_access #(
  parameter UDEPTH = 128
, parameter UWIDTH = 4
, parameter PDEPTH = 32
, parameter NUM_STAGES = 3
, parameter BLOCK_READ_ON_BYPASS = 0
//.........................
, parameter SCALE = ( UDEPTH / PDEPTH )
, parameter PWIDTH = UWIDTH * SCALE
, parameter UDEPTHB2 = ( AW_logb2 ( UDEPTH -1 ) + 1 )
, parameter PDEPTHB2 = ( AW_logb2 ( PDEPTH -1 ) + 1 )
, parameter SCALEB2 = ( AW_logb2 ( SCALE -1 ) + 1 )
, parameter SCALEB2M1 = SCALEB2 - 1
) (
  input  logic clk
, input  logic rst_n


TO be efficient need to check & strip SER from unpacked & regenerate on packed (same on return path)
  except mabye really big RAMs, 16kb+

, input  logic                                    unpacked_mem_re
, input  logic [ ( UDEPTHB2 ) - 1 : 0 ]           unpacked_mem_raddr
, output logic [ ( UWIDTH ) - 1 : 0 ]             unpacked_mem_rdata
, input  logic                                    unpacked_mem_we
, input  logic [ ( UDEPTHB2 ) - 1 : 0 ]           unpacked_mem_waddr
, input  logic [ ( UWIDTH ) - 1 : 0 ]             unpacked_mem_wdata

, output logic                                    packed_mem_re
, output logic [ ( PDEPTHB2 ) - 1 : 0 ]           packed_mem_raddr
, input  logic [ ( PWIDTH ) - 1 : 0 ]             packed_mem_rdata
, output logic                                    packed_mem_we
, output logic [ ( PDEPTHB2 ) - 1 : 0 ]           packed_mem_waddr
, output logic [ ( PWIDTH ) - 1 : 0 ]             packed_mem_wdata
) ;

localparam FIFO_DEPTH = NUM_STAGES ;
localparam FIFO_DWIDTH = PWIDTH ;
localparam FIFO_IDV = 1 ;
localparam FIFO_IDWIDTH = PDEPTHB2 ;
localparam FIFO_DEPTHB2 = ( AW_logb2 ( FIFO_DEPTH - 1 ) + 1 ) ;
localparam FIFO_DEPTHB2P1 = FIFO_DEPTHB2 + 1
logic fifo_push ;
logic [ ( FIFO_DWIDTH ) - 1 : 0 ] fifo_push_data ;
logic fifo_pop ;
logic fifo_pop_datav ;
logic [ ( FIFO_DWIDTH ) - 1 : 0 ] fifo_pop_data ;
logic [ ( FIFO_DEPTHB2P1 ) - 1 : 0 ] fifo_size ;
logic fifo_status_idle ;
logic fifo_error ;
logic [ ( FIFO_IDWIDTH ) - 1 : 0 ] fifo_push_id ;
logic fifo_byp ;
logic [ ( FIFO_IDWIDTH ) - 1 : 0 ] fifo_byp_id ;
logic [ ( FIFO_DWIDTH ) - 1 : 0 ] fifo_byp_data ;
hqm_AW_flopfifo_core #(
, .DEPTH ( FIFO_DEPTH )
, .DWIDTH ( FIFO_DWIDTH )
, .PUSH ( 1 )
, .IDV ( FIFO_IDV )
, .IDWIDTH ( FIFO_IDWIDTH )
) i_fifo (
  .clk ( clk )
, .rst_n ( rst_n )
, .fifo_push ( fifo_push )
, .fifo_push_data ( fifo_push_data )
, .fifo_pop ( fifo_pop )
, .fifo_pop_datav ( fifo_pop_datav )
, .fifo_pop_data ( fifo_pop_data )
, .fifo_size ( fifo_size )
, .status_idle ( fifo_status_idle )
, .error ( fifo_error )
, .fifo_push_id ( fifo_push_id )
, .fifo_byp ( fifo_byp )
, .fifo_byp_id ( fifo_byp_id )
, .fifo_byp_data ( fifo_byp_data )
) ;

logic [ ( UDEPTHB2 ) - 1 : 0 ] unpacked_mem_raddr_f ;
logic packed_mem_re_f ;
logic [ ( PDEPTHB2 ) - 1 : 0 ] packed_mem_raddr_f ;
logic packed_mem_re_byp_f , packed_mem_re_byp_nxt ;
logic [ ( PWIDTH ) - 1 : 0 ] packed_mem_rdata_byp_f ;
always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin 
    unpacked_mem_raddr_f <= '0 ;
    packed_mem_re_f <= '0 ;
    packed_mem_raddr_f <= '0 ;
    packed_mem_re_byp_f <= '0 ;
    packed_mem_rdata_byp_f <= '0 ;
  end else begin
    unpacked_mem_raddr_f <= unpacked_mem_raddr ;
    packed_mem_re_f <= packed_mem_re ;
    packed_mem_raddr_f <= packed_mem_raddr ;
    packed_mem_re_byp_f <= packed_mem_re_byp_nxt ;
    packed_mem_rdata_byp_f <= packed_mem_wdata ;
  end
end

logic [ ( UDEPTHB2 ) - 1 : 0 ] unpacked_mem_raddr_shift ;
assign unpacked_mem_raddr_shift = ( unpacked_mem_raddr >> SCALEB2 ) ;
hqm_AW_width_scale #(
  .A_WIDTH( UDEPTHB2 )
, .Z_WIDTH( PDEPTHB2 )
 ) i_packed_mem_raddr (
  .a ( unpacked_mem_raddr_shift )
, .z ( packed_mem_raddr )
);

logic [ ( UDEPTHB2 ) - 1 : 0 ] unpacked_mem_waddr_shift ;
assign unpacked_mem_waddr_shift = ( unpacked_mem_waddr >> SCALEB2 ) ;
hqm_AW_width_scale #(
  .A_WIDTH( UDEPTHB2 )
, .Z_WIDTH( PDEPTHB2 )
 ) i_packed_mem_waddr (
  .a ( unpacked_mem_waddr_shift )
, .z ( packed_mem_waddr )
);

logic [ ( SCALEB2 ) - 1 : 0 ] waddr_index ;
logic [ ( SCALEB2 ) - 1 : 0 ] raddr_index ;
always_comb begin

  //detect read & write to same location and bypass write data
  packed_mem_re_byp_nxt = '0 ;
  packed_mem_re = unpacked_mem_re ;
  if ( packed_mem_re & packed_mem_we & ( packed_mem_raddr == packed_mem_waddr ) ) begin
    packed_mem_re_byp_nxt = 1'b1 ;
    if ( BLOCK_READ_ON_BYPASS ) begin packed_mem_re = 1'b0 ; end
  end

  // process read return or read bypass, push into FIFO
  raddr_index = unpacked_mem_raddr_f [ 0 +: SCALEB2 ] ;
  unpacked_mem_rdata = packed_mem_rdata [ ( raddr_index * UWIDTH ) +: UWIDTH ] ;
  fifo_push = packed_mem_re_f | packed_mem_re_byp_f ;
  fifo_push_id = packed_mem_raddr_f ;
  fifo_push_data = '0 ;
  if ( packed_mem_re_byp_f ) begin
    fifo_push_data = packed_mem_rdata_byp_f ;
  end else begin
    fifo_push_data = packed_mem_rdata ;
  end

  //use fifo bypass to update any stale entries
  fifo_byp = packed_mem_we ;
  fifo_byp_id = packed_mem_waddr ;
  fifo_byp_data = packed_mem_wdata ;

  //when write is issued (in order), use the fifo output to retain non modified data and write new data then pop the RMW value from the fifo 
  fifo_pop = unpacked_mem_we ;
  packed_mem_we = unpacked_mem_we ;
  packed_mem_wdata = fifo_pop_data ;
  waddr_index = unpacked_mem_waddr [ 0 +: SCALEB2 ] ;
  packed_mem_wdata [ ( waddr_index * UWIDTH ) +: UWIDTH ] = unpacked_mem_wdata ;
end

endmodule
