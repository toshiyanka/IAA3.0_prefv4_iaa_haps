module hqm_system_if_prot_l_iso (
  input in_hqm_proc_clk_en
, output out_hqm_proc_clk_en
, input in_pdata_fifo_push
, output out_pdata_fifo_push
, input in_phdr_fifo_push
, output out_phdr_fifo_push
);
hqm_AW_if_prot_l i_hqm_proc_clk_en (
  .flr_prep ( flr_prep )
, .in_data ( in_hqm_proc_clk_en )
, .out_data ( out_hqm_proc_clk_en )
);
hqm_AW_if_prot_l i_pdata_fifo_push (
  .flr_prep ( flr_prep )
, .in_data ( in_pdata_fifo_push )
, .out_data ( out_pdata_fifo_push )
);
hqm_AW_if_prot_l i_phdr_fifo_push (
  .flr_prep ( flr_prep )
, .in_data ( in_phdr_fifo_push )
, .out_data ( out_phdr_fifo_push )
);
endmodule ;
