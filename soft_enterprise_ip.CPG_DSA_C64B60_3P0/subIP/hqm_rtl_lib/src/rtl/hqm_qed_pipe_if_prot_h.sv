module hqm_qed_pipe_if_prot_h (
  input in_nalb_qed_ready
, output out_nalb_qed_ready
, input in_qed_alarm_up_ready
, output out_qed_alarm_up_ready
, input in_qed_reset_done
, output out_qed_reset_done
, input in_qed_unit_idle
, output out_qed_unit_idle
, input in_qed_unit_pipeidle
, output out_qed_unit_pipeidle
, input in_qed_vf_reset_done
, output out_qed_vf_reset_done
, input in_rop_qed_enq_ready
, output out_rop_qed_enq_ready
);
hqm_AW_if_prot_h i_nalb_qed_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_nalb_qed_ready )
, .out_data ( out_nalb_qed_ready )
);
hqm_AW_if_prot_h i_qed_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_alarm_up_ready )
, .out_data ( out_qed_alarm_up_ready )
);
hqm_AW_if_prot_h i_qed_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_reset_done )
, .out_data ( out_qed_reset_done )
);
hqm_AW_if_prot_h i_qed_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_unit_idle )
, .out_data ( out_qed_unit_idle )
);
hqm_AW_if_prot_h i_qed_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_unit_pipeidle )
, .out_data ( out_qed_unit_pipeidle )
);
hqm_AW_if_prot_h i_qed_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_vf_reset_done )
, .out_data ( out_qed_vf_reset_done )
);
hqm_AW_if_prot_h i_rop_qed_enq_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_qed_enq_ready )
, .out_data ( out_rop_qed_enq_ready )
);
endmodule ;
