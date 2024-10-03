//

//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2015 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//  rcfwl_fuse_hip_glue.sv
//  DESIGNER    :shivamgu
//  DATE : March 2018
//------------------------------------------------------------------------------

module hqm_rcfwl_fuse_hip_glue
 #(
	parameter [14:0] ROM_MAX_ADDR	=	15'hFF
  )
(
	input	logic	[15:0]	fuse_address,
	input	logic	[35:0]	fuse_readdata,
	input	logic		fscan_mode,
	input	logic		glue_en_strap,
	output	logic	[15:0]	fuse_address_out,
	output	logic	[35:0]	fuse_readdata_out
         );

logic	[35:0]	fuse_data_muxed;
logic	[35:0]	canary_or_data;
logic		addr_in_rom;
logic		canary_zero_sel;
logic		canary_one_sel;
logic	[15:0]	fuse_addr_int;
logic	[35:0]	fuse_readdata_scan;
logic		fscan_mode_b;

assign	fscan_mode_b	= ~fscan_mode;
assign	addr_in_rom	= (fuse_address[14:0] > ROM_MAX_ADDR) ? 1'b0 : 1'b1;
assign	canary_zero_sel	= ((fuse_address[15] == 1) && (fuse_address[4:0] == 5))? 1'b1: 1'b0;
assign	canary_one_sel	= ((fuse_address[15] == 1) && (fuse_address[4:0] == 6))? 1'b1: 1'b0;
assign	fuse_addr_int	= {16{addr_in_rom}} & fuse_address;

assign	canary_or_data		= canary_one_sel ? 36'hfffffffff : (canary_zero_sel ? 36'h0 : 36'h800000000);
assign	fuse_data_muxed		= addr_in_rom ? fuse_readdata : canary_or_data; 
assign	fuse_readdata_scan	= fuse_data_muxed & {36{fscan_mode_b}};	

//Glue disable logic
assign	fuse_address_out	= glue_en_strap ? fuse_addr_int : fuse_address;
assign	fuse_readdata_out	= glue_en_strap ? fuse_readdata_scan : fuse_readdata;
	
endmodule
