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
// hqm_AW_cfg_ring_top
// 
// This module serves as the basic config ring element.  The master of the ring should be hqm_AW_sys2cfg.
// Broadcasts are supported by asserting bit [19] of the upstream user field on the request interface.
// For broadcast responses, the upstream logic's response always wins over the local unit's response.
//
// Each ring performs a NODE decode, and pulls requests from the CFG Ring when it's individual node hits
// The core side interface of this module must be connected to an hqm_AW_cfg2cfg module, which will handle further address 
// decoding to multiple targets.
// 
// The cfg ring module contains the broadcast registers for the unit in which it is instantiated.  
// 16 32b registers @  (base addr + 0x0) thru (base addr + 0x3c).
//
// The upstream/downstream portion of the ring is free running.
// CFG access to the core requires that clocks be on.
// Pending core requests will turn clocks on via the AW_rx_sync
// The internal registers are on the gated clock, gated reset, and gated patch reset. 
// 
// The cfg_ring_top module now also contains the cfg2cfg module, which connects naturally to the rx_sync module. 
// This reduces the number of AWs floating at the top level of each unit.
//
// CFG RING TOP DIAGRAM                       .
//                        _______.______
//             UP REQ -->|       .      |--> DOWN REQ
// (FROM                 |   CFG . RING |              (TO ANOTHER CFG_RING MODULE OR MASTER)
//  ANOTHER    UP RSP -->|       .      |--> DOWN RSP
//  CFG_RING             |_______.______|      
//  MODULE OR                |   .  ^
//  MASTER)         UNIT REQ |   .  | UNIT RSP
//                           V      |
// 
//                      (TO UNIT SIDECAR)
//
// The following parameters are supported:
//
//	TGT_MAP		Vector of values that represent the base address of this unit's cfg interface.
//	TGT_MSK		Vector of values that represent the base address bits to match for this unit's cfg interface.
//     * The Map and MSK should be a superset of all addresses supported by the unit in which this module is instantiated.
//
//-------------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_cfg_ring_top
        import hqm_AW_pkg::*;
#(      
        parameter                           NODE_ID                   = 15
      , parameter                           UNIT_ID                   = 15
      , parameter                           UNIT_NUM_TGTS             = 1
      , parameter [(16*UNIT_NUM_TGTS)-1:0]  UNIT_TGT_MAP              = {(16*UNIT_NUM_TGTS){1'b0}}
      , parameter                           ALWAYS_HITS               = 0
//.......................................................................................................................................................
) (

        input	logic                               hqm_inp_gated_clk
      , input	logic                               hqm_inp_gated_rst_n

      , input	logic                               hqm_gated_clk
      , input	logic                               hqm_gated_rst_n

      , input	logic                               rst_prep

      , input   logic                               cfg_rx_enable
      , output  logic                               cfg_rx_idle
      , output  aw_fifo_status_t                    cfg_rx_fifo_status 
 
      , output  logic                               cfg_idle  //something in ring_free, rx_sync, or cfg2cfg (req-to-rsp)

      , input   logic                               up_cfg_req_write
      , input   logic                               up_cfg_req_read  
      , input   cfg_req_t                           up_cfg_req
      , input   logic                               up_cfg_rsp_ack
      , input   cfg_rsp_t                           up_cfg_rsp
  
      , output  logic                               down_cfg_req_write
      , output  logic                               down_cfg_req_read
      , output  cfg_req_t                           down_cfg_req
      , output  logic                               down_cfg_rsp_ack
      , output  cfg_rsp_t                           down_cfg_rsp
 
      , output  logic [UNIT_NUM_TGTS-1:0]           unit_cfg_req_write
      , output  logic [UNIT_NUM_TGTS-1:0]           unit_cfg_req_read
      , output  cfg_req_t                           unit_cfg_req
      , input   logic                               unit_cfg_rsp_ack
      , input   logic [$bits(up_cfg_rsp.err)-1:0]   unit_cfg_rsp_err
      , input   logic [$bits(up_cfg_rsp.rdata)-1:0] unit_cfg_rsp_rdata
);

//-------------------------------------------------------------------------------------------------------------------------------------------------------
localparam CFG_DWIDTH = ( $bits(cfg_req_wctrl_t) ) ;
localparam CFG_DEPTH  = ( 2 ) ; //fifo_control assumes a minimum depth of 2

logic            ring_cfg_req_write, ring_cfg_req_read, ring_cfg_req_valid ;
cfg_req_t        ring_cfg_req ;
logic            ring_cfg_rsp_ack ;
cfg_rsp_t        ring_cfg_rsp ;
cfg_req_wctrl_t  ring_cfg_req_wctrl ;

logic            gated_cfg_req_valid ;
logic            gated_cfg_req_write, gated_cfg_req_read ;
cfg_req_wctrl_t  gated_cfg_req_wctrl ;
cfg_req_t        gated_cfg_req ;

logic re_nc, we_nc, waddr_nc, raddr_nc ;
logic [CFG_DWIDTH-1:0] wdata_nc ;
logic in_ready_nc ;
logic wire_cfg_rx_idle ;
logic cfg_ring_free_idle ;
logic cfg_cfg2cfg_idle ;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
// IDLE 
assign cfg_idle = cfg_ring_free_idle & wire_cfg_rx_idle & cfg_cfg2cfg_idle ;
assign cfg_rx_idle = wire_cfg_rx_idle & cfg_cfg2cfg_idle ;

//-------------------------------------------------------------------------------------------------------------------------------------------------------
assign ring_cfg_req_valid      = ring_cfg_req_write | ring_cfg_req_read ;
assign ring_cfg_req_wctrl.wr   = ring_cfg_req_write ;
assign ring_cfg_req_wctrl.rd   = ring_cfg_req_read ;
assign ring_cfg_req_wctrl.req  = ring_cfg_req ;

always_comb begin

  gated_cfg_req_write = 1'b0 ;
  gated_cfg_req_read  = 1'b0 ;
  gated_cfg_req       = '0 ;

  if ( gated_cfg_req_valid ) begin
    gated_cfg_req_write = gated_cfg_req_wctrl.wr ;
    gated_cfg_req_read  = gated_cfg_req_wctrl.rd ;
    gated_cfg_req       = gated_cfg_req_wctrl.req ;
  end
end

//-------------------------------------------------------------------------------------------------------------------------------------------------------
hqm_AW_cfg_ring_free #(
  .NODE_ID            ( NODE_ID )
 ) i_hqm_AW_cfg_ring_free (
  .clk                ( hqm_inp_gated_clk )
, .rst_n              ( hqm_inp_gated_rst_n )
, .rst_prep           ( rst_prep )

, .cfg_idle           ( cfg_ring_free_idle )

, .up_cfg_req_write   ( up_cfg_req_write )
, .up_cfg_req_read    ( up_cfg_req_read )
, .up_cfg_req         ( up_cfg_req )
, .up_cfg_rsp_ack     ( up_cfg_rsp_ack )
, .up_cfg_rsp         ( up_cfg_rsp )

, .down_cfg_req_write ( down_cfg_req_write )
, .down_cfg_req_read  ( down_cfg_req_read )
, .down_cfg_req       ( down_cfg_req )
, .down_cfg_rsp_ack   ( down_cfg_rsp_ack )
, .down_cfg_rsp       ( down_cfg_rsp )

, .ring_cfg_req_write ( ring_cfg_req_write )
, .ring_cfg_req_read  ( ring_cfg_req_read )
, .ring_cfg_req       ( ring_cfg_req)
, .ring_cfg_rsp_ack   ( ring_cfg_rsp_ack )
, .ring_cfg_rsp       ( ring_cfg_rsp )
) ;

hqm_AW_rx_sync #(
  .DEPTH              ( CFG_DEPTH )
, .WIDTH              ( CFG_DWIDTH )
) i_hqm_AW_rx_sync (
  .hqm_inp_gated_clk  ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n ( hqm_inp_gated_rst_n )

, .status             ( cfg_rx_fifo_status ) 

, .enable             ( cfg_rx_enable )  // enable control from hqm_AW_module_clock_control 
, .idle               ( wire_cfg_rx_idle )    // idle indication to hqm_AW_module_clock_control
, .rst_prep           ( rst_prep )

, .in_ready           ( in_ready_nc )
, .in_valid           ( ring_cfg_req_valid )
, .in_data            ( ring_cfg_req_wctrl )
, .out_ready          ( 1'b1 )
, .out_valid          ( gated_cfg_req_valid )
, .out_data           ( gated_cfg_req_wctrl )

, .mem_we             ( we_nc ) 
, .mem_waddr          ( waddr_nc )
, .mem_wdata          ( wdata_nc )
, .mem_re             ( re_nc )
, .mem_raddr          ( raddr_nc )
, .mem_rdata          ('0 )

) ;

hqm_AW_cfg2cfg #(  
  .UNIT_ID                  ( UNIT_ID )
, .NUM_TGTS                 ( UNIT_NUM_TGTS )
, .TGT_MAP                  ( UNIT_TGT_MAP )
, .ALWAYS_HITS              ( ALWAYS_HITS )
) i_hqm_AW_cfg2cfg (
  .clk                ( hqm_gated_clk )
, .rst_n              ( hqm_gated_rst_n )
, .rst_prep           ( rst_prep )

, .cfg_idle           ( cfg_cfg2cfg_idle ) 

, .up_cfg_req_write   ( gated_cfg_req_write )
, .up_cfg_req_read    ( gated_cfg_req_read )
, .up_cfg_req         ( gated_cfg_req )
, .up_cfg_rsp_ack     ( ring_cfg_rsp_ack )
, .up_cfg_rsp         ( ring_cfg_rsp )

, .down_cfg_req_write ( unit_cfg_req_write )
, .down_cfg_req_read  ( unit_cfg_req_read )
, .down_cfg_req       ( unit_cfg_req )
, .down_cfg_rsp_ack   ( unit_cfg_rsp_ack )
, .down_cfg_rsp_err   ( unit_cfg_rsp_err )
, .down_cfg_rsp_rdata ( unit_cfg_rsp_rdata )
);

endmodule  // hqm_AW_cfg_ring_top
