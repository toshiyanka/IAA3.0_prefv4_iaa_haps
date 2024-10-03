/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * ClockGenerator
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ps

module ClockGenerator #(
    int     ACKDLY = 1,
    int     ACK2CLKOFF = 8
)(
    input       logic       reset_b,
    input       logic       clkreq,
    input       logic       force_on,
    output      logic       clkack,
    output      logic       clock,
    input       time        tPeriod
);
    logic int_clock, clock_on;
    time tHighTime;
    
    assign tHighTime = tPeriod/2;
    
    initial begin
        int_clock = '0;
        fork
            forever #tPeriod int_clock = '1;
            forever @(posedge int_clock) #tHighTime int_clock = '0;
        join_none
    end
    
    initial begin
        clkack = '0;
        clock_on = '0;
        forever begin
            do @(posedge int_clock);
            while(!reset_b);
            fork
                @(negedge reset_b);
                forever begin
                    if (!clkreq) @(posedge clkreq);
                    repeat (ACKDLY) @(posedge int_clock);
                    clock_on = '1;
                    #1 clkack = '1;
                    @(negedge clkreq);
                    repeat (ACKDLY) @(posedge int_clock);
                    #1 clkack = '0;
                    repeat (ACK2CLKOFF) @(posedge int_clock);
                    clock_on = '0;
                end
            join_any
            disable fork;
        end
    end
    
    assign clock = (clock_on | force_on) & int_clock;
    
endmodule
