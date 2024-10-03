
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
//systemVerilog HDL for "c73p1plllcckdiv_coe73_sch", "c73p1plllcckdiv_postdiv" "systemverilog"

module hqm_rcfwl_gclk_iclk_clkpostdiv ( 
    output logic clkdivout, 
    input logic predivout, 
    input logic [3:0] ratiom3,
    input logic postdiven, 
    input logic dutycyc_50p_en
    );

logic hith;
logic hitl;

hqm_rcfwl_gclk_iclk_qdivtop icount (.ratiom3(ratiom3), .divrstb(postdiven),
     .hith(hith), .hitl(hitl),
     .dutycyc_50p_en(dutycyc_50p_en), .clkin(predivout));
hqm_rcfwl_gclk_iclk_clkdivdutycyc igenfbclk (
     .divrstb(postdiven),
     .hitl(hitl), .hith(hith), .clktoqdiv(predivout),.clkout(clkdivout));

endmodule
