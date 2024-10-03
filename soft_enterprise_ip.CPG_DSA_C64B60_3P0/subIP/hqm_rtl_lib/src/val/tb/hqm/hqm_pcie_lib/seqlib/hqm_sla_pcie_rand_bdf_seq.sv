`ifndef HQM_SLA_PCIE_RAND_BDF_SEQUENCE_
`define HQM_SLA_PCIE_RAND_BDF_SEQUENCE_

class hqm_sla_pcie_rand_bdf_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_sla_pcie_rand_bdf_seq, sla_sequencer)
  function new(string name = "hqm_sla_pcie_rand_bdf_seq");
    super.new(name);
  endfunction

  virtual task body();
	sla_ral_reg reg_list[$];
    int b_, d_, f_;

      reg_list.delete();
	  pf_cfg_regs.get_regs(reg_list);
      b_=reg_list[0].get_bus_num();
      d_=reg_list[0].get_dev_num();
      f_=reg_list[0].get_func_num();
      b_ = $urandom_range(1,255);
      `ovm_info(get_full_name(),$psprintf("Setting random bus number for PF as (0x%0x) and ARI function number as (0x%0x)",b_,{d_[4:0],f_[2:0]}),OVM_LOW)
      pf_cfg_regs.set_bdf(b_,d_,f_);
      pf_cfg_regs.CACHE_LINE_SIZE.write(status,8'h_55,primary_id,this,.sai(legal_sai));

  endtask


endclass

`endif
