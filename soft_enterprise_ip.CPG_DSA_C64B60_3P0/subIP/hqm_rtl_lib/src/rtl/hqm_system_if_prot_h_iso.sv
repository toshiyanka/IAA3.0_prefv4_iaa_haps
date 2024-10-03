module hqm_system_if_prot_h_iso (
  input in_iosf_alarm_ready
, output out_iosf_alarm_ready
);
hqm_AW_if_prot_h i_iosf_alarm_ready (
  .flr_prep ( flr_prep )
, .in_data ( in_iosf_alarm_ready )
, .out_data ( out_iosf_alarm_ready )
);
endmodule ;
