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
// this is useful for small RAM (a few bits wide) or FLOP RAM storage that require CFG access 
//------------------------------------------------------------------------------------------------------------------------------------------------
//
module hqm_AW_registerram_wtcfg
  import hqm_AW_pkg::*;
#(
  parameter DEPTH = 8
, parameter WIDTH = 8
, parameter DEFAULT = {WIDTH{1'b0}}
, parameter COPY = 1
, parameter CFG_READ_MASK = 0
, parameter WIDTHB2 = ( AW_logb2 ( WIDTH -1 ) + 1 )
 ) (
  input logic clk
, input logic rst_n
, input logic rst_prep
, input logic reg_load
, input logic [( COPY * DEPTH * WIDTH ) -1 : 0] reg_nxt
, output logic [( COPY * DEPTH * WIDTH ) -1 : 0] reg_f
, input logic cfg_write
, input logic cfg_read
, input cfg_req_t cfg_req
, output logic cfg_ack
, output logic cfg_err
, output logic [( 32 ) -1 : 0] cfg_rdata
) ;

generate
  if ( ( WIDTH > 32 ) ) begin : invalid_DEPTH_0
    for ( genvar g = DEPTH ; g <= DEPTH ; g = g + 1 ) begin : invalid_DEPTH_1
      INVALID_PARAM_COMBINATION u_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate

logic [( COPY * DEPTH * WIDTH ) -1 : 0] internal_nxt , internal_f ;
always_ff @( posedge clk or negedge rst_n ) begin 
  if (!rst_n ) begin
    internal_f <= DEFAULT ;
  end
  else begin
    internal_f <= internal_nxt ;
  end
end

always_comb begin : L27

    cfg_ack = '0 ;
    cfg_err = '0 ;
    cfg_rdata = '0 ;

    internal_nxt = internal_f ;

    if ( ( reg_load | cfg_write ) & ~ rst_prep ) begin
      internal_nxt = reg_nxt ;
      if ( cfg_write ) begin
        cfg_ack = 1'b1 ;
        cfg_err = 1'b0 ;
        cfg_rdata = 32'd0 ;
        internal_nxt [ ( cfg_req.addr.offset * WIDTH ) +: WIDTH ] = cfg_req.wdata [ ( WIDTH - 1 ) : 0 ] ; 
        if ( COPY == 2 ) begin
          internal_nxt [ ( ( cfg_req.addr.offset * WIDTH ) + ( DEPTH * WIDTH ) ) +: WIDTH ] = cfg_req.wdata [ ( WIDTH - 1 ) : 0 ] ; 
        end
      end
    end

    reg_f = internal_f ;

    if ( cfg_read ) begin
      cfg_ack = 1'b1 ;
      cfg_err = 1'b0 ;
      cfg_rdata = { {(32-WIDTH){1'b0}} , internal_f [ ( cfg_req.addr.offset * WIDTH ) +: WIDTH ] } & CFG_READ_MASK ; 
    end
end

endmodule
