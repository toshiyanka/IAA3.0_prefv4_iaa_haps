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
// AW_width_scale
//
// This module will scale an input field to a wider width output (if necessary) by padding with zeros
// or ones or to a smaller width output (if necessary) by truncating the MSBs of the input.
//
// The following parameters are supported:
//
//      A_WIDTH Width of the datapath input.
//      Z_WIDTH Width of the datapath output.
//      PAD_ONES 0-pad with zeros, 1-pad with ones.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_width_scale

         import hqm_AW_pkg::*;
#(

         parameter A_WIDTH      = 4
        ,parameter Z_WIDTH      = 32
        ,parameter PAD_ONES     = 0
) (
         input  logic   [A_WIDTH-1:0]   a

        ,output logic   [Z_WIDTH-1:0]   z
);

generate
 if (Z_WIDTH <= A_WIDTH) begin: g_truncate

  if (Z_WIDTH != A_WIDTH) begin: g_a_unused
   hqm_AW_unused_bits #(.WIDTH(A_WIDTH-Z_WIDTH)) u_unused (.a(a[A_WIDTH-1:Z_WIDTH]));
  end

  assign z = a[Z_WIDTH-1:0];

 end else begin: g_pad

  if (PAD_ONES==1) begin: g_pad_ones
    assign z = {{(Z_WIDTH-A_WIDTH){1'b1}}, a};
  end else begin: g_pad_zeros
    assign z = {{(Z_WIDTH-A_WIDTH){1'b0}}, a};
  end

 end
endgenerate

endmodule // AW_width_scale

