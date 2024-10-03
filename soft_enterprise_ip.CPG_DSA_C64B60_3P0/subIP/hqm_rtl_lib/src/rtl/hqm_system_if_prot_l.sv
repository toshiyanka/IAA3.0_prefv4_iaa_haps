module hqm_system_if_prot_l (
  input in_hcw_enq_aw_req_valid
, output out_hcw_enq_aw_req_valid
, input in_hcw_enq_w_req_valid
, output out_hcw_enq_w_req_valid
, input in_hcw_sched_b_req_valid
, output out_hcw_sched_b_req_valid
, input in_system_cfg_req_down_read
, output out_system_cfg_req_down_read
, input in_system_cfg_req_down_write
, output out_system_cfg_req_down_write
);
hqm_AW_if_prot_l i_hcw_enq_aw_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_aw_req_valid )
, .out_data ( out_hcw_enq_aw_req_valid )
);
hqm_AW_if_prot_l i_hcw_enq_w_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_enq_w_req_valid )
, .out_data ( out_hcw_enq_w_req_valid )
);
hqm_AW_if_prot_l i_hcw_sched_b_req_valid (
  .flr_prep ( flr_prep )
, .in_data ( in_hcw_sched_b_req_valid )
, .out_data ( out_hcw_sched_b_req_valid )
);
hqm_AW_if_prot_l i_system_cfg_req_down_read (
  .flr_prep ( flr_prep )
, .in_data ( in_system_cfg_req_down_read )
, .out_data ( out_system_cfg_req_down_read )
);
hqm_AW_if_prot_l i_system_cfg_req_down_write (
  .flr_prep ( flr_prep )
, .in_data ( in_system_cfg_req_down_write )
, .out_data ( out_system_cfg_req_down_write )
);
endmodule ;
