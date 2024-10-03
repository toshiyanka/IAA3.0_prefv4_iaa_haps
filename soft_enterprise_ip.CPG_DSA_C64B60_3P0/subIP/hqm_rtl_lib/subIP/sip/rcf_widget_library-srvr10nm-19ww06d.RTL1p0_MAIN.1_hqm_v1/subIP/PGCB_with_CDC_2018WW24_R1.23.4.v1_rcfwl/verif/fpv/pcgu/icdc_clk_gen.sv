//--------------------------------------------------------------------------------------//
//    FILENAME        : pcgu_clk_wrapper.sv
//    DESIGNER        : amshah2
//    PROJECT         : PCGU Generic Val RTL Collateral
//    DATE            : 10/21/2013
//    PURPOSE         : Wrapper Design for PCGU FPV
//    REVISION NUMBER : 0.5
//----------------------------- Revision History ---------------------------------------//
//
//      Date        Rev     Owner     Description
//      --------    ---     -----     ---------------------------------------------------
//      10/21/2013  0.51    amshah2   Included the following:
//-------------------------------------------------------------------------------------//
`timescale 1ns/1ns

module icdc_clk_gen #(
        FREQ = 8
       )(
    input  logic  clock,
    input  logic  reset_b,
    output logic  clk_out
    );

    logic[3:0] CCount;
    logic[3:0] DCount;  
    logic      clk;

//RTL CLOCK DIVIDER
//MASTER CLOCK = X PERIOD --> Y PERIOD
//FAST TO SLOW DIVIDER
    always @ (posedge clock or negedge reset_b)
    begin
        if (!reset_b)
        begin
            CCount <= '0;
            DCount <= '0;
            clk    <= '0;
        end 
        else if (CCount != FREQ)
        begin
            CCount <= CCount + 1;
            clk    <= '1;
        end
        else if (DCount != (FREQ-1))
        begin
            DCount <= DCount + 1;
            clk    <= '0;
        end
        else
        begin 
            DCount <= '0;
            CCount <= '0;
        end
    end

    assign clk_out = clk;

endmodule //END ICDC_CLK_GEN
