
typedef class hqm_chassis_picker;
typedef class hqm_agent_picker;

`topo_picker_class_begin(hqm_arch_picker, HQM_ARCH, base_hqm_arch_picker, RTL)

   `run_knobs_begin
//      `add_knob("psf_cpk_enable", psf_cpk_enable, bit)
   `run_knobs_end


   function void post_randomize();
      hqm_chassis_picker hqm_chassis[$];
      hqm_agent_picker hqm_agent[$];
      `get_pickers_of_type("HQM_AGENT", hqm_agent);
//
//     if (nac_agent[0].nac_clock != NAC_CLOCK_CFG_DEFAULT) begin
//        `get_pickers_of_type("NAC_CHASSIS", nac_chassis);

//        `override_cfg_val(nac_chassis[0].irc_fuse_bypass, 0);
//        `override_cfg_val(nac_chassis[0].cgu_fuse_bypass, 0);
//        `override_cfg_val(nac_chassis[0].upma_dts0_fuse_bypass, 0);
//        `override_cfg_val(nac_chassis[0].upma_dts1_fuse_bypass, 0);
//        `override_cfg_val(nac_chassis[0].cpk_fuse_bypass, 0);
//     end

      super.post_randomize();
  endfunction: post_randomize

`picker_class_end

