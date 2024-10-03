module hqm_nalb_pipe_if_prot_l (
  input in_nalb_alarm_down_v
, output out_nalb_alarm_down_v
, input in_nalb_cfg_req_down_read
, output out_nalb_cfg_req_down_read
, input in_nalb_cfg_req_down_write
, output out_nalb_cfg_req_down_write
, input in_nalb_lsp_enq_lb_v
, output out_nalb_lsp_enq_lb_v
, input in_nalb_lsp_enq_rorply_v
, output out_nalb_lsp_enq_rorply_v
, input in_nalb_qed_v
, output out_nalb_qed_v
);
hqm_AW_if_prot_l i_nalb_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_alarm_down_v )
, .out_data ( out_nalb_alarm_down_v )
);
hqm_AW_if_prot_l i_nalb_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_cfg_req_down_read )
, .out_data ( out_nalb_cfg_req_down_read )
);
hqm_AW_if_prot_l i_nalb_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_cfg_req_down_write )
, .out_data ( out_nalb_cfg_req_down_write )
);
hqm_AW_if_prot_l i_nalb_lsp_enq_lb_v (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_lsp_enq_lb_v )
, .out_data ( out_nalb_lsp_enq_lb_v )
);
hqm_AW_if_prot_l i_nalb_lsp_enq_rorply_v (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_lsp_enq_rorply_v )
, .out_data ( out_nalb_lsp_enq_rorply_v )
);
hqm_AW_if_prot_l i_nalb_qed_v (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_qed_v )
, .out_data ( out_nalb_qed_v )
);
endmodule ;
