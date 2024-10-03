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
// hqm_AW_rf_mem_3pipe_core : 3 stage read pipeline plus write port for regfile with no possibility of read vs. write collision
//
// Functions
//   RAM READ : command is issued on p0_*_nxt input and the data is available on p2_*_f
//   RAM WRITE : command is issued on px_*_nxt interface. The RAM write is issued independently of the read pipe with no comparisons or holds.
//
// Pipeline definition
//   p0 : issue RAM read. Will not issue read unless p1 & p2 stages are not holding. This is to avoid dropping the RAM read request.
//   p1 : pipeline for RAM read access
//   p2 : capture RAM output
//
// connect to 2 port RAM through mem_* interface
// 
// input port to supply hold at p0, p1, or p2 stage.  px does not hold.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_rf_mem_3pipe_core
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH = 32
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  logic                        p0_rd_v_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt

  , input  logic                        p0_hold

  , output logic                        p0_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f

  //..............................................................................................................................................
  , input  logic                        p2_hold

  , output logic                        p2_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_nobyp_f

  , input  logic                        p2_byp_v_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p2_bypdata_nxt
  //..............................................................................................................................................
  , input  logic                        pw_v_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] pw_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] pw_data_nxt

  , output logic                        pw_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] pw_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] pw_data_f
  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_write_addr
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_read_addr
  , output logic [ (   WIDTH ) -1 : 0 ] mem_write_data
  , input  logic [ (   WIDTH ) -1 : 0 ] mem_read_data

);

//------------------------------------------------------------------------------------------------------------------------------------------------
// parameters, typedef & logic
localparam BYPASS_HOLD = 0 ;

typedef struct packed {
logic hold ;
logic  [ ( 2 ) -1 : 0 ] bypsel ;
logic ctrlenable ;
logic dataenable ;
} ctrl_t ;

logic  mem_read_f ;
logic  mem_read_ignoredata_f , mem_read_ignoredata_nxt ;
logic  reg_p0_v_f , reg_p0_v_nxt ;
logic  reg_p0_rd_v_f , reg_p0_rd_v_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p0_addr_f , reg_p0_addr_nxt ;
ctrl_t reg_p0_ctrl;
logic  reg_p1_v_f , reg_p1_v_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p1_addr_f , reg_p1_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p1_data_f , reg_p1_data_nxt ;
ctrl_t reg_p1_ctrl;
logic  reg_p2_v_f , reg_p2_v_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p2_addr_f , reg_p2_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p2_data_f , reg_p2_data_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p2_data_nobyp_f , reg_p2_data_nobyp_nxt ;
ctrl_t reg_p2_ctrl;

logic  reg_pw_v_f , reg_pw_v_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_pw_addr_f , reg_pw_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_pw_data_f , reg_pw_data_nxt ;

logic reg_p0_ctrl_dataenable_nc;


logic part_nc ;
assign part_nc = 
( |reg_p0_ctrl )
& ( |reg_p1_ctrl )
& ( |reg_p2_ctrl )
;

//------------------------------------------------------------------------------------------------------------------------------------------------
// flops
always_ff @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    mem_read_f <= 0;
    mem_read_ignoredata_f <= 0;
    reg_p0_v_f <= 0 ;
    reg_p1_v_f <= 0 ;
    reg_p2_v_f <= 0 ;
    reg_pw_v_f <= 0 ;
  end
  else
  begin
    mem_read_f <= mem_read;
    mem_read_ignoredata_f <= mem_read_ignoredata_nxt ;
    reg_p0_v_f <= reg_p0_v_nxt ;
    reg_p1_v_f <= reg_p1_v_nxt ;
    reg_p2_v_f <= reg_p2_v_nxt ; 
    reg_pw_v_f <= reg_pw_v_nxt ;
  end
end

always_ff @(posedge clk)
begin
    reg_p0_addr_f <= reg_p0_addr_nxt ;
    reg_p0_rd_v_f <= reg_p0_rd_v_nxt ;

    reg_p1_addr_f <= reg_p1_addr_nxt ;
    reg_p1_data_f <= reg_p1_data_nxt ;

    reg_p2_addr_f <= reg_p2_addr_nxt ;
    reg_p2_data_f <= reg_p2_data_nxt ;
    reg_p2_data_nobyp_f <= reg_p2_data_nobyp_nxt ;

    reg_pw_addr_f <= reg_pw_addr_nxt ;
    reg_pw_data_f <= reg_pw_data_nxt ;
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p0 pipeline
//   Load read operation from input ports into p0 flop stage
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  mem_read                              = 1'b0 ;
  mem_read_addr                         = '0 ;
  p0_v_f                                = reg_p0_v_f ;
  p0_addr_f                             = reg_p0_addr_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p0_v_nxt                          = 1'b0 ;
  reg_p0_rd_v_nxt                       = reg_p0_rd_v_f ;
  reg_p0_addr_nxt                       = reg_p0_addr_f ;
  mem_read_ignoredata_nxt               = mem_read_ignoredata_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p0_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P0 control
  reg_p0_ctrl.hold                      = reg_p0_v_f & ( p0_hold | reg_p1_ctrl.hold ) ;
  reg_p0_ctrl.dataenable                = ( p0_v_nxt & ~reg_p0_ctrl.hold ) ;
  reg_p0_ctrl.ctrlenable                = ( p0_v_nxt & ~reg_p0_ctrl.hold ) ;

  if ( reg_p0_ctrl.ctrlenable ) begin
    reg_p0_rd_v_nxt                     = p0_rd_v_nxt ;
    reg_p0_addr_nxt                     = p0_addr_nxt ;
  end

  if ( ( reg_p0_ctrl.ctrlenable ) | ( reg_p0_ctrl.hold ) ) begin
    reg_p0_v_nxt                        = 1'b1 ;
  end

  //..............................................................................................................................................
  // P0 Function : RAM operation -- READ
  //   With operation flopped into p0, perform RAM READ operation 
  //   DO NOT perform RAM read until p2 is not holding so that the RAM output can be captured
  //   Do not want paths from input ports to memory so do not attempt to save power by blocking mem read if reg_p1_ctrl.hold.
  if ( reg_p0_v_f ) begin
      mem_read                          = reg_p0_rd_v_f ;
      mem_read_addr                     = reg_p0_addr_f ;
      mem_read_ignoredata_nxt           = reg_p1_ctrl.hold | ~ reg_p0_rd_v_f ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p1 pipeline
//   move data to align with RAM read from P0 stage
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p1_v_f                                = reg_p1_v_f ;
  p1_addr_f                             = reg_p1_addr_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p1_v_nxt                          = 1'b0 ;
  reg_p1_addr_nxt                       = reg_p1_addr_f ;
  reg_p1_data_nxt                       = reg_p1_data_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p1_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P1 control
  reg_p1_ctrl.hold                      = reg_p1_v_f & ( p1_hold | reg_p2_ctrl.hold ) ;
  reg_p1_ctrl.bypsel[ BYPASS_HOLD ]     = ( ( p1_hold | reg_p2_ctrl.hold ) & ( mem_read_f & ! mem_read_ignoredata_f ) ) ; // BYPASS : when p2 is holding then load the mem read into p1
  reg_p1_ctrl.dataenable                = reg_p1_ctrl.bypsel[ BYPASS_HOLD ] ;
  reg_p1_ctrl.ctrlenable                = ( reg_p0_v_f & ~p0_hold & ~reg_p1_ctrl.hold ) ;

  if ( reg_p1_ctrl.dataenable ) begin
    if ( reg_p1_ctrl.bypsel[ BYPASS_HOLD ] ) begin
      reg_p1_data_nxt                   = mem_read_data ;
    end
  end

  if ( reg_p1_ctrl.ctrlenable ) begin
    reg_p1_addr_nxt                     = reg_p0_addr_f ;
  end

  if ( ( reg_p1_ctrl.ctrlenable ) | ( reg_p1_ctrl.hold ) ) begin
    reg_p1_v_nxt                        = 1'b1 ;
  end

end

assign p2_data_f                        = reg_p2_data_f ;
assign p2_data_nobyp_f                  = reg_p2_data_nobyp_f ;

//------------------------------------------------------------------------------------------------------------------------------------------------
// p2 pipeline
//     capture the read data from RAM into p2 pipeline
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p2_v_f                                = reg_p2_v_f ;
  p2_addr_f                             = reg_p2_addr_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p2_v_nxt                          = 1'b0 ;
  reg_p2_addr_nxt                       = reg_p2_addr_f ;
  reg_p2_data_nxt                       = reg_p2_data_f ;
  reg_p2_data_nobyp_nxt                 = reg_p2_data_nobyp_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p2_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P2 control
  reg_p2_ctrl.hold                      = reg_p2_v_f & p2_hold ;
  reg_p2_ctrl.dataenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;
  reg_p2_ctrl.ctrlenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;
  reg_p2_ctrl.bypsel                    = '0 ;

  if ( reg_p2_ctrl.dataenable ) begin
    if ( p2_byp_v_nxt ) begin
      reg_p2_data_nxt                   = p2_bypdata_nxt ;
    end
    else if ( ( mem_read_f == 1'd1 ) & ! mem_read_ignoredata_f ) begin
      reg_p2_data_nxt                   = mem_read_data ;
    end
    else begin
      reg_p2_data_nxt                   = reg_p1_data_f ;
    end

    if ( ( mem_read_f == 1'd1 ) & ! mem_read_ignoredata_f ) begin
      reg_p2_data_nobyp_nxt             = mem_read_data ;
    end
    else begin
      reg_p2_data_nobyp_nxt             = reg_p1_data_f ;
    end
  end

  if ( reg_p2_ctrl.ctrlenable ) begin
    reg_p2_addr_nxt                     = reg_p1_addr_f ;
  end

  if ( ( reg_p2_ctrl.ctrlenable ) | ( reg_p2_ctrl.hold ) ) begin
    reg_p2_v_nxt                        = 1'b1 ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// pw pipeline
//   Load write operation from input ports into pw flop stage
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  mem_write                             = 1'b0 ;
  mem_write_addr                        = '0 ;
  mem_write_data                        = '0 ;
  pw_v_f                                = reg_pw_v_f ;
  pw_addr_f                             = reg_pw_addr_f ;
  pw_data_f                             = reg_pw_data_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_pw_v_nxt                          = 1'b0 ;
  reg_pw_addr_nxt                       = reg_pw_addr_f ;
  reg_pw_data_nxt                       = reg_pw_data_f ;

  if ( pw_v_nxt ) begin
    reg_pw_v_nxt                        = 1'b1 ;
    reg_pw_addr_nxt                     = pw_addr_nxt ;
    reg_pw_data_nxt                     = pw_data_nxt ;
  end

  //..............................................................................................................................................
  // PW Function : RAM operation -- WRITE
  if ( reg_pw_v_f ) begin
      mem_write                         = 1'b1 ;
      mem_write_addr                    = reg_pw_addr_f ;
      mem_write_data                    = reg_pw_data_f ;
  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// status & errors
assign status = { ( p0_v_nxt & reg_p0_ctrl.hold ) } ;
assign reg_p0_ctrl_dataenable_nc = reg_p0_ctrl.dataenable; 

//-----------------------------------------------------------------------------------------------------
// Assertions - may want to move to separate file eventually

`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RF_MEM_3PIPE_MODEL_ON
  // data, and when it has not performed any expected writes.
  logic                                         dbg_p0_v_f ;
  logic                                         dbg_p1_v_f ;
  logic                                         dbg_p2_v_f ;
  logic                                         dbg_int_p0_hold ;
  logic                                         dbg_int_p1_hold ;
  logic                                         dbg_int_p2_hold ;
  logic                                         dbg_err_input_v_f ;
  logic                                         dbg_err_rw_collide_f ;
  logic                                         dbg_err_rdata_neq_f ;
  logic                                         dbg_err_rdata_nobyp_neq_f ;
  logic                                         dbg_p0_en ;
  logic                                         dbg_p1_en ;
  logic                                         dbg_p2_en ;
  logic                                         dbg_err_susp_p0_hold_f ;
  logic                                         dbg_err_susp_p1_hold_f ;
  logic                                         dbg_err_susp_p2_hold_f ;
  logic                                         dbg_err_jg_error_rw_0_f ;
  logic                                         dbg_err_jg_error_rw_1_f ;
  logic                                         dbg_err_jg_error_rw_2_f ;
  logic                                         dbg_err_jg_error_rw_3_f ;
  logic                                         dbg_err_jg_error_noop_byp_f ;
  logic                                         dbg_err_jg_error_bypass_h1_f ;
  logic                                         dbg_err_jg_error_bypass_h2_f ;
  logic                                         dbg_err_jg_error_bypass_v_f ;
  logic                                         dbg_p0_rd_v_f ;
  logic [ ( DEPTHB2 ) -1 : 0 ]                  dbg_p0_addr_f ;
  logic                                         dbg_p1_rd_v_f ;
  logic [ ( DEPTHB2 ) -1 : 0 ]                  dbg_p1_addr_f ;
  logic                                         dbg_p2_rd_v_f ;
  logic                                         dbg_p2_byp_v_f ;
  logic [ ( DEPTHB2 ) -1 : 0 ]                  dbg_p2_addr_f ;
  logic [ ( WIDTH )   -1 : 0 ]                  dbg_p2_byp_data_f ;
  logic [ ( DEPTH   ) -1 : 0 ]                  dbg_mem_v_f ;
  logic [ ( WIDTH   ) -1 : 0 ]                  dbg_exp_rdata ;
  logic [ ( WIDTH   ) -1 : 0 ]                  dbg_exp_rdata_nobyp ;
  logic                                         dbg_rddata_neq_model_check_en ;

  assign dbg_int_p2_hold                = p2_hold ;
  assign dbg_int_p1_hold                = ( dbg_p1_v_f & dbg_int_p2_hold ) | p1_hold ;
  assign dbg_int_p0_hold                = ( dbg_p0_v_f & dbg_int_p1_hold ) | p0_hold ;
  assign dbg_p0_en                      = p0_v_nxt &   ! dbg_int_p0_hold ;
  assign dbg_p1_en                      = dbg_p0_v_f & ! dbg_int_p1_hold ;
  assign dbg_p2_en                      = dbg_p1_v_f & ! dbg_int_p2_hold ;

  hqm_assertion_mem #(
          .DEPTH                ( DEPTH )
        , .DWIDTH               ( WIDTH )
        , .INIT                 ( 0 )
  ) i_hqm_assertion_mem (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .we                   ( pw_v_nxt )
        , .waddr                ( pw_addr_nxt )
        , .wdata                ( pw_data_nxt )
        , .re                   ( dbg_p2_v_f )
        , .raddr                ( dbg_p2_addr_f )
        , .rdata                ( dbg_exp_rdata_nobyp )
  ) ;

  always_comb begin
    if ( dbg_p2_byp_v_f ) begin
      dbg_exp_rdata             = dbg_p2_byp_data_f ;
    end
    else begin
      dbg_exp_rdata             = dbg_exp_rdata_nobyp ;
    end

    // JG does not properly interpret plusarg; written this way to tolerate that
    dbg_rddata_neq_model_check_en       = 1'b1 ;
    if ( $test$plusargs("HQM_DYNAMIC_CONFIG") )
      dbg_rddata_neq_model_check_en     = 1'b0 ;
  end // always

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) begin
      dbg_p0_v_f                       <= 1'b0 ;
      dbg_p1_v_f                       <= 1'b0 ;
      dbg_p2_v_f                       <= 1'b0 ;
      dbg_p0_rd_v_f                    <= 1'b0 ;
      dbg_p1_rd_v_f                    <= 1'b0 ;
      dbg_p2_rd_v_f                    <= 1'b0 ;
      dbg_p0_addr_f                    <= '0 ;
      dbg_p1_addr_f                    <= '0 ;
      dbg_p2_addr_f                    <= '0 ;
      dbg_p2_byp_v_f                   <= 1'b0 ;
      dbg_p2_byp_data_f                <= '0 ;
      dbg_err_input_v_f                <= 1'b0 ;
      dbg_err_rw_collide_f             <= 1'b0 ;
      dbg_mem_v_f                      <= '0 ;
      dbg_err_rdata_neq_f              <= 1'b0 ;
      dbg_err_rdata_nobyp_neq_f        <= 1'b0 ;
      dbg_err_susp_p0_hold_f           <= 1'b0 ;
      dbg_err_susp_p1_hold_f           <= 1'b0 ;
      dbg_err_susp_p2_hold_f           <= 1'b0 ;
      dbg_err_jg_error_rw_0_f          <= 1'b0 ;
      dbg_err_jg_error_rw_1_f          <= 1'b0 ;
      dbg_err_jg_error_rw_2_f          <= 1'b0 ;
      dbg_err_jg_error_rw_3_f          <= 1'b0 ;
      dbg_err_jg_error_noop_byp_f      <= 1'b0 ;
      dbg_err_jg_error_bypass_h1_f     <= 1'b0 ;
      dbg_err_jg_error_bypass_h2_f     <= 1'b0 ;
      dbg_err_jg_error_bypass_v_f      <= 1'b0 ;
    end // if ~rst_n
    else begin
      dbg_p0_v_f                       <= ( dbg_p0_v_f & dbg_int_p0_hold ) | p0_v_nxt ;
      dbg_p1_v_f                       <= ( dbg_p1_v_f & dbg_int_p1_hold ) | ( dbg_p0_v_f & ! p0_hold ) ; // External p0 could be holding for a reason other than p1
      dbg_p2_v_f                       <= ( dbg_p2_v_f & dbg_int_p2_hold ) | ( dbg_p1_v_f & ! p1_hold ) ; // External p1 could be holding for a reason other than p2
      if ( dbg_p0_en ) begin
        dbg_p0_rd_v_f                  <= p0_rd_v_nxt ;
        dbg_p0_addr_f                  <= p0_addr_nxt ;
      end
      if ( dbg_p1_en ) begin
        dbg_p1_rd_v_f                  <= dbg_p0_rd_v_f ;
        dbg_p1_addr_f                  <= dbg_p0_addr_f ;
      end
      if ( dbg_p2_en ) begin
        dbg_p2_rd_v_f                  <= dbg_p1_rd_v_f ;
        dbg_p2_addr_f                  <= dbg_p1_addr_f ;
        dbg_p2_byp_v_f                 <= p2_byp_v_nxt ;
        dbg_p2_byp_data_f              <= p2_bypdata_nxt ;
      end
      dbg_err_input_v_f                <= p0_v_nxt & dbg_int_p0_hold ;
      dbg_err_rw_collide_f             <= mem_write & mem_read & ( mem_write_addr == mem_read_addr ) ;
      if ( pw_v_nxt ) begin
        dbg_mem_v_f [ pw_addr_nxt ]    <= dbg_rddata_neq_model_check_en ;
      end
      dbg_err_rdata_neq_f              <= dbg_p2_v_f & dbg_p2_rd_v_f & dbg_mem_v_f [ dbg_p2_addr_f ] & ( p2_data_f != dbg_exp_rdata ) ;
      dbg_err_rdata_nobyp_neq_f        <= dbg_p2_v_f & dbg_p2_rd_v_f & dbg_mem_v_f [ dbg_p2_addr_f ] & ( p2_data_nobyp_f != dbg_exp_rdata_nobyp ) ;
      dbg_err_susp_p0_hold_f           <= p0_hold & ! dbg_p0_v_f ;
      dbg_err_susp_p1_hold_f           <= p1_hold & ! dbg_p1_v_f ;
      dbg_err_susp_p2_hold_f           <= p2_hold & ! dbg_p2_v_f ;
      dbg_err_jg_error_rw_0_f          <= pw_v_nxt & p0_v_nxt & p0_rd_v_nxt & ( pw_addr_nxt == p0_addr_nxt ) ;
      dbg_err_jg_error_rw_1_f          <= pw_v_nxt & dbg_p0_v_f & dbg_p0_rd_v_f & ( pw_addr_nxt == dbg_p0_addr_f ) ;
      dbg_err_jg_error_rw_2_f          <= pw_v_nxt & dbg_p1_v_f & dbg_p1_rd_v_f & ( pw_addr_nxt == dbg_p1_addr_f ) ;
      dbg_err_jg_error_rw_3_f          <= pw_v_nxt & dbg_p2_v_f & dbg_p2_rd_v_f & ( pw_addr_nxt == dbg_p2_addr_f ) ;
      dbg_err_jg_error_noop_byp_f      <= dbg_p1_v_f & ! dbg_p1_rd_v_f & p2_byp_v_nxt ;
      dbg_err_jg_error_bypass_h1_f     <= dbg_int_p1_hold & p2_byp_v_nxt ;
      dbg_err_jg_error_bypass_h2_f     <= dbg_int_p2_hold & p2_byp_v_nxt ;
      dbg_err_jg_error_bypass_v_f      <= ! dbg_p1_v_f & p2_byp_v_nxt ;
    end // else ~rst_n
  end // always

    hqm_AW_rf_mem_3pipe_assert i_hqm_AW_rf_mem_3pipe_assert (.*) ;
`endif
`endif


`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge clk);
  WCP_P0N_LL: coverpoint { p0_v_nxt } iff (rst_n) ;
  WCP_P0V_LL: coverpoint { reg_p0_v_f } iff (rst_n) ;
  WCP_P1V_LL: coverpoint { reg_p1_v_f } iff (rst_n) ;
  WCP_P2V_LL: coverpoint { reg_p2_v_f } iff (rst_n) ;
  WCP_PwV_LL: coverpoint { reg_pw_v_f } iff (rst_n) ;
  WCX_P: cross WCP_P0N_LL,WCP_P0V_LL,WCP_P1V_LL,WCP_P2V_LL,WCP_PwV_LL ;
  
  WCP_H0V_LL: coverpoint { reg_p0_ctrl.hold } iff (rst_n) ;
  WCP_H1V_LL: coverpoint { reg_p1_ctrl.hold } iff (rst_n) ;
  WCP_H2V_LL: coverpoint { reg_p2_ctrl.hold } iff (rst_n) ;
  WCX_H: cross WCP_H0V_LL,WCP_H1V_LL,WCP_H2V_LL ;
endgroup
COVERGROUP u_COVERGROUP = new();
`endif

endmodule // hqm_AW_rf_mem_3pipe_core

`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RF_MEM_3PIPE_MODEL_ON

module hqm_AW_rf_mem_3pipe_assert import hqm_AW_pkg::*; (
          input logic clk
        , input logic rst_n
        , input logic dbg_err_input_v_f
        , input logic dbg_err_rw_collide_f
        , input logic dbg_err_rdata_neq_f
        , input logic dbg_err_rdata_nobyp_neq_f
        , input logic dbg_err_susp_p0_hold_f
        , input logic dbg_err_susp_p1_hold_f
        , input logic dbg_err_susp_p2_hold_f
        , input logic dbg_err_jg_error_rw_0_f
        , input logic dbg_err_jg_error_rw_1_f
        , input logic dbg_err_jg_error_rw_2_f
        , input logic dbg_err_jg_error_rw_3_f
        , input logic dbg_err_jg_error_noop_byp_f
        , input logic dbg_err_jg_error_bypass_h1_f
        , input logic dbg_err_jg_error_bypass_h2_f
        , input logic dbg_err_jg_error_bypass_v_f
);

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_input_v
                      , dbg_err_input_v_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_input_v: On previous clock AW_rf_mem parent module attempted new p0 command while 'p0' should have been holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_rw_collide
                      , dbg_err_rw_collide_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_rw_collide: On previous clock AW_rf_mem parent module attempted write of same address which AW_rf_mem was reading !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_rdata_neq
                      , dbg_err_rdata_neq_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_rdata_neq : On previous clock AW_rf_mem output read data not equal to expected value !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_rdata_nobyp_neq
                      , dbg_err_rdata_nobyp_neq_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_rdata_nobyp_neq : On previous clock AW_rf_mem output read data nobyp not equal to expected value !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p0_hold
                      , dbg_err_susp_p0_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p0_hold : On previous clock AW_rf_mem parent module asserted p0_hold=1 but p0 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p1_hold
                      , dbg_err_susp_p1_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p1_hold : On previous clock AW_rf_mem parent module asserted p1_hold=1 but p1 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p2_hold
                      , dbg_err_susp_p2_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p2_hold : On previous clock AW_rf_mem parent module asserted p2_hold=1 but p2 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_rw_0
                      , dbg_err_jg_error_rw_0_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_rw_0 : On previous clock AW_rf_mem parent module wrote and read same address !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_rw_1
                      , dbg_err_jg_error_rw_1_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_rw_1 : On previous clock AW_rf_mem parent module wrote same address as p0 read addr !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_rw_2
                      , dbg_err_jg_error_rw_2_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_rw_2 : On previous clock AW_rf_mem parent module wrote same address as p1 read addr !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_rw_3
                      , dbg_err_jg_error_rw_3_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_rw_3 : On previous clock AW_rf_mem parent module wrote same address as p2 read addr !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_noop_byp
                      , dbg_err_jg_error_noop_byp_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_noop_byp : On previous clock AW_rf_mem parent module attempted p2 bypass when p1 was not a valid read cmd !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_bypass_h1
                      , dbg_err_jg_error_bypass_h1_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_bypass_h1 : On previous clock AW_rf_mem parent module attempted p2 bypass when p1 was holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_bypass_h2
                      , dbg_err_jg_error_bypass_h2_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_bypass_h2 : On previous clock AW_rf_mem parent module attempted p2 bypass when p2 was holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_jg_error_bypass_v
                      , dbg_err_jg_error_bypass_v_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_jg_error_bypass_v : On previous clock AW_rf_mem parent module attempted p2 bypass when p2 was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
endmodule // hqm_AW_rf_mem_3pipe_assert
`endif
`endif
