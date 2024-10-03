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
//  Module sbcusync: 
//
//------------------------------------------------------------------------------

// lintra push -60088, -60020, -68001, -80028, -60024b, -60024a, -70036_simple

module hqm_sbcusync_clk2 #(
   parameter DATA_RST_VALUE    = 0,
   parameter BUSWIDTH          = 0,
   parameter EGRESS_CNTR_VALUE = 1
) (
   input  logic              usyncselect, // lintra s-0527, s-70036
   input  logic              clk2,
   input  logic              rst2_b,
   input  logic              usync2,

   input  logic [BUSWIDTH:0] pre_sync_data,

   output logic [BUSWIDTH:0] q
);

`include "hqm_sbcfunc.vm"

localparam                       EGRESS_CNTR_WIDTH = sbc_indexed_value( EGRESS_CNTR_VALUE );
localparam [EGRESS_CNTR_WIDTH:0] EGRESS_CNTR_ZERO  = 'd0;
localparam [EGRESS_CNTR_WIDTH:0] EGRESS_CNTR_ONE   = 'd1;

logic [         BUSWIDTH:0] qtmp3;
logic                       clk2not;
logic                       usync2tmp1, usync2tmp2, usync2tmp3;
logic [EGRESS_CNTR_WIDTH:0] egr_cntr;

// PCR 58252: Proper clock ctechs used - START
hqm_sbc_clk_inv i_sbc_clk_inv_clk2not (
   .clk   ( clk2    ),
   .clkout( clk2not )
);
// PCR 58252: Proper clock ctechs used - FINISH

always_ff @( posedge clk2 or negedge rst2_b )    // FF6 -- changed rst to rst2_b
   if( !rst2_b )
      qtmp3 <= DATA_RST_VALUE;
   else if( usync2tmp3 )
      qtmp3 <= pre_sync_data;

always_ff @( posedge clk2 or negedge rst2_b )    // FF7
   if( !rst2_b )
      q <= DATA_RST_VALUE;
   else
      q <= qtmp3;

always_ff @( posedge clk2not or negedge rst2_b ) // FF3
   if( !rst2_b )
      usync2tmp1 <= 1'b0;
   else
      usync2tmp1 <= usync2;

always_ff @( posedge clk2 or negedge rst2_b )    // FF4
   if( !rst2_b )
      usync2tmp2 <= 1'b0;
   else
      usync2tmp2 <= usync2tmp1;

// PCR 1019109221: Egress USYNC Counter - START
always_ff @( posedge clk2 or negedge rst2_b )
   if( !rst2_b )
      egr_cntr <= EGRESS_CNTR_ZERO;
   else if( usync2tmp2 )
      egr_cntr <= EGRESS_CNTR_VALUE;
   else if( egr_cntr != EGRESS_CNTR_ZERO )
      egr_cntr <= egr_cntr - EGRESS_CNTR_ONE;

always_comb usync2tmp3 = ( egr_cntr == EGRESS_CNTR_ONE );
// PCR 1019109221: Egress USYNC Counter - FINISH

//-----------------------------------------------------------------------------
// SVA
//-----------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF

 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
property egr_delay_too_big;
// IF usync2tmp2 comes in while egr_cntr is more than one then the GAL will
// be missed. This assertion should never be waived. A fix would be required
// by the clocking unit at full chip to spread appart thier GALs. Otherwise,
// it may require the implementing agent to us a more reasonable value.
// This should be sent up to top interface of the IP as they will likely
// not know the correct values.
   @( posedge clk2 ) disable iff(!rst2_b || !usyncselect)
      (usync2tmp2) |-> (egr_cntr <= EGRESS_CNTR_ONE);
endproperty: egr_delay_too_big

assert_egr_delay_too_big: assert property( egr_delay_too_big ) else
   $display( "%0t: %m: ERROR: EGRESS_CNTR_VALUE (%d) is too big for the period of the provided usync inputs.", $time, EGRESS_CNTR_VALUE );
   
 `endif // SynTranlateOn

`endif
`endif
endmodule

// lintra pop

