module hqm_qed_pipe_if_prot_l (
  input in_qed_alarm_down_v
, output out_qed_alarm_down_v
, input in_qed_aqed_enq_v
, output out_qed_aqed_enq_v
, input in_qed_cfg_req_down_read
, output out_qed_cfg_req_down_read
, input in_qed_cfg_req_down_write
, output out_qed_cfg_req_down_write
, input in_qed_chp_sch_v
, output out_qed_chp_sch_v
);
hqm_AW_if_prot_l i_qed_alarm_down_v (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_alarm_down_v )
, .out_data ( out_qed_alarm_down_v )
);
hqm_AW_if_prot_l i_qed_aqed_enq_v (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_aqed_enq_v )
, .out_data ( out_qed_aqed_enq_v )
);
hqm_AW_if_prot_l i_qed_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_cfg_req_down_read )
, .out_data ( out_qed_cfg_req_down_read )
);
hqm_AW_if_prot_l i_qed_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_cfg_req_down_write )
, .out_data ( out_qed_cfg_req_down_write )
);
hqm_AW_if_prot_l i_qed_chp_sch_v (
  .flr_prep ( flr_prep )
, .in_data ( in_qed_chp_sch_v )
, .out_data ( out_qed_chp_sch_v )
);
endmodule ;
