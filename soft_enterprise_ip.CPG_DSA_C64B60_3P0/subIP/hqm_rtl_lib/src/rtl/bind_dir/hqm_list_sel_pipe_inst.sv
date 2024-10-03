`ifdef INTEL_INST_ON

module hqm_list_sel_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

function automatic [3:0] enc16 ;
  input logic [11:0] dat ;
  begin
    if ( dat == 12'h000 )
      enc16 = 4'hf ;             // initial reset
    else if ( dat == 12'h001 )
      enc16 = 4'h0 ;
    else if ( dat == 12'h002 )
      enc16 = 4'h1 ;
    else if ( dat == 12'h004 )
      enc16 = 4'h2 ;
    else if ( dat == 12'h008 )
      enc16 = 4'h3 ;
    else if ( dat == 12'h010 )
      enc16 = 4'h4 ;
    else if ( dat == 12'h020 )
      enc16 = 4'h5 ;
    else if ( dat == 12'h040 )
      enc16 = 4'h6 ;
    else if ( dat == 12'h080 )
      enc16 = 4'h7 ;
    else if ( dat == 12'h100 )
      enc16 = 4'h8 ;
    else
      enc16 = 4'he ;             // error
  end
endfunction // enc16

localparam HQM_LSP_DISP_COS                     = 0 ;
localparam HQM_LSP_CQ_COS_NUM_COS               = 4 ;
localparam HQM_LSP_CQ_COS_CNT_WIDTH             = 16 ;
localparam HQM_LSP_CQ_COS_DELTA_WIDTH           = HQM_LSP_CQ_COS_CNT_WIDTH + 1 ;

   logic                                                inp_clk ;
   logic                                                inp_rst_n ;
   logic                                                clk ;
   logic                                                rst_n ;

   logic [( HQM_LSP_CFG_UNIT_NUM_TGTS )-1:0]            unit_cfg_req_write ;
   logic [( HQM_LSP_CFG_UNIT_NUM_TGTS )-1:0]            unit_cfg_req_read ;
   logic                                                dp_lsp_enq_dir_v ;
   logic                                                dp_lsp_enq_dir_ready ;
   dp_lsp_enq_dir_t                                     dp_lsp_enq_dir_data ;
   logic                                                chp_lsp_token_v ;
   logic                                                chp_lsp_token_ready ;
   chp_lsp_token_t                                      chp_lsp_token_data ;
   logic                                                lsp_dp_sch_dir_v ;
   logic                                                lsp_dp_sch_dir_ready ;
   lsp_dp_sch_dir_t                                     lsp_dp_sch_dir_data ;

   logic [HQM_LSP_ALARM_NUM_INF-1:0]                    dbg_int_inf_v_f ;
   logic [HQM_LSP_ALARM_NUM_INF-1:0]                    dbg_int_inf_v_prev_f ;
   logic [HQM_LSP_ALARM_NUM_INF-1:0]                    dbg_int_inf_v_reported_f ;
   aw_alarm_syn_t [HQM_LSP_ALARM_NUM_INF-1:0]           dbg_int_inf_data_f ;
   logic                                                dbg_stop_sim_set ;
   logic                                                dbg_stop_sim_f ;
   logic                                                dbg_lsp_continue_on_error ;
   logic [30:0]                                         dbg_cfg_syndrome0_capture_data_f ;
   logic [30:0]                                         dbg_cfg_syndrome1_capture_data_f ;

   //#############################################################################################################
   // May not need these long-term but useful now while when we're getting many completion underflow test failures
   logic                                                dbg_p8_lba_qid_if_cnt_uflow_f ;
   logic                                                dbg_p8_lba_cq_if_cnt_uflow_f ;
   logic                                                dbg_p8_lba_tot_if_cnt_uflow_f ;
   logic [6:0]                                          dbg_p8_lba_qid_f ;
   logic [5:0]                                          dbg_p8_lba_if_cnt_cq_f ;
   logic                                                dbg_p9_lba_qid_if_cnt_uflow_f ;
   logic                                                dbg_p9_lba_cq_if_cnt_uflow_f ;
   logic                                                dbg_p9_lba_tot_if_cnt_uflow_f ;
   logic [6:0]                                          dbg_p9_lba_qid_f ;
   logic [5:0]                                          dbg_p9_lba_if_cnt_cq_f ;

   logic                                                dbg_p3_direnq_tok_cnt_uflow_err_f ;
   logic [6:0]                                          dbg_p3_direnq_cq_f ;
   logic                                                dbg_p8_lba_cq_tok_cnt_uflow_err_f ;
   logic [5:0]                                          dbg_p8_lba_tok_cnt_cq_f ;
   logic                                                dbg_p4_direnq_tok_cnt_uflow_err_f ;
   logic [6:0]                                          dbg_p4_direnq_cq_f ;
   logic                                                dbg_p9_lba_cq_tok_cnt_uflow_err_f ;
   logic [5:0]                                          dbg_p9_lba_tok_cnt_cq_f ;

   logic                                                dbg_p4_lba_cq2qid_v_err_f ;
   logic [5:0]                                          dbg_p4_lba_cq_f ;
   logic                                                dbg_p5_lba_cq2qid_v_err_f ;
   logic [5:0]                                          dbg_p5_lba_cq_f ;

   logic                                                dbg_p8_lba_qid2cqidix_sch_v_err_f ;
   logic                                                dbg_p9_lba_qid2cqidix_sch_v_err_f ;
   //#############################################################################################################
   // atomic (+nalb)

   reg [63:0]                                           dbg_lsp_ap_atm_cmd_txt [3:0] ;

   reg [7:0]                                            dbg_pipe_sblast_vec ;

   //#############################################################################################################
   logic                                                dbg_p3_direnq_sch_start_f ;
   logic [7:0]                                          dbg_p3_direnq_sch_out_qid_f ;
   logic                                                dbg_p3_direnq_sch_out_f ;
   logic [1:0]                                          dbg_p3_direnq_rem_beats_f ;
   logic [2:0]                                          dbg_p3_direnq_qid_v_f ;
   logic [2:0]                                          dbg_p3_direnq_cq_avail_f ;
   logic [1:0]                                          dbg_p3_direnq_wp_f ;
   logic                                                dbg_p3_direnq_disab_opt_f ;
   logic                                                dbg_p3_direnq_first_beat_f ;

   logic                                                dbg_perf_hw_count_v_f ;
   logic                                                dbg_perf_v_f ;
   logic                                                dbg_perf_prev_v_f ;

   logic [31:0]                                         dbg_perf_0_f ;
   logic [31:0]                                         dbg_perf_1_f ;
   logic [31:0]                                         dbg_perf_2_f ;
   logic [31:0]                                         dbg_perf_3_f ;
   logic [31:0]                                         dbg_perf_5_f ;
   logic [31:0]                                         dbg_perf_7_f ;
   logic [31:0]                                         dbg_perf_0_prev_f ;
   logic [31:0]                                         dbg_perf_1_prev_f ;
   logic [31:0]                                         dbg_perf_2_prev_f ;
   logic [31:0]                                         dbg_perf_3_prev_f ;
   logic [31:0]                                         dbg_perf_5_prev_f ;
   logic [31:0]                                         dbg_perf_7_prev_f ;
   logic [31:0]                                         delta_0 ;
   logic [31:0]                                         delta_1 ;
   logic [31:0]                                         delta_2 ;
   logic [31:0]                                         delta_3 ;
   logic [31:0]                                         delta_5 ;
   logic [31:0]                                         delta_7 ;
   logic [31:0]                                         dbg_cfg_ldb_sched_perf_count_f [7:0] ;

   //----
   logic [31:0]                                         dbg_ldb_unable_to_work_pipe_lat_f ;
   logic [31:0]                                         dbg_ldb_unable_to_work_pipe_hold_f ;
   logic [31:0]                                         dbg_ldb_unable_to_work_cfg_f ;
   logic [31:0]                                         dbg_ldb_unable_to_work_blast_f ;
   logic [31:0]                                         dbg_ldb_unable_to_work_all_busy_f ;
   logic [31:0]                                         dbg_ldb_no_work_f ;
   logic [31:0]                                         dbg_ldb_no_work_batch_f ;
   logic [31:0]                                         dbg_ldb_cfg_disabled_f ;
   logic [31:0]                                         dbg_ldb_no_space_f ;
   logic [31:0]                                         dbg_ldb_ow_f ;
   logic [31:0]                                         dbg_ldb_sched_f ;
   logic                                                dbg_ldb_sched_en_f ;

   reg [71:0]           inp_err_inj_txt ;
   reg                  inp_err_inj_test ;
   reg [71:0]           aqed_err_inj_txt ;
   reg                  aqed_err_inj_test ;
   reg [71:0]           hw_err_inj_txt ;
   reg                  hw_err_inj_test ;

//*****************************************************************************************************
//*****************************************************************************************************
// Combinational
//*****************************************************************************************************
//*****************************************************************************************************
   assign inp_clk               = hqm_list_sel_pipe_core.hqm_inp_gated_clk;
   assign inp_rst_n             = hqm_list_sel_pipe_core.hqm_inp_gated_rst_n;
   assign clk                   = hqm_list_sel_pipe_core.hqm_gated_clk;
   assign rst_n                 = hqm_list_sel_pipe_core.hqm_gated_rst_n;

   assign unit_cfg_req_write    = hqm_list_sel_pipe_core.unit_cfg_req_write ;
   assign unit_cfg_req_read     = hqm_list_sel_pipe_core.unit_cfg_req_read ;
   assign dp_lsp_enq_dir_v      = hqm_list_sel_pipe_core.dp_lsp_enq_dir_v ;
   assign dp_lsp_enq_dir_ready  = hqm_list_sel_pipe_core.dp_lsp_enq_dir_ready ;
   assign dp_lsp_enq_dir_data   = hqm_list_sel_pipe_core.dp_lsp_enq_dir_data ;
   assign chp_lsp_token_v       = hqm_list_sel_pipe_core.chp_lsp_token_v ;
   assign chp_lsp_token_ready   = hqm_list_sel_pipe_core.chp_lsp_token_ready ;
   assign chp_lsp_token_data    = hqm_list_sel_pipe_core.chp_lsp_token_data ;
   assign lsp_dp_sch_dir_v      = hqm_list_sel_pipe_core.lsp_dp_sch_dir_v ;
   assign lsp_dp_sch_dir_ready  = hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready ;
   assign lsp_dp_sch_dir_data   = hqm_list_sel_pipe_core.lsp_dp_sch_dir_data ;

// Inside AW:
//   - control_f is the control register
//   - registers [15:0] are the 8 events ms and ls, (sched_perf_[7..0]).
// In our sims we will never overflow 32 bits so just look at ls halves of counters.
   always_comb begin
     dbg_cfg_ldb_sched_perf_count_f [0]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_0_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [1]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_1_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [2]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_2_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [3]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_3_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [4]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_4_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [5]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_5_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [6]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_6_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
     dbg_cfg_ldb_sched_perf_count_f [7]         = hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_7_count [31:0] ;     // ls 32 bits of 64-bit count, for each logical reg/count
   end // always

//*****************************************************************************************************
//*****************************************************************************************************
// State requiring reset
//*****************************************************************************************************
//*****************************************************************************************************

   // State which is monitoring inputs to rx_sync inputs needs to be clocked by inp_gated_clk in order to not miss initial requests during "wakeup" period
   //------------------------------------------------------------------
   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
        dbg_p3_direnq_sch_start_f               <= 1'b0 ;
        dbg_p3_direnq_sch_out_qid_f             <= 8'h0 ;
        dbg_p3_direnq_sch_out_f                 <= 1'b0 ;
        dbg_p3_direnq_rem_beats_f               <= 2'h0 ;
        dbg_p3_direnq_qid_v_f                   <= 3'h0 ;
        dbg_p3_direnq_cq_avail_f                <= 3'h0 ;
        dbg_p3_direnq_wp_f                      <= 2'h0 ;
        dbg_p3_direnq_disab_opt_f               <= 1'b0 ;
        dbg_p3_direnq_first_beat_f              <= 1'b0 ;

        dbg_int_inf_v_f                 <= '0 ;
        dbg_int_inf_v_prev_f            <= '0 ;
        dbg_int_inf_v_reported_f        <= '0 ;
        for ( int i=0; i<HQM_LSP_ALARM_NUM_INF; i++ ) begin
          dbg_int_inf_data_f [i]        <= '0 ;
        end
        dbg_cfg_syndrome0_capture_data_f        <= '0 ;
        dbg_cfg_syndrome1_capture_data_f        <= '0 ;
        dbg_stop_sim_f                  <= 1'b0 ;
        //-------------------------------------------------
        dbg_p8_lba_qid_if_cnt_uflow_f   <= 1'b0 ;
        dbg_p8_lba_cq_if_cnt_uflow_f    <= 1'b0 ;
        dbg_p8_lba_tot_if_cnt_uflow_f   <= 1'b0 ;
        dbg_p8_lba_qid_f                <= 7'h0 ;
        dbg_p8_lba_if_cnt_cq_f          <= 6'h0 ;
        dbg_p9_lba_qid_if_cnt_uflow_f   <= 1'b0 ;
        dbg_p9_lba_cq_if_cnt_uflow_f    <= 1'b0 ;
        dbg_p9_lba_tot_if_cnt_uflow_f   <= 1'b0 ;
        dbg_p9_lba_qid_f                <= 7'h0 ;
        dbg_p9_lba_if_cnt_cq_f          <= 6'h0 ;

        dbg_p3_direnq_tok_cnt_uflow_err_f       <= 1'b0 ;
        dbg_p3_direnq_cq_f                      <= 7'h0 ;
        dbg_p8_lba_cq_tok_cnt_uflow_err_f       <= 1'b0 ;
        dbg_p8_lba_tok_cnt_cq_f                 <= 6'h0 ;
        dbg_p4_direnq_tok_cnt_uflow_err_f       <= 1'b0 ;
        dbg_p4_direnq_cq_f                      <= 7'h0 ;
        dbg_p9_lba_cq_tok_cnt_uflow_err_f       <= 1'b0 ;
        dbg_p9_lba_tok_cnt_cq_f                 <= 6'h0 ;

        dbg_p4_lba_cq2qid_v_err_f       <= 1'b0 ;
        dbg_p4_lba_cq_f                 <= 6'h0 ;
        dbg_p5_lba_cq2qid_v_err_f       <= 1'b0 ;
        dbg_p5_lba_cq_f                 <= 6'h0 ;

        dbg_p8_lba_qid2cqidix_sch_v_err_f   <= 1'b0 ;
        dbg_p9_lba_qid2cqidix_sch_v_err_f   <= 1'b0 ;
        //-------------------------------------------------
        dbg_perf_hw_count_v_f <= '0 ;
        dbg_perf_v_f <= '0 ;
        dbg_perf_prev_v_f <= '0 ;
        dbg_perf_0_f <= '0 ;
        dbg_perf_1_f <= '0 ;
        dbg_perf_2_f <= '0 ;
        dbg_perf_3_f <= '0 ;
        dbg_perf_5_f <= '0 ;
        dbg_perf_7_f <= '0 ;
        dbg_perf_0_prev_f <= '0 ;
        dbg_perf_1_prev_f <= '0 ;
        dbg_perf_2_prev_f <= '0 ;
        dbg_perf_3_prev_f <= '0 ;
        dbg_perf_5_prev_f <= '0 ;
        dbg_perf_7_prev_f <= '0 ;
        //-------------------------------------------------
        dbg_ldb_unable_to_work_pipe_lat_f       <= '0 ;
        dbg_ldb_unable_to_work_pipe_hold_f      <= '0 ;
        dbg_ldb_unable_to_work_cfg_f            <= '0 ;
        dbg_ldb_unable_to_work_blast_f          <= '0 ;
        dbg_ldb_unable_to_work_all_busy_f       <= '0 ;
        dbg_ldb_no_work_f                       <= '0 ;
        dbg_ldb_no_work_batch_f                 <= '0 ;
        dbg_ldb_cfg_disabled_f                  <= '0 ;
        dbg_ldb_no_space_f                      <= '0 ;
        dbg_ldb_ow_f                            <= '0 ;
        dbg_ldb_sched_f                         <= '0 ;
        dbg_ldb_sched_en_f                      <= 1'b0 ;
      end // if rst_n
      else begin
        dbg_p3_direnq_sch_start_f               <= hqm_list_sel_pipe_core.p3_direnq_sch_start ;
        dbg_p3_direnq_sch_out_qid_f             <= hqm_list_sel_pipe_core.p3_direnq_sch_out_qid ;
        dbg_p3_direnq_sch_out_f                 <= hqm_list_sel_pipe_core.p3_direnq_sch_out ;
        dbg_p3_direnq_rem_beats_f               <= hqm_list_sel_pipe_core.p4_direnq_sch_rem_beats_nxt ;
        dbg_p3_direnq_qid_v_f                   <= hqm_list_sel_pipe_core.p4_direnq_sch_qid_v_nxt ;
        dbg_p3_direnq_cq_avail_f                <= hqm_list_sel_pipe_core.p4_direnq_sch_cq_avail_nxt ;
        dbg_p3_direnq_wp_f                      <= hqm_list_sel_pipe_core.p4_direnq_sch_wp_nxt ;
        dbg_p3_direnq_disab_opt_f               <= hqm_list_sel_pipe_core.p4_direnq_sch_disab_opt_nxt ;
        dbg_p3_direnq_first_beat_f              <= hqm_list_sel_pipe_core.p4_direnq_sch_first_beat_nxt ;

        //----------------------------------------------------------------------------

        dbg_int_inf_v_f                 <= hqm_list_sel_pipe_core.int_inf_v ;
        dbg_int_inf_v_prev_f            <= dbg_int_inf_v_f ;
        for ( int i = 0 ; i < HQM_LSP_ALARM_NUM_INF ; i++ ) begin
          dbg_int_inf_v_reported_f[i]   <= dbg_int_inf_v_reported_f[i] | ( dbg_int_inf_v_f[i] & ~ dbg_int_inf_v_prev_f [i] ) ;
          dbg_int_inf_data_f[i]         <= hqm_list_sel_pipe_core.int_inf_data[i] ;
        end
        if ( hqm_list_sel_pipe_core.cfg_syndrome0_capture_v ) begin
          dbg_cfg_syndrome0_capture_data_f      <= hqm_list_sel_pipe_core.cfg_syndrome0_capture_data ;
        end
        if ( hqm_list_sel_pipe_core.cfg_syndrome1_capture_v ) begin
          dbg_cfg_syndrome1_capture_data_f      <= hqm_list_sel_pipe_core.cfg_syndrome1_capture_data ;
        end
        dbg_stop_sim_f                  <= dbg_stop_sim_f | dbg_stop_sim_set ;

        //-------------------------------------------------
        dbg_p8_lba_qid_if_cnt_uflow_f   <= hqm_list_sel_pipe_core.p7_lba_qid_if_cnt_uflow_cond ;
        dbg_p8_lba_cq_if_cnt_uflow_f    <= hqm_list_sel_pipe_core.p7_lba_cq_if_cnt_uflow_cond ;
        dbg_p8_lba_tot_if_cnt_uflow_f   <= hqm_list_sel_pipe_core.p7_lba_tot_if_cnt_uflow_cond ;
        dbg_p8_lba_qid_f                <= hqm_list_sel_pipe_core.p7_lba_qid_if_cnt_rmw_pipe_f.qid ;
        dbg_p8_lba_if_cnt_cq_f          <= hqm_list_sel_pipe_core.p7_lba_cq_if_cnt_rmw_pipe_f.cq ;
        dbg_p9_lba_qid_if_cnt_uflow_f   <= dbg_p8_lba_qid_if_cnt_uflow_f ;
        dbg_p9_lba_cq_if_cnt_uflow_f    <= dbg_p8_lba_cq_if_cnt_uflow_f ;
        dbg_p9_lba_tot_if_cnt_uflow_f   <= dbg_p8_lba_tot_if_cnt_uflow_f ;
        dbg_p9_lba_qid_f                <= dbg_p8_lba_qid_f ;
        dbg_p9_lba_if_cnt_cq_f          <= dbg_p8_lba_if_cnt_cq_f ;

        dbg_p3_direnq_tok_cnt_uflow_err_f       <= hqm_list_sel_pipe_core.p2_direnq_tok_cnt_uflow_cond ;
        dbg_p3_direnq_cq_f                      <= hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.cq ;
        dbg_p8_lba_cq_tok_cnt_uflow_err_f       <= hqm_list_sel_pipe_core.p7_lba_cq_tok_cnt_uflow_cond ;
        dbg_p8_lba_tok_cnt_cq_f                 <= hqm_list_sel_pipe_core.p7_lba_cq_tok_cnt_rmw_pipe_f.cq ;
        dbg_p4_direnq_tok_cnt_uflow_err_f       <= dbg_p3_direnq_tok_cnt_uflow_err_f ;
        dbg_p4_direnq_cq_f                      <= dbg_p3_direnq_cq_f ;
        dbg_p9_lba_cq_tok_cnt_uflow_err_f       <= dbg_p8_lba_cq_tok_cnt_uflow_err_f ;
        dbg_p9_lba_tok_cnt_cq_f                 <= dbg_p8_lba_tok_cnt_cq_f ;

        dbg_p4_lba_cq2qid_v_err_f       <= hqm_list_sel_pipe_core.p3_lba_cq2qid_v_err_cond ;
//      dbg_p4_lba_cq_f                 <= hqm_list_sel_pipe_core.p3_lba_cq2qid_rw_pipe_f_pnc.cq ;
        dbg_p4_lba_cq_f                 <= hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_cq ;           // Should be the same as the "cq" (without pairing)
        dbg_p5_lba_cq2qid_v_err_f       <= dbg_p4_lba_cq2qid_v_err_f ;
        dbg_p5_lba_cq_f                 <= dbg_p4_lba_cq_f ;

        dbg_p8_lba_qid2cqidix_sch_v_err_f   <= hqm_list_sel_pipe_core.p7_lba_qid2cqidix_sch_v_err_cond ;
        dbg_p9_lba_qid2cqidix_sch_v_err_f   <= dbg_p8_lba_qid2cqidix_sch_v_err_f ;
        //-------------------------------------------------
        // conditions where counter regs don't load with +1.  Counts 0..7 are read-only
        dbg_perf_hw_count_v_f <=        ~ ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_ldb_sched_perf_control_reg_f [1:0] != 2'b01 ) ;

        dbg_perf_v_f <= dbg_perf_hw_count_v_f ;
        dbg_perf_prev_v_f <= 1'b1 ;             // Only time prev doesn't load with previous is on reset
        dbg_perf_0_f <= dbg_cfg_ldb_sched_perf_count_f [0] ;
        dbg_perf_1_f <= dbg_cfg_ldb_sched_perf_count_f [1] ;
        dbg_perf_2_f <= dbg_cfg_ldb_sched_perf_count_f [2] ;
        dbg_perf_3_f <= dbg_cfg_ldb_sched_perf_count_f [3] ;
        dbg_perf_5_f <= dbg_cfg_ldb_sched_perf_count_f [5] ;
        dbg_perf_7_f <= dbg_cfg_ldb_sched_perf_count_f [7] ;
        dbg_perf_0_prev_f <= dbg_perf_0_f ;
        dbg_perf_1_prev_f <= dbg_perf_1_f ;
        dbg_perf_2_prev_f <= dbg_perf_2_f ;
        dbg_perf_3_prev_f <= dbg_perf_3_f ;
        dbg_perf_5_prev_f <= dbg_perf_5_f ;
        dbg_perf_7_prev_f <= dbg_perf_7_f ;

        //-------------------------------------------------
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_pipe_frict_not_wait_work )          // hqm_lsp_target_cfg_ldb_sched_perf_3_inc [0]
          dbg_ldb_unable_to_work_pipe_lat_f         <= dbg_ldb_unable_to_work_pipe_lat_f + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_pipe_frict_wait_work_hold )         // hqm_lsp_target_cfg_ldb_sched_perf_3_inc [1]
          dbg_ldb_unable_to_work_pipe_hold_f        <= dbg_ldb_unable_to_work_pipe_hold_f  + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_pipe_frict_cause_pipe_idle  )       // hqm_lsp_target_cfg_ldb_sched_perf_3_inc [3]
          dbg_ldb_unable_to_work_cfg_f              <= dbg_ldb_unable_to_work_cfg_f + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_wait_blast  )                       // hqm_lsp_target_cfg_ldb_sched_perf_3_inc [2]
          dbg_ldb_unable_to_work_blast_f            <= dbg_ldb_unable_to_work_blast_f + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_wait_cq_busy )                      // hqm_lsp_target_cfg_ldb_sched_perf_5_inc
          dbg_ldb_unable_to_work_all_busy_f         <= dbg_ldb_unable_to_work_all_busy_f + 1 ;
        if ( dbg_ldb_sched_en_f & ( | hqm_list_sel_pipe_core.cfg_ldb_sched_perf_cq_disabled ) )                 // hqm_lsp_target_cfg_ldb_sched_perf_0_inc ( dis )
          dbg_ldb_cfg_disabled_f                    <= dbg_ldb_cfg_disabled_f + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_no_space  )                         // hqm_lsp_target_cfg_ldb_sched_perf_1_inc
          dbg_ldb_no_space_f                        <= dbg_ldb_no_space_f + 1 ;
        if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_overworked )                        // hqm_lsp_target_cfg_ldb_sched_perf_7_inc
          dbg_ldb_ow_f                              <= dbg_ldb_ow_f + 1 ;

        if ( hqm_list_sel_pipe_core.cfg_ldb_sched_perf_sched ) begin                                            // hqm_lsp_target_cfg_ldb_sched_perf_2_inc
          dbg_ldb_sched_f                           <= dbg_ldb_sched_f + 1 ;
          dbg_ldb_no_work_batch_f                   <= '0 ;
          dbg_ldb_no_work_f                         <= dbg_ldb_no_work_f + dbg_ldb_no_work_batch_f ;
        end
        else if ( dbg_ldb_sched_en_f & hqm_list_sel_pipe_core.cfg_ldb_sched_perf_no_work & ! ( | hqm_list_sel_pipe_core.cfg_ldb_sched_perf_cq_disabled ) ) begin        // hqm_lsp_target_cfg_ldb_sched_perf_0_inc ( ! dis )
          dbg_ldb_no_work_batch_f                   <= dbg_ldb_no_work_batch_f + 1 ;
        end

        if ( hqm_list_sel_pipe_core.cfg_ldb_sched_perf_sched )
          dbg_ldb_sched_en_f                        <= 1'b1 ;
      end // else rst_n
   end // always_ff


//*****************************************************************************************************
//*****************************************************************************************************
// per-clock error checking - do not condition on plusargs
//*****************************************************************************************************
//*****************************************************************************************************
   // Until error logic is tested and stable, only halt on errors induced by other units / "sw"
   // assign dbg_stop_sim_set      = | dbg_int_inf_v_f ;
   // Error injection tests intentionally cause token underflows, allow TB to supress this stop.
   assign dbg_stop_sim_set      = ( (~ $test$plusargs("HQM_INGRESS_ERROR_TEST") ) & ( dbg_int_inf_v_f [0] |dbg_int_inf_v_f [1] | dbg_int_inf_v_f [2] ) ) ;

   always_ff @(posedge clk) begin
    if ( ~ hqm_list_sel_pipe_core.rst_prep ) begin

     // If we're reporting an enqueue count underflow most likely it is due to a real qid/cq misconfig
     if ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_v & hqm_list_sel_pipe_core.p7_lba_qid_enq_cnt_uflow_cond ) begin
       $display("@%0t [%s]         LSP is about to report an enqueue count underflow on qid %x cq %x slot %d with 8-bit nalb qidixv %02x, most likely due to a cq2qid/qid2cqidix misconfig"
                , $time , hw_err_inj_txt
                , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_qid
                , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_cq
                , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_qidix
                , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_qidixv
               ) ;
     end

     for ( int i = 0 ; i < HQM_LSP_ALARM_NUM_INF ; i++ ) begin
       if ( ( dbg_int_inf_v_reported_f [i] === 1'b0 ) && ( dbg_int_inf_v_f [i] === 1'b1 ) && ( dbg_int_inf_v_prev_f [i] === 1'b0 ) ) begin      // problems w/ xprop when not spelled out like this
         if ( ( ( i == 0 ) || ( i == 1 ) || ( i == 2 ) ) ) begin
           $display("@%0t [%s]         LSP just signalled the interrupt serializer via int_inf_v bit %02d with syndrome %x, subsequent int_inf_v error messages are suppressed for that bit"
                , $time , inp_err_inj_txt , i , dbg_cfg_syndrome1_capture_data_f ) ;
         end
         else begin
           $display("@%0t [%s]         LSP just signalled the interrupt serializer via int_inf_v bit %02d with syndrome %x, subsequent int_inf_v error messages are suppressed for that bit"
                , $time , hw_err_inj_txt , i , dbg_cfg_syndrome0_capture_data_f ) ;
         end
         if ( dbg_int_inf_v_f[HQM_LSP_ALARM_NUM_INF-1:5] > 0 ) begin
           $display("@%0t [LSP_DEBUG]         Unexpected LSP interrupt, int_inf_v = %x" , $time , dbg_int_inf_v_f ) ;
         end // 0

         if ( dbg_int_inf_v_f[2]) begin
           if ( dbg_cfg_syndrome1_capture_data_f [30:0] == 31'h00000001 ) $display("@%0t [%s]         LSP interrupt 2 is due to LB CQ token count underflow for CQ %x" , $time , inp_err_inj_txt , dbg_int_inf_data_f[2].rid [HQM_NUM_LB_CQB2-1:0] ) ;
           else if ( dbg_cfg_syndrome1_capture_data_f [30:0] == 31'h00000002 ) $display("@%0t [%s]         LSP interrupt 2 is due to DIR token count underflow for CQ %x" , $time , inp_err_inj_txt , dbg_int_inf_data_f[2].rid [HQM_NUM_DIR_CQB2-1:0] ) ;
           else                                                                                            $display("@%0t [%s]         LSP interrupt 2 with unexpected sw_syndrome value %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome1_capture_data_f [30:0] ) ;
         end // 2

         if ( dbg_int_inf_v_f[1]) begin
           if ( dbg_cfg_syndrome1_capture_data_f [30:0] == 31'h00000004 ) $display("@%0t [%s]         LSP interrupt 1 is due to LB total inflight count underflow" , $time , inp_err_inj_txt ) ;
           // CHP should screen, should only get through to LSP if CHP hw failure
           else if ( dbg_cfg_syndrome1_capture_data_f [30:0] == 31'h00000008 ) $display("@%0t [%s]         LSP interrupt 1 is due to LB CQ inflight count underflow for CQ %x" , $time , hw_err_inj_txt , dbg_int_inf_data_f[1].rid [HQM_NUM_LB_CQB2-1:0] ) ;
           else                                                                                            $display("@%0t [%s]         LSP interrupt 1 with unexpected sw_syndrome value %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome1_capture_data_f [30:0] ) ;
         end // 1

         if ( dbg_int_inf_v_f[0]) begin
           if ( dbg_cfg_syndrome1_capture_data_f [30:0] == 31'h00000010 ) $display("@%0t [%s]         LSP interrupt 0 is due to LB QID inflight count underflow for QID %x" , $time , inp_err_inj_txt , dbg_int_inf_data_f[0].rid [HQM_NUM_LB_QIDB2-1:0] ) ;
           else                                                                                       $display("@%0t [%s]         LSP interrupt 0 with unexpected sw_syndrome value %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome1_capture_data_f [30:0] ) ;
         end // 0

         if ( dbg_int_inf_v_f[3]) begin
           if ( ( dbg_cfg_syndrome0_capture_data_f [30:28] < 3'h1 ) | ( dbg_cfg_syndrome0_capture_data_f [30:28] > 3'h4 ) ) $display("@%0t [%s]         LSP interrupt 3 with unexpected interrupt class %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome0_capture_data_f [30:28] ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [30:28] == 3'h1 ) begin
             if ( ( | {
                          dbg_cfg_syndrome0_capture_data_f [27]
                        , dbg_cfg_syndrome0_capture_data_f [14]
                      } ) > 1'b0 ) $display("@%0t [%s]         LSP interrupt 3 class 1 with unexpected syndrome bits set %x" , $time , hw_err_inj_txt , ( dbg_cfg_syndrome0_capture_data_f [30:0] & 32'h08004000 ) ) ;
             // 27 - spare
             if ( dbg_cfg_syndrome0_capture_data_f [26] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LBRPLY enqueue count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [25] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LBRPLY enqueue count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [24] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LBRPLY enqueue count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [23] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LBRPLY input frag count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [22] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIRRPLY enqueue count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [21] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIRRPLY enqueue count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [20] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIRRPLY enqueue count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [19] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIRRPLY input frag count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [18] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ active limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [17] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ active count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [16] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ active count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [15] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ active count residue error" , $time , hw_err_inj_txt ) ;
             // 14 - spare
             if ( dbg_cfg_syndrome0_capture_data_f [13] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ atomic active count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [12] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ enqueue count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [11] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid inflight limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [10] ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid inflight count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [9]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid inflight count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [8]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to ATQ qid depth threshold parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [7]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIR qid depth threshold parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [6]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid depth threshold parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [5]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid enqueue count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [4]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid enqueue count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [3]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to LB qid enqueue count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [2]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIR enqueue count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [1]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIR enqueue count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [0]  ) $display("@%0t [%s]         LSP interrupt 3 class 1 is due to DIR enqueue count residue error" , $time , hw_err_inj_txt ) ;
           end // interrupt 3 class 1
           if ( dbg_cfg_syndrome0_capture_data_f [30:28] == 3'h2 ) begin
             if ( dbg_cfg_syndrome0_capture_data_f [27] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB rlist cmpblast LSP set error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [26] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB rlist cmpblast AP set error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [25] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ inflight limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [24] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ inflight count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [23] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ inflight count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [22] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ token limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [21] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ token count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [20] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB CQ token count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [19] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB input token residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [18] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIR token limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [17] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIR token count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [16] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIR token count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [15] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIR input token residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [14] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to rx_sync FIFO error (see debug_00 register for details)" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [13] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to memory access error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [12] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ total active count > cfg limit" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [11] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ fid inflight count > cfg limit" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [10] ) $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ fid inflight count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [9] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ fid inflight count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [8] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LBRPLY input qid parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [7] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIRRPLY input qid parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [6] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ total active count overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [5] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ total active count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [4] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to ATQ input qid parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [3] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB total inflight count underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [2] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB input cq parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [1] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to LB input qid parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [0] )  $display("@%0t [%s]         LSP interrupt 3 class 2 is due to DIR input qid/cq parity error" , $time , hw_err_inj_txt ) ;
           end // interrupt 3 class 2
           if ( dbg_cfg_syndrome0_capture_data_f [30:28] == 3'h3 ) begin
             if ( dbg_cfg_syndrome0_capture_data_f [27] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to regfile interleaved parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [26] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to AQED DEQ credit error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [25] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to QED DEQ credit error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [24] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to WU pipeline error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [23] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB aqed deq FIFO overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [22] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB aqed deq FIFO underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [21] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB qed deq FIFO overflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [20] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB qed deq FIFO underflow" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [19] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB cq2qidpriov RAM parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [18] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB cq2qid1 RAM parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [17] ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB cq2qid0 RAM parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [15:0] > 0 ) begin
               if ( dbg_cfg_syndrome0_capture_data_f [16] == 1 ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to ATM qid2cqidix RAM parity error, RAM vector = %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome0_capture_data_f [15:0] ) ;
               if ( dbg_cfg_syndrome0_capture_data_f [16] == 0 ) $display("@%0t [%s]         LSP interrupt 3 clase 3 is due to LB qid2cqidix RAM parity error, RAM vector = %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome0_capture_data_f [15:0] ) ;
             end
           end // interrupt 3 class 3
           if ( dbg_cfg_syndrome0_capture_data_f [30:28] == 3'h4 ) begin
             if ( dbg_cfg_syndrome0_capture_data_f [27] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB wu input cq/wt parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [26] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB cq arbiter update when not valid" , $time , hw_err_inj_txt ) ;
             if ( ( | { dbg_cfg_syndrome0_capture_data_f [25:24] ,
                      dbg_cfg_syndrome0_capture_data_f [21:12] } ) > 1'b0 )
               $display("@%0t [%s]         LSP interrupt 3 class 4 is due to FIFO underflow/overflow; hw_syndrome bits = %x" , $time , hw_err_inj_txt , ( dbg_cfg_syndrome0_capture_data_f & 32'h033ff000 ) ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [23] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB wu limit parity error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [22] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB wu count residue error" , $time , hw_err_inj_txt ) ;
             if ( ( | dbg_cfg_syndrome0_capture_data_f [11:4] ) > 1'b0 )
               $display("@%0t [%s]         LSP interrupt 3 class 4 is due to pipeline error; hw_syndrome bits = %x" , $time , hw_err_inj_txt , ( dbg_cfg_syndrome0_capture_data_f & 32'h00000ff0 ) ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [3] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to ATQ fid inflight count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [2] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to ATQ total AQED enqueued count residue error" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [1] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB nalb scheduling error (abs FIFO push and full)" , $time , hw_err_inj_txt ) ;
             if ( dbg_cfg_syndrome0_capture_data_f [0] ) $display("@%0t [%s]         LSP interrupt 3 class 4 is due to LB total inflight count residue error" , $time , hw_err_inj_txt ) ;
           end // interrupt 3 class 4
         end // interrupt 3

         if ( dbg_int_inf_v_f[4]) begin
           if ( dbg_cfg_syndrome0_capture_data_f [30:28] != 3'h5 ) $display("@%0t [%s]         LSP interrupt 4 with unexpected interrupt class %x" , $time , hw_err_inj_txt , dbg_cfg_syndrome0_capture_data_f [30:28] ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [27:5] > '0 ) $display("@%0t [%s]         LSP interrupt 4 with unexpected syndrome bits set %x" , $time , hw_err_inj_txt , ( dbg_cfg_syndrome0_capture_data_f [30:0] & 32'hffffffe0 ) ) ;
           // 27:5 - spare
           if ( dbg_cfg_syndrome0_capture_data_f [4]  ) $display("@%0t [%s]         LSP interrupt 4 is due to ATQ total enqueue count residue error" , $time , hw_err_inj_txt ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [3]  ) $display("@%0t [%s]         LSP interrupt 4 is due to LB total enqueue count residue error" , $time , hw_err_inj_txt ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [2]  ) $display("@%0t [%s]         LSP interrupt 4 is due to DIR total enqueue count residue error" , $time , hw_err_inj_txt ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [1] )  $display("@%0t [%s]         LSP interrupt 4 is due to LB total schedule count residue error" , $time , hw_err_inj_txt ) ;
           if ( dbg_cfg_syndrome0_capture_data_f [0] )  $display("@%0t [%s]         LSP interrupt 4 is due to DIR total schedule count residue error" , $time , hw_err_inj_txt ) ;
         end // 4
         // Only do extra decoding for sw-caused ones - for benefit of non-specialists
         if ( dbg_int_inf_v_f[0] & ( dbg_p9_lba_qid_if_cnt_uflow_f ) ) begin
           if ( dbg_p9_lba_qid_if_cnt_uflow_f ) begin
             $display("@%0t [LSP_DEBUG]         Interrupt was due to LSP receiving more qid completions in from CHP than schedules sent out for qid %x; see EOT check messages for counts" ,
                $time ,
                dbg_p9_lba_qid_f ) ;
           end
         end
         if ( dbg_int_inf_v_f[1] & ( dbg_p9_lba_cq_if_cnt_uflow_f | dbg_p9_lba_tot_if_cnt_uflow_f ) ) begin
           if ( dbg_p9_lba_tot_if_cnt_uflow_f ) begin
             $display("@%0t [LSP_DEBUG]         Interrupt was due to LSP receiving more total completions in from CHP than schedules sent out" ,
                $time ) ;
           end
           if ( dbg_p9_lba_cq_if_cnt_uflow_f ) begin
             $display("@%0t [LSP_DEBUG]         Interrupt was due to LSP receiving more cq completions in from CHP than schedules sent out for cq %x; see EOT check messages for counts" ,
                $time ,
                dbg_p9_lba_if_cnt_cq_f ) ;
           end
         end
         if ( dbg_int_inf_v_f[2] & ( dbg_p4_direnq_tok_cnt_uflow_err_f | dbg_p9_lba_cq_tok_cnt_uflow_err_f ) ) begin
           if ( dbg_p4_direnq_tok_cnt_uflow_err_f ) begin
             $display("@%0t [LSP_DEBUG]         Interrupt was due to LSP receiving more tokens in from CHP than schedules sent out for DIR cq %x; see EOT check messages for counts" ,
                $time ,
                dbg_p4_direnq_cq_f ) ;
           end
           if ( dbg_p9_lba_cq_tok_cnt_uflow_err_f ) begin
             $display("@%0t [LSP_DEBUG]         Interrupt was due to LSP receiving more tokens in from CHP than schedules sent out for LB cq %x; see EOT check messages for counts" ,
                $time ,
                dbg_p9_lba_tok_cnt_cq_f ) ;
           end
         end
       end // if ! reported
     end // for
     if ( ( ~( $test$plusargs("HQM_DISABLE_AGITIATE_ASSERT") ) ) & ( ~ ( | hqm_list_sel_pipe_core.cfg_agitate_control_f ) ) &
             ( $test$plusargs("HQM_ENABLE_LSP_PERF_COUNT") ) &
          dbg_perf_v_f & dbg_perf_prev_v_f &
          ( ( delta_0 + delta_1 + delta_2 + delta_3 + delta_5 + delta_7 ) != 1 )
        ) begin
       $display("@%0t [LSP_DEBUG]         perf err:                0:%x      1:%x      2:%x      3:%x      5:%x      7:%x" ,
       $time ,
       dbg_perf_0_f ,
       dbg_perf_1_f ,
       dbg_perf_2_f ,
       dbg_perf_3_f ,
       dbg_perf_5_f ,
       dbg_perf_7_f ) ;
       $display("@%0t [LSP_DEBUG]         perf err:           0_prev:%x 1_prev:%x 2_prev:%x 3_prev:%x 5_prev:%x 7_prev:%x",
       $time ,
       dbg_perf_0_prev_f ,
       dbg_perf_1_prev_f ,
       dbg_perf_2_prev_f ,
       dbg_perf_3_prev_f ,
       dbg_perf_5_prev_f ,
       dbg_perf_7_prev_f ) ;
     end

    end // if ~ hqm_list_sel_pipe_core.rst_prep
   end // always

   always_comb begin
     delta_0 = dbg_perf_0_f - dbg_perf_0_prev_f ;
     delta_1 = dbg_perf_1_f - dbg_perf_1_prev_f ;
     delta_2 = dbg_perf_2_f - dbg_perf_2_prev_f ;
     delta_3 = dbg_perf_3_f - dbg_perf_3_prev_f ;
     delta_5 = dbg_perf_5_f - dbg_perf_5_prev_f ;
     delta_7 = dbg_perf_7_f - dbg_perf_7_prev_f ;
   end // always

   always_comb begin
     if ( dbg_stop_sim_f & ! dbg_lsp_continue_on_error ) begin
       $finish;
     end
   end // always

   //------------------------------------------------------------------
   //*****************************************************************************************************
   //*****************************************************************************************************
   // per-clock counters for statistics - could move to plusarg if performance is a concern
   //*****************************************************************************************************
   //*****************************************************************************************************
   //------------------------------------------------------------------

   always_comb begin
     dbg_pipe_sblast_vec [0]            = hqm_list_sel_pipe_core.p0_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p0_lba_pop_cq ;
     dbg_pipe_sblast_vec [1]            = hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [2]            = hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [3]            = hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [4]            = hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [5]            = hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [6]            = hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f ;
     dbg_pipe_sblast_vec [7]            = hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_cmpblast_cond & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f ;
   end

   // Displays which are triggered inputs to rx_sync inputs needs to be clocked by inp_gated_clk in order to not miss initial requests during "wakeup" period
   always_ff @(posedge inp_clk) begin
     //*****************************************************************************************************
     //*****************************************************************************************************
     // HIGH debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_HIGH")) begin
     end // plusarg HIGH

     //*****************************************************************************************************
     //*****************************************************************************************************
     // MED debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH") ) begin
       if ( inp_rst_n & hqm_list_sel_pipe_core.chp_lsp_cmp_v & hqm_list_sel_pipe_core.chp_lsp_cmp_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,pp/cq:%x ,qid:%x ,qe_wt:%x ,user:%x ,%m"
         ,$time
         ,"INBOUND  chp_lsp_cmp :"
         , hqm_list_sel_pipe_core.chp_lsp_cmp_data.pp
         , hqm_list_sel_pipe_core.chp_lsp_cmp_data.qid
         , hqm_list_sel_pipe_core.chp_lsp_cmp_data.qe_wt
         , hqm_list_sel_pipe_core.chp_lsp_cmp_data.user
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.qed_lsp_deq_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qe_wt:%x ,%m"
         ,$time
         ,"INBOUND  qed_lsp_deq :"
         , hqm_list_sel_pipe_core.qed_lsp_deq_data.cq
         , hqm_list_sel_pipe_core.qed_lsp_deq_data.qe_wt
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.aqed_lsp_deq_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qe_wt:%x ,%m"
         ,$time
         ,"INBOUND  aqed_lsp_deq :"
         , hqm_list_sel_pipe_core.aqed_lsp_deq_data.cq
         , hqm_list_sel_pipe_core.aqed_lsp_deq_data.qe_wt
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.chp_lsp_token_v & hqm_list_sel_pipe_core.chp_lsp_token_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,is_ldb:%x ,cq:%x ,count:%x ,%m"
         ,$time
         ,"INBOUND  chp_lsp_token :"
         , hqm_list_sel_pipe_core.chp_lsp_token_data.is_ldb
         , hqm_list_sel_pipe_core.chp_lsp_token_data.cq
         , hqm_list_sel_pipe_core.chp_lsp_token_data.count
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.nalb_lsp_enq_lb_v & hqm_list_sel_pipe_core.nalb_lsp_enq_lb_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qtype:%x ,qid:%x ,%m"
         ,$time
         ,"INBOUND  nalb_lsp_enq_lb :"
         ,hqm_list_sel_pipe_core.nalb_lsp_enq_lb_data.qtype
         ,hqm_list_sel_pipe_core.nalb_lsp_enq_lb_data.qid
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_v & hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,qtype:%x ,frag_cnt:%x ,%m"
         ,$time
         ,"INBOUND  nalb_lsp_enq_rorply :"
         , hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data.qid
         , hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data.qtype
         , hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data.frag_cnt
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.dp_lsp_enq_dir_v & hqm_list_sel_pipe_core.dp_lsp_enq_dir_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,%m"
         ,$time
         ,"INBOUND  dp_lsp_enq_dir :"
         ,hqm_list_sel_pipe_core.dp_lsp_enq_dir_data.qid
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.dp_lsp_enq_rorply_v & hqm_list_sel_pipe_core.dp_lsp_enq_rorply_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,frag_cnt:%x ,%m"
         ,$time
         ,"INBOUND  dp_lsp_enq_rorply :"
         , hqm_list_sel_pipe_core.dp_lsp_enq_rorply_data.qid
         , hqm_list_sel_pipe_core.dp_lsp_enq_rorply_data.frag_cnt
         );
       end

       if ( inp_rst_n & hqm_list_sel_pipe_core.rop_lsp_reordercmp_v & hqm_list_sel_pipe_core.rop_lsp_reordercmp_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qid:%x ,user:%x ,%m"
         ,$time
         ,"INBOUND  rop_lsp_reordercmp :"
         , hqm_list_sel_pipe_core.rop_lsp_reordercmp_data.cq
         , hqm_list_sel_pipe_core.rop_lsp_reordercmp_data.qid
         , hqm_list_sel_pipe_core.rop_lsp_reordercmp_data.user
         );
       end

     end // plusarg MED

     //*****************************************************************************************************
     //*****************************************************************************************************
     // LOW debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH") ) begin
     end // plusarg LOW

   end // always
   //------------------------------------------------------------------
   always_ff @(posedge clk) begin
     //*****************************************************************************************************
     //*****************************************************************************************************
     // HIGH debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_HIGH")) begin

       if ( hqm_list_sel_pipe_core.p0_lba_arb_winner_v & ! hqm_list_sel_pipe_core.p0_lba_ctrl_pipe.hold ) begin
         $display("@%0t [LSP_INFO]          LB: Input arbiter just selected winner: S:%x(cq=%x) E:%x(qid=%x) T:%x(cq=%x) QIDC:%x(qid=%x) CQC:%x(cq=%x)",
                $time ,
                hqm_list_sel_pipe_core.p0_lba_arb_sch_v ,
                hqm_list_sel_pipe_core.p0_lba_cq_arb_winner ,
                hqm_list_sel_pipe_core.p0_lba_arb_enq_v ,
                hqm_list_sel_pipe_core.lbi_inp_enq_qid ,
                hqm_list_sel_pipe_core.p0_lba_arb_tok_v ,
                hqm_list_sel_pipe_core.lbi_inp_tok_cq ,
                hqm_list_sel_pipe_core.p0_lba_arb_qid_cmp_v ,
                hqm_list_sel_pipe_core.lbi_inp_qid_cmp_qid ,
                hqm_list_sel_pipe_core.p0_lba_arb_cq_cmp_v ,
                hqm_list_sel_pipe_core.lbi_inp_cq_cmp_cq ) ;
       end

       if ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & ! hqm_list_sel_pipe_core.p7_lba_ctrl_pipe.hold & 
                ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_v | hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_v |
                        hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_if_dec_v ) ) begin
         $display("@%0t [LSP_INFO]          LB: p7 update for qid %x  sch=%x enq=%x cmp=%x nodec=%x dec=%x sch_v_nxt=%x if_v_nxt=%x  read qid_cqidix=%016x_%016x_%016x_%016x_%016x_%016x_%016x_%016x",
                $time ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_rw_pipe_f.qid ,
                hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_v ,
                hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_v ,
                hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_cmp_v ,
                hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid_no_dec ,
                hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_if_dec_v ,
                hqm_list_sel_pipe_core.p7_lba_qid_enq_cnt_upd_gt0 ,
                hqm_list_sel_pipe_core.p7_lba_qid_if_cnt_upd_lt_lim ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 7 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 6 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 5 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 4 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 3 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 2 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 1 * 64 ) +: 64 ] ,
                hqm_list_sel_pipe_core.p7_lba_qid2cqidix_v [ ( 0 * 64 ) +: 64 ] ) ;
       end

       //----------------------------------------------------------------------------
       if ( hqm_list_sel_pipe_core.p2_atq_enq_cnt_upd_v ) begin
         $display("@%0t [LSP_INFO]          ATQ: Updating atq_enq_cnt for qid %x from %x to %x" ,
                $time ,
                hqm_list_sel_pipe_core.p2_atq_enq_cnt_rmw_pipe_f.qid ,
                hqm_list_sel_pipe_core.p2_atq_enq_cnt_rmw_pipe_f.data.cnt ,
                hqm_list_sel_pipe_core.p2_atq_enq_cnt_upd.cnt ) ;
       end

       if ( hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_upd_v ) begin
         $display("@%0t [LSP_INFO]          ATQ: Updating aqed_act_cnt for qid %x from %x to %x" ,
                $time ,
                hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_rmw_pipe_f.qid ,
                hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_rmw_pipe_f.data.cnt ,
                hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_upd.cnt ) ;
       end

       //----------------------------------------------------------------------------
       if ( hqm_list_sel_pipe_core.p2_direnq_tok_cnt_upd_v ) begin
         $display("@%0t [LSP_INFO]          DIRENQ: Updating direnq_tok_cnt for cq %x from %x to %x" ,
                $time ,
                hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.cq ,
                hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.data.cnt ,
                hqm_list_sel_pipe_core.p2_direnq_tok_cnt_upd.cnt ) ;
       end

       if ( rst_n & dbg_p3_direnq_sch_out_f ) begin
         if ( dbg_p3_direnq_sch_start_f ) begin
           $display("@%0t [LSP_INFO]          DIRENQ: arb just started sch for qid %x: qid_v=%d, cq_avail=%d, wp=%d, disab=%d, first=%d"
                        , $time
                        , dbg_p3_direnq_sch_out_qid_f
                        , dbg_p3_direnq_qid_v_f
                        , dbg_p3_direnq_cq_avail_f
                        , dbg_p3_direnq_wp_f
                        , dbg_p3_direnq_disab_opt_f
                        , dbg_p3_direnq_first_beat_f ) ;
         end
         else begin
           $display("@%0t [LSP_INFO]          DIRENQ: arb just continued sch for qid %x: qid_v=%d, cq_avail=%d, wp=%d, disab=%d, first=%d, rem_beats=%d"
                        , $time
                        , dbg_p3_direnq_sch_out_qid_f
                        , dbg_p3_direnq_qid_v_f
                        , dbg_p3_direnq_cq_avail_f
                        , dbg_p3_direnq_wp_f
                        , dbg_p3_direnq_disab_opt_f
                        , dbg_p3_direnq_first_beat_f
                        , dbg_p3_direnq_rem_beats_f ) ;
         end
       end
       //----------------------------------------------------------------------------


       //-------------------------------------------------
       if ( rst_n & hqm_list_sel_pipe_core.p0_lba_cq_arb_update & ( HQM_LSP_DISP_COS > 0 ) ) begin
         $display("@%0t [LSP_INFO] CQ_COS ###################################################################" , $time );
         $display("@%0t [LSP_INFO] CQ_COS reqs=0x%016x, p0_reqs=0x%016x, upd=%0d, winner_v_int=%0d, winner=0x%02x (%s), index_f_3210=0x%01x%01x%01x%01x"
                , $time
                , hqm_list_sel_pipe_core.p0_nxt_lba_cq_arb_reqs
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.p0_reqs_f
                , hqm_list_sel_pipe_core.p0_lba_cq_arb_update
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.winner_v_int
                , hqm_list_sel_pipe_core.p0_lba_cq_arb_winner
                , ( hqm_list_sel_pipe_core.i_lba_cq_cos_arb.winner_v_int==1 )
                    ? ( hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v )
                        ? "RND"
                        : ( hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_winner_v )
                            ? "NEQ"
                            : "EQ "
                    : "---"
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.gen_cq_cos_arb_cos_arb[3].i_hqm_AW_rr_arb_cos.index_f
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.gen_cq_cos_arb_cos_arb[2].i_hqm_AW_rr_arb_cos.index_f
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.gen_cq_cos_arb_cos_arb[1].i_hqm_AW_rr_arb_cos.index_f
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.gen_cq_cos_arb_cos_arb[0].i_hqm_AW_rr_arb_cos.index_f ) ;
         $display("@%0t [LSP_INFO] CQ_COS cfg_range_3210=%03x %03x %03x %03x  cos_bw_count_3210=%02x %02x %02x %02x  cos_bw_req_count_3210=%01x %01x %01x %01x  index_f=%0d update=%01d"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_range_ar[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_range_ar[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_range_ar[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_range_ar[0]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[0]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[0]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.i_hqm_AW_rr_arb_rnd.index_f
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_arb_update ) ;
         $display("@%0t [LSP_INFO] CQ_COS cos_winner_v_3210=0x%01x, cos_winner_3210=0x%04x, rnd_winner_raw_v=%0d, rnd_cfg=%0d, rnd_winner_v=%0d, rnd_cosnum=0x%0d, cos_arb_update=0x%01x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_winner_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_winner
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_raw_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_configured
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_cosnum
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_arb_update ) ;
         $display("@%0t [LSP_INFO] CQ_COS cos_count_f_3210=    %04x %04x %04x %04x, cos_sel_f_3210=%01x%01x%01x%01x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_f [ ( 3 * HQM_LSP_CQ_COS_CNT_WIDTH ) +: HQM_LSP_CQ_COS_CNT_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_f [ ( 2 * HQM_LSP_CQ_COS_CNT_WIDTH ) +: HQM_LSP_CQ_COS_CNT_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_f [ ( 1 * HQM_LSP_CQ_COS_CNT_WIDTH ) +: HQM_LSP_CQ_COS_CNT_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_f [ ( 0 * HQM_LSP_CQ_COS_CNT_WIDTH ) +: HQM_LSP_CQ_COS_CNT_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_sel_f[7:6]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_sel_f[5:4]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_sel_f[3:2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_sel_f[1:0] ) ;
         $display("@%0t [LSP_INFO] CQ_COS cos_count_delta_3210=%05x %05x %05x %05x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_delta [ ( 3 * HQM_LSP_CQ_COS_DELTA_WIDTH ) +: HQM_LSP_CQ_COS_DELTA_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_delta [ ( 2 * HQM_LSP_CQ_COS_DELTA_WIDTH ) +: HQM_LSP_CQ_COS_DELTA_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_delta [ ( 1 * HQM_LSP_CQ_COS_DELTA_WIDTH ) +: HQM_LSP_CQ_COS_DELTA_WIDTH ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_count_delta [ ( 0 * HQM_LSP_CQ_COS_DELTA_WIDTH ) +: HQM_LSP_CQ_COS_DELTA_WIDTH ] ) ;
         $display("@%0t [LSP_INFO] CQ_COS neqcount arb: reqs=%01x, winner_v=%0d, winner=%01d, count_tied=%01x, cosnum=%0d"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_arb_reqs
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_winner_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_winner
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_tied
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_cosnum ) ;
         $display("@%0t [LSP_INFO] CQ_COS bkup_winner_v=%0d, neqcount_winner_tied=%0d, bkup_cosnum_pre_ovr=%0d, bkup_cosnum=%0d"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_winner_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.neqcount_winner_tied
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_cosnum_pre_ovr
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.bkup_cosnum ) ;
         $display("@%0t [LSP_INFO] CQ_COS seq_arb_used=%0d, cos_seq_f=0x%02x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_used
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_seq_f ) ;
         $display("@%0t [LSP_INFO] CQ_COS cos_eq_f_3210=%01x%01x%01x%01x, cos_eq_v_3210=%01x%01x%01x%01x, seq_arb: eligible=0x%01x, reqs=0x%01x, winner=0x%01d, winner_v=%0d, cosnum=0x%0d"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_f [ ( 3 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_f [ ( 2 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_f [ ( 1 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_f [ ( 0 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_v [ ( 3 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_v [ ( 2 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_v [ ( 1 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_eq_v [ ( 0 * HQM_LSP_CQ_COS_NUM_COS ) +: HQM_LSP_CQ_COS_NUM_COS ]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_eligible
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_reqs
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_winner
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_winner_v
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.seq_arb_cosnum ) ;
         $display("@%0t [LSP_INFO] CQ_COS rnd_winner_lost_opp=%d, cfg_starv_avoid_enable=%d, starv_avoid_count_update=%d, inc3210=%01x, dec3210=%01x, clr3210=%01x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.rnd_winner_lost_opp
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_starv_avoid_enable
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_update_cond
                , {   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_inc[3]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_inc[2]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_inc[1]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_inc[0] }
                , {   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_dec[3]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_dec[2]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_dec[1]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_dec[0] }
                , {   hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_clr[3]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_clr[2]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_clr[1]
                    , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_clr[0] } ) ;
         $display("@%0t [LSP_INFO] CQ_COS starv_avoid_arb_reqs=0x%01x, tot=%0d, thr max/min=0x%03x/0x%03x, cnt3=0x%03x, cnt2=0x%03x, cnt1=0x%03x, cnt0=0x%03x, high_pri_ovr=%0d, rmupd=%0d"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_arb_reqs
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_arb_reqs_tot
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_starv_avoid_thresh_max
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cfg_starv_avoid_thresh_min
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[0]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_high_pri_override_cond
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_arb_update ) ;
         $display("@%0t [LSP_INFO] CQ_COS ###################################################################" , $time );
       end
       if ( rst_n & hqm_list_sel_pipe_core.i_lba_cq_cos_arb.update_prev_f & ( HQM_LSP_DISP_COS > 0 ) ) begin
         $display("@%0t [LSP_INFO] CQ_COS ###################################################################" , $time );
         $display("@%0t [LSP_INFO] CQ_COS sch_rdy_count            : 0x%016x"
                , $time
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_sch_rdy_count ) ;
         $display("@%0t [LSP_INFO] CQ_COS schd_cos_counts_3210     : 0x%016x 0x%016x 0x%016x 0x%016x"
                , $time
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos3_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos2_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos1_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos0_count ) ;
         $display("@%0t [LSP_INFO] CQ_COS rdy_cos_counts_3210      : 0x%016x 0x%016x 0x%016x 0x%016x"
                , $time
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos3_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos2_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos1_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos0_count ) ;
         $display("@%0t [LSP_INFO] CQ_COS rnd_loss_cos_counts_3210 : 0x%016x 0x%016x 0x%016x 0x%016x"
                , $time
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos3_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos2_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos1_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos0_count ) ;
         $display("@%0t [LSP_INFO] CQ_COS cnt_win_cos_counts_3210  : 0x%016x 0x%016x 0x%016x 0x%016x"
                , $time
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos3_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos2_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos1_count
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos0_count ) ;
         $display("@%0t [LSP_INFO] CQ_COS cos_bw_count_3210=%02x %02x %02x %02x  cos_bw_req_count_3210=%01x %01x %01x %01x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_count_f[0]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.cos_bw_req_count_f[0] ) ;
         $display("@%0t [LSP_INFO] CQ_COS cnt3=0x%03x, cnt2=0x%03x, cnt1=0x%03x, cnt0=0x%03x"
                , $time
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[3]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[2]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[1]
                , hqm_list_sel_pipe_core.i_lba_cq_cos_arb.starv_avoid_count_f[0] ) ;
         $display("@%0t [LSP_INFO] CQ_COS ###################################################################" , $time );
       end
       //-------------------------------------------------
     end // plusarg HIGH

     //*****************************************************************************************************
     //*****************************************************************************************************
     // MED debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH") ) begin
       for ( int i = 0 ; i < HQM_LSP_CFG_UNIT_NUM_TGTS ; i++) begin
         if ( rst_n & unit_cfg_req_write [ i ] ) begin
           $display("@%0t [LSP_DEBUG] ,%-30s ,target:%02x ,%m"
           ,$time
           , "CFG_WRITE :"
           , i
           ) ;
         end
         if ( rst_n & unit_cfg_req_read [ i ] ) begin
           $display("@%0t [LSP_DEBUG] ,%-30s ,target:%02x ,%m"
           ,$time
           , "CFG_READ  :"
           , i
           ) ;
         end
       end // for i

       if ( rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v & hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qid:%x ,qidix:%x ,flags.cm:%x ,flags.wb_opt:%x ,flags.ign_cqdepth:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_nalb_sch_unoord :"
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.cq
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.qid
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.qidix
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.hqm_core_flags.congestion_management
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.hqm_core_flags.write_buffer_optimization
         , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.hqm_core_flags.ignore_cq_depth
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.lsp_dp_sch_dir_v & hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qid:%x ,qidix:%x ,flags.cm:%x ,flags.wb_opt:%x ,flags.ign_cqdepth:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_dp_sch_dir :"
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.cq
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.qid
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.qidix
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.congestion_management
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.write_buffer_optimization
         , hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.ignore_cq_depth
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.lsp_ap_atm_v & hqm_list_sel_pipe_core.lsp_ap_atm_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cmd:%s ,cq:%x ,qid:%x ,qidix:%x ,flags.cm:%x ,flags.wb_opt:%x ,flags.ign_cqdepth:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_ap_atm:"
         , dbg_lsp_ap_atm_cmd_txt [ hqm_list_sel_pipe_core.lsp_ap_atm_data.cmd ]
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.cq
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.qid
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.qidix
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.hqm_core_flags.congestion_management
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.hqm_core_flags.write_buffer_optimization
         , hqm_list_sel_pipe_core.lsp_ap_atm_data.hqm_core_flags.ignore_cq_depth
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_v & hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_nalb_sch_rorply :"
         , hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_data.qid
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.lsp_dp_sch_rorply_v & hqm_list_sel_pipe_core.lsp_dp_sch_rorply_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_dp_sch_rorply :"
         , hqm_list_sel_pipe_core.lsp_dp_sch_rorply_data.qid
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.lsp_nalb_sch_atq_v & hqm_list_sel_pipe_core.lsp_nalb_sch_atq_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,%m"
         ,$time
         ,"OUTBOUND lsp_nalb_sch_atq :"
         , hqm_list_sel_pipe_core.lsp_nalb_sch_atq_data.qid
         ) ;
       end

//       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_enq_v_nc & hqm_list_sel_pipe_core.ap_lsp_enq_ready ) begin
       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_enq_v_nc ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_enq :"
         , hqm_list_sel_pipe_core.ap_lsp_enq_data_nc.qid
         ) ;
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_haswork_slst_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qidix:%x ,qid:%x ,func:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_haswork_slst :"
         , hqm_list_sel_pipe_core.ap_lsp_cq
         , hqm_list_sel_pipe_core.ap_lsp_qidix
         , hqm_list_sel_pipe_core.ap_lsp_qid_nc
         , hqm_list_sel_pipe_core.ap_lsp_haswork_slst_func
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_unblast_slst_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qidix:%x ,qid:%x ,func:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_unblast_slst :"
         , hqm_list_sel_pipe_core.ap_lsp_cq
         , hqm_list_sel_pipe_core.ap_lsp_qidix
         , hqm_list_sel_pipe_core.ap_lsp_qid_nc
         , hqm_list_sel_pipe_core.ap_lsp_haswork_slst_func
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,func:%x ,qid:%x ,qid2cqqidix:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_haswork_rlst :"
         , hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_func
         , hqm_list_sel_pipe_core.ap_lsp_qid_nc
         , hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_unblast_rlst_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,qid:%x ,qid2cqqidix:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_unblast_rlst_v :"
         , hqm_list_sel_pipe_core.ap_lsp_qid_nc
         , hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_unblast_cmpblast ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qidix:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_unblast_cmpblast :"
         , hqm_list_sel_pipe_core.ap_lsp_cq
         , hqm_list_sel_pipe_core.ap_lsp_qidix
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.ap_lsp_cmpblast_v ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qidix:%x ,qid:%x ,cmpblstchkv:%x ,pipe_sblast_vec=%x ,qid2cqqidix:%x ,%m"
         ,$time
         ,"INBOUND  ap_lsp_cmpblast :"
         , hqm_list_sel_pipe_core.ap_lsp_cq
         , hqm_list_sel_pipe_core.ap_lsp_qidix
         , hqm_list_sel_pipe_core.ap_lsp_qid_nc
         , hqm_list_sel_pipe_core.p0_lba_cmpblast_chkv_f [ { hqm_list_sel_pipe_core.ap_lsp_cq , hqm_list_sel_pipe_core.ap_lsp_qidix } ]
         , dbg_pipe_sblast_vec
         , hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix
         );
       end

       if ( rst_n & hqm_list_sel_pipe_core.aqed_lsp_sch_v & hqm_list_sel_pipe_core.aqed_lsp_sch_ready ) begin
         $display( "@%0t [LSP_DEBUG] ,%-30s ,cq:%x ,qid:%x ,qidix:%x ,%m"
         ,$time
         ,"INBOUND  aqed_lsp_sch :"
         , hqm_list_sel_pipe_core.aqed_lsp_sch_data.cq
         , hqm_list_sel_pipe_core.aqed_lsp_sch_data.qid
         , hqm_list_sel_pipe_core.aqed_lsp_sch_data.qidix
         ) ;
       end
     end // plusarg MED

     //*****************************************************************************************************
     //*****************************************************************************************************
     // LOW debug messages
     //*****************************************************************************************************
     //*****************************************************************************************************
     if ( $test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH") ) begin
     end // plusarg LOW

   end // always_ff

//*****************************************************************************************************
//*****************************************************************************************************
// initial block
//*****************************************************************************************************
//*****************************************************************************************************
   initial begin
     $display("@%0tps [LSP_DEBUG] hqm_list_sel_pipe initial block ...",$time);

      $display("@%0tps [DM_LSP_DEBUG] LSP UNIT VERSION = %x (%d decimal)"
        , $time
        , hqm_list_sel_pipe_core.VERSION
        , hqm_list_sel_pipe_core.VERSION
      ) ;

     dbg_lsp_continue_on_error          = $test$plusargs("LSP_CONTINUE_ON_ERROR") ;
     dbg_lsp_ap_atm_cmd_txt [0]         = "--CMP---" ;
     dbg_lsp_ap_atm_cmd_txt [1]         = "SCH_RLST" ;
     dbg_lsp_ap_atm_cmd_txt [2]         = "SCH_SLST" ;
     dbg_lsp_ap_atm_cmd_txt [3]         = "-ERROR--" ;

     if ( $test$plusargs("HQM_LSP_CQ_QID_CFG_CHECK_DIS") ) begin
       $display("@%0t [LSP_INFO] Note: LSP assertions based on CQ <> QID configuration are disabled by plusarg", $time ) ;
     end

     if ( ( $test$plusargs("HQM_INGRESS_ERROR_TEST") ) || ( $test$plusargs("HQM_PARTIAL_TOKEN_RETURN") ) ) begin
       inp_err_inj_test = 1 ;
       inp_err_inj_txt  = "LSP_DEBUG" ;
     end
     else begin
       inp_err_inj_test = 0 ;
       inp_err_inj_txt  = "LSP_ERROR" ;
     end

     if ( $test$plusargs("HQM_AQED_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
       aqed_err_inj_test        = 1 ;
       aqed_err_inj_txt         = "LSP_DEBUG" ;
     end
     else begin
       aqed_err_inj_test        = 0 ;
       aqed_err_inj_txt         = "LSP_ERROR" ;
     end

     if ( $test$plusargs("HQM_LSP_ERROR_INJECTION_TEST") ) begin
       hw_err_inj_test  = 1 ;
       hw_err_inj_txt   = "LSP_DEBUG" ;
       $display("@%0t [LSP_INFO] Note: All LSP fail messages are supressed by plusarg", $time ) ;
     end
     else begin
       hw_err_inj_test  = 0 ;
       hw_err_inj_txt   = "LSP_ERROR" ;
     end

   end // initial

//*****************************************************************************************************
//*****************************************************************************************************
// final block
//*****************************************************************************************************
//*****************************************************************************************************
   final begin
     integer    dbg_ldb_unable_to_work_total ;
     real       dbg_re_ldb_unable_to_work_total ;
     real       dbg_ldb_unable_to_work_pct ;
     real       dbg_re_ldb_unable_to_work_pipe_lat ;
     real       dbg_ldb_unable_to_work_pipe_lat_pct ;
     real       dbg_re_ldb_unable_to_work_pipe_hold ;
     real       dbg_ldb_unable_to_work_pipe_hold_pct ;
     real       dbg_re_ldb_unable_to_work_cfg ;
     real       dbg_ldb_unable_to_work_cfg_pct ;
     real       dbg_re_ldb_unable_to_work_blast ;
     real       dbg_ldb_unable_to_work_blast_pct ;
     real       dbg_re_ldb_unable_to_work_all_busy ;
     real       dbg_ldb_unable_to_work_all_busy_pct ;
     real       dbg_re_ldb_no_work ;
     real       dbg_ldb_no_work_pct ;
     real       dbg_re_ldb_cfg_disabled ;
     real       dbg_ldb_cfg_disabled_pct ;
     real       dbg_re_ldb_no_space ;
     real       dbg_ldb_no_space_pct ;
     real       dbg_re_ldb_ow ;
     real       dbg_ldb_ow_pct ;
     real       dbg_re_ldb_sched ;
     real       dbg_ldb_sched_pct ;
     integer    dbg_ldb_total ;
     real       dbg_re_ldb_total ;

     dbg_ldb_unable_to_work_total     =   dbg_ldb_unable_to_work_pipe_lat_f +
                                          dbg_ldb_unable_to_work_pipe_hold_f +
                                          dbg_ldb_unable_to_work_cfg_f +
                                          dbg_ldb_unable_to_work_blast_f +
                                          dbg_ldb_unable_to_work_all_busy_f ;

     dbg_ldb_total                      = dbg_ldb_unable_to_work_total +
                                          dbg_ldb_no_work_f +
                                          dbg_ldb_cfg_disabled_f +
                                          dbg_ldb_no_space_f +
                                          dbg_ldb_ow_f +
                                          dbg_ldb_sched_f ;

     if ( dbg_ldb_total == 0 ) begin
       dbg_re_ldb_total                         = 0 ;

       dbg_re_ldb_unable_to_work_total          = 0 ;
       dbg_ldb_unable_to_work_pct               = 0 ;

       dbg_re_ldb_unable_to_work_pipe_lat       = 0 ;
       dbg_ldb_unable_to_work_pipe_lat_pct      = 0 ;

       dbg_re_ldb_unable_to_work_pipe_hold      = 0 ;
       dbg_ldb_unable_to_work_pipe_hold_pct     = 0 ;

       dbg_re_ldb_unable_to_work_cfg            = 0 ;
       dbg_ldb_unable_to_work_cfg_pct           = 0 ;

       dbg_re_ldb_unable_to_work_blast          = 0 ;
       dbg_ldb_unable_to_work_blast_pct         = 0 ;

       dbg_re_ldb_unable_to_work_all_busy       = 0 ;
       dbg_ldb_unable_to_work_all_busy_pct      = 0 ;

       dbg_re_ldb_no_work                       = 0 ;
       dbg_ldb_no_work_pct                      = 0 ;

       dbg_re_ldb_cfg_disabled                  = 0 ;
       dbg_ldb_cfg_disabled_pct                 = 0 ;

       dbg_re_ldb_no_space                      = 0 ;
       dbg_ldb_no_space_pct                     = 0 ;

       dbg_re_ldb_ow                            = 0 ;
       dbg_ldb_ow_pct                           = 0 ;

       dbg_re_ldb_sched                         = 0 ;
       dbg_ldb_sched_pct                        = 0 ;
     end
     else begin
       dbg_re_ldb_total                         = dbg_ldb_total ;

       dbg_re_ldb_unable_to_work_total          = dbg_ldb_unable_to_work_total ;
       dbg_ldb_unable_to_work_pct               = 100 * dbg_re_ldb_unable_to_work_total / dbg_re_ldb_total ;

       dbg_re_ldb_unable_to_work_pipe_lat       = dbg_ldb_unable_to_work_pipe_lat_f ;
       dbg_ldb_unable_to_work_pipe_lat_pct      = 100 * dbg_re_ldb_unable_to_work_pipe_lat / dbg_re_ldb_total ;

       dbg_re_ldb_unable_to_work_pipe_hold      = dbg_ldb_unable_to_work_pipe_hold_f ;
       dbg_ldb_unable_to_work_pipe_hold_pct     = 100 * dbg_re_ldb_unable_to_work_pipe_hold / dbg_re_ldb_total ;

       dbg_re_ldb_unable_to_work_cfg            = dbg_ldb_unable_to_work_cfg_f ;
       dbg_ldb_unable_to_work_cfg_pct           = 100 * dbg_re_ldb_unable_to_work_cfg / dbg_re_ldb_total ;

       dbg_re_ldb_unable_to_work_blast          = dbg_ldb_unable_to_work_blast_f ;
       dbg_ldb_unable_to_work_blast_pct         = 100 * dbg_re_ldb_unable_to_work_blast / dbg_re_ldb_total ;

       dbg_re_ldb_unable_to_work_all_busy       = dbg_ldb_unable_to_work_all_busy_f ;
       dbg_ldb_unable_to_work_all_busy_pct      = 100 * dbg_re_ldb_unable_to_work_all_busy / dbg_re_ldb_total ;

       dbg_re_ldb_no_work                       = dbg_ldb_no_work_f ;
       dbg_ldb_no_work_pct                      = 100 * dbg_re_ldb_no_work / dbg_re_ldb_total ;

       dbg_re_ldb_cfg_disabled                  = dbg_ldb_cfg_disabled_f ;
       dbg_ldb_cfg_disabled_pct                 = 100 * dbg_re_ldb_cfg_disabled / dbg_re_ldb_total ;

       dbg_re_ldb_no_space                      = dbg_ldb_no_space_f ;
       dbg_ldb_no_space_pct                     = 100 * dbg_re_ldb_no_space / dbg_re_ldb_total ;

       dbg_re_ldb_ow                            = dbg_ldb_ow_f ;
       dbg_ldb_ow_pct                           = 100 * dbg_re_ldb_ow / dbg_re_ldb_total ;

       dbg_re_ldb_sched                         = dbg_ldb_sched_f ;
       dbg_ldb_sched_pct                        = 100 * dbg_re_ldb_sched / dbg_re_ldb_total ;
     end

     $display("@%0tps [LSP_DEBUG] hqm_list_sel_pipe final block ...",$time);
     if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

       $display("@%0t [LSP_DEBUG] #####################################################################################################" , $time ) ;
       $display("@%0t [LSP_DEBUG] ####### Final CQ COS scheduling totals for LSP" , $time ) ;
       $display("@%0t [LSP_DEBUG]" , $time ) ;
       $display("@%0t [LSP_DEBUG] Total sch : %01d%08x                                    COS 3     COS 2     COS 1     COS 0"
                , $time
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_sch_rdy_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_sch_rdy_count [31:0]
               ) ;
       $display("@%0t [LSP_DEBUG]                                                        --------- --------- --------- ---------" , $time ) ;
       $display("@%0t [LSP_DEBUG] Number of sch from COS                                 %01d%08x %01d%08x %01d%08x %01d%08x"
                , $time
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos3_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos3_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos2_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos2_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos1_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos1_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos0_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_schd_cos0_count [31:0]
               ) ;
       $display("@%0t [LSP_DEBUG] Number of sch COS had room and work                    %01d%08x %01d%08x %01d%08x %01d%08x"
                , $time
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos3_count  [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos3_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos2_count  [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos2_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos1_count  [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos1_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos0_count  [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rdy_cos0_count [31:0]
               ) ;
       $display("@%0t [LSP_DEBUG] Number of sch COS rnd-selected but had no room or work %01d%08x %01d%08x %01d%08x %01d%08x"
                , $time
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos3_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos3_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos2_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos2_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos1_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos1_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos0_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_rnd_loss_cos0_count [31:0]
               ) ;
       $display("@%0t [LSP_DEBUG] Number of sch COS selected by backup arbiter           %01d%08x %01d%08x %01d%08x %01d%08x"
                , $time
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos3_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos3_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos2_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos2_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos1_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos1_count [31:0]
                , ( | ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos0_count [63:32] ) )
                , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cnt_win_cos0_count [31:0]
               ) ;
       $display("@%0t [LSP_DEBUG] Credit count                                                %04x      %04x      %04x      %04x"
                , $time
                , hqm_list_sel_pipe_core.cfg_credit_cnt_cos3 [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_cnt_cos2 [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_cnt_cos1 [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_cnt_cos0 [15:0]
               ) ;
       $display("@%0t [LSP_DEBUG]" , $time ) ;
       $display("@%0t [LSP_DEBUG] Configuration:" , $time ) ;
       $display("@%0t [LSP_DEBUG]                                   Range max         :        %03x       %03x       %03x       %03x"
                , $time
                , hqm_list_sel_pipe_core.cfg_range_cos3_f [8:0]
                , hqm_list_sel_pipe_core.cfg_range_cos2_f [8:0]
                , hqm_list_sel_pipe_core.cfg_range_cos1_f [8:0]
                , hqm_list_sel_pipe_core.cfg_range_cos0_f [8:0]
               ) ;
       $display("@%0t [LSP_DEBUG]                                   Credit saturation :       %04x      %04x      %04x      %04x"
                , $time
                , hqm_list_sel_pipe_core.cfg_credit_sat_cos3_f [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_sat_cos2_f [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_sat_cos1_f [15:0]
                , hqm_list_sel_pipe_core.cfg_credit_sat_cos0_f [15:0]
               ) ;
       $display("@%0t [LSP_DEBUG]                                   No Extra Credit   :          %01x         %01x         %01x         %01x"
                , $time
                , hqm_list_sel_pipe_core.cfg_no_extra_credit3_f
                , hqm_list_sel_pipe_core.cfg_no_extra_credit2_f
                , hqm_list_sel_pipe_core.cfg_no_extra_credit1_f
                , hqm_list_sel_pipe_core.cfg_no_extra_credit0_f
               ) ;
       $display("@%0t [LSP_DEBUG]" , $time ) ;

       $display("@%0t [LSP_DEBUG] #####################################################################################################" , $time ) ;
       $display("@%0t [LSP_DEBUG] ####### Final LB scheduling performance counts for LSP" , $time ) ;
       $display("@%0t [LSP_DEBUG]" , $time ) ;
       $display("@%0t [LSP_DEBUG] Clock counts from first LSP LDB schedule to the last LSP LDB schedule:" , $time ) ;
       $display("@%0t [LSP_DEBUG] " , $time ) ;
       $display("@%0t [LSP_DEBUG]   Unable to work                                        %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_total
                , dbg_ldb_unable_to_work_pct ) ;
       $display("@%0t [LSP_DEBUG]     Unable to work (LSP 1/8 pipe latency)                                   %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_pipe_lat_f
                , dbg_ldb_unable_to_work_pipe_lat_pct ) ;
       $display("@%0t [LSP_DEBUG]     Unable to work (pipeline hold)                                          %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_pipe_hold_f
                , dbg_ldb_unable_to_work_pipe_hold_pct ) ;
       $display("@%0t [LSP_DEBUG]     Unable to work (cfg access)                                             %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_cfg_f
                , dbg_ldb_unable_to_work_cfg_pct ) ;
       $display("@%0t [LSP_DEBUG]     Unable to work (pipeline blasting)                                      %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_blast_f
                , dbg_ldb_unable_to_work_blast_pct ) ;
       $display("@%0t [LSP_DEBUG]     Unable to work (all ready-to-work CQs are busy)                         %8d %5.1f %%"
                , $time
                , dbg_ldb_unable_to_work_all_busy_f
                , dbg_ldb_unable_to_work_all_busy_pct ) ;
       $display("@%0t [LSP_DEBUG]   No work to do                                         %8d %5.1f %%"
                , $time
                , dbg_ldb_no_work_f
                , dbg_ldb_no_work_pct ) ;
       $display("@%0t [LSP_DEBUG]   All ready-to-work CQs disabled by cfg                 %8d %5.1f %%"
                , $time
                , dbg_ldb_cfg_disabled_f
                , dbg_ldb_cfg_disabled_pct ) ;
       $display("@%0t [LSP_DEBUG]   All ready-to-work, cfg-enabled CQs don't have space   %8d %5.1f %%"
                , $time
                , dbg_ldb_no_space_f
                , dbg_ldb_no_space_pct ) ;
       $display("@%0t [LSP_DEBUG]   All ready-to-work, cfg-enabled CQs with space are ow  %8d %5.1f %%"
                , $time
                , dbg_ldb_ow_f
                , dbg_ldb_ow_pct ) ;
       $display("@%0t [LSP_DEBUG]   Schedule                                              %8d %5.1f %%"
                , $time
                , dbg_ldb_sched_f
                , dbg_ldb_sched_pct ) ;
       $display("@%0t [LSP_DEBUG]   ==============================================================" , $time ) ;
       $display("@%0t [LSP_DEBUG]   Total                                                 %8d"
                , $time
                , dbg_ldb_total ) ;
       $display("@%0t [LSP_DEBUG]                                                                                             " , $time ) ;
       $display("@%0t [LSP_DEBUG] Notes:                                                                                      " , $time ) ;
       $display("@%0t [LSP_DEBUG] - Pipeline hold is caused by backpressure from AP.                                          " , $time ) ;
       $display("@%0t [LSP_DEBUG] - 'ready-to-work' means the LSP scheduling state machine is ready to schedule, and the CQ   " , $time ) ;
       $display("@%0t [LSP_DEBUG]   has work to do and is not temporarily supressed by pipeline blasting.                     " , $time ) ;
       $display("@%0t [LSP_DEBUG] - For NALB traffic the 'has work' term also include includes the per-QID inflight check.    " , $time ) ;
       $display("@%0t [LSP_DEBUG] - 'CQ has space' includes the token count and per-CQ inflight checks, and the total         " , $time ) ;
       $display("@%0t [LSP_DEBUG]   inflight check.                                                                           " , $time ) ;
       $display("@%0t [LSP_DEBUG] - NALB blasting is 1 additional pipeline clock of protection required to account for        " , $time ) ;
       $display("@%0t [LSP_DEBUG]   QIDs which are mapped to multple CQs/slots.                                               " , $time ) ;
       $display("@%0t [LSP_DEBUG] - ATM blasting protects all instances of a QID from the time LSP schedules it until the AP  " , $time ) ;
       $display("@%0t [LSP_DEBUG]   updates its rlist/slist status.  In these statistics it also includes the per-QID inflight" , $time ) ;
       $display("@%0t [LSP_DEBUG]   check and 'completion blasting'.                                                          " , $time ) ;
       $display("@%0t [LSP_DEBUG] #####################################################################################################" , $time ) ;

     end // if plusarg

   end // final

//##############################################
//JTC: include debug file(s) here
//##############################################

`endif

task eot_check (output bit pf);
logic   fail ;
logic [31:0] cfg_interface_mask ;

  fail = 0 ;

  // If the HQM_INGRESS_ERROR_TEST pluarg is true, the error injection test may cause LSP to receive too many or too few tokens or completions.
  // If the HQM_PARTIAL_TOKEN_RETURN plusarg is true, the error injection test may be intentionally returning too few tokens.
  //-------------------------------------------------------------------------------------------------
  // Unit state checks
  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_unit_idle_reg_f[1] == 0 ) begin       // .unit_idle = lsp_unit_idle_local
    if (   hqm_list_sel_pipe_core.cfg_unit_idle_f.pipe_idle
         | hqm_list_sel_pipe_core.cfg_lbwu_pipe_idle
         | hqm_list_sel_pipe_core.dir_tokrtn_fifo_empty
         | hqm_list_sel_pipe_core.ldb_token_rtn_fifo_empty
         | hqm_list_sel_pipe_core.uno_atm_cmp_fifo_empty
         | hqm_list_sel_pipe_core.nalb_cmp_fifo_empty
         | hqm_list_sel_pipe_core.atm_cmp_fifo_empty
         | hqm_list_sel_pipe_core.enq_nalb_fifo_empty
         | hqm_list_sel_pipe_core.enq_atq_db_status_pnc [1:0]
         | hqm_list_sel_pipe_core.lsp_dp_sch_dir_tx_sync_idle
         | hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_tx_sync_idle
         | hqm_list_sel_pipe_core.atq_sel_ap_tx_sync_idle
         | hqm_list_sel_pipe_core.rpl_ldb_nalb_tx_sync_idle
         | hqm_list_sel_pipe_core.rpl_dir_dp_tx_sync_idle
         | hqm_list_sel_pipe_core.nalb_sel_nalb_fifo_empty
         | hqm_list_sel_pipe_core.cfg_lba_cq_arb_reqs_f
         | hqm_list_sel_pipe_core.cfg_direnq_arb_reqs_f
         | hqm_list_sel_pipe_core.cfg_atq_arb_winner_v_f
         | hqm_list_sel_pipe_core.cfg_qid_dir_replay_v_f
         | hqm_list_sel_pipe_core.cfg_qid_ldb_replay_v_f
         | hqm_list_sel_pipe_core.cfg_lba_atm_haswork ) begin
      fail      = 1 ;
      $display("@%0t [%s]         eot_check failed because unit_idle_local was 0" , $time , hw_err_inj_txt ) ;
      $display("@%0t [%s]             cfg_unit_idle_f.pipe_idle                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_unit_idle_f.pipe_idle ) ;
      $display("@%0t [%s]             cfg_lbwu_pipe_idle                                   = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_lbwu_pipe_idle ) ;
      $display("@%0t [%s]             dir_tokrtn_fifo_empty                                = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.dir_tokrtn_fifo_empty ) ;
      $display("@%0t [%s]             ldb_token_rtn_fifo_empty                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.ldb_token_rtn_fifo_empty ) ;
      $display("@%0t [%s]             uno_atm_cmp_fifo_empty                               = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.uno_atm_cmp_fifo_empty ) ;
      $display("@%0t [%s]             nalb_cmp_fifo_empty                                  = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.nalb_cmp_fifo_empty ) ;
      $display("@%0t [%s]             atm_cmp_fifo_empty                                   = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.atm_cmp_fifo_empty ) ;
      $display("@%0t [%s]             enq_nalb_fifo_empty                                  = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.enq_nalb_fifo_empty ) ;
      $display("@%0t [%s]             enq_atq_db_status [1:0]                              = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.enq_atq_db_status_pnc [1:0] ) ;
      $display("@%0t [%s]             lsp_dp_sch_dir_tx_sync_idle                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.lsp_dp_sch_dir_tx_sync_idle ) ;
      $display("@%0t [%s]             lsp_nalb_sch_unoord_tx_sync_idle                     = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_tx_sync_idle ) ;
      $display("@%0t [%s]             atq_sel_ap_tx_sync_idle                              = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.atq_sel_ap_tx_sync_idle ) ;
      $display("@%0t [%s]             rpl_ldb_nalb_tx_sync_idle                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.rpl_ldb_nalb_tx_sync_idle ) ;
      $display("@%0t [%s]             rpl_dir_dp_tx_sync_idle                              = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.rpl_dir_dp_tx_sync_idle ) ;
      $display("@%0t [%s]             nalb_sel_nalb_fifo_empty                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.nalb_sel_nalb_fifo_empty ) ;
      $display("@%0t [%s]             cfg_lba_cq_arb_reqs_f                                = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_lba_cq_arb_reqs_f ) ;
      $display("@%0t [%s]             cfg_direnq_arb_reqs_f                                = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_direnq_arb_reqs_f ) ;
      $display("@%0t [%s]             cfg_atq_arb_winner_v_f                               = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_atq_arb_winner_v_f ) ;
      $display("@%0t [%s]             cfg_qid_dir_replay_v_f                               = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_qid_dir_replay_v_f ) ;
      $display("@%0t [%s]             cfg_qid_ldb_replay_v_f                               = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_qid_ldb_replay_v_f ) ;
      $display("@%0t [%s]             cfg_lba_atm_haswork                                  = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_lba_atm_haswork ) ;
    end

    if ( ( hqm_list_sel_pipe_core.cfg_control_include_tok_unit_idle == 1 ) &
         (   hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_DIR_TOK_V ]
           | hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_TOK_V ] ) ) begin
      if ( inp_err_inj_test ) begin
        $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
      end
      else begin
        fail  = 1 ;
        $display("@%0t [%s]         eot_check failed because unit_idle_local was 0" , $time , hw_err_inj_txt ) ;
      end
      $display("@%0t [%s]             ( cfg_control_include_tok_unit_idle == 1 )" , $time , inp_err_inj_txt ) ;
      $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_DIR_TOK_V ] = %x" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_DIR_TOK_V ] ) ;
      $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_LB_TOK_V ]  = %x" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_TOK_V ] ) ;
    end

    if ( ( hqm_list_sel_pipe_core.cfg_control_include_cmp_unit_idle == 1 ) &
           hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CMP_V ] ) begin
      if ( inp_err_inj_test ) begin
        $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
      end
      else begin
        fail  = 1 ;
        $display("@%0t [%s]         eot_check failed because unit_idle_local was 0" , $time , hw_err_inj_txt) ;
      end
      $display("@%0t [%s]             ( cfg_control_include_cmp_unit_idle == 1 )" , $time , inp_err_inj_txt ) ;
      $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_LB_CMP_V ]  = %x" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CMP_V ] ) ;
    end
  end

  // Terms which are not in hw unit_idle but which we know should be "idle" when simulation is complete
  if ( ( ~ hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_AQED_EMPTY ] ) & aqed_err_inj_test ) begin
    $display("@%0t [LSP_DEBUG]         eot_check failure(s) checking of cfg_diagnostic_status_0 AQED_EMPTY supressed because of aqed error injection plusarg" , $time ) ;
  end
  if (   ( hqm_list_sel_pipe_core.dir_tokrtn_db_status_pnc [1:0] != 0 )
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_SLIST_BLAST ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_RLIST_BLAST ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NALB_V ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NALB_BLAST ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CMPBLAST_CHKV ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CMPBLAST ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_ATQ_QID_DIS ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CQ_BUSY ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_STOP_ATQATM ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NSN_FCERR_RPTD ]
       | ( ( ~ hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_AQED_EMPTY ] ) & ( ~ aqed_err_inj_test ) )
       | ( ~ hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_ATM_IF_V ] )
       | ( ~ hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_TOT_IF_V ] )
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CQ_NO_SPACE ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT0 ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT1 ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT2 ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT3 ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_QED_CRED_AFULL ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_AQED_CRED_AFULL ]
       | hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LBA_OW_ANY ]
     ) begin
    fail      = 1 ;
    $display("@%0t [%s]         eot_check failed because one or more of the following were not idle:" , $time , hw_err_inj_txt ) ;
    $display("@%0t [%s]             dir_tokrtn_db_status                                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.dir_tokrtn_db_status_pnc [1:0] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_SLIST_BLAST ]       = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_SLIST_BLAST ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_RLIST_BLAST ]       = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_RLIST_BLAST ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_NALB_V ]            = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NALB_V ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_NALB_BLAST ]        = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NALB_BLAST ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_CMPBLAST_CHKV ]     = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CMPBLAST_CHKV ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_CMPBLAST ]          = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CMPBLAST ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_ATQ_QID_DIS ]       = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_ATQ_QID_DIS ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_CQ_BUSY ]           = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CQ_BUSY ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_STOP_ATQATM ]       = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_STOP_ATQATM ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_NSN_FCERR_RPTD ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_NSN_FCERR_RPTD ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_AQED_EMPTY ]        = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_AQED_EMPTY ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_ATM_IF_V ]          = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_ATM_IF_V ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_TOT_IF_V ]          = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_TOT_IF_V ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_CQ_NO_SPACE ]       = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_CQ_NO_SPACE ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT0 ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT0 ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT1 ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT1 ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT2 ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT2 ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT3 ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CQARB_STAT3 ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_QED_CRED_AFULL ]    = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_QED_CRED_AFULL ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_AQED_CRED_AFULL ]   = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_AQED_CRED_AFULL ] ) ;
    $display("@%0t [%s]             hqm_lsp_target_cfg_diagnostic_status_0_status [ HQM_LSP_CFG_DIAG_0_LBA_OW_ANY ]        = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_status_0_status [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LBA_OW_ANY ] ) ;
  end // if

  if ( ( hqm_list_sel_pipe_core.cfg_control_include_tok_unit_idle == 0 ) &
       (   hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_DIR_TOK_V ]
         | hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_TOK_V ] ) ) begin
    if ( inp_err_inj_test ) begin
      $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
    end
    else begin
      fail  = 1 ;
      $display("@%0t [%s]         eot_check failed because one or more of the following were not idle:" , $time , hw_err_inj_txt ) ;
    end
    $display("@%0t [%s]             ( cfg_control_include_tok_unit_idle == 0 )" , $time , inp_err_inj_txt ) ;
    $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_DIR_TOK_V ] = %x (0=idle)" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_DIR_TOK_V ] ) ;
    $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_LB_TOK_V ]  = %x (0=idle)" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_TOK_V ] ) ;
  end

  if ( ( hqm_list_sel_pipe_core.cfg_control_include_cmp_unit_idle == 0 ) &
         hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CMP_V ] ) begin
    if ( inp_err_inj_test ) begin
      $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
    end
    else begin
      fail  = 1 ;
      $display("@%0t [%s]         eot_check failed because one or more of the following were not idle:" , $time , hw_err_inj_txt ) ;
    end
    $display("@%0t [%s]             ( cfg_control_include_cmp_unit_idle == 0 )" , $time , inp_err_inj_txt ) ;
    $display("@%0t [%s]             cfg_diag_status_0_f [ HQM_LSP_CFG_DIAG_0_LB_CMP_V ]  = %x (0=idle)" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_0_f [ hqm_list_sel_pipe_core.HQM_LSP_CFG_DIAG_0_LB_CMP_V ] ) ;
  end

  if ( hqm_list_sel_pipe_core.p0_lba_cq_ow_f > 0  ) begin
    fail  = 1 ;
    $display("@%0t [%s]         eot_check failed because per-CQ over-work-limit vector p0_lba_cq_ow_f was not zero: %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.p0_lba_cq_ow_f ) ;
  end

  if ( hqm_list_sel_pipe_core.cfg_fid_inflight_count_f > 0  ) begin
    if ( inp_err_inj_test ) begin
      $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
    end
    else begin
      fail  = 1 ;
      $display("@%0t [%s]         eot_check failed because one or more of the following were not idle:" , $time , hw_err_inj_txt ) ;
    end
    $display("@%0t [%s]             cfg_fid_inflight_count_f                                     = %x (0=idle)" , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.cfg_fid_inflight_count_f ) ;
  end

  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_f > 0  ) begin    // includes residue
    if ( inp_err_inj_test ) begin
      $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
    end
    else begin
      fail  = 1 ;
      $display("@%0t [%s]         eot_check failed because the following was not idle:" , $time , hw_err_inj_txt ) ;
    end
    $display("@%0t [%s]         LB: eot_check failed because lb total if count was > 0 (%x)"
             , $time , inp_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_f ) ;
  end

  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f > 0 ) begin       // Include residue
    if ( aqed_err_inj_test ) begin
      $display("@%0t [LSP_DEBUG]         LB: eot_check hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f failure supressed because of aqed error injection plusarg" , $time ) ;
    end
    else begin
      fail      = 1 ;
    end
    $display("@%0t [%s]         LB: eot_check failed because hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f was > 0 (%x)"
             , $time , aqed_err_inj_txt, hqm_list_sel_pipe_core.hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f ) ;
  end // if

  // cfg_interface_status_r
  cfg_interface_mask            = 32'hd55fffff ;        // Don't check ready signals from other units, could temporarily = 0 when LSP clocks turned off, captured in status reg
  if ( $test$plusargs("HQM_DISABLE_AGITIATE_ASSERT") ) begin
    cfg_interface_mask [31]     = 1'b0 ;                // With agitation lsp_ap_atm_ready could artificially = 0 when LSP clocks turned off.  Without
                                                        // agitation this shouldn't be possible since atm_unit_idle is part of lsp idle.
  end

  if ( ~ ( ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f & cfg_interface_mask ) == 32'h0 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because interface_status cfg register was non-idle (0=idle)" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         lsp_ap_atm_v {hold,v}           = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [31:30] ) ;
    $display("@%0tps [%s]         lsp_nalb_sch_unoord {hold,v}    = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [29:28] ) ;
    $display("@%0tps [%s]         lsp_nalb_sch_atq {hold,v}       = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [27:26] ) ;
    $display("@%0tps [%s]         lsp_dp_sch_dir {hold,v}         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [25:24] ) ;
    $display("@%0tps [%s]         lsp_nalb_sch_rorply {hold,v}    = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [23:22] ) ;
    $display("@%0tps [%s]         lsp_dp_sch_rorply {hold,v}      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [21:20] ) ;
    $display("@%0tps [%s]         chp_lsp_token {hold,v}          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [15:14] ) ;
    $display("@%0tps [%s]         chp_lsp_cmp {hold,v}            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [13:12] ) ;
    $display("@%0tps [%s]         rop_lsp_reordercmp {hold,v}     = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [11:10] ) ;
    $display("@%0tps [%s]         nalb_lsp_enq_lb{hold,v}         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [ 9: 8] ) ;
    $display("@%0tps [%s]         nalb_lsp_enq_rorply {hold,v}    = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [ 7: 6] ) ;
    $display("@%0tps [%s]         dp_lsp_enq_dir {hold,v}         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [ 5: 4] ) ;
    $display("@%0tps [%s]         dp_lsp_enq_rorply {hold,v}      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [ 3: 2] ) ;
    $display("@%0tps [%s]         send_atm_to_cq {hold,v}         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_interface_status_reg_f [ 1: 0] ) ;
  end

  // cfg_diagnostic_aw_status_r
  if ( ~ ( ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status & 32'hefffffff ) == 32'h08000000 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because diagnostic_aw_status cfg register was non-idle (0=idle except where indicated)" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         int_ser_up {hold,v}                      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[27:26] ) ;
    $display("@%0tps [%s]         int_ser_down {hold,v} (expect hold=1)    = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[25:24] ) ;
    $display("@%0tps [%s]         dir_tokrtn_db {hold,v}                   = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[19:18] ) ;
    $display("@%0tps [%s]         enq_atq_db {hold,v}                      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[17:16] ) ;
    $display("@%0tps [%s]         ldb_token_rtn_fifo {afull,v}             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[11:10] ) ;
    $display("@%0tps [%s]         uno_atm_cmp_fifo {afull,v}               = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[ 9: 8] ) ;
    $display("@%0tps [%s]         nalb_cmp_fifo {afull,v}                  = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[ 7: 6] ) ;
    $display("@%0tps [%s]         enq_nalb_fifo {afull,v}                  = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[ 5: 4] ) ;
    $display("@%0tps [%s]         atm_cmp_fifo {afull,v}                   = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[ 3: 2] ) ;
    $display("@%0tps [%s]         nalb_sel_nalb_fifo {afull,v}             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_diagnostic_aw_status_status[ 1: 0] ) ;
  end

  // cfg_pipe_health_hold_00_r
  if ( ~ ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status [31:0] == 0 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because pipe_health_hold_00 cfg register was non-zero" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         p4_ldb_sch_hold                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[27] ) ;
    $display("@%0tps [%s]         p4_ldb_pipe_hold                        = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[26] ) ;
    $display("@%0tps [%s]         p4_ldb_atm_cred_hold                    = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[25] ) ;
    $display("@%0tps [%s]         p4_ldb_nalb_cred_hold                   = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[24] ) ;
    $display("@%0tps [%s]         p9_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[9] ) ;
    $display("@%0tps [%s]         p8_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[8] ) ;
    $display("@%0tps [%s]         p7_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[7] ) ;
    $display("@%0tps [%s]         p6_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[6] ) ;
    $display("@%0tps [%s]         p5_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[5] ) ;
    $display("@%0tps [%s]         p4_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[4] ) ;
    $display("@%0tps [%s]         p3_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[3] ) ;
    $display("@%0tps [%s]         p2_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[2] ) ;
    $display("@%0tps [%s]         p1_ldb_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_00_status[1] ) ;
  end

  // cfg_pipe_health_hold_01_r
  if ( ~ ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status [31:0] == 0 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because pipe_health_hold_01 cfg register was non-zero" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         p4_lbrpl_sch_hold                       = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[28] ) ;
    $display("@%0tps [%s]         p3_lbrpl_hold                           = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[27] ) ;
    $display("@%0tps [%s]         p2_lbrpl_hold                           = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[26] ) ;
    $display("@%0tps [%s]         p1_lbrpl_hold                           = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[25] ) ;
    $display("@%0tps [%s]         p0_lbrpl_hold                           = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[24] ) ;
    $display("@%0tps [%s]         p4_dirrpl_sch_hold                      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[20] ) ;
    $display("@%0tps [%s]         p3_dirrpl_hold                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[19] ) ;
    $display("@%0tps [%s]         p2_dirrpl_hold                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[18] ) ;
    $display("@%0tps [%s]         p1_dirrpl_hold                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[17] ) ;
    $display("@%0tps [%s]         p0_dirrpl_hold                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[16] ) ;
    $display("@%0tps [%s]         p4_atq_sch_hold                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[12] ) ;
    $display("@%0tps [%s]         p3_atq_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[11] ) ;
    $display("@%0tps [%s]         p2_atq_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[10] ) ;
    $display("@%0tps [%s]         p1_atq_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[9] ) ;
    $display("@%0tps [%s]         p0_atq_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[8] ) ;
    $display("@%0tps [%s]         p4_dir_sch_hold                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[4] ) ;
    $display("@%0tps [%s]         p3_dir_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[3] ) ;
    $display("@%0tps [%s]         p2_dir_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[2] ) ;
    $display("@%0tps [%s]         p1_dir_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[1] ) ;
    $display("@%0tps [%s]         p0_dir_hold                             = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_hold_01_status[0] ) ;
  end


  // cfg_pipe_health_valid_00_r
  if ( ~ ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status == 0 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because pipe_health_valid_00 cfg register was non-zero" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         p8_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[8] ) ;
    $display("@%0tps [%s]         p7_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[7] ) ;
    $display("@%0tps [%s]         p6_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[6] ) ;
    $display("@%0tps [%s]         p5_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[5] ) ;
    $display("@%0tps [%s]         p4_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[4] ) ;
    $display("@%0tps [%s]         p3_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[3] ) ;
    $display("@%0tps [%s]         p2_ldb_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[2] ) ;
    $display("@%0tps [%s]         p1_ldb_cq_valid                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_00_status[1] ) ;
  end

  // cfg_pipe_health_valid_01_r
  if ( ~ ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status == 0 ) ) begin
    fail      = 1 ;
    $display("@%0tps [%s]       eot_check failed because pipe_health_valid_01 cfg register was non-zero" , $time , hw_err_inj_txt ) ;
    $display("@%0tps [%s]         p4_lbrpl_sch_valid                      = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[28] ) ;
    $display("@%0tps [%s]         p3_lbrpl_valid                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[27] ) ;
    $display("@%0tps [%s]         p2_lbrpl_valid                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[26] ) ;
    $display("@%0tps [%s]         p1_lbrpl_valid                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[25] ) ;
    $display("@%0tps [%s]         p0_lbrpl_valid                          = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[24] ) ;
    $display("@%0tps [%s]         p4_dirrpl_sch_valid                     = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[20] ) ;
    $display("@%0tps [%s]         p3_dirrpl_valid                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[19] ) ;
    $display("@%0tps [%s]         p2_dirrpl_valid                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[18] ) ;
    $display("@%0tps [%s]         p1_dirrpl_valid                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[17] ) ;
    $display("@%0tps [%s]         p0_dirrpl_valid                         = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[16] ) ;
    $display("@%0tps [%s]         p4_atq_sch_valid                        = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[12] ) ;
    $display("@%0tps [%s]         p3_atq_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[11] ) ;
    $display("@%0tps [%s]         p2_atq_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[10] ) ;
    $display("@%0tps [%s]         p1_atq_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[9] ) ;
    $display("@%0tps [%s]         p0_atq_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[8] ) ;
    $display("@%0tps [%s]         p4_dir_sch_valid                        = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[4] ) ;
    $display("@%0tps [%s]         p3_dir_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[3] ) ;
    $display("@%0tps [%s]         p2_dir_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[2] ) ;
    $display("@%0tps [%s]         p1_dir_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[1] ) ;
    $display("@%0tps [%s]         p0_dir_valid                            = %x" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_pipe_health_valid_01_status[0] ) ;
  end

  if ( $test$plusargs("HQM_PARTIAL_TOKEN_RETURN") ) begin
    $display("@%0tps [LSP_INFO] Note: eot_check error token count checking partially disabled by HQM_PARTIAL_TOKEN_RETURN plusarg" , $time ) ;
  end

  if ( $test$plusargs("HQM_INGRESS_ERROR_TEST") ) begin
    $display("@%0tps [LSP_INFO] Note: eot_check error checking partially disabled by HQM_INGRESS_ERROR_TEST plusarg" , $time ) ;
  end
  else begin
    // cfg_syndrome_sw_r
    if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_syndrome_sw_syndrome_data [31] == 1'b1 ) begin
      fail      = 1 ;
      $display("@%0tps [%s]     eot_check failed because syndrome_sw cfg register was valid" , $time , hw_err_inj_txt ) ;
    end
  end // if plusarg

  // cfg_syndrome_hw_r
  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_syndrome_hw_syndrome_data [31] == 1'b1 ) begin
      fail      = 1 ;
      $display("@%0tps [%s]     eot_check failed because syndrome_hw cfg register was valid" , $time , hw_err_inj_txt ) ;
  end

  //-------------------------------------------------------------------------------------------------
  // Unit port checks - captured in MASTER
  if ( hqm_list_sel_pipe_core.lsp_unit_idle == 0 ) begin
    fail      = 1 ;
    $display("@%0t [%s]         eot_check failed because lsp_unit_idle was 0" , $time , hw_err_inj_txt ) ;
    $display("@%0t [%s]           aqed_unit_idle                          = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.aqed_unit_idle ) ;
    $display("@%0t [%s]           ap_unit_idle                            = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.ap_unit_idle ) ;
    $display("@%0t [%s]           wire_lsp_unit_idle                      = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.wire_lsp_unit_idle ) ;
    $display("@%0t [%s]             cfg_idle                              = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_idle ) ;
    $display("@%0t [%s]             int_idle                              = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.int_idle ) ;
    $display("@%0t [%s]             rst_prep                              = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.rst_prep ) ;
    $display("@%0t [%s]             hqm_gated_rst_n_active                = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_gated_rst_n_active ) ;
    $display("@%0t [%s]             co_dly_next                           = %x (0=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.i_hqm_AW_module_clock_control.i_hqm_AW_module_clock_control_core.co_dly_next ) ;
    $display("@%0t [%s]               lsp_unit_idle_local                 = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.lsp_unit_idle_local ) ;
    $display("@%0t [%s]               atm_clk_idle                        = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.atm_clk_idle ) ;
    $display("@%0t [%s]               aqed_clk_idle                       = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.aqed_clk_idle ) ;
    $display("@%0t [%s]               cfg_rx_idle                         = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_rx_idle ) ;
    $display("@%0t [%s]               chp_lsp_token_rx_sync_idle          = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.chp_lsp_token_rx_sync_idle ) ;
    $display("@%0t [%s]               chp_lsp_cmp_rx_sync_idle            = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.chp_lsp_cmp_rx_sync_idle ) ;
    $display("@%0t [%s]               rop_lsp_reordercmp_rx_sync_idle     = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.rop_lsp_reordercmp_rx_sync_idle ) ;
    $display("@%0t [%s]               nalb_lsp_enq_lb_rx_sync_idle        = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.nalb_lsp_enq_lb_rx_sync_idle ) ;
    $display("@%0t [%s]               dp_lsp_enq_dir_rx_sync_idle         = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.dp_lsp_enq_dir_rx_sync_idle ) ;
    $display("@%0t [%s]               dp_lsp_enq_rorply_rx_sync_idle      = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.dp_lsp_enq_rorply_rx_sync_idle ) ;
    $display("@%0t [%s]               send_atm_to_cq_rx_sync_idle         = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.send_atm_to_cq_rx_sync_idle ) ;
    $display("@%0t [%s]               nalb_lsp_enq_rorply_rx_sync_idle    = %x (1=idle)" , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_rx_sync_idle ) ;
  end

  //-------------------------------------------------------------------------------------------------
  // Unit model EOT checks
  // Terms which are not in hw unit_idle but which we know should be "idle" when simulation is complete, not visible via config registers
  if ( hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc !== 0 ) begin
    fail      = 1 ;
    $display("@%0t [%s]         eot_check failed because one or more of the following were not zero:" , $time , hw_err_inj_txt ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [00] = %x  Some DIR CQ >= token limit             " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [00] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [01] = %x  Some DIR QID has work to do            " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [01] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [02] = %x  Some ATQ QID >= AQED active limit      " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [02] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [03] = %x  Some ATQ QID has work to do            " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [03] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [04] = %x  Some LB QID >= qid inflight limit      " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [04] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [05] = %x  Some LB CQ >= cq inflight limit        " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [05] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [06] = %x  Some LB CQ >= token limit              " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [06] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [07] = %x  Some NALB QID has work to do           " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [07] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [08] = %x  Some ORD QID has DIR frag work to do   " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [08] ) ;
    $display("@%0t [%s]             cfg_diagnostic_status_4 [09] = %x  Some ORD QID has LB frag work to do    " , $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_4_f_nc [09] ) ;
  end // if

  // cfg_diag_status_2 (non-synth)
  if ( hqm_list_sel_pipe_core.cfg_diag_status_2_f[2:0] != 0 ) begin
      fail      = 1 ;
      $display("@%0tps [%s]     eot_check failed because cfg_diag_status_2 was valid (nonzero)" , $time , hw_err_inj_txt ) ;
      $display("@%0tps [%s]         qid2cqidix_enq err   = %d  qid=0x%x", $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_2_f [2] ,  hqm_list_sel_pipe_core.cfg_diag_status_2_f [31:24] ) ;
      $display("@%0tps [%s]         qid2cqidix_sch err   = %d  qid=0x%x", $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_2_f [1] ,  hqm_list_sel_pipe_core.cfg_diag_status_2_f [23:16] ) ;
      $display("@%0tps [%s]         cq2qid err           = %d   cq=0x%x", $time , hw_err_inj_txt , hqm_list_sel_pipe_core.cfg_diag_status_2_f [0] ,  hqm_list_sel_pipe_core.cfg_diag_status_2_f [15: 8] ) ;
  end

  // hqm_lsp_target_cfg_debug_00_reg_f - non-synth
  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_debug_00_reg_f [31:0] != 0 ) begin
      fail      = 1 ;
      $display("@%0tps [%s]     eot_check failed because hqm_lsp_target_cfg_debug_00_reg_f was nonzero, some 'impossible' hardware error occurred" , $time , hw_err_inj_txt ) ;
      $display("@%0tps [%s]         hqm_lsp_target_cfg_debug_00_reg_f = 0x%x", $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_debug_00_reg_f ) ;
  end

  // hqm_lsp_target_cfg_debug_01_reg_f - non-synth
  if ( hqm_list_sel_pipe_core.hqm_lsp_target_cfg_debug_01_reg_f [31:0] != 0 ) begin
      fail      = 1 ;
      $display("@%0tps [%s]     eot_check failed because hqm_lsp_target_cfg_debug_01_reg_f was nonzero, some 'impossible' condition beyond the detect_feature threshold occurred" , $time , hw_err_inj_txt ) ;
      $display("@%0tps [%s]         hqm_lsp_target_cfg_debug_01_reg_f = 0x%x", $time , hw_err_inj_txt , hqm_list_sel_pipe_core.hqm_lsp_target_cfg_debug_01_reg_f ) ;
  end

  for ( int i = 0 ; i < HQM_NUM_LB_QID ; i++ ) begin
    if ( hqm_list_sel_pipe_core.cfg_qid_atq_aqed_avail_status [ i ] != 1 ) begin
      fail      = 1 ;
      $display("@%0t [%s]         LB: eot_check failed because cfg_qid_atq_aqed_avail_status for qid %02x was != 1"
               , $time , hw_err_inj_txt , i ) ;
    end // if
    if ( hqm_list_sel_pipe_core.cfg_qid_ldb_if_v_status [ i ] != 1 ) begin
      fail      = 1 ;
      $display("@%0t [%s]         LB: eot_check failed because cfg_qid_ldb_if_v_status for qid %02x was != 1"
               , $time , hw_err_inj_txt , i ) ;
    end // if
  end // for i

  for ( int i = 0 ; i < HQM_NUM_LB_CQ ; i++ ) begin
    if ( hqm_list_sel_pipe_core.cfg_cq_ldb_if_v_status [ i ] != 1 ) begin
      fail      = 1 ;
      $display("@%0t [%s]         LB: eot_check failed because cfg_cq_ldb_if_v_status for cq %02x was != 1"
               , $time , hw_err_inj_txt , i ) ;
    end // if
    if ( hqm_list_sel_pipe_core.cfg_cq_ldb_thr_v_status [ i ] != 1 ) begin
      fail      = 1 ;
      $display("@%0t [%s]         LB: eot_check failed because cfg_cq_ldb_thr_v_status for cq %02x was != 1"
               , $time , hw_err_inj_txt , i ) ;
    end // if

    if ( hqm_list_sel_pipe_core.cfg_cq_ldb_tok_v_status [ i ] != 1 ) begin
      if ( inp_err_inj_test ) begin
        $display("@%0t [LSP_DEBUG]         eot_check failure(s) supressed because of input error injection plusarg" , $time ) ;
      end
      else begin
        fail  = 1 ;
        $display("@%0t [%s]         eot_check failed because one or more of the following were not idle:" , $time , hw_err_inj_txt ) ;
      end
      $display("@%0t [%s]         LB: eot_check failed because cfg_cq_ldb_tok_v_status for cq %02x was != 1"
               , $time , inp_err_inj_txt , i ) ;
    end
  end // for i


  //-------------------------------------------------------------------------------------------------
  //Unit feature report - none

  pf = fail ; //pass=0

endtask : eot_check

endmodule

bind hqm_list_sel_pipe_core hqm_list_sel_pipe_inst i_hqm_list_sel_pipe_inst();

`endif
