//
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  File sbcmap : 
//                 Maps special cells, such as double sync, clockgate,
//                 etc. to behavioral models, or, if desired, end customer
//                 replaces this with library cells.
//
//------------------------------------------------------------------------------

// lintra push -60020, -68099, -60039

module hqm_sbc_doublesync ( // lintra s-80099, s-60704
                   input  logic d,
                   input  logic clr_b,
                   input  logic clk,
                   output logic q);
// lintra push -80099, -60026, -50000, -70023

   logic rst;
   
   always_comb rst = ~clr_b;
   
   ctech_lib_doublesync_rst // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_msff_async_rst_meta_donttouch_dcszo (
      .o  ( q   ), // lintra s-2271
      .d  ( d   ), // lintra s-2271
      .clk( clk ),
      .rst( rst )
   );
endmodule

// lintra pop

module hqm_sbc_ctech_scan_mux ( // lintra s-80099, s-60704
   input  logic d,
   input  logic si,
   input  logic se,
   output logic o );
// lintra push -80099, -60026, -50000, -70023

   ctech_lib_mux_2to1 // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_mux_2to1_donttouch_dcszo (
      .d1( si ),
      .d2( d  ),
      .s ( se ),
      .o ( o  )
   );
endmodule
// lintra pop

module hqm_sbc_doublesync_set ( // lintra s-80099, s-60704
                   input  logic d,
                   input  logic set_b,
                   input  logic clk,
                   output logic q);

// lintra push -80099, -60026, -50000, -70023
   logic set;
   
   always_comb set = ~set_b;
   
   ctech_lib_doublesync_set // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_msff_async_set_meta_donttouch_dcszo (
      .o  ( q   ), // lintra s-2271
      .d  ( d   ), // lintra s-2271
      .clk( clk ),
      .set( set )
   );

endmodule

// lintra pop

module hqm_sbc_clock_gate ( // lintra s-60704
                   input  logic en,
                   input  logic te,
                   input  logic clk,
                   output logic enclk );

// lintra push -80099, -60026, -50000, -60029, -50004
   ctech_lib_clk_gate_te // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_clk_gate_te_donttouch_dcszo (
      .clkout( enclk ),
      .clk   ( clk   ),
      .en    ( en    ),
      .te    ( te    )
   );
  
endmodule

// lintra pop


module hqm_sbc_clock_buf ( // lintra s-60704
                  input  logic i,
                  output logic o );

   ctech_lib_clk_buf // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_clk_buf_donttouch_dcszo (
      .clkout(o),
      .clk   (i)
   );

endmodule // sbc_clock_buf

//ctech4.0 rename from ctech_lib_clk_gate_te_rst_ss to ctech_lib_clk_gate_te_rstb
module hqm_sbc_gc_latchen ( // lintra s-60704
                   input  logic en,
                   input  logic te,
                   input  logic clrb,
                   input  logic ck,
                   output logic enclk );

// lintra push -80099, -60026, -60018
   //logic rst;
   
  // always_comb rst = ~clrb;
      
   ctech_lib_clk_gate_te_rstb // SOC Customer needs to replace this cell, SIP POR
   i_ctech_lib_clk_gate_te_rstb_donttouch_dcszo (
      .clkout( enclk ),   
      .clk   ( ck    ),
      .en    ( en    ),
      .te    ( te    ),
      .rstb  ( clrb  )     
   );

endmodule



module hqm_sbc_clk_inv ( // lintra s-60704
                 input  logic clk,
                 output logic clkout );

   
      ctech_lib_clk_inv // SOC Customer needs to replace this cell, SIP POR
      i_ctech_lib_clk_inv_donttouch_dcszo (
         .clkout( clkout ),
         .clk   ( clk    )
   );

endmodule



// lintra pop

// lintra pop
