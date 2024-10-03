module hqm_list_sel_pipe_if_prot_h (
  input in_ap_alarm_up_ready
, output out_ap_alarm_up_ready
, input in_ap_reset_done
, output out_ap_reset_done
, input in_ap_unit_idle
, output out_ap_unit_idle
, input in_ap_unit_pipeidle
, output out_ap_unit_pipeidle
, input in_ap_vf_reset_done
, output out_ap_vf_reset_done
, input in_aqed_alarm_up_ready
, output out_aqed_alarm_up_ready
, input in_aqed_reset_done
, output out_aqed_reset_done
, input in_aqed_unit_idle
, output out_aqed_unit_idle
, input in_aqed_unit_pipeidle
, output out_aqed_unit_pipeidle
, input in_aqed_vf_reset_done
, output out_aqed_vf_reset_done
, input in_chp_lsp_cmp_ready
, output out_chp_lsp_cmp_ready
, input in_chp_lsp_token_ready
, output out_chp_lsp_token_ready
, input in_dp_lsp_enq_dir_ready
, output out_dp_lsp_enq_dir_ready
, input in_dp_lsp_enq_rorply_ready
, output out_dp_lsp_enq_rorply_ready
, input in_lsp_alarm_up_ready
, output out_lsp_alarm_up_ready
, input in_lsp_reset_done
, output out_lsp_reset_done
, input in_lsp_unit_idle
, output out_lsp_unit_idle
, input in_lsp_unit_pipeidle
, output out_lsp_unit_pipeidle
, input in_lsp_vf_reset_done
, output out_lsp_vf_reset_done
, input in_nalb_lsp_enq_lb_ready
, output out_nalb_lsp_enq_lb_ready
, input in_nalb_lsp_enq_rorply_ready
, output out_nalb_lsp_enq_rorply_ready
, input in_qed_aqed_enq_ready
, output out_qed_aqed_enq_ready
, input in_rop_lsp_reordercmp_ready
, output out_rop_lsp_reordercmp_ready
);
hqm_AW_if_prot_h i_ap_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_alarm_up_ready )
, .out_data ( out_ap_alarm_up_ready )
);
hqm_AW_if_prot_h i_ap_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_reset_done )
, .out_data ( out_ap_reset_done )
);
hqm_AW_if_prot_h i_ap_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_unit_idle )
, .out_data ( out_ap_unit_idle )
);
hqm_AW_if_prot_h i_ap_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_unit_pipeidle )
, .out_data ( out_ap_unit_pipeidle )
);
hqm_AW_if_prot_h i_ap_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_ap_vf_reset_done )
, .out_data ( out_ap_vf_reset_done )
);
hqm_AW_if_prot_h i_aqed_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_alarm_up_ready )
, .out_data ( out_aqed_alarm_up_ready )
);
hqm_AW_if_prot_h i_aqed_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_reset_done )
, .out_data ( out_aqed_reset_done )
);
hqm_AW_if_prot_h i_aqed_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_unit_idle )
, .out_data ( out_aqed_unit_idle )
);
hqm_AW_if_prot_h i_aqed_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_unit_pipeidle )
, .out_data ( out_aqed_unit_pipeidle )
);
hqm_AW_if_prot_h i_aqed_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_vf_reset_done )
, .out_data ( out_aqed_vf_reset_done )
);
hqm_AW_if_prot_h i_chp_lsp_cmp_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_lsp_cmp_ready )
, .out_data ( out_chp_lsp_cmp_ready )
);
hqm_AW_if_prot_h i_chp_lsp_token_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_lsp_token_ready )
, .out_data ( out_chp_lsp_token_ready )
);
hqm_AW_if_prot_h i_dp_lsp_enq_dir_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_lsp_enq_dir_ready )
, .out_data ( out_dp_lsp_enq_dir_ready )
);
hqm_AW_if_prot_h i_dp_lsp_enq_rorply_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_lsp_enq_rorply_ready )
, .out_data ( out_dp_lsp_enq_rorply_ready )
);
hqm_AW_if_prot_h i_lsp_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_alarm_up_ready )
, .out_data ( out_lsp_alarm_up_ready )
);
hqm_AW_if_prot_h i_lsp_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_reset_done )
, .out_data ( out_lsp_reset_done )
);
hqm_AW_if_prot_h i_lsp_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_unit_idle )
, .out_data ( out_lsp_unit_idle )
);
hqm_AW_if_prot_h i_lsp_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_unit_pipeidle )
, .out_data ( out_lsp_unit_pipeidle )
);
hqm_AW_if_prot_h i_lsp_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_vf_reset_done )
, .out_data ( out_lsp_vf_reset_done )
);
hqm_AW_if_prot_h i_nalb_lsp_enq_lb_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_lsp_enq_lb_ready )
, .out_data ( out_nalb_lsp_enq_lb_ready )
);
hqm_AW_if_prot_h i_nalb_lsp_enq_rorply_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_lsp_enq_rorply_ready )
, .out_data ( out_nalb_lsp_enq_rorply_ready )
);
hqm_AW_if_prot_h i_qed_aqed_enq_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_aqed_enq_ready )
, .out_data ( out_qed_aqed_enq_ready )
);
hqm_AW_if_prot_h i_rop_lsp_reordercmp_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_lsp_reordercmp_ready )
, .out_data ( out_rop_lsp_reordercmp_ready )
);
endmodule ;
