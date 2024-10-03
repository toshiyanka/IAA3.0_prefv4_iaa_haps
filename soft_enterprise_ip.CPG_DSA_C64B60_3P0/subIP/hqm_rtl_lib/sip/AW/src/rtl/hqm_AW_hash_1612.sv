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
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// 
module hqm_AW_hash_1612 (
  input  logic                          clk
, input  logic                          rst_n
, input  logic                          bypass
, input  logic [ (  1 ) -1 : 0 ]        data_in_valid
, input  logic [ ( 16 ) -1 : 0 ]        data_in
, input  logic [ (  6 ) -1 : 0 ]        hash_size
, input  logic [ (  1 ) -1 : 0 ]        hash_hold   
, output logic [ (  1 ) -1 : 0 ]        hash_valid
, output logic [ ( 16 ) -1 : 0 ]        hash
);

//------------------------------------------------------------------------------------------------------------------------------------------------
// flops
logic [ ( 1 ) -1 : 0 ] data_in_valid_f ;
logic [ ( 6 ) -1 : 0 ] hash_size_f ;
logic [ ( 16 ) -1 : 0 ] data_in_f ;
logic [ ( 12 ) -1 : 0 ] mix_01_f , mix_01_nxt ;
always_ff @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    data_in_valid_f <= 0 ;
    data_in_f <= 0 ;
  end
  else
  begin
    data_in_valid_f <= data_in_valid | (data_in_valid_f & hash_hold);
    data_in_f <= hash_hold ? data_in_f : data_in ;
  end
end

always_ff @(posedge clk)
begin
    hash_size_f <= hash_hold ? hash_size_f : hash_size ;
    mix_01_f <= mix_01_nxt ;
end

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
logic [ ( 12 ) -1 : 0] crc ;
logic [ ( 12 ) -1 : 0] mix_01 ;
logic [ ( 12 ) -1 : 0] mix_02 ;
logic [ ( 12 ) -1 : 0] mix_03 ;
logic [ ( 12 ) -1 : 0] mix_04 ;
logic [ ( 12 ) -1 : 0] mix_05 ;
logic [ ( 12 ) -1 : 0] mix_06 ;

always_comb begin
  crc = '0 ;
  mix_01 = '0 ;
  mix_02 = '0 ;
  mix_03 = '0 ;
  mix_04 = '0 ;
  mix_05 = '0 ;
  mix_06 = '0 ;
  hash_valid = '0 ;
  hash = '0 ;

  if ( data_in_valid ) begin
    //-------------------------------------------------------------------------------------------------
    // Calculate CRC output
    //-------------------------------------------------------------------------------------------------
    crc[00] = data_in[0] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[14] ^ data_in[15] ;
    crc[01] = data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[14] ;
    crc[02] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[15] ;
    crc[03] = data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[14] ;
    crc[04] = data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[15] ;
    crc[05] = data_in[0] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[13] ^ data_in[14] ;
    crc[06] = data_in[1] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[14] ^ data_in[15] ;
    crc[07] = data_in[2] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[15] ;
    crc[08] = data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ;
    crc[09] = data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ;
    crc[10] = data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[14] ;
    crc[11] = data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[13] ^ data_in[14] ^ data_in[15] ;
    mix_01 = crc  ;//  + {           crc[10:0] , 1'd0 }
  end

  mix_01_nxt = mix_01_f;
  if (hash_hold==1'b0) begin
    mix_01_nxt = mix_01;
  end

  if ( data_in_valid_f ) begin
    if ( bypass ) begin
       hash = data_in_f;
    end
    else begin
      //-------------------------------------------------------------------------------------------------
      // Calculate MIXER output
      //-------------------------------------------------------------------------------------------------
      mix_02 = mix_01_f ^ { 1'd0 ,  mix_01_f[11:1]      } ;
      mix_03 = mix_02 ;//^ {        mix_02[10:0] , 1'd0 }
      mix_04 = mix_03 ;//+ {        mix_03[7:0]  , 4'd0 }
      mix_05 = mix_04 ^ { 7'd0 , mix_04[11:7]        } ;
      mix_06 = mix_05 ;//^ {        mix_05[8:0]  , 3'd0 }

      //-------------------------------------------------------------------------------------------------
      // output
      //-------------------------------------------------------------------------------------------------
      hash_valid = 1'd1 ;
      if ( hash_size_f == 6'd0 )  begin hash = { 4'd0,      data_in_f[11:0] } ; end
      if ( hash_size_f == 6'd1 )  begin hash = { 4'd0, 11'd0 , mix_06[0:0]  } ; end
      if ( hash_size_f == 6'd2 )  begin hash = { 4'd0, 10'd0 , mix_06[1:0]  } ; end
      if ( hash_size_f == 6'd3 )  begin hash = { 4'd0, 9'd0  , mix_06[2:0]  } ; end
      if ( hash_size_f == 6'd4 )  begin hash = { 4'd0, 8'd0  , mix_06[3:0]  } ; end
      if ( hash_size_f == 6'd5 )  begin hash = { 4'd0, 7'd0  , mix_06[4:0]  } ; end
      if ( hash_size_f == 6'd6 )  begin hash = { 4'd0, 6'd0  , mix_06[5:0]  } ; end
      if ( hash_size_f == 6'd7 )  begin hash = { 4'd0, 5'd0  , mix_06[6:0]  } ; end
      if ( hash_size_f == 6'd8 )  begin hash = { 4'd0, 4'd0  , mix_06[7:0]  } ; end
      if ( hash_size_f == 6'd9 )  begin hash = { 4'd0, 3'd0  , mix_06[8:0]  } ; end
      if ( hash_size_f == 6'd10 ) begin hash = { 4'd0, 2'd0  , mix_06[9:0]  } ; end
      if ( hash_size_f == 6'd11 ) begin hash = { 4'd0, 1'd0  , mix_06[10:0] } ; end
      if ( hash_size_f == 6'd12 ) begin hash = { 4'd0,         mix_06[11:0] } ; end
    end
  end

end
endmodule
// 
