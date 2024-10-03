//----------------------------------------------------------------------------//
//-------------------- ENTITY FOR DEVTLB_RSTMUX2 -------------------//
//----------------------------------------------------------------------------//
//
//    RCS Information:
//    $Author: $
//    $Date: $
//    $Revision: $
//    $Locker: $
//
//----------------------------------------------------------------------------//
//
//    FILENAME  : rstmux2.v
//    DESIGNER  : Teo, Pik Lay
//    PROJECT   : ICH10 / iommu_rstmux2
//    DATE      : 12/07/06
//    PURPOSE   : Entity/Architecture/Config for iommu_rstmux2
//    REVISION NUMBER   : 12/7/2006 3:56:24 PM
//
//----------------------------------------------------------------------------//
//    Created by MAS2RTL v2005.5.20
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//    All Rights Reserved
//----------------------------------------------------------------------------//
//

`ifndef HQM_DEVTLB_RSTMUX2
`define HQM_DEVTLB_RSTMUX2

//---------------------------- Entity Declaration ----------------------------//

module hqm_devtlb_rstmux2 (
//lintra -68099
   clk,
   clr_b,
   clr_bypass_b,
   clr_bypass_sel,
   rst_bypass_b,
   rst_bypass_sel,
   reset_out_b
//lintra +68099
);
    input      logic            clk; // rxclk
    input      logic          clr_b; // txrst_b
    input      logic   clr_bypass_b; // dt_scanrst_b
    input      logic clr_bypass_sel; // dt_scanmode
    input      logic   rst_bypass_b; // dt_scanrst_b
    input      logic rst_bypass_sel; // dt_scanmode
    output     logic    reset_out_b; // rxrst_b


//----------------------------------------------------------------------------//
//----------------- ARCHITECTURE FOR RSTMUX -----------------//
//----------------------------------------------------------------------------//

//--------------------------- Signal Declarations ----------------------------//

    logic               reset_in_b;

//---------------------------- Model Description -----------------------------//

   // non-inverting 2:1 mux
   hqm_devtlb_ctech_mux_2to1 rstmux1 (
      .s       (clr_bypass_sel),
      .d1      (clr_bypass_b),
      .d2      (clr_b),
      .o       (reset_in_b)
   );

   // reset synhchronizer

   // non-inverting 2:1 mux
   hqm_devtlb_ctech_mux_2to1 rstmux2 (
      .s       (rst_bypass_sel),
      .d1      (rst_bypass_b),
      .d2      (reset_in_b),
      .o       (reset_out_b)
   );


endmodule // devtlb_rstmux2

`endif
