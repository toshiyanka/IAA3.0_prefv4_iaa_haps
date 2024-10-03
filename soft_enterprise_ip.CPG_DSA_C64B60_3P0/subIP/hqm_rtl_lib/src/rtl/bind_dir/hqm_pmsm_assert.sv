`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_pmsm_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

  logic prim_freerun_clk;
  logic prim_freerun_prim_gated_rst_b_sync;
  logic go_off;
  logic go_on;



  assign prim_freerun_clk = hqm_pmsm.prim_freerun_clk;
  assign prim_freerun_prim_gated_rst_b_sync = hqm_pmsm.prim_freerun_prim_gated_rst_b_sync; 
  assign go_on = hqm_pmsm.go_on; 
  assign go_off = hqm_pmsm.go_off; 

  // 

  logic hqm_pmsm_go_on_go_off_error; // go_on and go_off can't be on at the same time

  always_comb begin
     hqm_pmsm_go_on_go_off_error =  go_off & go_on;
  end


  `HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_hqm_pmsm_go_on_go_off_error
                        , (hqm_pmsm_go_on_go_off_error)
                        , prim_freerun_clk
                        , ~prim_freerun_prim_gated_rst_b_sync
                        , `HQM_SVA_ERR_MSG("assert_forbidden_hqm_pmsm_go_on_go_off_error")
                        , SDG_SVA_SOC_SIM
                        )

endmodule

bind hqm_pmsm hqm_pmsm_assert i_hqm_pmsm_assert();

`endif

`endif

