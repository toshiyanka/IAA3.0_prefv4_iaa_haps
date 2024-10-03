`ifdef INTEL_INST_ON

 `ifndef INTEL_SVA_OFF

module hqm_pm_unit_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

  logic pgcb_clk;
  logic pmc_pgcb_pg_ack_b;
  logic pgcb_fet_en_b;
  logic side_rst_b_sync;
  logic pgcb_isol_en_b;
  logic prim_freerun_prim_gated_rst_b_sync;
  logic prim_freerun_clk;
  logic hqm_clk_enable_int;

  assign pgcb_clk = hqm_pm_unit.pgcb_clk;
  assign pmc_pgcb_pg_ack_b = hqm_pm_unit.pmc_pgcb_pg_ack_b;
  assign pgcb_fet_en_b = hqm_pm_unit.pgcb_fet_en_b;
  assign side_rst_b_sync = hqm_pm_unit.side_rst_b_sync;
  assign pgcb_isol_en_b = hqm_pm_unit.pgcb_isol_en_b;
  assign prim_freerun_prim_gated_rst_b_sync = hqm_pm_unit.prim_freerun_prim_gated_rst_b_sync;
  assign prim_freerun_clk = hqm_pm_unit.prim_freerun_clk;
  assign hqm_clk_enable_int = hqm_pm_unit.hqm_clk_enable_int;

//`HQM_SDG_ASSERTS_BEFORE_EVENT(isolate_before_powergate, ~pgcb_fet_en_b, ~pgcb_isol_en_b, ~pgcb_fet_en_b, pgcb_clk, side_rst_b_sync, `HQM_SVA_ERR_MSG("Error: assert_isolate_before_powergate")) ;

      // power can be gated (pgcb_fet_en_b) only if power domain boundy is isolated only
      isolate_before_powergate: assert property ( @(posedge pgcb_clk)  disable iff ((side_rst_b_sync!==1) )
         $fell(pgcb_fet_en_b) |-> (~$past(pgcb_isol_en_b))
      );


//     // the hqm_clk_enable_int needs to be low before pmsm gets to OFF state
//      hqm_clk_enable_int_active_pwr_off: assert property ( @(posedge prim_freerun_clk) disable iff ((prim_freerun_prim_gated_rst_b_sync!==1) )
//      ($fell(hqm_clk_enable_int) && (hqm_pm_unit.pmsm_state_f == HQM_PMSM_WAIT_ACK)) |-> ##[8:$] (hqm_pm_unit.pmsm_state_f==HQM_PMSM_PWR_OFF)
//    );


// in HQM_PMSMS_PWR_OFF state hqm_clk_enable_int needs to be low
in_hqm_pmsm_pwr_off_state_hqm_clk_enable_int_needstobe_low: assert property ( @(posedge prim_freerun_clk) disable iff ((prim_freerun_prim_gated_rst_b_sync!==1) )
      (hqm_pm_unit.pmsm_state_f == HQM_PMSM_PWR_OFF) |-> ~hqm_clk_enable_int
    );


// assert when isolation is released before power is turned on
//`HQM_SDG_ASSERTS_BEFORE_EVENT(assert_pgcb_isol_en_b_released_before_pmc_pgcb_fet_en_b, pmc_pgcb_fet_en_b, pgcb_fet_en_b, pgcb_isol_en_b, pgcb_clk, ~side_rst_b_sync, `HQM_SVA_ERR_MSG("Error: assert_pgcb_isol_en_b_released_before_pmc_pgcb_fet_en_b") );



`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_ctl_sb_wr_pgcb_clk,
  hqm_pm_unit.master_ctl,
  hqm_pm_unit.pgcb_clk ,
  (~hqm_pm_unit.side_rst_b_sync | ~$sampled(hqm_pm_unit.master_ctl_load_sync_pgcb)),
  `HQM_SVA_ERR_MSG( "Error: hqm_pm_unit_apb_response unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_ctl_sb_wr_prim_clk,
  hqm_pm_unit.master_ctl,
  hqm_pm_unit.prim_freerun_clk ,
  (~hqm_pm_unit.prim_freerun_side_rst_b_sync| ~$sampled(hqm_pm_unit.master_ctl_load_sync_prim)),
  `HQM_SVA_ERR_MSG( "Error: hqm_pm_unit_apb_response unknown")
  , SDG_SVA_SOC_SIM
)

endmodule

bind hqm_pm_unit hqm_pm_unit_assert i_hqm_pm_unit_assert();

 `endif

`endif

