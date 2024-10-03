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
//  Module sbcfifo : 
//                   Flop-based clock crossing FIFO.
//
//------------------------------------------------------------------------------

// lintra push -68099, -68012
// lintra push -60024b, -60024a, -70036_simple

module hqm_sbcfifo ( // lintra s-80099
                ing_side_clk,
                ing_side_rst_b,
                qpush,
                bin_wptr,
                bin_rptr,
                qout,
                qin,
                egr_side_clk
                );

// lintra push -60020

  parameter MAXQENTRY = 1;
  parameter MAXPLDBIT = 7;
  parameter MAXQPTRBIT = 0;
  
  input logic                 ing_side_clk;
  input logic                 egr_side_clk;   // lintra s-0527, s-70036
  input logic                 ing_side_rst_b;
  input logic                 qpush;
  input logic  [MAXQPTRBIT:0] bin_wptr;
  input logic  [MAXQPTRBIT:0] bin_rptr;
  input logic  [MAXPLDBIT:0]  qin;
  output logic [MAXPLDBIT:0]  qout;
  
  
  logic [MAXQENTRY:0][MAXPLDBIT:0] fifo;
  
  always_ff @(posedge ing_side_clk or negedge ing_side_rst_b)
    if (~ing_side_rst_b) fifo <= '0;
    else if (qpush) begin
       for (int entry = 0; entry <= MAXQENTRY; entry++) begin
          if (bin_wptr == entry) fifo[entry] <= qin;
       end
    end
  
  always_comb begin
     qout = '0;
     for (int entry = 0; entry <= MAXQENTRY; entry++) begin
        if (bin_rptr == entry) qout = fifo[entry];
     end
  end

// lintra pop

endmodule // sbcfifo
