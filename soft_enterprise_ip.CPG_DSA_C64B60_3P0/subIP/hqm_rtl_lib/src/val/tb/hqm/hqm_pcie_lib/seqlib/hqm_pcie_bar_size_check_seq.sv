`ifndef HQM_PCIE_BAR_SIZE_CHECK_SEQ__SV
`define HQM_PCIE_BAR_SIZE_CHECK_SEQ__SV
`include "stim_config_macros.svh"

class hqm_pcie_bar_size_check_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_pcie_bar_size_check_seq,sla_sequencer)

    hqm_sla_pcie_init_seq           pcie_init_seq;

  function new(string name = "hqm_pcie_bar_size_check_seq");
    super.new(name);
  endfunction

  virtual task body();

      bit [63:0] pf_func_bar_exp, csr_bar_exp;
      bit [63:0] pf_func_bar_base, csr_bar_base;

	  `ovm_info(get_name(), $sformatf("Starting bar size check sequence"),OVM_LOW)

      // keep the expect sizes of each bar
      pf_func_bar_exp = ~(`HQM_PF_FUNC_BAR_SIZE);//64'h3ff_ffff; // 2^26 = 64MB
      csr_bar_exp     = ~(`HQM_PF_CSR_BAR_SIZE); //64'hffff_ffff; // 2^32 = 4GB
     
      // write 1's to all BAR registers
      pf_cfg_regs.FUNC_BAR_U.write(status,32'h_ffff_ffff,primary_id);
      pf_cfg_regs.FUNC_BAR_L.write(status,32'h_ffff_ffff,primary_id);
      pf_cfg_regs.CSR_BAR_U.write(status,32'h_ffff_ffff,primary_id);
      pf_cfg_regs.CSR_BAR_L.write(status,32'h_ffff_ffff,primary_id);

      // read back & compare the bar sizes from RTL with expect
      read_compare(pf_cfg_regs.FUNC_BAR_U, pf_func_bar_exp[63:32],32'h_ffffffff,result);
      read_compare(pf_cfg_regs.FUNC_BAR_L, {pf_func_bar_exp[31:4],4'hc},32'h_ffffffff,result);
      read_compare(pf_cfg_regs.CSR_BAR_U, csr_bar_exp[63:32],32'h_ffffffff,result);
      read_compare(pf_cfg_regs.CSR_BAR_L, {csr_bar_exp[31:0],4'hc},32'h_ffffffff,result);

      // Do PCIe initialization, get the base addresses from all 3 BARs
      `ovm_do(pcie_init_seq);

      pf_cfg_regs.FUNC_BAR_U.read(status,rd_val,primary_id);
      pf_func_bar_base[63:32] = rd_val[31:0];
      pf_cfg_regs.FUNC_BAR_L.read(status,rd_val,primary_id);
      pf_func_bar_base[31:4] = rd_val[31:4];

      pf_cfg_regs.CSR_BAR_U.read(status,rd_val,primary_id);
      csr_bar_base[63:32] = rd_val[31:0];
      pf_cfg_regs.CSR_BAR_L.read(status,rd_val,primary_id);
      csr_bar_base[31:4] = rd_val[31:4];

      pf_func_bar_exp = (`HQM_PF_FUNC_BAR_SIZE);           pf_func_bar_exp[1:0]=0;
      csr_bar_exp     = (`HQM_PF_CSR_BAR_SIZE);            csr_bar_exp[1:0]=0;
     
      // send a MRd to addresses adjacent (but outside) to BAR base address & expect URs
      send_tlp(get_tlp((pf_func_bar_base+pf_func_bar_exp+4), Iosf::MRd64),.ur(1));
      send_tlp(get_tlp((csr_bar_base+csr_bar_exp+4), Iosf::MRd64),.ur(1));

      send_tlp(get_tlp((pf_func_bar_base-4), Iosf::MRd64),.ur(1));
      send_tlp(get_tlp((csr_bar_base-4), Iosf::MRd64),.ur(1));

      // send a MRd to addresses adjacent (but inside) to BAR base address & expect Successful Completions
      send_tlp(get_tlp((pf_func_bar_base), Iosf::MRd64),.ur(0));
      send_tlp(get_tlp((csr_bar_base), Iosf::MRd64),.ur(0));

      send_tlp(get_tlp((pf_func_bar_base+pf_func_bar_exp), Iosf::MRd64),.ur(0));
      send_tlp(get_tlp((csr_bar_base+csr_bar_exp), Iosf::MRd64),.ur(0));

      `ovm_info(get_full_name(),$psprintf("Done with hqm_pcie_bar_size_check_seq "),OVM_LOW)
  endtask

endclass

`endif

