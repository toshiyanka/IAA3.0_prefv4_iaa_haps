`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_master_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

// hqm_pwrgood_rst_b should only be issued IFF pmsm triggered flr
logic prim_freerun_clk;
logic prim_freerun_prim_gated_rst_b_sync;

assign prim_freerun_clk                    = hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.prim_freerun_clk;
assign prim_freerun_prim_gated_rst_b_sync  = hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.prim_freerun_prim_gated_rst_b_sync;

//==========================================================================================
logic psel, penable;
logic penable_f;
logic pselenb_wr;
logic pselenb_rd;

assign psel    = hqm_master_core.psel;
assign penable = hqm_master_core.penable;
assign pwrite  = hqm_master_core.pwrite;

always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    penable_f   <= 1'b0 ;
  end else begin
    penable_f   <= penable;
  end 
end

assign pselenb_wr = (psel & penable &  pwrite) & (~penable_f);
assign pselenb_rd = (psel & penable & ~pwrite) & (~penable_f);
//==========================================================================================

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( 
  assert_knowndriven_master_apb_control,
  ( hqm_master_core.psel
  | hqm_master_core.penable
  | hqm_master_core.pwrite
  | hqm_master_core.pready
  ),
  posedge prim_freerun_clk,
  (~prim_freerun_prim_gated_rst_b_sync),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_apb_control is unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( 
  assert_knowndriven_master_apb_write,
  ( hqm_master_core.puser
  | hqm_master_core.pwdata
  | hqm_master_core.paddr
  ),
  posedge prim_freerun_clk,
  (~prim_freerun_prim_gated_rst_b_sync | ~$sampled(pselenb_wr)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_apb_write is unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_apb_read,
  ( hqm_master_core.i_hqm_cfg_master.puser.a_par
  | hqm_master_core.i_hqm_cfg_master.puser.rsvd
  | hqm_master_core.i_hqm_cfg_master.puser.addr_decode_par_err
  | hqm_master_core.i_hqm_cfg_master.puser.disable_ring_parity_check
  | hqm_master_core.i_hqm_cfg_master.puser.addr_decode_err
  | hqm_master_core.paddr
  ),
  posedge prim_freerun_clk,
  (~prim_freerun_prim_gated_rst_b_sync | ~$sampled(pselenb_rd)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_apb_read is unknown")
  , SDG_SVA_SOC_SIM
) 


`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_apb_response,
  ( hqm_master_core.pslverr
  | hqm_master_core.prdata
  | hqm_master_core.prdata_par
  ),
  posedge prim_freerun_clk,
  (~prim_freerun_prim_gated_rst_b_sync | ~$sampled(hqm_master_core.pready)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_apb_response unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_misc_prim,
  ( hqm_master_core.flr_triggered
  | hqm_master_core.prochot
  | hqm_master_core.pm_state
  ),
  posedge prim_freerun_clk,
  (~prim_freerun_prim_gated_rst_b_sync),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_misc_prim unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_misc_hqm,
  ( hqm_master_core.mstr_hqm_reset_done
  | hqm_master_core.mstr_unit_idle
  | hqm_master_core.mstr_unit_pipeidle
  ),
  posedge hqm_master_core.hqm_inp_gated_clk,
  (~hqm_master_core.hqm_gated_rst_b),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_misc_hqm is unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( 
  assert_knowndriven_master_cfg_rsp,
  ( hqm_master_core.mstr_cfg_rsp_up
  ),
  posedge hqm_master_core.hqm_inp_gated_clk,
  (~hqm_master_core.hqm_gated_rst_b | ~$sampled(hqm_master_core.mstr_cfg_rsp_up_ack)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_cfg_rsp_rdata is unknown")
  , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_cfg_req_down_write,
  ( hqm_master_core.mstr_cfg_req_down
  ),
  posedge hqm_master_core.hqm_inp_gated_clk,
  (~hqm_master_core.hqm_gated_rst_b | ~$sampled(hqm_master_core.mstr_cfg_req_down_write)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_cfg_req_down is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
  assert_knowndriven_master_cfg_req_down_read,
  ( hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.addr
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.addr_par
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.cfg_ignore_pipe_busy
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.user.a_par
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.user.rsvd
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.user.addr_decode_par_err
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.user.disable_ring_parity_check
  | hqm_master_core.i_hqm_proc_master.mstr_cfg_req_down.user.addr_decode_err
  ),
  posedge hqm_master_core.hqm_inp_gated_clk,
  (~hqm_master_core.hqm_gated_rst_b | ~$sampled(hqm_master_core.mstr_cfg_req_down_read)),
  `HQM_SVA_ERR_MSG( "Error: hqm_master_cfg_req_down is unknown")
  , SDG_SVA_SOC_SIM
)



////////////////////////////////////////////////////////////////////////////////////////////////////

//SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) 

//some units need to flop unit_idle for STA,  check those with flopped pipeidle
//aqed_unit_pipeidle
//dqed_unit_pipeidle
//qed_unit_pipeidle
//dp_unit_pipeidle
//ap_unit_pipeidle
//nalb_unit_pipeidle
//lsp_unit_pipeidle
//rop_unit_pipeidle
//chp_unit_pipeidle
logic [ ( 32 ) - 1 : 0 ] mstr_unit_pipeidle_f2;
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync ) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    mstr_unit_pipeidle_f2 <= '1 ;
  end else begin
    mstr_unit_pipeidle_f2 <= hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f ;
  end
end
//dont check when hqm_flr_prep is assert3ed since it overrides mstr_unit_idle_post_prot->hqm_proc_master_unit_idle_f but does not override hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_00
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[0] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_00: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_01
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[1] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_01: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_02
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[2] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_02: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_03
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[3] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_03: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_04
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[4] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_04: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_05
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[5] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_05: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_06
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~mstr_unit_pipeidle_f2[6] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_06: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_07
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~mstr_unit_pipeidle_f2[7] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_07: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_unit_idle_not_pipe_idle_08
                      , ( ~ hqm_master_core.i_hqm_proc_master.hqm_flr_prep & hqm_master_core.i_hqm_proc_master.hqm_proc_master_unit_idle_f & ~hqm_master_core.i_hqm_proc_master.mstr_unit_pipeidle_f[8] )
                      , posedge hqm_master_core.hqm_inp_gated_clk
                      , ~hqm_master_core.hqm_gated_rst_b
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_pipe_idle_not_unit_idle_08: " )
                      , SDG_SVA_SOC_SIM
                      )






// Check that Sync'ed version of master_ctl reg is always known within clk throttle unit 
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_master_ctl_sync_hqm_clk
                      ,  hqm_master_core.i_hqm_clk_throttle_unit.master_ctl_clk_switch_f 
                      , posedge hqm_master_core.i_hqm_clk_throttle_unit.hqm_cdc_clk
                      , (~hqm_master_core.i_hqm_clk_throttle_unit.hqm_fullrate_side_rst_b_sync)
                      , `HQM_SVA_ERR_MSG( "Error: hqm_clk_throttle_unit.master_ctl_clk_switch_f is unknown")
                      , SDG_SVA_SOC_SIM
                      )

// Check that Sync'ed version of master_ctl reg is always known within pm_unit
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_master_ctl_sync_pgcb_clk
                      , hqm_master_core.i_hqm_pm_unit.master_ctl_pgcb_f
                      , posedge hqm_master_core.i_hqm_pm_unit.pgcb_clk
                      , (~hqm_master_core.i_hqm_pm_unit.side_rst_b_sync)
                      , `HQM_SVA_ERR_MSG( "Error: hqm_master_core.hqm_pm_unit.master_ctl_pgcb_f is unknown")
                      , SDG_SVA_SOC_SIM
                      )

// Check that Sync'ed version of master_ctl reg is always known within pm_unit
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_master_ctl_sync_prim_clk
                      , hqm_master_core.i_hqm_pm_unit.master_ctl_prim_f
                      , posedge hqm_master_core.i_hqm_pm_unit.prim_freerun_clk
                      , (~hqm_master_core.i_hqm_pm_unit.prim_freerun_side_rst_b_sync)
                      , `HQM_SVA_ERR_MSG( "Error: hqm_master_core.hqm_pm_unit.master_ctl_prim_f is unknown")
                      , SDG_SVA_SOC_SIM
                      )


logic prep_off_2_inactive;
logic iosf_triggered_f;
logic pmsm_triggered_f;

always_comb begin
  
  prep_off_2_inactive = (hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flrsm_state_nxt == HQM_FLRSM_INACTIVE) & (hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flrsm_state_f == HQM_FLRSM_PREP_OFF);

end


always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync ) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    iosf_triggered_f <= '0 ;
    pmsm_triggered_f <= '0 ;
  end else begin
    iosf_triggered_f <= (hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flr_triggered_edge_detect | iosf_triggered_f) & ~prep_off_2_inactive ;  
    pmsm_triggered_f <= (hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flr_pmfsm_triggered_edge_detect | pmsm_triggered_f) & ~prep_off_2_inactive ;
  end
end

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_flr_req_f_eq_3
                      , ( hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flr_req_f[1:0] == 2'b11 )
                      , posedge prim_freerun_clk
                      , ~prim_freerun_prim_gated_rst_b_sync
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_flr_req_f_eq_3: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_hqm_pwrgood_rst_b_iosf_trigger
                      , ( ~hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.hqm_pwrgood_rst_b_nxt & iosf_triggered_f)
                      , posedge prim_freerun_clk
                      , ~prim_freerun_prim_gated_rst_b_sync
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_hqm_pwrgood_rst_b_iosf_trigger: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_hqm_pwrgood_rst_b_pmsm_trigger
                      , ( hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.hqm_pwrgood_rst_b_nxt & pmsm_triggered_f & (hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flrsm_state_f == HQM_FLRSM_PWRGOOD_RST_ACTIVE))
                      , posedge prim_freerun_clk
                      , ~prim_freerun_prim_gated_rst_b_sync
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_hqm_pwrgood_rst_b_pmsm_trigger: " )
                      , SDG_SVA_SOC_SIM
                      )
logic hqm_clk_off_mask;
always_comb begin
  hqm_clk_off_mask = 1'b0 ;

  if ($test$plusargs("HQM_MSTR_HQM_CLK_OFF_ERROR_TEST") ) begin
    hqm_clk_off_mask = 1'b1 ;
  end
end



endmodule

bind hqm_master_core hqm_master_assert i_hqm_master_assert();

`endif

`endif
