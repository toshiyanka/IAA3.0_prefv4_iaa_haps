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
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_iosf_pd_ll_ctrl_core_par
import hqm_AW_pkg::*; 
#(
  parameter DWIDTH                                = 256
, parameter PARITY                                = 8
) (
  input  logic [ ( DWIDTH ) - 1 : 0 ]             d
, input  logic                                    odd
, output logic [ ( PARITY ) - 1 : 0 ]             p
);

generate
  for ( genvar gi = 0 ; gi < PARITY ; gi = gi + 1 ) begin: L01
    hqm_AW_parity_gen # (
     .WIDTH ( DWIDTH / PARITY )
    ) i_par_gi (
      .d ( d [ ( gi * 32 ) +: 32 ] )
    , .odd ( odd )
    , .p ( p [ gi ] )
    ) ;
  end
endgenerate

endmodule

