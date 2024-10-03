module hqm_system_if_prot_h (
  input in_cwdi_interrupt_w_req_ready
, output out_cwdi_interrupt_w_req_ready
, input in_hcw_enq_b_req_ready
, output out_hcw_enq_b_req_ready
, input in_hcw_sched_aw_req_ready
, output out_hcw_sched_aw_req_ready
, input in_hcw_sched_w_req_ready
, output out_hcw_sched_w_req_ready
, input in_hqm_alarm_ready
, output out_hqm_alarm_ready
, input in_interrupt_w_req_ready
, output out_interrupt_w_req_ready
);
hqm_AW_if_prot_h i_cwdi_interrupt_w_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_cwdi_interrupt_w_req_ready )
, .out_data ( out_cwdi_interrupt_w_req_ready )
);
hqm_AW_if_prot_h i_hcw_enq_b_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_b_req_ready )
, .out_data ( out_hcw_enq_b_req_ready )
);
hqm_AW_if_prot_h i_hcw_sched_aw_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_aw_req_ready )
, .out_data ( out_hcw_sched_aw_req_ready )
);
hqm_AW_if_prot_h i_hcw_sched_w_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_w_req_ready )
, .out_data ( out_hcw_sched_w_req_ready )
);
hqm_AW_if_prot_h i_hqm_alarm_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_hqm_alarm_ready )
, .out_data ( out_hqm_alarm_ready )
);
hqm_AW_if_prot_h i_interrupt_w_req_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_interrupt_w_req_ready )
, .out_data ( out_interrupt_w_req_ready )
);
endmodule ;
