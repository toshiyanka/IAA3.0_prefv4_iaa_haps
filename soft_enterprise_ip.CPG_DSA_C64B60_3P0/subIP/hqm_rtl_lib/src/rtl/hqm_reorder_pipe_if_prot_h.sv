module hqm_reorder_pipe_if_prot_h (
  input in_chp_rop_hcw_ready
, output out_chp_rop_hcw_ready
, input in_rop_alarm_up_ready
, output out_rop_alarm_up_ready
, input in_rop_reset_done
, output out_rop_reset_done
, input in_rop_unit_idle
, output out_rop_unit_idle
, input in_rop_unit_pipeidle
, output out_rop_unit_pipeidle
, input in_rop_vf_reset_done
, output out_rop_vf_reset_done
);
hqm_AW_if_prot_h i_chp_rop_hcw_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_rop_hcw_ready )
, .out_data ( out_chp_rop_hcw_ready )
);
hqm_AW_if_prot_h i_rop_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_alarm_up_ready )
, .out_data ( out_rop_alarm_up_ready )
);
hqm_AW_if_prot_h i_rop_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_reset_done )
, .out_data ( out_rop_reset_done )
);
hqm_AW_if_prot_h i_rop_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_unit_idle )
, .out_data ( out_rop_unit_idle )
);
hqm_AW_if_prot_h i_rop_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_unit_pipeidle )
, .out_data ( out_rop_unit_pipeidle )
);
hqm_AW_if_prot_h i_rop_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_rop_vf_reset_done )
, .out_data ( out_rop_vf_reset_done )
);
endmodule ;
