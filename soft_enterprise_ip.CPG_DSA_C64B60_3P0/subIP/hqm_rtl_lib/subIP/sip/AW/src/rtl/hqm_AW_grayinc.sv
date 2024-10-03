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
module hqm_AW_grayinc
  import hqm_AW_pkg::*;
#(
  parameter WIDTH                         = 2 
) (
  input  logic                            clk 
, input  logic                            rst_n 
, input  logic                            clear
, input  logic                            incr 
, output logic [ ( WIDTH - 1 ) : 0 ]      gray 
) ;
logic [ ( WIDTH - 1 ) : 0 ] gray_nxt , gray_f , bin , binp1 ;
always_ff @( posedge clk or negedge rst_n ) begin: L000
  if ( ~ rst_n ) begin
    gray_f <= '0 ;
  end else if ( clear ) begin
    gray_f <= '0 ;
  end else begin
    gray_f <= gray_nxt ;
  end
end

hqm_AW_bin2gray #( .WIDTH ( WIDTH ) ) i_b2g (
  .binary ( binp1 )
, .gray ( gray_nxt )
);
hqm_AW_gray2bin #( .WIDTH ( WIDTH ) ) i_g2b (
  .gray ( gray_f )
, .binary ( bin )
);
assign binp1 = bin + { {(WIDTH-1){1'b0}} , incr } ;

assign gray = gray_f ;

endmodule
