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

module hqm_rcfwl_gclk_pccdu_dop_clken_mux (
    // DOP functional controls
    input  logic fpm_dop_clken,       // functional clock enable

    // scan controls
    input  logic fscan_mode,          // scan mode active
    input  logic fscan_dop_clken,       // functional/scan shift output clock to partition

    // outputs
    output logic fdop_clken          // dop clock enable
  );

  hqm_rcfwl_gclk_ctech_mux_2to1 i_fdop_clken( .d1(fscan_dop_clken), .d2(fpm_dop_clken), .s(fscan_mode), .o(fdop_clken) );

endmodule
