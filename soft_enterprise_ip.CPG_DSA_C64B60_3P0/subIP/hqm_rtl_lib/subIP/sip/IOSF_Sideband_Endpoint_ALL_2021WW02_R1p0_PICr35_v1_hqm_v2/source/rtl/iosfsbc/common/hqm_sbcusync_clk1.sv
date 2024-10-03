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

module hqm_sbcusync_clk1 #(
   parameter DATA_RST_VALUE    = 0,
   parameter BUSWIDTH          = 0,
   parameter EGRESS_CNTR_VALUE = 1
) (
   input  logic              usyncselect, // lintra s-0527, s-70036
   input  logic              clk1,
   input  logic              rst1_b,
   input  logic              usync1,

   output logic [BUSWIDTH:0] pre_sync_data,

   input  logic [BUSWIDTH:0] d
);

`include "hqm_sbcfunc.vm"

localparam                       EGRESS_CNTR_WIDTH = sbc_indexed_value( EGRESS_CNTR_VALUE );
localparam [EGRESS_CNTR_WIDTH:0] EGRESS_CNTR_ZERO  = 'd0;
localparam [EGRESS_CNTR_WIDTH:0] EGRESS_CNTR_ONE   = 'd1;

logic [         BUSWIDTH:0] qtmp1;
logic                       clk1not;

// PCR 58252: Proper clock ctechs used - START
hqm_sbc_clk_inv i_sbc_clk_inv_clk1not (
   .clk   ( clk1    ),
   .clkout( clk1not )
);

// PCR 58252: Proper clock ctechs used - FINISH

always_ff @( posedge clk1 or negedge rst1_b )    // FF1
   if( !rst1_b )
      qtmp1 <= DATA_RST_VALUE;
   else
      qtmp1 <= d;

always_ff @( posedge clk1not or negedge rst1_b ) // FF2     
   if( !rst1_b )
      pre_sync_data <= DATA_RST_VALUE;
   else if( usync1 )
      pre_sync_data <= qtmp1;


endmodule

// lintra pop

