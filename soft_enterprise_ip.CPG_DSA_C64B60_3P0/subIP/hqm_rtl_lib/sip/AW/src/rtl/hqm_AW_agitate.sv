//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
//....................................................
// MODE01: The agitate is broken into 2 sections
//        which are defined by the period and duty
//        cycles. The period repeats. Each portion
//        of the period have seperate probablities
//        to detetmine agitation. A prob of zero
//        is never agitate, a prob of 255 is always
//        agitate 
//
//                          -------------------------
//  |                       |                       | 
//  -------------------------                        ...
//
//  |<------------------ PERIOD ------------------->|...
//
//  |<-------- DUTY ------->|
//  |<------ PROB1st ------>|<------ PROB2nd ------>|...
//
//  cfg_mode      = {control[1:0]}                     // mode=1 
//  cfg_duty      = {control[4:2]}                     // 1-50% 2-25% 3-12%, 4-6% 5-3% 6-1.5% 7-0.75%
//  cfg_period    = {control[15:5],4'd0}               // 11b of cfg in multiple of 16 units  
//  cfg_prob1st   = {control[23:16]}                   // n/256 probablity
//  cfg_prob2nd   = {control[31:24]}                   // n/256 probablity 
//
//
//
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// 
module hqm_AW_agitate
  import hqm_AW_pkg::*;
#(
  parameter SEED = 1
, parameter ENABLE_MODE1 = 1
, parameter ENABLE_MODE2 = 0
, parameter ENABLE_MODE3 = 0
) (
    input  logic                        clk
  , input  logic                        rst_n
  , input  logic [ (32 ) -1 : 0 ]       control
  , input  logic                        in_agitate_value
  , input  logic                        in_data
  , input  logic                        in_stall_trigger
  , output logic                        out_data
);

logic agitate_f , agitate_nxt ;
logic [(8)-1:0] rand_f , rand_nxt ;
logic [(16)-1:0] randcnt_f , randcnt_nxt ;
logic [(16)-1:0] cnt_f , cnt_nxt;
logic [(2)-1:0] cfg_mode;
logic [(3)-1:0] cfg_duty;
logic [(16)-1:0] cfg_period;
logic [(8)-1:0] cfg_prob1st;
logic [(8)-1:0] cfg_prob2nd;
logic [(32)-1:0] control_f ;
logic in_stall_trigger_nc;
always_ff @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_f <= '0 ;
    rand_f <= '0 ;
    randcnt_f <= '0 ;
    agitate_f <= '0 ;
    control_f <= '0 ; 
  end
  else begin
    cnt_f <= cnt_nxt ;
    rand_f <= rand_nxt ;
    randcnt_f <= randcnt_nxt ;
    agitate_f <= agitate_nxt ;
    control_f[1:0] <= control[1:0] ;
    control_f[31:2] <= ( control[1] | control[0] ) ? control[31:2] : control_f[31:2] ;
  end
end

always_comb begin
  out_data = in_data;
  agitate_nxt = '0 ;
  cnt_nxt = cnt_f;
  rand_nxt = rand_f;
  randcnt_nxt = randcnt_f;
  cfg_mode = control_f[1:0] ;
  cfg_duty = control_f[4:2] ;
  cfg_period = {1'b0,control_f[15:5],4'd0} ;
  cfg_prob1st = control_f[23:16] ;
  cfg_prob2nd = control_f[31:24] ;
  in_stall_trigger_nc = in_stall_trigger;

  //=======================================================
  // create random number
  if ( cfg_mode != 2'd0 ) begin
    randcnt_nxt = randcnt_f + 16'd1 ;
    rand_nxt[0] = SEED[0] ^ randcnt_f[0] ^ randcnt_f[6] ^ randcnt_f[7] ^ randcnt_f[8] ^ randcnt_f[12] ^ randcnt_f[14];
    rand_nxt[1] = SEED[1] ^ randcnt_f[0] ^ randcnt_f[1] ^ randcnt_f[6] ^ randcnt_f[9] ^ randcnt_f[12] ^ randcnt_f[13] ^ randcnt_f[14] ^ randcnt_f[15];
    rand_nxt[2] = SEED[2] ^ randcnt_f[0] ^ randcnt_f[1] ^ randcnt_f[2] ^ randcnt_f[6] ^ randcnt_f[8] ^ randcnt_f[10] ^ randcnt_f[12] ^ randcnt_f[13] ^ randcnt_f[15];
    rand_nxt[3] = SEED[3] ^ randcnt_f[1] ^ randcnt_f[2] ^ randcnt_f[3] ^ randcnt_f[7] ^ randcnt_f[9] ^ randcnt_f[11] ^ randcnt_f[13] ^ randcnt_f[14];
    rand_nxt[4] = SEED[4] ^ randcnt_f[2] ^ randcnt_f[3] ^ randcnt_f[4] ^ randcnt_f[8] ^ randcnt_f[10] ^ randcnt_f[12] ^ randcnt_f[14] ^ randcnt_f[15];
    rand_nxt[5] = SEED[5] ^ randcnt_f[3] ^ randcnt_f[4] ^ randcnt_f[5] ^ randcnt_f[9] ^ randcnt_f[11] ^ randcnt_f[13] ^ randcnt_f[15];
    rand_nxt[6] = SEED[6] ^ randcnt_f[4] ^ randcnt_f[5] ^ randcnt_f[6] ^ randcnt_f[10] ^ randcnt_f[12] ^ randcnt_f[14];
    rand_nxt[7] = SEED[7] ^ randcnt_f[5] ^ randcnt_f[6] ^ randcnt_f[7] ^ randcnt_f[11] ^ randcnt_f[13] ^ randcnt_f[15];
  end

  //=======================================================
  if ( ( ENABLE_MODE1 == 1 ) & ( cfg_mode == 2'd1 ) ) begin
    cnt_nxt = cnt_f + 16'd1;
    if ( cnt_nxt >= cfg_period ) begin
      cnt_nxt = '0;
    end
    if ( cnt_f < ( cfg_period >> cfg_duty ) ) begin
      if ( ( cfg_prob1st == 8'hff ) | ( rand_f < cfg_prob1st ) ) begin
        agitate_nxt = 1'b1 ;
      end
    end
    else begin
      if ( ( cfg_prob2nd == 8'hff ) | ( rand_f < cfg_prob2nd ) ) begin
        agitate_nxt = 1'b1 ;
      end
    end
  end

  //=======================================================
  if (agitate_f == 1'b1 ) begin
      out_data = in_agitate_value ;
  end 

end
endmodule
// 
