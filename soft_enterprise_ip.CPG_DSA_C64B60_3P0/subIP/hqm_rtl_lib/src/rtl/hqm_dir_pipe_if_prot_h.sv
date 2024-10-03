module hqm_dir_pipe_if_prot_h (
  input in_dp_alarm_down_ready
, output out_dp_alarm_down_ready
, input in_dp_alarm_up_ready
, output out_dp_alarm_up_ready
, input in_dp_reset_done
, output out_dp_reset_done
, input in_dp_unit_idle
, output out_dp_unit_idle
, input in_dp_unit_pipeidle
, output out_dp_unit_pipeidle
, input in_dp_vf_reset_done
, output out_dp_vf_reset_done
, input in_lsp_dp_sch_dir_ready
, output out_lsp_dp_sch_dir_ready
, input in_lsp_dp_sch_rorply_ready
, output out_lsp_dp_sch_rorply_ready
, input in_rop_dp_enq_ready
, output out_rop_dp_enq_ready
);
hqm_AW_if_prot_h i_dp_alarm_down_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_alarm_down_ready )
, .out_data ( out_dp_alarm_down_ready )
);
hqm_AW_if_prot_h i_dp_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_alarm_up_ready )
, .out_data ( out_dp_alarm_up_ready )
);
hqm_AW_if_prot_h i_dp_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_reset_done )
, .out_data ( out_dp_reset_done )
);
hqm_AW_if_prot_h i_dp_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_unit_idle )
, .out_data ( out_dp_unit_idle )
);
hqm_AW_if_prot_h i_dp_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_unit_pipeidle )
, .out_data ( out_dp_unit_pipeidle )
);
hqm_AW_if_prot_h i_dp_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_dp_vf_reset_done )
, .out_data ( out_dp_vf_reset_done )
);
hqm_AW_if_prot_h i_lsp_dp_sch_dir_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_dp_sch_dir_ready )
, .out_data ( out_lsp_dp_sch_dir_ready )
);
hqm_AW_if_prot_h i_lsp_dp_sch_rorply_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_lsp_dp_sch_rorply_ready )
, .out_data ( out_lsp_dp_sch_rorply_ready )
);
hqm_AW_if_prot_h i_rop_dp_enq_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_dp_enq_ready )
, .out_data ( out_rop_dp_enq_ready )
);
endmodule ;
