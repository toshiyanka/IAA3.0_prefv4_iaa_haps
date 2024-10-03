// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//----------------------------------------------------------------------
//nu_ecc_pkg
//
//wiki(Overview)
// This package contains functions used to generate and check ECC values.
// The following ECC algorithms are supported:
//
// | *Name* | *Data Bits* | *ECC Bits* | *Generate* | *Check* | *Description* |
// | 72_64 | 64 | 8 | nu_ecc_72_64_gen or nu_ecc_d64_e8_gen | nu_ecc_72_64_chk or nu_ecc_d64_e8_chk | Implements the ECC algorithm used in AW_ecc and AW_ecc_check |
//endwiki
//----------------------------------------------------------------------

`ifndef NU_ECC_PKG_DEFINE
`define NU_ECC_PKG_DEFINE

package nu_ecc_pkg;

  bit [101:0] gen_d102_e8_mask[8] = '{
                             102'b101101111010100111010101010100111010101011010011010001101101001101000101001011001011100100101100101110,
                             102'b101011010111010110100010111010110100010001010101010111000101010101011100010101010101110001010101010111,
                             102'b100111110101001101101010101001101101011010011010011001101001101001100110100110100110011010011010011001,
                             102'b011110110100111100011010100111100011010011100011100011001110001110001100111000111000110011100011100011,
                             102'b111110010011111100000110011111100000111100000011111100110000001111110011000000111111001100000011111100,
                             102'b111110001111111100000001111111100000001111111100000000111111110000000011111111000000001111111100000000,
                             102'b111110000000000011111111111111100000001111111100000000000000001111111111111111000000000000000011111111,
                             102'b111110001111111100000000000000011111110000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d102_e8_mask[256] = '{
                             -1,
                             102,
                             103,
                             -1,
                             104,
                             -1,
                             -1,
                             96,
                             105,
                             -1,
                             -1,
                             17,
                             -1,
                             95,
                             16,
                             -1,
                             106,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             94,
                             107,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             108,
                             -1,
                             -1,
                             85,
                             -1,
                             84,
                             83,
                             -1,
                             -1,
                             82,
                             33,
                             -1,
                             81,
                             -1,
                             -1,
                             32,
                             -1,
                             80,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             79,
                             -1,
                             -1,
                             78,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             77,
                             -1,
                             62,
                             -1,
                             -1,
                             76,
                             -1,
                             63,
                             75,
                             -1,
                             -1,
                             74,
                             73,
                             -1,
                             72,
                             -1,
                             -1,
                             71,
                             109,
                             -1,
                             -1,
                             70,
                             -1,
                             69,
                             68,
                             -1,
                             -1,
                             67,
                             49,
                             -1,
                             66,
                             -1,
                             -1,
                             48,
                             -1,
                             65,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             64,
                             -1,
                             -1,
                             93,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             92,
                             -1,
                             46,
                             -1,
                             -1,
                             91,
                             -1,
                             47,
                             90,
                             -1,
                             -1,
                             89,
                             88,
                             -1,
                             87,
                             -1,
                             -1,
                             86,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             101,
                             100,
                             -1,
                             -1,
                             99,
                             -1,
                             98,
                             97,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d102_e8_gen()= function accepts a 102 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d102_e8_gen(bit [101:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d102_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d102_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d102_e8_chk()= function accepts a 102 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d102_e8_chk(bit [101:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [101:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [101:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d102_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d102_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d102_e8_chk[0] = (|(sb));      // error
  nu_ecc_d102_e8_chk[1] = nu_ecc_d102_e8_chk[0] & (^(sb)) & (synd_d102_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d102_e8_chk[2] = nu_ecc_d102_e8_chk[0] & ~nu_ecc_d102_e8_chk[1]; // double bit error
endfunction

  bit [9:0] gen_d10_e5_mask[5] = '{
                             10'b1100101110,
                             10'b0101010111,
                             10'b1110011001,
                             10'b1111100011,
                             10'b0111111100
                                   };

  int synd_d10_e5_mask[32] = '{
                             -1,
                             10,
                             11,
                             -1,
                             12,
                             -1,
                             -1,
                             -1,
                             13,
                             -1,
                             -1,
                             1,
                             -1,
                             9,
                             0,
                             -1,
                             14,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             8
                                   };

//wiki(Methods)
// The nu_ecc_d10_e5_gen()= function accepts a 10 bit wide data vector, calculates the ecc
// value using that data and returns the 5 bit ecc value
//endwiki
//wiki(Methods)
function bit [4:0] nu_ecc_d10_e5_gen(bit [9:0] data_in);//endwiki
  bit [4:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d10_e5_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d10_e5_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d10_e5_chk()= function accepts a 10 bit wide data vector, and an 5 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d10_e5_chk(bit [9:0] data_in,
                                           bit [4:0] ecc_in,
                                           output bit [9:0] data_out,
                                           bit [4:0] ecc_out);//endwiki
  bit [4:0] sb;
  bit [9:0] eb;
  bit [4:0] ecc_eb;

  sb = nu_ecc_d10_e5_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d10_e5_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d10_e5_chk[0] = (|(sb));      // error
  nu_ecc_d10_e5_chk[1] = nu_ecc_d10_e5_chk[0] & (^(sb)) & (synd_d10_e5_mask[sb] >= 0); // single bit error
  nu_ecc_d10_e5_chk[2] = nu_ecc_d10_e5_chk[0] & ~nu_ecc_d10_e5_chk[1]; // double bit error
endfunction

  bit [10:0] gen_d11_e5_mask[5] = '{
                             11'b11100101110,
                             11'b10101010111,
                             11'b11110011001,
                             11'b01111100011,
                             11'b00111111100
                                   };

  int synd_d11_e5_mask[32] = '{
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             10,
                             14,
                             -1,
                             -1,
                             1,
                             -1,
                             9,
                             0,
                             -1,
                             15,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             8
                                   };

//wiki(Methods)
// The nu_ecc_d11_e5_gen()= function accepts a 11 bit wide data vector, calculates the ecc
// value using that data and returns the 5 bit ecc value
//endwiki
//wiki(Methods)
function bit [4:0] nu_ecc_d11_e5_gen(bit [10:0] data_in);//endwiki
  bit [4:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d11_e5_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d11_e5_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d11_e5_chk()= function accepts a 11 bit wide data vector, and an 5 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d11_e5_chk(bit [10:0] data_in,
                                           bit [4:0] ecc_in,
                                           output bit [10:0] data_out,
                                           bit [4:0] ecc_out);//endwiki
  bit [4:0] sb;
  bit [10:0] eb;
  bit [4:0] ecc_eb;

  sb = nu_ecc_d11_e5_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d11_e5_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d11_e5_chk[0] = (|(sb));      // error
  nu_ecc_d11_e5_chk[1] = nu_ecc_d11_e5_chk[0] & (^(sb)) & (synd_d11_e5_mask[sb] >= 0); // single bit error
  nu_ecc_d11_e5_chk[2] = nu_ecc_d11_e5_chk[0] & ~nu_ecc_d11_e5_chk[1]; // double bit error
endfunction

  bit [127:0] gen_d128_e9_mask[9] = '{
                             128'b01001011110100011011010000101110101101000010111001001011110100011011010000101110010010111101000110110100001011100100101111010001,
                             128'b00010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             128'b10100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             128'b00111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             128'b11000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             128'b00000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             128'b00000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             128'b00000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             128'b11111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d128_e9_mask[512] = '{
                             -1,
                             128,
                             129,
                             -1,
                             130,
                             -1,
                             -1,
                             -1,
                             131,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             132,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             133,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             134,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             135,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             -1,
                             -1,
                             94,
                             -1,
                             -1,
                             -1,
                             -1,
                             95,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             -1,
                             -1,
                             110,
                             -1,
                             -1,
                             -1,
                             -1,
                             111,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             113,
                             -1,
                             -1,
                             -1,
                             -1,
                             112,
                             -1,
                             -1,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             -1,
                             -1,
                             136,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             122,
                             -1,
                             -1,
                             123,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             -1,
                             -1,
                             126,
                             -1,
                             -1,
                             127,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             97,
                             -1,
                             -1,
                             96,
                             -1,
                             -1,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             100,
                             -1,
                             -1,
                             101,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             84,
                             -1,
                             -1,
                             85,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             74,
                             -1,
                             -1,
                             75,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             52,
                             -1,
                             -1,
                             53,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             42,
                             -1,
                             -1,
                             43,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d128_e9_gen()= function accepts a 128 bit wide data vector, calculates the ecc
// value using that data and returns the 9 bit ecc value
//endwiki
//wiki(Methods)
function bit [8:0] nu_ecc_d128_e9_gen(bit [127:0] data_in);//endwiki
  bit [8:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d128_e9_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d128_e9_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d128_e9_chk()= function accepts a 128 bit wide data vector, and an 9 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d128_e9_chk(bit [127:0] data_in,
                                           bit [8:0] ecc_in,
                                           output bit [127:0] data_out,
                                           bit [8:0] ecc_out);//endwiki
  bit [8:0] sb;
  bit [127:0] eb;
  bit [8:0] ecc_eb;

  sb = nu_ecc_d128_e9_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d128_e9_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d128_e9_chk[0] = (|(sb));      // error
  nu_ecc_d128_e9_chk[1] = nu_ecc_d128_e9_chk[0] & (^(sb)) & (synd_d128_e9_mask[sb] >= 0); // single bit error
  nu_ecc_d128_e9_chk[2] = nu_ecc_d128_e9_chk[0] & ~nu_ecc_d128_e9_chk[1]; // double bit error
endfunction

  bit [11:0] gen_d12_e6_mask[6] = '{
                             12'b101100101110,
                             12'b010101010111,
                             12'b011010011001,
                             12'b100011100011,
                             12'b000011111100,
                             12'b111100000000
                                   };

  int synd_d12_e6_mask[64] = '{
                             -1,
                             12,
                             13,
                             -1,
                             14,
                             -1,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             16,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d12_e6_gen()= function accepts a 12 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d12_e6_gen(bit [11:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d12_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d12_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d12_e6_chk()= function accepts a 12 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d12_e6_chk(bit [11:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [11:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [11:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d12_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d12_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d12_e6_chk[0] = (|(sb));      // error
  nu_ecc_d12_e6_chk[1] = nu_ecc_d12_e6_chk[0] & (^(sb)) & (synd_d12_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d12_e6_chk[2] = nu_ecc_d12_e6_chk[0] & ~nu_ecc_d12_e6_chk[1]; // double bit error
endfunction

  bit [12:0] gen_d13_e6_mask[6] = '{
                             13'b0101100101110,
                             13'b1010101010111,
                             13'b0011010011001,
                             13'b1100011100011,
                             13'b0000011111100,
                             13'b1111100000000
                                   };

  int synd_d13_e6_mask[64] = '{
                             -1,
                             13,
                             14,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             16,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             17,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             18,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d13_e6_gen()= function accepts a 13 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d13_e6_gen(bit [12:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d13_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d13_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d13_e6_chk()= function accepts a 13 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d13_e6_chk(bit [12:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [12:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [12:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d13_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d13_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d13_e6_chk[0] = (|(sb));      // error
  nu_ecc_d13_e6_chk[1] = nu_ecc_d13_e6_chk[0] & (^(sb)) & (synd_d13_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d13_e6_chk[2] = nu_ecc_d13_e6_chk[0] & ~nu_ecc_d13_e6_chk[1]; // double bit error
endfunction

  bit [143:0] gen_d144_e9_mask[9] = '{
                             144'b101101010101011001001011110100011011010000101110101101000010111001001011110100011011010000101110010010111101000110110100001011100100101111010001,
                             144'b101010001111010100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             144'b100110101101001110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             144'b100001101100111100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             144'b100000011011111111000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             144'b011111111000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             144'b111111111000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             144'b111111111000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             144'b000000000111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d144_e9_mask[512] = '{
                             -1,
                             144,
                             145,
                             -1,
                             146,
                             -1,
                             -1,
                             -1,
                             147,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             148,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             149,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             150,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             151,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             -1,
                             -1,
                             94,
                             -1,
                             -1,
                             -1,
                             -1,
                             95,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             -1,
                             -1,
                             110,
                             -1,
                             -1,
                             -1,
                             -1,
                             111,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             143,
                             142,
                             -1,
                             -1,
                             141,
                             -1,
                             140,
                             139,
                             -1,
                             -1,
                             138,
                             113,
                             -1,
                             137,
                             -1,
                             -1,
                             112,
                             -1,
                             136,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             135,
                             -1,
                             152,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             122,
                             -1,
                             -1,
                             123,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             134,
                             -1,
                             126,
                             133,
                             -1,
                             127,
                             -1,
                             -1,
                             132,
                             131,
                             -1,
                             -1,
                             130,
                             -1,
                             129,
                             128,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             97,
                             -1,
                             -1,
                             96,
                             -1,
                             -1,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             100,
                             -1,
                             -1,
                             101,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             84,
                             -1,
                             -1,
                             85,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             74,
                             -1,
                             -1,
                             75,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             52,
                             -1,
                             -1,
                             53,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             42,
                             -1,
                             -1,
                             43,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d144_e9_gen()= function accepts a 144 bit wide data vector, calculates the ecc
// value using that data and returns the 9 bit ecc value
//endwiki
//wiki(Methods)
function bit [8:0] nu_ecc_d144_e9_gen(bit [143:0] data_in);//endwiki
  bit [8:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d144_e9_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d144_e9_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d144_e9_chk()= function accepts a 144 bit wide data vector, and an 9 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d144_e9_chk(bit [143:0] data_in,
                                           bit [8:0] ecc_in,
                                           output bit [143:0] data_out,
                                           bit [8:0] ecc_out);//endwiki
  bit [8:0] sb;
  bit [143:0] eb;
  bit [8:0] ecc_eb;

  sb = nu_ecc_d144_e9_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d144_e9_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d144_e9_chk[0] = (|(sb));      // error
  nu_ecc_d144_e9_chk[1] = nu_ecc_d144_e9_chk[0] & (^(sb)) & (synd_d144_e9_mask[sb] >= 0); // single bit error
  nu_ecc_d144_e9_chk[2] = nu_ecc_d144_e9_chk[0] & ~nu_ecc_d144_e9_chk[1]; // double bit error
endfunction

  bit [13:0] gen_d14_e6_mask[6] = '{
                             14'b00101100101110,
                             14'b01010101010111,
                             14'b10011010011001,
                             14'b11100011100011,
                             14'b00000011111100,
                             14'b11111100000000
                                   };

  int synd_d14_e6_mask[64] = '{
                             -1,
                             14,
                             15,
                             -1,
                             16,
                             -1,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             18,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             19,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d14_e6_gen()= function accepts a 14 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d14_e6_gen(bit [13:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d14_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d14_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d14_e6_chk()= function accepts a 14 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d14_e6_chk(bit [13:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [13:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [13:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d14_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d14_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d14_e6_chk[0] = (|(sb));      // error
  nu_ecc_d14_e6_chk[1] = nu_ecc_d14_e6_chk[0] & (^(sb)) & (synd_d14_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d14_e6_chk[2] = nu_ecc_d14_e6_chk[0] & ~nu_ecc_d14_e6_chk[1]; // double bit error
endfunction

  bit [14:0] gen_d15_e6_mask[6] = '{
                             15'b100101100101110,
                             15'b001010101010111,
                             15'b010011010011001,
                             15'b011100011100011,
                             15'b100000011111100,
                             15'b111111100000000
                                   };

  int synd_d15_e6_mask[64] = '{
                             -1,
                             15,
                             16,
                             -1,
                             17,
                             -1,
                             -1,
                             -1,
                             18,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             19,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             20,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d15_e6_gen()= function accepts a 15 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d15_e6_gen(bit [14:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d15_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d15_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d15_e6_chk()= function accepts a 15 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d15_e6_chk(bit [14:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [14:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [14:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d15_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d15_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d15_e6_chk[0] = (|(sb));      // error
  nu_ecc_d15_e6_chk[1] = nu_ecc_d15_e6_chk[0] & (^(sb)) & (synd_d15_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d15_e6_chk[2] = nu_ecc_d15_e6_chk[0] & ~nu_ecc_d15_e6_chk[1]; // double bit error
endfunction

  bit [15:0] gen_d16_e6_mask[6] = '{
                             16'b0100101100101110,
                             16'b0001010101010111,
                             16'b1010011010011001,
                             16'b0011100011100011,
                             16'b1100000011111100,
                             16'b1111111100000000
                                   };

  int synd_d16_e6_mask[64] = '{
                             -1,
                             16,
                             17,
                             -1,
                             18,
                             -1,
                             -1,
                             -1,
                             19,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             20,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             21,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d16_e6_gen()= function accepts a 16 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d16_e6_gen(bit [15:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d16_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d16_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d16_e6_chk()= function accepts a 16 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d16_e6_chk(bit [15:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [15:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [15:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d16_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d16_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d16_e6_chk[0] = (|(sb));      // error
  nu_ecc_d16_e6_chk[1] = nu_ecc_d16_e6_chk[0] & (^(sb)) & (synd_d16_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d16_e6_chk[2] = nu_ecc_d16_e6_chk[0] & ~nu_ecc_d16_e6_chk[1]; // double bit error
endfunction

  bit [170:0] gen_d171_e9_mask[9] = '{
                             171'b010110101001100101011010100101101010101011001001011110100011011010000101110101101000010111001001011110100011011010000101110010010111101000110110100001011100100101111010001,
                             171'b000101110101010100010111010101010001111010100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             171'b010101010011001101010101001100110101101001110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             171'b110101001111000011010100111100001101100111100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             171'b001100111111000000110011111100000011011111111000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             171'b000011111111111111110000000011111111000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             171'b111100000000000000001111111111111111000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             171'b000011111111000000001111111111111111000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             171'b111100000000111111110000000000000000111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d171_e9_mask[512] = '{
                             -1,
                             171,
                             172,
                             -1,
                             173,
                             -1,
                             -1,
                             -1,
                             174,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             175,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             176,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             177,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             178,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             166,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             165,
                             -1,
                             94,
                             -1,
                             -1,
                             164,
                             -1,
                             95,
                             163,
                             -1,
                             -1,
                             162,
                             161,
                             -1,
                             160,
                             -1,
                             -1,
                             159,
                             -1,
                             150,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             149,
                             -1,
                             110,
                             -1,
                             -1,
                             148,
                             -1,
                             111,
                             147,
                             -1,
                             -1,
                             146,
                             145,
                             -1,
                             144,
                             -1,
                             -1,
                             143,
                             142,
                             -1,
                             -1,
                             141,
                             -1,
                             140,
                             139,
                             -1,
                             -1,
                             138,
                             113,
                             -1,
                             137,
                             -1,
                             -1,
                             112,
                             -1,
                             136,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             135,
                             -1,
                             179,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             122,
                             -1,
                             -1,
                             123,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             134,
                             -1,
                             126,
                             133,
                             -1,
                             127,
                             -1,
                             -1,
                             132,
                             131,
                             -1,
                             -1,
                             130,
                             -1,
                             129,
                             128,
                             -1,
                             -1,
                             158,
                             157,
                             -1,
                             156,
                             -1,
                             -1,
                             155,
                             154,
                             -1,
                             -1,
                             97,
                             -1,
                             153,
                             96,
                             -1,
                             152,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             100,
                             -1,
                             -1,
                             101,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             151,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             170,
                             -1,
                             -1,
                             81,
                             -1,
                             169,
                             80,
                             -1,
                             168,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             84,
                             -1,
                             -1,
                             85,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             167,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             74,
                             -1,
                             -1,
                             75,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             52,
                             -1,
                             -1,
                             53,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             42,
                             -1,
                             -1,
                             43,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d171_e9_gen()= function accepts a 171 bit wide data vector, calculates the ecc
// value using that data and returns the 9 bit ecc value
//endwiki
//wiki(Methods)
function bit [8:0] nu_ecc_d171_e9_gen(bit [170:0] data_in);//endwiki
  bit [8:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d171_e9_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d171_e9_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d171_e9_chk()= function accepts a 171 bit wide data vector, and an 9 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d171_e9_chk(bit [170:0] data_in,
                                           bit [8:0] ecc_in,
                                           output bit [170:0] data_out,
                                           bit [8:0] ecc_out);//endwiki
  bit [8:0] sb;
  bit [170:0] eb;
  bit [8:0] ecc_eb;

  sb = nu_ecc_d171_e9_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d171_e9_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d171_e9_chk[0] = (|(sb));      // error
  nu_ecc_d171_e9_chk[1] = nu_ecc_d171_e9_chk[0] & (^(sb)) & (synd_d171_e9_mask[sb] >= 0); // single bit error
  nu_ecc_d171_e9_chk[2] = nu_ecc_d171_e9_chk[0] & ~nu_ecc_d171_e9_chk[1]; // double bit error
endfunction

  bit [16:0] gen_d17_e6_mask[6] = '{
                             17'b10100101100101110,
                             17'b10001010101010111,
                             17'b11010011010011001,
                             17'b10011100011100011,
                             17'b11100000011111100,
                             17'b01111111100000000
                                   };

  int synd_d17_e6_mask[64] = '{
                             -1,
                             17,
                             18,
                             -1,
                             19,
                             -1,
                             -1,
                             -1,
                             20,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             21,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             16,
                             22,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d17_e6_gen()= function accepts a 17 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d17_e6_gen(bit [16:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d17_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d17_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d17_e6_chk()= function accepts a 17 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d17_e6_chk(bit [16:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [16:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [16:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d17_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d17_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d17_e6_chk[0] = (|(sb));      // error
  nu_ecc_d17_e6_chk[1] = nu_ecc_d17_e6_chk[0] & (^(sb)) & (synd_d17_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d17_e6_chk[2] = nu_ecc_d17_e6_chk[0] & ~nu_ecc_d17_e6_chk[1]; // double bit error
endfunction

  bit [191:0] gen_d192_e9_mask[9] = '{
                             192'b011101010010101101001010110101001100101011010100101101010101011001001011110100011011010000101110101101000010111001001011110100011011010000101110010010111101000110110100001011100100101111010001,
                             192'b011010001011101010101000101110101010100010111010101010001111010100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             192'b110110101010100110011010101010011001101010101001100110101101001110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             192'b110001101010011110000110101001111000011010100111100001101100111100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             192'b110000011001111110000001100111111000000110011111100000011011111111000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             192'b110000000111111110000000011111111111111110000000011111111000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             192'b110000000111111111111111100000000000000001111111111111111000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             192'b001111111000000000000000011111111000000001111111111111111000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             192'b000000000111111111111111100000000111111110000000000000000111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d192_e9_mask[512] = '{
                             -1,
                             192,
                             193,
                             -1,
                             194,
                             -1,
                             -1,
                             -1,
                             195,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             196,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             197,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             198,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             191,
                             -1,
                             -1,
                             190,
                             199,
                             -1,
                             -1,
                             189,
                             -1,
                             188,
                             187,
                             -1,
                             -1,
                             186,
                             65,
                             -1,
                             185,
                             -1,
                             -1,
                             64,
                             -1,
                             184,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             183,
                             -1,
                             -1,
                             166,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             165,
                             -1,
                             94,
                             -1,
                             -1,
                             164,
                             -1,
                             95,
                             163,
                             -1,
                             -1,
                             162,
                             161,
                             -1,
                             160,
                             -1,
                             -1,
                             159,
                             -1,
                             150,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             149,
                             -1,
                             110,
                             -1,
                             -1,
                             148,
                             -1,
                             111,
                             147,
                             -1,
                             -1,
                             146,
                             145,
                             -1,
                             144,
                             -1,
                             -1,
                             143,
                             142,
                             -1,
                             -1,
                             141,
                             -1,
                             140,
                             139,
                             -1,
                             -1,
                             138,
                             113,
                             -1,
                             137,
                             -1,
                             -1,
                             112,
                             -1,
                             136,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             135,
                             -1,
                             200,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             122,
                             -1,
                             -1,
                             123,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             134,
                             -1,
                             126,
                             133,
                             -1,
                             127,
                             -1,
                             -1,
                             132,
                             131,
                             -1,
                             -1,
                             130,
                             -1,
                             129,
                             128,
                             -1,
                             -1,
                             158,
                             157,
                             -1,
                             156,
                             -1,
                             -1,
                             155,
                             154,
                             -1,
                             -1,
                             97,
                             -1,
                             153,
                             96,
                             -1,
                             152,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             100,
                             -1,
                             -1,
                             101,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             151,
                             -1,
                             174,
                             173,
                             -1,
                             172,
                             -1,
                             -1,
                             171,
                             170,
                             -1,
                             -1,
                             81,
                             -1,
                             169,
                             80,
                             -1,
                             168,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             84,
                             -1,
                             -1,
                             85,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             167,
                             182,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             74,
                             -1,
                             -1,
                             75,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             181,
                             -1,
                             78,
                             180,
                             -1,
                             79,
                             -1,
                             -1,
                             179,
                             178,
                             -1,
                             -1,
                             177,
                             -1,
                             176,
                             175,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             52,
                             -1,
                             -1,
                             53,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             42,
                             -1,
                             -1,
                             43,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d192_e9_gen()= function accepts a 192 bit wide data vector, calculates the ecc
// value using that data and returns the 9 bit ecc value
//endwiki
//wiki(Methods)
function bit [8:0] nu_ecc_d192_e9_gen(bit [191:0] data_in);//endwiki
  bit [8:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d192_e9_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d192_e9_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d192_e9_chk()= function accepts a 192 bit wide data vector, and an 9 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d192_e9_chk(bit [191:0] data_in,
                                           bit [8:0] ecc_in,
                                           output bit [191:0] data_out,
                                           bit [8:0] ecc_out);//endwiki
  bit [8:0] sb;
  bit [191:0] eb;
  bit [8:0] ecc_eb;

  sb = nu_ecc_d192_e9_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d192_e9_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d192_e9_chk[0] = (|(sb));      // error
  nu_ecc_d192_e9_chk[1] = nu_ecc_d192_e9_chk[0] & (^(sb)) & (synd_d192_e9_mask[sb] >= 0); // single bit error
  nu_ecc_d192_e9_chk[2] = nu_ecc_d192_e9_chk[0] & ~nu_ecc_d192_e9_chk[1]; // double bit error
endfunction

  bit [19:0] gen_d20_e6_mask[6] = '{
                             20'b01110100101100101110,
                             20'b11010001010101010111,
                             20'b11111010011010011001,
                             20'b10110011100011100011,
                             20'b10011100000011111100,
                             20'b10001111111100000000
                                   };

  int synd_d20_e6_mask[64] = '{
                             -1,
                             20,
                             21,
                             -1,
                             22,
                             -1,
                             -1,
                             18,
                             23,
                             -1,
                             -1,
                             1,
                             -1,
                             17,
                             0,
                             -1,
                             24,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             16,
                             25,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             19,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d20_e6_gen()= function accepts a 20 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d20_e6_gen(bit [19:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d20_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d20_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d20_e6_chk()= function accepts a 20 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d20_e6_chk(bit [19:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [19:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [19:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d20_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d20_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d20_e6_chk[0] = (|(sb));      // error
  nu_ecc_d20_e6_chk[1] = nu_ecc_d20_e6_chk[0] & (^(sb)) & (synd_d20_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d20_e6_chk[2] = nu_ecc_d20_e6_chk[0] & ~nu_ecc_d20_e6_chk[1]; // double bit error
endfunction

  bit [19:0] gen_d20_e7_mask[7] = '{
                             20'b11100100101111010001,
                             20'b01110001010101010111,
                             20'b10011010011010011001,
                             20'b00110011100011100011,
                             20'b11001100000011111100,
                             20'b00001111111100000000,
                             20'b00000000000011111111
                                   };

  int synd_d20_e7_mask[128] = '{
                             -1,
                             20,
                             21,
                             -1,
                             22,
                             -1,
                             -1,
                             -1,
                             23,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             24,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             25,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             26,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d20_e7_gen()= function accepts a 20 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d20_e7_gen(bit [19:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d20_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d20_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d20_e7_chk()= function accepts a 20 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d20_e7_chk(bit [19:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [19:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [19:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d20_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d20_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d20_e7_chk[0] = (|(sb));      // error
  nu_ecc_d20_e7_chk[1] = nu_ecc_d20_e7_chk[0] & (^(sb)) & (synd_d20_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d20_e7_chk[2] = nu_ecc_d20_e7_chk[0] & ~nu_ecc_d20_e7_chk[1]; // double bit error
endfunction

  bit [20:0] gen_d21_e6_mask[6] = '{
                             21'b101110100101100101110,
                             21'b011010001010101010111,
                             21'b111111010011010011001,
                             21'b110110011100011100011,
                             21'b110011100000011111100,
                             21'b110001111111100000000
                                   };

  int synd_d21_e6_mask[64] = '{
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             18,
                             24,
                             -1,
                             -1,
                             1,
                             -1,
                             17,
                             0,
                             -1,
                             25,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             16,
                             26,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             20,
                             19,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d21_e6_gen()= function accepts a 21 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d21_e6_gen(bit [20:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d21_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d21_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d21_e6_chk()= function accepts a 21 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d21_e6_chk(bit [20:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [20:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [20:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d21_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d21_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d21_e6_chk[0] = (|(sb));      // error
  nu_ecc_d21_e6_chk[1] = nu_ecc_d21_e6_chk[0] & (^(sb)) & (synd_d21_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d21_e6_chk[2] = nu_ecc_d21_e6_chk[0] & ~nu_ecc_d21_e6_chk[1]; // double bit error
endfunction

  bit [22:0] gen_d23_e6_mask[6] = '{
                             23'b01101110100101100101110,
                             23'b01011010001010101010111,
                             23'b00111111010011010011001,
                             23'b11110110011100011100011,
                             23'b11110011100000011111100,
                             23'b11110001111111100000000
                                   };

  int synd_d23_e6_mask[64] = '{
                             -1,
                             23,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             18,
                             26,
                             -1,
                             -1,
                             1,
                             -1,
                             17,
                             0,
                             -1,
                             27,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             16,
                             28,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             22,
                             -1,
                             -1,
                             21,
                             -1,
                             20,
                             19,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d23_e6_gen()= function accepts a 23 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d23_e6_gen(bit [22:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d23_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d23_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d23_e6_chk()= function accepts a 23 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d23_e6_chk(bit [22:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [22:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [22:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d23_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d23_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d23_e6_chk[0] = (|(sb));      // error
  nu_ecc_d23_e6_chk[1] = nu_ecc_d23_e6_chk[0] & (^(sb)) & (synd_d23_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d23_e6_chk[2] = nu_ecc_d23_e6_chk[0] & ~nu_ecc_d23_e6_chk[1]; // double bit error
endfunction

  bit [23:0] gen_d24_e6_mask[6] = '{
                             24'b101101110100101100101110,
                             24'b101011010001010101010111,
                             24'b100111111010011010011001,
                             24'b011110110011100011100011,
                             24'b111110011100000011111100,
                             24'b111110001111111100000000
                                   };

  int synd_d24_e6_mask[64] = '{
                             -1,
                             24,
                             25,
                             -1,
                             26,
                             -1,
                             -1,
                             18,
                             27,
                             -1,
                             -1,
                             1,
                             -1,
                             17,
                             0,
                             -1,
                             28,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             16,
                             29,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             23,
                             22,
                             -1,
                             -1,
                             21,
                             -1,
                             20,
                             19,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d24_e6_gen()= function accepts a 24 bit wide data vector, calculates the ecc
// value using that data and returns the 6 bit ecc value
//endwiki
//wiki(Methods)
function bit [5:0] nu_ecc_d24_e6_gen(bit [23:0] data_in);//endwiki
  bit [5:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d24_e6_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d24_e6_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d24_e6_chk()= function accepts a 24 bit wide data vector, and an 6 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d24_e6_chk(bit [23:0] data_in,
                                           bit [5:0] ecc_in,
                                           output bit [23:0] data_out,
                                           bit [5:0] ecc_out);//endwiki
  bit [5:0] sb;
  bit [23:0] eb;
  bit [5:0] ecc_eb;

  sb = nu_ecc_d24_e6_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d24_e6_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d24_e6_chk[0] = (|(sb));      // error
  nu_ecc_d24_e6_chk[1] = nu_ecc_d24_e6_chk[0] & (^(sb)) & (synd_d24_e6_mask[sb] >= 0); // single bit error
  nu_ecc_d24_e6_chk[2] = nu_ecc_d24_e6_chk[0] & ~nu_ecc_d24_e6_chk[1]; // double bit error
endfunction

  bit [23:0] gen_d24_e7_mask[7] = '{
                             24'b001011100100101111010001,
                             24'b010101110001010101010111,
                             24'b100110011010011010011001,
                             24'b111000110011100011100011,
                             24'b111111001100000011111100,
                             24'b000000001111111100000000,
                             24'b000000000000000011111111
                                   };

  int synd_d24_e7_mask[128] = '{
                             -1,
                             24,
                             25,
                             -1,
                             26,
                             -1,
                             -1,
                             -1,
                             27,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             28,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             29,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d24_e7_gen()= function accepts a 24 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d24_e7_gen(bit [23:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d24_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d24_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d24_e7_chk()= function accepts a 24 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d24_e7_chk(bit [23:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [23:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [23:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d24_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d24_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d24_e7_chk[0] = (|(sb));      // error
  nu_ecc_d24_e7_chk[1] = nu_ecc_d24_e7_chk[0] & (^(sb)) & (synd_d24_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d24_e7_chk[2] = nu_ecc_d24_e7_chk[0] & ~nu_ecc_d24_e7_chk[1]; // double bit error
endfunction

  bit [255:0] gen_d256_e10_mask[10] = '{
                             256'b1011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000101001011001011100100101100101110,
                             256'b0001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             256'b1010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             256'b0011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             256'b1100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             256'b1111111100000000111111110000000000000000111111110000000011111111000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             256'b1111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             256'b1111111100000000000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             256'b1111111100000000000000001111111100000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111,
                             256'b0000000011111111111111110000000011111111000000000000000011111111111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d256_e10_mask[1024] = '{
                             -1,
                             256,
                             257,
                             -1,
                             258,
                             -1,
                             -1,
                             -1,
                             259,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             260,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             261,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             262,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             263,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             -1,
                             -1,
                             94,
                             -1,
                             -1,
                             -1,
                             -1,
                             95,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             -1,
                             -1,
                             110,
                             -1,
                             -1,
                             -1,
                             -1,
                             111,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             113,
                             -1,
                             -1,
                             -1,
                             -1,
                             112,
                             -1,
                             -1,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             -1,
                             -1,
                             264,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             129,
                             -1,
                             -1,
                             -1,
                             -1,
                             128,
                             -1,
                             -1,
                             130,
                             -1,
                             131,
                             -1,
                             -1,
                             132,
                             133,
                             -1,
                             -1,
                             134,
                             -1,
                             135,
                             -1,
                             -1,
                             -1,
                             -1,
                             152,
                             -1,
                             153,
                             -1,
                             -1,
                             154,
                             155,
                             -1,
                             -1,
                             156,
                             -1,
                             157,
                             -1,
                             -1,
                             158,
                             -1,
                             -1,
                             -1,
                             -1,
                             159,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             168,
                             -1,
                             169,
                             -1,
                             -1,
                             170,
                             171,
                             -1,
                             -1,
                             172,
                             -1,
                             173,
                             -1,
                             -1,
                             174,
                             -1,
                             -1,
                             -1,
                             -1,
                             175,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             177,
                             -1,
                             -1,
                             -1,
                             -1,
                             176,
                             -1,
                             -1,
                             178,
                             -1,
                             179,
                             -1,
                             -1,
                             180,
                             181,
                             -1,
                             -1,
                             182,
                             -1,
                             183,
                             -1,
                             -1,
                             -1,
                             -1,
                             200,
                             -1,
                             201,
                             -1,
                             -1,
                             202,
                             203,
                             -1,
                             -1,
                             204,
                             -1,
                             205,
                             -1,
                             -1,
                             206,
                             -1,
                             -1,
                             -1,
                             -1,
                             207,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             209,
                             -1,
                             -1,
                             -1,
                             -1,
                             208,
                             -1,
                             -1,
                             210,
                             -1,
                             211,
                             -1,
                             -1,
                             212,
                             213,
                             -1,
                             -1,
                             214,
                             -1,
                             215,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             225,
                             -1,
                             -1,
                             -1,
                             -1,
                             224,
                             -1,
                             -1,
                             226,
                             -1,
                             227,
                             -1,
                             -1,
                             228,
                             229,
                             -1,
                             -1,
                             230,
                             -1,
                             231,
                             -1,
                             -1,
                             -1,
                             -1,
                             248,
                             -1,
                             249,
                             -1,
                             -1,
                             250,
                             251,
                             -1,
                             -1,
                             252,
                             -1,
                             253,
                             -1,
                             -1,
                             254,
                             -1,
                             -1,
                             -1,
                             -1,
                             255,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             265,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             241,
                             -1,
                             -1,
                             -1,
                             -1,
                             240,
                             -1,
                             -1,
                             242,
                             -1,
                             243,
                             -1,
                             -1,
                             244,
                             245,
                             -1,
                             -1,
                             246,
                             -1,
                             247,
                             -1,
                             -1,
                             -1,
                             -1,
                             232,
                             -1,
                             233,
                             -1,
                             -1,
                             234,
                             235,
                             -1,
                             -1,
                             236,
                             -1,
                             237,
                             -1,
                             -1,
                             238,
                             -1,
                             -1,
                             -1,
                             -1,
                             239,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             216,
                             -1,
                             217,
                             -1,
                             -1,
                             218,
                             219,
                             -1,
                             -1,
                             220,
                             -1,
                             221,
                             -1,
                             -1,
                             222,
                             -1,
                             -1,
                             -1,
                             -1,
                             223,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             193,
                             -1,
                             -1,
                             -1,
                             -1,
                             192,
                             -1,
                             -1,
                             194,
                             -1,
                             195,
                             -1,
                             -1,
                             196,
                             197,
                             -1,
                             -1,
                             198,
                             -1,
                             199,
                             -1,
                             -1,
                             -1,
                             -1,
                             184,
                             -1,
                             185,
                             -1,
                             -1,
                             186,
                             187,
                             -1,
                             -1,
                             188,
                             -1,
                             189,
                             -1,
                             -1,
                             190,
                             -1,
                             -1,
                             -1,
                             -1,
                             191,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             161,
                             -1,
                             -1,
                             -1,
                             -1,
                             160,
                             -1,
                             -1,
                             162,
                             -1,
                             163,
                             -1,
                             -1,
                             164,
                             165,
                             -1,
                             -1,
                             166,
                             -1,
                             167,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             145,
                             -1,
                             -1,
                             -1,
                             -1,
                             144,
                             -1,
                             -1,
                             146,
                             -1,
                             147,
                             -1,
                             -1,
                             148,
                             149,
                             -1,
                             -1,
                             150,
                             -1,
                             151,
                             -1,
                             -1,
                             -1,
                             -1,
                             136,
                             -1,
                             137,
                             -1,
                             -1,
                             138,
                             139,
                             -1,
                             -1,
                             140,
                             -1,
                             141,
                             -1,
                             -1,
                             142,
                             -1,
                             -1,
                             -1,
                             -1,
                             143,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             -1,
                             -1,
                             122,
                             123,
                             -1,
                             -1,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             126,
                             -1,
                             -1,
                             -1,
                             -1,
                             127,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             97,
                             -1,
                             -1,
                             -1,
                             -1,
                             96,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             -1,
                             -1,
                             100,
                             101,
                             -1,
                             -1,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             -1,
                             -1,
                             84,
                             85,
                             -1,
                             -1,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             -1,
                             -1,
                             74,
                             75,
                             -1,
                             -1,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d256_e10_gen()= function accepts a 256 bit wide data vector, calculates the ecc
// value using that data and returns the 10 bit ecc value
//endwiki
//wiki(Methods)
function bit [9:0] nu_ecc_d256_e10_gen(bit [255:0] data_in);//endwiki
  bit [9:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d256_e10_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d256_e10_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d256_e10_chk()= function accepts a 256 bit wide data vector, and an 10 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d256_e10_chk(bit [255:0] data_in,
                                           bit [9:0] ecc_in,
                                           output bit [255:0] data_out,
                                           bit [9:0] ecc_out);//endwiki
  bit [9:0] sb;
  bit [255:0] eb;
  bit [9:0] ecc_eb;

  sb = nu_ecc_d256_e10_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d256_e10_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d256_e10_chk[0] = (|(sb));      // error
  nu_ecc_d256_e10_chk[1] = nu_ecc_d256_e10_chk[0] & (^(sb)) & (synd_d256_e10_mask[sb] >= 0); // single bit error
  nu_ecc_d256_e10_chk[2] = nu_ecc_d256_e10_chk[0] & ~nu_ecc_d256_e10_chk[1]; // double bit error
endfunction

  bit [27:0] gen_d28_e7_mask[7] = '{
                             28'b0100001011100100101111010001,
                             28'b0101010101110001010101010111,
                             28'b0110100110011010011010011001,
                             28'b1000111000110011100011100011,
                             28'b0000111111001100000011111100,
                             28'b1111000000001111111100000000,
                             28'b1111000000000000000011111111
                                   };

  int synd_d28_e7_mask[128] = '{
                             -1,
                             28,
                             29,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             32,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             34,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d28_e7_gen()= function accepts a 28 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d28_e7_gen(bit [27:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d28_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d28_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d28_e7_chk()= function accepts a 28 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d28_e7_chk(bit [27:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [27:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [27:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d28_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d28_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d28_e7_chk[0] = (|(sb));      // error
  nu_ecc_d28_e7_chk[1] = nu_ecc_d28_e7_chk[0] & (^(sb)) & (synd_d28_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d28_e7_chk[2] = nu_ecc_d28_e7_chk[0] & ~nu_ecc_d28_e7_chk[1]; // double bit error
endfunction

  bit [318:0] gen_d319_e10_mask[10] = '{
                             319'b1010100101101010101010010110101010101001011010101010100111010101011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000101001011001011100100101100101110,
                             319'b0111010101010001011101010101000101110101010100010111010110100010001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             319'b0101001100110101010100110011010101010011001101010101001101101011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             319'b0100111100001101010011110000110101001111000011010100111100011010011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             319'b0011111100000011001111110000001100111111000000110011111100000111100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             319'b0000000011111111000000001111111111111111000000001111111100000001111111100000000111111110000000000000000111111110000000011111111000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             319'b0000000011111111111111110000000000000000111111111111111100000001111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             319'b1111111100000000000000001111111100000000111111111111111100000001111111100000000000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             319'b1111111100000000000000001111111100000000111111111111111100000001111111100000000000000001111111100000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111,
                             319'b0000000011111111111111110000000011111111000000000000000011111110000000011111111111111110000000011111111000000000000000011111111111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d319_e10_mask[1024] = '{
                             -1,
                             319,
                             320,
                             -1,
                             321,
                             -1,
                             -1,
                             -1,
                             322,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             323,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             324,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             325,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             326,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             -1,
                             -1,
                             94,
                             -1,
                             -1,
                             -1,
                             -1,
                             95,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             -1,
                             -1,
                             110,
                             -1,
                             -1,
                             -1,
                             -1,
                             111,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             113,
                             -1,
                             -1,
                             -1,
                             -1,
                             112,
                             -1,
                             -1,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             -1,
                             -1,
                             327,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             129,
                             -1,
                             -1,
                             -1,
                             -1,
                             128,
                             -1,
                             -1,
                             130,
                             -1,
                             131,
                             -1,
                             -1,
                             132,
                             133,
                             -1,
                             -1,
                             134,
                             -1,
                             135,
                             -1,
                             -1,
                             -1,
                             -1,
                             152,
                             -1,
                             153,
                             -1,
                             -1,
                             154,
                             155,
                             -1,
                             -1,
                             156,
                             -1,
                             157,
                             -1,
                             -1,
                             158,
                             -1,
                             -1,
                             -1,
                             -1,
                             159,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             168,
                             -1,
                             169,
                             -1,
                             -1,
                             170,
                             171,
                             -1,
                             -1,
                             172,
                             -1,
                             173,
                             -1,
                             -1,
                             174,
                             -1,
                             -1,
                             -1,
                             -1,
                             175,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             177,
                             -1,
                             -1,
                             -1,
                             -1,
                             176,
                             -1,
                             -1,
                             178,
                             -1,
                             179,
                             -1,
                             -1,
                             180,
                             181,
                             -1,
                             -1,
                             182,
                             -1,
                             183,
                             -1,
                             -1,
                             -1,
                             318,
                             200,
                             -1,
                             201,
                             -1,
                             -1,
                             202,
                             203,
                             -1,
                             -1,
                             204,
                             -1,
                             205,
                             317,
                             -1,
                             206,
                             -1,
                             -1,
                             316,
                             -1,
                             207,
                             315,
                             -1,
                             -1,
                             314,
                             313,
                             -1,
                             312,
                             -1,
                             -1,
                             311,
                             294,
                             -1,
                             -1,
                             293,
                             -1,
                             292,
                             291,
                             -1,
                             -1,
                             290,
                             209,
                             -1,
                             289,
                             -1,
                             -1,
                             208,
                             -1,
                             288,
                             210,
                             -1,
                             211,
                             -1,
                             -1,
                             212,
                             213,
                             -1,
                             -1,
                             214,
                             -1,
                             215,
                             287,
                             -1,
                             278,
                             -1,
                             -1,
                             277,
                             -1,
                             276,
                             275,
                             -1,
                             -1,
                             274,
                             225,
                             -1,
                             273,
                             -1,
                             -1,
                             224,
                             -1,
                             272,
                             226,
                             -1,
                             227,
                             -1,
                             -1,
                             228,
                             229,
                             -1,
                             -1,
                             230,
                             -1,
                             231,
                             271,
                             -1,
                             -1,
                             270,
                             248,
                             -1,
                             249,
                             -1,
                             -1,
                             250,
                             251,
                             -1,
                             -1,
                             252,
                             -1,
                             253,
                             269,
                             -1,
                             254,
                             -1,
                             -1,
                             268,
                             -1,
                             255,
                             267,
                             -1,
                             -1,
                             266,
                             265,
                             -1,
                             264,
                             -1,
                             -1,
                             263,
                             328,
                             -1,
                             -1,
                             262,
                             -1,
                             261,
                             260,
                             -1,
                             -1,
                             259,
                             241,
                             -1,
                             258,
                             -1,
                             -1,
                             240,
                             -1,
                             257,
                             242,
                             -1,
                             243,
                             -1,
                             -1,
                             244,
                             245,
                             -1,
                             -1,
                             246,
                             -1,
                             247,
                             256,
                             -1,
                             -1,
                             286,
                             232,
                             -1,
                             233,
                             -1,
                             -1,
                             234,
                             235,
                             -1,
                             -1,
                             236,
                             -1,
                             237,
                             285,
                             -1,
                             238,
                             -1,
                             -1,
                             284,
                             -1,
                             239,
                             283,
                             -1,
                             -1,
                             282,
                             281,
                             -1,
                             280,
                             -1,
                             -1,
                             279,
                             -1,
                             302,
                             216,
                             -1,
                             217,
                             -1,
                             -1,
                             218,
                             219,
                             -1,
                             -1,
                             220,
                             -1,
                             221,
                             301,
                             -1,
                             222,
                             -1,
                             -1,
                             300,
                             -1,
                             223,
                             299,
                             -1,
                             -1,
                             298,
                             297,
                             -1,
                             296,
                             -1,
                             -1,
                             295,
                             310,
                             -1,
                             -1,
                             309,
                             -1,
                             308,
                             307,
                             -1,
                             -1,
                             306,
                             193,
                             -1,
                             305,
                             -1,
                             -1,
                             192,
                             -1,
                             304,
                             194,
                             -1,
                             195,
                             -1,
                             -1,
                             196,
                             197,
                             -1,
                             -1,
                             198,
                             -1,
                             199,
                             303,
                             -1,
                             -1,
                             -1,
                             184,
                             -1,
                             185,
                             -1,
                             -1,
                             186,
                             187,
                             -1,
                             -1,
                             188,
                             -1,
                             189,
                             -1,
                             -1,
                             190,
                             -1,
                             -1,
                             -1,
                             -1,
                             191,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             161,
                             -1,
                             -1,
                             -1,
                             -1,
                             160,
                             -1,
                             -1,
                             162,
                             -1,
                             163,
                             -1,
                             -1,
                             164,
                             165,
                             -1,
                             -1,
                             166,
                             -1,
                             167,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             145,
                             -1,
                             -1,
                             -1,
                             -1,
                             144,
                             -1,
                             -1,
                             146,
                             -1,
                             147,
                             -1,
                             -1,
                             148,
                             149,
                             -1,
                             -1,
                             150,
                             -1,
                             151,
                             -1,
                             -1,
                             -1,
                             -1,
                             136,
                             -1,
                             137,
                             -1,
                             -1,
                             138,
                             139,
                             -1,
                             -1,
                             140,
                             -1,
                             141,
                             -1,
                             -1,
                             142,
                             -1,
                             -1,
                             -1,
                             -1,
                             143,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             -1,
                             -1,
                             122,
                             123,
                             -1,
                             -1,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             126,
                             -1,
                             -1,
                             -1,
                             -1,
                             127,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             97,
                             -1,
                             -1,
                             -1,
                             -1,
                             96,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             -1,
                             -1,
                             100,
                             101,
                             -1,
                             -1,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             -1,
                             -1,
                             84,
                             85,
                             -1,
                             -1,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             -1,
                             -1,
                             74,
                             75,
                             -1,
                             -1,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d319_e10_gen()= function accepts a 319 bit wide data vector, calculates the ecc
// value using that data and returns the 10 bit ecc value
//endwiki
//wiki(Methods)
function bit [9:0] nu_ecc_d319_e10_gen(bit [318:0] data_in);//endwiki
  bit [9:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d319_e10_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d319_e10_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d319_e10_chk()= function accepts a 319 bit wide data vector, and an 10 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d319_e10_chk(bit [318:0] data_in,
                                           bit [9:0] ecc_in,
                                           output bit [318:0] data_out,
                                           bit [9:0] ecc_out);//endwiki
  bit [9:0] sb;
  bit [318:0] eb;
  bit [9:0] ecc_eb;

  sb = nu_ecc_d319_e10_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d319_e10_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d319_e10_chk[0] = (|(sb));      // error
  nu_ecc_d319_e10_chk[1] = nu_ecc_d319_e10_chk[0] & (^(sb)) & (synd_d319_e10_mask[sb] >= 0); // single bit error
  nu_ecc_d319_e10_chk[2] = nu_ecc_d319_e10_chk[0] & ~nu_ecc_d319_e10_chk[1]; // double bit error
endfunction

  bit [30:0] gen_d31_e7_mask[7] = '{
                             31'b0110100001011100100101111010001,
                             31'b0010101010101110001010101010111,
                             31'b0100110100110011010011010011001,
                             31'b0111000111000110011100011100011,
                             31'b1000000111111001100000011111100,
                             31'b1111111000000001111111100000000,
                             31'b1111111000000000000000011111111
                                   };

  int synd_d31_e7_mask[128] = '{
                             -1,
                             31,
                             32,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             34,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             35,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             36,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             37,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d31_e7_gen()= function accepts a 31 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d31_e7_gen(bit [30:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d31_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d31_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d31_e7_chk()= function accepts a 31 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d31_e7_chk(bit [30:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [30:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [30:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d31_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d31_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d31_e7_chk[0] = (|(sb));      // error
  nu_ecc_d31_e7_chk[1] = nu_ecc_d31_e7_chk[0] & (^(sb)) & (synd_d31_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d31_e7_chk[2] = nu_ecc_d31_e7_chk[0] & ~nu_ecc_d31_e7_chk[1]; // double bit error
endfunction

  bit [31:0] gen_d32_e7_mask[7] = '{
                             32'b10110100001011100100101111010001,
                             32'b00010101010101110001010101010111,
                             32'b10100110100110011010011010011001,
                             32'b00111000111000110011100011100011,
                             32'b11000000111111001100000011111100,
                             32'b11111111000000001111111100000000,
                             32'b11111111000000000000000011111111
                                   };

  int synd_d32_e7_mask[128] = '{
                             -1,
                             32,
                             33,
                             -1,
                             34,
                             -1,
                             -1,
                             -1,
                             35,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             36,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             37,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             38,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d32_e7_gen()= function accepts a 32 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d32_e7_gen(bit [31:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d32_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d32_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d32_e7_chk()= function accepts a 32 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d32_e7_chk(bit [31:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [31:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [31:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d32_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d32_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d32_e7_chk[0] = (|(sb));      // error
  nu_ecc_d32_e7_chk[1] = nu_ecc_d32_e7_chk[0] & (^(sb)) & (synd_d32_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d32_e7_chk[2] = nu_ecc_d32_e7_chk[0] & ~nu_ecc_d32_e7_chk[1]; // double bit error
endfunction

  bit [367:0] gen_d368_e10_mask[10] = '{
                             368'b01010100101101010101010010110101010101001011010101010100101101010101010010110101010101001011010101010100111010101011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000110110100110100011011010011010001101101001101000101001011001011100100101100101110,
                             368'b10111010101010001011101010101000101110101010100010111010101010001011101010101000101110101010100010111010110100010001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111000101010101011100010101010101110001010101010111,
                             368'b10101001100110101010100110011010101010011001101010101001100110101010100110011010101010011001101010101001101101011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001101001101001100110100110100110011010011010011001,
                             368'b10100111100001101010011110000110101001111000011010100111100001101010011110000110101001111000011010100111100011010011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011001110001110001100111000111000110011100011100011,
                             368'b10011111100000011001111110000001100111111000000110011111100000011001111110000001100111111000000110011111100000111100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100110000001111110011000000111111001100000011111100,
                             368'b01111111100000000000000001111111100000000111111110000000011111111000000001111111111111111000000001111111100000001111111100000000111111110000000000000000111111110000000011111111000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000,
                             368'b00000000011111111111111110000000000000000111111110000000011111111111111110000000000000000111111111111111100000001111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111,
                             368'b00000000011111111000000001111111111111111000000001111111100000000000000001111111100000000111111111111111100000001111111100000000000000001111111100000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000000000000111111111111111100000000111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111,
                             368'b11111111100000000111111110000000000000000111111111111111100000000000000001111111100000000111111111111111100000001111111100000000000000001111111100000000111111111111111100000000000000001111111111111111000000001111111100000000000000001111111111111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111,
                             368'b00000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111110000000011111111111111110000000011111111000000000000000011111111111111110000000000000000111111110000000011111111111111110000000011111111000000000000000011111111000000001111111111111111000000000000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d368_e10_mask[1024] = '{
                             -1,
                             368,
                             369,
                             -1,
                             370,
                             -1,
                             -1,
                             -1,
                             371,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             372,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             373,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             374,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             375,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             66,
                             -1,
                             67,
                             -1,
                             -1,
                             68,
                             69,
                             -1,
                             -1,
                             70,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             88,
                             -1,
                             89,
                             -1,
                             -1,
                             90,
                             91,
                             -1,
                             -1,
                             92,
                             -1,
                             93,
                             -1,
                             -1,
                             94,
                             -1,
                             -1,
                             -1,
                             -1,
                             95,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             104,
                             -1,
                             105,
                             -1,
                             -1,
                             106,
                             107,
                             -1,
                             -1,
                             108,
                             -1,
                             109,
                             -1,
                             -1,
                             110,
                             -1,
                             -1,
                             -1,
                             -1,
                             111,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             113,
                             -1,
                             -1,
                             -1,
                             -1,
                             112,
                             -1,
                             -1,
                             114,
                             -1,
                             115,
                             -1,
                             -1,
                             116,
                             117,
                             -1,
                             -1,
                             118,
                             -1,
                             119,
                             -1,
                             -1,
                             376,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             129,
                             -1,
                             -1,
                             -1,
                             -1,
                             128,
                             -1,
                             -1,
                             130,
                             -1,
                             131,
                             -1,
                             -1,
                             132,
                             133,
                             -1,
                             -1,
                             134,
                             -1,
                             135,
                             367,
                             -1,
                             -1,
                             366,
                             152,
                             -1,
                             153,
                             -1,
                             -1,
                             154,
                             155,
                             -1,
                             -1,
                             156,
                             -1,
                             157,
                             365,
                             -1,
                             158,
                             -1,
                             -1,
                             364,
                             -1,
                             159,
                             363,
                             -1,
                             -1,
                             362,
                             361,
                             -1,
                             360,
                             -1,
                             -1,
                             359,
                             -1,
                             350,
                             168,
                             -1,
                             169,
                             -1,
                             -1,
                             170,
                             171,
                             -1,
                             -1,
                             172,
                             -1,
                             173,
                             349,
                             -1,
                             174,
                             -1,
                             -1,
                             348,
                             -1,
                             175,
                             347,
                             -1,
                             -1,
                             346,
                             345,
                             -1,
                             344,
                             -1,
                             -1,
                             343,
                             326,
                             -1,
                             -1,
                             325,
                             -1,
                             324,
                             323,
                             -1,
                             -1,
                             322,
                             177,
                             -1,
                             321,
                             -1,
                             -1,
                             176,
                             -1,
                             320,
                             178,
                             -1,
                             179,
                             -1,
                             -1,
                             180,
                             181,
                             -1,
                             -1,
                             182,
                             -1,
                             183,
                             319,
                             -1,
                             -1,
                             318,
                             200,
                             -1,
                             201,
                             -1,
                             -1,
                             202,
                             203,
                             -1,
                             -1,
                             204,
                             -1,
                             205,
                             317,
                             -1,
                             206,
                             -1,
                             -1,
                             316,
                             -1,
                             207,
                             315,
                             -1,
                             -1,
                             314,
                             313,
                             -1,
                             312,
                             -1,
                             -1,
                             311,
                             294,
                             -1,
                             -1,
                             293,
                             -1,
                             292,
                             291,
                             -1,
                             -1,
                             290,
                             209,
                             -1,
                             289,
                             -1,
                             -1,
                             208,
                             -1,
                             288,
                             210,
                             -1,
                             211,
                             -1,
                             -1,
                             212,
                             213,
                             -1,
                             -1,
                             214,
                             -1,
                             215,
                             287,
                             -1,
                             278,
                             -1,
                             -1,
                             277,
                             -1,
                             276,
                             275,
                             -1,
                             -1,
                             274,
                             225,
                             -1,
                             273,
                             -1,
                             -1,
                             224,
                             -1,
                             272,
                             226,
                             -1,
                             227,
                             -1,
                             -1,
                             228,
                             229,
                             -1,
                             -1,
                             230,
                             -1,
                             231,
                             271,
                             -1,
                             -1,
                             270,
                             248,
                             -1,
                             249,
                             -1,
                             -1,
                             250,
                             251,
                             -1,
                             -1,
                             252,
                             -1,
                             253,
                             269,
                             -1,
                             254,
                             -1,
                             -1,
                             268,
                             -1,
                             255,
                             267,
                             -1,
                             -1,
                             266,
                             265,
                             -1,
                             264,
                             -1,
                             -1,
                             263,
                             377,
                             -1,
                             -1,
                             262,
                             -1,
                             261,
                             260,
                             -1,
                             -1,
                             259,
                             241,
                             -1,
                             258,
                             -1,
                             -1,
                             240,
                             -1,
                             257,
                             242,
                             -1,
                             243,
                             -1,
                             -1,
                             244,
                             245,
                             -1,
                             -1,
                             246,
                             -1,
                             247,
                             256,
                             -1,
                             -1,
                             286,
                             232,
                             -1,
                             233,
                             -1,
                             -1,
                             234,
                             235,
                             -1,
                             -1,
                             236,
                             -1,
                             237,
                             285,
                             -1,
                             238,
                             -1,
                             -1,
                             284,
                             -1,
                             239,
                             283,
                             -1,
                             -1,
                             282,
                             281,
                             -1,
                             280,
                             -1,
                             -1,
                             279,
                             -1,
                             302,
                             216,
                             -1,
                             217,
                             -1,
                             -1,
                             218,
                             219,
                             -1,
                             -1,
                             220,
                             -1,
                             221,
                             301,
                             -1,
                             222,
                             -1,
                             -1,
                             300,
                             -1,
                             223,
                             299,
                             -1,
                             -1,
                             298,
                             297,
                             -1,
                             296,
                             -1,
                             -1,
                             295,
                             310,
                             -1,
                             -1,
                             309,
                             -1,
                             308,
                             307,
                             -1,
                             -1,
                             306,
                             193,
                             -1,
                             305,
                             -1,
                             -1,
                             192,
                             -1,
                             304,
                             194,
                             -1,
                             195,
                             -1,
                             -1,
                             196,
                             197,
                             -1,
                             -1,
                             198,
                             -1,
                             199,
                             303,
                             -1,
                             -1,
                             334,
                             184,
                             -1,
                             185,
                             -1,
                             -1,
                             186,
                             187,
                             -1,
                             -1,
                             188,
                             -1,
                             189,
                             333,
                             -1,
                             190,
                             -1,
                             -1,
                             332,
                             -1,
                             191,
                             331,
                             -1,
                             -1,
                             330,
                             329,
                             -1,
                             328,
                             -1,
                             -1,
                             327,
                             342,
                             -1,
                             -1,
                             341,
                             -1,
                             340,
                             339,
                             -1,
                             -1,
                             338,
                             161,
                             -1,
                             337,
                             -1,
                             -1,
                             160,
                             -1,
                             336,
                             162,
                             -1,
                             163,
                             -1,
                             -1,
                             164,
                             165,
                             -1,
                             -1,
                             166,
                             -1,
                             167,
                             335,
                             -1,
                             358,
                             -1,
                             -1,
                             357,
                             -1,
                             356,
                             355,
                             -1,
                             -1,
                             354,
                             145,
                             -1,
                             353,
                             -1,
                             -1,
                             144,
                             -1,
                             352,
                             146,
                             -1,
                             147,
                             -1,
                             -1,
                             148,
                             149,
                             -1,
                             -1,
                             150,
                             -1,
                             151,
                             351,
                             -1,
                             -1,
                             -1,
                             136,
                             -1,
                             137,
                             -1,
                             -1,
                             138,
                             139,
                             -1,
                             -1,
                             140,
                             -1,
                             141,
                             -1,
                             -1,
                             142,
                             -1,
                             -1,
                             -1,
                             -1,
                             143,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             120,
                             -1,
                             121,
                             -1,
                             -1,
                             122,
                             123,
                             -1,
                             -1,
                             124,
                             -1,
                             125,
                             -1,
                             -1,
                             126,
                             -1,
                             -1,
                             -1,
                             -1,
                             127,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             97,
                             -1,
                             -1,
                             -1,
                             -1,
                             96,
                             -1,
                             -1,
                             98,
                             -1,
                             99,
                             -1,
                             -1,
                             100,
                             101,
                             -1,
                             -1,
                             102,
                             -1,
                             103,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             82,
                             -1,
                             83,
                             -1,
                             -1,
                             84,
                             85,
                             -1,
                             -1,
                             86,
                             -1,
                             87,
                             -1,
                             -1,
                             -1,
                             -1,
                             72,
                             -1,
                             73,
                             -1,
                             -1,
                             74,
                             75,
                             -1,
                             -1,
                             76,
                             -1,
                             77,
                             -1,
                             -1,
                             78,
                             -1,
                             -1,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d368_e10_gen()= function accepts a 368 bit wide data vector, calculates the ecc
// value using that data and returns the 10 bit ecc value
//endwiki
//wiki(Methods)
function bit [9:0] nu_ecc_d368_e10_gen(bit [367:0] data_in);//endwiki
  bit [9:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d368_e10_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d368_e10_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d368_e10_chk()= function accepts a 368 bit wide data vector, and an 10 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d368_e10_chk(bit [367:0] data_in,
                                           bit [9:0] ecc_in,
                                           output bit [367:0] data_out,
                                           bit [9:0] ecc_out);//endwiki
  bit [9:0] sb;
  bit [367:0] eb;
  bit [9:0] ecc_eb;

  sb = nu_ecc_d368_e10_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d368_e10_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d368_e10_chk[0] = (|(sb));      // error
  nu_ecc_d368_e10_chk[1] = nu_ecc_d368_e10_chk[0] & (^(sb)) & (synd_d368_e10_mask[sb] >= 0); // single bit error
  nu_ecc_d368_e10_chk[2] = nu_ecc_d368_e10_chk[0] & ~nu_ecc_d368_e10_chk[1]; // double bit error
endfunction

  bit [37:0] gen_d38_e7_mask[7] = '{
                             38'b10101010110100001011100100101111010001,
                             38'b01000100010101010101110001010101010111,
                             38'b11010110100110100110011010011010011001,
                             38'b00110100111000111000110011100011100011,
                             38'b00001111000000111111001100000011111100,
                             38'b00000011111111000000001111111100000000,
                             38'b11111111111111000000000000000011111111
                                   };

  int synd_d38_e7_mask[128] = '{
                             -1,
                             38,
                             39,
                             -1,
                             40,
                             -1,
                             -1,
                             -1,
                             41,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             42,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             43,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             44,
                             -1,
                             -1,
                             -1,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d38_e7_gen()= function accepts a 38 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d38_e7_gen(bit [37:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d38_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d38_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d38_e7_chk()= function accepts a 38 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d38_e7_chk(bit [37:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [37:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [37:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d38_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d38_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d38_e7_chk[0] = (|(sb));      // error
  nu_ecc_d38_e7_chk[1] = nu_ecc_d38_e7_chk[0] & (^(sb)) & (synd_d38_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d38_e7_chk[2] = nu_ecc_d38_e7_chk[0] & ~nu_ecc_d38_e7_chk[1]; // double bit error
endfunction

  bit [38:0] gen_d39_e7_mask[7] = '{
                             39'b110101010110100001011100100101111010001,
                             39'b101000100010101010101110001010101010111,
                             39'b011010110100110100110011010011010011001,
                             39'b000110100111000111000110011100011100011,
                             39'b000001111000000111111001100000011111100,
                             39'b000000011111111000000001111111100000000,
                             39'b111111111111111000000000000000011111111
                                   };

  int synd_d39_e7_mask[128] = '{
                             -1,
                             39,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             -1,
                             42,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             43,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             44,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             45,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d39_e7_gen()= function accepts a 39 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d39_e7_gen(bit [38:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d39_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d39_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d39_e7_chk()= function accepts a 39 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d39_e7_chk(bit [38:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [38:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [38:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d39_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d39_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d39_e7_chk[0] = (|(sb));      // error
  nu_ecc_d39_e7_chk[1] = nu_ecc_d39_e7_chk[0] & (^(sb)) & (synd_d39_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d39_e7_chk[2] = nu_ecc_d39_e7_chk[0] & ~nu_ecc_d39_e7_chk[1]; // double bit error
endfunction

  bit [39:0] gen_d40_e7_mask[7] = '{
                             40'b0110101010110100001011100100101111010001,
                             40'b1101000100010101010101110001010101010111,
                             40'b1011010110100110100110011010011010011001,
                             40'b1000110100111000111000110011100011100011,
                             40'b1000001111000000111111001100000011111100,
                             40'b1000000011111111000000001111111100000000,
                             40'b0111111111111111000000000000000011111111
                                   };

  int synd_d40_e7_mask[128] = '{
                             -1,
                             40,
                             41,
                             -1,
                             42,
                             -1,
                             -1,
                             -1,
                             43,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             44,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             45,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             39,
                             -1,
                             46,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d40_e7_gen()= function accepts a 40 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d40_e7_gen(bit [39:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d40_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d40_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d40_e7_chk()= function accepts a 40 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d40_e7_chk(bit [39:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [39:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [39:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d40_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d40_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d40_e7_chk[0] = (|(sb));      // error
  nu_ecc_d40_e7_chk[1] = nu_ecc_d40_e7_chk[0] & (^(sb)) & (synd_d40_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d40_e7_chk[2] = nu_ecc_d40_e7_chk[0] & ~nu_ecc_d40_e7_chk[1]; // double bit error
endfunction

  bit [46:0] gen_d47_e7_mask[7] = '{
                             47'b11010110110101010110100001011100100101111010001,
                             47'b11110101101000100010101010101110001010101010111,
                             47'b11010011011010110100110100110011010011010011001,
                             47'b11001111000110100111000111000110011100011100011,
                             47'b10111111000001111000000111111001100000011111100,
                             47'b01111111000000011111111000000001111111100000000,
                             47'b00000000111111111111111000000000000000011111111
                                   };

  int synd_d47_e7_mask[128] = '{
                             -1,
                             47,
                             48,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             50,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             51,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             46,
                             52,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             45,
                             -1,
                             14,
                             44,
                             -1,
                             15,
                             -1,
                             -1,
                             43,
                             42,
                             -1,
                             -1,
                             41,
                             -1,
                             40,
                             39,
                             -1,
                             53,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d47_e7_gen()= function accepts a 47 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d47_e7_gen(bit [46:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d47_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d47_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d47_e7_chk()= function accepts a 47 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d47_e7_chk(bit [46:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [46:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [46:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d47_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d47_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d47_e7_chk[0] = (|(sb));      // error
  nu_ecc_d47_e7_chk[1] = nu_ecc_d47_e7_chk[0] & (^(sb)) & (synd_d47_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d47_e7_chk[2] = nu_ecc_d47_e7_chk[0] & ~nu_ecc_d47_e7_chk[1]; // double bit error
endfunction

  bit [47:0] gen_d48_e7_mask[7] = '{
                             48'b111010110110101010110100001011100100101111010001,
                             48'b011110101101000100010101010101110001010101010111,
                             48'b111010011011010110100110100110011010011010011001,
                             48'b111001111000110100111000111000110011100011100011,
                             48'b010111111000001111000000111111001100000011111100,
                             48'b001111111000000011111111000000001111111100000000,
                             48'b000000000111111111111111000000000000000011111111
                                   };

  int synd_d48_e7_mask[128] = '{
                             -1,
                             48,
                             49,
                             -1,
                             50,
                             -1,
                             -1,
                             -1,
                             51,
                             -1,
                             -1,
                             17,
                             -1,
                             47,
                             16,
                             -1,
                             52,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             46,
                             53,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             45,
                             -1,
                             14,
                             44,
                             -1,
                             15,
                             -1,
                             -1,
                             43,
                             42,
                             -1,
                             -1,
                             41,
                             -1,
                             40,
                             39,
                             -1,
                             54,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d48_e7_gen()= function accepts a 48 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d48_e7_gen(bit [47:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d48_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d48_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d48_e7_chk()= function accepts a 48 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d48_e7_chk(bit [47:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [47:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [47:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d48_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d48_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d48_e7_chk[0] = (|(sb));      // error
  nu_ecc_d48_e7_chk[1] = nu_ecc_d48_e7_chk[0] & (^(sb)) & (synd_d48_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d48_e7_chk[2] = nu_ecc_d48_e7_chk[0] & ~nu_ecc_d48_e7_chk[1]; // double bit error
endfunction

  bit [49:0] gen_d50_e7_mask[7] = '{
                             50'b11111010110110101010110100001011100100101111010001,
                             50'b11011110101101000100010101010101110001010101010111,
                             50'b11111010011011010110100110100110011010011010011001,
                             50'b10111001111000110100111000111000110011100011100011,
                             50'b10010111111000001111000000111111001100000011111100,
                             50'b10001111111000000011111111000000001111111100000000,
                             50'b10000000000111111111111111000000000000000011111111
                                   };

  int synd_d50_e7_mask[128] = '{
                             -1,
                             50,
                             51,
                             -1,
                             52,
                             -1,
                             -1,
                             48,
                             53,
                             -1,
                             -1,
                             17,
                             -1,
                             47,
                             16,
                             -1,
                             54,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             46,
                             55,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             45,
                             -1,
                             14,
                             44,
                             -1,
                             15,
                             -1,
                             -1,
                             43,
                             42,
                             -1,
                             -1,
                             41,
                             -1,
                             40,
                             39,
                             -1,
                             56,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49
                                   };

//wiki(Methods)
// The nu_ecc_d50_e7_gen()= function accepts a 50 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d50_e7_gen(bit [49:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d50_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d50_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d50_e7_chk()= function accepts a 50 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d50_e7_chk(bit [49:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [49:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [49:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d50_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d50_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d50_e7_chk[0] = (|(sb));      // error
  nu_ecc_d50_e7_chk[1] = nu_ecc_d50_e7_chk[0] & (^(sb)) & (synd_d50_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d50_e7_chk[2] = nu_ecc_d50_e7_chk[0] & ~nu_ecc_d50_e7_chk[1]; // double bit error
endfunction

  bit [52:0] gen_d53_e7_mask[7] = '{
                             53'b10011111010110110101010110100001011100100101111010001,
                             53'b01011011110101101000100010101010101110001010101010111,
                             53'b00111111010011011010110100110100110011010011010011001,
                             53'b11110111001111000110100111000111000110011100011100011,
                             53'b11110010111111000001111000000111111001100000011111100,
                             53'b11110001111111000000011111111000000001111111100000000,
                             53'b11110000000000111111111111111000000000000000011111111
                                   };

  int synd_d53_e7_mask[128] = '{
                             -1,
                             53,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             48,
                             56,
                             -1,
                             -1,
                             17,
                             -1,
                             47,
                             16,
                             -1,
                             57,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             46,
                             58,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             45,
                             -1,
                             14,
                             44,
                             -1,
                             15,
                             -1,
                             -1,
                             43,
                             42,
                             -1,
                             -1,
                             41,
                             -1,
                             40,
                             39,
                             -1,
                             59,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             52,
                             51,
                             -1,
                             50,
                             -1,
                             -1,
                             49
                                   };

//wiki(Methods)
// The nu_ecc_d53_e7_gen()= function accepts a 53 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d53_e7_gen(bit [52:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d53_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d53_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d53_e7_chk()= function accepts a 53 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d53_e7_chk(bit [52:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [52:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [52:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d53_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d53_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d53_e7_chk[0] = (|(sb));      // error
  nu_ecc_d53_e7_chk[1] = nu_ecc_d53_e7_chk[0] & (^(sb)) & (synd_d53_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d53_e7_chk[2] = nu_ecc_d53_e7_chk[0] & ~nu_ecc_d53_e7_chk[1]; // double bit error
endfunction

  bit [55:0] gen_d56_e7_mask[7] = '{
                             56'b01010011111010110110101010110100001011100100101111010001,
                             56'b11101011011110101101000100010101010101110001010101010111,
                             56'b10100111111010011011010110100110100110011010011010011001,
                             56'b10011110111001111000110100111000111000110011100011100011,
                             56'b01111110010111111000001111000000111111001100000011111100,
                             56'b11111110001111111000000011111111000000001111111100000000,
                             56'b11111110000000000111111111111111000000000000000011111111
                                   };

  int synd_d56_e7_mask[128] = '{
                             -1,
                             56,
                             57,
                             -1,
                             58,
                             -1,
                             -1,
                             48,
                             59,
                             -1,
                             -1,
                             17,
                             -1,
                             47,
                             16,
                             -1,
                             60,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             46,
                             61,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             45,
                             -1,
                             14,
                             44,
                             -1,
                             15,
                             -1,
                             -1,
                             43,
                             42,
                             -1,
                             -1,
                             41,
                             -1,
                             40,
                             39,
                             -1,
                             62,
                             -1,
                             -1,
                             38,
                             -1,
                             37,
                             36,
                             -1,
                             -1,
                             35,
                             1,
                             -1,
                             34,
                             -1,
                             -1,
                             0,
                             -1,
                             33,
                             2,
                             -1,
                             3,
                             -1,
                             -1,
                             4,
                             5,
                             -1,
                             -1,
                             6,
                             -1,
                             7,
                             32,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             -1,
                             -1,
                             26,
                             27,
                             -1,
                             -1,
                             28,
                             -1,
                             29,
                             55,
                             -1,
                             30,
                             -1,
                             -1,
                             54,
                             -1,
                             31,
                             53,
                             -1,
                             -1,
                             52,
                             51,
                             -1,
                             50,
                             -1,
                             -1,
                             49
                                   };

//wiki(Methods)
// The nu_ecc_d56_e7_gen()= function accepts a 56 bit wide data vector, calculates the ecc
// value using that data and returns the 7 bit ecc value
//endwiki
//wiki(Methods)
function bit [6:0] nu_ecc_d56_e7_gen(bit [55:0] data_in);//endwiki
  bit [6:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d56_e7_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d56_e7_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d56_e7_chk()= function accepts a 56 bit wide data vector, and an 7 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d56_e7_chk(bit [55:0] data_in,
                                           bit [6:0] ecc_in,
                                           output bit [55:0] data_out,
                                           bit [6:0] ecc_out);//endwiki
  bit [6:0] sb;
  bit [55:0] eb;
  bit [6:0] ecc_eb;

  sb = nu_ecc_d56_e7_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d56_e7_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d56_e7_chk[0] = (|(sb));      // error
  nu_ecc_d56_e7_chk[1] = nu_ecc_d56_e7_chk[0] & (^(sb)) & (synd_d56_e7_mask[sb] >= 0); // single bit error
  nu_ecc_d56_e7_chk[2] = nu_ecc_d56_e7_chk[0] & ~nu_ecc_d56_e7_chk[1]; // double bit error
endfunction

  bit [55:0] gen_d56_e8_mask[8] = '{
                             56'b11010001101101001101000101001011001011100100101100101110,
                             56'b01010111000101010101011100010101010101110001010101010111,
                             56'b10011001101001101001100110100110100110011010011010011001,
                             56'b11100011001110001110001100111000111000110011100011100011,
                             56'b11111100110000001111110011000000111111001100000011111100,
                             56'b00000000111111110000000011111111000000001111111100000000,
                             56'b00000000000000001111111111111111000000000000000011111111,
                             56'b11111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d56_e8_mask[256] = '{
                             -1,
                             56,
                             57,
                             -1,
                             58,
                             -1,
                             -1,
                             -1,
                             59,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             60,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             61,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d56_e8_gen()= function accepts a 56 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d56_e8_gen(bit [55:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d56_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d56_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d56_e8_chk()= function accepts a 56 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d56_e8_chk(bit [55:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [55:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [55:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d56_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d56_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d56_e8_chk[0] = (|(sb));      // error
  nu_ecc_d56_e8_chk[1] = nu_ecc_d56_e8_chk[0] & (^(sb)) & (synd_d56_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d56_e8_chk[2] = nu_ecc_d56_e8_chk[0] & ~nu_ecc_d56_e8_chk[1]; // double bit error
endfunction

  bit [60:0] gen_d61_e8_mask[8] = '{
                             61'b1010011010001101101001101000101001011001011100100101100101110,
                             61'b1010101010111000101010101011100010101010101110001010101010111,
                             61'b0011010011001101001101001100110100110100110011010011010011001,
                             61'b1100011100011001110001110001100111000111000110011100011100011,
                             61'b0000011111100110000001111110011000000111111001100000011111100,
                             61'b1111100000000111111110000000011111111000000001111111100000000,
                             61'b1111100000000000000001111111111111111000000000000000011111111,
                             61'b0000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d61_e8_mask[256] = '{
                             -1,
                             61,
                             62,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             64,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             65,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             66,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             67,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             68,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d61_e8_gen()= function accepts a 61 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d61_e8_gen(bit [60:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d61_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d61_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d61_e8_chk()= function accepts a 61 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d61_e8_chk(bit [60:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [60:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [60:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d61_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d61_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d61_e8_chk[0] = (|(sb));      // error
  nu_ecc_d61_e8_chk[1] = nu_ecc_d61_e8_chk[0] & (^(sb)) & (synd_d61_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d61_e8_chk[2] = nu_ecc_d61_e8_chk[0] & ~nu_ecc_d61_e8_chk[1]; // double bit error
endfunction

  bit [61:0] gen_d62_e8_mask[8] = '{
                             62'b11010011010001101101001101000101001011001011100100101100101110,
                             62'b01010101010111000101010101011100010101010101110001010101010111,
                             62'b10011010011001101001101001100110100110100110011010011010011001,
                             62'b11100011100011001110001110001100111000111000110011100011100011,
                             62'b00000011111100110000001111110011000000111111001100000011111100,
                             62'b11111100000000111111110000000011111111000000001111111100000000,
                             62'b11111100000000000000001111111111111111000000000000000011111111,
                             62'b00000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d62_e8_mask[256] = '{
                             -1,
                             62,
                             63,
                             -1,
                             64,
                             -1,
                             -1,
                             -1,
                             65,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             66,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             67,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             68,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             69,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d62_e8_gen()= function accepts a 62 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d62_e8_gen(bit [61:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d62_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d62_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d62_e8_chk()= function accepts a 62 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d62_e8_chk(bit [61:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [61:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [61:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d62_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d62_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d62_e8_chk[0] = (|(sb));      // error
  nu_ecc_d62_e8_chk[1] = nu_ecc_d62_e8_chk[0] & (^(sb)) & (synd_d62_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d62_e8_chk[2] = nu_ecc_d62_e8_chk[0] & ~nu_ecc_d62_e8_chk[1]; // double bit error
endfunction

  bit [63:0] gen_d64_e8_mask[8] = '{
                             64'b1011010011010001101101001101000101001011001011100100101100101110,
                             64'b0001010101010111000101010101011100010101010101110001010101010111,
                             64'b1010011010011001101001101001100110100110100110011010011010011001,
                             64'b0011100011100011001110001110001100111000111000110011100011100011,
                             64'b1100000011111100110000001111110011000000111111001100000011111100,
                             64'b1111111100000000111111110000000011111111000000001111111100000000,
                             64'b1111111100000000000000001111111111111111000000000000000011111111,
                             64'b0000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d64_e8_mask[256] = '{
                             -1,
                             64,
                             65,
                             -1,
                             66,
                             -1,
                             -1,
                             -1,
                             67,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             68,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             69,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             70,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             71,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             49,
                             -1,
                             -1,
                             -1,
                             -1,
                             48,
                             -1,
                             -1,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             -1,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d64_e8_gen()= function accepts a 64 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d64_e8_gen(bit [63:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d64_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d64_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d64_e8_chk()= function accepts a 64 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d64_e8_chk(bit [63:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [63:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [63:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d64_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d64_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d64_e8_chk[0] = (|(sb));      // error
  nu_ecc_d64_e8_chk[1] = nu_ecc_d64_e8_chk[0] & (^(sb)) & (synd_d64_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d64_e8_chk[2] = nu_ecc_d64_e8_chk[0] & ~nu_ecc_d64_e8_chk[1]; // double bit error
endfunction

function bit [7:0] nu_ecc_72_64_gen(bit [63:0] data_in);
  nu_ecc_72_64_gen = nu_ecc_d64_e8_gen(data_in);
endfunction

function bit [2:0] nu_ecc_72_64_chk(bit [63:0] data_in, bit [7:0] ecc_in, output bit [63:0] data_out, bit [7:0] ecc_out);//endwiki
  nu_ecc_72_64_chk = nu_ecc_d64_e8_chk(data_in,ecc_in,data_out,ecc_out);
endfunction
  bit [73:0] gen_d74_e8_mask[8] = '{
                             74'b00111010101011010011010001101101001101000101001011001011100100101100101110,
                             74'b10110100010001010101010111000101010101011100010101010101110001010101010111,
                             74'b01101101011010011010011001101001101001100110100110100110011010011010011001,
                             74'b11100011010011100011100011001110001110001100111000111000110011100011100011,
                             74'b11100000111100000011111100110000001111110011000000111111001100000011111100,
                             74'b11100000001111111100000000111111110000000011111111000000001111111100000000,
                             74'b11100000001111111100000000000000001111111111111111000000000000000011111111,
                             74'b00011111110000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d74_e8_mask[256] = '{
                             -1,
                             74,
                             75,
                             -1,
                             76,
                             -1,
                             -1,
                             -1,
                             77,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             78,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             -1,
                             -1,
                             -1,
                             -1,
                             73,
                             -1,
                             72,
                             -1,
                             -1,
                             71,
                             81,
                             -1,
                             -1,
                             70,
                             -1,
                             69,
                             68,
                             -1,
                             -1,
                             67,
                             49,
                             -1,
                             66,
                             -1,
                             -1,
                             48,
                             -1,
                             65,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             64,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d74_e8_gen()= function accepts a 74 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d74_e8_gen(bit [73:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d74_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d74_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d74_e8_chk()= function accepts a 74 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d74_e8_chk(bit [73:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [73:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [73:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d74_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d74_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d74_e8_chk[0] = (|(sb));      // error
  nu_ecc_d74_e8_chk[1] = nu_ecc_d74_e8_chk[0] & (^(sb)) & (synd_d74_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d74_e8_chk[2] = nu_ecc_d74_e8_chk[0] & ~nu_ecc_d74_e8_chk[1]; // double bit error
endfunction

  bit [75:0] gen_d76_e8_mask[8] = '{
                             76'b0100111010101011010011010001101101001101000101001011001011100100101100101110,
                             76'b1010110100010001010101010111000101010101011100010101010101110001010101010111,
                             76'b1001101101011010011010011001101001101001100110100110100110011010011010011001,
                             76'b0111100011010011100011100011001110001110001100111000111000110011100011100011,
                             76'b1111100000111100000011111100110000001111110011000000111111001100000011111100,
                             76'b1111100000001111111100000000111111110000000011111111000000001111111100000000,
                             76'b1111100000001111111100000000000000001111111111111111000000000000000011111111,
                             76'b0000011111110000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d76_e8_mask[256] = '{
                             -1,
                             76,
                             77,
                             -1,
                             78,
                             -1,
                             -1,
                             -1,
                             79,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             80,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             81,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             82,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             -1,
                             -1,
                             63,
                             75,
                             -1,
                             -1,
                             74,
                             73,
                             -1,
                             72,
                             -1,
                             -1,
                             71,
                             83,
                             -1,
                             -1,
                             70,
                             -1,
                             69,
                             68,
                             -1,
                             -1,
                             67,
                             49,
                             -1,
                             66,
                             -1,
                             -1,
                             48,
                             -1,
                             65,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             64,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d76_e8_gen()= function accepts a 76 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d76_e8_gen(bit [75:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d76_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d76_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d76_e8_chk()= function accepts a 76 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d76_e8_chk(bit [75:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [75:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [75:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d76_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d76_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d76_e8_chk[0] = (|(sb));      // error
  nu_ecc_d76_e8_chk[1] = nu_ecc_d76_e8_chk[0] & (^(sb)) & (synd_d76_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d76_e8_chk[2] = nu_ecc_d76_e8_chk[0] & ~nu_ecc_d76_e8_chk[1]; // double bit error
endfunction

function bit [7:0] nu_ecc_84_76_gen(bit [75:0] data_in);
  nu_ecc_84_76_gen = nu_ecc_d76_e8_gen(data_in);
endfunction

function bit [2:0] nu_ecc_84_76_chk(bit [75:0] data_in, bit [7:0] ecc_in, output bit [75:0] data_out, bit [7:0] ecc_out);//endwiki
  nu_ecc_84_76_chk = nu_ecc_d76_e8_chk(data_in,ecc_in,data_out,ecc_out);
endfunction
  bit [76:0] gen_d77_e8_mask[8] = '{
                             77'b10100111010101011010011010001101101001101000101001011001011100100101100101110,
                             77'b11010110100010001010101010111000101010101011100010101010101110001010101010111,
                             77'b01001101101011010011010011001101001101001100110100110100110011010011010011001,
                             77'b00111100011010011100011100011001110001110001100111000111000110011100011100011,
                             77'b11111100000111100000011111100110000001111110011000000111111001100000011111100,
                             77'b11111100000001111111100000000111111110000000011111111000000001111111100000000,
                             77'b11111100000001111111100000000000000001111111111111111000000000000000011111111,
                             77'b00000011111110000000011111111111111110000000011111111000000000000000011111111
                                   };

  int synd_d77_e8_mask[256] = '{
                             -1,
                             77,
                             78,
                             -1,
                             79,
                             -1,
                             -1,
                             -1,
                             80,
                             -1,
                             -1,
                             17,
                             -1,
                             -1,
                             16,
                             -1,
                             81,
                             -1,
                             -1,
                             18,
                             -1,
                             19,
                             20,
                             -1,
                             -1,
                             21,
                             22,
                             -1,
                             23,
                             -1,
                             -1,
                             -1,
                             82,
                             -1,
                             -1,
                             8,
                             -1,
                             9,
                             10,
                             -1,
                             -1,
                             11,
                             12,
                             -1,
                             13,
                             -1,
                             -1,
                             -1,
                             -1,
                             14,
                             -1,
                             -1,
                             15,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             83,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             33,
                             -1,
                             -1,
                             -1,
                             -1,
                             32,
                             -1,
                             -1,
                             34,
                             -1,
                             35,
                             -1,
                             -1,
                             36,
                             37,
                             -1,
                             -1,
                             38,
                             -1,
                             39,
                             -1,
                             -1,
                             -1,
                             -1,
                             56,
                             -1,
                             57,
                             -1,
                             -1,
                             58,
                             59,
                             -1,
                             -1,
                             60,
                             -1,
                             61,
                             -1,
                             -1,
                             62,
                             -1,
                             -1,
                             76,
                             -1,
                             63,
                             75,
                             -1,
                             -1,
                             74,
                             73,
                             -1,
                             72,
                             -1,
                             -1,
                             71,
                             84,
                             -1,
                             -1,
                             70,
                             -1,
                             69,
                             68,
                             -1,
                             -1,
                             67,
                             49,
                             -1,
                             66,
                             -1,
                             -1,
                             48,
                             -1,
                             65,
                             50,
                             -1,
                             51,
                             -1,
                             -1,
                             52,
                             53,
                             -1,
                             -1,
                             54,
                             -1,
                             55,
                             64,
                             -1,
                             -1,
                             -1,
                             40,
                             -1,
                             41,
                             -1,
                             -1,
                             42,
                             43,
                             -1,
                             -1,
                             44,
                             -1,
                             45,
                             -1,
                             -1,
                             46,
                             -1,
                             -1,
                             -1,
                             -1,
                             47,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             -1,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             24,
                             -1,
                             25,
                             26,
                             -1,
                             -1,
                             27,
                             28,
                             -1,
                             29,
                             -1,
                             -1,
                             -1,
                             -1,
                             30,
                             -1,
                             -1,
                             31,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d77_e8_gen()= function accepts a 77 bit wide data vector, calculates the ecc
// value using that data and returns the 8 bit ecc value
//endwiki
//wiki(Methods)
function bit [7:0] nu_ecc_d77_e8_gen(bit [76:0] data_in);//endwiki
  bit [7:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d77_e8_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d77_e8_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d77_e8_chk()= function accepts a 77 bit wide data vector, and an 8 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d77_e8_chk(bit [76:0] data_in,
                                           bit [7:0] ecc_in,
                                           output bit [76:0] data_out,
                                           bit [7:0] ecc_out);//endwiki
  bit [7:0] sb;
  bit [76:0] eb;
  bit [7:0] ecc_eb;

  sb = nu_ecc_d77_e8_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d77_e8_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d77_e8_chk[0] = (|(sb));      // error
  nu_ecc_d77_e8_chk[1] = nu_ecc_d77_e8_chk[0] & (^(sb)) & (synd_d77_e8_mask[sb] >= 0); // single bit error
  nu_ecc_d77_e8_chk[2] = nu_ecc_d77_e8_chk[0] & ~nu_ecc_d77_e8_chk[1]; // double bit error
endfunction

  bit [7:0] gen_d8_e5_mask[5] = '{
                             8'b00101110,
                             8'b01010111,
                             8'b10011001,
                             8'b11100011,
                             8'b11111100
                                   };

  int synd_d8_e5_mask[32] = '{
                             -1,
                             8,
                             9,
                             -1,
                             10,
                             -1,
                             -1,
                             -1,
                             11,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             12,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             -1
                                   };

//wiki(Methods)
// The nu_ecc_d8_e5_gen()= function accepts a 8 bit wide data vector, calculates the ecc
// value using that data and returns the 5 bit ecc value
//endwiki
//wiki(Methods)
function bit [4:0] nu_ecc_d8_e5_gen(bit [7:0] data_in);//endwiki
  bit [4:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d8_e5_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d8_e5_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d8_e5_chk()= function accepts a 8 bit wide data vector, and an 5 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d8_e5_chk(bit [7:0] data_in,
                                           bit [4:0] ecc_in,
                                           output bit [7:0] data_out,
                                           bit [4:0] ecc_out);//endwiki
  bit [4:0] sb;
  bit [7:0] eb;
  bit [4:0] ecc_eb;

  sb = nu_ecc_d8_e5_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d8_e5_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d8_e5_chk[0] = (|(sb));      // error
  nu_ecc_d8_e5_chk[1] = nu_ecc_d8_e5_chk[0] & (^(sb)) & (synd_d8_e5_mask[sb] >= 0); // single bit error
  nu_ecc_d8_e5_chk[2] = nu_ecc_d8_e5_chk[0] & ~nu_ecc_d8_e5_chk[1]; // double bit error
endfunction

  bit [8:0] gen_d9_e5_mask[5] = '{
                             9'b100101110,
                             9'b101010111,
                             9'b110011001,
                             9'b111100011,
                             9'b111111100
                                   };

  int synd_d9_e5_mask[32] = '{
                             -1,
                             9,
                             10,
                             -1,
                             11,
                             -1,
                             -1,
                             -1,
                             12,
                             -1,
                             -1,
                             1,
                             -1,
                             -1,
                             0,
                             -1,
                             13,
                             -1,
                             -1,
                             2,
                             -1,
                             3,
                             4,
                             -1,
                             -1,
                             5,
                             6,
                             -1,
                             7,
                             -1,
                             -1,
                             8
                                   };

//wiki(Methods)
// The nu_ecc_d9_e5_gen()= function accepts a 9 bit wide data vector, calculates the ecc
// value using that data and returns the 5 bit ecc value
//endwiki
//wiki(Methods)
function bit [4:0] nu_ecc_d9_e5_gen(bit [8:0] data_in);//endwiki
  bit [4:0] ecc;

  foreach (ecc[i]) begin
    ecc[i] = ^(gen_d9_e5_mask[i] & data_in);

    if ((i == 2) || (i == 3))
      ecc[i] ^= 1;
  end

  nu_ecc_d9_e5_gen = ecc;
endfunction

//wiki(Methods)
// The =nu_ecc_d9_e5_chk()= function accepts a 9 bit wide data vector, and an 5 bit ecc
// vector. It checks the integrity of the combined data, returning an error indication,
// corrected data, and the ecc output. The return value of this function is a 3 bit vector.
// The bits are defined as follows:
//
// | *Bit* | *Definition* |
// | 0 | Error detected |
// | 1 | Single bit error detected |
// | 2 | Double bit error detected |
//endwiki
//wiki(Methods)
function bit [2:0] nu_ecc_d9_e5_chk(bit [8:0] data_in,
                                           bit [4:0] ecc_in,
                                           output bit [8:0] data_out,
                                           bit [4:0] ecc_out);//endwiki
  bit [4:0] sb;
  bit [8:0] eb;
  bit [4:0] ecc_eb;

  sb = nu_ecc_d9_e5_gen(data_in);
  sb ^= ecc_in;

  foreach (eb[i]) begin
    eb[i] = 1;
    foreach (sb[j]) begin
      eb[i] &= (~gen_d9_e5_mask[j][i] ^ sb[j]);
    end
  end

  foreach (ecc_eb[i]) begin
    ecc_eb[i] = 1;
    foreach (sb[j]) begin
      ecc_eb[i] &= (((i == j) ? 0 : 1) ^ sb[j]);
    end
  end

  data_out = data_in ^ eb;
  ecc_out = ecc_in;

  nu_ecc_d9_e5_chk[0] = (|(sb));      // error
  nu_ecc_d9_e5_chk[1] = nu_ecc_d9_e5_chk[0] & (^(sb)) & (synd_d9_e5_mask[sb] >= 0); // single bit error
  nu_ecc_d9_e5_chk[2] = nu_ecc_d9_e5_chk[0] & ~nu_ecc_d9_e5_chk[1]; // double bit error
endfunction


endpackage : nu_ecc_pkg

`endif

