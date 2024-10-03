// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature 5d0be951736ff1bc8ef4aa56199eb919aa328856 % Version r1.0.0_m1.18 % _View_Id v % Date_Time 20160303_050453 
module rfrom_ctech_clk_buf (
   input  wire clk,
   output wire clkout
);
  `ifndef DC
  assign clkout =  clk;
   `else
   "ERROR, do not use this file for DC"
   `endif
endmodule
