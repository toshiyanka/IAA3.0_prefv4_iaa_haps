//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_rr_arb
  import hqm_AW_pkg::*;
#(
  parameter NUM_REQS = 8
//................................................................................................................................................
, parameter NUM_REQSB2 = ( AW_logb2 ( NUM_REQS -1 ) + 1 )
, parameter WIDTH_SCALE = ( 1<<NUM_REQSB2 )
, parameter WIDTH_SCALEB2 = (AW_logb2 ( WIDTH_SCALE -1 ) + 1)
) (
  input logic clk
, input logic rst_n
, input logic [( NUM_REQS ) -1 : 0] reqs
, input logic [( 1 ) -1 : 0] update
, output logic [( 1 ) -1 : 0] winner_v
, output logic [( NUM_REQSB2 ) -1 : 0] winner
) ;

//---------------------------------------------------------------------------------------------------
//Check for invalid paramter configation
genvar GEN0 ;
generate 
  if ( ~( NUM_REQS < 2049 ) ) begin : invalid_check
    for ( GEN0 = NUM_REQS ; GEN0 <= NUM_REQS ; GEN0 = GEN0+1 ) begin : invalid_NUM_REQS
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end 
endgenerate

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers

logic [( NUM_REQSB2 ) -1 : 0] index_nxt , index_f ;
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
  index_f <= 0 ;
 end else begin
  index_f <= index_nxt ;
 end
end

logic [( WIDTH_SCALE) -1 : 0] width_scale_reqs_Z ;
hqm_AW_width_scale #(
  .A_WIDTH( NUM_REQS )
, .Z_WIDTH( WIDTH_SCALE )
 ) i_width_scale_reqs (
 .a ( reqs )
,.z ( width_scale_reqs_Z )
);

logic [( WIDTH_SCALE ) -1 : 0] rotate_right_bit_00_dout ;
hqm_AW_rotate_bit #(
 .WIDTH(WIDTH_SCALE)
) i_rotate_right_bit (
 .din ( width_scale_reqs_Z )
,.rot ( index_f )
,.dout ( rotate_right_bit_00_dout )
);

logic [( WIDTH_SCALEB2 ) -1 : 0] binenc_reqs_enc ;
logic [( 1 ) -1 : 0 ] binend_reqs_any_nc ;
hqm_AW_binenc #(
 .WIDTH(WIDTH_SCALE)
) i_binenc_reqs (
 .a ( rotate_right_bit_00_dout )
,.enc ( binenc_reqs_enc )
,.any ( binend_reqs_any_nc )
);

//------------------------------------------------------------------------------------------------------------------------------------------------
always_comb begin

  //..............................................................................................................................................
  //output values
  winner_v = |(reqs) ;
  winner = index_f + binenc_reqs_enc ;

  //..............................................................................................................................................
  //flop values
  index_nxt = index_f ;
  if ( ( winner_v == 1'd1 )
     & ( update == 1'd1 )
     ) begin
    index_nxt = winner + { {(NUM_REQSB2-1){1'b0}} , 1'd1 } ;
  end
end

            `ifndef INTEL_SVA_OFF
            hqm_AW_rr_arb_assert i_hqm_AW_rr_arb_assert (.*) ;
            `endif  // INTEL_SVA_OFF

endmodule
            `ifndef INTEL_SVA_OFF
            module hqm_AW_rr_arb_assert import hqm_AW_pkg::*; (
                      input logic clk
                    , input logic rst_n
                    , input update
                    , input winner_v
            );
           `HQM_SDG_ASSERTS_FORBIDDEN    ( assert_update_nowinner
                                 , ( update & ~winner_v )
                                 , clk
                                 , ~rst_n
                                 , `HQM_SVA_ERR_MSG("Error: Assert: %m : arbiter update issued when no winner, index NOT updated. ")
                                 , SDG_SVA_SOC_SIM
                                 ) 
           endmodule
           `endif // INTEL_SVA_OFF

