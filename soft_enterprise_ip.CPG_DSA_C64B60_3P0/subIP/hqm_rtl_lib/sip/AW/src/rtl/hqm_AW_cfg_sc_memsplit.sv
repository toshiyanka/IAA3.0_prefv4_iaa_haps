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
// Interface between AW_cfg_sc and ram_access modules in the case where a config-accessible memory is
// wider than 32 bits (ignoring check bits).  Split the memory into "n" shallower memories (power of 2),
// Only memory "0" is seen by the register spreadsheet as existing, and seen by the <unit>.perl file
// as being config accessible.  Repurpose the functional interface to enable config access to all
// memories.  This relies on the fact that if the sidecar is doing a config access there can not be
// a simultaneous functional access.
//
// If the memory is a single port, use the same AW "rmw" and ram_access interface for the address,
// e.g. mem_write_addr and func_mem_waddr, and leave the "other" address ports tied off / nc.
//
// ram_access module config port for this memory's slice is unused.
//-----------------------------------------------------------------------------------------------------
//
module hqm_AW_cfg_sc_memsplit
  import hqm_AW_pkg::*;
# (
  parameter FACTOR                      = 1     // log2 of num memories; e.g. 1 for 2 mems, 2 for 4 etc.
, parameter CFG_MEM_ADDR_WIDTH          = 20    // Width of address bus out of sidecar, varies from unit to unit
, parameter MEM_DWIDTH                  = 33    // Memory data width including CC (if any)
, parameter MEM_AWIDTH                  = 5     // Memory address width
//.............................................................

, parameter NUM_MEMS                    = (1 << FACTOR)
) (
  input  logic                                  clk
, input  logic                                  rst_n

// Upstream interface to sidecar
, input  logic                                  cfgsc_cfg_mem_re
, input  logic                                  cfgsc_cfg_mem_we
, input  logic [CFG_MEM_ADDR_WIDTH-1:0]         cfgsc_cfg_mem_addr
, input  logic [MEM_DWIDTH-1:0]                 cfgsc_cfg_mem_wdata     // data with cc inclusion
, output logic [MEM_DWIDTH-1:0]                 cfgsc_cfg_mem_rdata     // data with cc inclusion
, output logic                                  cfgsc_cfg_mem_ack

// Upstream interface to functional access (e.g. AW rmw)
, input  logic                                  mem_read
, input  logic                                  mem_write
, input  logic [MEM_AWIDTH-1:0]                 mem_read_addr
, input  logic [MEM_AWIDTH-1:0]                 mem_write_addr
, output logic [(MEM_DWIDTH*NUM_MEMS)-1:0]      mem_read_data
, input  logic [(MEM_DWIDTH*NUM_MEMS)-1:0]      mem_write_data

// Downstream interface to ram_access module functional port
// If it is a single-port memory, use mem_write_addr as the memory address
, output logic [NUM_MEMS-1:0]                   func_mem_re
, output logic [NUM_MEMS-1:0]                   func_mem_we
, output logic [(MEM_AWIDTH*NUM_MEMS)-1:0]      func_mem_raddr          // same address goes to all memories
, output logic [(MEM_AWIDTH*NUM_MEMS)-1:0]      func_mem_waddr          // same address goes to all memories
, input  logic [(MEM_DWIDTH*NUM_MEMS)-1:0]      func_mem_rdata          // data with cc
, output logic [(MEM_DWIDTH*NUM_MEMS)-1:0]      func_mem_wdata          // data with cc

// Downstream interface to ram_access module rf port
, input  logic [NUM_MEMS-1:0]                   rf_mem_re
, input  logic [NUM_MEMS-1:0]                   rf_mem_we

) ;

localparam      NUM_MEMSB2      = AW_logb2 ( NUM_MEMS - 1 ) + 1 ;

logic [(MEM_AWIDTH*NUM_MEMS)-1:0]      func_mem_addr ;                  // same address goes to all memories
logic                           rf_mem_re_any ;
logic                           rf_mem_we_any ;
logic                           wait_for_ack_nxt ;
logic                           wait_for_ack_f ;
logic                           mem_ack_nxt ;
logic                           mem_ack_f ;
logic [NUM_MEMSB2-1:0]          mem_sel_nxt ;
logic [NUM_MEMSB2-1:0]          mem_sel_f ;

always_comb begin
  func_mem_we = '0 ;
  func_mem_re = '0 ;
  func_mem_addr = { NUM_MEMS { mem_write_addr } } ;
  func_mem_wdata = mem_write_data ;

//==============================================================
// Write interface to ram_access
  if ( cfgsc_cfg_mem_we ) begin
    for ( int i = 0 ; i < NUM_MEMS ; i = i + 1 ) begin
      if ( cfgsc_cfg_mem_addr [NUM_MEMSB2-1:0] == i ) begin
        func_mem_we[i]          = 1'b1 ;
      end
    end // for i
    func_mem_addr               = { NUM_MEMS { cfgsc_cfg_mem_addr [ NUM_MEMSB2 +: MEM_AWIDTH ] } } ;
    func_mem_wdata              = { NUM_MEMS { cfgsc_cfg_mem_wdata } } ;
  end

//==============================================================
// Read interface to ram_access
  else if ( cfgsc_cfg_mem_re ) begin
    for ( int i = 0 ; i < NUM_MEMS ; i = i + 1 ) begin
      if ( cfgsc_cfg_mem_addr [NUM_MEMSB2-1:0] == i ) begin
        func_mem_re[i]          = 1'b1 ;
      end
    end // for i
    func_mem_addr               = { NUM_MEMS { cfgsc_cfg_mem_addr [ NUM_MEMSB2 +: MEM_AWIDTH ] } } ;
  end

  else begin
    func_mem_we                 = { NUM_MEMS { mem_write } } ;
    func_mem_re                 = { NUM_MEMS { mem_read } } ;
  end
end // always

//==============================================================
// Response interface to sidecar

// Assumes only 1 cfg access at a time, and no functional accesses are possible if a cfg access is active
// Allow for the possibility that ram_access does the rf read/write on the same clock as the config read/write request

always_comb begin
  mem_sel_nxt                   = mem_sel_f ;
  if ( cfgsc_cfg_mem_re ) begin
    mem_sel_nxt                 = cfgsc_cfg_mem_addr [NUM_MEMSB2-1:0] ;
  end

  rf_mem_re_any                 = | rf_mem_re ;
  rf_mem_we_any                 = | rf_mem_we ;

  wait_for_ack_nxt              = wait_for_ack_f ;
  if ( cfgsc_cfg_mem_re | cfgsc_cfg_mem_we ) begin
    wait_for_ack_nxt            = 1'b1 ;
  end
  if ( rf_mem_re_any | rf_mem_we_any ) begin
    wait_for_ack_nxt            = 1'b0 ;
  end

  mem_ack_nxt                   = ( rf_mem_re_any & ( wait_for_ack_f | cfgsc_cfg_mem_re ) ) |
                                  ( rf_mem_we_any & ( wait_for_ack_f | cfgsc_cfg_mem_we ) ) ;

  cfgsc_cfg_mem_rdata           = func_mem_rdata [ 0 +: MEM_DWIDTH ] ;
  for ( int i = 0 ; i < NUM_MEMS; i = i + 1 ) begin
    if ( mem_sel_f == i ) begin
      cfgsc_cfg_mem_rdata       = func_mem_rdata [ (i * MEM_DWIDTH) +: MEM_DWIDTH ] ;
    end
  end

end // always

always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    mem_sel_f                   <= '0 ;
    wait_for_ack_f              <= 1'b0 ;
    mem_ack_f                   <= 1'b0 ;
  end
  else begin
    mem_sel_f                   <= mem_sel_nxt ;
    wait_for_ack_f              <= wait_for_ack_nxt ;
    mem_ack_f                   <= mem_ack_nxt ;
  end
end // always

assign cfgsc_cfg_mem_ack        = mem_ack_f ;

//==============================================================
// Response interface to memory AW
assign mem_read_data            = func_mem_rdata ;
assign func_mem_waddr           = func_mem_addr ;
assign func_mem_raddr           = func_mem_addr ;

endmodule
