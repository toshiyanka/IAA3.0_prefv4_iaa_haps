// =============================================================================
// INTEL CONFIDENTIAL
// Copyright 2013 - 2016 Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the source code ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with Intel Corporation or its suppliers and licensors. The Material contains trade secrets and proprietary and confidential information of Intel or its suppliers and licensors. The Material is protected by worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
// No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication, inducement, estoppel or otherwise. Any license under such intellectual property rights must be express and approved by Intel in writing.
// =============================================================================

module hqm_devtlb_ctech_clk_gate_te (
    input  logic    en,
    input  logic    te,
    input  logic    clk,
    output logic    clkout
);

ctech_lib_clk_gate_te ctech_clk_gate_te (.en, .te, .clk, .clkout);

endmodule : hqm_devtlb_ctech_clk_gate_te

module hqm_devtlb_ctech_clk_gate_te_rstb (
    input  logic    en,
    input  logic    te,
    input  logic    rstb,
    input  logic    clk,
    output logic    clkout
);

ctech_lib_clk_gate_te_rstb ctech_clk_gate_te_rstb (.en, .te, .rstb, .clk, .clkout);

endmodule : hqm_devtlb_ctech_clk_gate_te_rstb

module hqm_devtlb_ctech_mux_2to1 (
    input  logic    d1,
    input  logic    d2,
    input  logic    s,
    output logic    o
);

ctech_lib_mux_2to1 ctech_mux_2to1 (.d1, .d2, .s, .o);
    
endmodule : hqm_devtlb_ctech_mux_2to1

