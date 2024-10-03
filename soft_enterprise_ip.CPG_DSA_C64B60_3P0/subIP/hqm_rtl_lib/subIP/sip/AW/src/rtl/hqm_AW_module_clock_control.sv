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
// inp_fifo_empty         : input bit from each input rx_sync buffer that indicates empty/not empty status
// inp_fifo_en            : output bit to each input rx_sync buffer to enable operation (gated clock is active)
//
// cfg_idle               : dedicated input port for hqm_AW_cfg_ring_top instance cfg_idle output port. THis does NOT tuirn on local clock. THis keeps unit_idle output deasserted
// int_idle               : dedicated input port for hqm_AW_int_serializer instance int_idle output port. THis does NOT tuirn on local clock. THis keeps unit_idle output deasserted
// rst_prep               : dedicated input port for hqm_AW_reset_core insatnce rst_prep output port.  used to drive output ports properly when preparing for reset
// reset_active           : dedicated input port for module pf reset logic to keep local clocks on and outpt unit_idle deasserted until reset completes.
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_module_clock_control
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


, input  logic [ REQS - 1 : 0 ]             inp_fifo_empty
, output logic [ REQS - 1 : 0 ]             inp_fifo_en

, input  logic                              cfg_idle
, input  logic                              int_idle

, input logic                              rst_prep
, input logic                              reset_active

) ;

hqm_AW_module_clock_control_core  # (
  .REQS ( REQS )
) i_hqm_AW_module_clock_control_core (
  .hqm_inp_gated_clk ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n ( hqm_inp_gated_rst_n )
, .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_n ( hqm_gated_rst_n )
, .cfg_co_dly ( cfg_co_dly )
, .cfg_co_disable ( cfg_co_disable )
, .hqm_proc_clk_en ( hqm_proc_clk_en )
, .unit_idle_local ( unit_idle_local )
, .unit_idle ( unit_idle )
, .inp_fifo_empty_pre ( 1'b1 )
, .inp_fifo_empty ( inp_fifo_empty )
, .inp_fifo_en ( inp_fifo_en )
, .cfg_idle ( cfg_idle )
, .int_idle ( int_idle )
, .rst_prep ( rst_prep )
, .reset_active ( reset_active )
) ;

endmodule
