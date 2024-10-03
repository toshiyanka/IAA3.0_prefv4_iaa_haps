module hqm_credit_hist_pipe_if_prot_l (
  input in_chp_alarm_down_v
, output out_chp_alarm_down_v
, input in_chp_cfg_req_down_read
, output out_chp_cfg_req_down_read
, input in_chp_cfg_req_down_write
, output out_chp_cfg_req_down_write
, input in_chp_lsp_cmp_v
, output out_chp_lsp_cmp_v
, input in_chp_lsp_token_v
, output out_chp_lsp_token_v
, input in_chp_rop_hcw_v
, output out_chp_rop_hcw_v
, input in_cwdi_interrupt_w_req_valid
, output out_cwdi_interrupt_w_req_valid
, input in_hcw_enq_b_req_valid
, output out_hcw_enq_b_req_valid
, input in_hcw_sched_aw_req_valid
, output out_hcw_sched_aw_req_valid
, input in_hcw_sched_w_req_valid
, output out_hcw_sched_w_req_valid
, input in_interrupt_w_req_valid
, output out_interrupt_w_req_valid
);
hqm_AW_if_prot_l i_chp_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_alarm_down_v )
, .out_data ( out_chp_alarm_down_v )
);
hqm_AW_if_prot_l i_chp_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_cfg_req_down_read )
, .out_data ( out_chp_cfg_req_down_read )
);
hqm_AW_if_prot_l i_chp_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_cfg_req_down_write )
, .out_data ( out_chp_cfg_req_down_write )
);
hqm_AW_if_prot_l i_chp_lsp_cmp_v (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_lsp_cmp_v )
, .out_data ( out_chp_lsp_cmp_v )
);
hqm_AW_if_prot_l i_chp_lsp_token_v (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_lsp_token_v )
, .out_data ( out_chp_lsp_token_v )
);
hqm_AW_if_prot_l i_chp_rop_hcw_v (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_rop_hcw_v )
, .out_data ( out_chp_rop_hcw_v )
);
hqm_AW_if_prot_l i_cwdi_interrupt_w_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_cwdi_interrupt_w_req_valid )
, .out_data ( out_cwdi_interrupt_w_req_valid )
);
hqm_AW_if_prot_l i_hcw_enq_b_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_b_req_valid )
, .out_data ( out_hcw_enq_b_req_valid )
);
hqm_AW_if_prot_l i_hcw_sched_aw_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_aw_req_valid )
, .out_data ( out_hcw_sched_aw_req_valid )
);
hqm_AW_if_prot_l i_hcw_sched_w_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_w_req_valid )
, .out_data ( out_hcw_sched_w_req_valid )
);
hqm_AW_if_prot_l i_interrupt_w_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_interrupt_w_req_valid )
, .out_data ( out_interrupt_w_req_valid )
);
endmodule ;
