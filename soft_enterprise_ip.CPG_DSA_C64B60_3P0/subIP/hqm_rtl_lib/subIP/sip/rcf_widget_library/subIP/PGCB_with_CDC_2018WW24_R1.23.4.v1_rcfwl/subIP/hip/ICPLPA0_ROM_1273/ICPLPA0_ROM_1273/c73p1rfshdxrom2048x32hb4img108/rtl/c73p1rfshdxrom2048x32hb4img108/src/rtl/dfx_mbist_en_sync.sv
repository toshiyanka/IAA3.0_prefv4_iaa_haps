// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature 763643642fffc10458d27df1e57847ece70be2fd % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160216_100945 
`include "soc_clocks.sv"

module dfx_mbist_en_sync (
   input  logic  clk,
   input  logic  rst,
   input  logic  en_in,

   output logic  en_out
);

  logic rst_int;

    //`ASYNC_RST_2MSFF_META(q,i,clk,rstb)
    `ASYNC_RST_2MSFF_META(rst_int, 1'b1, clk, rst)
    `ASYNC_RST_2MSFF_META(en_out, en_in, clk, rst_int)

endmodule

