/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * RandTestbench
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ns
`ifndef ASSERT_ON 
    `define ASSERT_ON
`endif

`define CTECH_LIB_META_DISPLAY 
`define CTECH_LIB_META_ON 
`define CTECH_LIB_ENABLE_3TO1 
//`define CTECH_LIB_PLUS1_ONLY 
//`define CTECH_LIB_MINUS1_ONLY 
//`define CTECH_LIB_PULSE_ON 


module RandTestbench (
	
);

   // Set Max Runtime of 50ms
   initial begin
      #50ms $finish;
   end

    PgdTestbench #(
      .DEF_PWRON(1'b1), 
      .ICDC(1), 
      .NCDC(1)
    ) u_PgdTbDefPowerOn(
    );
    
    PgdTestbench #(
      .DEF_PWRON(1'b0), 
      .ICDC(1), 
      .NCDC(1)
    ) u_PgdTbDefPowerOff(
    );
    
    
endmodule
