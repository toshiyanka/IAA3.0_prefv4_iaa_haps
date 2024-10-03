class hqm_mem_map_cfg extends uvm_object;

    bit[63:0] func_pf_low_base;
    bit[63:0] func_pf_hi_base;
    bit[63:0] func_pf_limit;

    bit[63:0] func_vf_low_base;
    bit[63:0] func_vf_hi_base;
    bit[63:0] func_vf_limit;

    bit[63:0] csr_pf_base;
    bit[63:0] csr_pf_limit;

    bit[63:0] dram_addr_hi;
    bit[63:0] dram_addr_lo;

    //---------------------------------------
    `uvm_object_utils_begin(hqm_mem_map_cfg)
        `uvm_field_int(func_pf_low_base,    UVM_ALL_ON)
        `uvm_field_int(func_pf_hi_base,     UVM_ALL_ON)
        `uvm_field_int(func_pf_limit,       UVM_ALL_ON)
        `uvm_field_int(func_vf_low_base,    UVM_ALL_ON)
        `uvm_field_int(func_vf_hi_base,     UVM_ALL_ON)
        `uvm_field_int(func_vf_limit,       UVM_ALL_ON)
        `uvm_field_int(csr_pf_base,         UVM_ALL_ON)
        `uvm_field_int(csr_pf_limit,        UVM_ALL_ON)
        `uvm_field_int(dram_addr_hi,        UVM_ALL_ON)
        `uvm_field_int(dram_addr_lo,        UVM_ALL_ON)
    `uvm_object_utils_end


  function new(string name="hqm_mem_map_cfg");  //[UVM MIGRATION]Added class constructer
     super.new(name);
  endfunction

endclass
