module ctech_lib_clk_16delay (clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14);
   input logic clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14;
   output logic clk16delayout;
   d04cpkf0ld0c0 ctech_lib_dcszo (.clkout(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),
                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),
                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10),
                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),
                                     .rsel14(clk16in14), .clk(clk16delayin));
endmodule
