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
// MODE:0 write all zero to intialize all locations then indicate done
// MODE:1 write all ones to intialize all locations then indicate done
// MODE:2 write increment pattern to intialize all locations then indicate done
// MODE:3 write parameter DEFAULT to intialize all locations then indicate done
// MODE:4 write nothing but still generate done at correct time
// for custom value then add more modes or make a unique copy of this module ex.) hqm_AW_ram_init_<custom#1>
//-----------------------------------------------------------------------------------------------------
module hqm_AW_ram_init #(
  parameter DEPTH = 128
, parameter WIDTH = 0
, parameter MODE = 0
, parameter DEFAULT = 0
//.........................
, parameter DEPTHB2 = ( AW_logb2 ( DEPTH -1 ) + 1 )
) (
  input  logic                         clk
, input  logic                         rst_n

, output logic                         we
, output logic [ ( DEPTHB2 ) - 1 : 0 ] waddr
, output logic [ ( WIDTH ) - 1 : 0 ]   wdata
, output logic                         active
, output logic                         done
) ;

logic [ ( DEPTHB2 ) - 1 : 0 ] cnt_nxt , cnt_f ;
logic done_nxt , done_f ;
always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin 
    cnt_f <= '0 ;
    done_f <= '0 ;
  end else begin
    cnt_f <= cnt_nxt ;
    done_f <= done_nxt ;
  end
end

always_comb begin
  we = '0 ;
  waddr = cnt_f ;
  wdata = '0 ;
  done = done_f ;
  active = ~ done_f ;

  cnt_nxt = cnt_f ;
  done_nxt = done_f ;

  if ( ~ done_f ) begin
    cnt_nxt = cnt_f + { {(DEPTHB2-1){1'b0}} , 1'b1 } ;
    we = 1'b1 ;
    if ( MODE == 0 ) begin wdata = '0 ; end
    if ( MODE == 1 ) begin wdata = '1 ; end
    if ( MODE == 2 ) begin wdata = cnt_f ; end
    if ( MODE == 3 ) begin wdata = DEFAULT ; end
    if ( MODE == 4 ) begin we = 1'b0 ; end
  end
  if ( cnt_nxt == DEPTH ) begin
    done_nxt = 1'b1 ;
  end
end

endmodule
