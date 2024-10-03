//-----------------------------------------------------------------//
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved//
//-----------------------------------------------------------------//
// Author       : Lakshmi Sridhar                                  //
// Date Created : 02-2017                                          //
//-----------------------------------------------------------------//
// Description:                                                    //
// HQM subsystem IP address map picker file                        //
//-----------------------------------------------------------------//
//-----------------------------------------------------------------//


/////////////////////////////////////////////////
// Picker for overall HQM mmio high intlv region
/////////////////////////////////////////////////

typedef class granular_region;

`picker_class_begin(hqm_mmio_high_intlv_region, region)
    string prefixStr;
    granular_region hqm_func_pf_bar_mmioh_region;
    granular_region hqm_func_vf_bar_mmioh_region;
    granular_region hqm_csr_mmioh_region;
    protected bit static_regions_created;
    int unsigned granularity;

    constraint granularity_c {
        (addr_lo % granularity) == 0;
        (addr_hi + 1) % granularity == 0;
    };

    function void pre_randomize();
        ovm_object obj;
        ovm_object hqmobj;
        base_top_cfg topCfg;
        base_hqm_cfg hqmCfg;
        super.pre_randomize();

        if (get_config_object("top_cfg", obj, 0) == 0) begin
            `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
        end
        if (get_config_object("hqm_cfg", hqmobj, 0) == 0) begin
            `ovm_info(get_name(), "HqmCfg object could not be retrieved in hqm addr map", OVM_HIGH)
        end
        assert($cast(topCfg, obj));
        assert($cast(hqmCfg, hqmobj));

        if (static_regions_created == 0) begin
            `add_subregion_extend(hqm_csr_mmioh_region, $sformatf("%s_hqm_csr_mmioh", prefixStr), granular_region)
            hqm_csr_mmioh_region.granularity = (4 << 30); //CSR 4GB aligned boundary
            `override_cfg_val(hqm_csr_mmioh_region.size, 4 << 30)  //CSR region is 4GB

            `add_subregion_extend(hqm_func_pf_bar_mmioh_region, $sformatf("%s_pf_func_bar_mmioh", prefixStr), granular_region)
            hqm_func_pf_bar_mmioh_region.granularity = (64 << 20); //pf 64B aligned boundary
            `override_cfg_val(hqm_func_pf_bar_mmioh_region.size, 64 << 20)  //PF Bar region is 64MB

            // For HQM on SNR, there will always be maximum of 16 virtual functions enabled
            if (topCfg.sriov_enable == 1) begin
                longint unsigned vf_region_size = ((64 << 20) * hqmCfg.num_hqm_vfs);      // Each VF Bar region is 64MB
                `add_subregion_extend(hqm_func_vf_bar_mmioh_region, $sformatf("%s_vf_func_bar_mmioh", prefixStr), granular_region)
                hqm_func_vf_bar_mmioh_region.granularity = (1 << 30); //VF 1GB aligned boundary
                `override_cfg_val(hqm_func_vf_bar_mmioh_region.size, vf_region_size) //VF Bar region is 64MB each
            end
            static_regions_created = 1;
        end
    endfunction : pre_randomize

`picker_class_end
