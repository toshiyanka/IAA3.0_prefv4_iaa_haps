
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//
//	FILENAME	: clkreqaggr.sv
//	DESCRIPTION	: Clock Request Aggregator top level
//
//----------------------------------------------------------------------------//
//----------------------------- Revision History -----------------------------//
//
//	Date		Rev		Owner			Description
//	--------	---		------------	-------------------------------------
//	01/07/2015	0.00	Jesse Ong		Initial revision based on dyclkgate design
//
//----------------------------------------------------------------------------//
//	Assumptions	:
//
//	Glossary	:
//		Upstream	: agent from upper layer of this block (nearer to PCG/TCG or clock source)
//		Downstream	: agent from lower layer of this block (nearer to the IP/sub-block, further from PCG)
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

//`timescale 1ps/1ps

module hqm_rcfwl_gclk_clkreqaggr
#(
      parameter                                      CLKREQ_CNT = 2           // # of clock requests coming from downstream agents
)
(
      // Clock & Reset
      input  logic                                   rst_b,         		  // Active low reset, already sync'ed to iclk outside of this component
      input  logic                                   iclk,               	  // Input Clock

      // Clock control signals
      output logic                                   oclkmreq,                // Upstream clock request
      input  logic                                   iclkmack,                // Upstream clock acknowledge
      input  logic [                 CLKREQ_CNT-1:0] iclkreq,                 // Downstream clock requests
      output logic [                 CLKREQ_CNT-1:0] oclkack                 // Downstream clock acknowledges
      
);

//`ifndef SYNTHESIS
// `include "gclk_dump_initialize.sv" // Has the dump_hier() routine in it
//`endif
logic [7:0]  clkreqaggr_visa ;

//----------------------------------------------------------------------------//
//-------------------- Internal signals declaration --------------------------//
//----------------------------------------------------------------------------//
logic                     clkmack_sync, any_iclkreq, any_req_sync, consolidated_req_sync, any_iclkreq_sync;
logic [   CLKREQ_CNT-1:0] iclkreq_sync;
logic [              3:0] clkreqaggrsm_visa;
logic                     rst_b_sync;
//----------------------------------------------------------------------------//
//---------------------------- rcb_lcb---------------------------------//
//----------------------------------------------------------------------------//

 //logic clk_rcb_free;
 //logic clk_rcb;
 //logic clk_lcb_free;

 // Free running RCB
//   gclk_make_clk_and_rcb_free i_gclk_make_clk_and_rcb_free
//   (
//   .CkRcbX1N(clk_rcb_free),
//   .CkGridX1N(iclk),
 //  .Fd( 1'b0),
 //  .Rd(1'b1)
 //  );
 
 // Free running LCB
// gclk_make_lcb_loc_and i_gclk_make_lcb_loc_and_free
//   (
//   .CkLcbXPN(clk_lcb_free),
//   .CkRcbXPN(clk_rcb_free),
 //  .FcEn(1'b1),
 //  .LPEn(1'b1),
 //  .LPOvrd(1'b0),
 //  .FscanClkUngate(1'b0)
//   );

//----------------------------------------------------------------------------//
//---------------------------- Synchronizers ---------------------------------//
//----------------------------------------------------------------------------//

// hsd #220576368 Synchronize async reset to iclk domain.
hqm_rcfwl_gclk_ctech_doublesync_rst
i_rst_doublesync (
      .d(1'b1),
      .clr_b(rst_b),
      .clk(iclk),
      .q(rst_b_sync)
);



// Synchronize upstream clock ack to igclk
hqm_rcfwl_gclk_ctech_doublesync_rst
u_clkmack_doublesync (
      .d(iclkmack),
      .clr_b(rst_b_sync),
      .clk(iclk),
      .q(clkmack_sync)
);

// Consolidate and synchronize clkreq 
assign any_iclkreq                                   = |iclkreq;

hqm_rcfwl_gclk_ctech_doublesync_rst
u_any_req_doublesync (
      .d(any_iclkreq),
      .clr_b(rst_b_sync),
      .clk(iclk),
      .q(any_req_sync)
);


// Synchronize downstream clock req to igclk
genvar i;
generate
   for (i=0; i<CLKREQ_CNT; i=i+1) begin : num_dn_clkack

hqm_rcfwl_gclk_ctech_doublesync_rst
u_clkreq_doublesync (
      .d(iclkreq[i]),
      .clr_b(rst_b_sync),
      .clk(iclk),
      .q(iclkreq_sync[i])
);

   end
endgenerate

// Consolidate all clock ungate requests
assign any_iclkreq_sync                              = |iclkreq_sync;
hqm_rcfwl_gclk_ctech_or2_gen
u_consolidated_req_sync_or2_gen (
      .a(any_req_sync),
      .b(any_iclkreq_sync),
      .y(consolidated_req_sync)
);

//----------------------------------------------------------------------------//
//-------------------------- Clock control SM --------------------------------//
//----------------------------------------------------------------------------// 
hqm_rcfwl_gclk_clkreqaggrsm #(
      .CLKREQ_CNT(CLKREQ_CNT)
)
u_dyclkgatesm (
      .rst_b(rst_b_sync),
      .iclk(iclk),
      .clkmack_sync,
      .iclkreq_sync,
      .any_req_qual(any_iclkreq),
      .consolidated_req_sync,
      .oclkmreq,
      .oclkack,
      .clkreqaggrsm_visa
);

//----------------------------------------------------------------------------//
//----------------------------- VISA Signals ---------------------------------//
//----------------------------------------------------------------------------//
assign clkreqaggr_visa                                      = { oclkmreq, iclkmack,
                                                         2'b00,
                                                         clkreqaggrsm_visa};

endmodule
