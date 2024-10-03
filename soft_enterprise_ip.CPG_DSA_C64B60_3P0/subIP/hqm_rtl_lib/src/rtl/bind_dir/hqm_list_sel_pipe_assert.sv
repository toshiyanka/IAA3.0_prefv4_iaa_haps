`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_list_sel_pipe_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

//disable_pool scenario off
logic         disable_pool_off;
logic           dynamic_config ;

initial begin
 //continue_on_perr=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_PERR")) continue_on_perr='1;
 disable_pool_off =0; if ($test$plusargs("DISABLE_POOL"))  disable_pool_off ='1;
 dynamic_config =0; if ($test$plusargs("HQM_DYNAMIC_CONFIG"))  dynamic_config ='1;
end


////////////////////////////////////////////////////////////////////////////////////////////////////
// call $finish on error
logic inject_error_test ;
logic ingress_error_test ;
logic agit_test ;
logic cfg_test ;

assign inject_error_test = ( $test$plusargs("HQM_CHP_HCW_ENQ_USER_PARITY_ERROR_INJECTION_TEST") ) ;
assign ingress_error_test = ( $test$plusargs("HQM_INGRESS_ERROR_TEST") ) ;
assign agit_test = $test$plusargs("HQM_DISABLE_AGITIATE_ASSERT") ;
assign cfg_test = ( ( $test$plusargs("hraisatr") ) || ( $test$plusargs("hraissai") ) || ( $test$plusargs("hraisresetm") ) ) ;

logic   idle_pop_collision_f , idle_pop_collision_nxt ;
logic   cfg_pipe_collision_f , cfg_pipe_collision_nxt ;

always_comb begin
  // Don't include output FIFOs/DBs which will drain unless there is output backpressure, and whose drain is not blocked for cfg access : nalb_sel_nalb_fifo_pop
  // Note: this assertion is not necessarily totally up to date with V25 FIFOs (could be missing some), but has outlived its usefulness since common AW sidecar is used
  idle_pop_collision_nxt        = ( hqm_list_sel_pipe_core.cfg_unit_idle_f.cfg_active ) &
                                  (       hqm_list_sel_pipe_core.dir_tokrtn_fifo_pop
                                        | hqm_list_sel_pipe_core.ldb_token_rtn_fifo_pop
                                        | hqm_list_sel_pipe_core.uno_atm_cmp_fifo_pop
                                        | hqm_list_sel_pipe_core.nalb_cmp_fifo_pop
                                        | hqm_list_sel_pipe_core.atm_cmp_fifo_pop
                                        | hqm_list_sel_pipe_core.rop_lsp_reordercmp_fifo_pop
                                        | hqm_list_sel_pipe_core.enq_nalb_fifo_pop
                                        | hqm_list_sel_pipe_core.nalbrpl_fifo_pop
                                        | hqm_list_sel_pipe_core.dp_lsp_enq_dir_fifo_pop
                                        | hqm_list_sel_pipe_core.dirrpl_fifo_pop          
                                        | hqm_list_sel_pipe_core.send_atm_to_cq_fifo_pop
                                        | hqm_list_sel_pipe_core.enq_atq_fifo_pop
                                        | hqm_list_sel_pipe_core.p0_lba_pop_cq
                                        | hqm_list_sel_pipe_core.p3_atq_sch_start
                                        | hqm_list_sel_pipe_core.p3_direnq_sch_start
                                        | hqm_list_sel_pipe_core.p3_lbrpl_sch_start
                                        | hqm_list_sel_pipe_core.p3_dirrpl_sch_start ) ;
end

always_comb begin
  // Need to check inside ram_access instead of cfg_sc because there is glue logic in LSP core which intercepts config accesses for WU regfiles and converts
  // them to functional accesses without idling the pipe.
  cfg_pipe_collision_nxt  =
       (  ( ~ hqm_list_sel_pipe_core.cfg_unit_idle_f.pipe_idle ) 
          & ( ( | hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_ram_access.cfg_mem_re ) | ( | hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_ram_access.cfg_mem_we ) ) ) ;

end // always

always_ff @(posedge hqm_list_sel_pipe_core.hqm_gated_clk or negedge hqm_list_sel_pipe_core.hqm_gated_rst_n) begin
  if (~hqm_list_sel_pipe_core.hqm_gated_rst_n) begin
    idle_pop_collision_f        <= 1'b0 ;
    cfg_pipe_collision_f          <= 1'b0 ;
  end
  else begin
    idle_pop_collision_f        <= idle_pop_collision_nxt ;
    cfg_pipe_collision_f          <= cfg_pipe_collision_nxt ;
  end
end // always_ff

////////////////////////////////////////////////////////////////////////////////////////////////////

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_collision
                      , ( cfg_pipe_collision_f == 1'b1 )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_collision: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_collision_idle_pop
                      , ( idle_pop_collision_f == 1'b1 )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_collision_idle_pop: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_lsp_dp_wbo_error
                      , ( hqm_list_sel_pipe_core.lsp_dp_sch_dir_v & hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready &
                          hqm_list_sel_pipe_core.cfg_dir_tok_lim_disab_opt_f [ hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.cq ] &
                          ( hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.hqm_core_flags.write_buffer_optimization > 0 )
                        )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_lsp_dp_wbo_error: ")
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf02
                      , ( ( hqm_list_sel_pipe_core.int_inf_v[02] == 1'b1 ) & ~ ingress_error_test )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , (~hqm_list_sel_pipe_core.hqm_gated_rst_n | disable_pool_off)
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf02: " )
                      , SDG_SVA_SOC_SIM
                      )
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf01
                      , ( ( hqm_list_sel_pipe_core.int_inf_v[01] == 1'b1 ) & ~ ingress_error_test )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf01: " )
                      , SDG_SVA_SOC_SIM
                      )
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf00
                      , ( ( hqm_list_sel_pipe_core.int_inf_v[00] == 1'b1 ) & ~ ingress_error_test )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf00: " )
                      , SDG_SVA_SOC_SIM
                      )
// In v1 had to supress hw error (int_inf_v[6] if agit_test; may find that necessary in v2 also
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf03
                      , ( ( hqm_list_sel_pipe_core.int_inf_v[03] == 1'b1 ) & ~ inject_error_test )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf03: " )
                      , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf04
                      , ( hqm_list_sel_pipe_core.int_inf_v[04] == 1'b1 )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf04: " )
                      , SDG_SVA_SOC_SIM
                      ) 



chp_lsp_cmp_t                   dbg_chp_lsp_cmp_data_masked;
 
always_comb begin
  dbg_chp_lsp_cmp_data_masked           = hqm_list_sel_pipe_core.chp_lsp_cmp_data ;
  if ( hqm_list_sel_pipe_core.chp_lsp_cmp_v & hqm_list_sel_pipe_core.chp_lsp_cmp_data.user[1:0] == 2'b10 ) begin        // RELEASE, no hl info valid, including qtype
    dbg_chp_lsp_cmp_data_masked                                 = '0 ;
    dbg_chp_lsp_cmp_data_masked.hist_list_info.qtype            = ORDERED ;
  end
  else if ( hqm_list_sel_pipe_core.chp_lsp_cmp_v & hqm_list_sel_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype == UNORDERED )
    dbg_chp_lsp_cmp_data_masked.hist_list_info.sn_fid.fid       = '0 ;          // CHP only drives with known data if ATOMIC or ORDERED
end // always

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( 
    assert_chp_lsp_cmp_data
  , ( hqm_list_sel_pipe_core.chp_lsp_cmp_v ? dbg_chp_lsp_cmp_data_masked : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: chp_lsp_cmp_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_chp_lsp_token_data
  , ( hqm_list_sel_pipe_core.chp_lsp_token_v ? hqm_list_sel_pipe_core.chp_lsp_token_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: chp_lsp_token_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_qed_lsp_deq_data
  , ( hqm_list_sel_pipe_core.qed_lsp_deq_v ? hqm_list_sel_pipe_core.qed_lsp_deq_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: qed_lsp_deq_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_aqed_lsp_deq_data
  , ( hqm_list_sel_pipe_core.aqed_lsp_deq_v ? hqm_list_sel_pipe_core.aqed_lsp_deq_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: aqed_lsp_deq_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_nalb_lsp_enq_lb_data
  , ( hqm_list_sel_pipe_core.nalb_lsp_enq_lb_v ? hqm_list_sel_pipe_core.nalb_lsp_enq_lb_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n 
  , `HQM_SVA_ERR_MSG("Error: nalb_lsp_enq_lb_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_nalb_lsp_enq_rorply_data
  , ( hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_v ? hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: nalb_lsp_enq_rorply_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_dp_lsp_enq_dir_data
  , ( hqm_list_sel_pipe_core.dp_lsp_enq_dir_v ? hqm_list_sel_pipe_core.dp_lsp_enq_dir_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: dp_lsp_enq_dir_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_dp_lsp_enq_rorply_data
  , ( hqm_list_sel_pipe_core.dp_lsp_enq_rorply_v ? hqm_list_sel_pipe_core.dp_lsp_enq_rorply_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: dp_lsp_enq_rorply_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_enq_data
  , ( hqm_list_sel_pipe_core.ap_lsp_enq_v_nc ? hqm_list_sel_pipe_core.ap_lsp_enq_data_nc : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_enq_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_rop_lsp_reordercmp_data
  , ( hqm_list_sel_pipe_core.rop_lsp_reordercmp_v ? hqm_list_sel_pipe_core.rop_lsp_reordercmp_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: rop_lsp_reordercmp_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_aqed_lsp_sch_data
  , ( hqm_list_sel_pipe_core.aqed_lsp_sch_v ? hqm_list_sel_pipe_core.aqed_lsp_sch_data : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: aqed_lsp_sch_data is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_aqed_lsp_fid_cnt_upd
  , ( hqm_list_sel_pipe_core.aqed_lsp_fid_cnt_upd_v ? { hqm_list_sel_pipe_core.aqed_lsp_fid_cnt_upd_val , hqm_list_sel_pipe_core.aqed_lsp_fid_cnt_upd_qid } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: aqed_lsp_fid_cnt_upd_* is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_credit_fifo_ap_aqed_dec
  , ( { hqm_list_sel_pipe_core.credit_fifo_ap_aqed_dec_sch , hqm_list_sel_pipe_core.credit_fifo_ap_aqed_dec_cmp } )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: credit_fifo_ap_aqed_dec_* is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_nalb_sch_unoord_ready
  , hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_nalb_sch_unoord_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_dp_sch_dir_ready
  , hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_dp_sch_dir_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_nalb_sch_rorply_ready
  , hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_nalb_sch_rorply_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_dp_sch_rorply_ready
  , hqm_list_sel_pipe_core.lsp_dp_sch_rorply_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_dp_sch_rorply_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_nalb_sch_atq_ready
  , hqm_list_sel_pipe_core.lsp_nalb_sch_atq_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_nalb_sch_atq_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_lsp_ap_atm_ready
  , hqm_list_sel_pipe_core.lsp_ap_atm_ready
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: lsp_ap_atm_ready is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_freeze
  , hqm_list_sel_pipe_core.ap_lsp_freeze
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_freeze is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_haswork_slst_v
  , ( hqm_list_sel_pipe_core.ap_lsp_haswork_slst_v ? { hqm_list_sel_pipe_core.ap_lsp_cq , hqm_list_sel_pipe_core.ap_lsp_qidix , hqm_list_sel_pipe_core.ap_lsp_qid_nc , hqm_list_sel_pipe_core.ap_lsp_haswork_slst_func } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_haswork_slst_v=1 and { ap_lsp_cq , ap_lsp_qidix , ap_lsp_qid_nc , ap_lsp_haswork_slst_func } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_haswork_rlst_v
  , ( hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_v ? { hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix , hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_func } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_haswork_rlst_v=1 and { ap_lsp_qid2cqqidix , ap_lsp_haswork_rlst_func } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_cmpblast_v
  , ( hqm_list_sel_pipe_core.ap_lsp_cmpblast_v ? { hqm_list_sel_pipe_core.ap_lsp_cq , hqm_list_sel_pipe_core.ap_lsp_qidix , hqm_list_sel_pipe_core.ap_lsp_qid_nc , hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_cmpblast_v=1 and { ap_lsp_cq , ap_lsp_qidix , ap_lsp_qid_nc , ap_lsp_qid2cqqidix } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_cmd_v
  , ( hqm_list_sel_pipe_core.ap_lsp_cmd_v ? { hqm_list_sel_pipe_core.ap_lsp_cmd , hqm_list_sel_pipe_core.ap_lsp_cq , hqm_list_sel_pipe_core.ap_lsp_qidix , hqm_list_sel_pipe_core.ap_lsp_qid_nc , hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_cmd_v=1 and { ap_lsp_cmd , ap_lsp_cq , ap_lsp_qidix , ap_lsp_qid_nc , ap_lsp_qid2cqqidix } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_ap_lsp_dec_fid_cnt_v_nc
  , hqm_list_sel_pipe_core.ap_lsp_dec_fid_cnt_v_nc
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: ap_lsp_dec_fid_cnt_v_nc is unknown")
  , SDG_SVA_SOC_SIM
) 

//===========================================================================================
// For each of the pipes, make sure that if the pipe level is valid and a particular operation is valid (e.g. enq_v), then the associated information (e.g. enq_qid) is not unknown.
//--------
// lba p1
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and { p1_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p1_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p1_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p1_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p1_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p1_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p2
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and { p2_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p2_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p2_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p2_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p2_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p2_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p2_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p3
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and { p3_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p3_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p3_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p3_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p3_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p3_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p3_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p3_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p3_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p4
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and { p4_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p4_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p4_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p4_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p4_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p4_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p4_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p4_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p5
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and { p5_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p5_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p5_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p5_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p5_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p5_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p5_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p5_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p5_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p6
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and { p6_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p6_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p6_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p6_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p6_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p6_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p6_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p6_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p6_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p7
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and { p7_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p7_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p7_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p7_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p7_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p7_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p7_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p7_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lba p8
`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_v
                                                      , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cq_cmp_v
                                                      , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.qid_cmp_v
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and { p8_lba_ctrl_pipe_f sch_v, enq_v, tok_v, cq_cmp_v, qid_cmp_v } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_nalb_v
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_atm_v
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_atm_rlist
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_rlist_qidixv
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_slist_qidixv
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_nalb_qidixv
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_cq
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_cq_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_qid
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_cmpblast_qidixv
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and sch_v=1 and { p8_lba_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.enq_qid
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.enq_qid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and enq_v=1 and { p8_lba_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_cq
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_cnt
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.tok_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and tok_v=1 and { p8_lba_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_cq_cmp_v
  , ( ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cq_cmp_v ) ?
          {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_cq
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_cq_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_atm
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qid_atm
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qid_atm_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qidix
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qpri
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_fid
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_fid_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_hid
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_hid_p
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and cq_cmp_v=1 and { p8_lba_ctrl_pipe_f cmp_cq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p8_lba_ctrl_pipe_qid_cmp_v
  , ( ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.qid_cmp_v | hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.qid_if_dec_v ) ) ?
          {   hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qid
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.cmp_qid_no_dec
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p8_lba_ctrl_pipe_v_f=1 and qid_cmp_v/qid_if_dec_v=1 and { p8_lba_ctrl_pipe_f cmp_qid_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// atq p0

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_atq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.cmp_v
                                                      , hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.blast_enq
                                                      , hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.blast_cmp
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_atq_ctrl_pipe_v_f=1 and { p0_atq_ctrl_pipe_f sch_v, enq_v, cmp_v, blast_enq, blast_cmp } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_atq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p0_atq_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p0_atq_aqed_act_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_atq_ctrl_pipe_v_f=1 and sch_v=1 and { p0_atq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_atq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p0_atq_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_atq_ctrl_pipe_v_f=1 and enq_v=1 and { p0_atq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_atq_ctrl_pipe_cmp_v
  , ( ( hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.cmp_v ) ?
          {   hqm_list_sel_pipe_core.p0_atq_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p0_atq_aqed_act_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_atq_ctrl_pipe_v_f=1 and cmp_v=1 and { p0_atq_ctrl_pipe_f cmp_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// atq p1

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_atq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.cmp_v
                                                      , hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.blast_enq
                                                      , hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.blast_cmp
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_atq_ctrl_pipe_v_f=1 and { p1_atq_ctrl_pipe_f sch_v, enq_v, cmp_v, blast_enq, blast_cmp } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_atq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p1_atq_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p1_atq_aqed_act_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_atq_ctrl_pipe_v_f=1 and sch_v=1 and { p1_atq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_atq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p1_atq_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_atq_ctrl_pipe_v_f=1 and enq_v=1 and { p1_atq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_atq_ctrl_pipe_cmp_v
  , ( ( hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.cmp_v ) ?
          {   hqm_list_sel_pipe_core.p1_atq_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p1_atq_aqed_act_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_atq_ctrl_pipe_v_f=1 and cmp_v=1 and { p1_atq_ctrl_pipe_f cmp_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// atq p2

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_atq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.sch_v
                                                      , hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.enq_v
                                                      , hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.cmp_v
                                                      , hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.blast_enq
                                                      , hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.blast_cmp
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_atq_ctrl_pipe_v_f=1 and { p2_atq_ctrl_pipe_f sch_v, enq_v, cmp_v, blast_enq, blast_cmp } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_atq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p2_atq_enq_cnt_rmw_pipe_f.qid
            , hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_atq_ctrl_pipe_v_f=1 and sch_v=1 and { p2_atq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_atq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p2_atq_enq_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_atq_ctrl_pipe_v_f=1 and enq_v=1 and { p2_atq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_atq_ctrl_pipe_cmp_v
  , ( ( hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.cmp_v ) ?
          {   hqm_list_sel_pipe_core.p2_atq_ctrl_pipe_f.cmp_qid_p
            , hqm_list_sel_pipe_core.p2_atq_aqed_act_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_atq_ctrl_pipe_v_f=1 and cmp_v=1 and { p2_atq_ctrl_pipe_f cmp_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dir p0

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_direnq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.tok_v
                                                         , hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.blast_enq
                                                         , hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.blast_tok
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_direnq_ctrl_pipe_v_f=1 and { p0_direnq_ctrl_pipe_f sch_v, enq_v, tok_v, blast_enq, blast_tok } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_direnq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p0_direnq_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p0_direnq_tok_cnt_rmw_pipe_f_pnc.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_direnq_ctrl_pipe_v_f=1 and sch_v=1 and { p0_direnq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_direnq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p0_direnq_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_direnq_ctrl_pipe_v_f=1 and enq_v=1 and { p0_direnq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_direnq_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p0_direnq_ctrl_pipe_f.tok_delta
            , hqm_list_sel_pipe_core.p0_direnq_tok_cnt_rmw_pipe_f_pnc.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_direnq_ctrl_pipe_v_f=1 and tok_v=1 and { p0_direnq_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dir p1

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_direnq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.tok_v
                                                         , hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.blast_enq
                                                         , hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.blast_tok
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_direnq_ctrl_pipe_v_f=1 and { p1_direnq_ctrl_pipe_f sch_v, enq_v, tok_v, blast_enq, blast_tok } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_direnq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p1_direnq_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p1_direnq_tok_cnt_rmw_pipe_f_pnc.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_direnq_ctrl_pipe_v_f=1 and sch_v=1 and { p1_direnq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_direnq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p1_direnq_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_direnq_ctrl_pipe_v_f=1 and enq_v=1 and { p1_direnq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_direnq_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p1_direnq_ctrl_pipe_f.tok_delta
            , hqm_list_sel_pipe_core.p1_direnq_tok_cnt_rmw_pipe_f_pnc.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_direnq_ctrl_pipe_v_f=1 and tok_v=1 and { p1_direnq_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dir p2

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_direnq_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_v
                                                         , hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.blast_enq
                                                         , hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.blast_tok
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_direnq_ctrl_pipe_v_f=1 and { p2_direnq_ctrl_pipe_f sch_v, enq_v, tok_v, blast_enq, blast_tok } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_direnq_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.sch_qid_p
            , hqm_list_sel_pipe_core.p2_direnq_enq_cnt_rmw_pipe_f.qid
            , hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_direnq_ctrl_pipe_v_f=1 and sch_v=1 and { p2_direnq_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_direnq_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.enq_qid_p
            , hqm_list_sel_pipe_core.p2_direnq_enq_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_direnq_ctrl_pipe_v_f=1 and enq_v=1 and { p2_direnq_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_direnq_ctrl_pipe_tok_v
  , ( ( hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_v ) ?
          {   hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_cq_p
            , hqm_list_sel_pipe_core.p2_direnq_ctrl_pipe_f.tok_delta
            , hqm_list_sel_pipe_core.p2_direnq_tok_cnt_rmw_pipe_f.cq
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_direnq_ctrl_pipe_v_f=1 and tok_v=1 and { p2_direnq_ctrl_pipe_f tok_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lbrpl p0

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_lbrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_lbrpl_ctrl_pipe_v_f=1 and { p0_lbrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_lbrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p0_lbrpl_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_lbrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p0_lbrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_lbrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p0_lbrpl_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p0_lbrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_lbrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p0_lbrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lbrpl p1

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lbrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lbrpl_ctrl_pipe_v_f=1 and { p1_lbrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lbrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p1_lbrpl_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lbrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p1_lbrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_lbrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p1_lbrpl_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p1_lbrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_lbrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p1_lbrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// lbrpl p2

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lbrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lbrpl_ctrl_pipe_v_f=1 and { p2_lbrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lbrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p2_lbrpl_enq_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lbrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p2_lbrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_lbrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p2_lbrpl_enq_cnt_rmw_pipe_f.qid
            , hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p2_lbrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_lbrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p2_lbrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dirrpl p0

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_dirrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_dirrpl_ctrl_pipe_v_f=1 and { p0_dirrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_dirrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p0_dirrpl_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_dirrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p0_dirrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p0_dirrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p0_dirrpl_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p0_dirrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p0_dirrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p0_dirrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dirrpl p1

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_dirrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_dirrpl_ctrl_pipe_v_f=1 and { p1_dirrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_dirrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p1_dirrpl_enq_cnt_rmw_pipe_f_pnc.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_dirrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p1_dirrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p1_dirrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p1_dirrpl_enq_cnt_rmw_pipe_f_pnc.qid
            , hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p1_dirrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p1_dirrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p1_dirrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//--------
// dirrpl p2

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_dirrpl_ctrl_pipe_v
  , ( hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_v_f ? {   hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.sch_v
                                                         , hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.enq_v
                                                         , hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.blast_enq
                                                    } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_dirrpl_ctrl_pipe_v_f=1 and { p2_dirrpl_ctrl_pipe_f sch_v, enq_v, blast_enq } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_dirrpl_ctrl_pipe_sch_v
  , ( ( hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.sch_v ) ?
          {   hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p2_dirrpl_enq_cnt_rmw_pipe_f.qid
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_dirrpl_ctrl_pipe_v_f=1 and sch_v=1 and { p2_dirrpl_ctrl_pipe_f sch_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

`HQM_SDG_ASSERTS_KNOWN_DRIVEN (
    assert_p2_dirrpl_ctrl_pipe_enq_v
  , ( ( hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.enq_v ) ?
          {   hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.qid_p
            , hqm_list_sel_pipe_core.p2_dirrpl_enq_cnt_rmw_pipe_f.qid
            , hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.frag_cnt
            , hqm_list_sel_pipe_core.p2_dirrpl_ctrl_pipe_f.frag_cnt_res
            } : '0 )
  , posedge hqm_list_sel_pipe_core.hqm_gated_clk
  , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
  , `HQM_SVA_ERR_MSG("Error: p2_dirrpl_ctrl_pipe_v_f=1 and enq_v=1 and { p2_dirrpl_ctrl_pipe_f enq_* } is unknown")
  , SDG_SVA_SOC_SIM
) 

//===========================================================================================


`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_chp_lsp_token_gt_1K
                      , ( hqm_list_sel_pipe_core.chp_lsp_token_v & ( hqm_list_sel_pipe_core.chp_lsp_token_data.count > 1024 ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_chp_lsp_token_gt_1K: ")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ap_lsp_haswork_slst_v
                      , ( hqm_list_sel_pipe_core.ap_lsp_haswork_slst_v & ( hqm_list_sel_pipe_core.ap_lsp_haswork_slst_func == hqm_list_sel_pipe_core.p0_lba_slist_v_f [ { hqm_list_sel_pipe_core.ap_lsp_cq , hqm_list_sel_pipe_core.ap_lsp_qidix } ] ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_ap_lsp_haswork_slst_v: ")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ap_lsp_haswork_rlst_v
                      , ( ~ dynamic_config & hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_v & ( | ( hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix & ~( { 512 { hqm_list_sel_pipe_core.ap_lsp_haswork_rlst_func } } ^ hqm_list_sel_pipe_core.p0_lba_rlist_v_f ) ) ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_ap_lsp_haswork_rlst_v: ")
                      , SDG_SVA_SOC_SIM
                      ) 

//`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ap_lsp_unblast_slst_v
//                      , ( hqm_list_sel_pipe_core.ap_lsp_unblast_slst_v & ( hqm_list_sel_pipe_core.p0_lba_slist_blast_f [ (hqm_list_sel_pipe_core.ap_lsp_cq*8) +: 8] != ( 1 << hqm_list_sel_pipe_core.ap_lsp_qidix ) ) )
//                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
//                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
//                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_ap_lsp_unblast_slst_v: ")
//                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ap_lsp_unblast_rlst_v
                      , ( ~ dynamic_config & hqm_list_sel_pipe_core.ap_lsp_unblast_rlst_v & ( | ( hqm_list_sel_pipe_core.ap_lsp_qid2cqqidix & ~hqm_list_sel_pipe_core.p0_lba_rlist_blast_f ) ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_ap_lsp_unblast_rlst_v: ")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_lsp_blast_slst
                      , ( hqm_list_sel_pipe_core.p7_lba_blast_slist & hqm_list_sel_pipe_core.p0_lba_slist_blast_f [ hqm_list_sel_pipe_core.p7_lba_ctrl_pipe_sch_cq_qidix ] )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_lsp_blast_slst: ")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_lsp_blast_rlst
                      , ( ~ dynamic_config & hqm_list_sel_pipe_core.p7_lba_blast_rlist & ( | ( hqm_list_sel_pipe_core.p7_lba_blast_qid2cqidix_v & hqm_list_sel_pipe_core.p0_lba_rlist_blast_f ) ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_lsp_blast_rlst: ")
                      , SDG_SVA_SOC_SIM
                      ) 

// There are hw checks for setting/resetting p0_lba_cmpblast_chkv_f, so no need to replicate that in assertion code.

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_cq_busy_sch_set
                      , ( hqm_list_sel_pipe_core.p1_lba_issue_sched & hqm_list_sel_pipe_core.p0_lba_cq_busy_sch_f [ hqm_list_sel_pipe_core.p1_lba_ctrl_pipe_f.sch_cq ] )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_cq_busy_sch_set: ")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_cq_busy_sch_reset
                      , ( hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_v & ! hqm_list_sel_pipe_core.p0_lba_cq_busy_sch_f [ hqm_list_sel_pipe_core.p8_lba_ctrl_pipe_f.sch_cq ] )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_forbidden_cq_busy_sch_reset: ")
                      , SDG_SVA_SOC_SIM
                      ) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_lba_nalb_sch_arb_update_nowinner
                      , ( hqm_list_sel_pipe_core.p4_lba_nalb_sch_arb_update & ~( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_sch_nalb_v_f ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_lba_nalb_sch_arb_update_nowinner: lba_nalb_sch_arb update issued when no winner, nalb arb index and count corrupted")
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_lba_atm_sch_arb_update_nowinner
                      , ( hqm_list_sel_pipe_core.p4_lba_atm_sch_arb_update & ~( hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_v_f & hqm_list_sel_pipe_core.p4_lba_sch_atm_v_f ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_lba_atm_sch_arb_update_nowinner: lba_atm_sch_arb update issued when no winner, atm arb index and count corrupted")
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_lba_nalb_sch_arb_update_noreqs
                      , ( hqm_list_sel_pipe_core.p4_lba_nalb_sch_arb_update & ~( | ( { hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_nalb_qidixv } ) ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_lba_nalb_sch_arb_update_noreqs: lba_nalb sch_arb update issued when no nalb qidixv")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_lba_atm_sch_arb_update_noreqs
                      , ( hqm_list_sel_pipe_core.p4_lba_atm_sch_arb_update & ~( | ( {  hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_slist_qidixv ,
                                                                                       hqm_list_sel_pipe_core.p4_lba_ctrl_pipe_f.sch_rlist_qidixv } ) ) )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_lba_atm_sch_arb_update_noreqs: lba_atm sch_arb update issued when no slist or rlist qidixv")
                      , SDG_SVA_SOC_SIM
                      ) 

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_dir_tok_cnt_cfgwr_nonzero
                      , ( hqm_list_sel_pipe_core.cfgsc_dir_tok_cnt_mem_we & ( hqm_list_sel_pipe_core.cfgsc_dir_tok_cnt_mem_wdata_struct.cnt != '0 ) & ~ cfg_test )
                      , posedge hqm_list_sel_pipe_core.hqm_gated_clk
                      , ~hqm_list_sel_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error: assert_dir_tok_cnt_cfgwr_nonzero: config write of nonzero value to DIR token count")
                      , SDG_SVA_SOC_SIM
                      ) 

endmodule

bind hqm_list_sel_pipe_core hqm_list_sel_pipe_assert i_hqm_list_sel_pipe_assert();

`endif

`endif
