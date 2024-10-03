
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
module hqm_rcfwl_gclk_psyncdist 
 #(
	NUM_OF_GRID_PRI_CLKS    = 'd2
    
    )
 (
 input	    logic  [NUM_OF_GRID_PRI_CLKS-1:0]	sync_in,
  output	logic  [NUM_OF_GRID_PRI_CLKS-1:0]	sync_out, 
 
 input	    logic  x12clk_in,
  output    logic  x1clk_sync_out,
  output    logic  x3clk_sync_out,
  output    logic  x4clk_sync_out
);


   
logic  x1clk_sync;
logic  x3clk_sync;
logic  x4clk_sync;

//----------------------------------------------------------------------------//
//---------------------------- rcb_lcb---------------------------------//
//----------------------------------------------------------------------------//

logic clk_rcb_free;
logic x12clk_in_lcb;

 // Free running RCB
   hqm_rcfwl_gclk_make_clk_and_rcb_free i_gclk_make_clk_and_rcb_free
   (
   .CkRcbX1N(clk_rcb_free),
   .CkGridX1N(x12clk_in),
   .Fd( 1'b0),
   .Rd(1'b1)
   );

 // Free running LCB
 hqm_rcfwl_gclk_make_lcb_loc_and i_gclk_make_lcb_loc_and_free
   (
   .CkLcbXPN(x12clk_in_lcb),
   .CkRcbXPN(clk_rcb_free),
   .FcEn(1'b1),
   .LPEn(1'b1),
   .LPOvrd(1'b0),
   .FscanClkUngate(1'b0)
   );


hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 44),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
)
syncgen_1 (
          .clk_free_in  (x12clk_in_lcb),          
          .clk_en_in_b(1'b0),
          .usync_in(sync_in[0]),
   	// .MUsyncDelay(4'h0),
    	// .NUsyncDelay(4'h0),
	.reset_b(1'b1),
          .clk_en_out(),
         .div_reset_out(),
         .usync_out(x1clk_sync)
);
 
 hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 32),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
) 
syncgen_2 (
          .clk_free_in  (x12clk_in_lcb),          
          .clk_en_in_b  (1'b0),
          .usync_in   (sync_in[0]),
         // .MUsyncDelay(4'h0),
         // .NUsyncDelay(4'h0),
	.reset_b(1'b1),
         .clk_en_out  (),
         .div_reset_out(),
         .usync_out   (x3clk_sync)
); 
 
hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 8),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
) syncgen_3 (
          .clk_free_in  (x12clk_in_lcb),          
          .clk_en_in_b(1'b0),
          .usync_in(sync_in[0]),
   	 //.MUsyncDelay(4'h0),
   	 //.NUsyncDelay(4'h0),
	.reset_b(1'b1),
          .clk_en_out(),
         .div_reset_out(),
         .usync_out(x4clk_sync)
);  


assign sync_out = sync_in;
assign x1clk_sync_out   =   x1clk_sync;
assign x3clk_sync_out   =   x3clk_sync;
assign x4clk_sync_out   =   x4clk_sync; 

 endmodule
