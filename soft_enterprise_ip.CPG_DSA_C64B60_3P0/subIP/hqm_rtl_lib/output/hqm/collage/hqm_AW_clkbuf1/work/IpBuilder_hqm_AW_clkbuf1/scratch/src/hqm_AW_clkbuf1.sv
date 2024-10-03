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
// AW_clkbuf1
//
// This module is responsible for buffering a signal through a non-inverting clock buffer.
//
// The following parameters are supported:
//
//
//-----------------------------------------------------------------------------------------------------

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_AW_clkbuf1
(
    input   logic   a 

   ,output  logic   o
);

//-----------------------------------------------------------------------------------------------------
// synopsys translate_off

hqm_AW_ctech_clk_buf i_clk_buf1 (.clk(a), .clkout(o));

// synopsys translate_on
endmodule // AW_clkbuf1

