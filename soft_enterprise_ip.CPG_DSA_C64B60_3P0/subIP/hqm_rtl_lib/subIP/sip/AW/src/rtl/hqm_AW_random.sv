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
module hqm_AW_random #(
 SEED = 1
) (
  input logic clk
, input logic rst_n
, output logic [ ( 32 ) -1 : 0 ] random
);

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
logic [ ( 43 ) -1 : 0 ] lfsr_f , lfsr_nxt;
logic [ ( 32 ) -1 : 0 ] out_f , out_nxt;

always_ff @(posedge clk or negedge rst_n) begin
  if ( rst_n == 1'd0 ) begin
    lfsr_f <= {11'd0,SEED};
    out_f <= '0 ;
  end
  else begin
    lfsr_f <= lfsr_nxt;
    out_f <= out_nxt;
  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
always_comb begin
  random = out_f ;

  lfsr_nxt[ 42 ] = lfsr_f[ 41 ];
  lfsr_nxt[ 41 ] = lfsr_f[ 40 ] ^ lfsr_f[ 42 ];
  lfsr_nxt[ 40 ] = lfsr_f[ 39 ];
  lfsr_nxt[ 39 ] = lfsr_f[ 38 ];
  lfsr_nxt[ 38 ] = lfsr_f[ 37 ];
  lfsr_nxt[ 37 ] = lfsr_f[ 36 ];
  lfsr_nxt[ 36 ] = lfsr_f[ 35 ];
  lfsr_nxt[ 35 ] = lfsr_f[ 34 ];
  lfsr_nxt[ 34 ] = lfsr_f[ 33 ];
  lfsr_nxt[ 33 ] = lfsr_f[ 32 ];
  lfsr_nxt[ 32 ] = lfsr_f[ 31 ];
  lfsr_nxt[ 31 ] = lfsr_f[ 30 ];
  lfsr_nxt[ 30 ] = lfsr_f[ 29 ];
  lfsr_nxt[ 29 ] = lfsr_f[ 28 ];
  lfsr_nxt[ 28 ] = lfsr_f[ 27 ];
  lfsr_nxt[ 27 ] = lfsr_f[ 26 ];
  lfsr_nxt[ 26 ] = lfsr_f[ 25 ];
  lfsr_nxt[ 25 ] = lfsr_f[ 24 ];
  lfsr_nxt[ 24 ] = lfsr_f[ 23 ];
  lfsr_nxt[ 23 ] = lfsr_f[ 22 ];
  lfsr_nxt[ 22 ] = lfsr_f[ 21 ];
  lfsr_nxt[ 21 ] = lfsr_f[ 20 ];
  lfsr_nxt[ 20 ] = lfsr_f[ 19 ] ^ lfsr_f[ 42 ];
  lfsr_nxt[ 19 ] = lfsr_f[ 18 ];
  lfsr_nxt[ 18 ] = lfsr_f[ 17 ];
  lfsr_nxt[ 17 ] = lfsr_f[ 16 ];
  lfsr_nxt[ 16 ] = lfsr_f[ 15 ];
  lfsr_nxt[ 15 ] = lfsr_f[ 14 ];
  lfsr_nxt[ 14 ] = lfsr_f[ 13 ];
  lfsr_nxt[ 13 ] = lfsr_f[ 12 ];
  lfsr_nxt[ 12 ] = lfsr_f[ 11 ];
  lfsr_nxt[ 11 ] = lfsr_f[ 10 ];
  lfsr_nxt[ 10 ] = lfsr_f[ 9 ];
  lfsr_nxt[ 9 ] = lfsr_f[ 8 ];
  lfsr_nxt[ 8 ] = lfsr_f[ 7 ];
  lfsr_nxt[ 7 ] = lfsr_f[ 6 ];
  lfsr_nxt[ 6 ] = lfsr_f[ 5 ];
  lfsr_nxt[ 5 ] = lfsr_f[ 4 ];
  lfsr_nxt[ 4 ] = lfsr_f[ 3 ];
  lfsr_nxt[ 3 ] = lfsr_f[ 2 ];
  lfsr_nxt[ 2 ] = lfsr_f[ 1 ];
  lfsr_nxt[ 1 ] = lfsr_f[ 0 ] ^ lfsr_f[ 42 ];
  lfsr_nxt[ 0 ] = lfsr_f[ 42 ];

  out_nxt[00] = lfsr_f[0]^lfsr_f[6]^lfsr_f[9]^lfsr_f[10]^lfsr_f[12]^lfsr_f[16]^lfsr_f[24]^lfsr_f[25]^lfsr_f[26]^lfsr_f[28]^lfsr_f[29]^lfsr_f[30]^lfsr_f[31]^lfsr_f[32]^lfsr_f[34]^lfsr_f[37] ;
  out_nxt[01] = lfsr_f[0]^lfsr_f[1]^lfsr_f[6]^lfsr_f[7]^lfsr_f[9]^lfsr_f[11]^lfsr_f[12]^lfsr_f[13]^lfsr_f[16]^lfsr_f[17]^lfsr_f[24]^lfsr_f[27]^lfsr_f[28]^lfsr_f[33]^lfsr_f[34]^lfsr_f[35]^lfsr_f[37]^lfsr_f[38] ;
  out_nxt[02] = lfsr_f[0]^lfsr_f[1]^lfsr_f[2]^lfsr_f[6]^lfsr_f[7]^lfsr_f[8]^lfsr_f[9]^lfsr_f[13]^lfsr_f[14]^lfsr_f[16]^lfsr_f[17]^lfsr_f[18]^lfsr_f[24]^lfsr_f[26]^lfsr_f[30]^lfsr_f[31]^lfsr_f[32]^lfsr_f[35]^lfsr_f[36]^lfsr_f[37]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[03] = lfsr_f[1]^lfsr_f[2]^lfsr_f[3]^lfsr_f[7]^lfsr_f[8]^lfsr_f[9]^lfsr_f[10]^lfsr_f[14]^lfsr_f[15]^lfsr_f[17]^lfsr_f[18]^lfsr_f[19]^lfsr_f[25]^lfsr_f[27]^lfsr_f[31]^lfsr_f[32]^lfsr_f[33]^lfsr_f[36]^lfsr_f[37]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[04] = lfsr_f[0]^lfsr_f[2]^lfsr_f[3]^lfsr_f[4]^lfsr_f[6]^lfsr_f[8]^lfsr_f[11]^lfsr_f[12]^lfsr_f[15]^lfsr_f[18]^lfsr_f[19]^lfsr_f[20]^lfsr_f[24]^lfsr_f[25]^lfsr_f[29]^lfsr_f[30]^lfsr_f[31]^lfsr_f[33]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[05] = lfsr_f[0]^lfsr_f[1]^lfsr_f[3]^lfsr_f[4]^lfsr_f[5]^lfsr_f[6]^lfsr_f[7]^lfsr_f[10]^lfsr_f[13]^lfsr_f[19]^lfsr_f[20]^lfsr_f[21]^lfsr_f[24]^lfsr_f[28]^lfsr_f[29]^lfsr_f[37]^lfsr_f[39] ;
  out_nxt[06] = lfsr_f[1]^lfsr_f[2]^lfsr_f[4]^lfsr_f[5]^lfsr_f[6]^lfsr_f[7]^lfsr_f[8]^lfsr_f[11]^lfsr_f[14]^lfsr_f[20]^lfsr_f[21]^lfsr_f[22]^lfsr_f[25]^lfsr_f[29]^lfsr_f[30]^lfsr_f[38] ;
  out_nxt[07] = lfsr_f[0]^lfsr_f[2]^lfsr_f[3]^lfsr_f[5]^lfsr_f[7]^lfsr_f[8]^lfsr_f[10]^lfsr_f[15]^lfsr_f[16]^lfsr_f[21]^lfsr_f[22]^lfsr_f[23]^lfsr_f[24]^lfsr_f[25]^lfsr_f[28]^lfsr_f[29]^lfsr_f[32]^lfsr_f[34]^lfsr_f[37]^lfsr_f[39] ;
  out_nxt[08] = lfsr_f[0]^lfsr_f[1]^lfsr_f[3]^lfsr_f[4]^lfsr_f[8]^lfsr_f[10]^lfsr_f[11]^lfsr_f[12]^lfsr_f[17]^lfsr_f[22]^lfsr_f[23]^lfsr_f[28]^lfsr_f[31]^lfsr_f[32]^lfsr_f[33]^lfsr_f[34]^lfsr_f[35]^lfsr_f[37]^lfsr_f[38] ;
  out_nxt[09] = lfsr_f[1]^lfsr_f[2]^lfsr_f[4]^lfsr_f[5]^lfsr_f[9]^lfsr_f[11]^lfsr_f[12]^lfsr_f[13]^lfsr_f[18]^lfsr_f[23]^lfsr_f[24]^lfsr_f[29]^lfsr_f[32]^lfsr_f[33]^lfsr_f[34]^lfsr_f[35]^lfsr_f[36]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[10] = lfsr_f[0]^lfsr_f[2]^lfsr_f[3]^lfsr_f[5]^lfsr_f[9]^lfsr_f[13]^lfsr_f[14]^lfsr_f[16]^lfsr_f[19]^lfsr_f[26]^lfsr_f[28]^lfsr_f[29]^lfsr_f[31]^lfsr_f[32]^lfsr_f[33]^lfsr_f[35]^lfsr_f[36]^lfsr_f[39] ;
  out_nxt[11] = lfsr_f[0]^lfsr_f[1]^lfsr_f[3]^lfsr_f[4]^lfsr_f[9]^lfsr_f[12]^lfsr_f[14]^lfsr_f[15]^lfsr_f[16]^lfsr_f[17]^lfsr_f[20]^lfsr_f[24]^lfsr_f[25]^lfsr_f[26]^lfsr_f[27]^lfsr_f[28]^lfsr_f[31]^lfsr_f[33]^lfsr_f[36] ;
  out_nxt[12] = lfsr_f[0]^lfsr_f[1]^lfsr_f[2]^lfsr_f[4]^lfsr_f[5]^lfsr_f[6]^lfsr_f[9]^lfsr_f[12]^lfsr_f[13]^lfsr_f[15]^lfsr_f[17]^lfsr_f[18]^lfsr_f[21]^lfsr_f[24]^lfsr_f[27]^lfsr_f[30]^lfsr_f[31] ;
  out_nxt[13] = lfsr_f[1]^lfsr_f[2]^lfsr_f[3]^lfsr_f[5]^lfsr_f[6]^lfsr_f[7]^lfsr_f[10]^lfsr_f[13]^lfsr_f[14]^lfsr_f[16]^lfsr_f[18]^lfsr_f[19]^lfsr_f[22]^lfsr_f[25]^lfsr_f[28]^lfsr_f[31]^lfsr_f[32] ;
  out_nxt[14] = lfsr_f[2]^lfsr_f[3]^lfsr_f[4]^lfsr_f[6]^lfsr_f[7]^lfsr_f[8]^lfsr_f[11]^lfsr_f[14]^lfsr_f[15]^lfsr_f[17]^lfsr_f[19]^lfsr_f[20]^lfsr_f[23]^lfsr_f[26]^lfsr_f[29]^lfsr_f[32]^lfsr_f[33] ;
  out_nxt[15] = lfsr_f[3]^lfsr_f[4]^lfsr_f[5]^lfsr_f[7]^lfsr_f[8]^lfsr_f[9]^lfsr_f[12]^lfsr_f[15]^lfsr_f[16]^lfsr_f[18]^lfsr_f[20]^lfsr_f[21]^lfsr_f[24]^lfsr_f[27]^lfsr_f[30]^lfsr_f[33]^lfsr_f[34] ;
  out_nxt[16] = lfsr_f[0]^lfsr_f[4]^lfsr_f[5]^lfsr_f[8]^lfsr_f[12]^lfsr_f[13]^lfsr_f[17]^lfsr_f[19]^lfsr_f[21]^lfsr_f[22]^lfsr_f[24]^lfsr_f[26]^lfsr_f[29]^lfsr_f[30]^lfsr_f[32]^lfsr_f[35]^lfsr_f[37] ;
  out_nxt[17] = lfsr_f[1]^lfsr_f[5]^lfsr_f[6]^lfsr_f[9]^lfsr_f[13]^lfsr_f[14]^lfsr_f[18]^lfsr_f[20]^lfsr_f[22]^lfsr_f[23]^lfsr_f[25]^lfsr_f[27]^lfsr_f[30]^lfsr_f[31]^lfsr_f[33]^lfsr_f[36]^lfsr_f[38] ;
  out_nxt[18] = lfsr_f[2]^lfsr_f[6]^lfsr_f[7]^lfsr_f[10]^lfsr_f[14]^lfsr_f[15]^lfsr_f[19]^lfsr_f[21]^lfsr_f[23]^lfsr_f[24]^lfsr_f[26]^lfsr_f[28]^lfsr_f[31]^lfsr_f[32]^lfsr_f[34]^lfsr_f[37]^lfsr_f[39] ;
  out_nxt[19] = lfsr_f[3]^lfsr_f[7]^lfsr_f[8]^lfsr_f[11]^lfsr_f[15]^lfsr_f[16]^lfsr_f[20]^lfsr_f[22]^lfsr_f[24]^lfsr_f[25]^lfsr_f[27]^lfsr_f[29]^lfsr_f[32]^lfsr_f[33]^lfsr_f[35]^lfsr_f[38] ;
  out_nxt[20] = lfsr_f[4]^lfsr_f[8]^lfsr_f[9]^lfsr_f[12]^lfsr_f[16]^lfsr_f[17]^lfsr_f[21]^lfsr_f[23]^lfsr_f[25]^lfsr_f[26]^lfsr_f[28]^lfsr_f[30]^lfsr_f[33]^lfsr_f[34]^lfsr_f[36]^lfsr_f[39] ;
  out_nxt[21] = lfsr_f[5]^lfsr_f[9]^lfsr_f[10]^lfsr_f[13]^lfsr_f[17]^lfsr_f[18]^lfsr_f[22]^lfsr_f[24]^lfsr_f[26]^lfsr_f[27]^lfsr_f[29]^lfsr_f[31]^lfsr_f[34]^lfsr_f[35]^lfsr_f[37] ;
  out_nxt[22] = lfsr_f[0]^lfsr_f[9]^lfsr_f[11]^lfsr_f[12]^lfsr_f[14]^lfsr_f[16]^lfsr_f[18]^lfsr_f[19]^lfsr_f[23]^lfsr_f[24]^lfsr_f[26]^lfsr_f[27]^lfsr_f[29]^lfsr_f[31]^lfsr_f[34]^lfsr_f[35]^lfsr_f[36]^lfsr_f[37]^lfsr_f[38] ;
  out_nxt[23] = lfsr_f[0]^lfsr_f[1]^lfsr_f[6]^lfsr_f[9]^lfsr_f[13]^lfsr_f[15]^lfsr_f[16]^lfsr_f[17]^lfsr_f[19]^lfsr_f[20]^lfsr_f[26]^lfsr_f[27]^lfsr_f[29]^lfsr_f[31]^lfsr_f[34]^lfsr_f[35]^lfsr_f[36]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[24] = lfsr_f[1]^lfsr_f[2]^lfsr_f[7]^lfsr_f[10]^lfsr_f[14]^lfsr_f[16]^lfsr_f[17]^lfsr_f[18]^lfsr_f[20]^lfsr_f[21]^lfsr_f[27]^lfsr_f[28]^lfsr_f[30]^lfsr_f[32]^lfsr_f[35]^lfsr_f[36]^lfsr_f[37]^lfsr_f[39] ;
  out_nxt[25] = lfsr_f[2]^lfsr_f[3]^lfsr_f[8]^lfsr_f[11]^lfsr_f[15]^lfsr_f[17]^lfsr_f[18]^lfsr_f[19]^lfsr_f[21]^lfsr_f[22]^lfsr_f[28]^lfsr_f[29]^lfsr_f[31]^lfsr_f[33]^lfsr_f[36]^lfsr_f[37]^lfsr_f[38] ;
  out_nxt[26] = lfsr_f[0]^lfsr_f[3]^lfsr_f[4]^lfsr_f[6]^lfsr_f[10]^lfsr_f[18]^lfsr_f[19]^lfsr_f[20]^lfsr_f[22]^lfsr_f[23]^lfsr_f[24]^lfsr_f[25]^lfsr_f[26]^lfsr_f[28]^lfsr_f[31]^lfsr_f[38]^lfsr_f[39] ;
  out_nxt[27] = lfsr_f[1]^lfsr_f[4]^lfsr_f[5]^lfsr_f[7]^lfsr_f[11]^lfsr_f[19]^lfsr_f[20]^lfsr_f[21]^lfsr_f[23]^lfsr_f[24]^lfsr_f[25]^lfsr_f[26]^lfsr_f[27]^lfsr_f[29]^lfsr_f[32]^lfsr_f[39] ;
  out_nxt[28] = lfsr_f[2]^lfsr_f[5]^lfsr_f[6]^lfsr_f[8]^lfsr_f[12]^lfsr_f[20]^lfsr_f[21]^lfsr_f[22]^lfsr_f[24]^lfsr_f[25]^lfsr_f[26]^lfsr_f[27]^lfsr_f[28]^lfsr_f[30]^lfsr_f[33] ;
  out_nxt[29] = lfsr_f[3]^lfsr_f[6]^lfsr_f[7]^lfsr_f[9]^lfsr_f[13]^lfsr_f[21]^lfsr_f[22]^lfsr_f[23]^lfsr_f[25]^lfsr_f[26]^lfsr_f[27]^lfsr_f[28]^lfsr_f[29]^lfsr_f[31]^lfsr_f[34] ;
  out_nxt[30] = lfsr_f[4]^lfsr_f[7]^lfsr_f[8]^lfsr_f[10]^lfsr_f[14]^lfsr_f[22]^lfsr_f[23]^lfsr_f[24]^lfsr_f[26]^lfsr_f[27]^lfsr_f[28]^lfsr_f[29]^lfsr_f[30]^lfsr_f[32]^lfsr_f[35] ;
  out_nxt[31] = lfsr_f[5]^lfsr_f[8]^lfsr_f[9]^lfsr_f[11]^lfsr_f[15]^lfsr_f[23]^lfsr_f[24]^lfsr_f[25]^lfsr_f[27]^lfsr_f[28]^lfsr_f[29]^lfsr_f[30]^lfsr_f[31]^lfsr_f[33]^lfsr_f[36] ;
end
endmodule
