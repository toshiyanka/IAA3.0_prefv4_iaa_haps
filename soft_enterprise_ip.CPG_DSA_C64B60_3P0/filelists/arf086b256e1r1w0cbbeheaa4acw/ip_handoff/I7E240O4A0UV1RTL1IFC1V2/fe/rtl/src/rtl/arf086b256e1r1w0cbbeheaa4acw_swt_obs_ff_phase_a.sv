//----------------------------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------------------------------
`ifndef ARF086B256E1R1W0CBBEHEAA4ACW_SWT_OBS_FF_PHASE_A_SV
`define ARF086B256E1R1W0CBBEHEAA4ACW_SWT_OBS_FF_PHASE_A_SV

/*
#
#  THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH
#  IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS
#  SUBJECT TO LICENSE TERMS.
#
#  Copyright 1992-2011 Mentor Graphics Corporation
#
#  All Rights Reserved.
#
#  Technology Release: v9.3
*/

/* ------------------------------------------------------------------------------
  Module       : SWT_OBS_generic
  Description  : This is a generic module description that provides observation
                 flops for the address and control signals used by a memory with
                 Scan Write-Thru.
                 When instantiating this module concatenate the address and
                 control signals together to drive the 'in' port. The following
                 table shows the ports on the SWT_generic_xxx module that should
                 be observed.

                 Port Function    | Ports to observe on SWT_generic_xxx
                 -----------------+------------------------------------
                 Address          | ADDR_toMem, ADDR#_toMem
                 WriteEnable      | WE, WE#
                 GroupWriteEnable | WE, WE#
                 ReadEnable       | RE, RE#
                 OutputEnable     | OE, OE#
                 Select           | CS, CS#

  Synthesis    : When you synthesize your design it is recommended that you use
                 the analyze and elaborate commands for reading in your Verilog
                 files in Design Compiler. Using the read_verilog command to
                 build a design with parameters is not recommended because you
                 can build a design only with the default value of the parameters.

                 Also, design boundary optimization in your synthesis script
                 should be disabled until scan insertion has been performed.

  Parameters   : 
                 OBS_PIN_NUM - The sum of bus widths for all control and address
                 signals listed in the table above.
                 OBS_XOR_SIZE - The number of inputs to be combinded per XOR gate.
                 Defaults to 3.
                 OBS_FLOP_NUM - Number of observation flops that will be created.
                 By default, this port will sized according to the values
                 specified by OBS_PIN_NUM and OBS_XOR_SIZE.
  ------------------------------------------------------------------------------
  Instantiation template :
    SWT_OBS_generic
    #(
      .OBS_PIN_NUM   (#),
      .OBS_XOR_SIZE  (#)
    )
    <instance> (
      .clock  ( <memPortClock>            ) , // i
      .in     ( {ADDR_toMem, OE, WE, ...} ) , // i [OBS_PIN_NUM-1:0]
      .out    (                           )   // o [OBS_FLOP_NUM-1:0]
    );
*/

// SWT_OBS_generic modified for a phase array operation
module arf086b256e1r1w0cbbeheaa4acw_swt_obs_ff_phase_a #
(
  parameter OBS_PIN_NUM  = 1,
  parameter OBS_XOR_SIZE = 3,
  parameter OBS_FLOP_NUM = ( OBS_PIN_NUM / OBS_XOR_SIZE ) + int'( ( OBS_PIN_NUM % OBS_XOR_SIZE ) > 0 )
)
(
  input   logic                        clock,
  input   logic    [OBS_PIN_NUM-1:0]   in,
  output  logic    [OBS_FLOP_NUM-1:0]  out
);

reg   [OBS_FLOP_NUM-1:0]  ObsFlops;
wire  [OBS_FLOP_NUM-1:0]  ObsWires;

assign out = ObsFlops;

genvar i;
generate
  for (i = 0; i < OBS_FLOP_NUM; i = i+1) begin : ObsAssign
    if (i < (OBS_FLOP_NUM - 1))
    begin
      assign ObsWires[i] = ^ in[i*OBS_XOR_SIZE + OBS_XOR_SIZE-1 : i*OBS_XOR_SIZE];
    end
    else 
    begin
       assign ObsWires[i] = ^ in[OBS_PIN_NUM-1 : i*OBS_XOR_SIZE];
    end
  end

  always_ff @ (posedge clock)
  begin
    ObsFlops <= ObsWires;
  end
endgenerate

endmodule // arf086b256e1r1w0cbbeheaa4acw_swt_obs_ff_phase_a

`endif // ARF086B256E1R1W0CBBEHEAA4ACW_SWT_OBS_FF_PHASE_A_SV