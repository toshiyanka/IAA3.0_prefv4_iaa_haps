//

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
module hqm_rcfwl_dft_reset_sync
  #(parameter STRAP = 0) 
   (
    input logic  clk_in,
    input logic  rst_b,
    input logic  fscan_rstbyp_sel,
    input logic  fscan_byprst_b,  // to be connected to either fscan_byplatrst_b or fscan_byprst_b
    output logic synced_rst_b
    );

   // buffer fscan and strap inputs to override timing
   logic        buf_fscan_rstbyp_sel;
   logic        buf_fscan_byprst_b;
   
   hqm_rcfwl_ctech_buf buf2(.a(fscan_rstbyp_sel), .o(buf_fscan_rstbyp_sel));
   hqm_rcfwl_ctech_buf buf3(.a(fscan_byprst_b),   .o(buf_fscan_byprst_b));
 
generate
   if (STRAP == 1)
     begin : rst_mux
        // o = s ? d1 : d2
        hqm_rcfwl_ctech_mux_2to1 mux3(.d1(buf_fscan_byprst_b), .d2(rst_b), .s(buf_fscan_rstbyp_sel), .o(synced_rst_b));
     end
   else if (STRAP == 2)
     begin : rst_sync_all
        hqm_rcfwl_ctech_doublesync dsync(.d(rst_b), .clk(clk_in), .o(synced_rst_b));
     end
   else
     begin : rst_sync_deassert     
        logic   int_reset1_b;
        logic   sync_reset_q2_b; 
        // o = s ? d1 : d2
        hqm_rcfwl_ctech_mux_2to1 mux1(.d1(buf_fscan_byprst_b), .d2(rst_b), .s(buf_fscan_rstbyp_sel), .o(int_reset1_b));
        hqm_rcfwl_ctech_doublesync_rstb dsync(.d(1'b1), .clk(clk_in), .rstb(int_reset1_b), .o(sync_reset_q2_b));
        hqm_rcfwl_ctech_mux_2to1 mux3(.d1(buf_fscan_byprst_b), .d2(sync_reset_q2_b), .s(buf_fscan_rstbyp_sel), .o(synced_rst_b));
     end // block: rst_sync
     
endgenerate

endmodule
