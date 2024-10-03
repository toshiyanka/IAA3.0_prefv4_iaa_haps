`ifdef INTEL_INST_ON
module hqm_aqed_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge hqm_aqed_pipe_core.hqm_gated_clk);

  //Pipeline
  WCP_P00_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P01_LL: coverpoint { hqm_aqed_pipe_core.p1_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P02_LL: coverpoint { hqm_aqed_pipe_core.p2_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P03_LL: coverpoint { hqm_aqed_pipe_core.p3_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; }
  WCP_P04_LL: coverpoint { hqm_aqed_pipe_core.p4_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P05_LL: coverpoint { hqm_aqed_pipe_core.p5_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P06_LL: coverpoint { hqm_aqed_pipe_core.p6_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P07_LL: coverpoint { hqm_aqed_pipe_core.p7_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P08_LL: coverpoint { hqm_aqed_pipe_core.p8_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P09_LL: coverpoint { hqm_aqed_pipe_core.p9_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P10_LL: coverpoint { hqm_aqed_pipe_core.p10_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P11_LL: coverpoint { hqm_aqed_pipe_core.p11_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P12_LL: coverpoint { hqm_aqed_pipe_core.p12_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P13_LL: coverpoint { hqm_aqed_pipe_core.p13_ll_data_f.cmd } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }

  WCP_H00_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_LL: coverpoint { hqm_aqed_pipe_core.p1_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_LL: coverpoint { hqm_aqed_pipe_core.p2_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_LL: coverpoint { hqm_aqed_pipe_core.p3_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_LL: coverpoint { hqm_aqed_pipe_core.p4_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_LL: coverpoint { hqm_aqed_pipe_core.p5_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_LL: coverpoint { hqm_aqed_pipe_core.p6_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_LL: coverpoint { hqm_aqed_pipe_core.p7_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H08_LL: coverpoint { hqm_aqed_pipe_core.p8_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H09_LL: coverpoint { hqm_aqed_pipe_core.p9_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H10_LL: coverpoint { hqm_aqed_pipe_core.p10_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_H11_LL: coverpoint { hqm_aqed_pipe_core.p11_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H12_LL: coverpoint { hqm_aqed_pipe_core.p12_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H13_LL: coverpoint { hqm_aqed_pipe_core.p13_ll_ctrl.hold } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_ctrl.hold & (hqm_aqed_pipe_core.fifo_qed_aqed_enq_pop_data_v | ~hqm_aqed_pipe_core.fifo_ap_aqed_empty) } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_LL: coverpoint { hqm_aqed_pipe_core.p1_ll_ctrl.hold & hqm_aqed_pipe_core.p0_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_LL: coverpoint { hqm_aqed_pipe_core.p2_ll_ctrl.hold & hqm_aqed_pipe_core.p1_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_LL: coverpoint { hqm_aqed_pipe_core.p3_ll_ctrl.hold & hqm_aqed_pipe_core.p2_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_LL: coverpoint { hqm_aqed_pipe_core.p4_ll_ctrl.hold & hqm_aqed_pipe_core.p3_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_LL: coverpoint { hqm_aqed_pipe_core.p5_ll_ctrl.hold & hqm_aqed_pipe_core.p4_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_LL: coverpoint { hqm_aqed_pipe_core.p6_ll_ctrl.hold & hqm_aqed_pipe_core.p5_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_LL: coverpoint { hqm_aqed_pipe_core.p7_ll_ctrl.hold & hqm_aqed_pipe_core.p6_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH08_LL: coverpoint { hqm_aqed_pipe_core.p8_ll_ctrl.hold & hqm_aqed_pipe_core.p7_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH09_LL: coverpoint { hqm_aqed_pipe_core.p9_ll_ctrl.hold & hqm_aqed_pipe_core.p8_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH10_LL: coverpoint { hqm_aqed_pipe_core.p10_ll_ctrl.hold & hqm_aqed_pipe_core.p9_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_PH11_LL: coverpoint { hqm_aqed_pipe_core.p11_ll_ctrl.hold & hqm_aqed_pipe_core.p10_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH12_LL: coverpoint { hqm_aqed_pipe_core.p12_ll_ctrl.hold & hqm_aqed_pipe_core.p11_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH13_LL: coverpoint { hqm_aqed_pipe_core.p13_ll_ctrl.hold & hqm_aqed_pipe_core.p12_ll_v_f } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCX_PXX_LL_0: cross WCP_P00_LL,WCP_P01_LL,WCP_P02_LL,WCP_P03_LL,WCP_P04_LL,WCP_P05_LL,WCP_P06_LL ;
  WCX_PXX_LL_1: cross WCP_P07_LL,WCP_P08_LL,WCP_P09_LL,WCP_P10_LL,WCP_P11_LL,WCP_P12_LL,WCP_P13_LL ;

  WCX_HXX_LL_0: cross WCP_H00_LL,WCP_H01_LL,WCP_H02_LL,WCP_H03_LL,WCP_H04_LL,WCP_H05_LL,WCP_H06_LL ;
  WCX_HXX_LL_1: cross WCP_H07_LL,WCP_H08_LL,WCP_H09_LL,WCP_H10_LL,WCP_H11_LL,WCP_H12_LL,WCP_H13_LL ;

  WCX_PHXX_LL_0: cross WCP_PH00_LL,WCP_PH01_LL,WCP_PH02_LL,WCP_PH03_LL,WCP_PH04_LL,WCP_PH05_LL,WCP_PH06_LL ;
  WCX_PHXX_LL_1: cross WCP_PH07_LL,WCP_PH08_LL,WCP_PH09_LL,WCP_PH10_LL,WCP_PH11_LL,WCP_PH12_LL,WCP_PH13_LL ;

  WCP_H00_STALL: coverpoint { hqm_aqed_pipe_core.p10_stall_nc } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  

  //CONTENTION
  WCP_cfg_waiting_0: coverpoint { (|hqm_aqed_pipe_core.cfg_pipe_health_valid_f_nc) & hqm_aqed_pipe_core.cfg_unit_idle_f.cfg_busy } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
/*
  WCP_vf_waiting_0: coverpoint { (|hqm_aqed_pipe_core.cfg_pipe_health_valid_f_nc) & hqm_aqed_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_1: coverpoint { hqm_aqed_pipe_core.cfg_unit_idle_f.cfg_busy & hqm_aqed_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_2: coverpoint { hqm_aqed_pipe_core.cfg_unit_idle_f.cfg_active & hqm_aqed_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
*/
 
  //ARB
  WCP_arb_ll_reqs: coverpoint { hqm_aqed_pipe_core.arb_ll_reqs } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_ll_cnt_reqs0: coverpoint { hqm_aqed_pipe_core.arb_ll_cnt_reqs[0] } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_ll_cnt_reqs1: coverpoint { hqm_aqed_pipe_core.arb_ll_cnt_reqs[1] } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCX_arb_ll_cnt_reqs: cross WCP_arb_ll_cnt_reqs0,WCP_arb_ll_cnt_reqs1;

  //FIFO
  WCP_fifo_qed_aqed_enq: coverpoint { hqm_aqed_pipe_core.fifo_qed_aqed_enq_afull_nc , hqm_aqed_pipe_core.fifo_qed_aqed_enq_pop_data_v } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_aqed_ap_enq: coverpoint { hqm_aqed_pipe_core.fifo_aqed_ap_enq_afull , hqm_aqed_pipe_core.fifo_aqed_ap_enq_empty } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_ap_aqed: coverpoint { hqm_aqed_pipe_core.fifo_ap_aqed_afull , hqm_aqed_pipe_core.fifo_ap_aqed_empty } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_aqed_chp_sch: coverpoint { hqm_aqed_pipe_core.fifo_aqed_chp_sch_afull , hqm_aqed_pipe_core.fifo_aqed_chp_sch_empty } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCX_fifo: cross WCP_fifo_qed_aqed_enq,WCP_fifo_aqed_ap_enq,WCP_fifo_ap_aqed,WCP_fifo_aqed_chp_sch ;
 
  //IF
  WCP_ap_aqed_ready: coverpoint { hqm_aqed_pipe_core.ap_aqed_ready } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_qed_aqed_enq_ready: coverpoint { hqm_aqed_pipe_core.qed_aqed_enq_ready } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_aqed_ap_enq_ready: coverpoint { hqm_aqed_pipe_core.aqed_ap_enq_ready } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_aqed_chp_sch_ready: coverpoint { hqm_aqed_pipe_core.aqed_chp_sch_ready } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;
  WCP_aqed_lsp_sch_ready: coverpoint { hqm_aqed_pipe_core.aqed_lsp_sch_ready } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) ;

  //USAGE
  WCP_cq_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_data_f.cq } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=256; ignore_bins VAL = { [64:255] }; }
  WCP_qid_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_data_f.qid } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { bins valid_qid = {[0:31]}; ignore_bins invalid_qid = { [32:$] }; }
  WCP_qpri_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_data_f.qpri } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; ignore_bins VAL= { [4:7] }; }
  WCP_fid_LL: coverpoint { hqm_aqed_pipe_core.p0_ll_data_f.fid } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=4096; ignore_bins VAL = { [2048:4096] }; }


/*
  WCP_vasreset: coverpoint { ( hqm_aqed_pipe_core.cfg_vf_reset_f.cmd == hqm_aqed_pipe_core.HQM_AQED_VF_RESET_CMD_QID_WRITE_CNT_X ) & ( hqm_aqed_pipe_core.cfg_vf_reset_nxt.cmd == hqm_aqed_pipe_core.HQM_AQED_VF_RESET_CMD_DONE ) } iff (hqm_aqed_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=4096; ignore_bins VAL = { [2048:4096] }; }
*/



endgroup
COVERGROUP u_COVERGROUP = new();
`endif
endmodule
bind hqm_aqed_pipe_core hqm_aqed_pipe_cover i_hqm_aqed_pipe_cover();
`endif

