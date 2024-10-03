`ifndef HQM_SLA_PCIE_MEM_ERROR_SEQUENCE_
`define HQM_SLA_PCIE_MEM_ERROR_SEQUENCE_

class hqm_sla_pcie_mem_error_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_sla_pcie_mem_error_seq,sla_sequencer)
 
  hqm_sla_pcie_mem_ur_seq             mem_ur_seq;
  hqm_sla_pcie_mem_mtlp_seq           mem_mtlp_seq;
  hqm_sla_pcie_mem_mtlp_4kb_cross_seq mem_mtlp_4kb_cross_seq;
  hqm_sla_pcie_mem_ptlp_seq           mem_ptlp_seq;

  function new(string name = "hqm_sla_pcie_mem_error_seq");
    super.new(name);
  endfunction

  virtual task body();
    if($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO"))     begin `ovm_do(mem_ur_seq)   end
    if($test$plusargs("HQM_PCIE_MEM_MTLP_ERR"))           begin `ovm_do(mem_mtlp_seq) end
    if($test$plusargs("HQM_PCIE_MEM_MTLP_4KB_CROSS_ERR")) begin `ovm_do(mem_mtlp_4kb_cross_seq) end
    if($test$plusargs("HQM_PCIE_MEM_PTLP_ERR"))           begin `ovm_do(mem_ptlp_seq) end
  endtask

endclass

`endif
