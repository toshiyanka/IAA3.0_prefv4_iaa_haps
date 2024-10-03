//
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//

`ifndef ARF132B192E1R1W0CBBEHCAA4ACW_LATCH_P_SV
`define ARF132B192E1R1W0CBBEHCAA4ACW_LATCH_P_SV

module arf132b192e1r1w0cbbehcaa4acw_latch_p #
(
  parameter CTECH = 1
)
(
  output logic o,
  input  logic d,
  input  logic clkb
);

  if (CTECH == 1) begin: ctech_latch_p
    arf132b192e1r1w0cbbehcaa4acw_ctech_latch_p latch_p_0 (.o(o),.d(d),.clkb(clkb));
  end
  else begin
    always_latch begin
      if (~clkb) begin
        o <= d;
      end
    end
  end

endmodule // arf132b192e1r1w0cbbehcaa4acw_latch_p

`endif // ARF132B192E1R1W0CBBEHCAA4ACW_LATCH_P_SV