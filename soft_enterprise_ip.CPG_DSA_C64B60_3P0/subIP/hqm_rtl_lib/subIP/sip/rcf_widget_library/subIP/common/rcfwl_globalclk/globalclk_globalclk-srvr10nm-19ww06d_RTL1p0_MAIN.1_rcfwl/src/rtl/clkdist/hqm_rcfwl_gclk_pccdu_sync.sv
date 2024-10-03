
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
module hqm_rcfwl_gclk_pccdu_sync
  (
      input  logic  x4clk_in,              
      input  logic  x1clk_in,               
      input  logic  x3clk_in, 
      input  logic  x12clk_in,               
      input  logic  x1clk_in_sync,
      input  logic  x3clk_in_sync,
      input  logic  x4clk_in_sync,
      input  logic  x12clk_in_sync,
      output logic  x4clk_out,              
      output logic  x1clk_out,              
      output logic  x3clk_out, 
      output logic  x12clk_out,              
      output logic  x1clk_out_sync,
      output logic  x3clk_out_sync,
      output logic  x4clk_out_sync,
      output logic  x12clk_out_sync
  );



   assign  x4clk_out = x4clk_in;
   assign  x1clk_out = x1clk_in;
   assign  x3clk_out = x3clk_in;
   assign  x12clk_out = x12clk_in;
   assign  x4clk_out_sync = x4clk_in_sync; 
   assign  x1clk_out_sync = x1clk_in_sync;
   assign  x3clk_out_sync = x3clk_in_sync; 
   assign  x12clk_out_sync = x12clk_in_sync;
endmodule
