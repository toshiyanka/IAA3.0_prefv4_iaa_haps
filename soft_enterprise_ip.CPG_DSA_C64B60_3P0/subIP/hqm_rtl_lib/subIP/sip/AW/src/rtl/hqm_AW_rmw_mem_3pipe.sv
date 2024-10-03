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
// hqm_AW_rmw_mem_3pipe : 3 stage pipeline for RAM read, write and read-modify-write access
// Functions
//   RAM READ : command is issued on p0_*_nxt input and the data is avaible on p2_*_f or p3_*_f interfacew
//   RAM WRITE : command is issued on p0_*_nxt interface. THe RAM write is issued on the p3_*_f interface
//   RAM RMW : command is issued on p0_*_nxt interface. The RAM read is issued on p0_*_f and the RAM write is issued on the p3_*_f.
//     * The read source data is supplied on the p2_*_f output port and the modifued updated value is supplied on p3_bypsel interface, the external
//       pipleine must match the hqm_AW_rmw_mem_pipe pipline including holds. 
//
// Pipeline definition
//   p0 : issue RAM read. Will not issue read unless p1 & p2 stages are not holding. THis is to avoid dropping the RAM read request.
//        will avoid read/write to same address and abort the RAM read and capture the new write data into data pipline
//   p1 : pipeline for RAM read access
//   p2 : write RAM. p2_next state drives the RAM output or bypassed value
//
// connect to 2 port (1 read & 1 write) RAM through mem_* interface
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

module hqm_AW_rmw_mem_3pipe
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH = 32
  , parameter NO_RDATA_ASSERT = 0
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  aw_rmwpipe_cmd_t             p0_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_write_data_nxt

  , output logic                        p0_v_f
  , output aw_rmwpipe_cmd_t             p0_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p0_data_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output aw_rmwpipe_cmd_t             p1_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p1_data_f

  //..............................................................................................................................................
  , input  logic                        p2_hold
  , input  logic                        p2_bypsel_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p2_bypdata_nxt

  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_nxt

  , output logic                        p2_v_f
  , output aw_rmwpipe_cmd_t             p2_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f

  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_write_addr
  , output logic [ (   WIDTH ) -1 : 0 ] mem_write_data
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_read_addr
  , input  logic [ (   WIDTH ) -1 : 0 ] mem_read_data

);

//------------------------------------------------------------------------------------------------------------------------------------------------
// paramters, typedef & logic
localparam BYPASS_FROM_PORTP1 = 0 ;
localparam BYPASS_FROM_PORTP2 = 1 ;

localparam BYPASS_FROM_P3N = 2 ;
localparam BYPASS_FROM_P2  = 3 ;
localparam BYPASS_FROM_P1F = 4 ;
localparam BYPASS_HOLD = 5 ;
localparam BYPASS_RWCOLIDE = 6 ;

localparam BYPASS_FROM_P2P1 = 7 ;
localparam BYPASS_FROM_P3NP1 = 8 ;

typedef struct packed {
logic  hold ;
logic [ ( 9 ) -1 : 0 ] bypsel ;
logic  ctrlenable ;
logic  dataenable ;
} ctrl_t ;

logic  reg_p1_data_bypass ;
logic  reg_p1_byp_bypass ;
logic  mem_read_f ;
logic  mem_read_hold_f , mem_read_hold_nxt ;
logic  mem_read_ignoredata_f , mem_read_ignoredata_nxt ;
logic  reg_p0_v_f , reg_p0_v_nxt ;
aw_rmwpipe_cmd_t       reg_p0_rw_f , reg_p0_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p0_addr_f , reg_p0_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p0_data_f , reg_p0_data_nxt ;
ctrl_t reg_p0_ctrl;
logic  reg_p1_v_f , reg_p1_v_nxt ;
aw_rmwpipe_cmd_t       reg_p1_rw_f , reg_p1_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p1_addr_f , reg_p1_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p1_data_f , reg_p1_data_nxt ;
ctrl_t reg_p1_ctrl;
logic  reg_p2_v_f , reg_p2_v_nxt ;
aw_rmwpipe_cmd_t       reg_p2_rw_f , reg_p2_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ] reg_p2_addr_f , reg_p2_addr_nxt ;
logic [ ( WIDTH ) -1 : 0 ] reg_p2_data_f , reg_p2_data_nxt ;
ctrl_t reg_p2_ctrl;

logic  reg_p2_v_first_f , reg_p2_v_first_nxt ;
ctrl_t reg_p3_ctrl;

logic part_nc ;         // lint tool still flags some of these bits as nc because they are tied to a constant
assign part_nc =
( |reg_p0_ctrl )
& ( |reg_p1_ctrl )
& ( |reg_p2_ctrl )
& ( |reg_p3_ctrl )
;

//------------------------------------------------------------------------------------------------------------------------------------------------
// This section for compatibility with hqm_AW_rmw_mem_4pipe_core 
logic                           p0_byp_v_nxt ;
aw_rmwpipe_cmd_t                p0_byp_rw_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ]    p0_byp_addr_nxt ;
logic [ (   WIDTH ) -1 : 0 ]    p0_byp_write_data_nxt ;
logic                           p0_hold ;
logic                           p2_bypdata_sel_nxt ;
logic                           p2_bypaddr_sel_nxt ;
logic [ ( DEPTHB2 ) -1 : 0 ]    p2_bypaddr_nxt ;
logic [ (   WIDTH ) -1 : 0 ]    reg_p3_data_nxt ;
logic                           p3_hold ;

assign p0_byp_v_nxt                             = '0 ;
assign p0_byp_rw_nxt                            = HQM_AW_RMWPIPE_NOOP ;
assign p0_byp_addr_nxt                          = '0 ;
assign p0_byp_write_data_nxt                    = '0 ;
assign p0_hold                                  = '0 ;
assign p2_bypdata_sel_nxt                       = p2_bypsel_nxt ;
assign p2_bypaddr_sel_nxt                       = '0 ;
assign p2_bypaddr_nxt                           = '0 ;
assign reg_p3_data_nxt                          = '0 ;
assign reg_p3_ctrl                              = '0 ;
assign p3_hold                                  = '0 ;

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

    reg_p2_v_first_f <= 0 ;
  end
  else
  begin
    mem_read_f <= mem_read ;
    mem_read_hold_f <= mem_read_hold_nxt ;
    mem_read_ignoredata_f <= mem_read_ignoredata_nxt ;
    reg_p0_v_f <= reg_p0_v_nxt ;
    reg_p1_v_f <= reg_p1_v_nxt ;
    reg_p2_v_f <= reg_p2_v_nxt ;

    reg_p2_v_first_f <= reg_p2_v_first_nxt ;
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




end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p0 pipeline
//   Load operation from input ports into p0 flop stage
//   Do not want paths from input ports to memory so do not attempt to save power by blocking mem read if p1_hold.
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  mem_read                              = 1'b0 ;
  mem_read_addr                         = '0 ;
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
  reg_p1_data_bypass                    = 1'b0 ;
  reg_p1_byp_bypass                     = 1'b0 ;
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

  if ( ( reg_p0_ctrl.ctrlenable ) | ( reg_p0_ctrl.hold ) ) begin
    reg_p0_v_nxt                        = 1'b1 ;
  end
  if ( p0_byp_v_nxt ) begin
    reg_p0_rw_nxt                       = p0_byp_rw_nxt ;
    reg_p0_addr_nxt                     = p0_byp_addr_nxt ;
    reg_p0_data_nxt                     = p0_byp_write_data_nxt ;
  end

  //..............................................................................................................................................
  // P0 Function : RAM operation -- READ
  //   With operation flopped into p0, perform RAM READ operation 
  //   DO NOT perform RAM read until p2 is not holding so that the RAM output can be captured
  //   If a memory write to same address is issued then abort the read and load the new write data into the 
  //   mem_read_ignoredata needed for static timing. Need to break all input ports (bypass) to RAM arcs. Instead do the read unconditionally then
  //   ignore read data if read should not have been performed.  In both cases when the bogus read is being performed at P1, the P1 register
  //   has the correct data to be used instead.
  //   mem_read and mem_read_addr also pulled out because of static timing

  if (reg_p0_v_f ) begin
    if ( ( reg_p0_rw_f == HQM_AW_RMWPIPE_READ ) | ( reg_p0_rw_f == HQM_AW_RMWPIPE_RMW ) ) begin
      mem_read_addr                     = reg_p0_addr_f ;
      mem_read                          = 1'b1 ;
      mem_read_ignoredata_nxt           = reg_p1_ctrl.hold |
                                          (   p2_bypaddr_sel_nxt & p2_bypdata_sel_nxt & ( p2_bypaddr_nxt  == mem_read_addr ) ) |
                                          ( ! p2_bypaddr_sel_nxt & p2_bypdata_sel_nxt & ( reg_p2_addr_nxt == mem_read_addr ) ) ;

      //do not issue read when a write is issued to same address.
      if ( ( mem_write == 1'b1 ) & ( mem_read_addr == mem_write_addr ) ) begin
        mem_read                        = 1'b0 ;
      end 
    end
  end


  if (reg_p0_v_f & ~reg_p1_ctrl.hold ) begin
    if ( ( reg_p0_rw_f == HQM_AW_RMWPIPE_READ ) | ( reg_p0_rw_f == HQM_AW_RMWPIPE_RMW ) ) begin
      if ( (   p2_bypaddr_sel_nxt & p2_bypdata_sel_nxt & ( p2_bypaddr_nxt  == mem_read_addr ) ) |
           ( ! p2_bypaddr_sel_nxt & p2_bypdata_sel_nxt & ( reg_p2_addr_nxt == mem_read_addr ) ) ) begin
        reg_p1_byp_bypass               = 1'd1 ;
      end
      else begin
        if ( ( mem_write == 1'b1 ) & ( mem_read_addr == mem_write_addr ) ) begin
          reg_p1_data_bypass            = 1'd1 ;
          // mem_read turned off above to avoid path from reg_p2_addr_nxt input port to output port to memory
        end
      end
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
  // In addition to "normal" pipeline functionality, p1 is also used to store memory read data in the case where a memory read is being
  // performed in p1 but can not load into p2 because p2 is holding.
  reg_p1_ctrl.hold                      = reg_p1_v_f & ( p1_hold | reg_p2_ctrl.hold ) ;

  reg_p1_ctrl.bypsel[ BYPASS_HOLD ]     = ( ( p1_hold | reg_p2_ctrl.hold ) & (mem_read_f & ~mem_read_ignoredata_f) ) ; // BYPASS : when p2 is holding then load the mem read into p1
  reg_p1_ctrl.bypsel[ BYPASS_RWCOLIDE ] = reg_p1_data_bypass ; // BYPASS_FROM_P1F : avoid read/write to same address on same clock
  reg_p1_ctrl.bypsel[ BYPASS_FROM_PORTP1 ] = p2_bypdata_sel_nxt //load bypass data always even when holding
                                        & ( ( reg_p1_v_f  & ( ( reg_p2_rw_f == HQM_AW_RMWPIPE_WRITE ) | ( reg_p2_rw_f == HQM_AW_RMWPIPE_RMW ) ) & ( reg_p2_addr_nxt == reg_p1_addr_f ) & reg_p1_ctrl.hold ) // holding and bypass
                                          | ( reg_p1_byp_bypass ) //abort mem read when bypass, load into p1 and pass through pipe with mem_read_f = 0;
                                          ) ;

  // p2 has a writing command and write data, for the same address as what is being held in p1
  reg_p1_ctrl.bypsel[ BYPASS_FROM_P2P1 ]  = reg_p1_ctrl.hold &
                                            ( ( reg_p1_rw_f == HQM_AW_RMWPIPE_READ ) | ( reg_p1_rw_f == HQM_AW_RMWPIPE_RMW ) ) & ( reg_p2_addr_f == reg_p1_addr_f ) &
                                            reg_p2_v_f & ( ( reg_p2_rw_f == HQM_AW_RMWPIPE_WRITE ) | ( reg_p2_rw_f == HQM_AW_RMWPIPE_RMW ) ) ;

  reg_p1_ctrl.bypsel[ BYPASS_FROM_P3NP1]  = '0 ;
  reg_p1_ctrl.dataenable                = ( reg_p0_v_f & ~p0_hold & ~reg_p1_ctrl.hold ) |
                                          reg_p1_ctrl.bypsel[BYPASS_HOLD] | reg_p1_ctrl.bypsel[BYPASS_RWCOLIDE] |
                                          reg_p1_ctrl.bypsel[ BYPASS_FROM_P3NP1] | reg_p1_ctrl.bypsel[ BYPASS_FROM_P2P1] ;
  reg_p1_ctrl.ctrlenable                = ( reg_p0_v_f & ~p0_hold & ~reg_p1_ctrl.hold ) ;


  if ( reg_p2_ctrl.hold == 1'b0 ) begin
    mem_read_hold_nxt                   = 1'b0 ;
  end
  if ( reg_p1_ctrl.dataenable ) begin
    if ( reg_p1_ctrl.bypsel[ BYPASS_FROM_P3NP1 ] ) begin        // If P1 is holding previous mem read data from HOLD case, update w/ write data
      reg_p1_data_nxt                   = reg_p3_data_nxt ;
    end
    else if ( reg_p1_ctrl.bypsel[ BYPASS_FROM_P2P1 ] ) begin    // If P1 is holding previous mem read data from HOLD case, update w/ write data
      reg_p1_data_nxt                   = reg_p2_data_f ;
    end
    else if ( reg_p1_ctrl.bypsel[ BYPASS_RWCOLIDE ] ) begin
      reg_p1_data_nxt                   = mem_write_data ;
    end
    else if ( reg_p1_ctrl.bypsel[ BYPASS_HOLD ] ) begin
      reg_p1_data_nxt                   = mem_read_data ;
      mem_read_hold_nxt                 = 1'b1 ;
    end
    else begin
      reg_p1_data_nxt                   = reg_p0_data_f ;
    end
  end
  if ( reg_p1_ctrl.bypsel[ BYPASS_FROM_PORTP1 ] ) begin
    reg_p1_data_nxt                     = p2_bypdata_nxt ;
    mem_read_hold_nxt                   = 1'b0 ;
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
  p2_data_f                             = reg_p2_data_f ;

  //..............................................................................................................................................
  // INITIAL FLOP conditions
  reg_p2_v_nxt                          = 1'b0 ;
  reg_p2_v_first_nxt                    = 1'b0 ;
  reg_p2_rw_nxt                         = reg_p2_rw_f ;
  reg_p2_addr_nxt                       = reg_p2_addr_f ;
  reg_p2_data_nxt                       = reg_p2_data_f ;
  //..............................................................................................................................................
  // INITIAL LOGIC
  reg_p2_ctrl                           = '0 ;

  //..............................................................................................................................................
  // P2 control
  // P2 register is only used for RAM writes





  reg_p2_ctrl.hold                      = reg_p2_v_f & ( p2_hold | reg_p3_ctrl.hold ) ;

  reg_p2_ctrl.dataenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;
  reg_p2_ctrl.ctrlenable                = ( reg_p1_v_f & ~p1_hold & ~reg_p2_ctrl.hold ) ;

  reg_p2_ctrl.bypsel[BYPASS_FROM_PORTP2]  = reg_p2_ctrl.dataenable & p2_bypdata_sel_nxt ;

  if ( reg_p2_ctrl.dataenable ) begin
    if ( ( (reg_p1_rw_f == HQM_AW_RMWPIPE_READ) | (reg_p1_rw_f == HQM_AW_RMWPIPE_RMW) ) ) begin
      reg_p2_data_nxt                   = mem_read_data ;
    end
    else begin
      reg_p2_data_nxt                   = reg_p1_data_f ;
    end
  end
  if ( reg_p2_ctrl.bypsel[ BYPASS_FROM_PORTP2 ] ) begin
    reg_p2_data_nxt                     = p2_bypdata_nxt ;
  end

  if ( reg_p2_ctrl.ctrlenable ) begin
    reg_p2_rw_nxt                       = reg_p1_rw_f ;
    reg_p2_addr_nxt                     = reg_p1_addr_f ;
  end

  if ( ( reg_p2_ctrl.ctrlenable ) | ( reg_p2_ctrl.hold ) ) begin
    reg_p2_v_nxt                        = 1'b1 ;
  end

  if ( ( reg_p2_ctrl.ctrlenable )                        ) begin
    reg_p2_v_first_nxt                  = 1'b1 ;
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p2 pipeline
//   RAM write operation
//     allow output logic to bypass an updated value in for the Read Modify Write operation
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  mem_write                             = 1'b0 ;
  mem_write_addr                        = reg_p2_addr_f ;
  mem_write_data                        = reg_p2_data_f ;

  //..............................................................................................................................................
  // P2 Function : RAM operation --WRITE
  // In case where p2 is valid and holding for multiple clocks, only write on the first clock to save power.
  // If bypass comes in while p2 is valid and holding, desired behavior is that bypass wins.
  if ( reg_p2_v_first_f ) begin
    if ( (reg_p2_rw_f == HQM_AW_RMWPIPE_WRITE ) | (reg_p2_rw_f == HQM_AW_RMWPIPE_RMW ) ) begin
      mem_write                        = 1'b1 ;
    end
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// p2 pipeline
  // P2 next function : drive the correct bypassed value out for READ or RMW operation
  //drive correct value to output port for RMW operation (or RAM read)
always_comb begin
  //..............................................................................................................................................
  // INITIAL PORT conditions
  p2_data_nxt                           = mem_read_data ;

  //..............................................................................................................................................
  if ( reg_p2_ctrl.dataenable ) begin
     if ( ( mem_read_f & ! mem_read_ignoredata_f ) & ( ( reg_p2_rw_nxt == HQM_AW_RMWPIPE_READ ) | ( reg_p2_rw_nxt == HQM_AW_RMWPIPE_RMW ) ) )begin
      // for READ command then drive the RAM output 
      p2_data_nxt                       = mem_read_data ;
    end
    else if ( reg_p2_v_f
            & ( (reg_p2_rw_f == HQM_AW_RMWPIPE_WRITE) | (reg_p2_rw_f == HQM_AW_RMWPIPE_RMW) )
            & ( reg_p1_addr_f == reg_p2_addr_f )
            ) begin
      // if collision with current write value then drive the more recent write value
      p2_data_nxt                       = reg_p2_data_f ;
    end
    else if ( reg_p1_v_f
            & ( (reg_p1_rw_f == HQM_AW_RMWPIPE_READ) | (reg_p1_rw_f == HQM_AW_RMWPIPE_RMW) )
            & ( ! mem_read_f | mem_read_ignoredata_f )
            ) begin
      // if there was a collision in previous cycle between read & write then drive the more recent write from the collision
      p2_data_nxt                       = reg_p1_data_f ;
    end
    else if ( mem_read_hold_f  & ( reg_p1_v_f & reg_p2_v_nxt & ( reg_p1_addr_f == reg_p2_addr_nxt ) ) ) begin
      p2_data_nxt                       = reg_p1_data_f ; //if p2 was held and RAM output stored into P1 then need to drive the correct value when the p2_hold drops
    end
    else begin
      // if no collision then drive the RAM ouptut.
      p2_data_nxt                       = mem_read_data ;
    end
  end

end

//------------------------------------------------------------------------------------------------------------------------------------------------
// status & errors
assign  status = { ( p0_v_nxt & reg_p0_ctrl.hold ) } ;

//-----------------------------------------------------------------------------------------------------
// Assertions - may want to move to separate file eventually

`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RMW_MEM_3PIPE_MODEL_ON
  //---------------------------------------------------------------------------------------------------
  // Model the contents of FIFO memory, detect when this rmw module has not produced the correct read
  // data, and when it has not performed any expected writes.
  logic [WIDTH-1:0]                             dbg_mem_f [DEPTH-1:0] ;
  logic [DEPTH-1:0]                             dbg_mem_v_f  ;
  logic [DEPTH-1:0]                             dbg_mem_v_nxt  ;
  logic [WIDTH-1:0]                             dbg_mem2_f [DEPTH-1:0] ;        // Retained for xprop debug comparison
  logic [DEPTH-1:0]                             dbg_mem2_v_f  ;                 // Retained for xprop debug comparison
  logic                                         dbg_p0_v_f ;
  logic                                         dbg_p1_v_f ;
  logic                                         dbg_p2_v_f ;
  logic                                         dbg_p3_v_f ;
  logic                                         dbg_p2_v_first_f ;
  logic                                         dbg_int_p0_hold ;
  logic                                         dbg_int_p1_hold ;
  logic                                         dbg_int_p2_hold ;
  logic                                         dbg_int_p3_hold ;
  logic                                         dbg_err_input_v_f ;
  logic                                         dbg_err_p2_bypsel_f ;
  logic                                         dbg_err_bypdata_noread_f ;
  logic                                         dbg_err_susp_p0_hold_f ;
  logic                                         dbg_err_susp_p1_hold_f ;
  logic                                         dbg_err_susp_p2_hold_f ;
  logic                                         dbg_err_susp_p3_hold_f ;
  logic                                         dbg_err_rdata_neq_f ;
  logic                                         dbg_err_mem_write_f ;
  logic                                         dbg_err_rdata_neq_OK_f ;
  logic                                         dbg_err_mem_write_OK_f ;
  aw_rmwpipe_cmd_t                              dbg_p0_cmd_f ;
  aw_rmwpipe_cmd_t                              dbg_p1_cmd_f ;
  aw_rmwpipe_cmd_t                              dbg_p2_cmd_f ;
  aw_rmwpipe_cmd_t                              dbg_p3_cmd_f ;
  logic                                         dbg_p0_en ;
  logic                                         dbg_p1_en ;
  logic                                         dbg_p2_en ;
  logic                                         dbg_p3_en ;
  logic                                         dbg_p3_en_byp ;
  logic [ DEPTHB2-1:0 ]                         dbg_p0_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p1_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p2_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_p2_waddr_func ;
  logic [ DEPTHB2-1:0 ]                         dbg_p3_waddr_f ;
  logic [ WIDTH-1:0 ]                           dbg_p0_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p1_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p2_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_p3_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_rdata_err_syn_exp_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_rdata_err_syn_act_data_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_rdata_err_syn_addr_f ;
  logic                                         dbg_memw_err_syn_write_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_memw_err_syn_exp_addr_f ;
  logic [ DEPTHB2-1:0 ]                         dbg_memw_err_syn_act_addr_f ;
  logic [ WIDTH-1:0 ]                           dbg_memw_err_syn_exp_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_memw_err_syn_act_data_f ;
  logic [ WIDTH-1:0 ]                           dbg_exp_rdata ;
  logic                                         dbg_exp_rdata_v ;

  logic                                         dbg_mem_upd_v ;
  logic [ DEPTHB2-1:0 ]                         dbg_mem_upd_addr ;
  logic [ WIDTH-1:0 ]                           dbg_mem_upd_data ;

  logic                                         dbg_err_bypsel_required_with_p1_valid_f;
  logic                                         dbg_err_bypsel_not_set_on_read_f;

  logic                                         dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f;
  logic                                         dbg_err_dont_issue_bypsel_when_p1_hold_f;
  logic                                         dbg_err_p1_set_withoug_p2_hold_f;
  logic                                         dbg_err_writes_not_allowed_f;



  assign dbg_int_p3_hold                = p3_hold ;
  assign dbg_int_p2_hold                = ( dbg_p2_v_f & dbg_int_p3_hold ) | p2_hold ;
  assign dbg_int_p1_hold                = ( dbg_p1_v_f & dbg_int_p2_hold ) | p1_hold ;
  assign dbg_int_p0_hold                = ( dbg_p0_v_f & dbg_int_p1_hold ) | p0_hold ;
  assign dbg_p0_en                      = p0_v_nxt   & ! dbg_int_p0_hold ;
  assign dbg_p1_en                      = dbg_p0_v_f & ! dbg_int_p1_hold ;
  assign dbg_p2_en                      = dbg_p1_v_f & ! dbg_int_p2_hold ;
  assign dbg_p3_en                      = dbg_p2_v_f & ! dbg_int_p3_hold ;
  assign dbg_p3_en_byp                  = p2_bypaddr_sel_nxt | p2_bypdata_sel_nxt ;

  assign dbg_p2_waddr_func              = ( p2_bypaddr_sel_nxt ) ? p2_bypaddr_nxt : reg_p2_addr_nxt ;

  always_comb begin
    // If being written this clock need to pick up on the fly
    if ( dbg_p2_v_first_f & ( ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_WRITE ) | ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_RMW ) ) & ( dbg_p2_addr_f == dbg_p1_addr_f ) ) begin
      dbg_exp_rdata                     = dbg_p2_data_f ;
      dbg_exp_rdata_v                   = 1'b1 ;
    end
    else begin
      dbg_exp_rdata                     = dbg_mem_f [ dbg_p1_addr_f ] ;
      dbg_exp_rdata_v                   = dbg_mem_v_f [ dbg_p1_addr_f ] ;
    end
  end // always

  always_comb begin
       dbg_mem_upd_v           = 1'b0 ;
       dbg_mem_v_nxt           = dbg_mem_v_f ;

       if ( dbg_p2_v_f & ( ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_WRITE ) | ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
            ( ~ $test$plusargs("HQM_DYNAMIC_CONFIG") ) & ( NO_RDATA_ASSERT == 0 ) ) begin 
         dbg_mem_upd_v          = 1'b1 ;
         dbg_mem_upd_addr       = dbg_p2_addr_f ;
         dbg_mem_upd_data       = dbg_p2_data_f ;
         dbg_mem_v_nxt [ dbg_p2_addr_f ]  <= 1'b1 ;
       end
  end // always

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) begin
       dbg_p0_v_f                       <= 1'b0 ;
       dbg_p1_v_f                       <= 1'b0 ;
       dbg_p2_v_f                       <= 1'b0 ;
       dbg_p3_v_f                       <= 1'b0 ;
       dbg_p2_v_first_f                 <= 1'b0 ;
       dbg_err_input_v_f                <= 1'b0 ;
       dbg_err_p2_bypsel_f              <= 1'b0 ;
       dbg_err_bypdata_noread_f         <= 1'b0 ;
       dbg_err_susp_p0_hold_f           <= 1'b0 ;
       dbg_err_susp_p1_hold_f           <= 1'b0 ;
       dbg_err_susp_p2_hold_f           <= 1'b0 ;
       dbg_err_susp_p3_hold_f           <= 1'b0 ;
       dbg_err_rdata_neq_f              <= 1'b0 ;
       dbg_err_mem_write_f              <= 1'b0 ;
       dbg_err_bypsel_required_with_p1_valid_f <= 1'b0;
       dbg_err_bypsel_not_set_on_read_f <= 1'b0;
       dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f <= 1'b0;
       dbg_err_dont_issue_bypsel_when_p1_hold_f <= 1'b0;
       dbg_err_p1_set_withoug_p2_hold_f <= 1'b0;
       dbg_err_writes_not_allowed_f <= 1'b0;
       dbg_mem_v_f                      <= { DEPTH { 1'b0 } } ;
       dbg_mem2_v_f                      <= { DEPTH { 1'b0 } } ;
       for ( int i = 0 ; i < DEPTH ; i = i + 1 ) begin
         dbg_mem_f [i]                  <= { WIDTH { 1'b0 } } ;         // Needed to make JG work
         dbg_mem2_f [i]                  <= { WIDTH { 1'b0 } } ;         // Needed to make JG work
       end
    end // if ~rst_n
    else begin
       if ( p0_byp_v_nxt ) begin
         dbg_p0_addr_f                  <= p0_byp_addr_nxt ;
         dbg_p0_data_f                  <= p0_byp_write_data_nxt ;
         dbg_p0_cmd_f                   <= p0_byp_rw_nxt ;
       end
       else if ( dbg_p0_en ) begin
         dbg_p0_addr_f                  <= p0_addr_nxt ;
         dbg_p0_data_f                  <= p0_write_data_nxt ;
         dbg_p0_cmd_f                   <= p0_rw_nxt ;
       end
       if ( dbg_p1_en ) begin 
         dbg_p1_addr_f                  <= dbg_p0_addr_f ;
         dbg_p1_data_f                  <= dbg_p0_data_f ;
         dbg_p1_cmd_f                   <= dbg_p0_cmd_f ;
       end
       if ( p2_bypsel_nxt ) begin
         dbg_p2_addr_f                  <= dbg_p1_addr_f ;
         dbg_p2_data_f                  <= p2_bypdata_nxt ;
         dbg_p2_cmd_f                   <= HQM_AW_RMWPIPE_WRITE ;
       end
       else if ( dbg_p2_en ) begin
         dbg_p2_addr_f                  <= dbg_p1_addr_f ;
         dbg_p2_data_f                  <= dbg_p1_data_f ;
         dbg_p2_cmd_f                   <= dbg_p1_cmd_f ;
       end
       if ( dbg_p3_en | dbg_p3_en_byp ) begin
         dbg_p3_waddr_f                 <= dbg_p2_waddr_func ;
         dbg_p3_data_f                  <= dbg_p2_data_f ;
         if ( p2_bypaddr_sel_nxt )
           dbg_p3_cmd_f                 <= HQM_AW_RMWPIPE_WRITE ;
         else
           dbg_p3_cmd_f                 <= dbg_p2_cmd_f ;
       end

       if ( dbg_p2_v_f & ( ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_WRITE ) | ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
            ( ~ $test$plusargs("HQM_DYNAMIC_CONFIG") ) & ( NO_RDATA_ASSERT == 0 ) ) begin 
         dbg_mem2_f [ dbg_p2_addr_f ]    <= dbg_p2_data_f ;
         dbg_mem2_v_f [ dbg_p2_addr_f ]  <= 1'b1 ;
       end

       dbg_mem_v_f                      <= dbg_mem_v_nxt ;
       if ( dbg_mem_upd_v ) begin
         dbg_mem_f [ dbg_mem_upd_addr ] <= dbg_mem_upd_data ;
       end

       // Shouldn't need to AND v with hold, because convention is to not assert hold if v=0, but since rmw
       // code does AND, do this to keep it consistent, in case parent module is not following the rules;
       // don't double-report errors/warnings.
       dbg_p0_v_f                       <= ( dbg_p0_v_f & dbg_int_p0_hold ) | p0_v_nxt ;
       dbg_p1_v_f                       <= ( dbg_p1_v_f & dbg_int_p1_hold ) | ( dbg_p0_v_f & ! p0_hold ) ; // External p0 could be holding for a reason other than p1
       dbg_p2_v_f                       <= ( dbg_p2_v_f & dbg_int_p2_hold ) | ( dbg_p1_v_f & ! p1_hold ) ; // External p1 could be holding for a reason other than p2
       dbg_p3_v_f                       <= ( dbg_p3_v_f & dbg_int_p3_hold ) | ( dbg_p2_v_f & ! p2_hold ) ; // External p2 could be holding for a reason other than p3
       dbg_p2_v_first_f                 <= ( dbg_p1_v_f & ! p1_hold & ! ( dbg_p2_v_f & p2_hold ) ) | p2_bypaddr_sel_nxt ;
       dbg_err_input_v_f                <= p0_v_nxt & dbg_int_p0_hold ;
       dbg_err_p2_bypsel_f              <= dbg_int_p2_hold & ( p2_bypdata_sel_nxt | p2_bypaddr_sel_nxt ) ;
       dbg_err_bypdata_noread_f         <= p2_bypdata_sel_nxt & ! p2_bypaddr_sel_nxt & ! ( dbg_p1_v_f & ( ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_READ ) | ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_RMW ) ) ) ;
       dbg_err_susp_p0_hold_f           <= p0_hold & ! dbg_p0_v_f ;
       dbg_err_susp_p1_hold_f           <= p1_hold & ! dbg_p1_v_f ;
       dbg_err_susp_p2_hold_f           <= p2_hold & ! dbg_p2_v_f ;
       dbg_err_susp_p3_hold_f           <= p3_hold & ! dbg_p3_v_f ;
       dbg_err_rdata_neq_f              <= dbg_p2_en & ( ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_READ ) | ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
                                           dbg_exp_rdata_v & ( p2_data_nxt != dbg_exp_rdata ) ;
       dbg_err_rdata_neq_OK_f           <= dbg_p2_en & ( ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_READ ) | ( dbg_p1_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
                                           dbg_exp_rdata_v & ( p2_data_nxt == dbg_exp_rdata ) ;
       dbg_err_mem_write_f              <= dbg_p2_v_first_f &
                                           ( ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_WRITE ) | ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
                                           ( ! mem_write |
                                             ( mem_write_addr != dbg_p2_addr_f ) |
                                             ( mem_write_data != dbg_p2_data_f ) ) ;
       dbg_err_mem_write_OK_f           <= dbg_p2_v_first_f &
                                           ( ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_WRITE ) | ( dbg_p2_cmd_f == HQM_AW_RMWPIPE_RMW ) ) &
                                           ( mem_write &
                                             ( mem_write_addr == dbg_p2_addr_f ) &
                                             ( mem_write_data == dbg_p2_data_f ) ) ;
       dbg_rdata_err_syn_exp_data_f     <= dbg_exp_rdata ;
       dbg_rdata_err_syn_act_data_f     <= p2_data_nxt ;
       dbg_rdata_err_syn_addr_f         <= dbg_p1_addr_f ;
       dbg_memw_err_syn_write_f         <= mem_write ;
       dbg_memw_err_syn_exp_addr_f      <= dbg_p2_addr_f ;
       dbg_memw_err_syn_act_addr_f      <= mem_write_addr ;
       dbg_memw_err_syn_exp_data_f      <= dbg_p2_data_f ;
       dbg_memw_err_syn_act_data_f      <= mem_write_data ;

       //need to byp if command is RMW - fixed with     reg_p2_data_nxt = p2_data_nxt ;
       dbg_err_bypsel_required_with_p1_valid_f <= p1_v_f & (p1_rw_f== HQM_AW_RMWPIPE_RMW) & (p2_bypsel_nxt==1'b0);
       //cannot bypass on READ - fixed with     reg_p2_data_nxt = p2_data_nxt ;
       dbg_err_bypsel_not_set_on_read_f        <= p1_v_f & (p1_rw_f==HQM_AW_RMWPIPE_READ) & (p2_bypsel_nxt==1'b1);
       // ASSUME : do not issue bypaddr or bypdata when p2_hold is asserted
       dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f <= (p2_hold & (p2_bypsel_nxt==1'b1));
       // ASSUME : do not issue bypaddr or bypdata when p1_holf is asserted ( RTL will trigger p2 valid and cause error : dbg_err_susp_p2_hold )
       dbg_err_dont_issue_bypsel_when_p1_hold_f <= p1_hold & (p2_bypsel_nxt==1'b1);
       // thermometer hold
       dbg_err_p1_set_withoug_p2_hold_f <= p1_hold & (p2_hold==1'b0);
       // writes not allowed
       dbg_err_writes_not_allowed_f <= (p0_v_nxt & (p0_rw_nxt==HQM_AW_RMWPIPE_WRITE));

    end // else ~rst_n
  end // always

    hqm_AW_rmw_mem_3pipe_core_assert # ( .DEPTHB2 ( DEPTHB2 ) , .WIDTH ( WIDTH ) ) i_hqm_AW_rmw_mem_3pipe_core_assert (.*) ;
`endif
`endif

`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge clk);
  WCP_P0N_LL: coverpoint { p0_v_nxt } iff (rst_n) ;
  WCP_P0V_LL: coverpoint { reg_p0_v_f } iff (rst_n) ;
  WCP_P1V_LL: coverpoint { reg_p1_v_f } iff (rst_n) ;
  WCP_P2N_LL: coverpoint { p2_bypdata_sel_nxt } iff (rst_n) ;
  WCP_P2V_LL: coverpoint { reg_p2_v_f } iff (rst_n) ;
  WCX_P: cross WCP_P0N_LL,WCP_P0V_LL,WCP_P1V_LL,WCP_P2V_LL,WCP_P2N_LL ;
  
  WCP_H0V_LL: coverpoint { reg_p0_ctrl.hold } iff (rst_n) ;
  WCP_H1V_LL: coverpoint { reg_p1_ctrl.hold } iff (rst_n) ;
  WCP_H2V_LL: coverpoint { reg_p2_ctrl.hold } iff (rst_n) ;
  WCX_H: cross WCP_H0V_LL,WCP_H1V_LL,WCP_H2V_LL ;

  WCP_B0V_LL: coverpoint { reg_p0_ctrl.bypsel } iff (rst_n) ;
  WCP_B1V_LL: coverpoint { reg_p1_ctrl.bypsel } iff (rst_n) ;
  WCP_B2V_LL: coverpoint { reg_p2_ctrl.bypsel } iff (rst_n) ;


endgroup
COVERGROUP u_COVERGROUP = new();
`endif

endmodule // hqm_AW_rmw_mem_3pipe


`ifndef INTEL_SVA_OFF
`ifdef INTEL_HQM_AW_RMW_MEM_3PIPE_MODEL_ON

module hqm_AW_rmw_mem_3pipe_core_assert import hqm_AW_pkg::*; # (
          parameter DEPTHB2 = 4
        , parameter WIDTH = 32
) (
          input logic clk
        , input logic rst_n
        , input logic dbg_err_input_v_f
        , input logic dbg_err_p2_bypsel_f
        , input logic dbg_err_bypdata_noread_f
        , input logic dbg_err_susp_p0_hold_f
        , input logic dbg_err_susp_p1_hold_f
        , input logic dbg_err_susp_p2_hold_f
        , input logic dbg_err_susp_p3_hold_f
        , input logic dbg_err_rdata_neq_f
        , input logic dbg_err_mem_write_f
        , input logic dbg_err_bypsel_required_with_p1_valid_f
        , input logic dbg_err_bypsel_not_set_on_read_f
        , input logic dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f
        , input logic dbg_err_dont_issue_bypsel_when_p1_hold_f
        , input logic dbg_err_p1_set_withoug_p2_hold_f
        , input logic dbg_err_writes_not_allowed_f
        , input logic [ WIDTH-1:0 ] dbg_rdata_err_syn_exp_data_f
        , input logic [ WIDTH-1:0 ] dbg_rdata_err_syn_act_data_f
        , input logic [ DEPTHB2-1:0 ] dbg_rdata_err_syn_addr_f
);

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_input_v
                      , dbg_err_input_v_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_err_input_v: On previous clock AW_rmw_mem parent module attempted new p0 command while 'p0' should have been holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_p2_bypsel
                      , dbg_err_p2_bypsel_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_err_p2_bypsel: On previous clock AW_rmw_mem parent module p2 bypass nxt while 'p2' should have been holding !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_bypdata_noread
                      , dbg_err_bypdata_noread_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_err_bypdata_noread : On previous clock AW_rmw_mem parent module p3 bypassed data and not address, and p2 does not have valid reading command !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p0_hold
                      , dbg_err_susp_p0_hold_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_susp_p0_hold : On previous clock AW_rmw_mem parent module asserted p0_hold=1 but p0 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p1_hold
                      , dbg_err_susp_p1_hold_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_susp_p1_hold : On previous clock AW_rmw_mem parent module asserted p1_hold=1 but p1 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p2_hold
                      , dbg_err_susp_p2_hold_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_susp_p2_hold : On previous clock AW_rmw_mem parent module asserted p2_hold=1 but p2 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_susp_p3_hold
                      , dbg_err_susp_p3_hold_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_susp_p3_hold : On previous clock AW_rmw_mem parent module asserted p3_hold=1 but p3 pipe level was not valid !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_rdata_neq
                      , dbg_err_rdata_neq_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_err_rdata_neq : On previous clock AW_rmw_mem did not provide correct read data for address %x, act=%x, exp=%x!!! : ",
                        dbg_rdata_err_syn_addr_f , dbg_rdata_err_syn_act_data_f , dbg_rdata_err_syn_exp_data_f )
                        , SDG_SVA_SOC_SIM
                      ) 
`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_err_mem_write
                      , dbg_err_mem_write_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_err_mem_write : On previous clock AW_rmw_mem did not perform correct memory write !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_bypsel_required_with_p1_valid_f 
                      , dbg_err_bypsel_required_with_p1_valid_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_bypsel_required_with_p1_valid_f: byp expected with p1_v_f set and p1_rw_f==RMW !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_bypsel_not_set_on_read_f
                      , dbg_err_bypsel_not_set_on_read_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_bypsel_not_set_on_read_f: no bypsel expected when RMW==READ !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f
                      , dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f 
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_dont_issue_bypsel_or_bypdata_when_p2_hold_set_f: no bypsel expected when p2_hold set !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_dont_issue_bypsel_when_p1_hold_f
                      , dbg_err_dont_issue_bypsel_when_p1_hold_f
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_dont_issue_bypsel_when_p1_hold_f: no bypsel expected when p1_hold set !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_p1_set_withoug_p2_hold_f
                      , dbg_err_p1_set_withoug_p2_hold_f 
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_p1_set_withoug_p2_hold_f: p1_hold set and p2_hold=0 !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

`SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_err_writes_not_allowed_f
                      , dbg_err_writes_not_allowed_f 
                      , clk
                      , ~rst_n
                      , `ERR_MSG("assert_forbidden_dbg_err_writes_not_allowed_f: writes no allowed !!! : ")
                        , SDG_SVA_SOC_SIM
                      ) 

endmodule // hqm_AW_rmw_mem_3pipe_core_assert
`endif
`endif

