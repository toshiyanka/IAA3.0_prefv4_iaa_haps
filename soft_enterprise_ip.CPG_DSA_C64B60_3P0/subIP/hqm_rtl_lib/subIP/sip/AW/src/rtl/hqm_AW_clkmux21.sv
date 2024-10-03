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
// AW_clkmux21
//
// This module is responsible for implementing a 2-to-1 non-inverting clock multiplexer.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkmux21
(
	 input	logic		d0
	,input	logic		d1
	,input	logic		s

	,output	logic		z
);

//-----------------------------------------------------------------------------------------------------

// collage-pragma translate_off

  hqm_AW_ctech_clk_mux_2to1 i_clk_mux_2to1 (.clk1(d1), .clk2(d0), .s(s), .clkout(z));

// collage-pragma translate_on

endmodule // AW_clkmux21

