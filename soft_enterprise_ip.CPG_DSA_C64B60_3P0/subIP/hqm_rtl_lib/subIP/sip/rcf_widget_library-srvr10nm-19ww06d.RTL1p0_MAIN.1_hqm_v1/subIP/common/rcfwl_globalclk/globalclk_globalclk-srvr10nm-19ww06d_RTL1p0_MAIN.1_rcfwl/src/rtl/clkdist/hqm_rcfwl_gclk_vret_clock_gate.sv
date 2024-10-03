
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
module hqm_rcfwl_gclk_vret_clock_gate(
	input  logic vret_iso_b,
	input  logic clk_in,
	input  logic fscan_mode,
	output logic clk_out 
	);
logic vret_iso_b_sync;
logic vret_iso_b_sync_sc;

//syncronize divider reset
hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_div_reset
                        
  (
       .d     ( vret_iso_b),
       .clk   ( clk_in ),
       .o     ( vret_iso_b_sync)
      );

hqm_rcfwl_gclk_ctech_or2_gen i_gclk_ctech_or2_gen (
                              
	.a(fscan_mode) , .b(vret_iso_b_sync) , .y(vret_iso_b_sync_sc));

//clock gate with latch
hqm_rcfwl_gclk_ctech_clk_gate_and i_gclk_ctech_clk_gate_and
    (
     .clk(clk_in),
     .en(vret_iso_b_sync_sc),
     .clkout(clk_out)
    );


endmodule 
