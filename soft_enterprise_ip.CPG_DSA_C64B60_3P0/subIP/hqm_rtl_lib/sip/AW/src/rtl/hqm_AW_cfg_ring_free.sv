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
// hqm_AW_cfg_ring_free
//
// Runs on free clk.  Vlaid requests are pulled from ring and sent to hqm_AW_rx_sync to turn on clocks before proceeding
// Only One CFG Request/Repsonse can be active between Master, RING, CFG2CFG, and Sidecar at once
// Parity checks are perfromed on Up CFG Request flops.  Based on node decode, the req/rsp will be forwarded with err bits set
// 
// UP   Rsp  to  DOWN RSP  =  1 clk
// RING Rsp  to  DOWN Rsp  =  1 clk
// UP   Req  to  DOWN Req  =  2 clks
// UP   Req  to  RING Req  =  2 clks
//
//
// DIAGRAM                       .
//                        _______.______
//             UP REQ -->|       .      |--> DOWN REQ
// (FROM                 |   CFG . RING |              (TO ANOTHER CFG_RING MODULE OR MASTER)
//  ANOTHER    UP RSP -->|       .      |--> DOWN RSP
//  CFG_RING             |_______.______|      
//  MODULE OR                |   .  ^
//  MASTER)         RING REQ |   .  | RING RSP
//                           V      |
// 
//         (TO hqm_AW_rx_sync)      (FROM hqm_AW_cfg_ring_gated)
//
// The following parameters are supported:
//
//	NODE_ID		Value of this unit's CFG NODE, valid decode will pull requests from the CFG Ring.
//
//-------------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_cfg_ring_free 
        import hqm_AW_pkg::*;
#(      
        parameter                           NODE_ID         = 15
//.......................................................................................................................................................
) (

        input	logic                   clk
      , input	logic                   rst_n
      , input	logic                   rst_prep

      , output  logic                   cfg_idle
        
      , input   logic                   up_cfg_req_write
      , input   logic                   up_cfg_req_read  
      , input   cfg_req_t               up_cfg_req
      , input   logic                   up_cfg_rsp_ack
      , input   cfg_rsp_t               up_cfg_rsp
  
      , output  logic                   down_cfg_req_write
      , output  logic                   down_cfg_req_read
      , output  cfg_req_t               down_cfg_req
      , output  logic                   down_cfg_rsp_ack
      , output  cfg_rsp_t               down_cfg_rsp

      , output  logic                   ring_cfg_req_write
      , output  logic                   ring_cfg_req_read
      , output  cfg_req_t               ring_cfg_req
      , input   logic                   ring_cfg_rsp_ack
      , input   cfg_rsp_t               ring_cfg_rsp
);

//-------------------------------------------------------------------------------------------------------------------------------------------------------

logic      up_cfg_req_v_f;
logic      up_cfg_req_write_f;
logic      up_cfg_req_read_f;
cfg_req_t  up_cfg_req_f;

logic      up_cfg_rsp_v_f;
cfg_rsp_t  up_cfg_rsp_f;

logic      down_cfg_req_write_f, down_cfg_req_write_nxt;
logic      down_cfg_req_read_f, down_cfg_req_read_nxt;
cfg_req_t  down_cfg_req_f, down_cfg_req_nxt;

logic      ring_cfg_req_write_f, ring_cfg_req_write_nxt ;
logic      ring_cfg_req_read_f, ring_cfg_req_read_nxt;
cfg_req_t  ring_cfg_req_f, ring_cfg_req_nxt;

logic      ring_cfg_rsp_v_f;
cfg_rsp_t  ring_cfg_rsp_f;

logic      node_decode;

logic                   down_cfg_rsp_ack_nxt , down_cfg_rsp_ack_f ;
cfg_rsp_t               down_cfg_rsp_nxt , down_cfg_rsp_f ;

logic      addr_par_err;
logic      wdata_par_err;
logic      enbl_wdata_parity_check;
logic      enbl_addr_parity_check;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Flops
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin 

    up_cfg_req_v_f           <= 1'b0;
    up_cfg_req_write_f       <= 1'b0;
    up_cfg_req_read_f        <= 1'b0;
    up_cfg_req_f             <= '0;

    ring_cfg_req_write_f     <= 1'b0;
    ring_cfg_req_read_f      <= 1'b0;
    ring_cfg_req_f           <= '0;

    up_cfg_rsp_v_f           <= 1'b0;
    up_cfg_rsp_f             <= '0;

    ring_cfg_rsp_v_f         <= 1'b0;
    ring_cfg_rsp_f           <= '0;

    down_cfg_req_write_f     <= 1'b0;
    down_cfg_req_read_f      <= 1'b0;
    down_cfg_req_f           <= '0;

    down_cfg_rsp_ack_f       <= '0 ;
    down_cfg_rsp_f           <= '0 ;
  end else begin 

    up_cfg_req_v_f           <= up_cfg_req_write | up_cfg_req_read;
    up_cfg_req_write_f       <= up_cfg_req_write;
    up_cfg_req_read_f        <= up_cfg_req_read;
    if ( up_cfg_req_write | up_cfg_req_read ) begin
      up_cfg_req_f           <= up_cfg_req;
    end

    ring_cfg_req_write_f     <= ring_cfg_req_write_nxt;
    ring_cfg_req_read_f      <= ring_cfg_req_read_nxt;
    if ( ring_cfg_req_write_nxt | ring_cfg_req_read_nxt ) begin
      ring_cfg_req_f         <= ring_cfg_req_nxt;
    end
 
    up_cfg_rsp_v_f           <= up_cfg_rsp_ack;
    if ( up_cfg_rsp_ack ) begin
      up_cfg_rsp_f           <= up_cfg_rsp;
    end

    ring_cfg_rsp_v_f         <= ring_cfg_rsp_ack;
    if ( ring_cfg_rsp_ack ) begin
      ring_cfg_rsp_f         <= ring_cfg_rsp;
    end

    down_cfg_req_write_f     <= down_cfg_req_write_nxt;
    down_cfg_req_read_f      <= down_cfg_req_read_nxt;
    if ( down_cfg_req_write_nxt | down_cfg_req_read_nxt ) begin
      down_cfg_req_f         <= down_cfg_req_nxt;
    end

    down_cfg_rsp_ack_f       <= down_cfg_rsp_ack_nxt ;
    down_cfg_rsp_f           <= down_cfg_rsp_nxt ;
  end // ~rst_n 
end //always_ff

assign cfg_idle = ~( up_cfg_req_v_f
                   | ring_cfg_req_write_f
                   | ring_cfg_req_read_f
                   | up_cfg_rsp_v_f 
                   | ring_cfg_rsp_v_f
                   | down_cfg_req_write_f 
                   | down_cfg_req_read_f
                   ) ;

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Decode Address to determine endpoint ( pull from ring or pass downstream )   

assign node_decode       = up_cfg_req_v_f & ( up_cfg_req_f.addr.node == ( NODE_ID ) );

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Parity Check
// Error on req   - Transition Req into Rsp and send back to master with err bit set

assign enbl_wdata_parity_check  = ( (up_cfg_req_write_f)
                                  & (node_decode)
                                  & ~up_cfg_req_f.user.disable_ring_parity_check
                                  ) ;
assign enbl_addr_parity_check   = ( (up_cfg_req_write_f | up_cfg_req_read_f)
                                  & (node_decode)
                                  & ~up_cfg_req_f.user.disable_ring_parity_check
                                  ) ;
hqm_AW_parity_check # (
  .WIDTH ( $bits(up_cfg_req_f.wdata) )
) i_hqm_AW_par_check_wdata (
  .p     ( up_cfg_req_f.wdata_par ),
  .d     ( up_cfg_req_f.wdata ),
  .e     ( enbl_wdata_parity_check ),
  .odd   ( 1'b1 ),
  .err   ( wdata_par_err )
) ;

hqm_AW_parity_check # (
  .WIDTH ( $bits(up_cfg_req_f.addr) )
) i_hqm_AW_par_check_addr (
  .p     ( up_cfg_req_f.addr_par ),
  .d     ( up_cfg_req_f.addr ),
  .e     ( enbl_addr_parity_check ),
  .odd   ( 1'b1 ),
  .err   ( addr_par_err )
) ;

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Request Control Logic
// Up to Down 
//    OR
// Up to Ring(Core)
//    OR
// Up to Down Rsp (Par Err)
//
//
// Response Control Logic
// Up to Down
//    AND
// Ring(Core) to Down

always_comb begin 

  ring_cfg_req_write_nxt             = 1'b0;
  ring_cfg_req_read_nxt              = 1'b0;
  ring_cfg_req_nxt                   = up_cfg_req_f;

  down_cfg_req_write_nxt             = 1'b0;
  down_cfg_req_read_nxt              = 1'b0;
  down_cfg_req_nxt                   = up_cfg_req_f;

  down_cfg_rsp_ack                   = down_cfg_rsp_ack_f ;
  down_cfg_rsp                       = down_cfg_rsp_f ;




  // Response
  down_cfg_rsp_ack_nxt                   = 1'b0;
  down_cfg_rsp_nxt                       = up_cfg_rsp_f;

  // Request
  if ( up_cfg_req_v_f ) begin
    if ( node_decode ) begin
      if (addr_par_err | wdata_par_err) begin 
        down_cfg_rsp_ack_nxt             = 1'b1 ;
        down_cfg_rsp_nxt                 = '0 ;
        down_cfg_rsp_nxt.rdata_par       = 1'b1 ;
        down_cfg_rsp_nxt.err             = 1'b1 ;
        down_cfg_rsp_nxt.err_slv_par     = 1'b1 ;
        down_cfg_rsp_nxt.uid             =  enum_cfg_unit_id_t'(NODE_ID) ;
      end else begin
        ring_cfg_req_write_nxt       = up_cfg_req_write_f;
        ring_cfg_req_read_nxt        = up_cfg_req_read_f;
      end
    end else  begin
        down_cfg_req_write_nxt       = up_cfg_req_write_f;
        down_cfg_req_read_nxt        = up_cfg_req_read_f;
    end
  end // up_cfg_req_v_f

  
  if ( rst_prep ) begin
    
    down_cfg_rsp_ack_nxt                 = 1'b0 ;
    down_cfg_rsp_nxt                     = '0 ;
  end else 
  if ( up_cfg_rsp_v_f ) begin

    down_cfg_rsp_ack_nxt                 = up_cfg_rsp_v_f;
    down_cfg_rsp_nxt                     = up_cfg_rsp_f;
  end else 
  if ( ring_cfg_rsp_v_f ) begin 

    down_cfg_rsp_ack_nxt                 = ring_cfg_rsp_v_f;
    down_cfg_rsp_nxt                     = ring_cfg_rsp_f;
  end
end 

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Drive outputs
assign ring_cfg_req_write            = (rst_prep) ? 1'b0 : ring_cfg_req_write_f ;
assign ring_cfg_req_read             = (rst_prep) ? 1'b0 : ring_cfg_req_read_f ;
assign ring_cfg_req                  = (rst_prep) ? '0   : ring_cfg_req_f ;

assign down_cfg_req_write            = (rst_prep) ? 1'b0 : down_cfg_req_write_f ;
assign down_cfg_req_read             = (rst_prep) ? 1'b0 : down_cfg_req_read_f ;
assign down_cfg_req                  = (rst_prep) ? '0   : down_cfg_req_f ;
`ifndef INTEL_SVA_OFF
  hqm_AW_cfg_ring_free_assert 
    i_hqm_AW_cfg_ring_free_assert (.*) ;
`endif

endmodule // hqm_AW_cfg_ring_free


`ifndef INTEL_SVA_OFF

module hqm_AW_cfg_ring_free_assert (
   input logic clk
 , input logic rst_n
 , input logic up_cfg_req_read
 , input logic up_cfg_req_write
 , input logic down_cfg_req_read
 , input logic down_cfg_req_write
 , input logic ring_cfg_req_read
 , input logic ring_cfg_req_write
 , input logic up_cfg_rsp_ack
 , input logic down_cfg_rsp_ack
 , input logic ring_cfg_rsp_ack
);
 
 logic [8:0] cfg_control_bits;
 assign cfg_control_bits = { up_cfg_req_read
                           , up_cfg_req_write
                           , down_cfg_req_read
                           , down_cfg_req_write
                           , ring_cfg_req_read
                           , ring_cfg_req_write
                           , up_cfg_rsp_ack
                           , down_cfg_rsp_ack
                           , ring_cfg_rsp_ack
                           } ;
`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(ASSERTS_AT_MOST_BITS_HIGH , cfg_control_bits  , 1, clk, ~rst_n, `HQM_SVA_ERR_MSG("AW CFG_RING_FREE : only one ctrl bit can be valid"), SDG_SVA_SOC_SIM )

endmodule // hqm_AW_cfg_ring_free_assert
`endif

