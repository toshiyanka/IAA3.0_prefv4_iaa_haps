
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
module hqm_rcfwl_gclk_refclkdist (
  input	 logic x12clk_in,
  input	  logic x12clksync_in,
  output logic	x4clk_out,
  output logic	x4clk_sync_out,
  output  logic ckpll_ref_clk_out, 
  output  logic ckpll_ref_sync_out,
  output  logic x3clk_out, 
  output  logic x3clk_sync_out,
  input   logic ck_crystal_in, 
  output  logic ck_crystal_out,
  output logic	x12clk_out,
  output logic	x12clk_sync_out
  
);

//`ifndef SYNTHESIS
// `include "gclk_dump_initialize.sv" // Has the dump_hier() routine in it
//`endif

logic sync_edge_det;

logic sync_edge_det_1;
logic sync_edge_det_2;
//logic x4clk_sync_out;
//logic x3clk_sync_out;
//logic ckpll_ref_sync_out;
logic x4clk_sync_out_1;
logic x4clk_sync_out_2;
logic x3clk_sync_out_1;
logic ckpll_ref_sync_out_1;


 logic [3:0] x1_usync_counter;
 logic [3:0] x3_usync_counter;
 logic [5:0] x4_usync_counter;

 logic x1clk_sync_out_2;
 logic x3clk_sync_out_2;

logic [5:0] x4usyncratio;
logic [3:0] x1usyncratio;
logic [4:0] x3usyncratio;

logic x12clksync_in_ff;
logic x12clksync_in_ff2;
logic x4clk_sync_out_wire;
logic ckpll_ref_sync_out_wire;
logic x3clk_sync_out_wire;
logic x12clksync_in_ff2_reg;
logic x12clksync_in_ff2_edge;

always_ff @(posedge x12clk_in )
begin
x12clksync_in_ff <=x12clksync_in ;
x12clksync_in_ff2 <=x12clksync_in_ff ;
end

// on rising edge of the sync, generate a reset pulse
    assign sync_edge_det = ( x12clksync_in_ff& (~x12clksync_in_ff2) );

     always_ff @(posedge x12clk_in) begin
 	x12clksync_in_ff2_reg <= x12clksync_in_ff2 ;
     end
 
    
     assign x12clksync_in_ff2_edge = (x12clksync_in_ff2 & (~x12clksync_in_ff2_reg)) ;



hqm_rcfwl_gclk_pccdu_dop#( .GRID_CLK_DIVISOR (4'h3))
     div3 (
            .fdop_preclk_grid(x12clk_in),
            .fscan_clk(1'b0),  
             .fscan_dop_clken(1'b1),
             .fdop_preclk_div_sync(x12clksync_in_ff2_edge),
             .adop_postclk(x4clk_out),
	     .adop_postclk_free()
            );
hqm_rcfwl_gclk_pccdu_dop#( .GRID_CLK_DIVISOR (4'h9))
     div9 (
            .fdop_preclk_grid(x12clk_in),
            .fscan_clk(1'b0),  
             .fscan_dop_clken(1'b1),
             .fdop_preclk_div_sync(x12clksync_in_ff2_edge),
             .adop_postclk(x3clk_out),
	     .adop_postclk_free()
            );
hqm_rcfwl_gclk_pccdu_dop#( .GRID_CLK_DIVISOR (4'hc)
               )
     div12 (
            .fdop_preclk_grid(x12clk_in),
            .fscan_clk(1'b0),  
             .fscan_dop_clken(1'b1),
             .fdop_preclk_div_sync(x12clksync_in_ff2_edge),
             .adop_postclk(ckpll_ref_clk_out),
	     .adop_postclk_free()
            );

                  
always_ff @(posedge x12clk_in) begin
   sync_edge_det_1 <= sync_edge_det ;
   sync_edge_det_2 <= sync_edge_det_1 ;
  end                  
                  
                  
assign ck_crystal_out = ck_crystal_in ;
assign x12clk_out     = x12clk_in;
assign x12clk_sync_out   = x12clksync_in;

 
 
 always_ff @(posedge x4clk_out) begin
   x4clk_sync_out_1 <= sync_edge_det_2 ;
   x4clk_sync_out_2  <= x4clk_sync_out_1 ;
  end 
  
 always_ff @(posedge x3clk_out) begin
   x3clk_sync_out_1 <= sync_edge_det_2 ;
   x3clk_sync_out_2  <= x3clk_sync_out_1 ;
  end
  
 always_ff @(posedge ckpll_ref_clk_out) begin 
  ckpll_ref_sync_out_1 <= sync_edge_det_2 ;
  x1clk_sync_out_2   <= ckpll_ref_sync_out_1 ;
  end
  

  
always_comb begin
 x1usyncratio = 4'd12;
    end

always_ff @( posedge ckpll_ref_clk_out   ) begin
   if (x1clk_sync_out_2) 
     x1_usync_counter <= x1usyncratio - ((4*x1usyncratio/12) - 4);
   else if ( x1_usync_counter== x1usyncratio) 
     x1_usync_counter <= 4'd1;
    else                          
      x1_usync_counter  <= x1_usync_counter+4'd1;
 end
    
    always_ff @( posedge ckpll_ref_clk_out   ) begin
       ckpll_ref_sync_out_wire  <= ((x1_usync_counter > 4) &&  (x1_usync_counter < ((x1usyncratio/2)+ 5))) ;
        end
    
    
  
 always_comb begin
 x4usyncratio = 6'd48;
    end

always_ff @( posedge x4clk_out   ) begin
   if (x4clk_sync_out_2) 
     x4_usync_counter <= x4usyncratio - ((4*x4usyncratio/12) - 4);
   else if ( x4_usync_counter== x4usyncratio) 
     x4_usync_counter <= 6'd1;
    else                          
      x4_usync_counter  <= x4_usync_counter+6'd1;
 end
    
    always_ff @( posedge x4clk_out   ) begin
       x4clk_sync_out_wire  <= (x4_usync_counter == x4usyncratio || 
                                ((x4_usync_counter <= 4) ||  (x4_usync_counter > ((x4usyncratio/2)+ 4))) );
    end
 
 
 always_comb begin
 x3usyncratio = 5'd16;
    end
 

always_ff @( posedge x3clk_out   ) begin
   if (x3clk_sync_out_2) 
     x3_usync_counter <= x3usyncratio - ((4*x3usyncratio/12) - 4);
   else if ( x3_usync_counter== x3usyncratio) 
     x3_usync_counter <= 5'd1;
    else                          
      x3_usync_counter  <= x3_usync_counter+5'd1;
 end
    
    always_ff @( posedge x3clk_out   ) begin
        x3clk_sync_out_wire <=  ((x3_usync_counter <= (x3usyncratio - 1 ) ) && 
                               (x3_usync_counter > ((x3usyncratio/2)-1) ) ) ;
    end

hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 44),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
)
syncgen_1 (
          .clk_free_in  (x12clk_in),          
          .clk_en_in_b(1'b0),
          .usync_in(x12clksync_in),
   	// .MUsyncDelay(4'h0),
    	// .NUsyncDelay(4'h0),
	.reset_b(1'b1),
          .clk_en_out(),
         .div_reset_out(),
         .usync_out(ckpll_ref_sync_out)
);
 
 hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 32),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
) 
syncgen_2 (
          .clk_free_in  (x12clk_in),          
          .clk_en_in_b  (1'b0),
          .usync_in   (x12clksync_in),
        //  .MUsyncDelay(4'h0),
        //  .NUsyncDelay(4'h0),
	.reset_b(1'b1),
         .clk_en_out  (),
         .div_reset_out(),
         .usync_out   (x3clk_sync_out)
); 
hqm_rcfwl_gclk_divsync_gen#(
     .INPUT_SYNC_GCLK_BEFORE_GAL_SYNC ( 1),
    .OUTPUT_SYNC_GCLK_BEFORE_X_SYNC    ( 8),  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
     .MAX_RATIO_WIDTH                  ( 12),  
     .RO_RATIO_WIDTH                   ( 1)
) syncgen_3 (
          .clk_free_in  (x12clk_in),          
          .clk_en_in_b(1'b0),
          .usync_in(x12clksync_in),
   	// .MUsyncDelay(4'h0),
   	// .NUsyncDelay(4'h0),
	.reset_b(1'b1),
          .clk_en_out(),
         .div_reset_out(),
         .usync_out(x4clk_sync_out)
);  
 

endmodule
