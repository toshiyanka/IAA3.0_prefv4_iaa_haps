class hqm_mem_map_cfg extends ovm_object;

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
    `ovm_object_utils_begin(hqm_mem_map_cfg)
        `ovm_field_int(func_pf_low_base,    OVM_ALL_ON)
        `ovm_field_int(func_pf_hi_base,     OVM_ALL_ON)
        `ovm_field_int(func_pf_limit,       OVM_ALL_ON)
        `ovm_field_int(func_vf_low_base,    OVM_ALL_ON)
        `ovm_field_int(func_vf_hi_base,     OVM_ALL_ON)
        `ovm_field_int(func_vf_limit,       OVM_ALL_ON)
        `ovm_field_int(csr_pf_base,         OVM_ALL_ON)
        `ovm_field_int(csr_pf_limit,        OVM_ALL_ON)
        `ovm_field_int(dram_addr_hi,        OVM_ALL_ON)
        `ovm_field_int(dram_addr_lo,        OVM_ALL_ON)
    `ovm_object_utils_end

endclass
