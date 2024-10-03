
`include "tb.svh"
`include "tb_verif_definitions.svh"

module tb;
  logic clock;
  logic pgcb_clk;

  logic pgcb_rst_b;

  logic                          boundary_locked;
  logic[23:0]                    cdc_visa;
  logic                          cfg_clkgate_disabled;
  logic[3:0]                     cfg_clkgate_holdoff;
  logic                          cfg_clkreq_ctl_disabled;
  logic[3:0]                     cfg_clkreq_off_holdoff;
  logic[3:0]                     cfg_clkreq_syncoff_holdoff;
  logic[3:0]                     cfg_pwrgate_holdoff;
  logic                          clkack;
  logic                          clkreq;
  logic                          fismdfx_clkgate_ovrd;
  logic                          fismdfx_force_clkreq;
  logic[2:0]                     fscan_byprst_b;
  logic[1:0]                     fscan_clkgenctrl;
  logic[1:0]                     fscan_clkgenctrlen;
  logic                          fscan_clkungate;
  logic[2:0]                     fscan_rstbypen;
  logic                          gclock;
  logic[0:0]                     gclock_ack_async;
  logic                          gclock_active;
  logic                          gclock_enable_final;
  logic[0:0]                     gclock_req_async;
  logic                          gclock_req_sync;
  logic[0:0]                     greset_b;
  logic[2:0]                     ism_agent;
  logic[2:0]                     ism_fabric;
  logic                          ism_locked;
  logic                          pgcb_force_rst_b;
  logic                          pgcb_pok;
  logic                          pgcb_pwrgate_active;
  logic                          pgcb_restore;
  logic                          pok;
  logic                          pok_reset_b;
  logic                          prescc_clock;
  logic                          pwrgate_disabled;
  logic                          pwrgate_force;
  logic                          pwrgate_pmc_wake;
  logic                          pwrgate_ready;
  logic[0:0]                     reset_b;
  logic[0:0]                     reset_sync_b;


  initial begin : clk_clock
    clock = 1'b1;
    forever #500 clock = ~clock;
  end:clk_clock

  initial begin : clk_pgcb_clk
    pgcb_clk = 1'b1;
    forever #500 pgcb_clk = ~pgcb_clk;
  end:clk_pgcb_clk


  initial begin:rst_pgcb_rst_b
    pgcb_rst_b = 1'b0;
    repeat (10) @(posedge clock);
    pgcb_rst_b = 1'b1;
  end:rst_pgcb_rst_b


`include "tb_verif.svh"

ClockDomainController 
  `UTB_DUT_PARAM_PORTMAP
ClockDomainController_1(
    .clock ( clock ),
    .pgcb_clk ( pgcb_clk ),
    .pgcb_rst_b ( pgcb_rst_b ),
    .gclock_req_sync ( gclock_req_sync ),
    .reset_b ( reset_b ),
    .pwrgate_pmc_wake ( pwrgate_pmc_wake ),
    .prescc_clock ( prescc_clock ),
    .ism_agent ( ism_agent ),
    .cfg_clkreq_ctl_disabled ( cfg_clkreq_ctl_disabled ),
    .fismdfx_force_clkreq ( fismdfx_force_clkreq ),
    .cfg_clkgate_holdoff ( cfg_clkgate_holdoff ),
    .gclock_req_async ( gclock_req_async ),
    .pgcb_restore ( pgcb_restore ),
    .pgcb_force_rst_b ( pgcb_force_rst_b ),
    .fscan_rstbypen ( fscan_rstbypen ),
    .pok_reset_b ( pok_reset_b ),
    .cfg_clkreq_off_holdoff ( cfg_clkreq_off_holdoff ),
    .clkack ( clkack ),
    .cfg_pwrgate_holdoff ( cfg_pwrgate_holdoff ),
    .ism_fabric ( ism_fabric ),
    .pwrgate_disabled ( pwrgate_disabled ),
    .fscan_byprst_b ( fscan_byprst_b ),
    .pgcb_pwrgate_active ( pgcb_pwrgate_active ),
    .pgcb_pok ( pgcb_pok ),
    .fismdfx_clkgate_ovrd ( fismdfx_clkgate_ovrd ),
    .fscan_clkungate ( fscan_clkungate ),
    .pwrgate_force ( pwrgate_force ),
    .fscan_clkgenctrlen ( fscan_clkgenctrlen ),
    .cfg_clkgate_disabled ( cfg_clkgate_disabled ),
    .fscan_clkgenctrl ( fscan_clkgenctrl ),
    .cfg_clkreq_syncoff_holdoff ( cfg_clkreq_syncoff_holdoff ),
    .pok ( pok ),
    .greset_b ( greset_b ),
    .ism_locked ( ism_locked ),
    .gclock_active ( gclock_active ),
    .gclock ( gclock ),
    .cdc_visa ( cdc_visa ),
    .gclock_ack_async ( gclock_ack_async ),
    .reset_sync_b ( reset_sync_b ),
    .boundary_locked ( boundary_locked ),
    .gclock_enable_final ( gclock_enable_final ),
    .pwrgate_ready ( pwrgate_ready ),
    .clkreq ( clkreq ));

initial begin
    fork : this_test 
    begin : body
        `define JGTESTFILE `"`TESTNAME.jvh`"
        `include `JGTESTFILE
        `define TESTFILE `"`TESTNAME.svh`"
        `include `TESTFILE
    end
    begin : wd_timer 
        #`TEST_TIME;
        `ASSERT_EQ(0, "Test hang")
    end
    join_any
    disable this_test;
    $finish();
end


endmodule: tb
