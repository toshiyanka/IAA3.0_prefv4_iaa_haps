//-----------------------------------------------------------------------------------------------------
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
//
// hqm_AW_residue_add : 2-bit residue adder - inputs are residues so result may be incorrect if either
// input is 3.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_residue_add
   import hqm_AW_pkg::* ;
(
  input  logic [1:0]            a
, input  logic [1:0]            b
, output logic [1:0]            r
) ;

logic           a_z ;

assign a_z      = ( a == 2'h0 ) ;

always_comb begin
  case ( b )
    2'h0 , 2'h3 : r = a ;
    2'h1        : r = { a[0] , a_z } ;
    2'h2        : r = { a_z , a[1] } ;
  endcase
end

endmodule
