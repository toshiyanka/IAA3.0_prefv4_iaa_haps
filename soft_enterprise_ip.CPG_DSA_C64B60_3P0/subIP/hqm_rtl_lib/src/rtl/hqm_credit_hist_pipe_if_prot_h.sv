module hqm_credit_hist_pipe_if_prot_h (
  input in_aqed_chp_sch_ready
, output out_aqed_chp_sch_ready
, input in_chp_alarm_up_ready
, output out_chp_alarm_up_ready
, input in_chp_reset_done
, output out_chp_reset_done
, input in_chp_unit_idle
, output out_chp_unit_idle
, input in_chp_unit_pipeidle
, output out_chp_unit_pipeidle
, input in_chp_vf_reset_done
, output out_chp_vf_reset_done
, input in_dqed_chp_sch_ready
, output out_dqed_chp_sch_ready
, input in_hcw_enq_aw_req_ready
, output out_hcw_enq_aw_req_ready
, input in_hcw_enq_w_req_ready
, output out_hcw_enq_w_req_ready
, input in_hcw_sched_b_req_ready
, output out_hcw_sched_b_req_ready
, input in_qed_chp_sch_ready
, output out_qed_chp_sch_ready
);
hqm_AW_if_prot_h i_aqed_chp_sch_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_aqed_chp_sch_ready )
, .out_data ( out_aqed_chp_sch_ready )
);
hqm_AW_if_prot_h i_chp_alarm_up_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_alarm_up_ready )
, .out_data ( out_chp_alarm_up_ready )
);
hqm_AW_if_prot_h i_chp_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_reset_done )
, .out_data ( out_chp_reset_done )
);
hqm_AW_if_prot_h i_chp_unit_idle (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_unit_idle )
, .out_data ( out_chp_unit_idle )
);
hqm_AW_if_prot_h i_chp_unit_pipeidle (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_unit_pipeidle )
, .out_data ( out_chp_unit_pipeidle )
);
hqm_AW_if_prot_h i_chp_vf_reset_done (
  .flr_prep ( flr_prep )
, .in_data ( in_chp_vf_reset_done )
, .out_data ( out_chp_vf_reset_done )
);
hqm_AW_if_prot_h i_dqed_chp_sch_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_dqed_chp_sch_ready )
, .out_data ( out_dqed_chp_sch_ready )
);
hqm_AW_if_prot_h i_hcw_enq_aw_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_aw_req_ready )
, .out_data ( out_hcw_enq_aw_req_ready )
);
hqm_AW_if_prot_h i_hcw_enq_w_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_w_req_ready )
, .out_data ( out_hcw_enq_w_req_ready )
);
hqm_AW_if_prot_h i_hcw_sched_b_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_b_req_ready )
, .out_data ( out_hcw_sched_b_req_ready )
);
hqm_AW_if_prot_h i_qed_chp_sch_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_chp_sch_ready )
, .out_data ( out_qed_chp_sch_ready )
);
endmodule ;
