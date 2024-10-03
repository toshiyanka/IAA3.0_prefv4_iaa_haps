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
module hqm_rcfwl_ip_disable
  #(parameter INPUT_SIGNAL_POLARITY = 0) // 0 to disable active high signal, 1 to disable active low signal 
   (
    input  logic ip_disable,        // from local pma
    input  logic signal_in,         // input to be gated
    output logic signal_out         // resultant output
    );

   generate
      if (INPUT_SIGNAL_POLARITY == 1) // to disable an active low input - keep it low 
        begin : AND 
           logic ip_disable_b;
           hqm_rcfwl_ctech_lib_inv ipd_inv(.a(ip_disable), .o1(ip_disable_b));
           hqm_rcfwl_ctech_lib_and ipd_and(.a(ip_disable_b), .b(signal_in), .o(signal_out));
        end
      else                      // to disable an active high input - keep it high
        begin : OR
           hqm_rcfwl_ctech_lib_or ipd_or(.a(ip_disable), .b(signal_in), .o(signal_out));
        end
   endgenerate
endmodule // rcfwl_ipdisable

