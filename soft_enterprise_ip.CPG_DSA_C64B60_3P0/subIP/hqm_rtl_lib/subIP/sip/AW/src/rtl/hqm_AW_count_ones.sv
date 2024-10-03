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
// AW_count_ones
//
// This module is a wrapper for the Synopsys DesignWare DWF_dp_count_ones component
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_count_ones
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2

	,parameter ZWIDTH	= (AW_logb2(WIDTH)+1)
) (
	 input	logic	[WIDTH-1:0]	a
	,output	logic	[ZWIDTH-1:0]	z
);


//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>=1) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>=1) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

logic [ZWIDTH-1:0] z_int;

always_comb
begin
  z_int = 0;
  for (int i = 0 ; i < WIDTH ; i = i+1) begin
    if ( ZWIDTH == 1 ) begin
      if (a[i]) z_int = z_int + 1'b1 ;
    end else begin
      if (a[i]) z_int = z_int + {{(ZWIDTH-1){1'b0}},1'b1};
    end
  end
end

assign z = z_int[ZWIDTH-1:0];

endmodule // AW_count_ones

