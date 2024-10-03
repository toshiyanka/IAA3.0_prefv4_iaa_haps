//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
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
// reset_sync_scan
//
// This module is responsible for synchronizing the reset to the current clock domain.
// The reset output of this block is asynchronously asserted, but synchronously deasserted.
// Setting fscan_rstbypen bypasses fscan_byprst_b as the synchronizer and output resets.
//
//-----------------------------------------------------------------------------------------------------

module hqm_mem_reset_sync_scan (

     input  logic       clk
    ,input  logic       rst_n

    ,input  logic       fscan_rstbypen
    ,input  logic       fscan_byprst_b

    ,output logic       rst_n_sync
) ;

logic   buf_fscan_rstbypen;
logic   buf_fscan_byprst_b;
logic   int_reset1_b;
logic   sync_reset_q2_b;

// buffer fscan and strap inputs to override timing

hqm_mem_ctech_buf buf2(.a(fscan_rstbypen), .o(buf_fscan_rstbypen));
hqm_mem_ctech_buf buf3(.a(fscan_byprst_b), .o(buf_fscan_byprst_b));

assign int_reset1_b = buf_fscan_rstbypen ? buf_fscan_byprst_b : rst_n;

hqm_mem_ctech_doublesync_rstb i_hqm_mem_ctech_doublesync (.d(1'b1), .clk(clk), .rstb(int_reset1_b), .o(sync_reset_q2_b));

assign rst_n_sync = buf_fscan_rstbypen ? buf_fscan_byprst_b : sync_reset_q2_b;

endmodule

