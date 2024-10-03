`ifdef INTEL_INST_ON
module hqm_dir_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge hqm_dir_pipe_core.hqm_gated_clk);


  WCP_ENQNOSTALL_00: coverpoint { ( hqm_dir_pipe_core.p6_dir_v_nxt
                                  & ( hqm_dir_pipe_core.p6_dir_data_nxt.cmd == hqm_dir_pipe_core.HQM_DP_CMD_ENQ )
                                  & ( ( ( hqm_dir_pipe_core.p7_dir_v_nxt & ( hqm_dir_pipe_core.p7_dir_data_nxt.qid == hqm_dir_pipe_core.p6_dir_data_nxt.qid ) ) & ( hqm_dir_pipe_core.p7_dir_v_nxt & ( hqm_dir_pipe_core.p7_dir_data_nxt.qpri == hqm_dir_pipe_core.p6_dir_data_nxt.qpri ) ) )
                                    | ( ( hqm_dir_pipe_core.p8_dir_v_nxt & ( hqm_dir_pipe_core.p8_dir_data_nxt.qid == hqm_dir_pipe_core.p6_dir_data_nxt.qid ) ) & ( hqm_dir_pipe_core.p8_dir_v_nxt & ( hqm_dir_pipe_core.p8_dir_data_nxt.qpri == hqm_dir_pipe_core.p6_dir_data_nxt.qpri ) ) )
                                    ) 
                                  ) } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;



  //FEature
  WCP_FEATURE000_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[0] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE001_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[1] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE002_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[2] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE003_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[3] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE004_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[4] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE005_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[5] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE006_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[6] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE007_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[7] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE008_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[8] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;

  WCP_FEATURE016_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[16] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE017_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[17] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE018_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[18] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE019_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[19] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE020_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[20] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE021_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[21] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE022_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[22] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE023_LL: coverpoint { hqm_dir_pipe_core.cfg_control6_nxt[23] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;

  WCP_FEATURE100_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[0] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE101_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[1] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE102_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[2] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE103_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[3] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE104_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[4] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE105_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[5] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE106_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[6] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE107_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[7] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE108_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[8] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  
  WCP_FEATURE116_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[16] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE117_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[17] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE118_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[18] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE119_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[19] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE120_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[20] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE121_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[21] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE122_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[22] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE123_LL: coverpoint { hqm_dir_pipe_core.cfg_control7_nxt[23] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;



  //Pipeline
  WCP_P00_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P01_DIR: coverpoint { hqm_dir_pipe_core.p1_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P02_DIR: coverpoint { hqm_dir_pipe_core.p2_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P03_DIR: coverpoint { hqm_dir_pipe_core.p3_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P04_DIR: coverpoint { hqm_dir_pipe_core.p4_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P05_DIR: coverpoint { hqm_dir_pipe_core.p5_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P06_DIR: coverpoint { hqm_dir_pipe_core.p6_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P07_DIR: coverpoint { hqm_dir_pipe_core.p7_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P08_DIR: coverpoint { hqm_dir_pipe_core.p8_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P09_DIR: coverpoint { hqm_dir_pipe_core.p9_dir_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }

  WCP_H00_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_DIR: coverpoint { hqm_dir_pipe_core.p1_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_DIR: coverpoint { hqm_dir_pipe_core.p2_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_DIR: coverpoint { hqm_dir_pipe_core.p3_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_DIR: coverpoint { hqm_dir_pipe_core.p4_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_DIR: coverpoint { hqm_dir_pipe_core.p5_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_DIR: coverpoint { hqm_dir_pipe_core.p6_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_DIR: coverpoint { hqm_dir_pipe_core.p7_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_DIR: coverpoint { hqm_dir_pipe_core.p8_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_DIR: coverpoint { hqm_dir_pipe_core.p9_dir_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_ctrl.hold & (~hqm_dir_pipe_core.fifo_rop_dp_enq_dir_empty | ~hqm_dir_pipe_core.fifo_lsp_dp_sch_dir_empty) } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_DIR: coverpoint { hqm_dir_pipe_core.p1_dir_ctrl.hold & hqm_dir_pipe_core.p0_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_DIR: coverpoint { hqm_dir_pipe_core.p2_dir_ctrl.hold & hqm_dir_pipe_core.p1_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_DIR: coverpoint { hqm_dir_pipe_core.p3_dir_ctrl.hold & hqm_dir_pipe_core.p2_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_DIR: coverpoint { hqm_dir_pipe_core.p4_dir_ctrl.hold & hqm_dir_pipe_core.p3_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_DIR: coverpoint { hqm_dir_pipe_core.p5_dir_ctrl.hold & hqm_dir_pipe_core.p4_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_DIR: coverpoint { hqm_dir_pipe_core.p6_dir_ctrl.hold & hqm_dir_pipe_core.p5_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_DIR: coverpoint { hqm_dir_pipe_core.p7_dir_ctrl.hold & hqm_dir_pipe_core.p6_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_DIR: coverpoint { hqm_dir_pipe_core.p8_dir_ctrl.hold & hqm_dir_pipe_core.p7_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_DIR: coverpoint { hqm_dir_pipe_core.p9_dir_ctrl.hold & hqm_dir_pipe_core.p8_dir_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_DIR: cross WCP_P00_DIR,WCP_P01_DIR,WCP_P02_DIR,WCP_P03_DIR,WCP_P04_DIR,WCP_P05_DIR,WCP_P06_DIR,WCP_P07_DIR,WCP_P08_DIR,WCP_P09_DIR ;
//WCX_HXX_DIR: cross WCP_H00_DIR,WCP_H01_DIR,WCP_H02_DIR,WCP_H03_DIR,WCP_H04_DIR,WCP_H05_DIR,WCP_H06_DIR,WCP_H07_DIR,WCP_H08_DIR,WCP_H09_DIR ;
//WCX_PHXX_DIR: cross WCP_PH00_DIR,WCP_PH01_DIR,WCP_PH02_DIR,WCP_PH03_DIR,WCP_PH04_DIR,WCP_PH05_DIR,WCP_PH06_DIR,WCP_PH07_DIR,WCP_PH08_DIR,WCP_PH09_DIR ;

  WCP_P00_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P01_ROFRAG: coverpoint { hqm_dir_pipe_core.p1_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P02_ROFRAG: coverpoint { hqm_dir_pipe_core.p2_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P03_ROFRAG: coverpoint { hqm_dir_pipe_core.p3_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P04_ROFRAG: coverpoint { hqm_dir_pipe_core.p4_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P05_ROFRAG: coverpoint { hqm_dir_pipe_core.p5_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P06_ROFRAG: coverpoint { hqm_dir_pipe_core.p6_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P07_ROFRAG: coverpoint { hqm_dir_pipe_core.p7_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P08_ROFRAG: coverpoint { hqm_dir_pipe_core.p8_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P09_ROFRAG: coverpoint { hqm_dir_pipe_core.p9_rofrag_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }

  WCP_H00_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_ROFRAG: coverpoint { hqm_dir_pipe_core.p1_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_ROFRAG: coverpoint { hqm_dir_pipe_core.p2_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_ROFRAG: coverpoint { hqm_dir_pipe_core.p3_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_ROFRAG: coverpoint { hqm_dir_pipe_core.p4_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_ROFRAG: coverpoint { hqm_dir_pipe_core.p5_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_ROFRAG: coverpoint { hqm_dir_pipe_core.p6_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_ROFRAG: coverpoint { hqm_dir_pipe_core.p7_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_ROFRAG: coverpoint { hqm_dir_pipe_core.p8_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_ROFRAG: coverpoint { hqm_dir_pipe_core.p9_rofrag_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_ctrl.hold & (~hqm_dir_pipe_core.fifo_rop_dp_enq_ro_empty | ~hqm_dir_pipe_core.fifo_lsp_dp_sch_rorply_empty ) } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_ROFRAG: coverpoint { hqm_dir_pipe_core.p1_rofrag_ctrl.hold & hqm_dir_pipe_core.p0_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_ROFRAG: coverpoint { hqm_dir_pipe_core.p2_rofrag_ctrl.hold & hqm_dir_pipe_core.p1_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_ROFRAG: coverpoint { hqm_dir_pipe_core.p3_rofrag_ctrl.hold & hqm_dir_pipe_core.p2_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_ROFRAG: coverpoint { hqm_dir_pipe_core.p4_rofrag_ctrl.hold & hqm_dir_pipe_core.p3_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_ROFRAG: coverpoint { hqm_dir_pipe_core.p5_rofrag_ctrl.hold & hqm_dir_pipe_core.p4_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_ROFRAG: coverpoint { hqm_dir_pipe_core.p6_rofrag_ctrl.hold & hqm_dir_pipe_core.p5_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_ROFRAG: coverpoint { hqm_dir_pipe_core.p7_rofrag_ctrl.hold & hqm_dir_pipe_core.p6_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_ROFRAG: coverpoint { hqm_dir_pipe_core.p8_rofrag_ctrl.hold & hqm_dir_pipe_core.p7_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_ROFRAG: coverpoint { hqm_dir_pipe_core.p9_rofrag_ctrl.hold & hqm_dir_pipe_core.p8_rofrag_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_ROFRAG: cross WCP_P00_ROFRAG,WCP_P01_ROFRAG,WCP_P02_ROFRAG,WCP_P03_ROFRAG,WCP_P04_ROFRAG,WCP_P05_ROFRAG,WCP_P06_ROFRAG,WCP_P07_ROFRAG,WCP_P08_ROFRAG,WCP_P09_ROFRAG ;
//WCX_HXX_ROFRAG: cross WCP_H00_ROFRAG,WCP_H01_ROFRAG,WCP_H02_ROFRAG,WCP_H03_ROFRAG,WCP_H04_ROFRAG,WCP_H05_ROFRAG,WCP_H06_ROFRAG,WCP_H07_ROFRAG,WCP_H08_ROFRAG,WCP_H09_ROFRAG ;
//WCX_PHXX_ROFRAG: cross WCP_PH00_ROFRAG,WCP_PH01_ROFRAG,WCP_PH02_ROFRAG,WCP_PH03_ROFRAG,WCP_PH04_ROFRAG,WCP_PH05_ROFRAG,WCP_PH06_ROFRAG,WCP_PH07_ROFRAG,WCP_PH08_ROFRAG,WCP_PH09_ROFRAG ;

  WCP_P00_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P01_REPLAY: coverpoint { hqm_dir_pipe_core.p1_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P02_REPLAY: coverpoint { hqm_dir_pipe_core.p2_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P03_REPLAY: coverpoint { hqm_dir_pipe_core.p3_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P04_REPLAY: coverpoint { hqm_dir_pipe_core.p4_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P05_REPLAY: coverpoint { hqm_dir_pipe_core.p5_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P06_REPLAY: coverpoint { hqm_dir_pipe_core.p6_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P07_REPLAY: coverpoint { hqm_dir_pipe_core.p7_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P08_REPLAY: coverpoint { hqm_dir_pipe_core.p8_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P09_REPLAY: coverpoint { hqm_dir_pipe_core.p9_replay_data_f.cmd } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_H00_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_REPLAY: coverpoint { hqm_dir_pipe_core.p1_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_REPLAY: coverpoint { hqm_dir_pipe_core.p2_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_REPLAY: coverpoint { hqm_dir_pipe_core.p3_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_REPLAY: coverpoint { hqm_dir_pipe_core.p4_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_REPLAY: coverpoint { hqm_dir_pipe_core.p5_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_REPLAY: coverpoint { hqm_dir_pipe_core.p6_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_REPLAY: coverpoint { hqm_dir_pipe_core.p7_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_REPLAY: coverpoint { hqm_dir_pipe_core.p8_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_REPLAY: coverpoint { hqm_dir_pipe_core.p9_replay_ctrl.hold } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_ctrl.hold & (~hqm_dir_pipe_core.fifo_rop_dp_enq_ro_empty | ~hqm_dir_pipe_core.fifo_lsp_dp_sch_rorply_empty ) } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_REPLAY: coverpoint { hqm_dir_pipe_core.p1_replay_ctrl.hold & hqm_dir_pipe_core.p0_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_REPLAY: coverpoint { hqm_dir_pipe_core.p2_replay_ctrl.hold & hqm_dir_pipe_core.p1_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_REPLAY: coverpoint { hqm_dir_pipe_core.p3_replay_ctrl.hold & hqm_dir_pipe_core.p2_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_REPLAY: coverpoint { hqm_dir_pipe_core.p4_replay_ctrl.hold & hqm_dir_pipe_core.p3_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_REPLAY: coverpoint { hqm_dir_pipe_core.p5_replay_ctrl.hold & hqm_dir_pipe_core.p4_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_REPLAY: coverpoint { hqm_dir_pipe_core.p6_replay_ctrl.hold & hqm_dir_pipe_core.p5_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_REPLAY: coverpoint { hqm_dir_pipe_core.p7_replay_ctrl.hold & hqm_dir_pipe_core.p6_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_REPLAY: coverpoint { hqm_dir_pipe_core.p8_replay_ctrl.hold & hqm_dir_pipe_core.p7_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_REPLAY: coverpoint { hqm_dir_pipe_core.p9_replay_ctrl.hold & hqm_dir_pipe_core.p8_replay_v_f } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_REPLAY: cross WCP_P00_REPLAY,WCP_P01_REPLAY,WCP_P02_REPLAY,WCP_P03_REPLAY,WCP_P04_REPLAY,WCP_P05_REPLAY,WCP_P06_REPLAY,WCP_P07_REPLAY,WCP_P08_REPLAY,WCP_P09_REPLAY ;
//WCX_HXX_REPLAY: cross WCP_H00_REPLAY,WCP_H01_REPLAY,WCP_H02_REPLAY,WCP_H03_REPLAY,WCP_H04_REPLAY,WCP_H05_REPLAY,WCP_H06_REPLAY,WCP_H07_REPLAY,WCP_H08_REPLAY,WCP_H09_REPLAY ;

  WCP_H00_DIR_STALL: coverpoint { hqm_dir_pipe_core.dir_stall_f [ 0 ] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_H00_ORDERED_STALL: coverpoint { hqm_dir_pipe_core.ordered_stall_f [ 0 ] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;

  //CONTENTION
  WCP_cfg_waiting_0: coverpoint { (|hqm_dir_pipe_core.cfg_pipe_health_valid_00_f) & hqm_dir_pipe_core.cfg_unit_idle_f.cfg_busy } iff (hqm_dir_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
/*
  WCP_vf_waiting_0: coverpoint { (|hqm_dir_pipe_core.cfg_pipe_health_valid_00_f) & hqm_dir_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_dir_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_1: coverpoint { hqm_dir_pipe_core.cfg_unit_idle_f.cfg_busy & hqm_dir_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_dir_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_2: coverpoint { hqm_dir_pipe_core.cfg_unit_idle_f.cfg_active & hqm_dir_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_dir_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
*/

  //ARB
  WCP_arb_dir_reqs: coverpoint { hqm_dir_pipe_core.arb_dir_reqs } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_ro_reqs: coverpoint { hqm_dir_pipe_core.arb_ro_reqs } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL7 = { 7 } ; }
  // update for 4 qprio bins
  WCP_arb_dir_cnt_reqs: coverpoint { hqm_dir_pipe_core.arb_dir_cnt_reqs [ 3 : 0 ] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_replay_cnt_reqs: coverpoint { hqm_dir_pipe_core.arb_replay_cnt_reqs [ 3 : 0 ] } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_nxthp_reqs: coverpoint { hqm_dir_pipe_core.arb_nxthp_reqs } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;

  //FIFO
  WCP_fifo_rop_dp_enq_dir: coverpoint { hqm_dir_pipe_core.fifo_rop_dp_enq_dir_afull , hqm_dir_pipe_core.fifo_rop_dp_enq_dir_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_rop_dp_enq_ro: coverpoint { hqm_dir_pipe_core.fifo_rop_dp_enq_ro_afull , hqm_dir_pipe_core.fifo_rop_dp_enq_ro_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_lsp_dp_sch_dir: coverpoint { hqm_dir_pipe_core.fifo_lsp_dp_sch_dir_afull , hqm_dir_pipe_core.fifo_lsp_dp_sch_dir_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_lsp_dp_sch_rorply: coverpoint { hqm_dir_pipe_core.fifo_lsp_dp_sch_rorply_afull , hqm_dir_pipe_core.fifo_lsp_dp_sch_rorply_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_dp_dqed: coverpoint { hqm_dir_pipe_core.fifo_dp_dqed_afull , hqm_dir_pipe_core.fifo_dp_dqed_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_dp_lsp_enq_dir: coverpoint { hqm_dir_pipe_core.fifo_dp_lsp_enq_dir_afull , hqm_dir_pipe_core.fifo_dp_lsp_enq_dir_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_dp_lsp_enq_rorply: coverpoint { hqm_dir_pipe_core.fifo_dp_lsp_enq_rorply_afull , hqm_dir_pipe_core.fifo_dp_lsp_enq_rorply_empty } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
//WCX_fifo: cross WCP_fifo_rop_dp_enq_dir,WCP_fifo_rop_dp_enq_ro,WCP_fifo_lsp_dp_sch_dir,WCP_fifo_lsp_dp_sch_rorply,WCP_fifo_dp_dqed,WCP_fifo_dp_lsp_enq_dir,WCP_fifo_dp_lsp_enq_rorply ;

  //IF
  WCP_rop_dp_enq_ready: coverpoint { hqm_dir_pipe_core.rop_dp_enq_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_lsp_dp_sch_dir_ready: coverpoint { hqm_dir_pipe_core.lsp_dp_sch_dir_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_lsp_dp_sch_rorply_ready: coverpoint { hqm_dir_pipe_core.lsp_dp_sch_rorply_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_dp_lsp_enq_dir_ready: coverpoint { hqm_dir_pipe_core.dp_lsp_enq_dir_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_dp_lsp_enq_rorply_ready: coverpoint { hqm_dir_pipe_core.dp_lsp_enq_rorply_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;
  WCP_dp_dqed_ready: coverpoint { hqm_dir_pipe_core.dp_dqed_ready } iff (hqm_dir_pipe_core.hqm_gated_rst_n) ;

  //USAGE
  WCP_cq_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_data_f.cq } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:95] }; ignore_bins invalid_cq = { [96:$]}; }
  WCP_qid_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_data_f.qid } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:95] }; ignore_bins invalid_qid = { [96:$] }; }
  WCP_qidix_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_data_f.qidix } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qidix = { 0 }; ignore_bins invalid_qidix = { [1:$]}; }
  WCP_qpri_DIR: coverpoint { hqm_dir_pipe_core.p0_dir_data_f.qpri } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qpri = { [0:3] }; ignore_bins invalid_qpri = { [4:$]}; }

  WCP_cq_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_data_f.cq } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [63:$] }; }
  WCP_qid_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_data_f.qid } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$]}; }
  WCP_qidix_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_data_f.qidix } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_ROFRAG: coverpoint { hqm_dir_pipe_core.p0_rofrag_data_f.qpri } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qpri = { [0:3] }; ignore_bins invalid_qpri = { [4:$]}; }

  WCP_cq_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_data_f.cq } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [63:$] }; }
  WCP_qid_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_data_f.qid } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$]} ; }
  WCP_qidix_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_data_f.qidix } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_REPLAY: coverpoint { hqm_dir_pipe_core.p0_replay_data_f.qpri } iff (hqm_dir_pipe_core.hqm_gated_rst_n) { bins valid_qpri = { [0:3] }; ignore_bins invalid_qpri = { [4:$]}; }

endgroup
COVERGROUP u_COVERGROUP = new();
`endif
endmodule
bind hqm_dir_pipe_core hqm_dir_pipe_cover i_hqm_dir_pipe_cover();
`endif
