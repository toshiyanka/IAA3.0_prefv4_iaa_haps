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
// AW_pg_remap_field
//
// This module remaps a single field to support the "partial goods" strategy for N clusters.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_pg_remap_field
       import hqm_AW_pkg::*; #(

	 parameter N  = 4		// Number of clusters
	,parameter CN = 0		// This cluster's number
	,parameter W  = 1		// Width of fields
) (

	 input	logic	[(W*N)-1:0]	a
	,input	logic	[N-1:0]		cpv

	,output	logic	[W-1:0]		z
);

logic [(W*N)-1:0] t;

hqm_AW_pg_remap #(.N(N), .W(W), .D(1), .V(2)) i_pg_remap (.a(a), .cpv(cpv), .z(t));

assign z = t[(W*CN) +: W];

endmodule // AW_pg_remap_field

