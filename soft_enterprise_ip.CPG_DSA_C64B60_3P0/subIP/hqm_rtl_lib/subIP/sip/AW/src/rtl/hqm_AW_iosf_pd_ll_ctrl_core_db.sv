//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------

module hqm_AW_iosf_pd_ll_ctrl_core_db
import hqm_AW_pkg::*; 
#(
  parameter DWIDTH                                = 32
) (
  input  logic                                    clk
, input  logic                                    rst_n
, output logic [ 1 : 0 ]                          status
, input  logic                                    in_push
, input  logic [ ( DWIDTH ) - 1 : 0 ]             in_data
, input  logic                                    in_push_2
, input  logic [ ( DWIDTH ) - 1 : 0 ]             in_data_2
, input  logic                                    out_pop
, output logic [ ( DWIDTH ) - 1 : 0 ]             out_data
, output logic                                    db_error
);

logic [ ( 2 ) - 1 : 0 ] depth_nxt , depth_f ;
logic [ ( 1 ) - 1 : 0 ] wp_f , wp_nxt , wpp1 , wpp2;
logic [ ( 1 ) - 1 : 0 ] rp_f , rp_nxt , rpp1 ;
logic [ ( DWIDTH ) - 1 : 0 ] data_f [ 1 : 0 ] ;
logic [ ( DWIDTH ) - 1 : 0 ] data_nxt [ 1 : 0 ] ;

always_ff @ ( posedge clk or negedge rst_n ) begin
 if (~rst_n) begin
  depth_f <= '0 ;
  wp_f <= '0 ;
  rp_f <= '0 ;
 end else begin
  depth_f <= depth_nxt ;
  wp_f <= wp_nxt ;
  rp_f <= rp_nxt ;
 end
end
always_ff @ ( posedge clk ) begin
  data_f [ 0 ] <= data_nxt [ 0 ] ;
  data_f [ 1 ] <= data_nxt [ 1 ] ;
end

always_comb begin
 status = depth_f ;
 depth_nxt = depth_f + {1'b0,in_push} + {1'b0,in_push_2} - {1'b0,out_pop} ;

 rp_nxt = rp_f ;
 wp_nxt = wp_f ; 
 rpp1 = rp_f + out_pop ;
 wpp1 = wp_f + in_push ;
 wpp2 = wp_f ;
 data_nxt [ 0 ] = data_f [ 0 ] ; 
 data_nxt [ 1 ] = data_f [ 1 ] ; 
 if ( in_push ) begin 
   wp_nxt = wpp1 ;
   data_nxt [ wp_f ] = in_data ;
 end
 if ( in_push_2 ) begin 
   wp_nxt = wpp2 ;
   data_nxt [ ~ wp_f ] = in_data_2 ;
 end

 if ( out_pop ) begin 
   rp_nxt = rpp1 ;
 end
 out_data = data_f [ rp_f ] ;
 db_error = ( depth_f == 2'd3 ) ;
end

endmodule

