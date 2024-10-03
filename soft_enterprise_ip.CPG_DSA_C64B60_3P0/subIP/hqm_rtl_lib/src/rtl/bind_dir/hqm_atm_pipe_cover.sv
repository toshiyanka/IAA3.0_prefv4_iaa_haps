`ifdef INTEL_INST_ON
module hqm_lsp_atm_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge hqm_lsp_atm_pipe.hqm_gated_clk);


  //Features
  WCP_FEATURE000_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[0] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE001_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[1] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE002_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[2] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE003_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[3] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE004_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[4] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE005_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[5] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE006_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[6] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE007_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[7] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE008_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[8] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE009_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[9] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE010_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[10] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE011_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[11] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE012_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[12] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE013_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[13] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;

  WCP_FEATURE017_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[17] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE018_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[18] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE019_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[19] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE020_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[20] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE021_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[21] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE022_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[22] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE023_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[23] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE024_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[24] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE025_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[25] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE026_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[26] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE027_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[27] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE028_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[28] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE029_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[29] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE030_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[30] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE031_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control7_nxt[31] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;

  WCP_FEATURE100_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[0] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE101_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[1] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE102_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[2] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE103_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[3] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE104_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[4] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE105_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[5] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE106_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[6] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE107_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[7] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE108_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[8] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE109_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[9] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE110_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[10] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE111_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[11] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE112_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[12] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;

  WCP_FEATURE116_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[16] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE117_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[17] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE118_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[18] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE119_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[19] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE120_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[20] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE121_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[21] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE122_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[22] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE123_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[23] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE124_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[24] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE125_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[25] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE126_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[26] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE127_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[27] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_FEATURE128_LL: coverpoint { hqm_lsp_atm_pipe.cfg_control8_nxt[28] } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;


  //Pipeline
  WCP_P00_LL: coverpoint { hqm_lsp_atm_pipe.p0_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P01_LL: coverpoint { hqm_lsp_atm_pipe.p1_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P02_LL: coverpoint { hqm_lsp_atm_pipe.p2_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P03_LL: coverpoint { hqm_lsp_atm_pipe.p3_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P04_LL: coverpoint { hqm_lsp_atm_pipe.p4_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P05_LL: coverpoint { hqm_lsp_atm_pipe.p5_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P06_LL: coverpoint { hqm_lsp_atm_pipe.p6_ll_data_f.cmd } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }

  WCP_H00_LL: coverpoint { hqm_lsp_atm_pipe.p0_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_H01_LL: coverpoint { hqm_lsp_atm_pipe.p1_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_H02_LL: coverpoint { hqm_lsp_atm_pipe.p2_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_H03_LL: coverpoint { hqm_lsp_atm_pipe.p3_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_H04_LL: coverpoint { hqm_lsp_atm_pipe.p4_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H05_LL: coverpoint { hqm_lsp_atm_pipe.p5_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H06_LL: coverpoint { hqm_lsp_atm_pipe.p6_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_LL: coverpoint { hqm_lsp_atm_pipe.p0_ll_ctrl.hold } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_PH01_LL: coverpoint { hqm_lsp_atm_pipe.p1_ll_ctrl.hold & hqm_lsp_atm_pipe.p0_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_PH02_LL: coverpoint { hqm_lsp_atm_pipe.p2_ll_ctrl.hold & hqm_lsp_atm_pipe.p1_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_PH03_LL: coverpoint { hqm_lsp_atm_pipe.p3_ll_ctrl.hold & hqm_lsp_atm_pipe.p2_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_PH04_LL: coverpoint { hqm_lsp_atm_pipe.p4_ll_ctrl.hold & hqm_lsp_atm_pipe.p3_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH05_LL: coverpoint { hqm_lsp_atm_pipe.p5_ll_ctrl.hold & hqm_lsp_atm_pipe.p4_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH06_LL: coverpoint { hqm_lsp_atm_pipe.p6_ll_ctrl.hold & hqm_lsp_atm_pipe.p5_ll_v_f } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCX_PXX_LL: cross WCP_P00_LL,WCP_P01_LL,WCP_P02_LL,WCP_P03_LL,WCP_P04_LL,WCP_P05_LL,WCP_P06_LL;
  WCX_HXX_LL: cross WCP_H00_LL,WCP_H01_LL,WCP_H02_LL,WCP_H03_LL,WCP_H04_LL,WCP_H05_LL,WCP_H06_LL;
  WCX_PHXX_LL: cross WCP_PH00_LL,WCP_PH01_LL,WCP_PH02_LL,WCP_PH03_LL,WCP_PH04_LL,WCP_PH05_LL,WCP_PH06_LL;

  WCP_H00_STALL: coverpoint { hqm_lsp_atm_pipe.stall_nc } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  

  //CONTENTION
  WCP_cfg_waiting_0: coverpoint { (|hqm_lsp_atm_pipe.cfg_pipe_health_valid_00_f) & hqm_lsp_atm_pipe.cfg_unit_idle_f.cfg_busy } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
/*
  WCP_vf_waiting_0: coverpoint { (|hqm_lsp_atm_pipe.cfg_pipe_health_valid_00_f) & hqm_lsp_atm_pipe.cfg_vf_reset_f.wait_for_idle } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_1: coverpoint { hqm_lsp_atm_pipe.cfg_unit_idle_f.cfg_busy & hqm_lsp_atm_pipe.cfg_vf_reset_f.wait_for_idle } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_2: coverpoint { hqm_lsp_atm_pipe.cfg_unit_idle_f.cfg_active & hqm_lsp_atm_pipe.cfg_vf_reset_f.wait_for_idle } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
*/

  //ARB
  WCP_arb_ll_strict_reqs: coverpoint { hqm_lsp_atm_pipe.arb_ll_strict_reqs } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_arb_ll_sch_reqs: coverpoint { hqm_lsp_atm_pipe.arb_ll_sch_reqs } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_arb_ll_rdy_reqs: coverpoint { hqm_lsp_atm_pipe.arb_ll_rdy_reqs } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;

  //FIFO
  WCP_fifo_ap_aqed: coverpoint { hqm_lsp_atm_pipe.fifo_ap_aqed_afull , hqm_lsp_atm_pipe.fifo_ap_aqed_empty } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_aqed_ap_enq: coverpoint { hqm_lsp_atm_pipe.fifo_aqed_ap_enq_afull , hqm_lsp_atm_pipe.fifo_aqed_ap_enq_empty } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }

  //IF
  WCP_ap_aqed_ready: coverpoint { hqm_lsp_atm_pipe.ap_aqed_ready } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;
  WCP_aqed_ap_enq_ready: coverpoint { hqm_lsp_atm_pipe.aqed_ap_enq_ready } iff (hqm_lsp_atm_pipe.hqm_gated_rst_n) ;


endgroup
COVERGROUP u_COVERGROUP = new();
`endif
endmodule
bind hqm_lsp_atm_pipe hqm_lsp_atm_pipe_cover i_hqm_lsp_atm_pipe_cover();
`endif

