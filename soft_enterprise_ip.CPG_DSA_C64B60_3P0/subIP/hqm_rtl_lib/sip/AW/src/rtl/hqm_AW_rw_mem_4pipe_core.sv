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
// hqm_AW_rw_mem_4pipe : 4 stage pipeline for RAM read, write
//
// Functions
//   RAM READ : command is issued on p0_*_nxt input and the data is avaible on p2_*_f or p3_*_f interfacew
//   RAM WRITE : command is issued on p0_*_nxt interface. THe RAM write is issued on the p3_*_f interface
//
// Pipeline defention
//   p0 : issue RAM read. Will not issue read unless p1 & p2 stages are not holding. THis is to avoid dropping the RAM read request.
//        will avoid read/write to same address and abort the RAM read and capture the new write data into data pipline
//   p1 : pipeline for RAM read access
//   p2 : capture RAM output
//   p3 : issue RAM write - to match RMW_4PORT timing
//
// connect to 1 port (1 shared read & write) RAM through mem_* interface
// 
// input port to supply hold at p1, p2, or p3 stage
//
// supply each pipe stage valid, command, and address output port for external collision detection or to determine when the pipe is idle.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_rw_mem_4pipe_core
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH = 32
  , parameter BLOCK_WRITE_ON_P0_HOLD = 0
  , parameter NO_RDATA_ASSERT = 0
  , parameter PARAM_MASK = {WIDTH{1'b1}}
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  aw_rwpipe_cmd_t              p0_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_write_data_nxt

  , input  logic                        p0_byp_v_nxt
  , input  aw_rwpipe_cmd_t              p0_byp_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_byp_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_byp_write_data_nxt

  , input  logic                        p0_hold

  , output logic                        p0_v_f
  , output aw_rwpipe_cmd_t              p0_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p0_data_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output aw_rwpipe_cmd_t              p1_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p1_data_f

  //..............................................................................................................................................
  , input  logic                        p2_hold

  , output logic                        p2_v_f
  , output aw_rwpipe_cmd_t              p2_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f

  //..............................................................................................................................................
  , input  logic                        p3_hold

  , output logic                        p3_v_f
  , output aw_rwpipe_cmd_t              p3_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p3_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p3_data_f

  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_addr
  , output logic [ (   WIDTH ) -1 : 0 ] mem_write_data
  , input  logic [ (   WIDTH ) -1 : 0 ] mem_read_data

);

//------------------------------------------------------------------------------------------------------------------------------------------------
// paramters, typedef & logic
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
aw_rwpipe_cmd_t        reg_p0_rw_f , reg_p0_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p0_addr_f , reg_p0_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p0_data_f , reg_p0_data_nxt ;
ctrl_t reg_p0_ctrl;
logic  reg_p1_v_f , reg_p1_v_nxt ;
aw_rwpipe_cmd_t        reg_p1_rw_f , reg_p1_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p1_addr_f , reg_p1_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p1_data_f , reg_p1_data_nxt ;
ctrl_t reg_p1_ctrl;
logic  reg_p2_v_f , reg_p2_v_nxt ;
aw_rwpipe_cmd_t        reg_p2_rw_f , reg_p2_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p2_addr_f , reg_p2_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p2_data_f , reg_p2_data_nxt ;
ctrl_t reg_p2_ctrl;
logic  reg_p3_v_f , reg_p3_v_nxt ;
aw_rwpipe_cmd_t        reg_p3_rw_f , reg_p3_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p3_addr_f , reg_p3_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p3_data_f , reg_p3_data_nxt ;
ctrl_t reg_p3_ctrl;
logic  mem_read_hold_f , mem_read_hold_nxt ;

logic part_nc ;
assign part_nc = 
( |reg_p0_ctrl )
& ( |reg_p1_ctrl )   
& ( |reg_p2_ctrl )   
& ( |reg_p3_ctrl )   
;

//------------------------------------------------------------------------------------------------------------------------------------------------
// flops
always_ff @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    mem_read_f <= 0;
    mem_read_hold_f <= 0;
    mem_read_ignoredata_f <= 0;
    reg_p0_v_f <= 0 ;
    reg_p1_v_f <= 0 ;
    reg_p2_v_f <= 0 ;
    reg_p3_v_f <= 0 ;
  end
  else
  begin
    mem_read_f <= mem_read;
    mem_read_hold_f <= mem_read_hold_nxt ;
    mem_read_ignoredata_f <= mem_read_ignoredata_nxt ;
    reg_p0_v_f <= reg_p0_v_nxt ;
    reg_p1_v_f <= reg_p1_v_nxt ;
    reg_p2_v_f <= reg_p2_v_nxt ;
    reg_p3_v_f <= reg_p3_v_nxt ;
  end
end

always_ff @(posedge clk)
begin
    reg_p0_rw_f <= reg_p0_rw_nxt ;
    reg_p0_addr_f <= reg_p0_addr_nxt ;
    reg_p0_data_f <= reg_p0_data_nxt ;

    reg_p1_rw_f <= reg_p1_rw_nxt ;
    reg_p1_addr_f <= reg_p1_addr_nxt ;
    reg_p1_data_f <= reg_p1_data_nxt ;

    reg_p2_rw_f <= reg_p2_rw_nxt ;
    reg_p2_addr_f <= reg_p2_addr_nxt ;
    reg_p2_data_f <= reg_p2_data_nxt ;

    reg_p3_rw_f <= reg_p3_rw_nxt ;
    reg_p3_addr_f <= reg_p3_addr_nxt ;
    reg_p3_data_f <= reg_p3_data_nxt ;
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p0 pipeline
//   Load operation from input ports into p0 flop stage
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  mem_read                              = 1'b0 ;
  mem_write                             = 1'b0 ;
  mem_addr                              = '0 ;
  mem_write_data                        = '0 ;
  p0_v_f                                = reg_p0_v_f ;
  p0_rw_f                               = reg_p0_rw_f ;
  p0_addr_f                             = reg_p0_addr_f ;
  p0_data_f                             = reg_p0_data_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p0_v_nxt                          = 1'b0 ;
  reg_p0_rw_nxt                         = reg_p0_rw_f ;
  reg_p0_addr_nxt                       = reg_p0_addr_f ;
  reg_p0_data_nxt                       = reg_p0_data_f ;
  mem_read_ignoredata_nxt               = mem_read_ignoredata_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p0_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P0 control
  reg_p0_ctrl.hold                      = reg_p0_v_f & ( p0_hold | reg_p1_ctrl.hold ) ;
  reg_p0_ctrl.dataenable                = ( p0_v_nxt & ~reg_p0_ctrl.hold ) ;
  reg_p0_ctrl.ctrlenable                = ( p0_v_nxt & ~reg_p0_ctrl.hold ) ;

  if ( reg_p0_ctrl.dataenable ) begin
    reg_p0_data_nxt                     = p0_write_data_nxt ;
  end

  if ( reg_p0_ctrl.ctrlenable ) begin
    reg_p0_rw_nxt                       = p0_rw_nxt ;
    reg_p0_addr_nxt                     = p0_addr_nxt ;
  end

  if ( p0_byp_v_nxt ) begin
    reg_p0_rw_nxt                       = p0_byp_rw_nxt ;
    reg_p0_addr_nxt                     = p0_byp_addr_nxt ;
    reg_p0_data_nxt                     = p0_byp_write_data_nxt ;
  end

  if ( ( reg_p0_ctrl.ctrlenable ) | ( reg_p0_ctrl.hold ) ) begin
    reg_p0_v_nxt                        = 1'b1 ;
  end

  //..............................................................................................................................................
  // P0 Function : RAM operation -- READ
  //   With operation flopped into p0, perform RAM READ operation 
  //   DO NOT perform RAM read until p2 is not holding so that the RAM output can be captured
  //   If a memory write to same address is issued then abort the read and load the new write data into the 
  //   Do not want paths from input ports to memory so do not attempt to save power by blocking mem read/write if reg_p1_ctrl.hold.
  if ( reg_p0_v_f ) begin
    if ( reg_p0_rw_f == HQM_AW_RWPIPE_READ ) begin
      mem_read                          = 1'b1 ;
      mem_addr                          = reg_p0_addr_f ;
      mem_read_ignoredata_nxt           = reg_p1_ctrl.hold ;
    end
    if ( reg_p0_rw_f == HQM_AW_RWPIPE_WRITE ) begin
      mem_write                         = 1'b1 ;
      mem_addr                          = reg_p0_addr_f ;
      mem_write_data                    = reg_p0_data_f ;
    end
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p1 pipeline
//   move data to align with RAM read from P0 stage
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p1_v_f                                = reg_p1_v_f ;
  p1_rw_f                               = reg_p1_rw_f ;
  p1_addr_f                             = reg_p1_addr_f ;
  p1_data_f                             = reg_p1_data_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p1_v_nxt                          = 1'b0 ;
  reg_p1_rw_nxt                         = reg_p1_rw_f ;
  reg_p1_addr_nxt                       = reg_p1_addr_f ;
  reg_p1_data_nxt                       = reg_p1_data_f ;
  mem_read_hold_nxt                     = mem_read_hold_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p1_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P1 control
  reg_p1_ctrl.hold                      = reg_p1_v_f & ( p1_hold | reg_p2_ctrl.hold ) ;
  reg_p1_ctrl.bypsel[ BYPASS_HOLD ]     = ( ( p1_hold | reg_p2_ctrl.hold ) & ( mem_read_f & ! mem_read_ignoredata_f ) ) ; // BYPASS : when p2 is holding then load the mem read into p1
  reg_p1_ctrl.dataenable                = ( reg_p0_v_f & ~p0_hold & ~reg_p1_ctrl.hold ) | reg_p1_ctrl.bypsel[ BYPASS_HOLD ] ;
  reg_p1_ctrl.ctrlenable                = ( reg_p0_v_f & ~p0_hold & ~reg_p1_ctrl.hold ) ;

  if ( reg_p2_ctrl.hold == 1'b0 ) begin
    mem_read_hold_nxt                   = 1'b0 ;
  end
  if ( reg_p1_ctrl.dataenable ) begin
    if ( reg_p1_ctrl.bypsel[ BYPASS_HOLD ] ) begin
      reg_p1_data_nxt                   = mem_read_data ;
      mem_read_hold_nxt                 = 1'b1 ;
    end
    else begin
      reg_p1_data_nxt                   = reg_p0_data_f ;
    end
  end

  if ( reg_p1_ctrl.ctrlenable ) begin
    reg_p1_rw_nxt                       = reg_p0_rw_f ;
    reg_p1_addr_nxt                     = reg_p0_addr_f ;
  end

  if ( ( reg_p1_ctrl.ctrlenable ) | ( reg_p1_ctrl.hold ) ) begin
    reg_p1_v_nxt                        = 1'b1 ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p2 pipeline
//     capture the read data from RAM into p2 pipline, or bypass when there is a address collision
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p2_v_f                                = reg_p2_v_f ;
  p2_rw_f                               = reg_p2_rw_f ;
  p2_addr_f                             = reg_p2_addr_f ;
  if ( mem_read_hold_f  & ( reg_p1_v_f & reg_p2_v_f & ( reg_p1_addr_f == reg_p2_addr_f ) ) ) begin
    p2_data_f                           = reg_p1_data_f ; //if p2 was held and RAM output stored into P1 then need to drive the correct value when the p2_hold drops
  end
  else begin
    p2_data_f                           = reg_p2_data_f ;
  end
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p2_v_nxt                          = 1'b0 ;
  reg_p2_rw_nxt                         = reg_p2_rw_f ;
  reg_p2_addr_nxt                       = reg_p2_addr_f ;
  reg_p2_data_nxt                       = reg_p2_data_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p2_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P2 control
  reg_p2_ctrl.hold                      = reg_p2_v_f & ( p2_hold | reg_p3_ctrl.hold ) ;
  reg_p2_ctrl.dataenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;
  reg_p2_ctrl.ctrlenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;
  reg_p2_ctrl.bypsel                    = '0 ;

  if ( reg_p2_ctrl.dataenable ) begin
    if ( ( ( mem_read_f == 1'd1 ) & ! mem_read_ignoredata_f ) & ( reg_p1_rw_f == HQM_AW_RWPIPE_READ ) ) begin
      reg_p2_data_nxt                   = mem_read_data ;
    end
    else begin
      reg_p2_data_nxt                   = reg_p1_data_f ;
    end
  end

  if ( reg_p2_ctrl.ctrlenable ) begin
    reg_p2_rw_nxt                       = reg_p1_rw_f ;
    reg_p2_addr_nxt                     = reg_p1_addr_f ;
  end

  if ( ( reg_p2_ctrl.ctrlenable ) | ( reg_p2_ctrl.hold ) ) begin
    reg_p2_v_nxt                        = 1'b1 ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p3 pipeline
//   RAM write operation
//     allow output logic to bypass an updated value in for the Read Modify Write operation
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p3_v_f                                = reg_p3_v_f ;
  p3_rw_f                               = reg_p3_rw_f ;
  p3_addr_f                             = reg_p3_addr_f ;
  p3_data_f                             = reg_p3_data_f ;
  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p3_v_nxt                          = 1'b0 ;
  reg_p3_rw_nxt                         = reg_p3_rw_f ;
  reg_p3_addr_nxt                       = reg_p3_addr_f ;
  reg_p3_data_nxt                       = reg_p3_data_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p3_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P3 control
  reg_p3_ctrl.hold                      = reg_p3_v_f & ( p3_hold ) ;
  reg_p3_ctrl.bypsel                    = '0 ;
  reg_p3_ctrl.dataenable                = ( reg_p2_v_f & ~p2_hold & ~reg_p3_ctrl.hold ) ;
  reg_p3_ctrl.ctrlenable                = ( reg_p2_v_f & ~p2_hold & ~reg_p3_ctrl.hold ) ;

  if ( reg_p3_ctrl.dataenable ) begin
    reg_p3_data_nxt                     = reg_p2_data_f ;
  end

  if ( reg_p3_ctrl.ctrlenable ) begin
    reg_p3_rw_nxt                       = reg_p2_rw_f ;
    reg_p3_addr_nxt                     = reg_p2_addr_f ;
  end

  if ( ( reg_p3_ctrl.ctrlenable ) | ( reg_p3_ctrl.hold ) ) begin
    reg_p3_v_nxt                        = 1'b1 ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// status & errors
assign status = { ( p0_v_nxt & reg_p0_ctrl.hold ) } ;

//-----------------------------------------------------------------------------------------------------
// Assertions - may want to move to separate file eventually

`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RW_MEM_4PIPE_MODEL_ON
  //---------------------------------------------------------------------------------------------------
  // Model the contents of FIFO memory, detect when this rmw module has not produced the correct read
  // data, and when it has not performed any expected writes.
  logic                                         dbg_p0_v_f ;
  logic                                         dbg_p1_v_f ;
  logic                                         dbg_p2_v_f ;
  logic                                         dbg_p3_v_f ;
  logic                                         dbg_int_p0_hold ;
  logic                                         dbg_int_p1_hold ;
  logic                                         dbg_int_p2_hold ;
  logic                                         dbg_int_p3_hold ;
  logic                                         dbg_err_input_v_f ;
  logic                                         dbg_err_p3_bypsel_f ;
  logic                                         dbg_err_susp_p0_hold_f ;
  logic                                         dbg_err_susp_p1_hold_f ;
  logic                                         dbg_err_susp_p2_hold_f ;
  logic                                         dbg_err_susp_p3_hold_f ;
  aw_rwpipe_cmd_t                               dbg_p0_cmd_f ;
  aw_rwpipe_cmd_t                               dbg_p1_cmd_f ;
  aw_rwpipe_cmd_t                               dbg_p2_cmd_f ;
  aw_rwpipe_cmd_t                               dbg_p3_cmd_f ;
  logic                                         dbg_p0_en ;
  logic                                         dbg_p1_en ;
  logic                                         dbg_p2_en ;
  logic                                         dbg_p3_en ;
  logic [ DEPTHB2-1:0 ]                         dbg_p0_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p1_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p2_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p3_waddr_f ;
  logic [ WIDTH-1:0 ]                           dbg_p0_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p1_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p2_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p3_data_f ;

  logic [ WIDTH-1 : 0 ]                         dbg_model_expected ;
  logic [ ( WIDTH * DEPTH ) - 1 : 0 ]           dbg_model_ram_f ;
  logic [ ( WIDTH * DEPTH ) - 1 : 0 ]           dbg_model_ram_nxt ;

  logic [DEPTH-1:0]                             dbg_model_ram_entry_v_nxt;
  logic [DEPTH-1:0]                             dbg_model_ram_entry_v_f;

  logic                                         dbg_rddata_neq_model_expected_f;
  logic                                         dbg_rddata_neq_model_expected_nxt;
  
  logic                                         dbg_rddata_neq_model_check_en;

  assign dbg_int_p3_hold                = p3_hold ;
  assign dbg_int_p2_hold                = ( dbg_p2_v_f & dbg_int_p3_hold ) | p2_hold ;
  assign dbg_int_p1_hold                = ( dbg_p1_v_f & dbg_int_p2_hold ) | p1_hold ;
  assign dbg_int_p0_hold                = ( dbg_p0_v_f & dbg_int_p1_hold ) | p0_hold ;
  assign dbg_p0_en                      = p0_v_nxt &   ! dbg_int_p0_hold ;
  assign dbg_p1_en                      = dbg_p0_v_f & ! dbg_int_p1_hold ;
  assign dbg_p2_en                      = dbg_p1_v_f & ! dbg_int_p2_hold ;
  assign dbg_p3_en                      = dbg_p2_v_f & ! dbg_int_p3_hold ;
  assign dbg_rddata_neq_model_check_en = ~$test$plusargs("HQM_DYNAMIC_CONFIG");

  

  // check data on reads and assert if there is no match 
  assign dbg_rddata_neq_model_expected_nxt = dbg_rddata_neq_model_check_en & (p2_v_f & ( p2_rw_f == HQM_AW_RWPIPE_READ ) & ( (p2_data_f & PARAM_MASK) != (dbg_model_expected & PARAM_MASK) ) & dbg_model_ram_entry_v_f[p2_addr_f]);

  always_comb begin
    dbg_model_ram_nxt = dbg_model_ram_f ;
    dbg_model_ram_entry_v_nxt = dbg_model_ram_entry_v_f ;

    dbg_model_expected = '0 ;
  
    if ( p2_v_f & ( p2_rw_f == HQM_AW_RWPIPE_READ ) ) begin 
          dbg_model_expected = dbg_model_ram_f [ ( p2_addr_f * WIDTH ) +: WIDTH ] ; 

          if (~dbg_model_ram_entry_v_f[p2_addr_f]) begin 
             dbg_model_ram_nxt[(p2_addr_f*WIDTH) +: WIDTH] = p2_data_f;
             dbg_model_ram_entry_v_nxt[p2_addr_f] = 1'b1; // set valid on first read, assumption that there will not be another side car cfg write with this assertion enabled
          end
    end
    if ( p2_v_f & ( p2_rw_f == HQM_AW_RWPIPE_WRITE ) ) begin dbg_model_ram_nxt [ ( p2_addr_f * WIDTH ) +: WIDTH ] = p2_data_f ; end
  end

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) begin
       dbg_p0_v_f                       <= 1'b0 ;
       dbg_p1_v_f                       <= 1'b0 ;
       dbg_p2_v_f                       <= 1'b0 ;
       dbg_p3_v_f                       <= 1'b0 ;
       dbg_err_input_v_f                <= 1'b0 ;
       dbg_err_susp_p0_hold_f           <= 1'b0 ;
       dbg_err_susp_p1_hold_f           <= 1'b0 ;
       dbg_err_susp_p2_hold_f           <= 1'b0 ;
       dbg_err_susp_p3_hold_f           <= 1'b0 ;
       dbg_model_ram_f <= '0 ;  // dbg model of the ram, used in assertion for reaads
       dbg_rddata_neq_model_expected_f  <= 1'b0;
       dbg_model_ram_entry_v_f <= '0;
    end // if ~rst_n
    else begin

       dbg_model_ram_f <= dbg_model_ram_nxt ;
       dbg_rddata_neq_model_expected_f  <= dbg_rddata_neq_model_expected_nxt;
       dbg_model_ram_entry_v_f <= dbg_model_ram_entry_v_nxt;

       if ( p0_byp_v_nxt ) begin
         dbg_p0_addr_f                  <= p0_byp_addr_nxt ;
         dbg_p0_data_f                  <= p0_byp_write_data_nxt & PARAM_MASK ;
         dbg_p0_cmd_f                   <= p0_byp_rw_nxt ;
       end
       else if ( dbg_p0_en ) begin 
         dbg_p0_addr_f                  <= p0_addr_nxt ;
         dbg_p0_data_f                  <= p0_write_data_nxt & PARAM_MASK ;
         dbg_p0_cmd_f                   <= p0_rw_nxt ;
       end
       if ( dbg_p1_en ) begin 
         dbg_p1_addr_f                  <= dbg_p0_addr_f ;
         dbg_p1_data_f                  <= dbg_p0_data_f & PARAM_MASK ;
         dbg_p1_cmd_f                   <= dbg_p0_cmd_f ;
       end
       if ( dbg_p2_en ) begin 
         dbg_p2_addr_f                  <= dbg_p1_addr_f ;
         dbg_p2_data_f                  <= dbg_p1_data_f & PARAM_MASK ;
         dbg_p2_cmd_f                   <= dbg_p1_cmd_f ;
       end
       if ( dbg_p3_en ) begin 
         dbg_p3_waddr_f                 <= dbg_p2_addr_f ;
         dbg_p3_data_f                  <= dbg_p2_data_f & PARAM_MASK ;
         dbg_p3_cmd_f                   <= dbg_p2_cmd_f ;
       end

       dbg_p0_v_f                       <= ( dbg_p0_v_f & dbg_int_p0_hold ) | p0_v_nxt ;
       dbg_p1_v_f                       <= ( dbg_p1_v_f & dbg_int_p1_hold ) | ( dbg_p0_v_f & ! p0_hold ) ; // External p0 could be holding for a reason other than p1
       dbg_p2_v_f                       <= ( dbg_p2_v_f & dbg_int_p2_hold ) | ( dbg_p1_v_f & ! p1_hold ) ; // External p1 could be holding for a reason other than p2
       dbg_p3_v_f                       <= ( dbg_p3_v_f & dbg_int_p3_hold ) | ( dbg_p2_v_f & ! p2_hold ) ; // External p2 could be holding for a reason other than p3
       dbg_err_input_v_f                <= p0_v_nxt & dbg_int_p0_hold ;
       dbg_err_susp_p0_hold_f           <= p0_hold & ! dbg_p0_v_f ;
       dbg_err_susp_p1_hold_f           <= p1_hold & ! dbg_p1_v_f ;
       dbg_err_susp_p2_hold_f           <= p2_hold & ! dbg_p2_v_f ;
       dbg_err_susp_p3_hold_f           <= p3_hold & ! dbg_p3_v_f ;
    end // else ~rst_n
  end // always

    hqm_AW_rw_mem_4pipe_core_assert i_hqm_AW_rw_mem_4pipe_core_assert (.*) ;
`endif
`endif


`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge clk);
  WCP_P0N_LL: coverpoint { p0_v_nxt } iff (rst_n) ;
  WCP_P0V_LL: coverpoint { reg_p0_v_f } iff (rst_n) ;
  WCP_P1V_LL: coverpoint { reg_p1_v_f } iff (rst_n) ;
  WCP_P2V_LL: coverpoint { reg_p2_v_f } iff (rst_n) ;
  WCP_P3V_LL: coverpoint { reg_p3_v_f } iff (rst_n) ;
  WCX_P: cross WCP_P0N_LL,WCP_P0V_LL,WCP_P1V_LL,WCP_P2V_LL,WCP_P3V_LL ;
  
  WCP_H0V_LL: coverpoint { reg_p0_ctrl.hold } iff (rst_n) ;
  WCP_H1V_LL: coverpoint { reg_p1_ctrl.hold } iff (rst_n) ;
  WCP_H2V_LL: coverpoint { reg_p2_ctrl.hold } iff (rst_n) ;
  WCP_H3V_LL: coverpoint { reg_p3_ctrl.hold } iff (rst_n) ;
  WCX_H: cross WCP_H0V_LL,WCP_H1V_LL,WCP_H2V_LL,WCP_H3V_LL ;
endgroup
COVERGROUP u_COVERGROUP = new();
`endif

endmodule // hqm_AW_rw_mem_4pipe_core

`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RW_MEM_4PIPE_MODEL_ON

module hqm_AW_rw_mem_4pipe_core_assert import hqm_AW_pkg::*; (
          input logic clk
        , input logic rst_n
        , input logic dbg_err_input_v_f


        , input logic dbg_err_susp_p0_hold_f
        , input logic dbg_err_susp_p1_hold_f
        , input logic dbg_err_susp_p2_hold_f
        , input logic dbg_err_susp_p3_hold_f
        , input logic dbg_rddata_neq_model_expected_f

);

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_input_v
                      , dbg_err_input_v_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_err_input_v: On previous clock AW_rmw_mem parent module attempted new p0 command while 'p0' should have been holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 












`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p0_hold
                      , dbg_err_susp_p0_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p0_hold : On previous clock AW_rmw_mem parent module asserted p0_hold=1 but p0 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p1_hold
                      , dbg_err_susp_p1_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p1_hold : On previous clock AW_rmw_mem parent module asserted p1_hold=1 but p1 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p2_hold
                      , dbg_err_susp_p2_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p2_hold : On previous clock AW_rmw_mem parent module asserted p2_hold=1 but p2 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p3_hold
                      , dbg_err_susp_p3_hold_f
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_susp_p3_hold : On previous clock AW_rmw_mem parent module asserted p3_hold=1 but p3 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

//`HQM_SDG_ASSERTS_FORBIDDEN    (assert_forbidden_dbg_rddata_neq_model_expected 
//                      , dbg_rddata_neq_model_expected_f 
//                      , clk
//                      , ~rst_n
//                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_rddata_neq_model_expected: AW_rw_mem did not provide correct read data !!! : ")
//                      ) ;

endmodule // hqm_AW_rw_mem_4pipe_core_assert
`endif
`endif
