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
// hqm_AW_viewpin_mux
//
// This module implements multiplexers for the viewpin outputs.  Each output can be independently
// selected from among the input signals.
//
// The following parameters are supported:
//
//   NUM_IN             Number of signals to select among for viewing
//   MUX_SEL_WIDTH      Width of mux_sel = func(NUM_IN)
//   NUM_OUT            Number of output signals
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_viewpin_mux
#(
  parameter NUM_IN              = 8
, parameter MUX_SEL_WIDTH       = 3     // Not able to derive this from NUM_IN using AW_logb2 because of collage limitation
, parameter NUM_OUT             = 2
) (
  input  logic [NUM_IN-1:0]                     mux_in
, input  logic [(NUM_OUT*MUX_SEL_WIDTH)-1:0]    mux_sel
, output logic [NUM_OUT-1:0]                    mux_out  
);

localparam NUM_IN_SCALED        = 1<<MUX_SEL_WIDTH ;

logic [NUM_IN_SCALED-1:0]       mux_in_scaled ;

always_comb begin
  mux_in_scaled                 = '0 ;
  mux_in_scaled [NUM_IN-1:0]    = mux_in ;
end

generate
  for ( genvar gi = 0 ; gi < NUM_OUT ; gi = gi + 1 ) begin: gen_view
    assign mux_out[gi]  = mux_in_scaled [mux_sel[ (gi*MUX_SEL_WIDTH) +: MUX_SEL_WIDTH ] ] ;
  end
endgenerate
endmodule // hqm_AW_viewpin_mux
