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
module hqm_AW_flopfifo
  import hqm_AW_pkg::*;
#(
  parameter DEPTH                                 = 4
, parameter DWIDTH                                = 16
, parameter PUSH                                  = 1
, parameter POP                                   = 1
//..................................................
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1                             = DEPTHB2 + 1
) (
  input  logic                                    clk 
, input  logic                                    rst_n 

, input  logic [ ( PUSH ) - 1 : 0 ]               fifo_push 
, input  logic [ ( PUSH * DWIDTH ) - 1 : 0 ]      fifo_push_data 
, input  logic [ ( POP ) - 1 : 0 ]                fifo_pop 
, output logic [ ( POP ) - 1 : 0 ]                fifo_pop_datav 
, output logic [ ( POP * DWIDTH ) - 1 : 0 ]       fifo_pop_data 
, output logic [ ( DEPTHB2P1 ) - 1 : 0 ]          fifo_size 

, output logic                                    status_idle 
, output logic                                    error 
);

hqm_AW_flopfifo_core #(
  .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
, .PUSH ( PUSH )
, .POP ( POP )
) i_core (
  .clk ( clk )
, .rst_n ( rst_n )
, .fifo_push ( fifo_push )
, .fifo_push_data ( fifo_push_data )
, .fifo_pop ( fifo_pop )
, .fifo_pop_datav ( fifo_pop_datav )
, .fifo_pop_data ( fifo_pop_data )
, .fifo_size ( fifo_size )
, .status_idle ( status_idle )
, .error ( error )
, .fifo_push_id ( '0 )
, .fifo_byp ( '0 )
, .fifo_byp_id ( '0 )
, .fifo_byp_data ( '0 )
) ;

endmodule // hqm_AW_flopfifo
