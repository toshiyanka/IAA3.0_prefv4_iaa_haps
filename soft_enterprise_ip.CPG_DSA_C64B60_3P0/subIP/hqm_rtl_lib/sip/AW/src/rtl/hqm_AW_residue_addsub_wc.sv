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
// hqm_AW_residue_addsub_wc : Conditional 2-bit residue adder or subtractor with carry adjust.
// sub=0: add,  sub=1: sub (b minus a)
// Inputs are residues so result may be incorrect if either input is 3.
// The carry input indicates that in the parent logic, where the two residue-protected numbers were
// added/subtracted a carry/borrow out of the most significant bit occurred.  The WIDTH input parameter
// indicates the width of the residue-protected numbers in the parent logic.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_residue_addsub_wc
import hqm_AW_pkg::*; #(
    parameter WIDTH     = 2
) (
  input  logic [1:0]            a
, input  logic [1:0]            b
, input  logic                  sub
, input  logic                  carry
, output logic [1:0]            r
) ;

logic   [1:0]   r_add ;
logic   [1:0]   r_sub ;

hqm_AW_residue_add_wc # ( .WIDTH ( WIDTH ) ) i_add ( .a ( a ) , .b ( b ) , .carry ( carry ) , .r ( r_add ) ) ;
hqm_AW_residue_sub_wc # ( .WIDTH ( WIDTH ) ) i_sub ( .a ( a ) , .b ( b ) , .carry ( carry ) , .r ( r_sub ) ) ;

assign r        = ( sub ) ? r_sub : r_add ;
endmodule
