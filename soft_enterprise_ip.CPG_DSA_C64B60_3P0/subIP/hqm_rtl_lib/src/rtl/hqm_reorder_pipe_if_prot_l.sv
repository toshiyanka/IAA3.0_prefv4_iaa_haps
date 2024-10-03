module hqm_reorder_pipe_if_prot_l (
  input in_rop_alarm_down_v
, output out_rop_alarm_down_v
, input in_rop_cfg_req_down_read
, output out_rop_cfg_req_down_read
, input in_rop_cfg_req_down_write
, output out_rop_cfg_req_down_write
, input in_rop_dp_enq_v
, output out_rop_dp_enq_v
, input in_rop_lsp_reordercmp_v
, output out_rop_lsp_reordercmp_v
, input in_rop_nalb_enq_v
, output out_rop_nalb_enq_v
, input in_rop_qed_dqed_enq_v
, output out_rop_qed_dqed_enq_v
);
hqm_AW_if_prot_l i_rop_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_alarm_down_v )
, .out_data ( out_rop_alarm_down_v )
);
hqm_AW_if_prot_l i_rop_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_cfg_req_down_read )
, .out_data ( out_rop_cfg_req_down_read )
);
hqm_AW_if_prot_l i_rop_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_cfg_req_down_write )
, .out_data ( out_rop_cfg_req_down_write )
);
hqm_AW_if_prot_l i_rop_dp_enq_v (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_dp_enq_v )
, .out_data ( out_rop_dp_enq_v )
);
hqm_AW_if_prot_l i_rop_lsp_reordercmp_v (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_lsp_reordercmp_v )
, .out_data ( out_rop_lsp_reordercmp_v )
);
hqm_AW_if_prot_l i_rop_nalb_enq_v (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_nalb_enq_v )
, .out_data ( out_rop_nalb_enq_v )
);
hqm_AW_if_prot_l i_rop_qed_dqed_enq_v (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_qed_dqed_enq_v )
, .out_data ( out_rop_qed_dqed_enq_v )
);
endmodule ;
