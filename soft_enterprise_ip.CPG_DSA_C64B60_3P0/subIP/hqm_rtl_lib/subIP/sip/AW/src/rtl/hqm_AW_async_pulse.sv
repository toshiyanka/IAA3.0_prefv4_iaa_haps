//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
// AW_async_pulse
//
// This module is responsible for ensuring that a pulse is seen across a clock domain crossing.
// Since the source pulse is latched and held in the source clock domain until the pulse has been
// delivered in the destination clock domain, if another source pulse can occur within 3 source clock
// cycles after the destination pulse has been delivered, then this logic may either ignore the source
// pulse or be put into a state where ALL future source pulses are ignored.  If you believe a new
// source pulse can be generated within this hazard window, then this module should not be used, and an
// AW_async_pulses block (with appropriate width for the pulse counter) should be used instead.
//
// NUM_STAGES parameter deleted as it was unused.
// For synchronizing pulse w/ data, use hqm_AW_async_one_pulse_reg.sv
//-----------------------------------------------------------------------------------------------------

module hqm_AW_async_pulse 
        import hqm_AW_pkg::*;
(
        input   wire    clk_src,
        input   wire    rst_src_n,
        input   wire    data,

        input   wire    clk_dst,
        input   wire    rst_dst_n,
        output  wire    data_sync
);

//-----------------------------------------------------------------------------------------------------
logic out_data_nc;
logic req_active_nc;
//-----------------------------------------------------------------------------------------------------
hqm_AW_async_one_pulse_reg #(
      .WIDTH        (1)
) i_async_one_pulse_reg (
      .src_clk      (clk_src)
     ,.src_rst_n    (rst_src_n)
     ,.dst_clk      (clk_dst)
     ,.dst_rst_n    (rst_dst_n)

     ,.in_v         (data)
     ,.in_data      ('0)
     ,.out_v        (data_sync)
     ,.out_data     (out_data_nc)
     
     ,.req_active   (req_active_nc)
);
//-----------------------------------------------------------------------------------------------------
endmodule // AW_async_pulse
