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
// AW_fifo_control_wreg_wcredit_wtcfg
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// wrap AW_fifo_control standard FIFO controller 
// ADDITIONS:
//   add flop output stage to isolate RAM output timing
//     NOTE: this has 2 targets & not 1 shared target
//   add parity protection for high watermark
//     reconfigure to default when parity error detected
//   add credit interface, support FIFO credit allocate and deallocate which are independant from push/pop
//     specify NUM_ALLOC alloccate requestors : consume a credit
//     specify NUM_DEALLOC deallocate reqeustors : return a credit
//
//
//      USAGE: use ~alloc_afull to determine if FIFO has space.
//             issue alloc to comsume a credit & a FIFO storage location
//             if request is dropped BEFORE push then issue dealloc to return the credit
//             issue push to store data into FIFO when it is avaible
//             use pop_data_v to know when FIFO can be popped
//             issue pop to consume the FIFO data
//             issue dealloc to return the credit. THe dealloc can/should be issued on the same clock as the pop.
//
//      ERROR:
//      [3]:                    FIFO overflow
//      [2]:                    FIFO underflow
//      [1]:                    credit error
//      [0]:                    parity error
//
//      cfg target[0] read-write credit high watermark (default is DEFAULT_HWM )
//      [7:0]:                  HWM for credit limit. NOTE:0 provides 0 credits and will hang
//
//      cfg target[1] read-only STATUS:
//      [31-13]:                CREDIT size
//      [12]:                   CREDIT full
//      [11]:                   CREDIT almost full
//      [10]:                   Rsvd
//      [9]:                    CREDIT empty 
//      [8]:                    CREDIT error
//      [7]:                    FIFO full         (FIFO depth == FIFO size)
//      [6]:                    Rsvd
//      [5]:                    Rsvd
//      [4]:                    FIFO empty        (FIFO depth == 0)
//      [3]:                    Rsvd
//      [2]:                    parity error 
//      [1]:                    FIFO overflow     (push while FIFO full)
//      [0]:                    FIFO underflow    (pop  while FIFO empty)
//
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_wreg_wcrd
import hqm_AW_pkg::* ;
# (
  parameter DEPTH                          = 8
, parameter DWIDTH                         = 16
, parameter NUM_ALLOC                      = 1
, parameter NUM_DEALLOC                    = 1
, parameter DEFAULT_HWM                    = 1
//...............................................................................................................................................
, parameter DEPTHB2                        = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHWIDTH                     = ( AW_logb2 ( DEPTH     ) + 1 )
, parameter WMWIDTH                        = ( AW_logb2 ( DEPTH + 1 ) + 1 )
, parameter NUM_ALLOCB2                    = ( AW_logb2 ( NUM_ALLOC - 1 ) + 1 )
, parameter NUM_DEALLOCB2                  = ( AW_logb2 ( NUM_DEALLOC - 1 ) + 1 )
, parameter DEFAULT_HWM_PAR                = 1 ^ DEFAULT_HWM [7] ^ DEFAULT_HWM [6] ^ DEFAULT_HWM [5] ^ DEFAULT_HWM [4] ^ DEFAULT_HWM [3] ^ DEFAULT_HWM [2] ^ DEFAULT_HWM [1] ^ DEFAULT_HWM [0]
) (
  input  logic                             clk
, input  logic                             rst_n

, input  logic                             push
, input  logic [ ( DWIDTH ) - 1 : 0 ]      push_data
, input  logic                             pop
, output logic                             pop_data_v
, output logic [ ( DWIDTH ) - 1 : 0 ]      pop_data

, input  logic [ ( NUM_ALLOC ) - 1 : 0 ]   alloc
, input  logic [ ( NUM_DEALLOC ) - 1 : 0 ] dealloc
, output logic                             alloc_empty
, output logic                             alloc_full
, output logic                             alloc_afull
, output logic [ ( WMWIDTH ) - 1 : 0 ]     alloc_size

, input  logic [ ( WMWIDTH ) - 1 : 0 ]     cfg_hwm
, output logic [ ( 32 ) - 1 : 0 ]          status
, output logic [ ( 3 ) - 1 : 0 ]           error

, output logic                             mem_we
, output logic [ ( DEPTHB2 ) - 1 : 0 ]     mem_waddr
, output logic [ ( DWIDTH ) - 1 : 0 ]      mem_wdata
, output logic                             mem_re
, output logic [ ( DEPTHB2 ) - 1 : 0 ]     mem_raddr
, input  logic [ ( DWIDTH ) - 1 : 0 ]      mem_rdata
);


logic alloc_error ;
hqm_AW_control_credits #(
  .DEPTH ( DEPTH )
, .NUM_A ( NUM_ALLOC )
, .NUM_D ( NUM_DEALLOC + 1 )
) i_hqm_AW_control_credits (
  .clk ( clk )
, .rst_n ( rst_n )
, .alloc ( alloc )
, .dealloc ( { pop , dealloc } )
, .empty ( alloc_empty )
, .full ( alloc_full )
, .size ( alloc_size )
, .error ( alloc_error )
, .hwm ( cfg_hwm )
, .afull ( alloc_afull )
);

logic [ ( 32 ) - 1 : 0 ] fifo_status ;
hqm_AW_fifo_control_wreg #(
  .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
) i_hqm_AW_fifo_control_wreg (
  .clk ( clk )
, .rst_n ( rst_n )
, .push ( push )
, .push_data ( push_data )
, .pop ( pop )
, .pop_data_v ( pop_data_v )
, .pop_data ( pop_data )
, .cfg_high_wm ( DEPTH )
, .mem_we ( mem_we )
, .mem_waddr ( mem_waddr )
, .mem_wdata ( mem_wdata )
, .mem_re ( mem_re )
, .mem_raddr ( mem_raddr )
, .mem_rdata ( mem_rdata )
, .fifo_status ( fifo_status )
, .fifo_full ( )
, .fifo_afull ( )
);


assign status = { { ( 32 - WMWIDTH - 13 ) { 1'b0 } }
                  , alloc_size
                  , alloc_full
                  , 1'b0
                  , 1'b0
                  , alloc_empty
                  , alloc_error
                  , fifo_status [ 7 : 3 ]
                  , 1'b0
                  , fifo_status [ 1 : 0 ]
                } ;

assign error = {
                 fifo_status [ 1 ]
               , fifo_status [ 0 ]
               , ( alloc_error | ( fifo_status [ 31 : 8 ] > { {(24-WMWIDTH){1'b0}} ,  alloc_size } ) )
               } ;

endmodule
