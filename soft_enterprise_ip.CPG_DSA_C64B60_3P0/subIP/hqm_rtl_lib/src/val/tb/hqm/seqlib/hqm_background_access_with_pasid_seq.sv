`ifndef HQM_BACKGROUND_ACCESS_WITH_PASID_SEQ__SV
`define HQM_BACKGROUND_ACCESS_WITH_PASID_SEQ__SV

class hqm_background_access_with_pasid_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_background_access_with_pasid_seq,sla_sequencer)

  function new(string name = "hqm_background_access_with_pasid_seq");
    super.new(name);
  endfunction

  virtual task body();
   string file_name;
   // -- Generate bg accesses with PASID prefix -- //
   if ($value$plusargs({"HQM_BG_ACC_WITH_PASID","=%s"}, file_name)) begin rd_chk_file(file_name); end
   else `ovm_info(get_full_name(),$psprintf("Avoiding hqm_pf unimp chk since plusarg HQM_BG_ACC_WITH_PASID not defined ! "),OVM_LOW)

  endtask

endclass

`endif
