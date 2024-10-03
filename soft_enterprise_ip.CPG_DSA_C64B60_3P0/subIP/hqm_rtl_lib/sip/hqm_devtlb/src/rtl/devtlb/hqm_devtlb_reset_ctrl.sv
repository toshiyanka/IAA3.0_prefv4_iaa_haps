//======================================================================================================================
//
// iommu_resetctrl.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//======================================================================================================================


`ifndef HQM_DEVTLB_RESET_CTRL_VS
`define HQM_DEVTLB_RESET_CTRL_VS

`include "hqm_devtlb_rstmux2.v"

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_reset_ctrl (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   nonflreset,
   local_reset_out,
   local_nonflreset_out
//lintra +68099
);
parameter logic DEVTLB_RESET_STYLE = 1'b1; //0=async; 1=sync.

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input    logic                               nonflreset;
   output   logic                               local_reset_out;              // Unit reset asynchronous
   output   logic                               local_nonflreset_out;      // Unit reset asynchronous

generate
if(DEVTLB_RESET_STYLE==1'b0) begin : gen_async_rst
   logic                                        ClkFreeRcb_H;
   logic                                        ClkFreeLcb_H;

   `HQM_DEVTLB_MAKE_RCB_PH1(ClkFreeRcb_H, clk, 1'b1,  1'b1)
   `HQM_DEVTLB_MAKE_LCB_PWR(ClkFreeLcb_H, ClkFreeRcb_H, 1'b1,  1'b1)

   //`DEVTLB_MSFF(local_reset_out, reset, ClkFreeLcb_H)
   //`DEVTLB_MSFF(local_nonflreset_out, nonflreset, ClkFreeLcb_H)



   logic                                        local_reset_out_b;              // Unit reset
   logic                                        local_nonflreset_out_b;      // Unit reset

   hqm_devtlb_rstmux2 rst_rstmux2 (
      .clk(ClkFreeLcb_H), 
      .clr_b(~reset),
      .clr_bypass_b(fscan_byprst_b), 
      .clr_bypass_sel(fscan_rstbypen), 
      .rst_bypass_b(fscan_byprst_b), 
      .rst_bypass_sel(fscan_rstbypen), 
      .reset_out_b(local_reset_out_b)
   );

   hqm_devtlb_rstmux2 nonflrst_rstmux2 (
      .clk(ClkFreeLcb_H), 
      .clr_b(~nonflreset),
      .clr_bypass_b(fscan_byprst_b), 
      .clr_bypass_sel(fscan_rstbypen), 
      .rst_bypass_b(fscan_byprst_b), 
      .rst_bypass_sel(fscan_rstbypen), 
      .reset_out_b(local_nonflreset_out_b)
   );

assign local_reset_out           = ~local_reset_out_b;
assign local_nonflreset_out      = ~local_nonflreset_out_b;

end else if(DEVTLB_RESET_STYLE==1'b1) begin : gen_sync_rst
    always_comb begin
        local_reset_out = reset;
        local_nonflreset_out = nonflreset;
    end

end
endgenerate

endmodule

`endif
