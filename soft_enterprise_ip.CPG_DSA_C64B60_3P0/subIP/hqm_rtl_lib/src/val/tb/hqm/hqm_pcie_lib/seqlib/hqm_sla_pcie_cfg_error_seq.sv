`ifndef HQM_SLA_PCIE_CFG_ERROR_SEQUENCE_
`define HQM_SLA_PCIE_CFG_ERROR_SEQUENCE_

class hqm_sla_pcie_cfg_error_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_cfg_error_seq,sla_sequencer)
 
  hqm_sla_pcie_cfg_poison_seq                     cfg_poison_seq; 
  hqm_sla_pcie_cfg_badparity_seq                  cfg_badparity_seq; 
  hqm_sla_pcie_cfg_busnum_seq                     cfg_busnum_seq; 
  hqm_pcie_aer_header_fp_behavior_masked_error    cfg_aer_header_fp_behavior_masked_error_seq;

  function new(string name = "hqm_sla_pcie_cfg_error_seq");
    super.new(name);
  endfunction

  virtual task body();
    if($test$plusargs("HQM_SLA_PCIE_CFG_POISON_ERR_SEQ")) `ovm_do(cfg_poison_seq);
    if($test$plusargs("HQM_SLA_PCIE_CFG_BADPARITY_ERR_SEQ")) `ovm_do(cfg_badparity_seq);
    if($test$plusargs("HQM_SLA_PCIE_CFG_BUSNUM_SEQ")) `ovm_do(cfg_busnum_seq);
    if($test$plusargs("HQM_SLA_PCIE_CFG_AER_HEADER_FP_BEHAVIOR_MASKED_ERROR_SEQ")) `ovm_do(cfg_aer_header_fp_behavior_masked_error_seq);
  endtask

endclass

`endif
