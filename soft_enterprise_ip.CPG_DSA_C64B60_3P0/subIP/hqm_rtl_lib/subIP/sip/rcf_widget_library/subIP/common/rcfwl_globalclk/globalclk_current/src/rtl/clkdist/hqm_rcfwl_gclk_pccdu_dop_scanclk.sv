//--------------------------------------------------------------------------------
// INTEL CONFIDENTIAL
//
// Copyright 2016-2017 Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the
// source code ("Material") are owned by Intel Corporation or its suppliers or
// licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and treaty
// provisions. No part of the Material may be used, copied, reproduced, modified,
// published, uploaded, posted, transmitted, distributed, or disclosed in any way
// without Intels prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be express
// and approved by Intel in writing.
//
//--------------------------------------------------------------------------------

module hqm_rcfwl_gclk_pccdu_dop_scanclk (
    // scan controls
    input  logic fscan_dop_shift_dis, // shift disable control
    input  logic fscan_rpt_clk,       // functional/scan shift output clock to partition

    // outputs
    output logic fdop_scanclk        // dop scan shift clock
  );

  logic rpt_clk_b;

  // final rpt clock AND stage (implemented as nor+inv), this is because there is no and_en flavor of clk and,
  // so this has to be implemented as nor_en to keep tools happy and map to existing ctech's.
  hqm_rcfwl_gclk_ctech_clk_inv i_clk_inv_rpt_clk(.clk(fscan_rpt_clk), .clkout(rpt_clk_b));
  hqm_rcfwl_gclk_ctech_clk_nor_en i_clk_nor_en_scanclk (.clkout(fdop_scanclk), .en(fscan_dop_shift_dis), .clk(rpt_clk_b));
endmodule
