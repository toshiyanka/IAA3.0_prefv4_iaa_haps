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
// clock controller wrapper needed when any rx_sync uses ENABLE_DROPREADY
//-----------------------------------------------------------------------------------------------------
module hqm_AW_module_clock_control_wpre
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

, input logic                               rst_prep
, input logic                               reset_active
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
, .inp_fifo_empty_pre ( inp_fifo_empty_pre )
, .inp_fifo_empty ( inp_fifo_empty )
, .inp_fifo_en ( inp_fifo_en )
, .cfg_idle ( cfg_idle )
, .int_idle ( int_idle )
, .rst_prep ( rst_prep )
, .reset_active ( reset_active )
) ;

endmodule
