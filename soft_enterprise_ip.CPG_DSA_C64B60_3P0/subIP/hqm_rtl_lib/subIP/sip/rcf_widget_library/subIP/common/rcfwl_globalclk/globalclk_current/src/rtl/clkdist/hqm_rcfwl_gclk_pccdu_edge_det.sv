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
module hqm_rcfwl_gclk_pccdu_edge_det 
   (
	
  input	    logic  	adop_postclk_free,
  input	    logic  	fdop_preclk_div_sync,
  output	logic  	fdop_preclk_div_sync_edge
);

logic fdop_preclk_div_sync_reg;

always_ff @(posedge adop_postclk_free) begin
	fdop_preclk_div_sync_reg <= fdop_preclk_div_sync ;
    end
 
    // on rising edge of the sync, generate a reset pulse
    assign fdop_preclk_div_sync_edge = (fdop_preclk_div_sync & (~fdop_preclk_div_sync_reg)) ;

endmodule
