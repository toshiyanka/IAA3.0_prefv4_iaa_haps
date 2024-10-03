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
// AW_reset_sync_scan
//
// This module is responsible for synchronizing the reset to the current clock domain.
// The reset output of this block is asynchronously asserted, but synchronously deasserted.
// Setting fscan_rstbypen bypasses fscan_byprst_b as the synchronizer and output resets.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_reset_sync_scan (
     input  logic       clk
    ,input  logic       rst_n

    ,input  logic       fscan_rstbypen
    ,input  logic       fscan_byprst_b

    ,output logic       rst_n_sync
);

//-----------------------------------------------------------------------------------------------------


hqm_rcfwl_dft_reset_sync #(.STRAP(0)) i_hqm_rcfwl_dft_reset_sync (
     .clk_in            (clk)
    ,.rst_b             (rst_n)
    ,.fscan_rstbyp_sel  (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    ,.synced_rst_b      (rst_n_sync)
);

endmodule // AW_reset_sync_scan

