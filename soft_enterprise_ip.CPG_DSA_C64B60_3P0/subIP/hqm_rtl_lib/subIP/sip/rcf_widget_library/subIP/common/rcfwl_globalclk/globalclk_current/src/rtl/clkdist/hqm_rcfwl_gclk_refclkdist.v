
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
  input	  x4clk_in,
  input	  sync,
  output	x4clk_out,
  output	sync_out,
  output   ckpll_ref_clk_out, 
  output   ckpll_ref_sync_out,
  output   x3clk_out, 
  output   x3clk_sync_out
);

reg div3;
reg [1:0] cnt;
reg div3_d;
reg sync_edge;
reg sync_edge_reg;
reg div2_clk;
reg div4_clk;
wire x3clk;
wire sync_edge_det;

always_ff @(posedge x4clk_in )
begin
sync_edge <=sync ;
end

/////// Div 3 clock
always_ff @(posedge x4clk_in ) 
begin 
  if (sync_edge) 
     cnt <= 2'b00; 
  else if (cnt == 2'b10) 
  begin 
     cnt <= 2'b00; 
     div3 <= 1'b1; 
  end 
  else 
  begin 
      cnt <= cnt + 1; 
      div3 <= 1'b0; 
  end 
end 


always_ff @(negedge x4clk_in) 
begin 
  if (sync_edge) 
     div3_d <= 1'b1; 
  else 
      div3_d <= div3; 
end 

assign x3clk = div3 | div3_d; 


///// Div 4 clock
always_ff @(posedge x4clk_in) begin
   sync_edge_reg <= sync_edge ;
  end
 
 assign  sync_edge_det =  sync_edge & (~sync_edge_reg) ;
 
always_ff@(posedge x4clk_in) begin
     if (sync_edge_det)
       begin
         div2_clk <= 1'b0;
       end
     else
       begin
         div2_clk <= ~div2_clk;
       end
    end

always_ff@(posedge div2_clk) begin
     if (sync_edge_det)
       begin
         div4_clk <= 1'b1;
       end
     else
       begin
         div4_clk <= ~div4_clk;
       end
    end



assign x4clk_out = x4clk_in ;
assign sync_out = sync_edge ;
assign x3clk_out = x3clk;
assign x3clk_sync_out = sync_edge ;
assign ckpll_ref_clk_out =  div4_clk;
assign ckpll_ref_sync_out  = sync_edge ;
endmodule
