//----------------------------------------------------------------------------------------------------
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
//----------------------------------------------------------------------------------------------------
`ifndef ARF086B128E1R1W0CBBEHSAA4ACW_LATCH_PHASE_B_SV
`define ARF086B128E1R1W0CBBEHSAA4ACW_LATCH_PHASE_B_SV

module arf086b128e1r1w0cbbehsaa4acw_latch_phase_b #
(
  parameter DWIDTH = 1
)
(
  input  logic [DWIDTH-1:0] d,
  input  logic en,
  output logic [DWIDTH-1:0] q
);

always_latch begin
  if (~en) begin
    q <= d;
  end
end

endmodule // arf086b128e1r1w0cbbehsaa4acw_latch_phase_b

`endif // ARF086B128E1R1W0CBBEHSAA4ACW_LATCH_PHASE_B_SV