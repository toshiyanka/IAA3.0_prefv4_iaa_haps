//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// hqm_system_visa_block
//
// This module is responsible for flopping (and synchronizing some) top-level hqm_system signals.
//
//-----------------------------------------------------------------------------------------------------

module hqm_system_visa_block

    import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*;
(
     input  logic           hqm_inp_gated_clk

    ,input  logic [31:0]    hqm_system_visa_in

    ,output logic [31:0]    hqm_system_visa_out
);

//--------------------------------------------------------------------------------------- 
// Synchronizers 
 
//---------------------------------------------------------------------------------------
// Flops

always_ff @(posedge hqm_inp_gated_clk) begin
  hqm_system_visa_out <= hqm_system_visa_in;
end

endmodule // hqm_system_visa_block

