`ifndef HQM_ADDR_WITHIN_BAR_CHK_SEQ__SV
`define HQM_ADDR_WITHIN_BAR_CHK_SEQ__SV

class hqm_addr_within_bar_chk_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_addr_within_bar_chk_seq,sla_sequencer)

  function new(string name = "hqm_addr_within_bar_chk_seq");
    super.new(name);
  endfunction

  virtual task body();
   string file_name;
   // -- Check registers are within BAR space of HQM -- //
   if ($value$plusargs({"HQM_CHK_REG_WITHIN_BAR","=%s"}, file_name)) begin rd_chk_file(file_name); end
   else `ovm_info(get_full_name(),$psprintf("Avoiding hqm_pf unimp chk since plusarg HQM_CHK_REG_WITHIN_BAR not defined ! "),OVM_LOW)

  endtask

endclass

`endif
