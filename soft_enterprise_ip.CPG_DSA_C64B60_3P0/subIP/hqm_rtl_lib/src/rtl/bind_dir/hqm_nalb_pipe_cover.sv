`ifdef INTEL_INST_ON
module hqm_nalb_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge hqm_nalb_pipe_core.hqm_gated_clk);

  WCP_ENQNOSTALL_00: coverpoint { ( hqm_nalb_pipe_core.p6_nalb_v_nxt
                                  & ( hqm_nalb_pipe_core.p6_nalb_data_nxt.cmd == hqm_nalb_pipe_core.HQM_NALB_CMD_ENQ )
                                  & ( ( ( hqm_nalb_pipe_core.p7_nalb_v_nxt & ( hqm_nalb_pipe_core.p7_nalb_data_nxt.qid == hqm_nalb_pipe_core.p6_nalb_data_nxt.qid ) ) & ( hqm_nalb_pipe_core.p7_nalb_v_nxt & ( hqm_nalb_pipe_core.p7_nalb_data_nxt.qpri == hqm_nalb_pipe_core.p6_nalb_data_nxt.qpri ) ) )
                                    | ( ( hqm_nalb_pipe_core.p8_nalb_v_nxt & ( hqm_nalb_pipe_core.p8_nalb_data_nxt.qid == hqm_nalb_pipe_core.p6_nalb_data_nxt.qid ) ) & ( hqm_nalb_pipe_core.p8_nalb_v_nxt & ( hqm_nalb_pipe_core.p8_nalb_data_nxt.qpri == hqm_nalb_pipe_core.p6_nalb_data_nxt.qpri ) ) )
                                    )
                                  ) } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;

  //Feature
  WCP_FEATURE000_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[0] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE001_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[1] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE002_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[2] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE003_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[3] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE004_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[4] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE005_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[5] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE006_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[6] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE007_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[7] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE008_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[8] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE016_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[16] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE017_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[17] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE018_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[18] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE019_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[19] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE020_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[20] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE021_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[21] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE022_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[22] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE023_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[23] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE024_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[24] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE025_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[25] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE026_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[26] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE027_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[27] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE028_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[28] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE029_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[29] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE030_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[30] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE031_LL: coverpoint { hqm_nalb_pipe_core.cfg_control9_nxt[31] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;

  WCP_FEATURE100_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[0] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE101_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[1] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE102_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[2] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE103_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[3] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE104_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[4] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE105_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[5] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE106_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[6] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE107_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[7] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE108_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[8] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE116_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[16] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE117_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[17] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE118_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[18] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE119_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[19] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE120_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[20] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE121_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[21] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE122_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[22] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE123_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[23] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE124_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[24] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE125_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[25] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE126_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[26] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE127_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[27] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE128_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[28] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE129_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[29] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE130_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[30] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_FEATURE131_LL: coverpoint { hqm_nalb_pipe_core.cfg_control10_nxt[31] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;

  //Pipeline
  WCP_P00_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P01_NALB: coverpoint { hqm_nalb_pipe_core.p1_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P02_NALB: coverpoint { hqm_nalb_pipe_core.p2_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P03_NALB: coverpoint { hqm_nalb_pipe_core.p3_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P04_NALB: coverpoint { hqm_nalb_pipe_core.p4_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P05_NALB: coverpoint { hqm_nalb_pipe_core.p5_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P06_NALB: coverpoint { hqm_nalb_pipe_core.p6_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P07_NALB: coverpoint { hqm_nalb_pipe_core.p7_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P08_NALB: coverpoint { hqm_nalb_pipe_core.p8_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P09_NALB: coverpoint { hqm_nalb_pipe_core.p9_nalb_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }

  WCP_H00_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_NALB: coverpoint { hqm_nalb_pipe_core.p1_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_NALB: coverpoint { hqm_nalb_pipe_core.p2_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_NALB: coverpoint { hqm_nalb_pipe_core.p3_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_NALB: coverpoint { hqm_nalb_pipe_core.p4_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_NALB: coverpoint { hqm_nalb_pipe_core.p5_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_NALB: coverpoint { hqm_nalb_pipe_core.p6_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_NALB: coverpoint { hqm_nalb_pipe_core.p7_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_NALB: coverpoint { hqm_nalb_pipe_core.p8_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_NALB: coverpoint { hqm_nalb_pipe_core.p9_nalb_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_ctrl.hold & (~hqm_nalb_pipe_core.fifo_rop_nalb_enq_nalb_empty | ~hqm_nalb_pipe_core.fifo_lsp_nalb_sch_unoord_empty ) } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_NALB: coverpoint { hqm_nalb_pipe_core.p1_nalb_ctrl.hold & hqm_nalb_pipe_core.p0_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_NALB: coverpoint { hqm_nalb_pipe_core.p2_nalb_ctrl.hold & hqm_nalb_pipe_core.p1_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_NALB: coverpoint { hqm_nalb_pipe_core.p3_nalb_ctrl.hold & hqm_nalb_pipe_core.p2_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_NALB: coverpoint { hqm_nalb_pipe_core.p4_nalb_ctrl.hold & hqm_nalb_pipe_core.p3_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_NALB: coverpoint { hqm_nalb_pipe_core.p5_nalb_ctrl.hold & hqm_nalb_pipe_core.p4_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_NALB: coverpoint { hqm_nalb_pipe_core.p6_nalb_ctrl.hold & hqm_nalb_pipe_core.p5_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_NALB: coverpoint { hqm_nalb_pipe_core.p7_nalb_ctrl.hold & hqm_nalb_pipe_core.p6_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_NALB: coverpoint { hqm_nalb_pipe_core.p8_nalb_ctrl.hold & hqm_nalb_pipe_core.p7_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_NALB: coverpoint { hqm_nalb_pipe_core.p9_nalb_ctrl.hold & hqm_nalb_pipe_core.p8_nalb_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_NALB: cross WCP_P00_NALB,WCP_P01_NALB,WCP_P02_NALB,WCP_P03_NALB,WCP_P04_NALB,WCP_P05_NALB,WCP_P06_NALB,WCP_P07_NALB,WCP_P08_NALB,WCP_P09_NALB ;
//WCX_HXX_NALB: cross WCP_H00_NALB,WCP_H01_NALB,WCP_H02_NALB,WCP_H03_NALB,WCP_H04_NALB,WCP_H05_NALB,WCP_H06_NALB,WCP_H07_NALB,WCP_H08_NALB,WCP_H09_NALB ;
//WCX_PHXX_NALB: cross WCP_PH00_NALB,WCP_PH01_NALB,WCP_PH02_NALB,WCP_PH03_NALB,WCP_PH04_NALB,WCP_PH05_NALB,WCP_PH06_NALB,WCP_PH07_NALB,WCP_PH08_NALB,WCP_PH09_NALB ;

  WCP_P00_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P01_ROFRAG: coverpoint { hqm_nalb_pipe_core.p1_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P02_ROFRAG: coverpoint { hqm_nalb_pipe_core.p2_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P03_ROFRAG: coverpoint { hqm_nalb_pipe_core.p3_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P04_ROFRAG: coverpoint { hqm_nalb_pipe_core.p4_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P05_ROFRAG: coverpoint { hqm_nalb_pipe_core.p5_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P06_ROFRAG: coverpoint { hqm_nalb_pipe_core.p6_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P07_ROFRAG: coverpoint { hqm_nalb_pipe_core.p7_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P08_ROFRAG: coverpoint { hqm_nalb_pipe_core.p8_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }
  WCP_P09_ROFRAG: coverpoint { hqm_nalb_pipe_core.p9_rofrag_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL2 = { 2 } ; }

  WCP_H00_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_ROFRAG: coverpoint { hqm_nalb_pipe_core.p1_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_ROFRAG: coverpoint { hqm_nalb_pipe_core.p2_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_ROFRAG: coverpoint { hqm_nalb_pipe_core.p3_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_ROFRAG: coverpoint { hqm_nalb_pipe_core.p4_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_ROFRAG: coverpoint { hqm_nalb_pipe_core.p5_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_ROFRAG: coverpoint { hqm_nalb_pipe_core.p6_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_ROFRAG: coverpoint { hqm_nalb_pipe_core.p7_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; } 
  WCP_H08_ROFRAG: coverpoint { hqm_nalb_pipe_core.p8_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_ROFRAG: coverpoint { hqm_nalb_pipe_core.p9_rofrag_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_ctrl.hold & (~hqm_nalb_pipe_core.fifo_rop_nalb_enq_ro_empty | ~hqm_nalb_pipe_core.fifo_lsp_nalb_sch_rorply_empty ) } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_ROFRAG: coverpoint { hqm_nalb_pipe_core.p1_rofrag_ctrl.hold & hqm_nalb_pipe_core.p0_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_ROFRAG: coverpoint { hqm_nalb_pipe_core.p2_rofrag_ctrl.hold & hqm_nalb_pipe_core.p1_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_ROFRAG: coverpoint { hqm_nalb_pipe_core.p3_rofrag_ctrl.hold & hqm_nalb_pipe_core.p2_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_ROFRAG: coverpoint { hqm_nalb_pipe_core.p4_rofrag_ctrl.hold & hqm_nalb_pipe_core.p3_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_ROFRAG: coverpoint { hqm_nalb_pipe_core.p5_rofrag_ctrl.hold & hqm_nalb_pipe_core.p4_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_ROFRAG: coverpoint { hqm_nalb_pipe_core.p6_rofrag_ctrl.hold & hqm_nalb_pipe_core.p5_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_ROFRAG: coverpoint { hqm_nalb_pipe_core.p7_rofrag_ctrl.hold & hqm_nalb_pipe_core.p6_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_ROFRAG: coverpoint { hqm_nalb_pipe_core.p8_rofrag_ctrl.hold & hqm_nalb_pipe_core.p7_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_ROFRAG: coverpoint { hqm_nalb_pipe_core.p9_rofrag_ctrl.hold & hqm_nalb_pipe_core.p8_rofrag_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_ROFRAG: cross WCP_P00_ROFRAG,WCP_P01_ROFRAG,WCP_P02_ROFRAG,WCP_P03_ROFRAG,WCP_P04_ROFRAG,WCP_P05_ROFRAG,WCP_P06_ROFRAG,WCP_P07_ROFRAG,WCP_P08_ROFRAG,WCP_P09_ROFRAG ;
//WCX_HXX_ROFRAG: cross WCP_H00_ROFRAG,WCP_H01_ROFRAG,WCP_H02_ROFRAG,WCP_H03_ROFRAG,WCP_H04_ROFRAG,WCP_H05_ROFRAG,WCP_H06_ROFRAG,WCP_H07_ROFRAG,WCP_H08_ROFRAG,WCP_H09_ROFRAG ;
//WCX_PHXX_ROFRAG: cross WCP_PH00_ROFRAG,WCP_PH01_ROFRAG,WCP_PH02_ROFRAG,WCP_PH03_ROFRAG,WCP_PH04_ROFRAG,WCP_PH05_ROFRAG,WCP_PH06_ROFRAG,WCP_PH07_ROFRAG,WCP_PH08_ROFRAG,WCP_PH09_ROFRAG ;

  WCP_P00_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P01_REPLAY: coverpoint { hqm_nalb_pipe_core.p1_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P02_REPLAY: coverpoint { hqm_nalb_pipe_core.p2_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P03_REPLAY: coverpoint { hqm_nalb_pipe_core.p3_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P04_REPLAY: coverpoint { hqm_nalb_pipe_core.p4_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P05_REPLAY: coverpoint { hqm_nalb_pipe_core.p5_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P06_REPLAY: coverpoint { hqm_nalb_pipe_core.p6_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P07_REPLAY: coverpoint { hqm_nalb_pipe_core.p7_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P08_REPLAY: coverpoint { hqm_nalb_pipe_core.p8_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_P09_REPLAY: coverpoint { hqm_nalb_pipe_core.p9_replay_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_H00_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_REPLAY: coverpoint { hqm_nalb_pipe_core.p1_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_REPLAY: coverpoint { hqm_nalb_pipe_core.p2_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_REPLAY: coverpoint { hqm_nalb_pipe_core.p3_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_REPLAY: coverpoint { hqm_nalb_pipe_core.p4_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_REPLAY: coverpoint { hqm_nalb_pipe_core.p5_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_REPLAY: coverpoint { hqm_nalb_pipe_core.p6_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_REPLAY: coverpoint { hqm_nalb_pipe_core.p7_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_REPLAY: coverpoint { hqm_nalb_pipe_core.p8_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_REPLAY: coverpoint { hqm_nalb_pipe_core.p9_replay_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_ctrl.hold & (~hqm_nalb_pipe_core.fifo_rop_nalb_enq_ro_empty | ~hqm_nalb_pipe_core.fifo_lsp_nalb_sch_rorply_empty ) } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_REPLAY: coverpoint { hqm_nalb_pipe_core.p1_replay_ctrl.hold & hqm_nalb_pipe_core.p0_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_REPLAY: coverpoint { hqm_nalb_pipe_core.p2_replay_ctrl.hold & hqm_nalb_pipe_core.p1_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_REPLAY: coverpoint { hqm_nalb_pipe_core.p3_replay_ctrl.hold & hqm_nalb_pipe_core.p2_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_REPLAY: coverpoint { hqm_nalb_pipe_core.p4_replay_ctrl.hold & hqm_nalb_pipe_core.p3_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_REPLAY: coverpoint { hqm_nalb_pipe_core.p5_replay_ctrl.hold & hqm_nalb_pipe_core.p4_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_REPLAY: coverpoint { hqm_nalb_pipe_core.p6_replay_ctrl.hold & hqm_nalb_pipe_core.p5_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_REPLAY: coverpoint { hqm_nalb_pipe_core.p7_replay_ctrl.hold & hqm_nalb_pipe_core.p6_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_REPLAY: coverpoint { hqm_nalb_pipe_core.p8_replay_ctrl.hold & hqm_nalb_pipe_core.p7_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_REPLAY: coverpoint { hqm_nalb_pipe_core.p9_replay_ctrl.hold & hqm_nalb_pipe_core.p8_replay_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_REPLAY: cross WCP_P00_REPLAY,WCP_P01_REPLAY,WCP_P02_REPLAY,WCP_P03_REPLAY,WCP_P04_REPLAY,WCP_P05_REPLAY,WCP_P06_REPLAY,WCP_P07_REPLAY,WCP_P08_REPLAY,WCP_P09_REPLAY ;
//WCX_HXX_REPLAY: cross WCP_H00_REPLAY,WCP_H01_REPLAY,WCP_H02_REPLAY,WCP_H03_REPLAY,WCP_H04_REPLAY,WCP_H05_REPLAY,WCP_H06_REPLAY,WCP_H07_REPLAY,WCP_H08_REPLAY,WCP_H09_REPLAY ;
//WCX_PHXX_REPLAY: cross WCP_PH00_REPLAY,WCP_PH01_REPLAY,WCP_PH02_REPLAY,WCP_PH03_REPLAY,WCP_PH04_REPLAY,WCP_PH05_REPLAY,WCP_PH06_REPLAY,WCP_PH07_REPLAY,WCP_PH08_REPLAY,WCP_PH09_REPLAY ;

  WCP_P00_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P01_ATQ: coverpoint { hqm_nalb_pipe_core.p1_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P02_ATQ: coverpoint { hqm_nalb_pipe_core.p2_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P03_ATQ: coverpoint { hqm_nalb_pipe_core.p3_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P04_ATQ: coverpoint { hqm_nalb_pipe_core.p4_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P05_ATQ: coverpoint { hqm_nalb_pipe_core.p5_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P06_ATQ: coverpoint { hqm_nalb_pipe_core.p6_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P07_ATQ: coverpoint { hqm_nalb_pipe_core.p7_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P08_ATQ: coverpoint { hqm_nalb_pipe_core.p8_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }
  WCP_P09_ATQ: coverpoint { hqm_nalb_pipe_core.p9_atq_data_f.cmd } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL3 = { 3 } ; ignore_bins VAL0 = { 0 } ; }

  WCP_H00_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H01_ATQ: coverpoint { hqm_nalb_pipe_core.p1_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H02_ATQ: coverpoint { hqm_nalb_pipe_core.p2_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H03_ATQ: coverpoint { hqm_nalb_pipe_core.p3_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H04_ATQ: coverpoint { hqm_nalb_pipe_core.p4_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H05_ATQ: coverpoint { hqm_nalb_pipe_core.p5_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H06_ATQ: coverpoint { hqm_nalb_pipe_core.p6_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H07_ATQ: coverpoint { hqm_nalb_pipe_core.p7_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H08_ATQ: coverpoint { hqm_nalb_pipe_core.p8_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_H09_ATQ: coverpoint { hqm_nalb_pipe_core.p9_atq_ctrl.hold } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

  WCP_PH00_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_ctrl.hold & (~hqm_nalb_pipe_core.fifo_rop_nalb_enq_nalb_empty | ~hqm_nalb_pipe_core.fifo_lsp_nalb_sch_atq_empty) } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH01_ATQ: coverpoint { hqm_nalb_pipe_core.p1_atq_ctrl.hold & hqm_nalb_pipe_core.p0_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH02_ATQ: coverpoint { hqm_nalb_pipe_core.p2_atq_ctrl.hold & hqm_nalb_pipe_core.p1_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH03_ATQ: coverpoint { hqm_nalb_pipe_core.p3_atq_ctrl.hold & hqm_nalb_pipe_core.p2_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH04_ATQ: coverpoint { hqm_nalb_pipe_core.p4_atq_ctrl.hold & hqm_nalb_pipe_core.p3_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH05_ATQ: coverpoint { hqm_nalb_pipe_core.p5_atq_ctrl.hold & hqm_nalb_pipe_core.p4_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH06_ATQ: coverpoint { hqm_nalb_pipe_core.p6_atq_ctrl.hold & hqm_nalb_pipe_core.p5_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_PH07_ATQ: coverpoint { hqm_nalb_pipe_core.p7_atq_ctrl.hold & hqm_nalb_pipe_core.p6_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH08_ATQ: coverpoint { hqm_nalb_pipe_core.p8_atq_ctrl.hold & hqm_nalb_pipe_core.p7_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }
  WCP_PH09_ATQ: coverpoint { hqm_nalb_pipe_core.p9_atq_ctrl.hold & hqm_nalb_pipe_core.p8_atq_v_f } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { ignore_bins VAL1 = { 1 } ; }

//WCX_PXX_ATQ: cross WCP_P00_ATQ,WCP_P01_ATQ,WCP_P02_ATQ,WCP_P03_ATQ,WCP_P04_ATQ,WCP_P05_ATQ,WCP_P06_ATQ,WCP_P07_ATQ,WCP_P08_ATQ,WCP_P09_ATQ ;
//WCX_HXX_ATQ: cross WCP_H00_ATQ,WCP_H01_ATQ,WCP_H02_ATQ,WCP_H03_ATQ,WCP_H04_ATQ,WCP_H05_ATQ,WCP_H06_ATQ,WCP_H07_ATQ,WCP_H08_ATQ,WCP_H09_ATQ ;
//WCX_PHXX_ATQ: cross WCP_PH00_ATQ,WCP_PH01_ATQ,WCP_PH02_ATQ,WCP_PH03_ATQ,WCP_PH04_ATQ,WCP_PH05_ATQ,WCP_PH06_ATQ,WCP_PH07_ATQ,WCP_PH08_ATQ,WCP_PH09_ATQ ;

  WCP_H00_NALB_STALL: coverpoint { hqm_nalb_pipe_core.nalb_stall_f [ 0 ] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H00_ATQ_STALL: coverpoint { hqm_nalb_pipe_core.atq_stall_f [ 0 ] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_H00_ORDERED_STALL: coverpoint { hqm_nalb_pipe_core.ordered_stall_f[ 0 ]  } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  

  //CONTENTION
  WCP_cfg_waiting_0: coverpoint { (|hqm_nalb_pipe_core.cfg_pipe_health_valid_00_f) & hqm_nalb_pipe_core.cfg_unit_idle_f.cfg_busy } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
/*
  WCP_vf_waiting_0: coverpoint { (|hqm_nalb_pipe_core.cfg_pipe_health_valid_00_f) & hqm_nalb_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_1: coverpoint { hqm_nalb_pipe_core.cfg_unit_idle_f.cfg_busy & hqm_nalb_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
  WCP_vf_waiting_2: coverpoint { hqm_nalb_pipe_core.cfg_unit_idle_f.cfg_active & hqm_nalb_pipe_core.cfg_vf_reset_f.wait_for_idle } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) {
  bins B0={0};
  bins HIT={1};
  }
*/

  //ARB
  WCP_arb_nalb_reqs: coverpoint { hqm_nalb_pipe_core.arb_nalb_reqs } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_atq_reqs: coverpoint { hqm_nalb_pipe_core.arb_atq_reqs } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_ro_reqs: coverpoint { hqm_nalb_pipe_core.arb_ro_reqs } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  // update for 4 qprio bins
  WCP_arb_nalb_cnt_reqs: coverpoint { hqm_nalb_pipe_core.arb_nalb_cnt_reqs [ 3 : 0 ] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_atq_cnt_reqs: coverpoint { hqm_nalb_pipe_core.arb_atq_cnt_reqs [ 3 : 0 ] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_replay_cnt_reqs: coverpoint { hqm_nalb_pipe_core.arb_replay_cnt_reqs [ 3 : 0 ] } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_arb_nxthp_reqs: coverpoint { hqm_nalb_pipe_core.arb_nxthp_reqs } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;

  //FIFO
  WCP_fifo_rop_nalb_enq_nalb: coverpoint { hqm_nalb_pipe_core.fifo_rop_nalb_enq_nalb_afull , hqm_nalb_pipe_core.fifo_rop_nalb_enq_nalb_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_rop_nalb_enq_ro: coverpoint { hqm_nalb_pipe_core.fifo_rop_nalb_enq_ro_afull , hqm_nalb_pipe_core.fifo_rop_nalb_enq_ro_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_lsp_nalb_sch_unoord: coverpoint { hqm_nalb_pipe_core.fifo_lsp_nalb_sch_unoord_afull , hqm_nalb_pipe_core.fifo_lsp_nalb_sch_unoord_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_lsp_nalb_sch_rorply: coverpoint { hqm_nalb_pipe_core.fifo_lsp_nalb_sch_rorply_afull , hqm_nalb_pipe_core.fifo_lsp_nalb_sch_rorply_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_lsp_nalb_sch_atq: coverpoint { hqm_nalb_pipe_core.fifo_lsp_nalb_sch_atq_afull , hqm_nalb_pipe_core.fifo_lsp_nalb_sch_atq_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_nalb_qed: coverpoint { hqm_nalb_pipe_core.fifo_nalb_qed_afull , hqm_nalb_pipe_core.fifo_nalb_qed_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_nalb_lsp_enq_lb: coverpoint { hqm_nalb_pipe_core.fifo_nalb_lsp_enq_lb_afull , hqm_nalb_pipe_core.fifo_nalb_lsp_enq_lb_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
  WCP_fifo_nalb_lsp_enq_rorply: coverpoint { hqm_nalb_pipe_core.fifo_nalb_lsp_enq_rorply_afull , hqm_nalb_pipe_core.fifo_nalb_lsp_enq_rorply_empty } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; }
//WCX_fifo: cross WCP_fifo_rop_nalb_enq_nalb,WCP_fifo_rop_nalb_enq_ro,WCP_fifo_lsp_nalb_sch_unoord,WCP_fifo_lsp_nalb_sch_rorply,WCP_fifo_lsp_nalb_sch_atq,WCP_fifo_nalb_qed,WCP_fifo_nalb_lsp_enq_lb,WCP_fifo_nalb_lsp_enq_rorply ;

  //IF
  WCP_rop_nalb_enq_ready: coverpoint { hqm_nalb_pipe_core.rop_nalb_enq_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_lsp_nalb_sch_unoord_ready: coverpoint { hqm_nalb_pipe_core.lsp_nalb_sch_unoord_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_lsp_nalb_sch_rorply_ready: coverpoint { hqm_nalb_pipe_core.lsp_nalb_sch_rorply_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_lsp_nalb_sch_atq_ready: coverpoint { hqm_nalb_pipe_core.lsp_nalb_sch_atq_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_nalb_lsp_enq_lb_ready: coverpoint { hqm_nalb_pipe_core.nalb_lsp_enq_lb_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_nalb_lsp_enq_rorply_ready: coverpoint { hqm_nalb_pipe_core.nalb_lsp_enq_rorply_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;
  WCP_nalb_qed_ready: coverpoint { hqm_nalb_pipe_core.nalb_qed_ready } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) ;

  //USAGE
  WCP_cq_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_data_f.cq } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [64:$] }; }
  WCP_qid_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_data_f.qid } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$] }; }
  WCP_qidix_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_data_f.qidix } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_NALB: coverpoint { hqm_nalb_pipe_core.p0_nalb_data_f.qpri } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_prir = { [0:3] }; ignore_bins invalid_qpri = { [4:$] }; }

  WCP_cq_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_data_f.cq } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [64:$] }; }
  WCP_qid_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_data_f.qid } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$] }; }
  WCP_qidix_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_data_f.qidix } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_ROFRAG: coverpoint { hqm_nalb_pipe_core.p0_rofrag_data_f.qpri } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_prir = { [0:3] }; ignore_bins invalid_qpri = { [4:$] }; }

  WCP_cq_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_data_f.cq } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [64:$] }; }
  WCP_qid_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_data_f.qid } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$] }; }
  WCP_qidix_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_data_f.qidix } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_REPLAY: coverpoint { hqm_nalb_pipe_core.p0_replay_data_f.qpri } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qpri = { [0:3] }; ignore_bins invalid_qpri = { [4:$] }; }

  WCP_cq_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_data_f.cq } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_cq = { [0:63] }; ignore_bins invalid_cq = { [64:$] }; }
  WCP_qid_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_data_f.qid } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qid = { [0:31] }; ignore_bins invalid_qid = { [32:$] }; }
  // lsp does not provide qidix
//WCP_qidix_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_data_f.qidix } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { option.auto_bin_max=8; }
  WCP_qpri_ATQ: coverpoint { hqm_nalb_pipe_core.p0_atq_data_f.qpri } iff (hqm_nalb_pipe_core.hqm_gated_rst_n) { bins valid_qpri = { [0:3] }; ignore_bins invalid_qpri = { [4:$] }; }

endgroup
COVERGROUP u_COVERGROUP = new();
`endif
endmodule
bind hqm_nalb_pipe_core hqm_nalb_pipe_cover i_hqm_nalb_pipe_cover();
`endif
