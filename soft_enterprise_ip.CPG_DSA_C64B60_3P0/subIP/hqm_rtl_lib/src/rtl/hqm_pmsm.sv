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
// hqm_pm_unit
//
// This module implement the HQM PMSM logic 
//
//-----------------------------------------------------------------------------------------------------

module hqm_pmsm
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter HQM_PMSM_MAXCNT = 32
  ,parameter HQM_PMSM_MAXCNT_WIDTH = AW_logb2 ( HQM_PMSM_MAXCNT +1 ) + 1
) (
      input  logic                                     prim_freerun_clk

    , input  logic                                     prim_freerun_prim_gated_rst_b_sync

    // FUSE INTF
    , input  logic                                     fuse_force_on
    , input  logic                                     fuse_proc_disable

    , input  logic                                     cfg_pm_override
    , input  logic                                     cfg_pm_pmcsr_disable

    , input  logic                                     pgcb_hqm_pg_rdy_ack_b
    , input  logic                                     pgcb_hqm_idle
    , input  logic                                     hqm_in_d3
    , output logic                                     hqm_pm_unit_flr_req_edge
    , output logic                                     pm_fsm_d0tod3_ok
    , output logic                                     pm_fsm_d3tod0_ok
    , output logic                                     pmsm_pgcb_req_b
    , output logic                                     pmsm_shields_up 
    , output pmsm_t                                    pmsm_state_nxt // next pmsm state
    , output pmsm_t                                    pmsm_state_f // current pmsm state
    , output logic                                     pgcb_hqm_idle_sync_prim

    , output pmsm_visa_t                               pmsm_visa
    , output logic                                     cfg_d3tod0_event_cnt_inc 
    , output logic                                     pm_fsm_in_run
    , output logic                                     pm_fsm_active

    , input  logic                                     hw_reset_force_pwr_on_sync

);

logic [HQM_PMSM_MAXCNT_WIDTH-1:0]   hqm_prim_free_clk_cnt_nxt;
logic [HQM_PMSM_MAXCNT_WIDTH-1:0]   hqm_prim_free_clk_cnt_f;
logic                               go_off;
logic                               go_on;
logic                               cfg_pm_pmcsr_disable_f;
logic                               cfg_pm_override_f;
logic                               pm_fsm_d0tod3_ok_f;
logic                               pgcb_hqm_idle_sync;


assign pgcb_hqm_idle_sync_prim  = pgcb_hqm_idle_sync ;
assign hqm_pm_unit_flr_req_edge = ( pmsm_state_f == HQM_PMSM_PWR_ON ) & ( pmsm_state_nxt == HQM_PMSM_RUN );

// syn pgcb_hqm_idle to prim_freerun_clk                                                                                              
hqm_AW_sync_rst1 i_pgcb_hqm_idle_sync        (.clk (prim_freerun_clk) ,.rst_n(prim_freerun_prim_gated_rst_b_sync) ,.data (pgcb_hqm_idle)        ,.data_sync (pgcb_hqm_idle_sync));

always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin : pmsm_cfg_ctl_seq
  if(~prim_freerun_prim_gated_rst_b_sync) begin
    cfg_pm_pmcsr_disable_f <= 1'b1;
    cfg_pm_override_f      <= 1'b0;
  end else begin
    cfg_pm_pmcsr_disable_f <= cfg_pm_pmcsr_disable;
    cfg_pm_override_f      <= cfg_pm_override;
  end
end // always_ff  //pmsm_cfg_ctl_seq 

// generation of the go_off signal
// hw_reset_force_pwr_on_sync controls the go_off
assign go_off = ~hw_reset_force_pwr_on_sync & (fuse_proc_disable | (cfg_pm_pmcsr_disable_f & (~fuse_force_on | cfg_pm_override_f))) ;
// generation of the go_on signal
// hw_reset_force_pwr_on_sync controlls the go_on 
assign go_on  = hw_reset_force_pwr_on_sync | ((cfg_pm_override_f | fuse_force_on ) & ~go_off) ;

// generation of the go_on signal


always_comb
begin: pmsm_state_comb

        // Default State Assignments
        pmsm_pgcb_req_b = 1'b0;
        pm_fsm_d3tod0_ok = 1'b0; 
        pm_fsm_d0tod3_ok = 1'b0;
        pmsm_shields_up = 1'b0;

        hqm_prim_free_clk_cnt_nxt = hqm_prim_free_clk_cnt_f;

        pmsm_state_nxt = pmsm_state_f;

        case(pmsm_state_f) //: Case statement with an enum variable in a condition is not detected as full despite the fact that all enumerate values are checked, since the enum variable may have a value outside of the list of valid enumerate values
            HQM_PMSM_RUN:
            begin

              pmsm_pgcb_req_b = 1'b1;
              pm_fsm_d3tod0_ok = fuse_force_on | cfg_pm_override_f;
              pm_fsm_d0tod3_ok = 1'b1;
              pmsm_shields_up = 1'b0;

              if ( go_off | (hqm_in_d3 & ~go_on) ) begin
                   pmsm_state_nxt = HQM_PMSM_IF_OFF;
              end

            end // case HQM_PMSM_RUN

            HQM_PMSM_IF_OFF:
            begin

              hqm_prim_free_clk_cnt_nxt = hqm_prim_free_clk_cnt_f + {{(HQM_PMSM_MAXCNT_WIDTH-1){1'b0}},{1'b1}};
              pmsm_pgcb_req_b = 1'b1;
              pm_fsm_d3tod0_ok = 1'b0;
              pm_fsm_d0tod3_ok = 1'b0;
              pmsm_shields_up = 1'b1;
 
              if ( ( hqm_prim_free_clk_cnt_f==32 ) ) begin
                 pmsm_state_nxt = HQM_PMSM_WAIT_ACK;
                 hqm_prim_free_clk_cnt_nxt = '0; // clear the counter
              end

            end // HQM_PMSM_IF_OFF 

            HQM_PMSM_WAIT_ACK:
            begin

              pmsm_pgcb_req_b = 1'b0;
              pm_fsm_d3tod0_ok = 1'b0;
              pm_fsm_d0tod3_ok = 1'b0;
              pmsm_shields_up = 1'b1;

              if (~pgcb_hqm_pg_rdy_ack_b) begin
                pmsm_state_nxt = HQM_PMSM_PWR_OFF;
              end

            end // HQM_PMSM_WAIT_ACK

            HQM_PMSM_PWR_OFF:
            begin

              pmsm_pgcb_req_b = 1'b0;
              pm_fsm_d3tod0_ok = 1'b1;
              pm_fsm_d0tod3_ok = 1'b0;
              pmsm_shields_up = 1'b1;

              if ( ~go_off & ( ~hqm_in_d3 | go_on) ) begin
                pmsm_state_nxt = HQM_PMSM_PWR_ON;  
              end 

            end // HQM_PMSM_PWR_OFF 

            HQM_PMSM_PWR_ON:
            begin
 
              pmsm_pgcb_req_b = 1'b1;
              pm_fsm_d3tod0_ok = 1'b0;
              pm_fsm_d0tod3_ok = 1'b0;
              pmsm_shields_up = 1'b1;

              if ( (pgcb_hqm_idle_sync & pgcb_hqm_pg_rdy_ack_b ) |  cfg_pm_override_f | fuse_force_on | hw_reset_force_pwr_on_sync ) begin
                pmsm_state_nxt = HQM_PMSM_RUN;
              end

            end
            default: 
            begin
                pmsm_state_nxt = HQM_PMSM_PWR_OFF;
            end // default case

        endcase

    end // always_comb pmsm_state_comb

  // ------------------------------------------------------------------------
  // Power Management State Machine
  // The next power management state is assigned here.
  // ------------------------------------------------------------------------
  always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin : pmsm_state_seq
    if(~prim_freerun_prim_gated_rst_b_sync) begin
      pmsm_state_f <= HQM_PMSM_PWR_OFF;
      hqm_prim_free_clk_cnt_f <= '0; 
      pm_fsm_d0tod3_ok_f <= '0;
    end else begin 
      pmsm_state_f <= pmsm_state_nxt;
      hqm_prim_free_clk_cnt_f <= hqm_prim_free_clk_cnt_nxt; 
      pm_fsm_d0tod3_ok_f <= pm_fsm_d0tod3_ok;
    end
  end // always_ff  pmsm_state_seq

  always_comb begin
     pmsm_visa.spare                               = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_pgcb_fet_en_b         = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_pmc_pgcb_fet_en_b     = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_pmc_pgcb_pg_ack_b     = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_pgcb_pmc_pg_req_b     = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_PMSM_PGCB_REQ_B       = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_PGCB_HQM_PG_RDY_ACK_B = '0; //Assigned at pm_unit level
     pmsm_visa.cfg_pm_status_PGCB_HQM_IDLE         = '0; //Assigned at pm_unit level
     pmsm_visa.prdata_2_0                          = '0; //Assigned at pm_unit level
     pmsm_visa.pready                              = '0; //Assigned at pm_unit level
     pmsm_visa.paddr_31_28                         = '0; //Assigned at pm_unit level
     pmsm_visa.pwrite                              = '0; //Assigned at pm_unit level
     pmsm_visa.penable                             = '0; //Assigned at pm_unit level
     pmsm_visa.pgcb_hqm_idle                       = pgcb_hqm_idle_sync;
     pmsm_visa.not_hqm_in_d3                       = ~hqm_in_d3; 
     pmsm_visa.hqm_in_d3                           = hqm_in_d3;
     pmsm_visa.go_off                              = go_off;
     pmsm_visa.go_on                               = go_on;
     pmsm_visa.pmsm_shields_up                     = pmsm_shields_up;
     pmsm_visa.pm_fsm_d0tod3_ok                    = pm_fsm_d0tod3_ok;
     pmsm_visa.pm_fsm_d3tod0_ok                    = pm_fsm_d3tod0_ok;
     pmsm_visa.pmsm_pgcb_req_b                     = pmsm_pgcb_req_b;
     pmsm_visa.PMSM                                = pmsm_state_f;

  end

  // need to generate pulse for transitions from D0->D3 state
  //
  assign cfg_d3tod0_event_cnt_inc = ~pm_fsm_d0tod3_ok_f & pm_fsm_d0tod3_ok; // to cfg count logic
  assign pm_fsm_in_run = pmsm_state_f==HQM_PMSM_RUN; // to cfg count logic

  assign pm_fsm_active = ~((pmsm_state_f == HQM_PMSM_RUN) | (pmsm_state_f == HQM_PMSM_PWR_OFF));

endmodule // hqm_pmsm
