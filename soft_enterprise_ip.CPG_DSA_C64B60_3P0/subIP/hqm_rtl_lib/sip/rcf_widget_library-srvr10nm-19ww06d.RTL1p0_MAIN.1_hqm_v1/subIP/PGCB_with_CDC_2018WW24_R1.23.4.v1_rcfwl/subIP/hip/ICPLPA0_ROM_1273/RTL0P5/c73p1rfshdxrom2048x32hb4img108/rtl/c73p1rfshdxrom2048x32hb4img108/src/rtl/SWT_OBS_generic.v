// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature 5ffe3708491c8a8a3795a2e6daf855f0ea08c032 % Version r1.0.0_m1.18 % _View_Id v % Date_Time 20160216_100947 
/*
#
#   THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH
#   IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS
#   SUBJECT TO LICENSE TERMS.
#
#   Copyright 1992-2010 Mentor Graphics Corporation
#
#   All Rights Reserved.
#
#   Technology Release: v9.2
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
                   Address          |  ADDR_toMem, ADDR#_toMem
                   WriteEnable      |  WE, WE#
                   GroupWriteEnable |  WE, WE#
                   ReadEnable       |  RE, RE#
                   OutputEnable     |  OE, OE#
                   Select           |  CS, CS#

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
            .Clock         ( <memPortClock>              ) , // i
            .In            ( {ADDR_toMem, OE, WE, ...}   ) , // i [OBS_PIN_NUM-1:0]
            .Out           (                             )   // o [OBS_FLOP_NUM-1:0]
        );
*/

module SWT_OBS_generic
#(
    parameter OBS_PIN_NUM  = 1,
    parameter OBS_XOR_SIZE = 3,
    parameter OBS_FLOP_NUM = ( OBS_PIN_NUM / OBS_XOR_SIZE ) + ( ( OBS_PIN_NUM % OBS_XOR_SIZE ) > 0 )
)
(
    input                       Clock,
    input   [OBS_PIN_NUM-1:0]   In,
    output  [OBS_FLOP_NUM-1:0]     Out
);

reg    [OBS_FLOP_NUM-1:0]          ObsFlops;
wire   [OBS_FLOP_NUM-1:0]          ObsWires;

assign Out = ObsFlops;
genvar i;
generate
    for (i = 0; i < OBS_FLOP_NUM; i = i+1) begin : ObsAssign
        if (i < OBS_FLOP_NUM - 1) begin
            assign ObsWires[i] = ^ In[i*OBS_XOR_SIZE + OBS_XOR_SIZE-1 : i*OBS_XOR_SIZE];
        end else begin
            assign ObsWires[i] = ^ In[OBS_PIN_NUM-1 : i*OBS_XOR_SIZE];
        end
    end
    always @ (posedge Clock) begin
        ObsFlops <= ObsWires;
    end
endgenerate

endmodule
