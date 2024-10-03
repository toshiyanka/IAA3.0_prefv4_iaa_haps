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

module pcgu_clk_gen #(
        FREQ = 8 
       )(
    input  logic      clock, 
    input  logic      reset_b,
    input  logic      pgcb_clkreq,
    output logic      pgcb_clkack,
    output logic      clk_out
    );

    logic[3:0] CCount, PCount, gCCount, gPCount;
    logic[4:0] DCount;
    logic[2:0] UCount;
    logic      clk, gclk, clk_on;

//RTL CLOCK DIVIDER
//MASTER CLOCK = X PERIOD --> Y PERIOD
//FAST TO SLOW DIVIDER
    always_ff @ (posedge clock or negedge reset_b)
    begin
        if (!reset_b)
        begin
            CCount <= '0;
            PCount <= '0;
            clk    <= '0;
        end
        else if (CCount != FREQ)
        begin
            CCount <= CCount + 1;
            clk    <= '1;
        end
        else if (PCount != (FREQ-1))
        begin
            PCount <= PCount + 1;
            clk    <= '0;
        end
        else
        begin
            CCount <= '0;
            PCount <= '0;
            clk    <= '0;
        end
    end

    always_ff @ (posedge clock or negedge reset_b)
    begin
        if (!reset_b)
        begin
            gCCount <= '0;
            gPCount <= '0;
            gclk    <= '0;
        end
        else if ((gCCount != FREQ) && clk_on)
        begin
            gCCount <= gCCount + 1;
            gclk    <= '1;
        end
        else if ((gPCount != (FREQ-1)) && clk_on)
        begin
            gPCount <= gPCount + 1;
            gclk    <= '0;
        end
        else
        begin
            gCCount <= '0;
            gPCount <= '0;
            gclk    <= '0;
        end
    end

 

    always_ff @ (posedge clk or negedge reset_b)
    begin
        if (!reset_b)
        begin
            clk_on      <= '0;
            pgcb_clkack <= '0;
            UCount      <= '0;
            DCount      <= '0;
        end
        else if (!pgcb_clkreq)
        begin    
            pgcb_clkack <= '0;
            UCount      <= '0;
            if (DCount == 4'h8)
            begin
                DCount <= '0;
                clk_on <= '0;
            end
            else
                DCount <= DCount + 1;
        end
        else if (pgcb_clkreq)
        begin
            if (UCount == 3'h2)
            begin
                UCount      <= UCount + 1;
                clk_on      <= '1;
            end
            else if (UCount == 3'h3)
            begin
                UCount      <= '0;
                pgcb_clkack <= '1; 
            end
            else
            begin
                UCount      <= UCount + 1;
                DCount      <= '0; 
            end   
        end
    end

    assign clk_out = gclk;

endmodule // END PCGU_CLK_GEN
