//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// reduce NUM_TGTS cfg response signals into a single cfg_rsp to connect to cfg2cfg
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_cfg_rsp import hqm_AW_pkg::*; #(
  parameter NUM_TGTS = 8
 
 ,parameter EWIDTH   = (AW_logb2(NUM_TGTS-1)+1)
) (
    input  logic                                   clk
  , input  logic                                   rst_n
  , input  logic [ ( NUM_TGTS ) - 1 : 0 ]          in_cfg_rsp_ack
  , input  logic [ ( NUM_TGTS ) - 1 : 0 ]          in_cfg_rsp_err
  , input  logic [ ( NUM_TGTS * 32 ) - 1 : 0 ]     in_cfg_rsp_rdata

  , output logic [ ( 1 ) - 1 : 0 ]                 out_cfg_rsp_ack
  , output logic [ ( 1 ) - 1 : 0 ]                 out_cfg_rsp_err
  , output logic [ ( 1 * 32 ) - 1 : 0 ]            out_cfg_rsp_rdata
) ;

logic [ ( EWIDTH ) -1 : 0] prienc ;
logic [ ( 1 ) -1 : 0] any ;
hqm_AW_binenc #(
  .WIDTH( NUM_TGTS )
) i_prienc (
    .a ( in_cfg_rsp_ack )
  , .enc ( prienc )
  , .any ( any )
);

logic [ ( 1 ) - 1 : 0 ] cfg_rsp_ack_f , cfg_rsp_ack_nxt ;
logic [ ( 1 ) - 1 : 0 ] cfg_rsp_err_f , cfg_rsp_err_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_rsp_rdata_f , cfg_rsp_rdata_nxt ;
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cfg_rsp_ack_f   <= '0 ;
    cfg_rsp_err_f   <= '0 ;
    cfg_rsp_rdata_f <= '0 ;
  end 
  else begin
    cfg_rsp_ack_f   <= cfg_rsp_ack_nxt ;
    cfg_rsp_err_f   <= cfg_rsp_err_nxt ;
    cfg_rsp_rdata_f <= cfg_rsp_rdata_nxt ;
  end
end

always_comb begin
  out_cfg_rsp_ack = cfg_rsp_ack_f ;
  out_cfg_rsp_err = cfg_rsp_err_f ;
  out_cfg_rsp_rdata = cfg_rsp_rdata_f ;
  cfg_rsp_ack_nxt = '0 ;
  cfg_rsp_err_nxt = cfg_rsp_err_f ;
  cfg_rsp_rdata_nxt = cfg_rsp_rdata_f ;
  if ( any ) begin
    cfg_rsp_ack_nxt = 1'b1 ;
    cfg_rsp_err_nxt = in_cfg_rsp_err[ ( prienc ) * 1 +: 1 ] ; 
    cfg_rsp_rdata_nxt = in_cfg_rsp_rdata[ ( prienc ) * 32 +: 32 ] ; 
  end
end

`ifndef INTEL_SVA_OFF
  hqm_AW_cfg_rsp_assert #(
    .NUM_TGTS (NUM_TGTS)
  )  i_hqm_AW_cfg_rsp_assert (.*) ;
`endif

endmodule 


`ifndef INTEL_SVA_OFF

module hqm_AW_cfg_rsp_assert import hqm_AW_pkg::*; #(
   parameter NUM_TGTS = 8
) (
   input logic clk
 , input logic rst_n
 , input logic [(NUM_TGTS-1):0] in_cfg_rsp_ack 
);

`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH ( zero_one_hot_cfg_rsp_ack
                           , in_cfg_rsp_ack
                           , 1
                           , clk
                           , ~rst_n
                           , `HQM_SVA_ERR_MSG("AW CFG RSP: Only one ack can be high!")
                           , SDG_SVA_SOC_SIM
                           )

endmodule // hqm_AW_cfg_rsp_assert
`endif

