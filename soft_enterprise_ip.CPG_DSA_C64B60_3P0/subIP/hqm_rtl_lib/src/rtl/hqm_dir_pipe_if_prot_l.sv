module hqm_dir_pipe_if_prot_l (
  input in_dp_cfg_req_down_read
, output out_dp_cfg_req_down_read
, input in_dp_cfg_req_down_write
, output out_dp_cfg_req_down_write
, input in_dp_dqed_v
, output out_dp_dqed_v
, input in_dp_lsp_enq_dir_v
, output out_dp_lsp_enq_dir_v
, input in_dp_lsp_enq_rorply_v
, output out_dp_lsp_enq_rorply_v
);
hqm_AW_if_prot_l i_dp_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_cfg_req_down_read )
, .out_data ( out_dp_cfg_req_down_read )
);
hqm_AW_if_prot_l i_dp_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_cfg_req_down_write )
, .out_data ( out_dp_cfg_req_down_write )
);
hqm_AW_if_prot_l i_dp_dqed_v (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_dqed_v )
, .out_data ( out_dp_dqed_v )
);
hqm_AW_if_prot_l i_dp_lsp_enq_dir_v (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_lsp_enq_dir_v )
, .out_data ( out_dp_lsp_enq_dir_v )
);
hqm_AW_if_prot_l i_dp_lsp_enq_rorply_v (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_lsp_enq_rorply_v )
, .out_data ( out_dp_lsp_enq_rorply_v )
);
endmodule ;
