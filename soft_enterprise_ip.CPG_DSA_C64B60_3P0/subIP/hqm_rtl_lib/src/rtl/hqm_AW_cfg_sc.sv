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
// Future Feature: update cfg_req_idlepipe & cfg_req_ready to supoprt more than 1 idle. Need new function to link target to which idle
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_cfg_sc
import hqm_AW_pkg::*, hqm_core_pkg::*; #(
  parameter MODULE = 99
, parameter NUM_CFG_TARGETS = 32
, parameter NUM_CFG_ACCESSIBLE_RAM = NUM_CFG_TARGETS
//.............................................................
) (
      input  logic                                             hqm_gated_clk
    , input  logic                                             hqm_gated_rst_n

    , input  cfg_req_t                                         unit_cfg_req
    , input  logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             unit_cfg_req_write
    , input  logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             unit_cfg_req_read
    , output logic                                             unit_cfg_rsp_ack
    , output logic                                             unit_cfg_rsp_err
    , output logic [ ( 32 ) - 1 : 0 ]                          unit_cfg_rsp_rdata

    , output cfg_req_t                                         pfcsr_cfg_req
    , output logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             pfcsr_cfg_req_write
    , output logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             pfcsr_cfg_req_read
    , input  logic                                             pfcsr_cfg_rsp_ack
    , input  logic                                             pfcsr_cfg_rsp_err
    , input  logic [ ( 32 ) - 1 : 0 ]                          pfcsr_cfg_rsp_rdata

    , output logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             cfg_req_write
    , output logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             cfg_req_read
    , output logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_re
    , output logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_we
    , output logic [ ( 20 ) - 1 : 0 ]                          cfg_mem_addr
    , output logic [ ( 12 ) - 1 : 0 ]                          cfg_mem_minbit
    , output logic [ ( 12 ) - 1 : 0 ]                          cfg_mem_maxbit
    , output logic [ ( 32 ) - 1 : 0 ]                          cfg_mem_wdata
    , input  logic [ ( NUM_CFG_ACCESSIBLE_RAM * 32 ) - 1 : 0 ] cfg_mem_rdata
    , input  logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_ack

    , output logic                                             cfg_req_idlepipe
    , input  logic                                             cfg_req_ready

    , input  logic                                             cfg_timout_enable 
    , input  logic [ ( 16 ) - 1 : 0 ]                          cfg_timout_threshold

) ;

typedef struct packed {
  logic err ;
  logic idlepipe ;
  logic read ;
  logic write ;
  logic noidle ;
  logic ram ;
  logic [ ( 8 ) - 1 : 0 ] ram_index ; //256 RAMs
  logic [ ( 12 ) - 1 : 0 ] ram_minbit ;
  logic [ ( 12 ) - 1 : 0 ] ram_maxbit ;
} ctrl_t;

localparam CFG_IDLE        = 13'h0001 ;
localparam CFG_BUSY        = 13'h0002 ;
localparam CFG_REQ_WAIT    = 13'h0004 ;
localparam CFG_REQ_ACK0    = 13'h0008 ;
localparam CFG_REQ_ACK1    = 13'h0010 ;
localparam CFG_REQ_ISSUE   = 13'h0020 ;
localparam CFG_RAM_ACCESS  = 13'h0040 ;
localparam CFG_RAM_ACCESS1 = 13'h0080 ;
localparam CFG_REG_ACCESS  = 13'h0100 ;
localparam CFG_REG_ACCESS1 = 13'h0200 ;
localparam CFG_ERR         = 13'h0400 ;
localparam CFG_TO          = 13'h0800 ;
localparam CFG_DONE        = 13'h1000 ;

ctrl_t ctrl_nxt , ctrl_f ;
logic [ ( 13 ) - 1 : 0 ] sm_nxt , sm_f ;
logic [ ( 16 ) - 1 : 0 ] timer_nxt , timer_f ;
cfg_req_t unit_cfg_req_nxt , unit_cfg_req_f ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ] unit_cfg_req_write_nxt , unit_cfg_req_write_f ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ] unit_cfg_req_read_nxt , unit_cfg_req_read_f ;
logic [ ( MAX_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write_f_padded ;
logic [ ( MAX_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read_f_padded ;

always_ff @( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin :clk_l
  if ( ~ hqm_gated_rst_n ) begin
    ctrl_f <= '0 ;
    sm_f <= CFG_IDLE ;
    timer_f <= '0 ;
    unit_cfg_req_f <= '0 ;
    unit_cfg_req_write_f <= '0 ;
    unit_cfg_req_read_f <= '0 ;
  end else begin
    ctrl_f <= ctrl_nxt ;
    sm_f <= sm_nxt ;
    timer_f <= timer_nxt ;
    unit_cfg_req_f <= unit_cfg_req_nxt ;
    unit_cfg_req_write_f <= unit_cfg_req_write_nxt ;
    unit_cfg_req_read_f <= unit_cfg_req_read_nxt ;
  end
end

logic assert_working_nc ;
always_comb begin
  assert_working_nc = 1'b0 ;

  unit_cfg_rsp_ack = '0 ;
  unit_cfg_rsp_err = '0 ;
  unit_cfg_rsp_rdata = '0 ;
  pfcsr_cfg_req = '0 ;
  pfcsr_cfg_req_write = '0 ;
  pfcsr_cfg_req_read = '0 ;
  cfg_req_write = '0 ;
  cfg_req_read = '0 ;
  cfg_mem_re = '0 ;
  cfg_mem_addr = '0 ;
  cfg_mem_minbit = '0 ;
  cfg_mem_maxbit = '0 ;
  cfg_mem_we = '0 ;
  cfg_mem_wdata = '0 ;
  cfg_req_idlepipe = ctrl_f.idlepipe ;

  ctrl_nxt = ctrl_f ;
  sm_nxt = sm_f ;
  timer_nxt = timer_f ;
  unit_cfg_req_nxt = unit_cfg_req_f ;
  unit_cfg_req_write_nxt = unit_cfg_req_write_f ;
  unit_cfg_req_read_nxt = unit_cfg_req_read_f ;

  unit_cfg_req_write_f_padded                           = '0 ;
  unit_cfg_req_write_f_padded [NUM_CFG_TARGETS-1:0]     = unit_cfg_req_write_f ;
  unit_cfg_req_read_f_padded                            = '0 ;
  unit_cfg_req_read_f_padded  [NUM_CFG_TARGETS-1:0]     = unit_cfg_req_read_f ;

  case ( sm_f )
    CFG_IDLE : begin
      sm_nxt                 = CFG_IDLE ;
    end

    CFG_BUSY : begin
      ctrl_nxt.err           = ~ hqm_cfg_allowed ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ;
      ctrl_nxt.read          = ( | unit_cfg_req_read_f ) ;
      ctrl_nxt.write         = ( | unit_cfg_req_write_f ) ;
      ctrl_nxt.noidle        = ( unit_cfg_req_f.cfg_ignore_pipe_busy ) | ( hqm_cfg_noidle ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ) ;
      ctrl_nxt.idlepipe      = ( ~ ctrl_nxt.noidle ) & ( ~ ctrl_nxt.err ) ;
      ctrl_nxt.ram           = hqm_cfg_ram ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ; 
      ctrl_nxt.ram_minbit    = hqm_cfg_ram_minbit ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ;
      ctrl_nxt.ram_maxbit    = hqm_cfg_ram_maxbit ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ; 
      ctrl_nxt.ram_index     = hqm_cfg_ram_index ( MODULE[3:0] , unit_cfg_req_write_f_padded , unit_cfg_req_read_f_padded , unit_cfg_req_f ) ; 

      timer_nxt              = '0 ;

      if ( ctrl_nxt.err ) begin
        sm_nxt               = CFG_ERR ;
      end
      else if ( ctrl_nxt.idlepipe ) begin
        sm_nxt               = CFG_REQ_WAIT ;
      end
      else begin
        sm_nxt               = CFG_REQ_ISSUE ;
      end
    end

    CFG_ERR : begin
      sm_nxt                 = CFG_DONE ;

      unit_cfg_rsp_ack       = 1'b1 ;
      unit_cfg_rsp_err       = 1'b1 ;
      unit_cfg_rsp_rdata     = 32'hacedbeef;
    end

    CFG_TO : begin
      sm_nxt                 = CFG_DONE ;

      unit_cfg_rsp_ack       = 1'b1 ;
      unit_cfg_rsp_err       = 1'b1 ;
      unit_cfg_rsp_rdata     = 32'haaaabeef;
    end

    CFG_DONE : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = '0 ;

      sm_nxt                 = CFG_IDLE ;

      unit_cfg_req_write_nxt = '0 ;
      unit_cfg_req_read_nxt  = '0 ;
      unit_cfg_req_nxt       = '0 ;

      ctrl_nxt               = '0 ;
    end
   
    CFG_REQ_WAIT : begin
      timer_nxt              = timer_f + 16'd1 ;
      if ( cfg_req_ready ) begin
        sm_nxt               = CFG_REQ_ACK0 ;
      end
    end

    CFG_REQ_ACK0 : begin //2 ACK states to help improve STA timing. This covers the case when job is issued the same clock ctrl_nxt.idlepipe set (not driven to control logic until flopped ctrl_f.idlepipe)
      timer_nxt              = timer_f + 16'd1 ;
      if ( cfg_req_ready ) begin
        sm_nxt               = CFG_REQ_ACK1 ;
      end
    end

    CFG_REQ_ACK1 : begin
      timer_nxt              = timer_f + 16'd1 ;
      if ( cfg_req_ready ) begin
        sm_nxt               = CFG_REQ_ISSUE ;
      end
    end

    CFG_REQ_ISSUE : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = timer_f + 16'd1 ;
      if ( ctrl_f.ram ) begin
        sm_nxt               = CFG_RAM_ACCESS ;
      end
      else begin
        sm_nxt               = CFG_REG_ACCESS ;
      end
    end

    CFG_RAM_ACCESS : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = timer_f + 16'd1 ;
      sm_nxt                 = CFG_RAM_ACCESS1 ;

      cfg_req_write          = unit_cfg_req_write_f ;
      cfg_req_read           = unit_cfg_req_read_f ;

      cfg_mem_re [ ctrl_f.ram_index * 1 +: 1 ] = ctrl_f.read ; 
      cfg_mem_we [ ctrl_f.ram_index * 1 +: 1 ] = ctrl_f.write ; 
      cfg_mem_addr           = unit_cfg_req_f.addr [ ( 20 ) - 1 : 0 ] ; 
      cfg_mem_minbit         = ctrl_f.ram_minbit ;
      cfg_mem_maxbit         = ctrl_f.ram_maxbit ;
      cfg_mem_wdata          = unit_cfg_req_f.wdata ;

      if ( cfg_mem_ack [ ctrl_f.ram_index * 1 +: 1 ] ) begin  
        sm_nxt               =  CFG_ERR ; //DO NOT ACCEPT immediate RAM ack since it takes minimum of 1 cycle to access
      end
    end

    CFG_RAM_ACCESS1 : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = timer_f + 16'd1 ;

      if ( cfg_mem_ack [ ctrl_f.ram_index * 1 +: 1 ] ) begin  
      sm_nxt                 = CFG_DONE ;

      unit_cfg_rsp_ack       = 1'b1 ;
      unit_cfg_rsp_err       = 1'b0 ;
      unit_cfg_rsp_rdata     = cfg_mem_rdata [ ctrl_f.ram_index * 32 +: 32 ] ;  
      end
    end

    CFG_REG_ACCESS : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = timer_f + 16'd1 ;

      pfcsr_cfg_req         = unit_cfg_req_f ;
      pfcsr_cfg_req_write   = unit_cfg_req_write_f ;
      pfcsr_cfg_req_read    = unit_cfg_req_read_f ;

      if ( pfcsr_cfg_rsp_ack ) begin 
        sm_nxt             = CFG_DONE ;

        unit_cfg_rsp_ack   = pfcsr_cfg_rsp_ack ; 
        unit_cfg_rsp_err   = pfcsr_cfg_rsp_err ; 
        unit_cfg_rsp_rdata = pfcsr_cfg_rsp_rdata ;
      end
      else begin
        sm_nxt             = CFG_REG_ACCESS1 ;
      end 
    end

    CFG_REG_ACCESS1 : begin
      assert_working_nc = 1'b1 ;
      timer_nxt              = timer_f + 16'd1 ;

      if ( pfcsr_cfg_rsp_ack ) begin
        sm_nxt             = CFG_DONE ;

        unit_cfg_rsp_ack   = pfcsr_cfg_rsp_ack ;
        unit_cfg_rsp_err   = pfcsr_cfg_rsp_err ;
        unit_cfg_rsp_rdata = pfcsr_cfg_rsp_rdata ;
      end
    end

    default : begin
      sm_nxt                 = CFG_IDLE ;
    end

  endcase

  //move outside CFG_IDLE to allow subsequent CFG access to override hung cfg access
  if ( ( | unit_cfg_req_write ) | ( | unit_cfg_req_read ) ) begin
    sm_nxt                   = CFG_BUSY ;
    unit_cfg_req_write_nxt   = unit_cfg_req_write ;
    unit_cfg_req_read_nxt    = unit_cfg_req_read ;
    unit_cfg_req_nxt         = unit_cfg_req ;
  end
  if ( cfg_timout_enable & ( timer_f >= cfg_timout_threshold ) ) begin
    timer_nxt                = '0 ;
    sm_nxt                   = CFG_TO ;
  end

end

endmodule
