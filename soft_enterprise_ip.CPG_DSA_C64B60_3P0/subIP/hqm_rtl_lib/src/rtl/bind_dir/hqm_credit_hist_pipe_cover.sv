`ifdef INTEL_INST_ON

module hqm_credit_hist_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef HQM_COVER_ON

  logic [ 1 : 0 ] ing_qed_sch_v_count ;
  logic [ 3 : 0 ] enq_chp_state_v_count ;
  logic [ 2 : 0 ] sch_chp_state_v_count ;

  assign ing_qed_sch_v_count = ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.p0_qed_sch_v_f 
                               + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.p1_qed_sch_v_f 
                               + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.p2_qed_sch_v_f ) ;

  assign enq_chp_state_v_count = ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p0_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p1_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p2_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p3_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p4_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p5_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p8_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p9_enq_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_v_f ) ;

  assign sch_chp_state_v_count = ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p0_sch_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p1_sch_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p2_sch_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p3_sch_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p4_sch_chp_state_v_f 
                                 + hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_schpipe.p5_sch_chp_state_v_f ) ;

  covergroup CG_CHP_INP_GATED_CLK @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk);
    CP_HCW_ENQ_W_READY : coverpoint { hqm_credit_hist_pipe_core.hcw_enq_w_req_ready } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) ;
    CP_HCW_ENQ_W_CL : coverpoint { hqm_credit_hist_pipe_core.hcw_enq_w_req.user.cl } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                           hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) ;
    CP_HCW_ENQ_W_TS : coverpoint { hqm_credit_hist_pipe_core.hcw_enq_w_req.user.insert_timestamp } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                                         hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) ;
    CP_HCW_ENQ_W_HCW_CMD : coverpoint { hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                                             hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) {
      bins NOOP = { HQM_CMD_NOOP } ;
      bins BAT_T = { HQM_CMD_BAT_TOK_RET } ;
      bins COMP = { HQM_CMD_COMP } ;
      bins COMP_T = { HQM_CMD_COMP_TOK_RET } ;
      bins RELEASE = { HQM_CMD_ILLEGAL_CMD_4 } ;
      bins ARM = { HQM_CMD_ARM } ;
      ignore_bins ILLEGAL_CMD_6 = { HQM_CMD_A_COMP } ;
      ignore_bins ILLEGAL_CMD_7 = { HQM_CMD_A_COMP_TOK_RET } ;
      bins NEW = { HQM_CMD_ENQ_NEW } ;
      bins NEW_T = { HQM_CMD_ENQ_NEW_TOK_RET } ;
      bins RENQ = { HQM_CMD_ENQ_COMP } ;
      bins RENQ_T = { HQM_CMD_ENQ_COMP_TOK_RET } ;
      ignore_bins FRAG = { HQM_CMD_ENQ_FRAG } ;
      ignore_bins FRAG_T = { HQM_CMD_ENQ_FRAG_TOK_RET } ;
      ignore_bins ILLEGAL_CMD_14 = { HQM_CMD_ILLEGAL_CMD_14 } ;
      ignore_bins ILLEGAL_CMD_15 = { HQM_CMD_ILLEGAL_CMD_15 } ;
    }
    CP_HCW_ENQ_W_QTYPE : coverpoint { hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                                          hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) {
      bins ATOMIC = { ATOMIC } ;
      bins UNORDERED = { UNORDERED } ;
      bins ORDERED = { ORDERED } ;
      bins DIRECT = { DIRECT } ;
    }
    XCP_HCW_ENQ_W_HCW_CMD_QTYPE : cross CP_HCW_ENQ_W_HCW_CMD , CP_HCW_ENQ_W_QTYPE ;
    CP_QED_CHP_SCH_READY : coverpoint { hqm_credit_hist_pipe_core.qed_chp_sch_ready } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) ;
    CP_AQED_CHP_SCH_READY : coverpoint { hqm_credit_hist_pipe_core.aqed_chp_sch_ready } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) ;
    CP_QED_CHP_SCH_CMD : coverpoint { hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                             hqm_credit_hist_pipe_core.qed_chp_sch_v ) {
      ignore_bins ILL0 = { QED_CHP_SCH_ILL0 } ; 
      bins SCHED = { QED_CHP_SCH_SCHED } ;
      bins REPLAY = { QED_CHP_SCH_REPLAY } ;
      bins ATQ2ATM = { QED_CHP_SCH_TRANSFER } ; 
    } 
    CP_QED_CHP_SCH_CQ : coverpoint { hqm_credit_hist_pipe_core.qed_chp_sch_data.cq [ 5 : 0 ] } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                                     hqm_credit_hist_pipe_core.qed_chp_sch_v ) ;
    CP_QED_CHP_SCH_FLID : coverpoint { hqm_credit_hist_pipe_core.qed_chp_sch_data.flid [ 12 : 0 ] } iff ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp &
                                                                                                          hqm_credit_hist_pipe_core.qed_chp_sch_v ) ;
  endgroup

  covergroup CG_CHP_GATED_CLK @(posedge hqm_credit_hist_pipe_core.hqm_gated_clk);
    CP_CHP_ROP_HCW : coverpoint { hqm_credit_hist_pipe_core.chp_rop_hcw_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                      hqm_credit_hist_pipe_core.chp_rop_hcw_v ) {
      bins STALL = { 0 } ;
      bins TAKEN = { 1 } ;
    }
    CP_CHP_LSP_TOKEN : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_token_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                          hqm_credit_hist_pipe_core.chp_lsp_token_v ) {
      bins STALL = { 0 } ;
      bins TAKEN = { 1 } ;
    }
    CP_CHP_LSP_TOKEN_CQ : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_token_data.cq } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                               hqm_credit_hist_pipe_core.chp_lsp_token_v ) {
      bins VALID_CQ = { [ 0 : 63 ] } ;
      ignore_bins INVALID_CQ = { [ 64 : 255 ] } ;
    }
    CP_CHP_LSP_TOKEN_COUNT_DIR : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_token_data.count } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                         hqm_credit_hist_pipe_core.chp_lsp_token_v &
                                                                                                         ~ hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb ) {
      bins MIN_COUNT = { 1 } ;
      bins MAX_COUNT = { 2048 } ;
      bins OTHERS_COUNT = { [ 2 : 2047 ] } ;
    }
    CP_CHP_LSP_TOKEN_COUNT_LDB : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_token_data.count } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                         hqm_credit_hist_pipe_core.chp_lsp_token_v &
                                                                                                         hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb ) {
      bins MIN_COUNT = { 1 } ;
      bins MAX_COUNT = { 2048 } ;
      bins OTHERS_COUNT = { [ 2 : 2047 ] } ;
    }
    CP_CHP_LSP_CMP : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                      hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) {
      bins STALL = { 0 } ;
      bins TAKEN = { 1 } ;
    }
    CP_CHP_LSP_CMP_USER : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.user } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                               hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) {
      bins NORMAL = { 0 } ;
      bins NO_DEC = { 1 } ;
      bins RELEASE = { 2 } ;
      ignore_bins INVALID = { 3 } ;
    }
    CP_CHP_LSP_CMP_QID : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                             hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) {
      bins VALID_QID = { [ 0 : 31 ] } ;
      ignore_bins INVALID_QID = { [ 32 : 127 ] } ;
    }
    CP_CHP_LSP_CMP_CQ : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                           hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) {
      bins VALID_CQ = { [ 0 : 63 ] } ;
      ignore_bins INVALID_CQ = { [ 64 : 255 ] } ;
    }
    CP_CHP_LSP_CMP_QTYPE : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) {
      bins ATOMIC = { ATOMIC } ;
      bins UNORDERED = { UNORDERED } ;
      bins ORDERED = { ORDERED } ;
      ignore_bins DIRECT = { DIRECT } ;
    }
    CP_CHP_LSP_CMP_QPRI : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qpri } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                              hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) ; 
    CP_CHP_LSP_CMP_REORD_MODE : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.reord_mode } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                          hqm_credit_hist_pipe_core.chp_lsp_cmp_v &
                                                                                                                          ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype == ORDERED ) ) { 
      bins QIDS_32_SN_64 = { 0 } ;
      bins QIDS_16_SN_128 = { 1 } ;
      bins QIDS_8_SN_256 = { 2 } ;
      bins QIDS_4_SN_512 = { 3 } ;
      bins QIDS_2_SN_1024 = { 4 } ;
      ignore_bins INVALID_MODE = { [ 5 : 7 ] } ;
    }
    CP_CHP_LSP_CMP_REORD_SLOT : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.reord_slot [ 3 : 0 ] } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                               hqm_credit_hist_pipe_core.chp_lsp_cmp_v &
                                                                                                                               ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype == ORDERED ) ) ; 
    CP_CHP_LSP_CMP_REORD_SN : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.sn_fid [ 10 : 0 ] } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                               hqm_credit_hist_pipe_core.chp_lsp_cmp_v &
                                                                                                                               ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype == ORDERED ) ) ; 
    CP_CHP_LSP_CMP_HID : coverpoint { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                             hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) ; 
    CP_HCW_SCHED_W : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                          hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) {
       bins STALL = { 0 } ;
       bins TAKEN = { 1 } ;
    }
    CP_HCW_SCHED_W_IS_LDB : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                         hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) {
       bins DIR_CQ = { 0 } ;
       bins LDB_CQ = { 1 } ;
    }
    CP_HCW_SCHED_W_CQ : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                               hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) {
       bins VALID_CQ = { [ 0 : 63 ] } ;
       ignore_bins INVALID_CQ = { [ 64 : 255 ] } ;
    }
    XCP_HCW_SCHED_W_CQ : cross CP_HCW_SCHED_W_IS_LDB , CP_HCW_SCHED_W_CQ ;
    CP_HCW_SCHED_W_CQ_WPTR : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq_wptr [ 10 : 0 ] } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                    hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) ;
    CP_HCW_SCHED_W_WB_OPT : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.write_buffer_optimization } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                                         hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) ;
    CP_SIMULTANEOUS_HCW_SCHED_ROP_LSP : coverpoint { hqm_credit_hist_pipe_core.hcw_sched_w_req_valid
                                                   , hqm_credit_hist_pipe_core.chp_rop_hcw_v
                                                   , hqm_credit_hist_pipe_core.chp_lsp_token_v 
                                                   , hqm_credit_hist_pipe_core.chp_lsp_cmp_v } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) {
      ignore_bins IDLE                   = { 4'b0000 } ;
      ignore_bins LSP_CMP                = { 4'b0001 } ;
      ignore_bins LSP_TOK                = { 4'b0010 } ;
      bins LSP_TOK_LSP_CMP               = { 4'b0011 } ;
      ignore_bins ROP                    = { 4'b0100 } ;
      bins ROP_LSP_CMP                   = { 4'b0101 } ;
      bins ROP_LSP_TOK                   = { 4'b0110 } ;
      bins ROP_LSP_TOK_LSP_CMP           = { 4'b0111 } ;
      ignore_bins HCW_SCHED              = { 4'b1000 } ;
      bins HCW_SCHED_LSP_CMP             = { 4'b1001 } ;
      bins HCW_SCHED_LSP_TOK             = { 4'b1010 } ;
      bins HCW_SCHED_LSP_TOK_LSP_CMP     = { 4'b1011 } ;
      bins HCW_SCHED_ROP                 = { 4'b1100 } ;
      bins HCW_SCHED_ROP_LSP_CMP         = { 4'b1101 } ;
      bins HCW_SCHED_ROP_LSP_TOK         = { 4'b1110 } ;
      bins HCW_SCHED_ROP_LSP_TOK_LSP_CMP = { 4'b1111 } ;
    }
    CP_INTERRUPT_REQ : coverpoint { hqm_credit_hist_pipe_core.interrupt_w_req_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                            hqm_credit_hist_pipe_core.interrupt_w_req_valid ) {
      bins STALL = { 0 } ;
      bins TAKEN = { 1 } ;
    }
    CP_CWDI_INTERRUPT_REQ : coverpoint { hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                      hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_valid ) {
      bins STALL = { 0 } ;
      bins TAKEN = { 1 } ;
    }
    CP_WD_CLKREQ : coverpoint { hqm_credit_hist_pipe_core.wd_clkreq } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_HQM_PROC_CLK_EN : coverpoint { hqm_credit_hist_pipe_core.hqm_proc_clk_en_chp } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CHP_ALARM_DOWN_READY : coverpoint { hqm_credit_hist_pipe_core.chp_alarm_down_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CHP_ALARM_UP_READY : coverpoint { hqm_credit_hist_pipe_core.chp_alarm_up_ready } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CFG_REQ_IDLEPIPE : coverpoint { hqm_credit_hist_pipe_core.cfg_req_idlepipe } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CFG_REQ_STALL : coverpoint { hqm_credit_hist_pipe_core.cfg_req_idlepipe } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                       ~ hqm_credit_hist_pipe_core.cfg_req_ready ) ;

    CP_ING_FIFO_QED_TO_CQ_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.fifo_qed_to_cq_afull_nc } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_QED_TO_CQ_PIPE_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_HCW_ENQ_VALID : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_HCW_REPLAY_VALID : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_DQED_SCH_VALID : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_valid &
                                         ~hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_QED_SCH_VALID : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_valid &
                                        hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ING_AQED_SCH_VALID : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    XCP_ING_REQ_VALIDS : cross CP_ING_HCW_ENQ_VALID , CP_ING_HCW_REPLAY_VALID , CP_ING_DQED_SCH_VALID , CP_ING_QED_SCH_VALID , CP_ING_AQED_SCH_VALID ;
    CP_ING_HCW_ENQ_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                       ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_pop ) ;
    CP_ING_HCW_REPLAY_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                             ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_pop ) ;
    CP_ING_QED_SCH_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                       ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_pop ) ;
    CP_ING_AQED_SCH_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_valid } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                         ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_pop ) ;

    CP_ING_QED_SCH_V_COUNT : coverpoint { ing_qed_sch_v_count } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) {
      ignore_bins PIPE_IDLE = { [ 0 : 0 ] } ;
      bins PIPE_BUSY_1 = { [ 1 : 1 ] } ;
      bins PIPE_BUSY_2 = { [ 2 : 2 ] } ;
      bins PIPE_BUSY_3 = { [ 3 : 3 ] } ;
    }

    CP_ING_QED_CHP_SCH_OUT_OF_CREDIT_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                                                       hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_rx_sync_out_valid &
                                                                                                                                                       ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) &
                                                                                                                                                       ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.cfg_req_idlepipe ) {
      ignore_bins LOAD = { 0 } ;
      bins STALL = { 1 } ;
    }

    CP_ING_QED_CHP_SCH_CFG_ACCESS_STALL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.cfg_req_idlepipe } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                                         hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_rx_sync_out_valid &
                                                                                                                                         ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) &
                                                                                                                                         ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_afull ) {
      ignore_bins LOAD = { 0 } ;
      bins STALL = { 1 } ;
    }

    CP_ARB_CHP_ROP_PIPE_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ARB_CHP_LSP_TOK_PIPE_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ARB_CHP_LSP_AP_CMP_PIPE_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_ARB_CHP_OUTBOUND_HCW_PIPE_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_ENQ_CHP_STATE_V_COUNT : coverpoint { enq_chp_state_v_count } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) {
      ignore_bins PIPE_IDLE = { [ 0 : 0 ] } ;
      bins PIPE_BUSY_1 = { [ 1 : 1 ] } ;
      bins PIPE_BUSY_2 = { [ 2 : 2 ] } ;
      bins PIPE_BUSY_3 = { [ 3 : 3 ] } ;
      bins PIPE_BUSY_4 = { [ 4 : 4 ] } ;
      bins PIPE_BUSY_5 = { [ 5 : 5 ] } ;
      bins PIPE_BUSY_6 = { [ 6 : 6 ] } ;
      bins PIPE_BUSY_7 = { [ 7 : 7 ] } ;
      bins PIPE_BUSY_8 = { [ 8 : 8 ] } ;
      bins PIPE_BUSY_9 = { [ 9 : 9 ] } ;
      bins PIPE_BUSY_10 = { [ 10 : 10 ] } ;
      bins PIPE_BUSY_11 = { [ 11 : 11 ] } ;
      ignore_bins COUNT = { [ 12 : 15 ] } ;
    }

    CP_ENQ_OUT_OF_CREDIT_DROP : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_enq_to_rop_out_of_credit_drop } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_ENQ_P10_HCW_CMD : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.hcw_cmd.hcw_cmd_dec } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                                               hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_v_f ) { 
      ignore_bins NOOP = { HQM_CMD_NOOP } ;
      ignore_bins BAT_T = { HQM_CMD_BAT_TOK_RET } ;
      ignore_bins COMP = { HQM_CMD_COMP } ;
      ignore_bins COMP_T = { HQM_CMD_COMP_TOK_RET } ;
      ignore_bins RELEASE = { HQM_CMD_ILLEGAL_CMD_4 } ;
      ignore_bins ARM = { HQM_CMD_ARM } ;
      ignore_bins ILLEGAL_CMD_6 = { HQM_CMD_A_COMP } ;
      ignore_bins ILLEGAL_CMD_7 = { HQM_CMD_A_COMP_TOK_RET } ;
      bins NEW = { HQM_CMD_ENQ_NEW } ;
      bins NEW_T = { HQM_CMD_ENQ_NEW_TOK_RET } ;
      bins RENQ = { HQM_CMD_ENQ_COMP } ;
      bins RENQ_T = { HQM_CMD_ENQ_COMP_TOK_RET } ;
      ignore_bins FRAG = { HQM_CMD_ENQ_FRAG } ;
      ignore_bins FRAG_T = { HQM_CMD_ENQ_FRAG_TOK_RET } ;
      ignore_bins ILLEGAL_CMD_14 = { HQM_CMD_ILLEGAL_CMD_14 } ;
      ignore_bins ILLEGAL_CMD_15 = { HQM_CMD_ILLEGAL_CMD_15 } ;
    }
    CP_ENQ_P10_OUT_OF_CREDIT : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.out_of_credit } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                                               hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_v_f ) ;
    XCP_ENQ_P10_HCW_CMD_OUT_OF_CREDIT : cross CP_ENQ_P10_HCW_CMD , CP_ENQ_P10_OUT_OF_CREDIT ;

    CP_SCH_CHP_STATE_V_COUNT : coverpoint { sch_chp_state_v_count } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) {
      ignore_bins PIPE_IDLE = { [ 0 : 0 ] } ;
      bins PIPE_BUSY_1 = { [ 1 : 1 ] } ;
      bins PIPE_BUSY_2 = { [ 2 : 2 ] } ;
      bins PIPE_BUSY_3 = { [ 3 : 3 ] } ;
      bins PIPE_BUSY_4 = { [ 4 : 4 ] } ;
      bins PIPE_BUSY_5 = { [ 5 : 5 ] } ;
      bins PIPE_BUSY_6 = { [ 6 : 6 ] } ;
      ignore_bins COUNT = { [ 7 : 7 ] } ;
    }

    CP_EGRESS_CREDIT_AFULL : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_afull } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_EGRESS_RR_REQS : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.rr_reqs } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_EGRESS_TAKE_PUSH_POP_V : coverpoint { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.take_push_v } iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp &
                                                                                                                         hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.take_pop_v ) ;

    CP_CIAL_DIR_TIMER_EN              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.global_hqm_chp_tim_dir_enable} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_DIR_ARMED_0               : coverpoint {|hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_armed_dir[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_DIR_ARMED_1               : coverpoint {|hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_armed_dir[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_DIR_URGENT_0              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_dir[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_DIR_URGENT_1              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_dir[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_DIR_EXPIRED_0             : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_dir[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_DIR_EXPIRED_1             : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_dir[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_DIR_IRQ_ACTIVE            : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_irq_active_dir} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_DIR_TIMER_EN_X_IRQ_ACTIVE : cross CP_CIAL_DIR_TIMER_EN, CP_CIAL_DIR_IRQ_ACTIVE; // case where armed is set run_timer is set and global_timer_en=0 (special case)

    // LDB
    CP_CIAL_LDB_TIMER_EN              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.global_hqm_chp_tim_ldb_enable} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_LDB_ARMED_0               : coverpoint {|hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_armed_ldb[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_LDB_ARMED_1               : coverpoint {|hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_armed_ldb[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_LDB_URGENT_0              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_ldb[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_LDB_URGENT_1              : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_ldb[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_LDB_EXPIRED_0             : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_ldb[31:0]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_LDB_EXPIRED_1             : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_urgent_ldb[63:32]} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;

    CP_CIAL_LDB_IRQ_ACTIVE            : coverpoint {hqm_credit_hist_pipe_core.i_hqm_chp_cial_wrap.hqm_chp_int_irq_active_ldb} iff ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) ;
    CP_CIAL_LDB_TIMER_EN_X_IRQ_ACTIVE : cross CP_CIAL_LDB_TIMER_EN, CP_CIAL_LDB_IRQ_ACTIVE; // case where armed is set run_timer is set and global_timer_en=0 (special case)

  endgroup

  CG_CHP_INP_GATED_CLK u_CG_CHP_INP_GATED_CLK = new();
  CG_CHP_GATED_CLK u_CG_CHP_GATED_CLK = new();
`endif

endmodule

bind hqm_credit_hist_pipe_core hqm_credit_hist_pipe_cover i_hqm_credit_hist_pipe_cover();

`endif
