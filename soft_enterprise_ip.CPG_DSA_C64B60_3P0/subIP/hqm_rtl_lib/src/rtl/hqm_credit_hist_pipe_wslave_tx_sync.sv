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
// hqm_credit_hist_pipe_wslave_tx_sync
//
//                         +--------+
//      core request <---- |        | <---- axi request (AW, W channel) single beat request only
//     core response ----> |        | ----> axi response (B channel)
//                         +--------+
//
//-----------------------------------------------------------------------------------------------------

module hqm_credit_hist_pipe_wslave_tx_sync
   import hqm_AW_pkg::*
; #(
  parameter ID_WIDTH 				= 6
, parameter BUSER_WIDTH 			= 6
, parameter B_DATA_WIDTH 			= ID_WIDTH + 2 + BUSER_WIDTH
) (
  input  logic					hqm_gated_clk
, input  logic 					hqm_gated_rst_n
, input  logic 					bready
, output logic 					bvalid
, output logic [ ID_WIDTH - 1 : 0 ] 		bid
, output logic [ 1 : 0 ] 			bresp
, output logic [ BUSER_WIDTH - 1 : 0 ] 		buser
, output logic 					core_bready
, input  logic 					core_bvalid
, input  logic [ ID_WIDTH - 1 : 0 ] 		core_bid
, input  logic [ 1 : 0 ] 			core_bresp
, input  logic [ BUSER_WIDTH - 1 : 0 ] 		core_buser
, input  logic 					wslave_b_tx_sync_rst_prep
, output logic					wslave_b_tx_sync_idle
, output logic [ 6 : 0 ] 			wslave_b_tx_sync_status
) ;

logic 						wslave_b_tx_sync_in_ready ;
logic 						wslave_b_tx_sync_in_valid ;
logic [ ( B_DATA_WIDTH - 1 ) : 0 ] 		wslave_b_tx_sync_in_data ;
logic 						wslave_b_tx_sync_out_ready ;
logic 						wslave_b_tx_sync_out_valid ;
logic [ ( B_DATA_WIDTH - 1 ) : 0 ] 		wslave_b_tx_sync_out_data ; 


hqm_AW_tx_sync # (
  .WIDTH ( B_DATA_WIDTH ) 
) i_credit_hist_pipe_wslave_b_tx_sync (
  .hqm_gated_clk 				( hqm_gated_clk )
, .hqm_gated_rst_n 				( hqm_gated_rst_n )
, .status					( wslave_b_tx_sync_status )
, .idle						( wslave_b_tx_sync_idle )
, .rst_prep					( wslave_b_tx_sync_rst_prep )
, .in_ready					( wslave_b_tx_sync_in_ready )
, .in_valid 					( wslave_b_tx_sync_in_valid )
, .in_data					( wslave_b_tx_sync_in_data )
, .out_ready					( wslave_b_tx_sync_out_ready )
, .out_valid					( wslave_b_tx_sync_out_valid )
, .out_data					( wslave_b_tx_sync_out_data )
) ;

always_comb begin
   core_bready = wslave_b_tx_sync_in_ready ;
   wslave_b_tx_sync_in_valid = core_bvalid ;
   wslave_b_tx_sync_in_data = { core_bid
                              , core_bresp
                              , core_buser
                              } ;
   wslave_b_tx_sync_out_ready = bready ;
   bvalid = wslave_b_tx_sync_out_valid ;
   { bid
   , bresp
   , buser
   } = wslave_b_tx_sync_out_data ;

end // always_comb

endmodule // hqm_credit_hist_pipe_wslave_tx_sync
