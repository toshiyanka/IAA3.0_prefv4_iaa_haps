`ifndef hqm_sla_pcie_MSIx_seqUENCE_
`define hqm_sla_pcie_MSIx_seqUENCE_

class hqm_sla_pcie_MSIx_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_MSIx_seq,sla_sequencer)
  
  function new(string name = "hqm_sla_pcie_MSIx_seq");
    super.new(name);
  endfunction

  virtual task body();
  
//NS: FIXME update accesses to be made via ral
if($test$plusargs("MSIx_disable"))begin
//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h00476C11;addr_==32'h00000018;pcie_func_no==0;}); //disable MSIx signal
end 

if($test$plusargs("MSIx_enable"))begin
//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h80476C11;addr_==32'h00000018;pcie_func_no==0;}); //enable MSIx signal
end
endtask
endclass

`endif
