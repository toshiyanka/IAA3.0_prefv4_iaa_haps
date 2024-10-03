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

module hqm_AW_rf
       import hqm_AW_pkg::*; #(

	 parameter DEPTH	= 16
	,parameter WIDTH	= 32

	,parameter AWIDTH	= (AW_logb2(DEPTH-1)+1)
) (

	 input	logic			wclk
	,input	logic			we
	,input	logic	[AWIDTH-1:0]	waddr
	,input	logic	[WIDTH-1:0]	wdata

	,input	logic			rclk
	,input	logic	[AWIDTH-1:0]	raddr
	,input	logic			re

	,output	logic	[WIDTH-1:0]	rdata
);


//-----------------------------------------------------------------------------------------------------

logic	[WIDTH-1:0]	mem[DEPTH-1:0];

always_ff @(posedge wclk) begin
 if (we) mem[waddr] <= wdata;
end

always_ff @(posedge rclk) begin
 if (re) rdata <= mem[raddr];
end

endmodule // AW_rf

