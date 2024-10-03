//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

module hqm_system_lut_rmw

         import hqm_AW_pkg::*, hqm_pkg::*;
#(
         parameter DEPTH        = 64
        ,parameter WIDTH        = 1
        ,parameter PACK         = 32

        ,parameter [WIDTH-1:0] INIT_VALUE = {WIDTH{1'b0}}

        ,parameter AWIDTH       = (AW_logb2(DEPTH-1)+1)
        ,parameter PWIDTH       = (AW_logb2(PACK-1)+1)
        ,parameter MWIDTH       = ((PACK == 1) ? (3+AWIDTH+WIDTH) : (3+(AWIDTH-PWIDTH)+(WIDTH*PACK)))
) (

         input  logic                           clk
        ,input  logic                           rst_b

        ,input  logic                           wr_bad_par

        ,input  logic                           init
        ,output logic                           init_done

        ,input  logic                           cfg_re
        ,input  logic                           cfg_we
        ,input  logic   [AWIDTH-1:0]            cfg_addr
        ,input  logic   [WIDTH-1:0]             cfg_wdata

        ,output logic   [31:0]                  cfg_rdata

        ,output logic   [MWIDTH-1:0]            memi

        ,input  logic   [(WIDTH*PACK):0]        memo

        ,input  logic                           lut_re
        ,input  logic   [AWIDTH-1:0]            lut_addr
        ,input  logic                           lut_nord

        ,output logic                           lut_perr
        ,output logic   [WIDTH-1:0]             lut_rdata

        ,input  logic                           lut_hold
);

localparam DEPTH_WIDTH = AW_logb2(DEPTH)+1;

//-----------------------------------------------------------------------------------------------------

logic                           init_q;
logic                           init_done_q;
logic                           init_in_progress;

logic   [DEPTH_WIDTH-1:0]       cfg_addr_scaled;
logic   [DEPTH_WIDTH-1:0]       lut_addr_scaled;

logic                           lut0_hold;
logic                           lut0_re_q;
logic                           lut0_we_q;
logic                           lut0_nord_q;
logic   [AWIDTH:0]              lut0_addr_plus_pack;
logic   [DEPTH_WIDTH-1:0]       lut0_addr_next;
logic   [AWIDTH-1:0]            lut0_addr_q;
logic   [WIDTH-1:0]             lut0_wdata_q;

logic                           lut1_hold;
logic                           lut1_re_q;
logic                           lut1_nord_q;

logic                           lut2_hold;
logic                           lut2_re_q;
logic   [(WIDTH*PACK):0]        lut2_rdata_q;

//-----------------------------------------------------------------------------------------------------

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  init_q      <= '0;
  init_done_q <= '0;
 end else begin
  init_q      <= init;
  init_done_q <= init_done_q | (lut0_addr_next >= DEPTH[DEPTH_WIDTH-1:0]);
 end
end

assign init_in_progress = init_q & ~init_done_q;

assign init_done = init_done_q;

//-----------------------------------------------------------------------------------------------------

assign lut0_hold = (lut0_re_q | lut0_we_q) & lut1_hold;

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  lut0_re_q   <= '0;
  lut0_we_q   <= '0;
  lut0_nord_q <= '0;
 end else if (~lut0_hold) begin
  lut0_re_q   <= (cfg_re | lut_re) & init_done_q;
  lut0_we_q   <= cfg_we & init_done_q;
  lut0_nord_q <= lut_re & init_done_q & (lut_nord | ({1'b0, lut_addr} >= DEPTH[AWIDTH:0]));
 end
end

hqm_AW_width_scale #(.A_WIDTH(AWIDTH), .Z_WIDTH(DEPTH_WIDTH)) i_cfg_addr_scaled (

         .a     (cfg_addr)
        ,.z     (cfg_addr_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(AWIDTH), .Z_WIDTH(DEPTH_WIDTH)) i_lut_addr_scaled (

         .a     (lut_addr)
        ,.z     (lut_addr_scaled)
);

assign lut0_addr_plus_pack = {1'b0, lut0_addr_q} + PACK[AWIDTH:0];

assign lut0_addr_next = (~init_done)       ? lut0_addr_plus_pack[DEPTH_WIDTH-1:0] :
                        ((cfg_re | cfg_we) ? cfg_addr_scaled : lut_addr_scaled);

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  lut0_addr_q  <= '0;
  lut0_wdata_q <= INIT_VALUE;
 end else begin
  if (((cfg_re | cfg_we | lut_re) & ~lut0_hold) | init_in_progress) begin
   lut0_addr_q  <= lut0_addr_next[AWIDTH-1:0];
  end
  if (cfg_we & ~lut0_hold & ~init_in_progress) begin
   lut0_wdata_q <= cfg_wdata;
  end
 end
end

//-----------------------------------------------------------------------------------------------------

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  lut1_re_q   <= '0;
  lut1_nord_q <= '0;
 end else if (~lut1_hold) begin
  lut1_re_q   <= lut0_re_q;
  lut1_nord_q <= lut0_nord_q;
 end
end

//-----------------------------------------------------------------------------------------------------

assign lut2_hold = lut2_re_q & lut_hold;

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  lut2_re_q <= '0;
 end else if (~lut2_hold) begin
  lut2_re_q <= lut1_re_q;
 end
end

generate

 if (PACK == 1) begin: g_nonpacked

  logic                         lut0_wpar_q;

  //        1   2   3   4   5
  // LUT0   MR  MW  MR
  // LUT1       MV      MV
  // LUT2           MQ      MQ

  always_ff @(posedge clk or negedge rst_b) begin
   if (~rst_b) begin
    lut0_wpar_q  <= ^INIT_VALUE;
    lut2_rdata_q <= '0;
   end else begin
    if (cfg_we & ~lut0_hold & ~init_in_progress) begin
     lut0_wpar_q <= ^{cfg_wdata, wr_bad_par};
    end
    if (lut1_re_q & ~lut2_hold) begin
     lut2_rdata_q <= memo & {$bits(lut2_rdata_q){~lut1_nord_q}};
    end
   end
  end

  assign lut1_hold = lut1_re_q & lut2_hold;

  assign memi = {   (lut0_re_q & ~lut0_nord_q & ~lut1_hold)             // re
                  ,((lut0_we_q & ~lut1_hold) | init_in_progress)        // we
                  ,lut0_addr_q                                          // addr
                  ,lut0_wpar_q                                          // parity
                  ,lut0_wdata_q                                         // wdata
  };

  assign lut_rdata = lut2_rdata_q[WIDTH-1:0];

  assign lut_perr = lut2_re_q & (^lut2_rdata_q);

 end else begin: g_packed

  //        1   2   3   4   5   6
  // LUT0   MR  MW              Mx
  // LUT1       MV  MV          
  // LUT2           MQ  MQ  
  // LUT3                   MW

  logic                         lut1_we_q;
  logic                         lut2_we_q;
  logic                         lut3_we_q;
  logic [PWIDTH-1:0]            lut1_addr_q;
  logic [PWIDTH-1:0]            lut2_addr_q;
  logic [(WIDTH*PACK)-1:0]      lut3_wdata_next;
  logic [(WIDTH*PACK)-1:0]      lut3_wdata_q;
  logic                         lut3_wpar_next;
  logic                         lut3_wpar_q;

  assign lut1_hold = (lut1_re_q | lut1_we_q) & lut2_hold;

  always_ff @(posedge clk or negedge rst_b) begin
   if (~rst_b) begin
    lut1_we_q    <= '0;
    lut2_we_q    <= '0;
    lut3_we_q    <= '0;
    lut2_rdata_q <= '0;
    lut3_wdata_q <= {PACK{INIT_VALUE}};
    lut3_wpar_q  <= (^{PACK{INIT_VALUE}});
    lut1_addr_q  <= '0;
    lut2_addr_q  <= '0;
   end else begin
    if (~lut1_hold) lut1_we_q <= lut0_we_q;
    if (~lut2_hold) lut2_we_q <= lut1_we_q;
                    lut3_we_q <= lut2_we_q;
    if ((lut1_re_q | lut1_we_q) & ~lut2_hold) begin
     lut2_rdata_q <= memo & {$bits(lut2_rdata_q){~lut1_nord_q}};
    end
    if (lut2_we_q) begin
     lut3_wdata_q <= lut3_wdata_next;
     lut3_wpar_q  <= lut3_wpar_next ^ wr_bad_par;
    end
    if (lut0_re_q & ~lut1_hold) lut1_addr_q <= lut0_addr_q[PWIDTH-1:0];
    if (lut1_re_q & ~lut2_hold) lut2_addr_q <= lut1_addr_q;
   end
  end

  always_comb begin
   lut3_wdata_next = lut2_rdata_q[(WIDTH*PACK)-1:0];
   lut3_wdata_next[(WIDTH*lut0_addr_q[PWIDTH-1:0]) +: WIDTH] = lut0_wdata_q; 
  end

  assign lut3_wpar_next = ^(lut3_wdata_next);

  assign memi = {  (((lut0_re_q & ~lut0_nord_q) | lut0_we_q) & ~lut1_hold)  // re
                  ,(lut3_we_q | init_in_progress)                           // we
                  ,lut0_addr_q[AWIDTH-1:PWIDTH]                             // addr
                  ,lut3_wpar_q                                              // parity
                  ,lut3_wdata_q                                             // wdata
  };

  assign lut_rdata = lut2_rdata_q[(WIDTH*lut2_addr_q) +: WIDTH];    

  assign lut_perr = (lut2_re_q | lut2_we_q) & (^lut2_rdata_q);

 end

endgenerate

hqm_AW_width_scale #(.A_WIDTH(WIDTH), .Z_WIDTH(32)) i_cfg_rdata (               

         .a     (lut_rdata[WIDTH-1:0] & {WIDTH{lut2_re_q}})
        ,.z     (cfg_rdata)
);

//-----------------------------------------------------------------------------------------------------

hqm_AW_unused_bits i_unused( 

        .a      (lut0_addr_plus_pack[AWIDTH])   // Not used in non-power-of-2 cases
);

endmodule // hqm_system_lut_rmw

