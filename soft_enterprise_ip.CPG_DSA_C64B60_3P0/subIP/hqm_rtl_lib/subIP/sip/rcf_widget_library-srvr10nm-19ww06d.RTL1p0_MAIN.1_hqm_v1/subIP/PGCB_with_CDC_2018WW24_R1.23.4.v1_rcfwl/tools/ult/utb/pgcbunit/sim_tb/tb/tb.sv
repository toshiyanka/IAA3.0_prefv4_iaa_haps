
`include "tb.svh"
`include "tb_verif_definitions.svh"

module tb;
  logic pgcb_tck;
  logic clk;

  logic fdfx_powergood_rst_b;
  logic pgcb_rst_b;

  logic[1:0]                     cfg_taccrstup;
  logic[1:0]                     cfg_tclksoffack_srst;
  logic[1:0]                     cfg_tclksonack_cp;
  logic[1:0]                     cfg_tclksonack_srst;
  logic[1:0]                     cfg_tdeisolate;
  logic[1:0]                     cfg_tinaccrstup;
  logic[1:0]                     cfg_tisolate;
  logic[1:0]                     cfg_tlatchdis;
  logic[1:0]                     cfg_tlatchen;
  logic[1:0]                     cfg_tpokdown;
  logic[1:0]                     cfg_tpokup;
  logic[1:0]                     cfg_trstdown;
  logic[1:0]                     cfg_trstup2frcclks;
  logic[1:0]                     cfg_trsvd0;
  logic[1:0]                     cfg_trsvd1;
  logic[1:0]                     cfg_trsvd2;
  logic[1:0]                     cfg_trsvd3;
  logic[1:0]                     cfg_trsvd4;
  logic[1:0]                     cfg_tsleepact;
  logic[1:0]                     cfg_tsleepinactiv;
  logic                          fdfx_pgcb_bypass;
  logic                          fdfx_pgcb_ovr;
  logic                          fscan_isol_ctrl;
  logic                          fscan_isol_lat_ctrl;
  logic                          fscan_mode;
  logic                          fscan_ret_ctrl;
  logic                          ip_pgcb_all_pg_rst_up;
  logic                          ip_pgcb_force_clks_on_ack;
  logic                          ip_pgcb_frc_clk_cp_en;
  logic                          ip_pgcb_frc_clk_srst_cc_en;
  logic                          ip_pgcb_pg_rdy_req_b;
  logic[1:0]                     ip_pgcb_pg_type;
  logic                          ip_pgcb_sleep_en;
  logic                          pgcb_force_rst_b;
  logic                          pgcb_idle;
  logic                          pgcb_ip_fet_en_b;
  logic                          pgcb_ip_force_clks_on;
  logic                          pgcb_ip_pg_rdy_ack_b;
  logic                          pgcb_isol_en_b;
  logic                          pgcb_isol_latchen;
  logic                          pgcb_pmc_pg_req_b;
  logic                          pgcb_pok;
  logic                          pgcb_pwrgate_active;
  logic                          pgcb_restore;
  logic                          pgcb_restore_force_reg_rw;
  logic                          pgcb_sleep;
  logic                          pgcb_sleep2;
  logic[23:0]                    pgcb_visa;
  logic                          pmc_pgcb_fet_en_b;
  logic                          pmc_pgcb_pg_ack_b;
  logic                          pmc_pgcb_restore_b;


  initial begin : clk_pgcb_tck
    pgcb_tck = 1'b1;
    forever #500 pgcb_tck = ~pgcb_tck;
  end:clk_pgcb_tck

  initial begin : clk_clk
    clk = 1'b1;
    forever #500 clk = ~clk;
  end:clk_clk


  initial begin:rst_fdfx_powergood_rst_b
    fdfx_powergood_rst_b = 1'b0;
    repeat (10) @(posedge clk);
    fdfx_powergood_rst_b = 1'b1;
  end:rst_fdfx_powergood_rst_b

  initial begin:rst_pgcb_rst_b
    pgcb_rst_b = 1'b0;
    repeat (10) @(posedge clk);
    pgcb_rst_b = 1'b1;
  end:rst_pgcb_rst_b


`include "tb_verif.svh"

pgcbunit 
  `UTB_DUT_PARAM_PORTMAP
pgcbunit_1(
    .pgcb_tck ( pgcb_tck ),
    .clk ( clk ),
    .fdfx_powergood_rst_b ( fdfx_powergood_rst_b ),
    .pgcb_rst_b ( pgcb_rst_b ),
    .pmc_pgcb_pg_ack_b ( pmc_pgcb_pg_ack_b ),
    .fscan_isol_ctrl ( fscan_isol_ctrl ),
    .fscan_mode ( fscan_mode ),
    .cfg_trsvd3 ( cfg_trsvd3 ),
    .cfg_tlatchen ( cfg_tlatchen ),
    .cfg_trstup2frcclks ( cfg_trstup2frcclks ),
    .fdfx_pgcb_ovr ( fdfx_pgcb_ovr ),
    .ip_pgcb_frc_clk_cp_en ( ip_pgcb_frc_clk_cp_en ),
    .cfg_trsvd1 ( cfg_trsvd1 ),
    .ip_pgcb_pg_type ( ip_pgcb_pg_type ),
    .ip_pgcb_all_pg_rst_up ( ip_pgcb_all_pg_rst_up ),
    .fscan_isol_lat_ctrl ( fscan_isol_lat_ctrl ),
    .fdfx_pgcb_bypass ( fdfx_pgcb_bypass ),
    .cfg_tisolate ( cfg_tisolate ),
    .cfg_trsvd4 ( cfg_trsvd4 ),
    .cfg_trstdown ( cfg_trstdown ),
    .cfg_tclksonack_cp ( cfg_tclksonack_cp ),
    .cfg_tclksoffack_srst ( cfg_tclksoffack_srst ),
    .pmc_pgcb_restore_b ( pmc_pgcb_restore_b ),
    .cfg_tsleepinactiv ( cfg_tsleepinactiv ),
    .cfg_taccrstup ( cfg_taccrstup ),
    .ip_pgcb_frc_clk_srst_cc_en ( ip_pgcb_frc_clk_srst_cc_en ),
    .cfg_tclksonack_srst ( cfg_tclksonack_srst ),
    .ip_pgcb_sleep_en ( ip_pgcb_sleep_en ),
    .ip_pgcb_force_clks_on_ack ( ip_pgcb_force_clks_on_ack ),
    .cfg_tpokdown ( cfg_tpokdown ),
    .cfg_tsleepact ( cfg_tsleepact ),
    .cfg_tdeisolate ( cfg_tdeisolate ),
    .ip_pgcb_pg_rdy_req_b ( ip_pgcb_pg_rdy_req_b ),
    .pmc_pgcb_fet_en_b ( pmc_pgcb_fet_en_b ),
    .cfg_tinaccrstup ( cfg_tinaccrstup ),
    .cfg_trsvd2 ( cfg_trsvd2 ),
    .cfg_tpokup ( cfg_tpokup ),
    .fscan_ret_ctrl ( fscan_ret_ctrl ),
    .cfg_trsvd0 ( cfg_trsvd0 ),
    .cfg_tlatchdis ( cfg_tlatchdis ),
    .pgcb_sleep ( pgcb_sleep ),
    .pgcb_ip_pg_rdy_ack_b ( pgcb_ip_pg_rdy_ack_b ),
    .pgcb_idle ( pgcb_idle ),
    .pgcb_ip_force_clks_on ( pgcb_ip_force_clks_on ),
    .pgcb_visa ( pgcb_visa ),
    .pgcb_isol_en_b ( pgcb_isol_en_b ),
    .pgcb_pwrgate_active ( pgcb_pwrgate_active ),
    .pgcb_pok ( pgcb_pok ),
    .pgcb_restore ( pgcb_restore ),
    .pgcb_ip_fet_en_b ( pgcb_ip_fet_en_b ),
    .pgcb_isol_latchen ( pgcb_isol_latchen ),
    .pgcb_pmc_pg_req_b ( pgcb_pmc_pg_req_b ),
    .pgcb_restore_force_reg_rw ( pgcb_restore_force_reg_rw ),
    .pgcb_sleep2 ( pgcb_sleep2 ),
    .pgcb_force_rst_b ( pgcb_force_rst_b ));

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
