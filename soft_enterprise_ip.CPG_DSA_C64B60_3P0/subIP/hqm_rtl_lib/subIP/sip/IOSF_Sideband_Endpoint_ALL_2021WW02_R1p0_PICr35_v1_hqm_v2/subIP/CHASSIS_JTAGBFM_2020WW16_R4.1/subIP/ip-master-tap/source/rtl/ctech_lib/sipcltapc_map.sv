//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//  2020WW22_PICr33
//
//  Module <mapfile> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved
//----------------------------------------------------------------------
//    FILENAME    : sipcltapc_map.sv
//    DESIGNER    : 
//    PROJECT     : sipcltapc
//    PURPOSE     : ctech cells map file for sipcltapc IP
//----------------------------------------------------------------------

`include "soc_clock_macros.sv"
`include "soc_clocks.sv"


//---------------------------------------------------------------
// Double Flop Synchronizer
//---------------------------------------------------------------
module sipcltapc_ctech_doublesync
   (
   input   logic   din,
   input   logic   clr_b,
   input   logic   clk,
   output  logic   qout
   );

   `ifdef DC
       `ASYNC_RST_2MSFF_META(qout,din,clk,clr_b)
   `else
       logic qtmp;

       always_ff @(posedge clk or negedge clr_b)
       begin : sipcltapc_ctech_doublesync
          if (clr_b == 1'b0) begin
            qtmp <= 1'b0;
            qout <= 1'b0;
          end else begin
            qtmp <= din ;
            qout <= qtmp;
          end
       end
   `endif

endmodule

//---------------------------------------------------------------
// Clock MUX 
//-------------------------------------------------------------------
module sipcltapc_ctech_clockmux
   (
   input   logic   in1,
   input   logic   in2,
   input   logic   sel,
   output  logic   outclk
   );

   `ifdef DC
       `MAKE_CLK_2TO1MUX(outclk,in2,in1,sel) 
   `else
       assign outclk = (in1 & sel) | (in2 & ~sel);
   `endif     

endmodule

//---------------------------------------------------------------
// Clock gate
//-------------------------------------------------------------------
module sipcltapc_ctech_clock_gate
   (
   input   logic   en,
   input   logic   te,
   input   logic   clk,
   output  logic   enclk
   );

   `ifdef DC
       `CLK_GATE_W_OVERRIDE (enclk,clk,en,te)

   `else
       logic cken_int;
       logic latched_cken;

       assign cken_int = en | te;

       always_latch
       begin : sipcltapc_ctech_clock_gate
          if (~clk) latched_cken <= cken_int;
       end

       always_comb enclk = latched_cken & clk;
   `endif

endmodule

//---------------------------------------------------------------
// Data AND cell
//---------------------------------------------------------------
module sipcltapc_ctech_and2_gen  
   (
   input   logic   a,
   input   logic   b,
   output  logic   o
   );

   `ifdef DC
       `DATAAND (o,a,b)

   `else
       assign o = a & b ; 
   `endif 

endmodule

//---------------------------------------------------------------
// Data Clock Buffer
//---------------------------------------------------------------
module sipcltapc_ctech_clkbf  
   (
   input   logic   in_clk,
   output  logic   o_clk
   );

   `ifdef DC
       `CLKBF(o_clk, in_clk)

   `else
       assign o_clk = in_clk;
   `endif 

endmodule
