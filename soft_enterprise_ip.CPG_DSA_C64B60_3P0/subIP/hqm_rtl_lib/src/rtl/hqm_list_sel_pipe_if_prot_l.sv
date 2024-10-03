module hqm_list_sel_pipe_if_prot_l (
  input in_ap_alarm_down_v
, output out_ap_alarm_down_v
, input in_ap_cfg_req_down_read
, output out_ap_cfg_req_down_read
, input in_ap_cfg_req_down_write
, output out_ap_cfg_req_down_write
, input in_aqed_alarm_down_v
, output out_aqed_alarm_down_v
, input in_aqed_cfg_req_down_read
, output out_aqed_cfg_req_down_read
, input in_aqed_cfg_req_down_write
, output out_aqed_cfg_req_down_write
, input in_lsp_alarm_down_v
, output out_lsp_alarm_down_v
, input in_lsp_cfg_req_down_read
, output out_lsp_cfg_req_down_read
, input in_lsp_cfg_req_down_write
, output out_lsp_cfg_req_down_write
, input in_lsp_dp_sch_dir_v
, output out_lsp_dp_sch_dir_v
, input in_lsp_dp_sch_rorply_v
, output out_lsp_dp_sch_rorply_v
, input in_lsp_nalb_sch_atq_v
, output out_lsp_nalb_sch_atq_v
, input in_lsp_nalb_sch_rorply_v
, output out_lsp_nalb_sch_rorply_v
, input in_lsp_nalb_sch_unoord_v
, output out_lsp_nalb_sch_unoord_v
);
hqm_AW_if_prot_l i_ap_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_alarm_down_v )
, .out_data ( out_ap_alarm_down_v )
);
hqm_AW_if_prot_l i_ap_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_cfg_req_down_read )
, .out_data ( out_ap_cfg_req_down_read )
);
hqm_AW_if_prot_l i_ap_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_cfg_req_down_write )
, .out_data ( out_ap_cfg_req_down_write )
);
hqm_AW_if_prot_l i_aqed_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_alarm_down_v )
, .out_data ( out_aqed_alarm_down_v )
);
hqm_AW_if_prot_l i_aqed_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_cfg_req_down_read )
, .out_data ( out_aqed_cfg_req_down_read )
);
hqm_AW_if_prot_l i_aqed_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_cfg_req_down_write )
, .out_data ( out_aqed_cfg_req_down_write )
);
hqm_AW_if_prot_l i_lsp_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_alarm_down_v )
, .out_data ( out_lsp_alarm_down_v )
);
hqm_AW_if_prot_l i_lsp_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_cfg_req_down_read )
, .out_data ( out_lsp_cfg_req_down_read )
);
hqm_AW_if_prot_l i_lsp_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_cfg_req_down_write )
, .out_data ( out_lsp_cfg_req_down_write )
);
hqm_AW_if_prot_l i_lsp_dp_sch_dir_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_dp_sch_dir_v )
, .out_data ( out_lsp_dp_sch_dir_v )
);
hqm_AW_if_prot_l i_lsp_dp_sch_rorply_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_dp_sch_rorply_v )
, .out_data ( out_lsp_dp_sch_rorply_v )
);
hqm_AW_if_prot_l i_lsp_nalb_sch_atq_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_atq_v )
, .out_data ( out_lsp_nalb_sch_atq_v )
);
hqm_AW_if_prot_l i_lsp_nalb_sch_rorply_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_rorply_v )
, .out_data ( out_lsp_nalb_sch_rorply_v )
);
hqm_AW_if_prot_l i_lsp_nalb_sch_unoord_v (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_unoord_v )
, .out_data ( out_lsp_nalb_sch_unoord_v )
);
endmodule ;
