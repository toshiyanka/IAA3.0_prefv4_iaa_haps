//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------
// AW_reverse_byte_bits
//
// This module will conditionally reverse the order of the bits in each byte of the datapath based on
// an enable.
//
// The following parameters are supported:
//
//	WIDTH	Width of the datapath input in bytes.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_reverse_byte_bits
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2 
) (
	 input	logic	[(WIDTH*8)-1:0]	a
	,input	logic			e

	,output	logic	[(WIDTH*8)-1:0]	z
);

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>0) else begin
    $display ("\nERROR: %m: Width parameter had an illegal value (WIDTH=%d).  Valid values are >0!!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

logic	[(WIDTH*8)-1:0]	a_reverse;

genvar g1,g2;

generate
 for (g1=0; g1<WIDTH; g1=g1+1) begin: loop1
  for (g2=0; g2<8; g2=g2+1) begin: loop2
   assign a_reverse[(g1*8)+g2]=a[(g1*8)+(7-g2)];
  end
 end
endgenerate

assign z = (e) ? a_reverse : a;

endmodule // AW_reverse_byte_bits

