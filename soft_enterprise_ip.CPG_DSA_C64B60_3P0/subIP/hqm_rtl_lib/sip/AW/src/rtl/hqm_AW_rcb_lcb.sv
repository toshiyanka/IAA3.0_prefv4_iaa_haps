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
// AW_rcb_lcb
//
// This module is responsible for instantiating a local RCB/LCB pair for global clock gating.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_rcb_lcb (

     input  logic       clk                 // Input clock
    ,input  logic       clk_enable          // Clock enable
    ,input  logic       cfg_clkungate       // CFG override to force ungating the clock

    ,input  logic       fscan_clkungate     // Scan control to force ungating the clock

    ,output logic       gated_clk           // Gated output clock
);

//-----------------------------------------------------------------------------------------------------

// collage-pragma translate_off

logic   clk_rcb;

// Gated RCB

hqm_gclk_make_clk_and_rcb_ph1 i_hqm_gclk_make_clk_and_rcb_ph1 (

         .CkGridX1N         (clk)                   // Input clock
        ,.FscanClkUngate    (fscan_clkungate)       // Control from Scan
        ,.RPEn              (clk_enable)            // Engine enable
        ,.RPOvrd            (cfg_clkungate)         // Override enable to force clock on 
        ,.Fd                (1'b0)                  // From LCP
        ,.Rd                (1'b0)                  // From LCP

        ,.CkRcbX1N          (clk_rcb)               // RCB output clock to LCB
);

// LCB

hqm_gclk_make_lcb_loc_and i_hqm_gclk_make_lcb_loc_and (

         .CkRcbXPN          (clk_rcb)               // Clock from RCB
        ,.FscanClkUngate    (fscan_clkungate)       // Control from Scan (not needed due to below tie offs)
        ,.FcEn              (1'b1)                  // LCB func enable tied off (control via RCB only)
        ,.LPEn              (1'b1)                  // LCB power enable tied off
        ,.LPOvrd            (1'b0)

        ,.CkLcbXPN          (gated_clk)             // LCB output clock to logic
);

// collage-pragma translate_on

endmodule // AW_rcb_lcb

