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
///=====================================================================================================================
///
/// pmsrvr_pma_haltclk.vs
///
/// HSW RTL Contact1: Rahul Agrawal 
/// HSW RTL Contact2: Dean Mulla
///
/// Original Date: 19 September 2015
///
/// Copyright (c) 2009-2011 Intel Corporation
/// Intel Proprietary and Top Secret Information
///
/// This module contains the sync gen for early sync generation.
///
///=====================================================================================================================

module hqm_rcfwl_gclk_divsync_gen 
#(
    parameter INPUT_SYNC_GCLK_BEFORE_GAL_SYNC  = 1,       
    parameter OUTPUT_SYNC_GCLK_BEFORE_X_SYNC   = 0,  //this input should be in the range of MAX_RATIO_WIDTH-1 - 0 
    parameter MAX_RATIO_WIDTH                  = 12, 
  //  parameter XVR_TYPE                         = XVR_NOCHK,
    parameter RO_RATIO_WIDTH                   = 1 ,
     parameter NO_CLKEN_SYNC                   = 1    // 1-> no metflop used for clk_en , 0 -> meta flop used for clk_en
)

(
 input   logic         clk_free_in,
 input   logic         reset_b,
 input   logic         clk_en_in_b, // active low clock enable
 input   logic         usync_in,
  
 output  logic         clk_en_out,
 output  logic         div_reset_out, 
 output  logic         usync_out
);

logic clk_en_new_b;
logic [3:0]   MUsyncDelay;
logic [3:0]   NUsyncDelay;

assign MUsyncDelay = 4'b0000;
assign NUsyncDelay = 4'b0000;

generate
    if ( NO_CLKEN_SYNC ) begin : gen_no_clken_sync
     always_comb begin
     clk_en_new_b = clk_en_in_b ;
     end
    end 
    else begin : gen_clken_sync 
    hqm_rcfwl_gclk_ctech_lib_doublesync  ctech_lib_doublesync (
    
    .d(clk_en_in_b), .clk(clk_free_in), .o(clk_en_new_b));
    end
    
endgenerate  
     


logic PllZclkSyncGnnyH,  PllXclkSyncGnnxH;   
assign  PllZclkSyncGnnyH = usync_in;

logic [MAX_RATIO_WIDTH-1:0] SyncCntGnnnH,  SyncNxtCntGnnnH, GclkRatioGYXnnnH, SyncCnttoFallGnnnH, SyncCnttoRiseGnnnH;
logic PllZclkSyncRaisingEdgeGnnnH, PllZclkSyncGnny1H; //, PllXclkSyncRaisingEdgeGnnnH, PllXclkSyncGnnx1H;
logic PllXclkSyncRiseGnnxH, PllXclkSyncFallGnnxH;
logic [MAX_RATIO_WIDTH-1:0] gclk_before_gal_sync;

///////////////////////////////////////////////////////////////////////////
// calculate the gclk ratio or number of gclks between 2 rising sync edges
logic [MAX_RATIO_WIDTH-1:0] GclkRatio_local, localRatio_cnt;

assign GclkRatioGYXnnnH = GclkRatio_local;

assign gclk_before_gal_sync = INPUT_SYNC_GCLK_BEFORE_GAL_SYNC;


 always_ff @(posedge clk_free_in) begin
  localRatio_cnt  <= PllZclkSyncRaisingEdgeGnnnH ? '0 : (localRatio_cnt +{{MAX_RATIO_WIDTH-$bits(1'b1){1'b0}},1'b1} ) ;
  GclkRatio_local <= PllZclkSyncRaisingEdgeGnnnH ? (localRatio_cnt + {{MAX_RATIO_WIDTH-$bits(1'b1){1'b0}},1'b1} ) : GclkRatio_local;
  PllZclkSyncGnny1H <= PllZclkSyncGnnyH;
  SyncCntGnnnH <= PllZclkSyncRaisingEdgeGnnnH ? gclk_before_gal_sync : SyncNxtCntGnnnH;
 end
/////////////////////////////////////////////////////////////////////////

always_comb begin : pmsb_x4x1_sync
    // Falling edge detector
    PllZclkSyncRaisingEdgeGnnnH = ~PllZclkSyncGnny1H & PllZclkSyncGnnyH;

    SyncNxtCntGnnnH = ({MAX_RATIO_WIDTH{1'b0}} == SyncCntGnnnH) ? (GclkRatioGYXnnnH - {{MAX_RATIO_WIDTH-$bits(1'b1){1'b0}},1'b1})  : 
                                                                   (SyncCntGnnnH -{{MAX_RATIO_WIDTH-$bits(1'b1){1'b0}},1'b1} );
    
    SyncCnttoRiseGnnnH = (OUTPUT_SYNC_GCLK_BEFORE_X_SYNC + 1 );
    SyncCnttoRiseGnnnH = ((SyncCnttoRiseGnnnH >= GclkRatioGYXnnnH) ? (SyncCnttoRiseGnnnH - GclkRatioGYXnnnH) : SyncCnttoRiseGnnnH);
    
    PllXclkSyncRiseGnnxH = (SyncNxtCntGnnnH == SyncCnttoRiseGnnnH);
    
    //SyncCnttoFallGnnnH could be bigger then the ratio (need to adjust for overlap)
    SyncCnttoFallGnnnH = ({1'b0,GclkRatioGYXnnnH>>1} + (OUTPUT_SYNC_GCLK_BEFORE_X_SYNC + 1));
    SyncCnttoFallGnnnH = ((SyncCnttoFallGnnnH >= GclkRatioGYXnnnH) ? (SyncCnttoFallGnnnH - GclkRatioGYXnnnH) : SyncCnttoFallGnnnH);
    SyncCnttoFallGnnnH = ((SyncCnttoFallGnnnH >= GclkRatioGYXnnnH) ? (SyncCnttoFallGnnnH - GclkRatioGYXnnnH) : SyncCnttoFallGnnnH);
    
    PllXclkSyncFallGnnxH = (SyncNxtCntGnnnH == SyncCnttoFallGnnnH);
end

  logic gate_clk_sync_aligned, gate_clk_staged, gate_clk_rise_edge, gate_clk_fall_edge, PllXclkSyncGnnxH_staged;

 always_comb begin 

     PllXclkSyncGnnxH = PllXclkSyncRiseGnnxH ? 1'b1 :
                        PllXclkSyncFallGnnxH ? 1'b0 :
                                                PllXclkSyncGnnxH_staged;


  end

 always_ff @(posedge clk_free_in) begin
   PllXclkSyncGnnxH_staged <= PllXclkSyncGnnxH;
   gate_clk_sync_aligned <= PllZclkSyncRaisingEdgeGnnnH ? ~clk_en_new_b : gate_clk_sync_aligned;
   gate_clk_staged <= gate_clk_sync_aligned;
 end

 assign usync_out = PllXclkSyncGnnxH;

////////////////////////////////////////////////////////////////////////////////////////
///////// generate halt clk signal /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

 assign gate_clk_rise_edge =  gate_clk_sync_aligned & ~gate_clk_staged;
 assign gate_clk_fall_edge = ~gate_clk_sync_aligned &  gate_clk_staged;

  // start a counter on rising ip gate clk

  logic [3:0] m_usync_counter_in, m_usync_counter;
  logic counter_expired, counter_expired_staged, counter_expired_riseedge;
  logic counter_enabled;

  assign counter_expired = (m_usync_counter == 0);

 always_ff @(posedge clk_free_in) begin
   counter_expired_staged <= counter_expired;
 end

  assign counter_expired_riseedge =  counter_expired & ~counter_expired_staged;


 always_ff @(posedge clk_free_in) begin
  counter_enabled <= gate_clk_rise_edge       ? 1'b1 : 
                     (counter_expired_riseedge | reset_b) ? 1'b0 : counter_enabled;
   
  m_usync_counter <= PllXclkSyncRiseGnnxH             ? m_usync_counter_in :  
                     (gate_clk_rise_edge | reset_b)   ? MUsyncDelay : m_usync_counter_in;
 end

  assign  m_usync_counter_in = counter_enabled ? m_usync_counter - 1 : m_usync_counter;
////////////////////

  logic [3:0] n_usync_counter_in, n_usync_counter;
  logic n_counter_expired, n_counter_expired_staged, n_counter_expired_riseedge;
  logic n_counter_enabled;

  assign n_counter_expired = (n_usync_counter == 0);

 always_ff @(posedge clk_free_in) begin
   n_counter_expired_staged <= n_counter_expired;
 end

  assign n_counter_expired_riseedge =  n_counter_expired & ~n_counter_expired_staged;

 always_ff @(posedge clk_free_in) begin
  n_counter_enabled <= gate_clk_fall_edge       ? 1'b1 : 
                     (n_counter_expired_riseedge | reset_b) ? 1'b0 : n_counter_enabled;
   
  n_usync_counter <= PllXclkSyncRiseGnnxH ? n_usync_counter_in :  
                     (gate_clk_fall_edge | reset_b)   ? NUsyncDelay : n_usync_counter_in;
 end

  assign  n_usync_counter_in = n_counter_enabled ? n_usync_counter - 1 : n_usync_counter;

//////////////////
  logic clk_en_local;
 
 always_comb begin
   if ((MUsyncDelay == 0) & (NUsyncDelay == 0)) begin 
     clk_en_local = PllXclkSyncRiseGnnxH ? ~clk_en_new_b : clk_en_out;  
   end else begin
     clk_en_local = (n_counter_expired_riseedge | reset_b) ? 1'b0 :
                   counter_expired_riseedge              ? 1'b1 : clk_en_out;
   end
 end

 always_ff @(posedge clk_free_in) begin
   clk_en_out    <= clk_en_local; 
 end

///////////////////////////////// dop rst logic//////////////////
 assign div_reset_out = PllXclkSyncRiseGnnxH; 

endmodule  

//`endif 








