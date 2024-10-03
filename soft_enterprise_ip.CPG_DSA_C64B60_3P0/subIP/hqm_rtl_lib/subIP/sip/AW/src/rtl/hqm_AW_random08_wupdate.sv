//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIcnt_fENTIAL
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_random08_wupdate #(
  parameter SEED = 1
, parameter INC = 1

) (
  input  logic                  clk
, input  logic                  rst_n
, output logic [ ( 8 ) -1 : 0 ] random
, input logic update  

);

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
logic [ ( 40 ) -1 : 0 ] cnt_f , cnt_nxt;
logic [ ( 8 ) -1 : 0 ] crc_f , crc_nxt;
logic [ ( 8 ) -1 : 0 ] out_f , out_nxt;
logic [ ( 8 ) -1 : 0 ] crc ;
logic [ ( 8 ) -1 : 0 ] mix0 , mix1 , mix2 , mix3 , mix4 , mix5 , mix6 ;

always_ff @(posedge clk or negedge rst_n) begin
  if ( rst_n == 1'd0 ) begin
    cnt_f <= {8'd0,SEED};
    crc_f <= '0 ;
    out_f <= '0 ;
  end
  else begin
    cnt_f <= cnt_nxt;
    crc_f <= crc_nxt;
    out_f <= out_nxt;
  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
always_comb begin
  random = out_f ; 

  cnt_nxt = cnt_f + { 39'd0 , ( update | 1'b1 ) } ; //always INCrement by default

//hash
  crc[00] = cnt_f[0]^cnt_f[6]^cnt_f[7]^cnt_f[8]^cnt_f[12]^cnt_f[14]^cnt_f[16]^cnt_f[18]^cnt_f[19]^cnt_f[21]^cnt_f[23]^cnt_f[28]^cnt_f[30]^cnt_f[31]^cnt_f[34]^cnt_f[35]^cnt_f[39] ;
  crc[01] = cnt_f[0]^cnt_f[1]^cnt_f[6]^cnt_f[9]^cnt_f[12]^cnt_f[13]^cnt_f[14]^cnt_f[15]^cnt_f[16]^cnt_f[17]^cnt_f[18]^cnt_f[20]^cnt_f[21]^cnt_f[22]^cnt_f[23]^cnt_f[24]^cnt_f[28]^cnt_f[29]^cnt_f[30]^cnt_f[32]^cnt_f[34]^cnt_f[36]^cnt_f[39] ;
  crc[02] = cnt_f[0]^cnt_f[1]^cnt_f[2]^cnt_f[6]^cnt_f[8]^cnt_f[10]^cnt_f[12]^cnt_f[13]^cnt_f[15]^cnt_f[17]^cnt_f[22]^cnt_f[24]^cnt_f[25]^cnt_f[28]^cnt_f[29]^cnt_f[33]^cnt_f[34]^cnt_f[37]^cnt_f[39] ;
  crc[03] = cnt_f[1]^cnt_f[2]^cnt_f[3]^cnt_f[7]^cnt_f[9]^cnt_f[11]^cnt_f[13]^cnt_f[14]^cnt_f[16]^cnt_f[18]^cnt_f[23]^cnt_f[25]^cnt_f[26]^cnt_f[29]^cnt_f[30]^cnt_f[34]^cnt_f[35]^cnt_f[38] ;
  crc[04] = cnt_f[2]^cnt_f[3]^cnt_f[4]^cnt_f[8]^cnt_f[10]^cnt_f[12]^cnt_f[14]^cnt_f[15]^cnt_f[17]^cnt_f[19]^cnt_f[24]^cnt_f[26]^cnt_f[27]^cnt_f[30]^cnt_f[31]^cnt_f[35]^cnt_f[36]^cnt_f[39] ;
  crc[05] = cnt_f[3]^cnt_f[4]^cnt_f[5]^cnt_f[9]^cnt_f[11]^cnt_f[13]^cnt_f[15]^cnt_f[16]^cnt_f[18]^cnt_f[20]^cnt_f[25]^cnt_f[27]^cnt_f[28]^cnt_f[31]^cnt_f[32]^cnt_f[36]^cnt_f[37] ;
  crc[06] = cnt_f[4]^cnt_f[5]^cnt_f[6]^cnt_f[10]^cnt_f[12]^cnt_f[14]^cnt_f[16]^cnt_f[17]^cnt_f[19]^cnt_f[21]^cnt_f[26]^cnt_f[28]^cnt_f[29]^cnt_f[32]^cnt_f[33]^cnt_f[37]^cnt_f[38] ;
  crc[07] = cnt_f[5]^cnt_f[6]^cnt_f[7]^cnt_f[11]^cnt_f[13]^cnt_f[15]^cnt_f[17]^cnt_f[18]^cnt_f[20]^cnt_f[22]^cnt_f[27]^cnt_f[29]^cnt_f[30]^cnt_f[33]^cnt_f[34]^cnt_f[38]^cnt_f[39] ;

  crc_nxt = crc ;

//mix
//    00  01  02  03  04  05  06  07
//00 500 500 500 500 500 500 500 500
//01 500 500 500 500 500 500 500 500
//02 500 500 500 500 500 500 500 500
//03 500 500 500 500 500 500 500 500
//04 500 500 500 500 500 500 500 500
//05 500 500 500 500 500 500 500 500
//06 500 500 500 500 500 500 500 500
//07 500 500 562 500 437 500 437 500
//002 =RMSE 0     0 2 5 3 4 2 0 4
//                + ^ + ^ + ^ + ^

  mix0 = crc_f ;
  mix1 = mix0 ^ { 2'd0 , mix0[7:2]        } ;
  mix2 = mix1 + {        mix1[2:0] , 5'd0 } ;
  mix3 = mix2 ^ { 3'd0 , mix2[7:3]        } ;
  mix4 = mix3 + {        mix3[3:0] , 4'd0 } ;
  mix5 = mix4 ^ { 2'd0 , mix4[7:2]        } ;
  mix6 = mix5 ^ { 4'd0 , mix5[7:4]        } ;

  out_nxt = mix6 ;
end


logic unused_nnc ;       // lint says it is nc even though used, because ORed with constant 1
assign unused_nnc       = update ;

endmodule
