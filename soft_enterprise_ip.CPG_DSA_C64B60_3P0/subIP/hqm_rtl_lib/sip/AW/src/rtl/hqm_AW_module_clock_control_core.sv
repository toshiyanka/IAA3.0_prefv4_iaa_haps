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
//
// hqm_inp_gated_clk      : input gated clk. This clock remains active until HQM clk is gated
// hqm_inp_gated_rst_n    : reset synchronized to hqm_inp_gated_clk
// hqm_gated_clk          : module local gated clock.
//
// cfg_co_dly             : input configuration strap to specify the number of idle clocks before initiate process to gate local clock 'turn off hqm_gated_clk'
//
// hqm_proc_clk_en        : output signal sent to PAR clock control to control gating local clock (0: gate, 1:active)
//
// unit_idle_local        : input from local module indication that all pipeline stages & activity (cfg, int, timers...) are idle
// unit_idle              : output signal sent to PAR to indicate module is idle
//
// inp_fifo_empty_pre     : input bit indicate that any input RX FIFO is being loaded,  needed when RX FIFO needs to use ENABLE_DROPREADY and must block holding anything when clocks are off
// inp_fifo_empty         : input bit from each input rx_sync buffer that indicates empty/not empty status
// inp_fifo_en            : output bit to each input rx_sync buffer to enable operation (gated clock is active)
//-----------------------------------------------------------------------------------------------------
module hqm_AW_module_clock_control_core
import hqm_AW_pkg::*; #(
  parameter REQS = 32

) (
  input  logic                              hqm_inp_gated_clk
, input  logic                              hqm_inp_gated_rst_n

, input  logic                              hqm_gated_clk
, input  logic                              hqm_gated_rst_n

, input  logic [ 16 - 1 : 0 ]               cfg_co_dly
, input  logic                              cfg_co_disable

, output logic                              hqm_proc_clk_en

, input  logic                              unit_idle_local
, output logic                              unit_idle

, input  logic                              inp_fifo_empty_pre
, input  logic [ REQS - 1 : 0 ]             inp_fifo_empty
, output logic [ REQS - 1 : 0 ]             inp_fifo_en

, input  logic                              cfg_idle
, input  logic                              int_idle

, input logic                              rst_prep
, input logic                              reset_active

) ;

localparam STATE_CLK_OFF = 5'h1 ;
localparam STATE_CLK_ON = 5'h2 ;
localparam STATE_TURN_ON_REQ = 5'h4 ;
localparam STATE_TURN_OFF_REQ = 5'h8 ;
localparam STATE_TURN_OFF_BYPASS = 5'h16 ;

logic idle ;
logic go_off ;
logic go_on ;
logic unit_idle_local_f ;
logic hqm_clk_req_f , hqm_clk_req_next ;
logic [ 5 - 1 : 0 ] state_f , state_next ;
logic [ 8 - 1 : 0 ] co_dly_f , co_dly_next ;
logic [ 6 - 1 : 0 ] byp_dly_f , byp_dly_next ;
logic [ 2 - 1 : 0 ] sample_graycnt_hqm_gated_clk_f , sample_graycnt_hqm_gated_clk_next ;
always_ff @ ( posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n ) begin
  if ( ~ hqm_inp_gated_rst_n ) begin
    state_f <= STATE_CLK_OFF ;
    co_dly_f <= '0 ;
    byp_dly_f <= '0 ;
    hqm_clk_req_f <= '0 ;
    unit_idle_local_f <= '1 ;
  end else begin
    state_f <= state_next ;
    co_dly_f <= co_dly_next ;
    byp_dly_f <= byp_dly_next ;
    hqm_clk_req_f <= hqm_clk_req_next ;
    unit_idle_local_f <= unit_idle_local ;
  end
end
always_ff @ ( posedge hqm_inp_gated_clk ) begin
    sample_graycnt_hqm_gated_clk_f <= sample_graycnt_hqm_gated_clk_next ;
end

logic [ 2 - 1 : 0 ] graycnt_hqm_gated_clk_f , graycnt_hqm_gated_clk_next ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ~ hqm_gated_rst_n ) begin
    graycnt_hqm_gated_clk_f <= '0 ;
  end else begin
    graycnt_hqm_gated_clk_f <= graycnt_hqm_gated_clk_next ;
  end
end
always_comb begin
  graycnt_hqm_gated_clk_next [ 1 ] = graycnt_hqm_gated_clk_f [ 0 ] ;
  graycnt_hqm_gated_clk_next [ 0 ] = ~ graycnt_hqm_gated_clk_f [ 1 ] ;
end

//output to clock control that is flopped in par wrapper
assign hqm_proc_clk_en = ( rst_prep ) ? 1'b0 : hqm_clk_req_next ;

always_comb begin

  // registers
  state_next = state_f ;
  co_dly_next = co_dly_f ;
  sample_graycnt_hqm_gated_clk_next = graycnt_hqm_gated_clk_next ;
  hqm_clk_req_next = hqm_clk_req_f ;

  idle = ( unit_idle_local_f  // local unit_idle
         & ( & inp_fifo_empty )  // input FIFO empty
         & ( inp_fifo_empty_pre )
         ) ;

  // decrement clock off delay when idle, saturate at zero
  if ( ~ idle ) begin
    co_dly_next = { cfg_co_dly [ 7 : 1 ] , 1'b1 } ; //value of zero is illegal since unit_idle uses co_dly_next==0, so it must be non zero when not idle
  end else begin
     if ( | co_dly_f ) begin
      co_dly_next = co_dly_f - 8'd1 ;
    end
  end

  go_on = ( ~ idle ) | ( cfg_co_disable ) | ( ( | co_dly_next ) ) ; // assert when local unit_idle or ANY input FIFO are not idle or co_dly timer has not expired
  go_off = ( idle ) & ( ~ cfg_co_disable ) & ( ~ ( | co_dly_next ) ) ; // assert when local unit_idle & ALL input FIFO are idle AND co_dly timer expires

  // drive output signals
  unit_idle = ( ( ~ ( | co_dly_next ) ) //idle hystersis timer expired
              & cfg_idle                //config ring is idle
              & int_idle                //interrupt rin is idle
              & ( ~ rst_prep )          //when rst_prep is asserted then force to look NOT idle
              & ( ~ reset_active )      //when reset_active is asserted then force to look NOT idle ( to turn on regional clock )  : make part of logic driving input port 'local_unit_idle' to keep clocks on until reset completes
              ) ;

  inp_fifo_en = { REQS { 1'b0 } } ; //only assert in states where hqm_clk_req_next is known to be asserted

  // bypass delay count.  This is reset when in STATE_TURN_OFF_REQ & waiting to turn off clocks and idle is deasserted.  used to exit STATE_TURN_OFF_BYPASS state
  byp_dly_next = byp_dly_f + 6'd1 ;

  //STATE MACHINE
  case ( state_f )
    STATE_CLK_OFF : begin
    // when gated clock is currently off
    // detect when _ANY_ input REQS goes non idle and set hqm_clk_req to begin process to turn on clock
      if ( go_on ) begin
        state_next = STATE_TURN_ON_REQ ;
        hqm_clk_req_next = 1'b1 ;
      end
    end

    STATE_TURN_ON_REQ : begin
    // wait until detect gated clock is active
    // when gated clock is detected active then move to CLK_ON state
      if ( sample_graycnt_hqm_gated_clk_next != sample_graycnt_hqm_gated_clk_f ) begin
        state_next = STATE_CLK_ON ;
      end
    end

    STATE_CLK_ON : begin
    // when gated clock is currently on
    // when idle activity count meets threshold then begin process to turn off clock
      inp_fifo_en = { REQS { 1'b1 } } ;
      if ( go_off ) begin
        state_next = STATE_TURN_OFF_REQ ;
      end
    end

    STATE_TURN_OFF_REQ : begin
    // wait until detect gated clock is inactive
    // when gated clock is detected inactive then move to CLK_OFF state
      hqm_clk_req_next = 1'b0 ;
      if ( sample_graycnt_hqm_gated_clk_next == sample_graycnt_hqm_gated_clk_f ) begin
        state_next = STATE_CLK_OFF ;
      end
      if ( go_on ) begin
        state_next = STATE_TURN_OFF_BYPASS ;
        byp_dly_next = 6'd0 ;
        hqm_clk_req_next = 1'b1 ;
      end
    end

    STATE_TURN_OFF_BYPASS : begin
    // when in STATE_TURN_OFF_REQ and waiting for clock to turn off and idle is deasserted (go_on=1) then goto this turn off Bypass state.
    //  NOTE:  this is expected behavior when master/pmu ctrl clk_ungate is set and clock do NOT turn off.
    //  unconditionly wait in this clock avoid SM collision that could have been caused by STATE_TURN_OFF_REQ turing off clock request ( prevent case where inp_fifo_en is asserted & there is no clock active )
    //  after waiting fixed time then move to STATE_TURN_ON_REQ to make sure clocks are ON,
      if ( byp_dly_f > cfg_co_dly [ 13 : 8 ] ) begin 
        state_next = STATE_TURN_ON_REQ ;
      end
    end

    default : begin
        state_next = STATE_CLK_OFF ;
    end

  endcase

end

endmodule
