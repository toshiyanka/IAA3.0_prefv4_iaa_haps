import hqm_tb_cfg_pkg::*;

class hqm_policy_reg_cfg_seq extends hqm_base_seq ;

  `ovm_sequence_utils( hqm_policy_reg_cfg_seq, sla_sequencer)


  function new(string name = "hqm_policy_reg_cfg_seq");
    super.new(name);
  endfunction

  virtual task body();
    sla_ral_data_t rd_val;
   `ovm_info(get_full_name(),$sformatf("\n hqm_policy_reg_cfg_seq  Started \n"),OVM_LOW)
    compare_reg("HQM_CSR_CP_LO", `HQM_CSR_CP_LO, rd_val, "hqm_sif_csr") ;
    compare_reg("HQM_CSR_CP_HI", `HQM_CSR_CP_HI, rd_val, "hqm_sif_csr") ;
    write_reg("HQM_CSR_RAC_LO", `HQM_WR_ALL_0S, "hqm_sif_csr"); 
    write_reg("HQM_CSR_RAC_HI", `HQM_WR_ALL_0S, "hqm_sif_csr"); 
    write_reg("HQM_CSR_WAC_LO", `HQM_WR_ALL_0S, "hqm_sif_csr"); 
    write_reg("HQM_CSR_WAC_HI", `HQM_WR_ALL_0S, "hqm_sif_csr"); 
    compare_reg("HQM_CSR_RAC_LO", `HQM_WR_ALL_0S, rd_val, "hqm_sif_csr") ;
    compare_reg("HQM_CSR_RAC_HI", `HQM_WR_ALL_0S, rd_val, "hqm_sif_csr") ;
    compare_reg("HQM_CSR_WAC_LO", `HQM_WR_ALL_0S, rd_val, "hqm_sif_csr") ;
    compare_reg("HQM_CSR_WAC_HI", `HQM_WR_ALL_0S, rd_val, "hqm_sif_csr") ;
   `ovm_info(get_full_name(),$sformatf("\n hqm_policy_reg_cfg_seq  Completed \n"),OVM_LOW)
  endtask: body
endclass : hqm_policy_reg_cfg_seq


