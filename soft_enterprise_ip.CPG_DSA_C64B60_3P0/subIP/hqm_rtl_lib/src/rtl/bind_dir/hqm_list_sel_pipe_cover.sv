`ifdef INTEL_INST_ON
module hqm_list_sel_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON

localparam      HQM_LSP_LBA_ARB_STATE_SCHED             = 3'b010 ;

logic clk ;
logic rst_n ;

logic [HQM_NUM_DIR_QID-1:0]                     cov_p2_direnq_enq_cnt_qid_vec ;
logic [HQM_NUM_DIR_CQ-1:0]                      cov_p2_direnq_tok_cnt_cq_vec ;
logic [HQM_NUM_LB_QID-1:0]                      cov_p2_atq_enq_cnt_qid_vec ;
logic [HQM_NUM_LB_QID-1:0]                      cov_p2_atq_aqed_act_cnt_qid_vec ;
logic [HQM_NUM_DIR_QID-1:0]                     cov_p2_dirrpl_enq_cnt_qid_vec ;
logic [HQM_NUM_LB_QID-1:0]                      cov_p2_lbrpl_enq_cnt_qid_vec ;

assign clk      = hqm_list_sel_pipe_core.hqm_gated_clk ;
assign rst_n    = hqm_list_sel_pipe_core.hqm_gated_rst_n ;

always_comb begin
  cov_p2_direnq_enq_cnt_qid_vec = { HQM_NUM_DIR_QID { 1'b0 } } ;
  cov_p2_direnq_enq_cnt_qid_vec [ hqm_list_sel_pipe_core.p2_direnq_enq_cnt_rmw_pipe_f.qid[HQM_NUM_DIR_QIDB2-1:0] ]      = 1'b1 ;
  cov_p2_direnq_tok_cnt_cq_vec  = { HQM_NUM_DIR_CQ { 1'b0 } } ;
  cov_p2_direnq_tok_cnt_cq_vec [ hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.cq[HQM_NUM_DIR_CQB2-1:0] ]         = 1'b1 ;
  cov_p2_atq_enq_cnt_qid_vec    = { HQM_NUM_LB_QID { 1'b0 } } ;
  cov_p2_atq_enq_cnt_qid_vec [ hqm_list_sel_pipe_core.p2_atq_enq_cnt_rmw_pipe_f.qid[HQM_NUM_LB_QIDB2-1:0] ]             = 1'b1 ;
  cov_p2_atq_aqed_act_cnt_qid_vec       = { HQM_NUM_LB_QID { 1'b0 } } ;
  cov_p2_atq_aqed_act_cnt_qid_vec [ hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_rmw_pipe_f.qid[HQM_NUM_LB_QIDB2-1:0] ]   = 1'b1 ;
  cov_p2_dirrpl_enq_cnt_qid_vec = { HQM_NUM_DIR_QID { 1'b0 } } ;
  cov_p2_dirrpl_enq_cnt_qid_vec [ hqm_list_sel_pipe_core.p2_dirrpl_enq_cnt_rmw_pipe_f.qid[HQM_NUM_DIR_QIDB2-1:0] ]      = 1'b1 ;
  cov_p2_lbrpl_enq_cnt_qid_vec = { HQM_NUM_LB_QID { 1'b0 } } ;
  cov_p2_lbrpl_enq_cnt_qid_vec [ hqm_list_sel_pipe_core.p2_lbrpl_enq_cnt_rmw_pipe_f.qid[HQM_NUM_LB_QIDB2-1:0] ]         = 1'b1 ;
end // always

covergroup COVERGROUP @(posedge clk);

//----------------------------------------------------------------------------------
// Hold conditions
  CP_HOLD_direnq_p3 : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_hold , hqm_list_sel_pipe_core.p4_direnq_sch_hold } iff
        (rst_n & hqm_list_sel_pipe_core.p3_direnq_arb_winner_v & ! hqm_list_sel_pipe_core.p3_direnq_fill_in_progress ) ;
  CP_HOLD_atq_p3 : coverpoint { hqm_list_sel_pipe_core.atq_sel_ap_fifo_hold , hqm_list_sel_pipe_core.p4_atq_sch_hold } iff (rst_n & hqm_list_sel_pipe_core.p3_atq_arb_winner_v ) ;
  CP_HOLD_lbrpl_p3 : coverpoint { hqm_list_sel_pipe_core.rpl_ldb_nalb_fifo_hold , hqm_list_sel_pipe_core.p4_lbrpl_sch_hold } iff (rst_n & hqm_list_sel_pipe_core.p3_lbrpl_arb_winner_v ) ;
  CP_HOLD_dirrpl_p3 : coverpoint { hqm_list_sel_pipe_core.rpl_dir_dp_fifo_hold , hqm_list_sel_pipe_core.p4_dirrpl_sch_hold } iff (rst_n & hqm_list_sel_pipe_core.p3_dirrpl_arb_winner_v ) ;
  // p4_from_p5_hold is always 0
  CP_HOLD_lba_p4 : coverpoint { hqm_list_sel_pipe_core.p4_lba_atm_sch_hold } iff (rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f ) ;
  CP_HOLD_lba_p3 : coverpoint { hqm_list_sel_pipe_core.p3_lba_ctrl_pipe.hold } iff (rst_n & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f ) ;
  CP_HOLD_lba_p2 : coverpoint { hqm_list_sel_pipe_core.p2_lba_ctrl_pipe.hold } iff (rst_n & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f ) ;
  CP_HOLD_lba_p1 : coverpoint { hqm_list_sel_pipe_core.p1_lba_ctrl_pipe.hold } iff (rst_n & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f ) ;
  CP_HOLD_lba_p0 : coverpoint { hqm_list_sel_pipe_core.p0_lba_ctrl_pipe.hold , hqm_list_sel_pipe_core.p0_lba_ctrl_pipe_sch_hold_cond } iff
        (rst_n & ( hqm_list_sel_pipe_core.p0_lba_sch_state_f == HQM_LSP_LBA_ARB_STATE_SCHED ) ) ;

  // Limited cross coverage, can only have hold if level below is holding.
  CP_HOLD_lba_p4_p3 : coverpoint { hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f } iff (rst_n & hqm_list_sel_pipe_core.p4_lba_atm_sch_hold ) ;
  CP_HOLD_lba_p3_p2 : coverpoint { hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f } iff (rst_n & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe.hold ) ;
  CP_HOLD_lba_p2_p1 : coverpoint { hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f } iff (rst_n & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe.hold ) ;
  CP_HOLD_lba_p1_p0 : coverpoint { hqm_list_sel_pipe_core.p0_lba_arb_winner_v }  iff (rst_n & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe.hold ) ;

//----------------------------------------------------------------------------------
// Pipeline commands / sharing
  CP_p0_direnq_cmds : coverpoint { hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.tok_v } iff (rst_n & hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe.en )
        { ignore_bins S_ET = { [5:7] } ; ignore_bins NONE = { 0 } ; }
  CP_p1_direnq_cmds : coverpoint { hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.tok_v } iff (rst_n & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe.en )
        { ignore_bins S_ET = { [5:7] } ; ignore_bins NONE = { 0 } ; }
  CP_p2_direnq_cmds : coverpoint { hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_v } iff (rst_n & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_v_f )
        { ignore_bins S_ET = { [5:7] } ; ignore_bins NONE = { 0 } ; }

  CX_px_direnq_cmds : cross  CP_p0_direnq_cmds , CP_p1_direnq_cmds , CP_p2_direnq_cmds  ;


  CP_p0_atq_cmds : coverpoint { hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.cmp_v } iff (rst_n & hqm_list_sel_pipe_core.p1_atq_ctrl_pipe.en )
        { ignore_bins S_EC = { [5:7] } ; ignore_bins NONE = { 0 } ; }
  CP_p1_atq_cmds : coverpoint { hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.cmp_v } iff (rst_n & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe.en )
        { ignore_bins S_EC = { [5:7] } ; ignore_bins NONE = { 0 } ; }
  CP_p2_atq_cmds : coverpoint { hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.cmp_v } iff (rst_n & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_v_f )
        { ignore_bins S_EC = { [5:7] } ; ignore_bins NONE = { 0 } ; }

  CX_px_atq_cmds : cross  CP_p0_atq_cmds , CP_p1_atq_cmds , CP_p2_atq_cmds ;


  // --------
  // No point in checking all combinations all the way down the pipe - if they occur at the top, they'll proceed all the way down to the bottom.
  CP_p2_lba_cmds : coverpoint { hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_v ,
                                hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cq_cmp_v ,
                                ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_cmp_v |
                                  hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_if_dec_v ) } iff
        (rst_n & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe.en )
        { ignore_bins NONE    = { 0 } ;
          ignore_bins E_QC    = { 9, 11, 13, 15 } ;
          ignore_bins S_ETC   = { [17:31] } ; }

  CP_p3_lba_cmds : coverpoint { hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v ,
                                hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.enq_v ,
                                hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_v ,
                                hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cq_cmp_v ,
                                ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_cmp_v |
                                  hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_if_dec_v ) } iff
        (rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe.en )
        { ignore_bins NONE    = { 0 } ;
          ignore_bins E_QC    = { 9, 11, 13, 15 } ;
          ignore_bins S_ETC   = { [17:31] } ; }

  CX_px_lba_cmds : cross  CP_p2_lba_cmds , CP_p3_lba_cmds
  {
        ignore_bins ill_b2b_sch = ( binsof ( CP_p2_lba_cmds )   intersect { 16 } &&
                                    binsof ( CP_p3_lba_cmds )   intersect { 16 } ) ;
  }

  //--------

  CP_p2_lba_cmp_cmds : coverpoint { hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_if_dec_v ,
                                    hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cq_cmp_v ,
                                    hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_cmp_v } iff
        (rst_n & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe.en )
        { ignore_bins NONE = { 0 , 5 , 7 } ; }

  CP_p3_lba_cmp_cmds : coverpoint { hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_if_dec_v ,
                                    hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cq_cmp_v ,
                                    hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_cmp_v } iff
        (rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe.en )
        { ignore_bins NONE = { 0 , 5 , 7 } ; }

  CX_px_lba_cmp_cmds : cross  CP_p2_lba_cmp_cmds , CP_p3_lba_cmp_cmds ;

//----------------------------------------------------------------------------------
// cfg contention

  // Config waiting until pipe idle
  CP_cfg_waiting_rd : coverpoint { ( | hqm_list_sel_pipe_core.unit_cfg_req_read )  & ! hqm_list_sel_pipe_core.cfg_req_ready } iff (rst_n) ;
  CP_cfg_waiting_wr : coverpoint { ( | hqm_list_sel_pipe_core.unit_cfg_req_write ) & ! hqm_list_sel_pipe_core.cfg_req_ready } iff (rst_n) ;

//----------------------------------------------------------------------------------
// Arbiter contention / usage
  CP_atq_input_arb_reqs : coverpoint { hqm_list_sel_pipe_core.atq_input_arb_reqs } iff (rst_n & hqm_list_sel_pipe_core.p0_atq_ctrl_pipe.en) { ignore_bins ill={0}; }
  CP_direnq_input_arb_reqs : coverpoint { hqm_list_sel_pipe_core.direnq_input_arb_reqs } iff (rst_n & hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe.en ) { ignore_bins ill={0}; }
  CP_lbrpl_input_arb_reqs : coverpoint { hqm_list_sel_pipe_core.lbrpl_input_arb_reqs } iff (rst_n & hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe.en ) { ignore_bins ill={0}; }
  CP_dirrpl_input_arb_reqs : coverpoint { hqm_list_sel_pipe_core.dirrpl_input_arb_reqs } iff (rst_n & hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe.en ) { ignore_bins ill={0}; }

  CP_lbi_qid_cmp_arb_reqs : coverpoint { hqm_list_sel_pipe_core.lbi_qid_cmp_arb_reqs } iff (rst_n & hqm_list_sel_pipe_core.lbi_qid_cmp_req_taken ) { ignore_bins ill={0}; }
  CP_lbi_ec_arb_reqs : coverpoint { hqm_list_sel_pipe_core.lbi_ec_arb_reqs } iff (rst_n & ( hqm_list_sel_pipe_core.enq_nalb_fifo_pop | hqm_list_sel_pipe_core.lbi_qid_cmp_req_taken ) ) { ignore_bins ill={0}; }
  CP_lbi_qid_cmp_req_taken : coverpoint { hqm_list_sel_pipe_core.lbi_qid_cmp_req_taken } iff (rst_n & hqm_list_sel_pipe_core.lbi_cq_cmp_req_taken ) { ignore_bins ill={0}; }

  // fill in progress and arb valid, with and without both types of backpressure
  CP_dir_fill_in_prog : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_hold , hqm_list_sel_pipe_core.p4_direnq_sch_hold } iff
        (rst_n & hqm_list_sel_pipe_core.p3_direnq_fill_in_progress & hqm_list_sel_pipe_core.p3_direnq_arb_winner_v ) ;

  // fill not in progress and arb valid, with and without DP FIFO backpressure
  CP_dir_not_fill_in_prog : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_hold , hqm_list_sel_pipe_core.p4_direnq_sch_hold } iff
        (rst_n & ! hqm_list_sel_pipe_core.p3_direnq_fill_in_progress & hqm_list_sel_pipe_core.p3_direnq_arb_winner_v ) ;

  // fill end condition and arb valid, with and without DP FIFO backpressure
  // If fill is ending, not possible to have p4_direnq_sch_hold; that would require p4=sch, which would require p3 sch req=1 on prior clock, which is
  // supressed by fill_in_progress.
  CP_dir_fill_ending : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_hold } iff
        (rst_n & hqm_list_sel_pipe_core.p3_direnq_fill_in_progress & ( hqm_list_sel_pipe_core.p3_direnq_rem_beats == 2'h1 ) & hqm_list_sel_pipe_core.p3_direnq_arb_winner_v ) ;

  CP_lba_sch_atm_arb_coll : coverpoint { hqm_list_sel_pipe_core.p3_lba_sch_atm_rlist_slist_collide } iff (rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe.en & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v ) ;

  CP_lba_sch_atm_nalb_arb_coll : coverpoint { hqm_list_sel_pipe_core.p4_lba_sch_arb_atm_nalb_collide_cond_nc } iff (rst_n & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe.en & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_v ) ;

  // Boosted priorities have a chance to take effect
  CP_lba_atm_arb_nalb_boosted : coverpoint { hqm_list_sel_pipe_core.p3_lba_sch_atm_arb_winner_boosted } iff
        ( rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe.en & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v & hqm_list_sel_pipe_core.p3_lba_sch_nalb_arb_winner_boosted &
          ( hqm_list_sel_pipe_core.p3_lba_sch_nalb_arb_winner_pri > hqm_list_sel_pipe_core.p3_lba_sch_atm_arb_winner_pri ) ) ;

  CP_lba_atm_arb_atm_boosted : coverpoint { hqm_list_sel_pipe_core.p3_lba_sch_nalb_arb_winner_boosted } iff
        ( rst_n & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe.en & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v & hqm_list_sel_pipe_core.p3_lba_sch_atm_arb_winner_boosted &
          ( hqm_list_sel_pipe_core.p3_lba_sch_atm_arb_winner_pri > hqm_list_sel_pipe_core.p3_lba_sch_nalb_arb_winner_pri ) ) ;

//----------------------------------------------------------------------------------
// "total" limitations take effect

  // effect of p3_atq_fid_inflight_cnt_lt_lim on p3_atq_arb_winner_v
  CP_p3_atq_fid_inflight_cnt_lt_lim : coverpoint { hqm_list_sel_pipe_core.p3_atq_fid_inflight_cnt_lt_lim } iff (rst_n & hqm_list_sel_pipe_core.p3_atq_arb_winner_pre_v &
        hqm_list_sel_pipe_core.p3_atq_tot_act_cnt_lt_lim & ~ hqm_list_sel_pipe_core.atq_stop_atqatm_f ) ;

  // effect of p3_atq_tot_act_cnt_lt_lim on p3_atq_arb_winner_v
  // Note: bin 0 covered by FEATURE detect, tested in emulation
  CP_p3_atq_tot_act_cnt_lt_lim : coverpoint { hqm_list_sel_pipe_core.p3_atq_tot_act_cnt_lt_lim } iff (rst_n & hqm_list_sel_pipe_core.p3_atq_arb_winner_pre_v &
        hqm_list_sel_pipe_core.p3_atq_fid_inflight_cnt_lt_lim & ~ hqm_list_sel_pipe_core.atq_stop_atqatm_f ) ;

  // effect of p3_atq_qid_en_f on p3_atq_nfull_arb_reqs
  CP_p3_atq_qid_en_f_nfull : coverpoint { ( | ( hqm_list_sel_pipe_core.p3_atq_nfull_arb_reqs ) ) } iff (rst_n &
        ( | ( hqm_list_sel_pipe_core.p3_atq_qid_v_f & hqm_list_sel_pipe_core.p3_atq_aqed_nfull_f ) ) ) ;

  // effect of p3_atq_qid_en_f on p3_atq_empty_arb_reqs
  CP_p3_atq_qid_en_f_empty : coverpoint { ( | ( hqm_list_sel_pipe_core.p3_atq_empty_arb_reqs ) ) } iff (rst_n &
        ( | ( hqm_list_sel_pipe_core.p3_atq_qid_v_f & hqm_list_sel_pipe_core.p3_atq_aqed_empty_f ) ) ) ;


  CP_p8_lba_tot_if_v_f : coverpoint { hqm_list_sel_pipe_core.p8_lba_tot_if_v_f } iff (rst_n & ( hqm_list_sel_pipe_core.p8_lba_cq_if_v_upd_f | hqm_list_sel_pipe_core.p8_lba_cq_tok_v_upd_f ) &
        ( | ( hqm_list_sel_pipe_core.p8_lba_cq_tok_v_f & hqm_list_sel_pipe_core.p8_lba_cq_if_v_f ) ) ) ;


//----------------------------------------------------------------------------------
// FIFOs (includes DBs used as FIFOs (afull signal derived from DB ready))
  CP_dir_tokrtn_fifo_afull : coverpoint { hqm_list_sel_pipe_core.dir_tokrtn_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_token_v & ( hqm_list_sel_pipe_core.core_chp_lsp_token_data.is_ldb == 1'b0 ) ) ;
  CP_ldb_token_rtn_fifo_afull : coverpoint { hqm_list_sel_pipe_core.ldb_token_rtn_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_token_v & ( hqm_list_sel_pipe_core.core_chp_lsp_token_data.is_ldb == 1'b1 ) ) ;
  CP_uno_atm_cmp_fifo_afull : coverpoint { hqm_list_sel_pipe_core.uno_atm_cmp_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_cmp_uno_v & hqm_list_sel_pipe_core.atm_cmp_fifo_ready & hqm_list_sel_pipe_core.nalb_cmp_fifo_ready ) ;
  CP_nalb_cmp_fifo_afull : coverpoint { hqm_list_sel_pipe_core.nalb_cmp_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_cmp_nalb_v & hqm_list_sel_pipe_core.atm_cmp_fifo_ready & hqm_list_sel_pipe_core.uno_atm_cmp_fifo_ready ) ;
  CP_atm_cmp_fifo_afull : coverpoint { hqm_list_sel_pipe_core.atm_cmp_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_cmp_atm_v & hqm_list_sel_pipe_core.uno_atm_cmp_fifo_ready & hqm_list_sel_pipe_core.nalb_cmp_fifo_ready ) ;
  // V1 input FIFO absorbed into V2 rx_sync FIFO
  CP_rop_ord_cmp_fifo_afull : coverpoint { hqm_list_sel_pipe_core.rop_lsp_reordercmp_ready } iff (rst_n & hqm_list_sel_pipe_core.rop_lsp_reordercmp_v ) ;
  CP_enq_nalb_fifo_afull : coverpoint { hqm_list_sel_pipe_core.enq_nalb_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.core_nalb_lsp_enq_lb_v & ( hqm_list_sel_pipe_core.core_nalb_lsp_enq_lb_data.qtype != ATOMIC ) ) ;
  CP_qed_lsp_deq_fifo_afull : coverpoint { hqm_list_sel_pipe_core.i_hqm_lsp_wu_pipe.qed_lsp_deq_fifo_afull_nc } iff (rst_n) ;   // managed by credits, can't get afull and input valid simultaneously
  CP_aqed_lsp_deq_fifo_afull : coverpoint { hqm_list_sel_pipe_core.i_hqm_lsp_wu_pipe.aqed_lsp_deq_fifo_afull_nc } iff (rst_n) ; // managed by credits, can't get afull and input valid simultaneously
  // V1 input FIFO absorbed into V2 rx_sync FIFO
  CP_enq_dir_fifo_afull : coverpoint { hqm_list_sel_pipe_core.dp_lsp_enq_dir_ready } iff (rst_n & hqm_list_sel_pipe_core.dp_lsp_enq_dir_v ) ;
  CP_dir_sel_dp_fifo_afull_prog_0  : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_afull } iff (rst_n & ! hqm_list_sel_pipe_core.p3_direnq_fill_in_progress & hqm_list_sel_pipe_core.p3_direnq_arb_winner_v & ! hqm_list_sel_pipe_core.p4_direnq_sch_hold) ;
  CP_dir_sel_dp_fifo_afull_prog_1  : coverpoint { hqm_list_sel_pipe_core.dir_sel_dp_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.p3_direnq_fill_in_progress & ! hqm_list_sel_pipe_core.p4_direnq_sch_hold) ;
  CP_atq_sel_ap_fifo_afull : coverpoint { hqm_list_sel_pipe_core.atq_sel_ap_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.p3_atq_arb_winner_v & ! hqm_list_sel_pipe_core.p4_atq_sch_hold ) ;
  CP_rpl_ldb_nalb_fifo_afull : coverpoint { hqm_list_sel_pipe_core.rpl_ldb_nalb_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.p3_lbrpl_arb_winner_v & ! hqm_list_sel_pipe_core.p4_lbrpl_sch_hold ) ;
  CP_rpl_dir_dp_fifo_afull : coverpoint { hqm_list_sel_pipe_core.rpl_dir_dp_fifo_afull } iff (rst_n & hqm_list_sel_pipe_core.p3_dirrpl_arb_winner_v & ! hqm_list_sel_pipe_core.p4_dirrpl_sch_hold ) ;

  // nalb_sel_nalb_fifo_afull not possible - credits only allow 8 (HQM_LSP_NALB_PIPE_CREDITS) schedules, FIFO is 16 (HQM_LSP_NALB_SEL_NALB_FIFO_DEPTH) deep

//----------------------------------------------------------------------------------
// DB ready
  CP_chp_lsp_token_ready : coverpoint { hqm_list_sel_pipe_core.chp_lsp_token_ready } iff (rst_n & hqm_list_sel_pipe_core.chp_lsp_token_v ) ;
  CP_core_chp_lsp_token_ready : coverpoint { hqm_list_sel_pipe_core.core_chp_lsp_token_ready } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_token_v ) ;

  CP_chp_lsp_cmp_ready : coverpoint { hqm_list_sel_pipe_core.chp_lsp_cmp_ready } iff (rst_n & hqm_list_sel_pipe_core.chp_lsp_cmp_v ) ;
  CP_core_chp_lsp_cmp_ready : coverpoint { hqm_list_sel_pipe_core.core_chp_lsp_cmp_ready } iff (rst_n & hqm_list_sel_pipe_core.core_chp_lsp_cmp_v ) ;

  CP_rop_lsp_reordercmp_ready : coverpoint { hqm_list_sel_pipe_core.rop_lsp_reordercmp_ready } iff (rst_n & hqm_list_sel_pipe_core.rop_lsp_reordercmp_v ) ;
  CP_core_rop_lsp_reordercmp_ready : coverpoint { hqm_list_sel_pipe_core.core_rop_lsp_reordercmp_ready } iff (rst_n & hqm_list_sel_pipe_core.core_rop_lsp_reordercmp_v ) ;

  CP_nalb_lsp_enq_lb_ready : coverpoint { hqm_list_sel_pipe_core.nalb_lsp_enq_lb_ready } iff (rst_n & hqm_list_sel_pipe_core.nalb_lsp_enq_lb_v ) ;
  CP_core_nalb_lsp_enq_lb_ready : coverpoint { hqm_list_sel_pipe_core.core_nalb_lsp_enq_lb_ready } iff (rst_n & hqm_list_sel_pipe_core.core_nalb_lsp_enq_lb_v ) ;

  // Note: bin 0 is covered by agitation
  CP_enq_atq_db_in_ready : coverpoint { hqm_list_sel_pipe_core.enq_atq_db_in_ready } iff (rst_n & hqm_list_sel_pipe_core.enq_atq_db_in_valid ) ;

  CP_enq_atq_db_out_ready : coverpoint { hqm_list_sel_pipe_core.enq_atq_db_out_ready } iff (rst_n & hqm_list_sel_pipe_core.enq_atq_db_out_valid ) ;

  CP_nalb_lsp_enq_rorply_ready : coverpoint { hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_ready } iff (rst_n & hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_v ) ;
  CP_core_nalb_lsp_enq_rorply_ready : coverpoint { hqm_list_sel_pipe_core.core_nalb_lsp_enq_rorply_ready } iff (rst_n & hqm_list_sel_pipe_core.core_nalb_lsp_enq_rorply_v ) ;

  CP_dp_lsp_enq_dir_ready : coverpoint { hqm_list_sel_pipe_core.dp_lsp_enq_dir_ready } iff (rst_n & hqm_list_sel_pipe_core.dp_lsp_enq_dir_v ) ;
  CP_core_dp_lsp_enq_dir_ready : coverpoint { hqm_list_sel_pipe_core.core_dp_lsp_enq_dir_ready } iff (rst_n & hqm_list_sel_pipe_core.core_dp_lsp_enq_dir_v ) ;

  CP_dp_lsp_enq_rorply_ready : coverpoint { hqm_list_sel_pipe_core.dp_lsp_enq_rorply_ready } iff (rst_n & hqm_list_sel_pipe_core.dp_lsp_enq_rorply_v ) ;
  CP_core_dp_lsp_enq_rorply_ready : coverpoint { hqm_list_sel_pipe_core.core_dp_lsp_enq_rorply_ready } iff (rst_n & hqm_list_sel_pipe_core.core_dp_lsp_enq_rorply_v ) ;

  CP_aqed_lsp_sch_ready : coverpoint { hqm_list_sel_pipe_core.aqed_lsp_sch_ready } iff (rst_n & hqm_list_sel_pipe_core.aqed_lsp_sch_v ) ;
  CP_send_atm_to_cq_ready : coverpoint { hqm_list_sel_pipe_core.send_atm_to_cq_ready } iff (rst_n & hqm_list_sel_pipe_core.send_atm_to_cq_v ) ;

  CP_lsp_nalb_sch_unoord_in_ready : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_in_ready } iff (rst_n & hqm_list_sel_pipe_core.nalb_sel_nalb_fifo_pop_data_v ) ;
  CP_lsp_nalb_sch_unoord_ready : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_ready } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v ) ;

//----------------------------------------------------------------------------------
// ms bits all the way down the pipe
  CP_lsp_nalb_sch_unoord_cq : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.cq[5] } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v ) ;
  CP_lsp_nalb_sch_unoord_qid : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v ) ;
  CP_lsp_nalb_sch_unoord_qidix : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.qidix[2] } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v ) ;
  CP_lsp_ap_atm_slist_sch_cq : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.cq[5] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ;
  CP_lsp_ap_atm_slist_sch_qid  : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ;
  CP_lsp_ap_atm_slist_sch_qidix  : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qidix[2] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ;
  CP_lsp_ap_atm_slist_sch_qpri : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qpri [2] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ;
  CP_lsp_ap_atm_rlist_sch_cq : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.cq[5] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) ) ;
  CP_lsp_ap_atm_rlist_sch_qid  : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) ) ;
  CP_lsp_ap_atm_rlist_sch_qidix  : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qidix[2] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) ) ;
  CP_lsp_ap_atm_rlist_sch_qpri : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qpri [2] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) ) ;
  CP_lsp_ap_atm_cmp_cq : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.cq[5] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ) ;
  CP_lsp_ap_atm_cmp_qid : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ) ;

  // fid[11] not currently used
  CP_lsp_ap_atm_cmp_fid : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.fid[10] } iff (rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & ( hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ) ;

  CP_lsp_nalb_sch_atq_qid : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_atq_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_atq_v ) ;
  CP_lsp_dp_sch_dir_cq : coverpoint { hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.cq[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_dp_sch_dir_v ) ;
  CP_lsp_dp_sch_dir_qid : coverpoint { hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_dp_sch_dir_v ) ;
  CP_lsp_nalb_sch_rorply_qid : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_v ) ;
  CP_lsp_dp_sch_rorply_qid : coverpoint { hqm_list_sel_pipe_core.lsp_dp_sch_rorply_data.qid[6] } iff (rst_n & hqm_list_sel_pipe_core.lsp_dp_sch_rorply_v ) ;

  // LBRPL with max frag cnt update (16K)
  CP_lbrply_max_frag_cnt : coverpoint { hqm_list_sel_pipe_core.p2_lbrpl_enq_cnt_upd_v & hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.enq_v &
        hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.frag_cnt[14] } iff (rst_n ) ;

  // DIRRPL with max frag cnt update (4K)
  CP_dirrply_max_frag_cnt : coverpoint { hqm_list_sel_pipe_core.p2_dirrpl_enq_cnt_upd_v & hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.enq_v &
        hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.frag_cnt[12] } iff (rst_n ) ;

//----------------------------------------------------------------------------------
// completion blast, included for completeness
  CP_lba_cmpblast_p8 : coverpoint { hqm_list_sel_pipe_core.p7_lba_set_cmpblast } iff (rst_n ) ;

//----------------------------------------------------------------------------------
// non-lba blast taking effect.  Too expensive / slow for feature bits


  // p2 direnq attempting to set qid_v but blocked by blast_enq
  CP_direnq_blast_enq_p3 : coverpoint { hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.blast_enq } iff (rst_n &
        hqm_list_sel_pipe_core.p3_direnq_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.enq_v & ( hqm_list_sel_pipe_core.p2_direnq_enq_cnt_upd.cnt > '0 )  &
        ( | ( cov_p2_direnq_enq_cnt_qid_vec & ~ hqm_list_sel_pipe_core.p3_qid_dir_sch_v_status ) )
  ) ;

  // p2 direnq attempting to set cq_avail but blocked by blast_tok
  CP_direnq_blast_tok_p3 : coverpoint { hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.blast_tok } iff (rst_n &
        hqm_list_sel_pipe_core.p3_direnq_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_v & ( hqm_list_sel_pipe_core.p2_direnq_tok_cnt_upd_space > '0 ) &
        ( | ( cov_p2_direnq_tok_cnt_cq_vec & ~ hqm_list_sel_pipe_core.p3_cq_dir_tok_v_status ) )
  ) ;

  // p2 atq attempting to set qid_v but blocked by blast_enq
  CP_atq_blast_enq_p3 : coverpoint { hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.blast_enq } iff (rst_n &
        hqm_list_sel_pipe_core.p3_atq_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.enq_v & hqm_list_sel_pipe_core.p2_atq_enq_cnt_upd_gt0 &
        ( | ( cov_p2_atq_enq_cnt_qid_vec & ~ hqm_list_sel_pipe_core.p3_atq_qid_v_f ) )
  ) ;

  // p2 atq attempting to set cq_avail but blocked by blast_cmp.  Disable empty arb since nfull is the one we're trying to blast
  // Note: only reachable if chicken bit cfg_control_disable_atq_empty_arb is set
  CP_atq_blast_cmp_p3 : coverpoint { hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.blast_cmp } iff (rst_n & hqm_list_sel_pipe_core.cfg_control_disable_atq_empty_arb &
        hqm_list_sel_pipe_core.p3_atq_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.cmp_v & hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_upd_lt_lim &
        ( | ( cov_p2_atq_aqed_act_cnt_qid_vec & ~ hqm_list_sel_pipe_core.p3_atq_aqed_nfull_f ) )
  ) ;

  // p2 dirrpl attempting to set qid_v but blocked by blast_enq
  CP_dirrpl_blast_enq_p3 : coverpoint { hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.blast_enq } iff (rst_n &
        hqm_list_sel_pipe_core.p3_dirrpl_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.enq_v & hqm_list_sel_pipe_core.p2_dirrpl_enq_cnt_upd_gt0 &
        ( | ( cov_p2_dirrpl_enq_cnt_qid_vec & ~ hqm_list_sel_pipe_core.cfg_qid_dir_replay_v_status ) )
  ) ;

  // p2 lbrpl attempting to set qid_v but blocked by blast_enq
  CP_lbrpl_blast_enq_p3 : coverpoint { hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.blast_enq } iff (rst_n &
        hqm_list_sel_pipe_core.p3_lbrpl_ctrl_pipe.en & hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.enq_v & hqm_list_sel_pipe_core.p2_lbrpl_enq_cnt_upd_gt0 &
        ( | ( cov_p2_lbrpl_enq_cnt_qid_vec & ~ hqm_list_sel_pipe_core.cfg_qid_ldb_replay_v_status ) )
  ) ;

//----------------------------------------------------------------------------------
// Write buffer optimization
// Entirely different than V1, need new coverpoints


//----------------------------------------------------------------------------------
// Feature bits cfg_detect_feature_0_f and cfg_detect_feature_1_f were tested in emulation in V1.  No longer in hw, only tested in simulation or not at all.
// Add coverpoints for all bits used in these to registers.  May later decide to give up on some of these.  cmpblast with hold (25,23,21,19) were
// difficult to cause even on v1 FPGA.
  CP_FEAT_0_0  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [0]  } iff ( rst_n ) ;
  CP_FEAT_0_1  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [1]  } iff ( rst_n ) ;
  CP_FEAT_0_2  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [2]  } iff ( rst_n ) ;
  CP_FEAT_0_3  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [3]  } iff ( rst_n ) ;
  CP_FEAT_0_4  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [4]  } iff ( rst_n ) ;
  CP_FEAT_0_5  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [5]  } iff ( rst_n ) ;
  CP_FEAT_0_6  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [6]  } iff ( rst_n ) ;
  CP_FEAT_0_7  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [7]  } iff ( rst_n ) ;
  CP_FEAT_0_8  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [8]  } iff ( rst_n ) ;
  CP_FEAT_0_9  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [9]  } iff ( rst_n ) ;
  CP_FEAT_0_10 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [10] } iff ( rst_n ) ;
  CP_FEAT_0_11 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [11] } iff ( rst_n ) ;
  CP_FEAT_0_12 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_0_f [12] } iff ( rst_n ) ;
  // 31:13 currently unused

  CP_FEAT_1_0  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [0]  } iff ( rst_n ) ;
  CP_FEAT_1_1  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [1]  } iff ( rst_n ) ;
  CP_FEAT_1_2  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [2]  } iff ( rst_n ) ;
  CP_FEAT_1_3  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [3]  } iff ( rst_n ) ;
  CP_FEAT_1_4  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [4]  } iff ( rst_n ) ;
  CP_FEAT_1_5  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [5]  } iff ( rst_n ) ;
  CP_FEAT_1_6  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [6]  } iff ( rst_n ) ;
  CP_FEAT_1_7  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [7]  } iff ( rst_n ) ;
  CP_FEAT_1_8  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [8]  } iff ( rst_n ) ;
  CP_FEAT_1_9  : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [9]  } iff ( rst_n ) ;
  CP_FEAT_1_10 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [10] } iff ( rst_n ) ;
  CP_FEAT_1_11 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [11] } iff ( rst_n ) ;
  CP_FEAT_1_12 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [12] } iff ( rst_n ) ;
  CP_FEAT_1_13 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [13] } iff ( rst_n ) ;
  CP_FEAT_1_14 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [14] } iff ( rst_n ) ;
  CP_FEAT_1_15 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [15] } iff ( rst_n ) ;
  CP_FEAT_1_16 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [16] } iff ( rst_n ) ;
  CP_FEAT_1_17 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [17] } iff ( rst_n ) ;
  CP_FEAT_1_18 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [18] } iff ( rst_n ) ;
  CP_FEAT_1_19 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [19] } iff ( rst_n ) ;      // Requires lba atm hold, difficult in sim
  CP_FEAT_1_20 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [20] } iff ( rst_n ) ;
  CP_FEAT_1_21 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [21] } iff ( rst_n ) ;      // Requires lba atm hold, difficult in sim
  CP_FEAT_1_22 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [22] } iff ( rst_n ) ;
  CP_FEAT_1_23 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [23] } iff ( rst_n ) ;      // Requires lba atm hold, difficult in sim
  CP_FEAT_1_24 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [24] } iff ( rst_n ) ;
  CP_FEAT_1_25 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [25] } iff ( rst_n ) ;      // Requires lba atm hold, difficult in sim
  CP_FEAT_1_26 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [26] } iff ( rst_n ) ;
  CP_FEAT_1_27 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [27] } iff ( rst_n ) ;
  CP_FEAT_1_28 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [28] } iff ( rst_n ) ;
  CP_FEAT_1_29 : coverpoint { hqm_list_sel_pipe_core.cfg_detect_feature_1_f [29] } iff ( rst_n ) ;
  // 31:30 currently unused

//----------------------------------------------------------------------------------
// Features

  CP_FEAT_disable_write_buffer_opt : coverpoint { hqm_list_sel_pipe_core.p3_direnq_arb_winner_disab_opt } iff (rst_n &
        hqm_list_sel_pipe_core.p3_direnq_sch_start ) ;

  // Note: only reachable if chicken bit cfg_control_atm_cq_qid_priority_prot is set
  CP_FEAT_atm_cq_qid_priority_prot : coverpoint { hqm_list_sel_pipe_core.cfg_control_atm_cq_qid_priority_prot } iff (rst_n & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f ) ;

//----------------------------------------------------------------------------------
// Things that might be flat out broken and not show up until later (e.g. perf)
  CP_TOG_p4_lba_sch_arb_update : coverpoint { hqm_list_sel_pipe_core.p4_lba_sch_arb_update } iff (rst_n ) ;

//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
// v2 changes / features

  // Just make sure these are wired up, telemetry counts could be broken and not noticed
  CP_FEAT_cos_cfg_sch_rdy_count_gt0        : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_sch_rdy_count }        iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_schd_cos0_count_gt0      : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos0_count }      iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_schd_cos1_count_gt0      : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos1_count }      iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_schd_cos2_count_gt0      : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos2_count }      iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_schd_cos3_count_gt0      : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos3_count }      iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rdy_cos0_count_gt0       : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos0_count }       iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rdy_cos1_count_gt0       : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos1_count }       iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rdy_cos2_count_gt0       : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos2_count }       iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rdy_cos3_count_gt0       : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos3_count }       iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rnd_loss_cos0_count_gt0  : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos0_count }  iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rnd_loss_cos1_count_gt0  : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos1_count }  iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rnd_loss_cos2_count_gt0  : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos2_count }  iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_rnd_loss_cos3_count_gt0  : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos3_count }  iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_cnt_win_cos0_count_gt0   : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos0_count }   iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_cnt_win_cos1_count_gt0   : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos1_count }   iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_cnt_win_cos2_count_gt0   : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos2_count }   iff (rst_n ) { bins gt0 = { [1:$] }; }
  CP_FEAT_cos_cfg_cnt_win_cos3_count_gt0   : coverpoint { hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos3_count }   iff (rst_n ) { bins gt0 = { [1:$] }; }

  // "Random" arbiter (bw selector) chooses winner
  CP_FEAT_cos_winner_rnd         : coverpoint { hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v
                                                & hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                              iff (rst_n ) ;

  // Backup count arbiter chooses winner without tiebreaker, and without starvation avoidance overriding it
  CP_FEAT_cos_winner_bkup_notie  : coverpoint { ( ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v )
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_winner_v
                                                & ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_cosnum_from_seqarb
                                                & ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_high_pri_override_cond
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                              iff (rst_n ) ;

  // Backup count arbiter chooses winner using tiebreaker, and without starvation avoidance overriding it
  CP_FEAT_cos_winner_bkup_tie    : coverpoint { ( ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v )
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_winner_v
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_cosnum_from_seqarb
                                                & ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_high_pri_override_cond
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                              iff (rst_n ) ;

  // Backup count arbiter chooses winner via starvation avoidance override
  // Don't intend to fully test in simulation, but at least see that it has been exercised
  CP_FEAT_cos_winner_starv_avoid : coverpoint { ( ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v )
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_winner_v
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_high_pri_override_cond
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                              iff (rst_n ) ;

  // Sequencer chooses winner (unconfigured bandwidth)
  CP_FEAT_cos_winner_sequencer   : coverpoint { ( ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v )
                                                & ~ hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_winner_v
                                                &   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                              iff (rst_n ) ;

  // Congestion management - nalb
  CP_FEAT_cm_nalb : coverpoint { hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.hqm_core_flags.congestion_management }
                               iff ( rst_n
                                     & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v 
                                     & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_ready ) ;

  // Congestion management - atm
  CP_FEAT_cm_atm  : coverpoint { hqm_list_sel_pipe_core.lsp_ap_atm_data.hqm_core_flags.congestion_management }
                               iff ( rst_n
                                     & ( (  hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST )
                                       | (  hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) )
                                     & hqm_list_sel_pipe_core.lsp_ap_atm_v
                                     & hqm_list_sel_pipe_core.lsp_ap_atm_ready ) ;

  // Congestion management - dir
  CP_FEAT_cm_dir  : coverpoint { hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.congestion_management }
                               iff ( rst_n
                                     & hqm_list_sel_pipe_core.lsp_dp_sch_dir_v 
                                     & hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready ) ;

  // Write Buffer optimization - all 4 codes
  CP_FEAT_wbo     : coverpoint { hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.write_buffer_optimization }
                               iff ( rst_n
                                     & hqm_list_sel_pipe_core.lsp_dp_sch_dir_v 
                                     & hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready ) ;

//----------------------------------------------------------------------------------
// Other v2 changes

  // Write (clear) to wide RW/C memories: write of any value to either half zeroes both halves
  CP_TOG_cfgsc_qid_naldb_tot_enq_cnt_mem_we : coverpoint { hqm_list_sel_pipe_core.cfgsc_qid_naldb_tot_enq_cnt_mem_we } iff (rst_n ) ;
  CP_TOG_cfgsc_qid_atm_tot_enq_cnt_mem_we   : coverpoint { hqm_list_sel_pipe_core.cfgsc_qid_atm_tot_enq_cnt_mem_we } iff (rst_n ) ;
  CP_TOG_cfgsc_cq_ldb_tot_sch_cnt_mem_we    : coverpoint { hqm_list_sel_pipe_core.cfgsc_cq_ldb_tot_sch_cnt_mem_we } iff (rst_n ) ;
  CP_TOG_cfgsc_qid_dir_tot_enq_cnt_mem_we   : coverpoint { hqm_list_sel_pipe_core.cfgsc_qid_dir_tot_enq_cnt_mem_we } iff (rst_n ) ;
  CP_TOG_cfgsc_cq_dir_tot_sch_cnt_mem_we    : coverpoint { hqm_list_sel_pipe_core.cfgsc_cq_dir_tot_sch_cnt_mem_we } iff (rst_n ) ;

  // Max DIR token limit = 4K
  CP_FEAT_dir_tok_lim_4K : coverpoint { hqm_list_sel_pipe_core.p2_direnq_tok_cnt_upd_v
                                        &   ( hqm_list_sel_pipe_core.p2_direnq_tok_limit == 13'h1000 ) }
                                      iff (rst_n ) ;

  // Priority binning is tested in emulation

  // ATM active count functionality confirmed in emulation

endgroup
COVERGROUP u_COVERGROUP = new();

//----------------------------------------------------------------------------------
// v2 changes / features - COS arbiter
generate
  for ( genvar gi=0; gi < 4; gi = gi + 1 ) begin : gen_for_cos
    // credit count = configured max
    covergroup CG_FEAT_cos_count_eq_cfg_max @(posedge clk);
      CP_FEAT_cos_count_eq_cfg_max : coverpoint { ( hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_credit_cnt [gi*16+:16] ==
                                                    hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_credit_sat [gi*16+:16] )
                                                  & hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                                iff (rst_n ) ;
    endgroup
    CG_FEAT_cos_count_eq_cfg_max u_CG_FEAT_cos_count_eq_cfg_max = new();

    // no_extra_credit takes effect
    covergroup CG_FEAT_cos_no_extra_credit @(posedge clk);
      CP_FEAT_cos_no_extra_credit : coverpoint { ( hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_credit_cnt [gi*16+:16] == 0 )
                                                 & hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_no_extra_credit [gi]
                                                 & hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update }
                                                iff (rst_n ) ;
    endgroup
    CG_FEAT_cos_no_extra_credit u_CG_FEAT_cos_no_extra_credit = new();

  end // for
endgenerate

`endif
endmodule
bind hqm_list_sel_pipe_core hqm_list_sel_pipe_cover i_hqm_list_sel_pipe_cover();
`endif
