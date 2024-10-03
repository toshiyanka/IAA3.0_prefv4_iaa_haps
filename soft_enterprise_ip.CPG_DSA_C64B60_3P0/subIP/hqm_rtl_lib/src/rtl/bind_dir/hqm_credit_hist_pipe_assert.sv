`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_credit_hist_pipe_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

logic int_inf_0_mask , int_inf_1_mask , int_inf_2_mask ;
logic int_unc_mask ;
logic int_cor_mask ;

always_comb begin
  int_inf_0_mask = 1'b0 ;
  int_inf_1_mask = 1'b0 ;
  int_inf_2_mask = 1'b0 ;
  int_unc_mask = 1'b0 ;
  int_cor_mask = 1'b0 ;

  if ($test$plusargs("HQM_AQED_QED_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 16 ] ) ;
  end

  if ($test$plusargs("HQM_AQED_QED_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 20 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_HCW_ENQ_USER_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 11 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_HCW_ENQ_DATA_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 12 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 15 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_OUT_OF_CREDIT_TEST") ) begin
    int_inf_1_mask = int_inf_1_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 1 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_EXCESS_FRAG_TEST") ) begin
    int_inf_1_mask = int_inf_1_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 2 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_EXCESS_COMP_TEST") ) begin
    int_inf_1_mask = int_inf_1_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 3 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_RELEASE_QTYPE_TEST") ) begin
    int_inf_1_mask = int_inf_1_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 4 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_EXCESS_TOKEN_TEST") ) begin
    int_inf_2_mask = int_inf_2_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 5 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_INGRESS_ERROR_EXCESS_TOKEN_TEST") ) begin
    int_inf_2_mask = int_inf_2_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data [ 7 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_SCHPIPE_HCW_MB_INJECTION_TEST") ) begin
    int_unc_mask = int_unc_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 7 ] ) |
                                  ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 5 ] ) ;
  end

  if ($test$plusargs("HQM_CHP_SCHPIPE_HCW_SB_INJECTION_TEST") ) begin
    int_cor_mask = int_cor_mask | ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data [ 4 ] ) ;
  end

end

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_alarm_inf_v_0
                   , ( hqm_credit_hist_pipe_core.int_inf_v [ 0 ] & ~ int_inf_0_mask )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf_0: syndrome_1 0x%h"
                             , $sampled ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data )
                             )
                             , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_alarm_inf_v_1
                   , ( hqm_credit_hist_pipe_core.int_inf_v [ 1 ] & ~ int_inf_1_mask )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf_1: syndrome_0 0x%h"
                             , $sampled ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data )
                             )
                             , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_alarm_inf_v_2
                   , ( hqm_credit_hist_pipe_core.int_inf_v [ 2 ] & ~ int_inf_2_mask )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf_2: syndrome_0 0x%h"
                             , $sampled ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_00_capture_data )
                             )
                             , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_alarm_int_unc_v_0
                   , ( hqm_credit_hist_pipe_core.int_unc_v [ 0 ] & ~ int_unc_mask )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_unc_0: syndrome_1 0x%h"
                             , $sampled ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data )
                             )
                             , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_alarm_int_cor_v_0
                   , ( hqm_credit_hist_pipe_core.int_cor_v [ 0 ] & ~ int_cor_mask )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_cor_0: syndrome_1 0x%h"
                             , $sampled ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_syndrome_01_capture_data )
                             )
                             , SDG_SVA_SOC_SIM
                   )

////////////////////////////////////////////////////////////////////////////////////////////////////

logic hqm_prochot_disable ;
always_comb begin
  hqm_prochot_disable = 1'b0 ;
  if ($test$plusargs("HQM_PROCHOT_DISABLE") ) begin
    hqm_prochot_disable = 1'b1 ;
  end
end
/*
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_wdint_and_no_clkreq_begin
                      , ( ~hqm_prochot_disable & (((|hqm_credit_hist_pipe_core.dir_wdto_nxt) | (|hqm_credit_hist_pipe_core.ldb_wdto_nxt)) & ~hqm_credit_hist_pipe_core.wd_clkreq &  hqm_credit_hist_pipe_core.cfg_unit_idle_reg_nxt.pipe_idle ))
                      , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_wdint_and_no_clkreq_begin: WD interrupt detected & wd_clkreq is not asserted. WD must request clocks active before issuing interrupts" )
                      , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_wdint_and_no_clkreq_enq
                      , ( ~hqm_prochot_disable & (hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_valid & ~hqm_credit_hist_pipe_core.wd_clkreq & hqm_credit_hist_pipe_core.cfg_unit_idle_reg_nxt.pipe_idle ))
                      , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_wdint_and_no_clkreq_end: WD interrupt issued & wd_clkreq is not asserted. WD must request clocks active before issuing interrupts" )
                      , SDG_SVA_SOC_SIM
                      ) ;
*/

logic [ 63 : 0 ] ldb_wd_irq_d1 ;
logic [ 63 : 0 ] dir_wd_irq_d1 ;

always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
  if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
    ldb_wd_irq_d1 <= 64'h0 ;
    dir_wd_irq_d1 <= 64'h0 ;
  end
  else begin
    ldb_wd_irq_d1 <= hqm_credit_hist_pipe_core.ldb_wd_irq ;
    dir_wd_irq_d1 <= hqm_credit_hist_pipe_core.dir_wd_irq ;
  end
end

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ldb_wd_irq_and_no_clkreq
                      , (( |(hqm_credit_hist_pipe_core.ldb_wd_irq & ~ldb_wd_irq_d1) & ~hqm_credit_hist_pipe_core.wd_clkreq_sync2inp ) & hqm_credit_hist_pipe_core.chp_unit_idle )
                      , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_ldb_wd_irq_and_no_clkreq: LDB WD irq detected & wd_clkreq is not set. WD must request clocks prior to an irq active event" )
                      , SDG_SVA_SOC_SIM) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dir_wd_irq_and_no_clkreq
                      , (( |(hqm_credit_hist_pipe_core.dir_wd_irq & ~dir_wd_irq_d1) & ~hqm_credit_hist_pipe_core.wd_clkreq_sync2inp ) & hqm_credit_hist_pipe_core.chp_unit_idle )
                      , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_dir_wd_irq_and_no_clkreq: DIR WD irq detected & wd_clkreq is not set. WD must request clocks prior to an irq active event" )
                      , SDG_SVA_SOC_SIM) 


`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_wdint_and_chp_unit_idle
                      , ( ( (|hqm_credit_hist_pipe_core.ldb_wd_irq)|(|hqm_credit_hist_pipe_core.dir_wd_irq)|hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_valid ) & hqm_credit_hist_pipe_core.chp_unit_idle )
                      , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_wdint_and_chp_unit_idle: WD interrupt pending/active & chp_unit_idle. Clocks must stay on until WD interrupt is taken " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven
                      , (  
                          hqm_credit_hist_pipe_core.chp_cfg_req_up_read
                        | hqm_credit_hist_pipe_core.chp_cfg_req_up_write
                        | hqm_credit_hist_pipe_core.chp_cfg_rsp_up_ack
                        | hqm_credit_hist_pipe_core.chp_alarm_up_v
                        | hqm_credit_hist_pipe_core.chp_alarm_down_ready
                        | hqm_credit_hist_pipe_core.hcw_enq_w_req_valid
                        | hqm_credit_hist_pipe_core.hcw_sched_w_req_ready
                        | hqm_credit_hist_pipe_core.interrupt_w_req_ready
                        | hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_ready
                        | hqm_credit_hist_pipe_core.chp_rop_hcw_ready
                        | hqm_credit_hist_pipe_core.chp_lsp_cmp_ready
                        | hqm_credit_hist_pipe_core.chp_lsp_token_ready
                        | hqm_credit_hist_pipe_core.qed_chp_sch_v
                        | hqm_credit_hist_pipe_core.aqed_chp_sch_v
           )
                      , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                      , ~ hqm_credit_hist_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven" )
                      , SDG_SVA_SOC_SIM
                      )



`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hcw_enq_qe_is_ldb_qtype_err
                   , ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid &
                       ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb ? ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype == DIRECT ) :
                                                                                  ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype != DIRECT ) )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: hcw_enq_w.user.qe_is_ldb and hcw.user_info.qtype err " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hcw_enq_ldb_pp_out_of_range
                   , ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid &
                       hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp_is_ldb &
                       ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp > 63 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: hcw_enq_w.user.pp is out of range (valid LDB PP 0-63) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hcw_enq_dir_pp_out_of_range
                   , ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid &
                       ~hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp_is_ldb &
                       ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp > 95 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: hcw_enq_w.user.pp is out of range (valid DIR PP 0-95) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hcw_enq_qid_out_of_range
                   , ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid &
                       ( ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                         ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                         ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                         ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) &
                       ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb ? ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qid > 31 ) :
                                                                                  ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qid > 95 ) )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: hcw_enq_w.user.qid is out of range (dir valid 0-95, ldb valid 0-31) " )
                   , SDG_SVA_SOC_SIM
                   )

/*
`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_qqed_chp_sch_ignore_cq_depth
                   , ( hqm_credit_hist_pipe_core.aqed_chp_sch_v &
                       ( hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.ignore_cq_depth )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: aqed_chp_sch_data.hqm_core_flags.ignore_cq_depth 1 " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_qed_chp_sch_ignore_cq_depth
                   , ( hqm_credit_hist_pipe_core.qed_chp_sch_v &
                       ( hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: qed_chp_sch_data.hqm_core_flags.ignore_cq_depth 1 " )
                   , SDG_SVA_SOC_SIM
                   )
*/

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_qed_chp_sch_cmd_ill0
                   , ( hqm_credit_hist_pipe_core.qed_chp_sch_v &
                       ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_ILL0 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: qed_chp_sch_data.cmd ILL0 " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_qed_chp_sch_cq_err
                   , ( hqm_credit_hist_pipe_core.qed_chp_sch_v &
                       ( hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ? 
                         ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cq > 63 ) :
                         ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cq > 95 ) )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: qed_chp_sch_data.cq is out of range (valid ldb 0-63, dir 0-95) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_qed_chp_sch_flid_err
                   , ( hqm_credit_hist_pipe_core.qed_chp_sch_v &
                       ( hqm_credit_hist_pipe_core.qed_chp_sch_data.flid > 16383 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_inp_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: qed_chp_sch_data.flid is out of range (valid 0-16383) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_ldb_cq_token_depth_select_err
                   , ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.check_ldb &
                       ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.rw_ldb_cq_token_depth_select_p2_data_f [ 3 : 0 ] > 8 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: ldb_cq_token_depth_select is out of range (valid 0-8) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_dir_cq_token_depth_select_err
                   , ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.check_dir &
                       ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.rw_dir_cq_token_depth_select_p2_data_f [ 3 : 0 ] > 8 )
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: dir_cq_token_depth_select is out of range (valid 0-8) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_chp_rop_hcw_dir_flid_err
                   , ( hqm_credit_hist_pipe_core.chp_rop_hcw_v &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) &
                       ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qtype == DIRECT ) &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid >= ( 16 * 1024 ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: chp_rop_hcw dir flid is out of range (valid 0-16383) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_chp_rop_hcw_ldb_flid_err
                   , ( hqm_credit_hist_pipe_core.chp_rop_hcw_v &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) &
                       ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qtype != DIRECT ) &
                       ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid >= ( 16 * 1024 ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: chp_rop_hcw ldb flid is out of range (valid 0-16383) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_chp_lsp_dir_token_err
                   , ( hqm_credit_hist_pipe_core.chp_lsp_token_v &
                       ~ hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb &
                       ( hqm_credit_hist_pipe_core.chp_lsp_token_data.count > ( 1 * 1024 ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: chp_lsp_token ldb token return is out of range (valid 1-1024) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_chp_lsp_ldb_token_err
                   , ( hqm_credit_hist_pipe_core.chp_lsp_token_v &
                       hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb &
                       ( hqm_credit_hist_pipe_core.chp_lsp_token_data.count > ( 1 * 1024 ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: chp_lsp_token ldb token return is out of range (valid 1-1024) " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_arbiter_pop_err_3
                   , ( ( hqm_credit_hist_pipe_core.hcw_enq_pop & hqm_credit_hist_pipe_core.hcw_replay_pop ) |
                       ( hqm_credit_hist_pipe_core.qed_sch_pop & hqm_credit_hist_pipe_core.aqed_sch_pop ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: arbiter pop error_3 simultaneous hcw_enq_pop, hcw_replay_pop or qed_sch_pop, aqed_sch_pop " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_arbiter_pop_err_4
                   , ( ( hqm_credit_hist_pipe_core.hcw_enq_pop +
                         hqm_credit_hist_pipe_core.hcw_replay_pop +
                         hqm_credit_hist_pipe_core.qed_sch_pop +
                         hqm_credit_hist_pipe_core.aqed_sch_pop ) > 2
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: arbiter pop error_4 poping more than 2 at a time " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_enqpipe_out_of_credit_err
                   , ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_v_f &
                       hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.out_of_credit &
                       ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_NOOP ) | 
                         ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_BAT_TOK_RET ) | 
                         ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_COMP ) | 
                         ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_COMP_TOK_RET ) | 
                         ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p6_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_ARM ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: out of credit on non enqueue cmd " )
                   , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_enqpipe_excess_frag_drop_err
                   , ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_v_f &
                       hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.excess_frag_drop &
                       ( ( ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.cq_hcw.pp_is_ldb ) |
                         ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_NOOP ) | 
                           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_BAT_TOK_RET ) | 
                           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_ARM ) | 
                           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) | 
                           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p7_enq_chp_state_f.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) ) ) 
                     )
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: excess frag on dir pp or non frag cmd  " )
                   , SDG_SVA_SOC_SIM
                   )


logic [ 12 : 0 ] dir_cq_depth_nxt [ 63 : 0 ] ;
logic [ 12 : 0 ] dir_cq_depth_f  [ 63 : 0 ];
logic [ 10 : 0 ] ldb_cq_depth_nxt  [ 63 : 0 ];
logic [ 10 : 0 ] ldb_cq_depth_f  [ 63 : 0 ];
logic [ 12 : 0 ] dir_cq_intr_thresh_nxt [ 63 : 0 ] ;
logic [ 12 : 0 ] dir_cq_intr_thresh_f  [ 63 : 0 ];
logic [ 10 : 0 ] ldb_cq_intr_thresh_nxt  [ 63 : 0 ];
logic [ 10 : 0 ] ldb_cq_intr_thresh_f  [ 63 : 0 ];

generate
  for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
    always_comb begin
      ldb_cq_depth_nxt [ gi ] = ldb_cq_depth_f [ gi ] ;
      if ( hqm_credit_hist_pipe_core.rf_ldb_cq_depth_we & ( hqm_credit_hist_pipe_core.rf_ldb_cq_depth_waddr == gi ) ) begin
        ldb_cq_depth_nxt [ gi ] = hqm_credit_hist_pipe_core.rf_ldb_cq_depth_wdata_struct.depth ;
      end
    end
    always_comb begin
      ldb_cq_intr_thresh_nxt [ gi ] = ldb_cq_intr_thresh_f [ gi ] ;
      if ( hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_we & ( hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_waddr == gi ) ) begin
        ldb_cq_intr_thresh_nxt [ gi ] = hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_wdata_struct.threshold ;
      end
    end
    always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
      if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        ldb_cq_depth_f [ gi ] <= 32'h0 ;
        ldb_cq_intr_thresh_f [ gi ] <= 32'h0 ;
      end
      else begin
        ldb_cq_depth_f [ gi ] <= ldb_cq_depth_nxt [ gi ] ;
        ldb_cq_intr_thresh_f [ gi ] <= ldb_cq_intr_thresh_nxt [ gi ] ;
      end
    end
  end
  for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
    always_comb begin
      dir_cq_depth_nxt [ gi ] = dir_cq_depth_f [ gi ] ;
      if ( hqm_credit_hist_pipe_core.rf_dir_cq_depth_we & ( hqm_credit_hist_pipe_core.rf_dir_cq_depth_waddr == gi ) ) begin
        dir_cq_depth_nxt [ gi ] = hqm_credit_hist_pipe_core.rf_dir_cq_depth_wdata_struct.depth ;
      end
    end
    always_comb begin
      dir_cq_intr_thresh_nxt [ gi ] = dir_cq_intr_thresh_f [ gi ] ;
      if ( hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_we & ( hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_waddr == gi ) ) begin
        dir_cq_intr_thresh_nxt [ gi ] = hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_wdata_struct.threshold ;
      end
    end
    always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
      if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        dir_cq_depth_f [ gi ] <= 32'h0 ;
        dir_cq_intr_thresh_f [ gi ] <= 32'h0 ;
      end
      else begin
        dir_cq_depth_f [ gi ] <= dir_cq_depth_nxt [ gi ] ;
        dir_cq_intr_thresh_f [ gi ] <= dir_cq_intr_thresh_nxt [ gi ] ;
      end
    end
  end
endgenerate

logic hl_ao_mem_nxt [ 2047 : 0 ] ;
logic hl_ao_mem_f  [ 2047 : 0 ] ;
logic [ 11 : 0 ] hl_ao_addr_mem_nxt [ 2047 : 0 ] ;
logic [ 11 : 0 ] hl_ao_addr_mem_f [ 2047 : 0 ] ;
logic hl_ao_unexpected_a_comp ;
logic hl_ao_missing_a_comp ;
logic hist_list_pop_d0_f ;
logic hist_list_pop_d1_f ;
logic hist_list_pop_d2_f ;
logic hist_list_a_pop_d0_f ;
logic hist_list_a_pop_d1_f ;
logic hist_list_a_pop_d2_f ;

always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
  if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
    hist_list_pop_d0_f <= 1'b0 ;
    hist_list_pop_d1_f <= 1'b0 ;
    hist_list_pop_d2_f <= 1'b0 ;
    hist_list_a_pop_d0_f <= 1'b0 ;
    hist_list_a_pop_d1_f <= 1'b0 ;
    hist_list_a_pop_d2_f <= 1'b0 ;
  end
  else begin
    hist_list_pop_d0_f <= hqm_credit_hist_pipe_core.hist_list_cmd_v & ( hqm_credit_hist_pipe_core.hist_list_cmd == HQM_AW_MF_POP ) ;
    hist_list_pop_d1_f <= hist_list_pop_d0_f ;
    hist_list_pop_d2_f <= hist_list_pop_d1_f ;
    hist_list_a_pop_d0_f <= hqm_credit_hist_pipe_core.hist_list_a_cmd_v & ( hqm_credit_hist_pipe_core.hist_list_a_cmd == HQM_AW_MF_POP ) ;
    hist_list_a_pop_d1_f <= hist_list_a_pop_d0_f ;
    hist_list_a_pop_d2_f <= hist_list_a_pop_d1_f ;
  end
end


generate
  for ( genvar gi = 0 ; gi < 2048 ; gi++ ) begin
    always_comb begin 
      if ( hqm_credit_hist_pipe_core.hqm_proc_reset_done ) begin
        hl_ao_mem_nxt [ gi ] = hl_ao_mem_f [ gi ] ;
        hl_ao_addr_mem_nxt [ gi ] = hl_ao_addr_mem_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.sr_hist_list_we & hqm_credit_hist_pipe_core.sr_hist_list_a_we & ( hqm_credit_hist_pipe_core.sr_hist_list_addr == gi ) ) begin
          hl_ao_mem_nxt [ gi ] = 1'b1 ;
        end
        if ( hqm_credit_hist_pipe_core.sr_hist_list_we & hqm_credit_hist_pipe_core.sr_hist_list_a_we & ( hqm_credit_hist_pipe_core.sr_hist_list_a_addr == gi ) ) begin
          hl_ao_addr_mem_nxt [ gi ] = hqm_credit_hist_pipe_core.sr_hist_list_addr ;
        end
        if ( hqm_credit_hist_pipe_core.sr_hist_list_a_re & ( hl_ao_addr_mem_f [ hqm_credit_hist_pipe_core.sr_hist_list_a_addr ] == gi ) & ( hl_ao_mem_f [ gi ] == 1'b1 ) ) begin
          hl_ao_mem_nxt [ gi ] = 1'b0 ;
        end
      end
    end
    always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
      if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        hl_ao_mem_f [ gi ] <= 1'b0 ;
        hl_ao_addr_mem_f [ gi ] <= 12'h0 ;
      end
      else begin
        hl_ao_mem_f [ gi ] <= hl_ao_mem_nxt [ gi ] ;
        hl_ao_addr_mem_f [ gi ] <= hl_ao_addr_mem_nxt [ gi ] ;
      end
    end 
  end
endgenerate

always_comb begin
  hl_ao_unexpected_a_comp = 1'b0 ;
  hl_ao_missing_a_comp = 1'b0 ;
  for ( int fi = 0 ; fi < 2048 ; fi++ ) begin
    if ( hqm_credit_hist_pipe_core.sr_hist_list_a_re & ( ~ hl_ao_mem_f [ hl_ao_addr_mem_f [ hqm_credit_hist_pipe_core.sr_hist_list_a_addr ] ] ) ) begin 
      hl_ao_unexpected_a_comp = 1'b1 ;
    end
    if ( hqm_credit_hist_pipe_core.sr_hist_list_re & hist_list_pop_d2_f & ( hl_ao_mem_f [ hqm_credit_hist_pipe_core.sr_hist_list_addr ] ) ) begin 
      hl_ao_missing_a_comp = 1'b1 ;
    end
  end
end

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hl_ao_unexpected_a_comp
                   , hl_ao_unexpected_a_comp 
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_hl_ao_unexpected_a_comp"
                             )
                             , SDG_SVA_SOC_SIM
                   )

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_hl_ao_missing_a_comp
                   , hl_ao_missing_a_comp 
                   , posedge hqm_credit_hist_pipe_core.hqm_gated_clk
                   , ~hqm_credit_hist_pipe_core.hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_hl_ao_missing_a_comp"
                             )
                             , SDG_SVA_SOC_SIM
                   )

endmodule

bind hqm_credit_hist_pipe_core hqm_credit_hist_pipe_assert i_hqm_credit_hist_pipe_assert();

`endif

`endif
