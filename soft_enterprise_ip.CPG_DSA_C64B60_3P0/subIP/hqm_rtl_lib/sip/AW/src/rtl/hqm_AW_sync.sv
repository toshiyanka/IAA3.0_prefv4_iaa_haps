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
// AW_sync
//
// This module is responsible for synchronizing a signal through a synchronizer.
//
// The following parameters are supported:
//
//  WIDTH       Width of the datapath that is synchronized
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_sync

     import hqm_AW_pkg::*;
#(
     parameter WIDTH    = 1
) (
     input  logic               clk
    ,input  logic   [WIDTH-1:0] data

    ,output logic   [WIDTH-1:0] data_sync
);

//-----------------------------------------------------------------------------------------------------

genvar g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_bit

  hqm_AW_ctech_doublesync_rstb i_ctech_doublesync_rstb (

     .clk   (clk)
    ,.rstb  (1'b1)
    ,.d     (data[g])

    ,.o     (data_sync[g])
  );

 end
endgenerate

endmodule // AW_sync

