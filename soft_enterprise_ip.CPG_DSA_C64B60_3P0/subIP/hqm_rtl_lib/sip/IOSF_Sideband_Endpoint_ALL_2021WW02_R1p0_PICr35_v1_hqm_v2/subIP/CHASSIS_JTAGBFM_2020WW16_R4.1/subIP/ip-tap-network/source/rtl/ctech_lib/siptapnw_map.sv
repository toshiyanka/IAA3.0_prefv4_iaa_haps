
`timescale 1ps/1ps
`include "soc_clocks.sv"


module siptapnwctech_mx22_clk (
   input   logic d1,
   input   logic d2,
   input   logic s,
   output  logic o
   );

   `ifdef DC
       `MAKE_CLK_2TO1MUX (o,d2,d1,s)

   `else
       always_comb
           if(d1 == d2)
               o =  d2;
           else
               o = (d1&s)|(d2&~s);
   `endif 

endmodule

