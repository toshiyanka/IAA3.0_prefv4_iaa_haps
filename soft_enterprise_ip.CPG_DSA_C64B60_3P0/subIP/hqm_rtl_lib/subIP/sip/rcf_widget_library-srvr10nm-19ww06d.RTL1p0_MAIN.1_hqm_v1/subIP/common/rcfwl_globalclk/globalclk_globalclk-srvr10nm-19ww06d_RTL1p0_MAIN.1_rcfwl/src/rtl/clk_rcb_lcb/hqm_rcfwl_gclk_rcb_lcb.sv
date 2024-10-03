
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
///=====================================================================================================================
///
/// rcb_lcb.sv
///
/// Place holder for RCB/LCB/LCP modules. 
/// 
/// 
/// 
/// 
///=====================================================================================================================

module hqm_rcfwl_gclk_rcb_lcb 
(
     output logic   clkout,					   
	input  logic   clk	     
); 

 
  
  // RCB
  hqm_rcfwl_gclk_make_clk_and_rcb_ph1   i_make_clk_and_rcb_ph1(
  .CkRcbX1N(clkout),
  .CkGridX1N(clk),
  .RPEn(1'b0),
  .RPOvrd(1'b0),
  .FscanClkUngate(1'b0),
  .Fd(1'b0),
  .Rd(1'b0)
  );
  
  hqm_rcfwl_gclk_make_clk_and_rcb_ph2_b i_make_clk_and_rcb_ph2_b(
  .CkRcbX2NB(), // lintra s-0214
  .CkGridX1N(clk),
  .RPEn(1'b0),
  .RPOvrd(1'b0),
  .FscanClkUngate(1'b0),
  .Fd(1'b0),
  .Rd(1'b0)
  );

  hqm_rcfwl_gclk_make_clk_and_rcb_free   i_make_clk_and_rcb_free(
  .CkRcbX1N(), // lintra s-0214
  .CkGridX1N(clk),
  .Fd(1'b0),
  .Rd(1'b0)
  );

  hqm_rcfwl_gclk_make_clk_buf_rcb_ph1    i_make_clk_buf_rcb_ph1(
  .CkRcbX1N(), // lintra s-0214
  .CkGridX1N(clk),
  .Fd(1'b0),
  .Rd(1'b0)
  );
  
  // LCB 
  hqm_rcfwl_gclk_make_lcb_loc_and i_make_lcb_loc_and(
  .CkLcbXPN(), // lintra s-0214
  .CkRcbXPN(clk),
  .FcEn(1'b0),
  .LPEn(1'b0),
  .LPOvrd(1'b0),
  .FscanClkUngate(1'b0)
  );
    
  // LCB with LCP
  hqm_rcfwl_gclk_make_lcb_lcp_loc_and i_make_lcb_lcp_loc_and(
  .CkLcbXPN(), // lintra s-0214
  .CkRcbXPN(clk),
  .FcEn(1'b0),
  .LPEn(1'b0),
  .LPOvrd(1'b0),
  .FscanClkUngate(1'b0),
  .Fd(1'b0),
  .Rd(1'b0)
  );
  
  hqm_rcfwl_gclk_make_lcb_loc_and_ph2_b i_make_lcb_loc_and_ph2_b(
  .CkLcbXPNB(), // lintra s-0214
  .CkRcbXPNB(clk),
  .FcEn(1'b0),
  .LPEn(1'b0),
  .LPOvrd(1'b0),
  .FscanClkUngate(1'b0)
  
  );
  
  // Combined RCB/LCB
  hqm_rcfwl_gclk_make_clk_rcb_lcb_ph1 i_gclk_make_clk_rcb_lcb_ph1(
  .CkLcbXPN(), // lintra s-0214
  .CkRcbXPN(), // lintra s-0214
  .CkGridX1N(clk),
  .RPEn(1'b0),
  .RPOvrd(1'b0),
  .FscanClkUngate(1'b0)
  );

  // RCB with no latch
  hqm_rcfwl_gclk_make_clk_and_rcb_nolat_ph1   i_make_clk_and_rcb_nolat_ph1(
  .CkRcbX1N(), // lintra s-0214
  .CkGridX1N(clk),
  .RcbEnL(1'b0),
  .Fd(1'b0),
  .Rd(1'b0)
  );
  
  // LCP - now in LCP repo
 // gclk_make_slcp_msff i_make_slcp_msff(
 // .Fd(), // lintra s-0214
 // .Rd(), // lintra s-0214
 // .DatOut(), // lintra s-0214
 // .DatIn(1'b0),
 // .CkLcpXPNB(1'b0)  
 // );
  
endmodule
