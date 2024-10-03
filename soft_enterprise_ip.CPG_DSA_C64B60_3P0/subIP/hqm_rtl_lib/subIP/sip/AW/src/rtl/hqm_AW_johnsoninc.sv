//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
module hqm_AW_johnsoninc
  import hqm_AW_pkg::*;
#(
  parameter WIDTH                         = 2 
) (
  input  logic                            clk 
, input  logic                            rst_n 
, input  logic                            incr 
, output logic [ ( WIDTH - 1 ) : 0 ]      johnson 
) ;
logic [ ( WIDTH - 1 ) : 0 ] johnson_nxt , johnson_f ;
always_ff @( posedge clk or negedge rst_n ) begin: L000
  if ( ~ rst_n ) begin
    johnson_f <= '0 ;
  end else begin
    johnson_f <= johnson_nxt ;
  end
end

always_comb begin: L010
  johnson_nxt = johnson_f ;
  if ( incr ) begin
    johnson_nxt [ 0 ] = ~ johnson_f [ WIDTH - 1 ] ;
    for ( int i = 1 ; i < WIDTH ; i = i + 1 ) begin : L011
      johnson_nxt [ i ] = johnson_f [ i - 1 ] ;
    end
  end
end

assign johnson = johnson_f ;

endmodule
