module hqm_nalb_pipe_if_prot_h (
  input in_lsp_nalb_sch_atq_ready
, output out_lsp_nalb_sch_atq_ready
, input in_lsp_nalb_sch_rorply_ready
, output out_lsp_nalb_sch_rorply_ready
, input in_lsp_nalb_sch_unoord_ready
, output out_lsp_nalb_sch_unoord_ready
, input in_nalb_alarm_up_ready
, output out_nalb_alarm_up_ready
, input in_nalb_reset_done
, output out_nalb_reset_done
, input in_nalb_unit_idle
, output out_nalb_unit_idle
, input in_nalb_unit_pipeidle
, output out_nalb_unit_pipeidle
, input in_nalb_vf_reset_done
, output out_nalb_vf_reset_done
, input in_rop_nalb_enq_ready
, output out_rop_nalb_enq_ready
);
hqm_AW_if_prot_h i_lsp_nalb_sch_atq_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_atq_ready )
, .out_data ( out_lsp_nalb_sch_atq_ready )
);
hqm_AW_if_prot_h i_lsp_nalb_sch_rorply_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_rorply_ready )
, .out_data ( out_lsp_nalb_sch_rorply_ready )
);
hqm_AW_if_prot_h i_lsp_nalb_sch_unoord_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_nalb_sch_unoord_ready )
, .out_data ( out_lsp_nalb_sch_unoord_ready )
);
hqm_AW_if_prot_h i_nalb_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_alarm_up_ready )
, .out_data ( out_nalb_alarm_up_ready )
);
hqm_AW_if_prot_h i_nalb_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_reset_done )
, .out_data ( out_nalb_reset_done )
);
hqm_AW_if_prot_h i_nalb_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_unit_idle )
, .out_data ( out_nalb_unit_idle )
);
hqm_AW_if_prot_h i_nalb_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_unit_pipeidle )
, .out_data ( out_nalb_unit_pipeidle )
);
hqm_AW_if_prot_h i_nalb_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_vf_reset_done )
, .out_data ( out_nalb_vf_reset_done )
);
hqm_AW_if_prot_h i_rop_nalb_enq_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_nalb_enq_ready )
, .out_data ( out_rop_nalb_enq_ready )
);
endmodule ;
