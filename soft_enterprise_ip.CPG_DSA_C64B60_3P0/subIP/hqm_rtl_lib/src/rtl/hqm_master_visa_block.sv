
//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// hqm_master_visa_block
//
// This module is responsible for flopping (and synchronizing some) master signals to visa
// The flopped values are demuxed and output as 1 64-bit buses.
//
//-----------------------------------------------------------------------------------------------------

module hqm_master_visa_block

// collage-pragma translate_off

  import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;

// collage-pragma translate_on

(
      input  logic                                     side_clk

    // CLK
    , input  logic                                     wd_clkreq
    , input  logic                                     hqm_cfg_master_clkreq_b

    // RST
    , input  logic                                     side_rst_b
    , input  logic                                     prim_gated_rst_b
    , input  logic                                     hqm_gated_rst_b
    , input  logic                                     hqm_clk_rptr_rst_b
    , input  logic                                     hqm_pwrgood_rst_b

    // PM_UNIT INTF
    , input  logic                                     prochot
    , input  master_ctl_reg_t                          master_ctl
    , input  logic                                     pgcb_isol_en_b
    , input  logic                                     pgcb_isol_en

    // FET INTF
    , input  logic                                     pgcb_fet_en_b
    , input  logic                                     pgcb_fet_en_ack_b
    , input  logic                                     pgcb_fet_en_ack_b_sys  //VISA_ONLY
    , input  logic                                     pgcb_fet_en_ack_b_qed  //VISA_ONLY

    // DFX INTF
    , input  logic                                     cdc_hqm_jta_force_clkreq
    , input  logic                                     cdc_hqm_jta_clkgate_ovrd
    `include "hqm_master_visa_block.VISA_IT.hqm_master_visa_block.port_defs.sv" // Auto Included by VISA IT - *** Do not modify this line ***
    

);

// Structures

`include "hqm_master_visa_block.VISA_IT.hqm_master_visa_block.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
typedef struct packed {

logic                                     master_ctl_OVERRIDE_CLK_GATE ;  //NOSYNC
logic                                     master_ctl_PWRGATE_PMC_WAKE ;  //NOSYNC
logic [2:0]                               master_ctl_OVERRIDE_CLK_SWITCH_CONTROL ;  //NOSYNC
logic [1:0]                               master_ctl_OVERRIDE_PMSM_PGCB_REQ_B ;  //NOSYNC
logic [2:0]                               master_ctl_OVERRIDE_PM_CFG_CONTROL ;  //NOSYNC
logic [1:0]                               master_ctl_OVERRIDE_FET_EN_B ;  //NOSYNC
logic [1:0]                               master_ctl_OVERRIDE_PMC_PGCB_ACK_B ;  //NOSYNC
// CLK
logic                                     wd_clkreq ;
logic                                     hqm_cfg_master_clkreq_b ;

// RST
logic                                     side_rst_b ;
logic                                     prim_gated_rst_b ;
logic                                     hqm_gated_rst_b ;
logic                                     hqm_clk_rptr_rst_b ;
logic                                     hqm_pwrgood_rst_b ;

// PM_UNIT INTF
logic                                     prochot ;
logic                                     pgcb_isol_en_b ;
logic                                     pgcb_isol_en ;

// FET INTF
logic                                     pgcb_fet_en_b ;
logic                                     pgcb_fet_en_ack_b ;
logic                                     pgcb_fet_en_ack_b_sys ;
logic                                     pgcb_fet_en_ack_b_qed ;

// DFX INTF
logic                                     cdc_hqm_jta_force_clkreq ;
logic                                     cdc_hqm_jta_clkgate_ovrd ;

} hqm_master_visa_str_t ;

typedef struct packed {
logic                                     master_ctl_OVERRIDE_CLK_GATE ;
logic                                     master_ctl_PWRGATE_PMC_WAKE ;
logic [2:0]                               master_ctl_OVERRIDE_CLK_SWITCH_CONTROL ;
logic [1:0]                               master_ctl_OVERRIDE_PMSM_PGCB_REQ_B ;
logic [2:0]                               master_ctl_OVERRIDE_PM_CFG_CONTROL ;
logic [1:0]                               master_ctl_OVERRIDE_FET_EN_B ;
logic [1:0]                               master_ctl_OVERRIDE_PMC_PGCB_ACK_B ;
logic                                     wd_clkreq ;
logic                                     hqm_cfg_master_clkreq_b ;
logic                                     side_rst_b ;
logic                                     prim_gated_rst_b ;
logic                                     hqm_gated_rst_b ;
logic                                     hqm_clk_rptr_rst_b ;
logic                                     hqm_pwrgood_rst_b ;
logic                                     prochot ;
logic                                     pgcb_isol_en_b ;
logic                                     pgcb_isol_en ;
logic                                     pgcb_fet_en_b ;
logic                                     pgcb_fet_en_ack_b ;
logic                                     pgcb_fet_en_ack_b_sys ;
logic                                     pgcb_fet_en_ack_b_qed ;
logic                                     cdc_hqm_jta_force_clkreq ;
logic                                     cdc_hqm_jta_clkgate_ovrd ;
} hqm_master_visa_lane_0_t ;

logic [ ( 16 ) - 1 : 0]                   data , data_sync ;
hqm_master_visa_str_t                     visa_capture_reg_nxt , visa_capture_reg_f ;
hqm_master_visa_lane_0_t                  hqm_master_visa_lane_0 ;

`ifndef HQM_VISA_ELABORATE

//---------------------------------------------------------------------------------------
// Synchronizers

hqm_AW_sync #(
 .WIDTH                                   ( $bits ( data ) )
) i_hqm_AW_sync (
  .clk                                    ( side_clk )
, .data                                   ( data )
, .data_sync                              ( data_sync )
);

//---------------------------------------------------------------------------------------
// Flops

always_ff @ ( posedge side_clk ) begin
  visa_capture_reg_f <= visa_capture_reg_nxt ;
end

//---------------------------------------------------------------------------------------
// Always block for assignments to capture register

always_comb begin
  data                 = { wd_clkreq
                         , hqm_cfg_master_clkreq_b
                         , side_rst_b
                         , prim_gated_rst_b
                         , hqm_gated_rst_b
                         , hqm_clk_rptr_rst_b
                         , hqm_pwrgood_rst_b
                         , prochot
                         , pgcb_isol_en_b
                         , pgcb_isol_en
                         , pgcb_fet_en_b
                         , pgcb_fet_en_ack_b
                         , pgcb_fet_en_ack_b_sys
                         , pgcb_fet_en_ack_b_qed
                         , cdc_hqm_jta_force_clkreq
                         , cdc_hqm_jta_clkgate_ovrd
                         } ;
  visa_capture_reg_nxt = { master_ctl.OVERRIDE_CLK_GATE
                         , master_ctl.PWRGATE_PMC_WAKE
                         , master_ctl.OVERRIDE_CLK_SWITCH_CONTROL
                         , master_ctl.OVERRIDE_PMSM_PGCB_REQ_B
                         , master_ctl.OVERRIDE_PM_CFG_CONTROL
                         , master_ctl.OVERRIDE_FET_EN_B
                         , master_ctl.OVERRIDE_PMC_PGCB_ACK_B
                         , data_sync
                         } ;
end

//---------------------------------------------------------------------------------------
// Demux the flopped data into 64b lane bus outputs

always_comb begin

  // LANE 0
  hqm_master_visa_lane_0 = '0 ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_GATE = visa_capture_reg_f.master_ctl_OVERRIDE_CLK_GATE ;
  hqm_master_visa_lane_0.master_ctl_PWRGATE_PMC_WAKE = visa_capture_reg_f.master_ctl_PWRGATE_PMC_WAKE ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_SWITCH_CONTROL = visa_capture_reg_f.master_ctl_OVERRIDE_CLK_SWITCH_CONTROL ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMSM_PGCB_REQ_B = visa_capture_reg_f.master_ctl_OVERRIDE_PMSM_PGCB_REQ_B ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_PM_CFG_CONTROL = visa_capture_reg_f.master_ctl_OVERRIDE_PM_CFG_CONTROL ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_FET_EN_B = visa_capture_reg_f.master_ctl_OVERRIDE_FET_EN_B ;
  hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMC_PGCB_ACK_B = visa_capture_reg_f.master_ctl_OVERRIDE_PMC_PGCB_ACK_B ;
  hqm_master_visa_lane_0.wd_clkreq = visa_capture_reg_f.wd_clkreq ;
  hqm_master_visa_lane_0.hqm_cfg_master_clkreq_b = visa_capture_reg_f.hqm_cfg_master_clkreq_b ;
  hqm_master_visa_lane_0.side_rst_b = visa_capture_reg_f.side_rst_b ;
  hqm_master_visa_lane_0.prim_gated_rst_b = visa_capture_reg_f.prim_gated_rst_b ;
  hqm_master_visa_lane_0.hqm_gated_rst_b = visa_capture_reg_f.hqm_gated_rst_b ;
  hqm_master_visa_lane_0.hqm_clk_rptr_rst_b = visa_capture_reg_f.hqm_clk_rptr_rst_b ;
  hqm_master_visa_lane_0.hqm_pwrgood_rst_b = visa_capture_reg_f.hqm_pwrgood_rst_b ;
  hqm_master_visa_lane_0.prochot = visa_capture_reg_f.prochot ;
  hqm_master_visa_lane_0.pgcb_isol_en_b = visa_capture_reg_f.pgcb_isol_en_b ;
  hqm_master_visa_lane_0.pgcb_isol_en = visa_capture_reg_f.pgcb_isol_en ;
  hqm_master_visa_lane_0.pgcb_fet_en_b = visa_capture_reg_f.pgcb_fet_en_b ;
  hqm_master_visa_lane_0.pgcb_fet_en_ack_b = visa_capture_reg_f.pgcb_fet_en_ack_b ;
  hqm_master_visa_lane_0.pgcb_fet_en_ack_b_sys = visa_capture_reg_f.pgcb_fet_en_ack_b_sys ;
  hqm_master_visa_lane_0.pgcb_fet_en_ack_b_qed = visa_capture_reg_f.pgcb_fet_en_ack_b_qed ;
  hqm_master_visa_lane_0.cdc_hqm_jta_force_clkreq = visa_capture_reg_f.cdc_hqm_jta_force_clkreq ;
  hqm_master_visa_lane_0.cdc_hqm_jta_clkgate_ovrd = visa_capture_reg_f.cdc_hqm_jta_clkgate_ovrd ;

end

`endif

//---------------------------------------------------------------------------------------


`include "hqm_master_visa_block.VISA_IT.hqm_master_visa_block.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_master_visa_block

