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
// AW_flop_set
//
// This module is responsible for instantiating a single flipflop with default value of 1.
//
//-----------------------------------------------------------------------------------------------------

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_AW_flop_set (
         input  logic       clk
        ,input  logic       rst_n
        ,input  logic       data

        ,output logic       data_q
);

//-----------------------------------------------------------------------------------------------------

always_ff @(posedge clk or negedge rst_n) if (~rst_n) data_q <= '1; else data_q <= data;

endmodule // AW_flop_set

