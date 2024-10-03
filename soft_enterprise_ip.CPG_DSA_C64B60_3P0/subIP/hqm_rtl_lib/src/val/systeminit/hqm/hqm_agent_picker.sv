`topo_picker_class_begin(hqm_agent_picker, HQM_AGENT, base_hqm_agent_picker, RTL)

`run_knobs_begin
  `add_knob("pll_fuse_override_en",pll_fuse_override_en,bit)
  `add_knob("hqm_fuse_no_bypass",hqm_fuse_no_bypass,bit)
  `add_knob("fuse_speedup_en",fuse_speedup_en ,bit)
`run_knobs_end

function void pre_randomize();
    super.pre_randomize();
    `ovm_info("MY_INFO", "  I am in HQM subsystem AGENT Unit ",  OVM_LOW)
endfunction : pre_randomize

`picker_class_end
