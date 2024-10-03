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
// hqm_AW_cfg_ring_gated
// 
// This module serves as the 2nd basic config ring element.  The master of the ring should be hqm_AW_sys2cfg.
//
// The core side interface of this module must be connected to an hqm_AW_cfg2cfg module,
// which will handle further address decoding to the sidecar cfg targets.
// 
// The cfg_ring_gated module contains the broadcast registers for the unit in which it is instantiated.  
//
// To save 1 clk cycle, the inputs are not flopped in this unit (before the target decode)
// Inputs are coming directly from the bypass flop of the fifo controller in the AW_rx_sync module.
// 
// DIAGRAM                       .
//                        _______.______
//             UP REQ -->|       .      |--> DOWN REQ
// (FROM                 |   CFG . RING |              (TO ANOTHER CFG_RING MODULE OR MASTER)
//  ANOTHER    UP RSP -->|       .      |--> DOWN RSP
//  CFG_RING             |_______.______|      
//  MODULE OR                |   .  ^
//  MASTER)         CORE REQ |   .  | CORE RSP
//                           V      |
// 
//                     (TO hqm_AW_CFG2CFG)
//
// The following parameters are supported:
//
//	TGT_MAP		Vector of values that represent the base address of this unit's cfg interface.
//	TGT_MSK		Vector of values that represent the base address bits to match for this unit's cfg interface.
//     * The Map and MSK should be a superset of all addresses supported by the unit in which this module is instantiated.
//
//-------------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_cfg_ring_gated 
        import hqm_AW_pkg::*;
#(      
        parameter                       UNIT_ID         = 15
//.......................................................................................................................................................
) (

        input	logic                   clk
      , input	logic                   rst_n
      , input	logic                   rst_prep

      , output	logic                   cfg_idle
       
      , input   logic                   ring_cfg_req_write
      , input   logic                   ring_cfg_req_read
      , input   cfg_req_t               ring_cfg_req
      , output  logic                   ring_cfg_rsp_ack
      , output  cfg_rsp_t               ring_cfg_rsp
 
      , output  logic                   core_cfg_req_write
      , output  logic                   core_cfg_req_read
      , output  cfg_req_t               core_cfg_req
      , input   logic                   core_cfg_rsp_ack
      , input   cfg_rsp_t               core_cfg_rsp

);

//-------------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------------
logic      core_cfg_req_write_f, core_cfg_req_write_nxt;
logic      core_cfg_req_read_f, core_cfg_req_read_nxt;
cfg_req_t  core_cfg_req_f, core_cfg_req_nxt;

logic      ring_cfg_rsp_ack_f, ring_cfg_rsp_ack_nxt;
cfg_rsp_t  ring_cfg_rsp_f, ring_cfg_rsp_nxt;
logic      ring_cfg_req_v ;

logic core_cfg_req_busy_f, core_cfg_req_busy_nxt ;  // Sets for req to core, clears on rsp from core

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Flops
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin
    core_cfg_req_write_f     <= 1'b0;
    core_cfg_req_read_f      <= 1'b0;
    core_cfg_req_f           <= '0 ;

    core_cfg_req_busy_f      <= '0 ;
   
    ring_cfg_rsp_ack_f       <= 1'b0; 
    ring_cfg_rsp_f           <= '0 ; 
  end else begin
    core_cfg_req_write_f     <= core_cfg_req_write_nxt;
    core_cfg_req_read_f      <= core_cfg_req_read_nxt;
    core_cfg_req_f           <= core_cfg_req_nxt;

    core_cfg_req_busy_f      <= core_cfg_req_busy_nxt ;
   
    ring_cfg_rsp_ack_f       <= ring_cfg_rsp_ack_nxt;
    ring_cfg_rsp_f           <= ring_cfg_rsp_nxt; 

  end
end //always_ff

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Address Decode
//
//................................................................
// TGT Decode is External             - send to core
// Error (Parity or Decode)           - send response back to ring 
//

assign ring_cfg_req_v    = ring_cfg_req_write | ring_cfg_req_read ;

always_comb begin 

  core_cfg_req_write_nxt             = 1'b0;
  core_cfg_req_read_nxt              = 1'b0;
  core_cfg_req_nxt                   = ring_cfg_req;

  ring_cfg_rsp_ack_nxt               = 1'b0;
  ring_cfg_rsp_nxt                   = '0;

  if ( ring_cfg_req_v ) begin
    core_cfg_req_write_nxt         = ring_cfg_req_write;
    core_cfg_req_read_nxt          = ring_cfg_req_read; 
  end //ring_cfg_req_v


  // Flop repsonses and send to ring
  if ( core_cfg_rsp_ack ) begin
    ring_cfg_rsp_ack_nxt             = 1'b1;
    ring_cfg_rsp_nxt                 = core_cfg_rsp;
  end 

end //always_comb

always_comb begin
  core_cfg_req_busy_nxt = core_cfg_req_busy_f ;

  if ( core_cfg_req_write_f | core_cfg_req_read_f ) begin
    core_cfg_req_busy_nxt = 1'b1 ;
  end else 
  if ( core_cfg_rsp_ack ) begin
    core_cfg_req_busy_nxt = 1'b0 ;
  end
end

assign cfg_idle = ~( core_cfg_req_busy_f
                   | core_cfg_req_write_f
                   | core_cfg_req_read_f
                   | ring_cfg_rsp_ack_f
                   ); 
//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Drive Outputs

assign core_cfg_req_write = (rst_prep) ? 1'b0 : core_cfg_req_write_f ;
assign core_cfg_req_read  = (rst_prep) ? 1'b0 : core_cfg_req_read_f ;
assign core_cfg_req       = (rst_prep) ? '0   : core_cfg_req_f ;

assign ring_cfg_rsp_ack   = (rst_prep) ? 1'b0 : ring_cfg_rsp_ack_f ;
assign ring_cfg_rsp       = (rst_prep) ? '0   : ring_cfg_rsp_f ;

endmodule // hqm_AW_cfg_ring_gated
