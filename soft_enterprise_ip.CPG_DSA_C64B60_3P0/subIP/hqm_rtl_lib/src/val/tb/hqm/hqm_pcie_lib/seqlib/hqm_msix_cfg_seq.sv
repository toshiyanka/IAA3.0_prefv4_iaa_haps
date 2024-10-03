`ifndef HQM_MSIX_CFG_SEQ__SV
`define HQM_MSIX_CFG_SEQ__SV

class hqm_msix_cfg_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_msix_cfg_seq,sla_sequencer)

  rand bit[31:0] msix_data[`HQM_NUM_MSIX_VECTOR];

  constraint _unique_msix_data_ { unique { msix_data }; }

  function new(string name = "hqm_msix_cfg_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit        msix_func_mask = 1'b_0;
    bit        msix_vec_mask  = 1'b_0;
    bit        msix_en        = 1'b_1;

    bit [63:0] addr_alloc;
    `ovm_info(get_full_name(), $psprintf("hqm_msix_cfg_seq programming PF MSIX table as: ", ), OVM_LOW)
      
    pf_cfg_regs.MSIX_CAP_CONTROL.write(status,{msix_en,msix_func_mask,14'h_0},primary_id,this,.sai(legal_sai));

    `ovm_info(get_full_name(), $psprintf("HQM_PF MSIX_FUNC_MASK:(0x%0x); MSIX_EN:(0x%0x)", msix_func_mask, msix_en), OVM_LOW)

    foreach (hqm_msix_mem_regs.MSG_ADDR_U[i]) begin
      addr_alloc = get_sm_addr($psprintf("HQM_PF_%0d_MSIX_ADDR",i), 'h_1, 'h_3);
      hqm_msix_mem_regs.MSG_ADDR_U[i].write(status,addr_alloc[63:32],primary_id,this,.sai(legal_sai));
      hqm_msix_mem_regs.MSG_ADDR_L[i].write(status,addr_alloc[31:00],primary_id,this,.sai(legal_sai));

      hqm_msix_mem_regs.MSG_DATA[i].write(status,msix_data[i],primary_id,this,.sai(legal_sai));

      hqm_msix_mem_regs.VECTOR_CTRL[i].write(status,msix_vec_mask,primary_id,this,.sai(legal_sai));

      `ovm_info(get_full_name(), $psprintf("HQM_PF_MSIX_VECTOR (0x%0x) MSIX_ADDR:(0x%0x); MSIX_DATA:(0x%0x); MSIX_VECTOR_MASK:(0x%0x);", i, addr_alloc, msix_data[i], msix_vec_mask), OVM_LOW)

    end
    
  endtask

endclass

`endif
