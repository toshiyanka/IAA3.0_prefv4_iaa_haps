// -*- mode: Verilog; verilog-indent-level: 3; -*-
//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2013 Intel -- All rights reserved
//-----------------------------------------------------------------
// Author       : Sumedh Attarde
// Date Created : Apr 2015
//-----------------------------------------------------------------
// Description:
// Picker classes for regions allocated to IO devices
//------------------------------------------------------------------

typedef class base_mmio_high_region;

class base_multicast_config extends ovm_object;
  `ovm_object_utils(base_multicast_config)
  int unsigned num_socket;
  int unsigned multicast_enable;
  int unsigned num_dramlo_regions;
  int unsigned num_dramhi_regions;
  int unsigned mcast_socket_targ[$];
  longint unsigned mcast_dramlo_num_groups[$];
  longint unsigned mcast_dramhi_num_groups[$];
  longint unsigned mcast_dramlo_index_pos[$];
  longint unsigned mcast_dramhi_index_pos[$];
  longint unsigned mcast_dramlo_region_size[$];
  longint unsigned mcast_dramhi_region_size[$];

  function int unsigned socket_has_dramlo_mcast(int unsigned skt);
        int          mcast_search[$] = mcast_socket_targ.find_index(s) with (s == skt);
        assert(mcast_search.size() == 1);
        return (mcast_search[0] < num_dramlo_regions);
  endfunction : socket_has_dramlo_mcast

  function int unsigned socket_has_dramhi_mcast(int unsigned skt);
       int           mcast_search[$] = mcast_socket_targ.find_index(s) with (s == skt);
       assert(mcast_search.size() == 1);
       return (mcast_search[0] >= num_dramlo_regions);
  endfunction : socket_has_dramhi_mcast

endclass : base_multicast_config

class base_vmdcfgbar_config extends ovm_object;
  `ovm_object_utils(base_vmdcfgbar_config)
  int unsigned socket[$];
  int unsigned m2iosf[$];
  int unsigned vmd_buses[$];
  int unsigned vmd_enable[$];
  bit cfgbar_mmiol[$];
  bit cfgbar_mmioh[$];
endclass : base_vmdcfgbar_config

`picker_class_begin(uboxmmiobase_bar_region, region)

    longint unsigned granularity;

    constraint uboxmmiobase_bar_granularity_c {
        (addr_lo & (size - 64'h1)) == 0;
        ((addr_hi + 1) & (size - 64'h1)) == 0;
        size == granularity;
    };

    function void pre_randomize();
        super.pre_randomize();
    endfunction: pre_randomize

`picker_class_end

`picker_class_begin(pcie_bar_region, region)

    longint unsigned min_size;

    constraint pcie_bar_granularity_c {
        (addr_lo & (size - 64'h1)) == 0;
        ((addr_hi + 1) & (size - 64'h1)) == 0;
        (size & (size - 64'h1)) == 0;
        size >= min_size;
    };

    function void pre_randomize();
        super.pre_randomize();
        if (min_size == 0) // uninitialized case
            min_size = 'h40; // can be overriden in the child's pre_randomize
    endfunction: pre_randomize

`picker_class_end

`picker_class_begin(fxr_hfi_bar_region, pcie_bar_region)

    string prefixStr;
    string suffixStr;
    bit static_regions_created;

    function void post_randomize();
        region txci;
        region rxci;
        super.post_randomize();
        if (static_regions_created == 0) begin
            `add_subregion_extend(txci, {prefixStr, "_txci", suffixStr}, region)
            `override_cfg_val(txci.size, 32'h200000);
            `override_cfg_val(txci.addr_lo, addr_lo);
            `override_cfg_val(txci.addr_hi, txci.addr_lo + txci.size - 1);
            `add_subregion_extend(rxci, {prefixStr, "_rxci", suffixStr}, region)
            `override_cfg_val(rxci.size, 32'h200000);
            `override_cfg_val(rxci.addr_lo, addr_lo + 32'h400000);
            `override_cfg_val(rxci.addr_hi, rxci.addr_lo + rxci.size - 1);
            static_regions_created = 1;
        end
    endfunction : post_randomize

`picker_class_end

`picker_class_begin(granular_region, region)
    longint unsigned granularity;

    constraint pcie_bar_granularity_c {
        (addr_lo & (granularity - 64'h1)) == 0;
        ((addr_hi + 1) & (granularity - 64'h1)) == 0;
    };

    function void pre_randomize();
        super.pre_randomize();
    endfunction : pre_randomize
`picker_class_end

`picker_class_begin(multicast_overlaybar_region, pcie_bar_region)
`picker_class_end

`picker_class_begin(vmdmembar2_mmio_high_region, base_mmio_high_region)
    longint unsigned min_size;

    constraint vmdmembar2_granularity_c {
        (addr_lo & (granularity - 64'h1)) == 0;
        ((addr_hi + 1) & (granularity - 64'h1)) == 0;
    };

    constraint membar2_msix_reserve_c {
        foreach (subregions[i]) {
            (subregions[i].addr_lo > (addr_lo + 'h1008));
        }
    };

    constraint size_c {
        size == granularity;
        size >= min_size;
    };

    function void pre_randomize();
        super.pre_randomize();
        granularity = (1 << 28);
    endfunction : pre_randomize
`picker_class_end

`picker_class_begin(npk_csrmtbbar_region, pcie_bar_region)
    rand int unsigned log_size;
    constraint legal_size_c {
        log_size >= 12;
        log_size <= 20;
    };
    constraint size_1mb_c {
        soft log_size == 20;
    };
    constraint logsize_c {
        size == (1 << log_size);
    };
`picker_class_end

`picker_class_begin(npk_swbar_region, pcie_bar_region)
    rand int unsigned log_size;
    constraint legal_size_c {
        log_size >= 12;
        log_size <= 32;
    };
    constraint logsize_c {
        size == (1 << log_size);
    };
`picker_class_end

`picker_class_begin(npk_rtitbar_region, pcie_bar_region)
    rand int unsigned log_size;
    constraint legal_size_c {
        log_size >= 12;
        log_size <= 32;
    };
    constraint logsize_c {
        size == (1 << log_size);
    };
`picker_class_end

`picker_class_begin(npk_fwbar_region, pcie_bar_region)
    rand int unsigned log_size;
    constraint legal_size_c {
        log_size >= 12;
        log_size <= 32;
    };
    constraint logsize_c {
        size == (1 << log_size);
    };
`picker_class_end

`picker_class_begin(mmio_low_region, region)
    `define MEMBAR_MMIOL_GRANULARITY 'h4_0000
    `define SCFBAR_MMIOL_GRANULARITY 'h4_0000
    `define PCUBAR_MMIOL_GRANULARITY 'h1000
    `define SBREGBAR_MMIOL_GRANULARITY 'h1_0000
    `define PORT_MMIOL_GRANULARITY 'h10_0000
    `define M2IOSF_MMIOL_GRANULARITY 'h40_0000
    `define UBOXMMIOBASE_MMIOL_GRANULARITY 'h80_0000
    `define SOCKET_MMIOL_GRANULARITY 'h100_0000
    `define TOP_MMIOL_GRANULARITY 'h100_0000
    `define VRP_MMIOL_MINSIZE 64'h600_0000
    `define RLINK_UPMEMBAR_MMIOL_GRANULARITY 64'h10000
    `define RLINK_DPMEMBAR_MMIOL_GRANULARITY 64'h8000
    `define CPM_SRIOVBAR0_MMIOL_GRANULARITY 64'h4000
    `define CPM_SRIOVBAR1_MMIOL_GRANULARITY 64'h2000
    `define CPM_SRIOVBAR2_MMIOL_GRANULARITY 64'h8000
    static const int unsigned      TOP = 0;
    static const int unsigned   SOCKET = 1;
    static const int unsigned   M2IOSF = 2;
    static const int unsigned     PCIE = 3;
    static const int unsigned UBOXMMIOBASE = 4;
    static const int unsigned    RLINK = 5;
    static const int unsigned VMDMEMBAR1 = 6;
    static const int unsigned      FXR = 7;
    static const int unsigned GFX_GUNIT = 8;
    static const int unsigned NTB_PB01BAR = 9;
    static const int unsigned NTB_PB23BAR = 10;
    static const int unsigned      VRP = 11;
    static const int unsigned      HQM = 12;
    static const int unsigned      TIP = 13;
    static const int unsigned      CPM = 14;
    static const int unsigned RLINK_66_DP = 15;

    protected bit static_regions_created;
    protected bit vmd_bars_set;
    protected bit cfgbar_regions_created;
    protected bit mcast_overlaybar_created;
    protected bit mcast_overlaybar_groups_created;
    bit generate_hierarchical_subregions = 0;
    int unsigned lockdown = 0;
    int unsigned hier;
    string prefixStr;
    int socket;
    int mmiolorder;
    int unsigned num_requestors;
    longint unsigned granularity;
    longint unsigned subregion_granularity;
    region mca_sgx_mmio_overlap_region;
    rand longint unsigned subregion_size [];
    longint unsigned minimum_region_size;
    rand mmio_low_region  mmioLowV[$];

    constraint vrp_mmiol_minsize_c {
        (hier == VRP) -> (size >= `VRP_MMIOL_MINSIZE);
    };

    constraint mmiol_noholes_c {
        ((hier == TOP || hier == SOCKET) && num_requestors > 0) -> (size == subregion_size.sum());
        foreach (subregions[i]) {
            subregion_size[i] == subregions[i].size;
            subregion_size[i] <= size;
        }
    };

    constraint mca_sgx_mmio_overlap_region_c{
      if(mca_sgx_mmio_overlap_region!=null){
         mca_sgx_mmio_overlap_region.size >0;
      }
    };

    constraint mmiol_granularity_c {
        (addr_lo & (granularity - 64'h1)) == 0;
        ((addr_hi + 1) & (granularity - 64'h1)) == 0;
    };

    constraint min_size_c {
        size >= (subregion_granularity * num_requestors);
    };

    constraint min_region_size_c {
        size >= minimum_region_size;
    };

    constraint mmiolorder_c {
        foreach (mmioLowV[i]) {
            foreach (mmioLowV[j]) {
                ((i != j) & (mmioLowV[i].mmiolorder > mmioLowV[j].mmiolorder)) -> (mmioLowV[i].addr_lo > mmioLowV[j].addr_lo);
            }
        }
    };

    virtual function longint unsigned probe_size_requests(int unsigned _hier = TOP, base_topo_cfg cfg = null);
        ovm_object obj;
        longint unsigned min_size = 0;
        int unsigned roundup = 1;
        longint unsigned mmiol_limit;
        longint unsigned mmcfg_size;
        longint unsigned tolm_check;
        longint unsigned mmiol_probe_roundup_threshold;
        get_config_int("mmiol_limit", mmiol_limit); // luckily mmiol is only 32-bit!!
        get_config_int("mmcfg_size",  mmcfg_size);  // luckily mmcfg is only 32-bit!!
        get_config_int("tolm_check",  tolm_check);  // luckily tolm is only 32-bit!!
        get_config_int("mmiol_probe_roundup_threshold", mmiol_probe_roundup_threshold);
        if (_hier == TOP) begin
            base_top_cfg topCfg;
            assert($cast(topCfg, cfg));
            foreach (topCfg.socketV[i])
                min_size += probe_size_requests(SOCKET, topCfg.socketV[i]);
            `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP calculated min size = 0x%0x", min_size), OVM_HIGH);
            `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP granularity = 0x%0x", `TOP_MMIOL_GRANULARITY), OVM_HIGH);
            if (min_size < `TOP_MMIOL_GRANULARITY)
                min_size = `TOP_MMIOL_GRANULARITY;
            `ovm_info("probe_size_requests", $sformatf("HIER TOP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == SOCKET) begin
            int ubox_mmiol;
            base_socket_cfg sktCfg;
            assert($cast(sktCfg, cfg));
            foreach (sktCfg.m2iosfV[i])
                min_size += probe_size_requests(M2IOSF, sktCfg.m2iosfV[i]);
            get_config_int("uboxmmio_mmio_low", ubox_mmiol);
            if (ubox_mmiol == 1)
                min_size += `UBOXMMIOBASE_MMIOL_GRANULARITY;
            if (min_size < `SOCKET_MMIOL_GRANULARITY)
                min_size = `SOCKET_MMIOL_GRANULARITY;
            if (min_size > (2 * `SOCKET_MMIOL_GRANULARITY))
                roundup = 0;
            `ovm_info("probe_size_requests", $sformatf("  HIER SOCKET%0d calculated min size = 0x%0x", sktCfg.inst_id, min_size), OVM_HIGH);
        end else if (_hier == M2IOSF) begin
            ovm_object obj2;
            base_top_cfg topCfg;
            base_m2iosf_cfg m2iosfCfg;
            base_rlink_cfg rlink_cfg;
            base_rlink_66_dp_cfg rlink_66_dp_cfg;
            base_tip_cfg tip_cfg;
            base_gfx_gunit_cfg gfx_gunit_cfg;
            base_vrp_cfg vrp_cfg;
            base_vmdcfgbar_config vmdcfgbar_cfg;
            int unsigned iommubar_enable;
            int unsigned oobmsmbar_enable;
            int m2iosf_iommubar_mmio_low;

            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            assert($cast(m2iosfCfg, cfg));
            if (get_config_object("vmdcfgbar_cfg", obj2, 0) == 0) begin
                `ovm_info(get_name(), "vmdcfgbar_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vmdcfgbar_cfg, obj2));
            foreach (m2iosfCfg.pcieV[i]) begin
                int pcie_rpmbar_mmio_low;
                int unsigned pcie_rpmbar_enable;
                get_config_int("pcie_rpmbar_mmio_low", pcie_rpmbar_mmio_low);
                get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);

                min_size += probe_size_requests(PCIE, m2iosfCfg.pcieV[i]);
                min_size += probe_size_requests(NTB_PB01BAR, m2iosfCfg.pcieV[i]);
                min_size += probe_size_requests(NTB_PB23BAR, m2iosfCfg.pcieV[i]);

                if ((pcie_rpmbar_mmio_low == 1) && (pcie_rpmbar_enable == 1) && (m2iosfCfg.pcieV[i].pcie_generation >= 4))
                    min_size += (1 << 17);
            end
            foreach (m2iosfCfg.rlinkV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_low = 0;

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_low", rlink_dpmembar_mmio_low);
`else
                get_config_int("rlink_membar_mmio_low", rlink_dpmembar_mmio_low);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_low == 1))
                    min_size += `RLINK_DPMEMBAR_MMIOL_GRANULARITY;
                min_size += probe_size_requests(RLINK, m2iosfCfg.rlinkV[i]);
            end
            foreach (m2iosfCfg.rlink66DPV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_low = 0;

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_low", rlink_dpmembar_mmio_low);
`else
                get_config_int("rlink_membar_mmio_low", rlink_dpmembar_mmio_low);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_low == 1))
                    min_size += `RLINK_DPMEMBAR_MMIOL_GRANULARITY;
                min_size += probe_size_requests(RLINK_66_DP, m2iosfCfg.rlink66DPV[i]);
            end
            foreach (m2iosfCfg.fxrV[i])
                min_size += probe_size_requests(FXR, m2iosfCfg.fxrV[i]);
            foreach (m2iosfCfg.hqmV[i])
                min_size += probe_size_requests(HQM, m2iosfCfg.hqmV[i]);
            foreach (m2iosfCfg.cpmV[i])
                min_size += probe_size_requests(CPM, m2iosfCfg.cpmV[i]);
            foreach (m2iosfCfg.tipV[i])
                min_size += probe_size_requests(TIP, m2iosfCfg.tipV[i]);
            foreach (m2iosfCfg.gfxGunitV[i])
                min_size += probe_size_requests(GFX_GUNIT, m2iosfCfg.gfxGunitV[i]);
            foreach (m2iosfCfg.vrpV[i])
                min_size += probe_size_requests(VRP, m2iosfCfg.vrpV[i]);
            // manage VMD cfgbar

            get_config_int("m2iosf_iommubar_mmio_low", m2iosf_iommubar_mmio_low);
            get_config_int("iommubar_enable", iommubar_enable);
            get_config_int("oobmsmbar_enable", oobmsmbar_enable);
            if (m2iosfCfg.has_vmd == 1) begin
                longint unsigned cfgbar_req = 0;
                if (vmdcfgbar_cfg == null) begin
                    cfgbar_req = ((1 << $clog2(m2iosfCfg.num_vmd_buses)) * `PCIE_CFGBUS_GRANULARITY);
                    `ovm_info("probe_size_requests", $sformatf("    HIER M2IOSF%0d adding size request 0x%0x owing to VMD (real size = 0x%0x)", m2iosfCfg.inst_id, cfgbar_req, cfgbar_req), OVM_HIGH);
                    min_size += cfgbar_req;
                end else begin
                    foreach (vmdcfgbar_cfg.cfgbar_mmiol[i]) begin
                        if ((m2iosfCfg.socket == vmdcfgbar_cfg.socket[i]) && (m2iosfCfg.inst_id == vmdcfgbar_cfg.m2iosf[i]) &&
                            (vmdcfgbar_cfg.vmd_enable[i] == 1) && (vmdcfgbar_cfg.cfgbar_mmiol[i] == 1))
                            cfgbar_req += ((1 << $clog2(m2iosfCfg.num_vmd_buses)) * `PCIE_CFGBUS_GRANULARITY);
                    end
                    min_size += cfgbar_req;
                    `ovm_info("probe_size_requests", $sformatf("    HIER M2IOSF%0d adding size request 0x%0x owing to VMD", m2iosfCfg.inst_id, cfgbar_req), OVM_HIGH);
                end
            end
            if (m2iosfCfg.has_dmi == 1)
                min_size += (1 << 12);
            if ((m2iosf_iommubar_mmio_low == 1) && (iommubar_enable == 1))
                min_size += (1 << 12);
            if (m2iosfCfg.has_npk == 1)
                min_size += (1 << 20);
            if ((m2iosfCfg.has_oobmsm == 1) && (oobmsmbar_enable == 1))
                min_size += ((1 << 20) + (1 << 19) + (1 << 19) + (1 << 12));
            if (min_size < `M2IOSF_MMIOL_GRANULARITY)
                min_size = `M2IOSF_MMIOL_GRANULARITY;
            `ovm_info("probe_size_requests", $sformatf("    HIER M2IOSF%0d calculated min size = 0x%0x", m2iosfCfg.inst_id, min_size), OVM_HIGH);
        end else if (_hier == PCIE) begin
            base_pcie_cfg pcieCfg;
            assert($cast(pcieCfg, cfg));
            if (pcieCfg.is_ntb == 0)
                min_size += `PORT_MMIOL_GRANULARITY;
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER PCIE%0d_%0d calculated min size = 0x%0x", pcieCfg.agent_id, pcieCfg.pcie_port, min_size), OVM_HIGH);
        end else if (_hier == NTB_PB01BAR) begin
            base_pcie_cfg pcieCfg;
            assert($cast(pcieCfg, cfg));
            if (pcieCfg.is_ntb == 1)
                min_size += (1 << pcieCfg.pribar01_size);
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER NTB_PB01BAR_%0d_%0d calculated min size = 0x%0x", pcieCfg.agent_id, pcieCfg.pcie_port, min_size), OVM_HIGH);
        end else if (_hier == NTB_PB23BAR) begin
            base_pcie_cfg pcieCfg;
            assert($cast(pcieCfg, cfg));
            if (pcieCfg.is_ntb == 1)
                min_size += (1 << pcieCfg.pribar23_size);
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER NTB_PB23BAR_%0d_%0d calculated min size = 0x%0x", pcieCfg.agent_id, pcieCfg.pcie_port, min_size), OVM_HIGH);
        end else if (_hier == RLINK) begin
            min_size += `PORT_MMIOL_GRANULARITY;
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER RLINK calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == RLINK_66_DP) begin
            min_size += `PORT_MMIOL_GRANULARITY;
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER RLINK_66_DP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == FXR) begin
            int fxr_hfi_mmio_low;
            int unsigned fxrbar_enable;
            get_config_int("fxr_hfi_mmio_low", fxr_hfi_mmio_low);
            get_config_int("fxrbar_enable", fxrbar_enable);
            if ((fxr_hfi_mmio_low == 1) && (fxrbar_enable == 1))
                min_size += (1 << 26);
            `ovm_info("probe_size_requests", $sformatf("      HIER FXR calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == CPM) begin
            base_cpm_cfg cpmCfg;
            int unsigned sriov_enable;
            int unsigned cpm_vfbar_mmio_low;
            assert($cast(cpmCfg, cfg));
            get_config_int("sriov_enable", sriov_enable);
            get_config_int("cpm_vfbar_mmio_low", cpm_vfbar_mmio_low);
            // SRIOVBAR0 - 16K per VF (2 ** 14)
            // SRIOVBAR1 -  8K per VF (2 ** 13)
            // SRIOVBAR2 - 32K per VF (2 ** 15)
            if ((sriov_enable == 1) && (cpm_vfbar_mmio_low == 1))
                min_size += (cpmCfg.max_num_virtual_functions * (`CPM_SRIOVBAR0_MMIOL_GRANULARITY + `CPM_SRIOVBAR1_MMIOL_GRANULARITY + `CPM_SRIOVBAR2_MMIOL_GRANULARITY));
            `ovm_info("probe_size_requests", $sformatf("      HIER CPM calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == GFX_GUNIT) begin
            min_size += `PORT_MMIOL_GRANULARITY;
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER GFX calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == VRP) begin
            min_size += `VRP_MMIOL_MINSIZE;
            min_size *= 2; //special handling for leaf allocations..
            `ovm_info("probe_size_requests", $sformatf("      HIER VRP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end
        `ovm_info("probe_size_requests", $sformatf("calculated min = 0x%0x", min_size), OVM_HIGH)
        if (min_size > (mmiol_limit + 64'h1 - tolm_check - mmcfg_size))
            min_size = mmiol_limit + 64'h1 - tolm_check - mmcfg_size;
        else if ((roundup == 1) && (min_size < mmiol_probe_roundup_threshold))
            min_size = (64'h1 << $clog2(min_size));
        `ovm_info("probe_size_requests", $sformatf("going to return min = 0x%0x", min_size), OVM_HIGH)
        return min_size;
    endfunction : probe_size_requests

    virtual function void setup_region();
        ovm_object obj;
        base_top_cfg topCfg;
        int unsigned hierarchical_mmiol_alloc;

        get_config_int("hierarchical_mmiol_alloc", hierarchical_mmiol_alloc);
        if (get_config_object("top_cfg", obj, 0) == 0) begin
            `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
        end
        assert($cast(topCfg, obj));
        if (hier == TOP) begin
            granularity = `TOP_MMIOL_GRANULARITY;
            subregion_granularity = `SOCKET_MMIOL_GRANULARITY;
            socket = -1;
            mmiolorder = -1;
        end
        if (hierarchical_mmiol_alloc == 0)
            return;
        if (hier == TOP)
            minimum_region_size = probe_size_requests(TOP, topCfg);
        else if (hier == SOCKET) begin
            base_socket_cfg sktCfg;
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            minimum_region_size = probe_size_requests(SOCKET, sktCfg);
        end else if (hier == M2IOSF) begin
            base_m2iosf_cfg m2iosfCfg;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));
            minimum_region_size = probe_size_requests(M2IOSF, m2iosfCfg);
        end else if (hier == PCIE) begin
            base_pcie_cfg pcieCfg;
            if (get_config_object("pcie_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(pcieCfg, obj));
            minimum_region_size = probe_size_requests(PCIE, pcieCfg);
        end else if (hier == NTB_PB01BAR) begin
            base_pcie_cfg pcieCfg;
            if (get_config_object("pcie_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(pcieCfg, obj));
            minimum_region_size = (probe_size_requests(NTB_PB01BAR, pcieCfg) >> 1); // discount the x2 padding in probe_size_requests at the leaf hierarchy
        end else if (hier == NTB_PB23BAR) begin
            base_pcie_cfg pcieCfg;
            if (get_config_object("pcie_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(pcieCfg, obj));
            minimum_region_size = (probe_size_requests(NTB_PB23BAR, pcieCfg) >> 1); // discount the x2 padding in probe_size_requests at the leaf hierarchy
        end else if (hier == RLINK) begin
            base_rlink_cfg rlinkCfg;
            if (get_config_object("rlink_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlinkCfg, obj));
            minimum_region_size = probe_size_requests(RLINK, rlinkCfg);
        end else if (hier == RLINK_66_DP) begin
            base_rlink_66_dp_cfg rlink66DPCfg;
            if (get_config_object("rlink_66_dp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_66_dp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlink66DPCfg, obj));
            minimum_region_size = probe_size_requests(RLINK_66_DP, rlink66DPCfg);
        end else if (hier == FXR) begin
            base_fxr_cfg fxrCfg;
            if (get_config_object("fxr_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "fxr_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(fxrCfg, obj));
            minimum_region_size = probe_size_requests(FXR);
        end else if (hier == GFX_GUNIT) begin
            base_gfx_gunit_cfg gfxGunitCfg;
            if (get_config_object("gfx_gunit_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "gfx_gunit_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(gfxGunitCfg, obj));
            minimum_region_size = probe_size_requests(GFX_GUNIT, gfxGunitCfg);
        end else if (hier == HQM) begin
            base_hqm_cfg hqmCfg;
            if (get_config_object("hqm_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "hqm_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(hqmCfg, obj));
            minimum_region_size = probe_size_requests(HQM, hqmCfg);
        end else if (hier == CPM) begin
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "cpm_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(cpmCfg, obj));
            minimum_region_size = probe_size_requests(CPM, cpmCfg);
        end else if (hier == TIP) begin
            base_tip_cfg tipCfg;
            if (get_config_object("tip_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "tip_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(tipCfg, obj));
            minimum_region_size = probe_size_requests(TIP, tipCfg);
        end else if (hier == VRP) begin
            base_vrp_cfg vrpCfg;
            if (get_config_object("vrp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "vrp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vrpCfg, obj));
            minimum_region_size = probe_size_requests(VRP, vrpCfg);
        end
    endfunction : setup_region

    virtual function void populate_mmio_regions();
        ovm_object obj;
        int unsigned hierarchical_mmiol_alloc;

        get_config_int("hierarchical_mmiol_alloc", hierarchical_mmiol_alloc);
        `ovm_info("SUMEDH DEBUG", $sformatf("populate_mmio_regions invoked for region %s with hierarchical_mmiol_alloc = %0d and generate_hierarchical_subregions = %0d", get_name(), hierarchical_mmiol_alloc, generate_hierarchical_subregions), OVM_HIGH)
        if (hier == TOP && static_regions_created == 0) begin
            base_top_cfg topCfg;
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            set_config_int("*", "sriov_enable", topCfg.sriov_enable);
            set_config_int("*", "iommubar_enable", topCfg.iommubar_enable);
            set_config_int("*", "fxrbar_enable", topCfg.fxrbar_enable);
            set_config_int("*", "oobmsmbar_enable", topCfg.oobmsmbar_enable);
            set_config_int("*", "pcie_rpmbar_enable", topCfg.pcie_rpmbar_enable);
            set_config_int("*", "rlink_membar_enable", topCfg.rlink_membar_enable);
            foreach (topCfg.socketV[i]) begin
                mmio_low_region mmioregion;
                string childName = $sformatf("s%0d", topCfg.socketV[i].inst_id);
                if ((topCfg.socketV[i].is_xnc_socket == 1) || (topCfg.socketV[i].is_fpga_socket == 1))
                    continue;
                if (topCfg.socketV[i].m2iosfV.size() == 0 && topCfg.socketV[i].uboxmmiobase_enable == 0)
                    continue;
                `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object(mmioregion.get_name(), "socket_cfg", topCfg.socketV[i], 0);
                mmioregion.hier = SOCKET;
                mmioregion.prefixStr = childName;
                mmioregion.socket = topCfg.socketV[i].inst_id;
                mmioregion.granularity = `SOCKET_MMIOL_GRANULARITY;
                mmioregion.subregion_granularity = `M2IOSF_MMIOL_GRANULARITY;
                mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end

            if(topCfg.mca_sgx_mmio_overlap_enable>0) begin
                `add_subregion_extend(mca_sgx_mmio_overlap_region, "mca_sgx_mmio_overlap_region", region)
            end
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
            if (topCfg.allow_mmio_holes == 1)
                mmiol_noholes_c.constraint_mode(0);
        end
        if (hier == SOCKET && static_regions_created == 0) begin
            base_top_cfg topCfg;
            ovm_object obj2;
            base_socket_cfg sktCfg;
            mmio_low_region uboxmmiobase_mmioregion;
            int uboxmmio_mmio_low;

            string childName;
            if (get_config_object("top_cfg", obj2, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj2));
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            //Create M2IOSF region
            foreach (sktCfg.m2iosfV[i]) begin
                mmio_low_region m2iosf_mmioregion;
                childName = $sformatf("%s_m2iosf%0d", prefixStr, sktCfg.m2iosfV[i].inst_id);
                `add_subregion_extend(m2iosf_mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object(m2iosf_mmioregion.get_name(), "m2iosf_cfg", sktCfg.m2iosfV[i], 0);
                m2iosf_mmioregion.hier = M2IOSF;
                m2iosf_mmioregion.prefixStr = childName;
                m2iosf_mmioregion.granularity = `M2IOSF_MMIOL_GRANULARITY;
                m2iosf_mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                m2iosf_mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                m2iosf_mmioregion.populate_mmio_regions();
                if (hierarchical_mmiol_alloc == 1)
                    min_size_c.constraint_mode(0);
                mmioLowV.push_back(m2iosf_mmioregion);
                num_requestors++;
                m2iosf_mmioregion.socket = socket;
            end
            get_config_int("uboxmmio_mmio_low", uboxmmio_mmio_low);
            if ((sktCfg.uboxmmiobase_enable == 1) && (uboxmmio_mmio_low == 1)) begin
                //Create UBOXMMIOBASE region
                //Used by UBOX to handle mmio accesses
                childName = $sformatf("%s_uboxmmiobase", prefixStr);
                `add_subregion_extend(uboxmmiobase_mmioregion, {childName, "_mmiol"}, mmio_low_region)
                uboxmmiobase_mmioregion.hier = UBOXMMIOBASE;
                uboxmmiobase_mmioregion.prefixStr = childName;
                uboxmmiobase_mmioregion.granularity = `UBOXMMIOBASE_MMIOL_GRANULARITY;
                uboxmmiobase_mmioregion.subregion_granularity = `MEMBAR_MMIOL_GRANULARITY;
                uboxmmiobase_mmioregion.socket = socket;
                uboxmmiobase_mmioregion.mmiolorder = 0;
                if (hierarchical_mmiol_alloc == 0)
                uboxmmiobase_mmioregion.populate_mmio_regions();
                mmioLowV.push_back(uboxmmiobase_mmioregion);
                `override_cfg_val(uboxmmiobase_mmioregion.size, `UBOXMMIOBASE_MMIOL_GRANULARITY);

                subregion_granularity = `UBOXMMIOBASE_MMIOL_GRANULARITY; // change from M2IOSF MMIOL granularity since it is coarser
                num_requestors++;
            end
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
            if (topCfg.allow_mmio_holes == 1)
                mmiol_noholes_c.constraint_mode(0);
        end
        if (hier == M2IOSF && static_regions_created == 0) begin
            base_m2iosf_cfg m2iosfCfg;
            int unsigned iommubar_enable;
            int unsigned oobmsmbar_enable;
            int m2iosf_iommubar_mmio_low;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));
            get_config_int("m2iosf_iommubar_mmio_low", m2iosf_iommubar_mmio_low);
            get_config_int("iommubar_enable", iommubar_enable);
            get_config_int("oobmsmbar_enable", oobmsmbar_enable);
            if ((m2iosf_iommubar_mmio_low == 1) && (iommubar_enable == 1)) begin
                pcie_bar_region iommubar_region;
                `add_subregion_extend(iommubar_region, {prefixStr, "_iommubar_mmiol"}, pcie_bar_region)
                `override_cfg_val(iommubar_region.size, (1 << 12));
            end
            foreach (m2iosfCfg.pcieV[i]) begin
                string childName;
                num_requestors++;
                if (m2iosfCfg.pcieV[i].vmd_enable == 1)
                    continue;

                childName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                if (m2iosfCfg.pcieV[i].pcie_generation >= 4) begin
                    int unsigned pcie_rpmbar_enable;
                    int unsigned pcie_rpmbar_mmio_low;
                    pcie_bar_region pcie_rpmbar_region;

                    get_config_int("pcie_rpmbar_mmio_low", pcie_rpmbar_mmio_low);
                    get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);
                    if ((pcie_rpmbar_mmio_low == 1) && (pcie_rpmbar_enable == 1)) begin
                        `add_subregion_extend(pcie_rpmbar_region, {childName, "_rootportmbar_mmiol"}, pcie_bar_region)
                        `override_cfg_val(pcie_rpmbar_region.size, (64'h1 << 17));
                    end
                end
                // NTB_PB01BAR
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_pribar01_mmiol"}, mmio_low_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = NTB_PB01BAR;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = (1 << m2iosfCfg.pcieV[i].pribar01_size);
                    mmioregion.subregion_granularity = mmioregion.granularity;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.populate_mmio_regions();
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar01_size));
                end
                // NTB_PB23BAR
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_pribar23_mmiol"}, mmio_low_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = NTB_PB23BAR;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = (1 << m2iosfCfg.pcieV[i].pribar23_size);
                    mmioregion.subregion_granularity = mmioregion.granularity;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.populate_mmio_regions();
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar23_size));
                end
                if (m2iosfCfg.pcieV[i].is_ntb == 0) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = PCIE;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                    mmioregion.subregion_granularity = mmioregion.granularity;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.populate_mmio_regions();
                end
            end
            foreach (m2iosfCfg.rlinkV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_low = 0;
                mmio_low_region mmioregion;
                string childName = $sformatf("%s_rlink%0d", prefixStr, m2iosfCfg.rlinkV[i].agent_id);

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_low", rlink_dpmembar_mmio_low);
`else
                get_config_int("rlink_membar_mmio_low", rlink_dpmembar_mmio_low);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_low == 1)) begin
                    pcie_bar_region rlink_dpmembar_region;
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_dpmembar_mmiol"}, pcie_bar_region)
                    `override_cfg_val(rlink_dpmembar_region.size, `RLINK_DPMEMBAR_MMIOL_GRANULARITY);
                end
                `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object({"*", mmioregion.get_name()}, "rlink_cfg", m2iosfCfg.rlinkV[i], 0);
                mmioregion.hier = RLINK;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.socket = socket;
                mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                    mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.rlink66DPV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_low = 0;
                mmio_low_region mmioregion;
                string childName = $sformatf("%s_rlink%0d", prefixStr, m2iosfCfg.rlink66DPV[i].agent_id);

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_low", rlink_dpmembar_mmio_low);
`else
                get_config_int("rlink_membar_mmio_low", rlink_dpmembar_mmio_low);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_low == 1)) begin
                    pcie_bar_region rlink_dpmembar_region;
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_dpmembar_mmiol"}, pcie_bar_region)
                    `override_cfg_val(rlink_dpmembar_region.size, `RLINK_DPMEMBAR_MMIOL_GRANULARITY);
                end
                `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object({"*", mmioregion.get_name()}, "rlink_66_dp_cfg", m2iosfCfg.rlink66DPV[i], 0);
                mmioregion.hier = RLINK_66_DP;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.socket = socket;
                mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                    mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.fxrV[i]) begin
                int fxr_hfi_mmio_low;
                int unsigned fxrbar_enable;
                fxr_hfi_bar_region fxr_hfi_bar;
                get_config_int("fxr_hfi_mmio_low", fxr_hfi_mmio_low);
                get_config_int("fxrbar_enable", fxrbar_enable);
                if ((fxr_hfi_mmio_low == 1) && (fxrbar_enable == 1)) begin
                    string childName = $sformatf("%s_fxr%0d_hfibar", prefixStr, m2iosfCfg.fxrV[i].agent_id);
                    `add_subregion_extend(fxr_hfi_bar, {childName, "_mmiol"}, fxr_hfi_bar_region)
                    `override_cfg_val(fxr_hfi_bar.size, (1 << 26));
                    fxr_hfi_bar.prefixStr = childName;
                    fxr_hfi_bar.suffixStr = "_mmiol";
                    num_requestors = num_requestors + 64;
                end
            end
            foreach (m2iosfCfg.gfxGunitV[i]) begin
                mmio_low_region mmioregion;
                string childName = $sformatf("%s_gfxgunit%0d", prefixStr, m2iosfCfg.gfxGunitV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object(mmioregion.get_name(), "gfx_gunit_cfg", m2iosfCfg.gfxGunitV[i], 0);
                mmioregion.hier = GFX_GUNIT;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.socket = socket;
                mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.vrpV[i]) begin
                mmio_low_region mmioregion;
                string childName = $sformatf("%s_vrp%0d_0", prefixStr, m2iosfCfg.vrpV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                set_config_object(mmioregion.get_name(), "vrp_cfg", m2iosfCfg.vrpV[i], 0);
                mmioregion.hier = VRP;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                mmioregion.socket = socket;
                mmioregion.mmiolorder = -1;
                if (hierarchical_mmiol_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.cpmV[i]) begin
                mmio_low_region mmioregion;
                int unsigned sriov_enable;
                int unsigned cpm_vfbar_mmio_low;
                get_config_int("sriov_enable", sriov_enable);
                get_config_int("cpm_vfbar_mmio_low", cpm_vfbar_mmio_low);
                if ((sriov_enable == 1) && (cpm_vfbar_mmio_low == 1)) begin
                    string childName = $sformatf("%s_cpm%0d", prefixStr, m2iosfCfg.cpmV[i].agent_id);
                    `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region)
                    set_config_object(mmioregion.get_name(), "cpm_cfg", m2iosfCfg.cpmV[i], 0);
                    mmioregion.hier = CPM;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                    mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.populate_mmio_regions();
                    num_requestors++;
                end
            end
            if (m2iosfCfg.has_npk == 1) begin
                npk_csrmtbbar_region npk_csrmtbbar;
                string childName = $sformatf("%s_npk_csrmtbbar", prefixStr);
                `add_subregion_extend(npk_csrmtbbar, {childName, "_mmiol"}, npk_csrmtbbar_region)
            end
            if (m2iosfCfg.has_dmi == 1) begin
                granular_region dmircbar;
                string childName = $sformatf("%s_dmircbar", prefixStr);
                `add_subregion_extend(dmircbar, {childName, "_mmiol"}, granular_region)
                dmircbar.granularity = (1 << 12);
            end
            if (m2iosfCfg.has_oobmsm == 1) begin
                if (oobmsmbar_enable == 1) begin
                    // create all 4 needed bars
                    granular_region dfdbar;
                    granular_region pmonbar;
                    granular_region telemetrybar;
                    granular_region msmbar;
                    string childName;

                    childName = $sformatf("%s_oobmsm_dfdbar_mmiol", prefixStr);
                    `add_subregion_extend(dfdbar, childName, granular_region)
                    dfdbar.granularity = (1 << 20);
                    `override_cfg_val(dfdbar.size, (1 << 20));

                    childName = $sformatf("%s_oobmsm_pmonbar_mmiol", prefixStr);
                    `add_subregion_extend(pmonbar, childName, granular_region)
                    pmonbar.granularity = (1 << 19);
                    `override_cfg_val(pmonbar.size, (1 << 19));

                    childName = $sformatf("%s_oobmsm_telemetrybar_mmiol", prefixStr);
                    `add_subregion_extend(telemetrybar, childName, granular_region)
                    telemetrybar.granularity = (1 << 19);
                    `override_cfg_val(telemetrybar.size, (1 << 19));

                    childName = $sformatf("%s_oobmsm_msmbar_mmiol", prefixStr);
                    `add_subregion_extend(msmbar, childName, granular_region)
                    msmbar.granularity = (1 << 12);
                    `override_cfg_val(msmbar.size, (1 << 12));
                end
            end
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == UBOXMMIOBASE && static_regions_created == 0) begin
            uboxmmiobase_bar_region scfbar_region;
            uboxmmiobase_bar_region sbregbar_region;
            uboxmmiobase_bar_region pcubar_region;
            uboxmmiobase_bar_region membar_region;
            //Add subregion for each mem bar
            for (int i = 0; i < 8; i++) begin
                `add_subregion_extend(membar_region, $sformatf("%s_membar%0d", prefixStr, i), uboxmmiobase_bar_region);
                membar_region.granularity = `MEMBAR_MMIOL_GRANULARITY;
                num_requestors++;
            end
            //Add SCF BAR subregion
            `add_subregion_extend(scfbar_region, $sformatf("%s_scfbar", prefixStr), uboxmmiobase_bar_region);
            scfbar_region.granularity = `SCFBAR_MMIOL_GRANULARITY;
            num_requestors++;
            //Add SBREG BAR subregion
            `add_subregion_extend(sbregbar_region, $sformatf("%s_sbregbar", prefixStr), uboxmmiobase_bar_region);
            sbregbar_region.granularity = `SBREGBAR_MMIOL_GRANULARITY;
            num_requestors++;
            //Add PCU BAR subregion
            `add_subregion_extend(pcubar_region, $sformatf("%s_pcubar", prefixStr), uboxmmiobase_bar_region);
            pcubar_region.granularity = `PCUBAR_MMIOL_GRANULARITY;
            num_requestors++;
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == PCIE) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
        end
        if (hier == NTB_PB23BAR) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
        end
        if (hier == RLINK && static_regions_created == 0) begin
            ovm_object obj;
            base_rlink_cfg rlinkCfg;
            int unsigned rlink_membar_enable;
            int unsigned rlink_upmembar_mmio_low = 0;
            static_regions_created = 1;
            get_config_int("rlink_membar_enable", rlink_membar_enable);
            get_config_int("rlink_upmembar_mmio_low", rlink_upmembar_mmio_low);
            if (get_config_object("rlink_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlinkCfg, obj));
            if ((rlink_upmembar_mmio_low == 1) && (rlink_membar_enable == 1) && (rlinkCfg.is_dmi == 0)) begin
                pcie_bar_region rlink_upmembar_region;
                `add_subregion_extend(rlink_upmembar_region, {prefixStr, "_upmembar_mmiol"}, pcie_bar_region)
                `override_cfg_val(rlink_upmembar_region.size, `RLINK_UPMEMBAR_MMIOL_GRANULARITY);
            end
            subregion_size = new [subregions.size()];
        end
        if (hier == RLINK_66_DP && static_regions_created == 0) begin
            ovm_object obj;
            base_rlink_66_dp_cfg rlink66DPCfg;
            int unsigned rlink_membar_enable;
            int unsigned rlink_upmembar_mmio_low = 0;
            static_regions_created = 1;
            get_config_int("rlink_membar_enable", rlink_membar_enable);
            get_config_int("rlink_upmembar_mmio_low", rlink_upmembar_mmio_low);
            if (get_config_object("rlink_66_dp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_66_dp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlink66DPCfg, obj));
            if ((rlink_upmembar_mmio_low == 1) && (rlink_membar_enable == 1) && (rlink66DPCfg.is_dmi == 0)) begin
                pcie_bar_region rlink_upmembar_region;
                `add_subregion_extend(rlink_upmembar_region, {prefixStr, "_upmembar_mmiol"}, pcie_bar_region)
                `override_cfg_val(rlink_upmembar_region.size, `RLINK_UPMEMBAR_MMIOL_GRANULARITY);
            end
            subregion_size = new [subregions.size()];
        end
        if (hier == FXR && static_regions_created == 0) begin
            // do nothing for now
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == GFX_GUNIT && static_regions_created == 0) begin
            // do nothing for now
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == VRP && static_regions_created == 0) begin
            ovm_object obj;
            base_vrp_cfg vrpCfg;
            region vrp_mmio;
            if (get_config_object("vrp_cfg", obj, 0) == 0)
                return;
            assert($cast(vrpCfg, obj));
            `add_subregion_extend(vrp_mmio, $sformatf("S%0d_VRP%0d_0_MMIO", socket, vrpCfg.inst_id), region)
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == CPM && static_regions_created == 0) begin
            int unsigned sriov_enable;
            int unsigned cpm_vfbar_mmio_low;
            ovm_object obj;
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0)
                return;
            assert($cast(cpmCfg, obj));
            get_config_int("sriov_enable", sriov_enable);
            get_config_int("cpm_vfbar_mmio_low", cpm_vfbar_mmio_low);
            if ((sriov_enable == 1) && (cpm_vfbar_mmio_low == 1)) begin
                granular_region sriovbar0, sriovbar1, sriovbar2;
                `add_subregion_extend(sriovbar0, {prefixStr, "_sriovbar0_mmiol"}, granular_region)
                `add_subregion_extend(sriovbar1, {prefixStr, "_sriovbar1_mmiol"}, granular_region)
                `add_subregion_extend(sriovbar2, {prefixStr, "_sriovbar2_mmiol"}, granular_region)

                // SRIOVBAR0 - 16K per VF (2 ** 14)
                // SRIOVBAR1 -  8K per VF (2 ** 13)
                // SRIOVBAR2 - 32K per VF (2 ** 15)
                `override_cfg_val(sriovbar0.size, `CPM_SRIOVBAR0_MMIOL_GRANULARITY * cpmCfg.max_num_virtual_functions);
                `override_cfg_val(sriovbar1.size, `CPM_SRIOVBAR1_MMIOL_GRANULARITY * cpmCfg.max_num_virtual_functions);
                `override_cfg_val(sriovbar2.size, `CPM_SRIOVBAR2_MMIOL_GRANULARITY * cpmCfg.max_num_virtual_functions);

                sriovbar0.granularity = `CPM_SRIOVBAR0_MMIOL_GRANULARITY;
                sriovbar1.granularity = `CPM_SRIOVBAR1_MMIOL_GRANULARITY;
                sriovbar2.granularity = `CPM_SRIOVBAR2_MMIOL_GRANULARITY;
            end
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
//        if (mca_sgx_mmio_overlap_region == null) begin
//	        mca_sgx_mmio_overlap_region.rand_mode(0);
//        end

    endfunction : populate_mmio_regions

    function void create_multicast_overlay();
        base_multicast_config mcast_cfg;
        base_pcie_cfg pcieCfg;
        ovm_object obj;

        if (get_config_object("mcast_cfg", obj, 0) == 0)
            return;
        assert($cast(mcast_cfg, obj));
        if (mcast_cfg.multicast_enable == 0 || mcast_cfg.socket_has_dramlo_mcast(socket) == 0)
            return;
        if (get_config_object("pcie_cfg", obj, 0) == 0)
            `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
        assert($cast(pcieCfg, obj));
        if (mcast_overlaybar_created == 1)
            return;
        if (pcieCfg.group_mask > 0) begin
            multicast_overlaybar_region mcast_overlay_bar;
            string mcastOverlayName = $sformatf("%s_mcast_overlaybar_mmiol", prefixStr);
            `add_subregion_extend(mcast_overlay_bar, mcastOverlayName, multicast_overlaybar_region);
            mcast_overlay_bar.min_size = `PORT_MMIOL_GRANULARITY;
        end
        mcast_overlaybar_created = 1;
        subregion_size = new [subregions.size()];
    endfunction : create_multicast_overlay

    function void pre_randomize();
        int unsigned hierarchical_mmiol_alloc;

        get_config_int("lockdown", lockdown);
        if (lockdown == 1)
            return;
        get_config_int("hierarchical_mmiol_alloc", hierarchical_mmiol_alloc);
        super.pre_randomize();
        setup_region();
        `ovm_info(get_name(), $sformatf("SUMEDH: DEBUG: finished setting up region %s", get_name()), OVM_HIGH)
        if (hierarchical_mmiol_alloc == 0)
            min_region_size_c.constraint_mode(0);
        if ((hierarchical_mmiol_alloc == 1) && (generate_hierarchical_subregions == 1))
            populate_mmio_regions();
        `ovm_info(get_name(), $sformatf("SUMEDH: DEBUG: now finished pre_randomize"), OVM_HIGH);
    endfunction : pre_randomize

    function void post_randomize();
        int unsigned hierarchical_mmiol_alloc;

        get_config_int("hierarchical_mmiol_alloc", hierarchical_mmiol_alloc);
        `ovm_info("SUMEDH DEBUG", $sformatf("in post_randomize for region %s", get_name()), OVM_HIGH);
        get_config_int("lockdown", lockdown);
        if (lockdown == 1)
            return;
        if ((hier == PCIE) || (hier == NTB_PB23BAR)) begin
            base_pcie_cfg pcieCfg;
            ovm_object obj;

            if (get_config_object("pcie_cfg", obj, 0) == 0)
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            assert($cast(pcieCfg, obj));
            if (pcieCfg.group_mask > 0 && mcast_overlaybar_groups_created == 0) begin
                region bar_with_groups;
                int unsigned group_mask_copy;
                string wGroupName;

                mcast_overlaybar_groups_created = 1;
                wGroupName = prefixStr;
                group_mask_copy = pcieCfg.group_mask;
                for (int unsigned group_ix = 0; group_mask_copy > 0; group_ix++) begin
                    if ((group_mask_copy % 2) == 1)
                        wGroupName = $sformatf("%s_group%0d", wGroupName, group_ix);
                    group_mask_copy = group_mask_copy >> 1;
                end
                wGroupName = {wGroupName, "_mcast_overlaybar_mmiol"};
                foreach (subregions[i]) begin
                    if (ovm_is_match("*_mcast_overlaybar_mmiol", subregions[i].name)) begin
                        `add_subregion_extend(bar_with_groups, wGroupName, region, subregions[i]);
                        bar_with_groups.addr_lo = subregions[i].addr_lo;
                        bar_with_groups.addr_hi = subregions[i].addr_hi;
                        bar_with_groups.size = subregions[i].size;
                    end
                end
            end
            subregion_size = new [subregions.size()];
        end
        if (hier == M2IOSF) begin
            region parent_cfgbar;
            base_m2iosf_cfg m2iosfCfg;
            ovm_object obj;
            int unsigned found_cfgbar = 0;

            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));

            if (vmd_bars_set == 1) begin
            foreach (subregions[i]) begin
                if (subregions[i].name == $sformatf("%s_vmdcfgbar_mmiol", prefixStr)) begin
                    found_cfgbar = 1;
                    parent_cfgbar = subregions[i];
                end
            end
                if ((found_cfgbar == 1) && (cfgbar_regions_created == 0)) begin
            cfgbar_regions_created = 1;
            foreach (m2iosfCfg.pcieV[i]) begin
                string pcieChildName;
                region vmd_pcie_cfg0;
                region vmd_pcie_cfg1;
                if (m2iosfCfg.pcieV[i].vmd_enable == 0)
                    continue;
                if (m2iosfCfg.pcieV[i].is_ntb == 1)
                    continue;
                pcieChildName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                `add_subregion_extend(vmd_pcie_cfg0, {pcieChildName, "_cfg0_mmcfg"}, region, parent_cfgbar)
                `override_cfg_val(vmd_pcie_cfg0.addr_lo, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus - m2iosfCfg.base_vmd_bus) * `PCIE_CFGBUS_GRANULARITY)
                `override_cfg_val(vmd_pcie_cfg0.addr_hi, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus - m2iosfCfg.base_vmd_bus + 1) * `PCIE_CFGBUS_GRANULARITY - 1)
                `override_cfg_val(vmd_pcie_cfg0.size, vmd_pcie_cfg0.addr_hi - vmd_pcie_cfg0.addr_lo + 1)
                if (m2iosfCfg.pcieV[i].subordinate_bus > m2iosfCfg.pcieV[i].secondary_bus) begin
                    `add_subregion_extend(vmd_pcie_cfg1, {pcieChildName, "_cfg1_mmcfg"}, region, parent_cfgbar)
                    `override_cfg_val(vmd_pcie_cfg1.addr_lo, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus + 1 - m2iosfCfg.base_vmd_bus) * `PCIE_CFGBUS_GRANULARITY)
                    `override_cfg_val(vmd_pcie_cfg1.addr_hi, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].subordinate_bus - m2iosfCfg.base_vmd_bus + 1) * `PCIE_CFGBUS_GRANULARITY - 1)
                    `override_cfg_val(vmd_pcie_cfg1.size, vmd_pcie_cfg1.addr_hi - vmd_pcie_cfg1.addr_lo + 1)
                end
            end
            subregion_size = new [subregions.size()];
        end
            end
        end
        if (hier == VRP) begin
            foreach (subregions[i]) begin
                if (ovm_is_match("*S?_VRP?_0_MMIO", subregions[i].name)) begin
                    subregions[i].addr_lo  = addr_lo;
                    subregions[i].addr_hi  = addr_hi;
                    subregions[i].size     = size;
                end
            end
        end
        if (hier == CPM) begin
            ovm_object obj;
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0)
                return;
            assert($cast(cpmCfg, obj));
            foreach (subregions[i]) begin
                if (ovm_is_match("*_sriovbar0_mmiol", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar0_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar0_vf%0d_mmiol", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR0_MMIOL_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR0_MMIOL_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end else if (ovm_is_match("*_sriovbar1_mmiol", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar1_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar1_vf%0d_mmiol", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR1_MMIOL_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR1_MMIOL_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end else if (ovm_is_match("*_sriovbar2_mmiol", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar2_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar2_vf%0d_mmiol", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR2_MMIOL_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR2_MMIOL_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end
            end
        end
        if (hierarchical_mmiol_alloc == 1) begin
            foreach (subregions[i]) begin
                mmio_low_region ml;
                if ($cast(ml, subregions[i])) begin
                    ml.populate_mmio_regions();
                    ml.generate_hierarchical_subregions = 1;
                    ml.setup_vmd_bars();
                end
                subregions[i].addr_lo.rand_mode(0);
                subregions[i].addr_hi.rand_mode(0);
                subregions[i].size.rand_mode(0);
                `ovm_info("SUMEDH: DEBUG", $sformatf("now starting randomization of subregion %s from region %s with limits [0x%0x : 0x%0x]", subregions[i].get_name(), get_name(), subregions[i].addr_lo, subregions[i].addr_hi), OVM_HIGH)
                subregions[i].randomize();
                `ovm_info("SUMEDH: DEBUG", $sformatf("now finished randomization of subregion %s from region %s with limits [0x%0x : 0x%0x]", subregions[i].get_name(), get_name(), subregions[i].addr_lo, subregions[i].addr_hi), OVM_HIGH)
            end
        end
        super.post_randomize();
    endfunction : post_randomize

    virtual function void setup_vmd_bars();
        int unsigned hierarchical_mmiol_alloc;

        get_config_int("hierarchical_mmiol_alloc", hierarchical_mmiol_alloc);
        if (hier == TOP) begin
            base_top_cfg topCfg;
            ovm_object obj;
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            foreach (subregions[i]) begin
               mmio_low_region sub_mmiol;
               assert($cast(sub_mmiol, subregions[i]));
               if (sub_mmiol != null) begin
                   foreach (topCfg.socketV[i]) begin
                       if (sub_mmiol.prefixStr == $sformatf("s%0d", topCfg.socketV[i].inst_id))
                           set_config_object(sub_mmiol.get_name(), "socket_cfg", topCfg.socketV[i], 0);
                   end
                   if (hierarchical_mmiol_alloc == 0)
                   sub_mmiol.setup_vmd_bars();
               end
            end
        end
        if (hier == SOCKET) begin
            base_socket_cfg sktCfg;
            ovm_object obj;
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            foreach (subregions[i]) begin
                mmio_low_region sub_mmiol;
                assert($cast(sub_mmiol, subregions[i]));
                if(sub_mmiol == null) continue;
                foreach (sktCfg.m2iosfV[i]) begin
                    if (sub_mmiol.prefixStr == $sformatf("%s_m2iosf%0d", prefixStr, sktCfg.m2iosfV[i].inst_id))
                        set_config_object(sub_mmiol.get_name(), "m2iosf_cfg", sktCfg.m2iosfV[i], 0);
                end
                if (hierarchical_mmiol_alloc == 0)
                sub_mmiol.setup_vmd_bars();
            end
        end
        if (hier == M2IOSF) begin
            ovm_object obj;
            string childName;
            base_m2iosf_cfg m2iosfCfg;
            mmio_low_region vmdmembar1_region;
            base_vmdcfgbar_config vmdcfgbar_cfg;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));

            if (m2iosfCfg.has_vmd == 0)
                return;
            if (get_config_object("vmdcfgbar_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "vmdcfgbar_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vmdcfgbar_cfg, obj));

            if (vmd_bars_set == 1)
                return;
            // Check if CFGBAR for this M2IOSF is in MMIOL
            foreach (vmdcfgbar_cfg.cfgbar_mmiol[i]) begin
                if (vmdcfgbar_cfg.cfgbar_mmiol[i] == 0)
                    continue;
                if (vmdcfgbar_cfg.socket[i] == socket && vmdcfgbar_cfg.m2iosf[i] == m2iosfCfg.inst_id) begin
                    granular_region cfgbar_mmioregion;
                    string childName = $sformatf("%s_vmdcfgbar", prefixStr);
                    `add_subregion_extend(cfgbar_mmioregion, {childName, "_mmiol"}, granular_region)
                    `override_cfg_val(cfgbar_mmioregion.size, vmdcfgbar_cfg.vmd_buses[i] * `PCIE_CFGBUS_GRANULARITY);
                    cfgbar_mmioregion.granularity = cfgbar_mmioregion.size;
                end
            end
            childName = $sformatf("%s_vmdmembar1", prefixStr);
            `add_subregion_extend(vmdmembar1_region, {childName, "_mmiol"}, mmio_low_region)
            vmdmembar1_region.hier = VMDMEMBAR1;
            vmdmembar1_region.prefixStr = prefixStr;
            vmdmembar1_region.granularity = `PORT_MMIOL_GRANULARITY;
            vmdmembar1_region.subregion_granularity = `PORT_MMIOL_GRANULARITY;
            vmdmembar1_region.socket = socket;
            foreach (m2iosfCfg.pcieV[i]) begin
                if (m2iosfCfg.pcieV[i].vmd_enable == 0)
                    continue;
                childName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                if (m2iosfCfg.pcieV[i].pcie_generation >= 4) begin
                    int unsigned pcie_rpmbar_enable;
                    int unsigned pcie_rpmbar_mmio_low;
                    pcie_bar_region pcie_rpmbar_region;

                    get_config_int("pcie_rpmbar_mmio_low", pcie_rpmbar_mmio_low);
                    get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);
                    if ((pcie_rpmbar_mmio_low == 1) && (pcie_rpmbar_enable == 1)) begin
                        `add_subregion_extend(pcie_rpmbar_region, {childName, "_rootportmbar_mmiol"}, pcie_bar_region, vmdmembar1_region)
                        `override_cfg_val(pcie_rpmbar_region.size, (64'h1 << 17));
                    end
                end
                if (m2iosfCfg.pcieV[i].is_ntb == 0) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_mmiol"}, mmio_low_region, vmdmembar1_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = PCIE;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = `PORT_MMIOL_GRANULARITY;
                    mmioregion.subregion_granularity = `PORT_MMIOL_GRANULARITY;
                    mmioregion.socket = socket;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.setup_vmd_bars();
                end
                // NTB_PB01BAR
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_pribar01_mmiol"}, mmio_low_region, vmdmembar1_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = NTB_PB01BAR;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = (1 << m2iosfCfg.pcieV[i].pribar01_size);
                    mmioregion.subregion_granularity = mmioregion.granularity;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.setup_vmd_bars();
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar01_size));
                end
                // NTB_PB23BAR
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    mmio_low_region mmioregion;
                    `add_subregion_extend(mmioregion, {childName, "_pribar23_mmiol"}, mmio_low_region, vmdmembar1_region)
                    set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                    mmioregion.hier = NTB_PB23BAR;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = (1 << m2iosfCfg.pcieV[i].pribar23_size);
                    mmioregion.subregion_granularity = mmioregion.granularity;
                    mmioregion.socket = socket;
                    mmioregion.mmiolorder = -1;
                    if (hierarchical_mmiol_alloc == 0)
                        mmioregion.setup_vmd_bars();
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar23_size));
                end
            end
            subregion_size = new [subregions.size()];
            vmd_bars_set = 1;
            vmdmembar1_region.subregion_size = new [vmdmembar1_region.subregions.size()];
        end
        if (hier == PCIE) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
            vmd_bars_set = 1;
        end
        if (hier == NTB_PB01BAR) begin
            vmd_bars_set = 1;
        end
        if (hier == NTB_PB23BAR) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
            vmd_bars_set = 1;
        end
    endfunction : setup_vmd_bars

`picker_class_end

`picker_class_begin(base_mmio_high_region, region)
    `define MMIOH_BLOCK_MODE_GRANULARITY 'h4000_0000
    `define MMIOH_INTERLEAVE_INDEX_START 30
    `define MMIOH_INTERLEAVE_BASELIMIT_INDEX_START 26
    `define MAX_NUM_MMIOH_INTERLEAVE_RULES 32
    `define PORT_MMIOH_GRANULARITY 'h10_0000
    `define CBDMABAR_MMIOH_GRANULARITY  'h4000
    `define UBOXMMIOBASE_MMIOH_GRANULARITY 'h80_0000
    `define MEMBAR_MMIOH_GRANULARITY 'h4_0000
    `define SCFBAR_MMIOH_GRANULARITY 'h4_0000
    `define PCUBAR_MMIOH_GRANULARITY 'h1000
    `define SBREGBAR_MMIOH_GRANULARITY 'h1_0000
    `define RLINK_UPMEMBAR_MMIOH_GRANULARITY 64'h10000
    `define RLINK_DPMEMBAR_MMIOH_GRANULARITY 64'h8000
    `define CPM_SRIOVBAR0_MMIOH_GRANULARITY 64'h4000
    `define CPM_SRIOVBAR1_MMIOH_GRANULARITY 64'h2000
    `define CPM_SRIOVBAR2_MMIOH_GRANULARITY 64'h8000
    `define CPM_PARAMBAR_MMIOH_GRANULARITY   64'h80000
    `define CPM_PMISCBAR_MMIOH_GRANULARITY   64'h800000
    `define CPM_WQMRINGBAR_MMIOH_GRANULARITY 64'h400000
    static const int unsigned    TOP = 0;
    static const int unsigned SOCKET = 1;
    static const int unsigned M2IOSF = 2;
    static const int unsigned   PCIE = 3;
    static const int unsigned NTB_PB45BAR = 4;
    static const int unsigned  RLINK = 5;
    static const int unsigned VMDMEMBAR2 = 6;
    static const int unsigned    FXR = 7;
    static const int unsigned GFX_GUNIT = 8;
    static const int unsigned   CBDMABAR = 9;
    static const int unsigned    VRP = 10;
    static const int unsigned UBOXMMIOBASE = 11;
    static const int unsigned    HQM = 12;
    static const int unsigned    TIP = 13;
    static const int unsigned    CPM = 14;
    static const int unsigned RLINK_66_DP = 15;

    protected bit static_regions_created;
    protected int unsigned vmd_bars_set;
    protected int unsigned cfgbar_regions_created;
    protected int unsigned mcast_overlaybar_created;
    protected int unsigned mcast_overlaybar_groups_created;
    int unsigned generate_hierarchical_subregions = 0;
    int unsigned adjust_minsize_for_ubox = 0;
    int unsigned lockdown = 0;
    int unsigned hier;
    string prefixStr;
    int socket;
    longint unsigned edge_granularity;
    int unsigned num_requestors;
    longint unsigned granularity;
    longint unsigned subregion_granularity;
    rand longint unsigned subregion_size [];
    longint unsigned minimum_region_size;

    rand longint unsigned aligned_addr_lo;
    rand longint unsigned aligned_addr_hi;

    constraint mmioh_granularity_c {
        (hier == TOP) -> (addr_lo % edge_granularity) == 0;
        (hier == TOP) -> ((addr_hi + 1) % edge_granularity) == 0;
        foreach (subregions[i]) {
            ((hier == TOP || hier == SOCKET) && (subregions[i].addr_lo > addr_lo)) -> (subregions[i].addr_lo & (subregion_granularity - 1)) == 0;
            ((hier == TOP || hier == SOCKET) && (subregions[i].addr_hi < addr_hi)) -> ((subregions[i].addr_hi + 1) & (subregion_granularity - 1)) == 0;
        }
    };

    constraint iosfagt_mmioh_granularity_c {
        (hier inside {PCIE, NTB_PB45BAR, RLINK, RLINK_66_DP, FXR, CBDMABAR, VRP, CPM}) -> (addr_lo & (granularity - 1)) == 0;
        (hier inside {PCIE, NTB_PB45BAR, RLINK, RLINK_66_DP, FXR, CBDMABAR, VRP, CPM}) -> ((addr_hi + 1) & (granularity - 1)) == 0;
    };

    constraint aligned_baselimit_gen_c {
        (hier == TOP) -> aligned_addr_lo == (addr_lo & ~(granularity - 1));
        (hier == TOP) -> aligned_addr_hi == (addr_hi | (granularity - 1));
    };
    constraint intlv_mmioh_total_size_c {
        (hier == TOP) -> (aligned_addr_hi - aligned_addr_lo + 1) <= (granularity * `MAX_NUM_MMIOH_INTERLEAVE_RULES);
    };
    constraint intlv_mmioh_noholes_c {
        ((hier == TOP || hier == SOCKET) && num_requestors > 0) -> (size == subregion_size.sum());
        foreach (subregions[i]) {
            subregion_size[i] == subregions[i].size;
            subregion_size[i] <= size;
        }
    };
    constraint subregion_size_helper_c {
        foreach (subregions[i]) {
            (hier == TOP) -> subregions[i].size <= (granularity * `MAX_NUM_MMIOH_INTERLEAVE_RULES);
        }
    };

    constraint min_region_size_c {
        size >= minimum_region_size;
    };

    virtual function longint unsigned probe_size_requests(int unsigned _hier = TOP, base_topo_cfg cfg = null);
        ovm_object obj;
        longint unsigned min_size = 0;
        int unsigned roundup = 1;
        if (_hier == TOP) begin
            base_top_cfg topCfg;
            assert($cast(topCfg, cfg));
            foreach (topCfg.socketV[i])
                min_size += probe_size_requests(SOCKET, topCfg.socketV[i]);
            if (topCfg.block_mode_mmioh == 1) begin
                `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP calculated min size = 0x%0x", min_size), OVM_HIGH);
                `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP granularity = 0x%0x", `MMIOH_BLOCK_MODE_GRANULARITY), OVM_HIGH);
                if (min_size < `MMIOH_BLOCK_MODE_GRANULARITY)
                    min_size = `MMIOH_BLOCK_MODE_GRANULARITY;
            end else begin
                `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP calculated min size = 0x%0x", min_size), OVM_HIGH);
                `ovm_info("probe_size_requests", $sformatf("PRE GRANULARITY HIER TOP granularity = 0x%0x", (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2))), OVM_HIGH);
                if (min_size < (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2)))
                    min_size = (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2));
            end
            `ovm_info("probe_size_requests", $sformatf("HIER TOP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == SOCKET) begin
            base_top_cfg topCfg;
            base_socket_cfg sktCfg;
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            assert($cast(sktCfg, cfg));
            foreach (sktCfg.m2iosfV[i])
                min_size += probe_size_requests(M2IOSF, sktCfg.m2iosfV[i]);
            if (topCfg.block_mode_mmioh == 1) begin
                if (min_size < `MMIOH_BLOCK_MODE_GRANULARITY)
                    min_size = `MMIOH_BLOCK_MODE_GRANULARITY;
            end else begin
                if (min_size < (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2)))
                    min_size = (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2));
            end
            `ovm_info("probe_size_requests", $sformatf("  HIER SOCKET%0d calculated min size = 0x%0x", sktCfg.inst_id, min_size), OVM_HIGH);
        end else if (_hier == M2IOSF) begin
            base_top_cfg topCfg;
            int ubox_mmioh;
            base_m2iosf_cfg m2iosfCfg;
            base_rlink_cfg rlink_cfg;
            base_rlink_66_dp_cfg rlink_66_dp_cfg;
            base_tip_cfg tip_cfg;
            base_gfx_gunit_cfg gfx_gunit_cfg;
            base_vrp_cfg vrp_cfg;

            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            assert($cast(m2iosfCfg, cfg));
            foreach (m2iosfCfg.pcieV[i]) begin
                int pcie_rpmbar_mmio_high;
                int unsigned pcie_rpmbar_enable;
                get_config_int("pcie_rpmbar_mmio_high", pcie_rpmbar_mmio_high);
                get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);

                min_size += probe_size_requests(PCIE, m2iosfCfg.pcieV[i]);
                min_size += probe_size_requests(NTB_PB45BAR, m2iosfCfg.pcieV[i]);

                if ((pcie_rpmbar_mmio_high == 1) && (pcie_rpmbar_enable == 1) && (m2iosfCfg.pcieV[i].pcie_generation >= 4))
                    min_size += (1 << 17);
            end
            foreach (m2iosfCfg.rlinkV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_high = 0;

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_high", rlink_dpmembar_mmio_high);
`else
                get_config_int("rlink_membar_mmio_high", rlink_dpmembar_mmio_high);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_high == 1))
                    min_size += `RLINK_DPMEMBAR_MMIOH_GRANULARITY;
                min_size += probe_size_requests(RLINK, m2iosfCfg.rlinkV[i]);
            end
            foreach (m2iosfCfg.rlink66DPV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_high = 0;

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_high", rlink_dpmembar_mmio_high);
`else
                get_config_int("rlink_membar_mmio_high", rlink_dpmembar_mmio_high);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_high == 1))
                    min_size += `RLINK_DPMEMBAR_MMIOH_GRANULARITY;
                min_size += probe_size_requests(RLINK_66_DP, m2iosfCfg.rlink66DPV[i]);
            end
            foreach (m2iosfCfg.fxrV[i])
                min_size += probe_size_requests(FXR, m2iosfCfg.fxrV[i]);
            foreach (m2iosfCfg.hqmV[i])
                min_size += probe_size_requests(HQM, m2iosfCfg.hqmV[i]);
            foreach (m2iosfCfg.cpmV[i])
                min_size += probe_size_requests(CPM, m2iosfCfg.cpmV[i]);
            foreach (m2iosfCfg.tipV[i])
                min_size += probe_size_requests(TIP, m2iosfCfg.tipV[i]);
            foreach (m2iosfCfg.gfxGunitV[i])
                min_size += probe_size_requests(GFX_GUNIT, m2iosfCfg.gfxGunitV[i]);
            foreach (m2iosfCfg.vrpV[i])
                min_size += probe_size_requests(VRP, m2iosfCfg.vrpV[i]);
            // manage VMD cfgbar

            if (m2iosfCfg.has_vmd == 1)
                min_size += ((1 << $clog2(m2iosfCfg.num_vmd_buses)) * `PCIE_CFGBUS_GRANULARITY);
            if (m2iosfCfg.has_cbdma == 1)
                min_size += (8 * `CBDMABAR_MMIOH_GRANULARITY);
            if (m2iosfCfg.has_npk == 1)
                min_size += (3 * (4 << 30));
            get_config_int("uboxmmio_mmio_high", ubox_mmioh);
            if (topCfg.block_mode_mmioh == 1) begin
                if (min_size < `MMIOH_BLOCK_MODE_GRANULARITY)
                    min_size = `MMIOH_BLOCK_MODE_GRANULARITY;
            end else begin
                if (min_size < (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2)))
                    min_size = (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2));
            end
            if ((ubox_mmioh == 1) && (adjust_minsize_for_ubox == 1)) begin
                `ovm_info("SUMEDH DEBUG", $sformatf("before ubox adjustment, for region %s min_size = 0x%0x", get_name(), min_size), OVM_HIGH)
                min_size -= `UBOXMMIOBASE_MMIOH_GRANULARITY;
            end
            roundup = 0;
            `ovm_info("probe_size_requests", $sformatf("    HIER M2IOSF%0d calculated min size = 0x%0x", m2iosfCfg.inst_id, min_size), OVM_HIGH);
        end else if (_hier == PCIE) begin
            base_pcie_cfg pcieCfg;
            assert($cast(pcieCfg, cfg));
            if (pcieCfg.is_ntb == 0)
                min_size += `PORT_MMIOH_GRANULARITY;
            min_size *= 2; // special handling for leaf regions
            `ovm_info("probe_size_requests", $sformatf("      HIER PCIE%0d_%0d calculated min size = 0x%0x", pcieCfg.agent_id, pcieCfg.pcie_port, min_size), OVM_HIGH);
        end else if (_hier == NTB_PB45BAR) begin
            base_pcie_cfg pcieCfg;
            assert($cast(pcieCfg, cfg));
            if (pcieCfg.is_ntb == 1)
                min_size += (1 << pcieCfg.pribar45_size);
            min_size *= 2; // special handling for leaf regions
            `ovm_info("probe_size_requests", $sformatf("      HIER NTB_PB45BAR_%0d_%0d calculated min size = 0x%0x", pcieCfg.agent_id, pcieCfg.pcie_port, min_size), OVM_HIGH);
        end else if (_hier == RLINK) begin
            min_size += `PORT_MMIOH_GRANULARITY;
            min_size *= 2; // special handling for leaf regions
            `ovm_info("probe_size_requests", $sformatf("      HIER RLINK calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == RLINK_66_DP) begin
            min_size += `PORT_MMIOH_GRANULARITY;
            min_size *= 2; // special handling for leaf regions
            `ovm_info("probe_size_requests", $sformatf("      HIER RLINK_66_DP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == FXR) begin
            int fxr_hfi_mmio_high;
            int unsigned fxrbar_enable;
            get_config_int("fxr_hfi_mmio_high", fxr_hfi_mmio_high);
            get_config_int("fxrbar_enable", fxrbar_enable);
            if ((fxr_hfi_mmio_high == 1) && (fxrbar_enable == 1))
                min_size += (1 << 26);
            `ovm_info("probe_size_requests", $sformatf("      HIER FXR calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == CPM) begin
            base_cpm_cfg cpmCfg;
            int unsigned sriov_enable;
            int unsigned cpm_vfbar_mmio_high;
            assert($cast(cpmCfg, cfg));
            get_config_int("sriov_enable", sriov_enable);
            get_config_int("cpm_vfbar_mmio_high", cpm_vfbar_mmio_high);

            // Physical function BARs
            // PaRAMBAR - 512K
            // PMISCBAR - 8M
            // WQMRINGBAR - 4M
            min_size += (`CPM_PARAMBAR_MMIOH_GRANULARITY + `CPM_PMISCBAR_MMIOH_GRANULARITY + `CPM_WQMRINGBAR_MMIOH_GRANULARITY);

            // Virtual function BARs
            // SRIOVBAR0 - 16K per VF (2 ** 14)
            // SRIOVBAR1 -  8K per VF (2 ** 13)
            // SRIOVBAR2 - 32K per VF (2 ** 15)
            if ((sriov_enable == 1) && (cpm_vfbar_mmio_high == 1))
                min_size += (cpmCfg.max_num_virtual_functions * (`CPM_SRIOVBAR0_MMIOH_GRANULARITY + `CPM_SRIOVBAR1_MMIOH_GRANULARITY + `CPM_SRIOVBAR2_MMIOH_GRANULARITY));
            `ovm_info("probe_size_requests", $sformatf("      HIER CPM calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == HQM) begin
            base_hqm_cfg hqmCfg;
            assert($cast(hqmCfg, cfg));
            min_size += ((4 << 30) + (64 << 20) + (hqmCfg.num_hqm_vfs * (64 << 20)));
            `ovm_info("probe_size_requests", $sformatf("      HIER HQM calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == TIP) begin
            min_size += ((16 << 20) + (4 << 10) + (64 * (4 << 10)));
            `ovm_info("probe_size_requests", $sformatf("      HIER TIP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == GFX_GUNIT) begin
            min_size += ((4 << 30) + (8 * (16 << 20)));
            `ovm_info("probe_size_requests", $sformatf("      HIER GFX calculated min size = 0x%0x", min_size), OVM_HIGH);
        end else if (_hier == VRP) begin
            min_size += `PORT_MMIOH_GRANULARITY;
            min_size *= 2; // special handling for leaf regions
            `ovm_info("probe_size_requests", $sformatf("      HIER VRP calculated min size = 0x%0x", min_size), OVM_HIGH);
        end
        `ovm_info("probe_size_requests", $sformatf("calculated min = 0x%0x, going to return 0x%0x", min_size, (64'h1 << $clog2(min_size))), OVM_HIGH)
        return (roundup ? (64'h1 << $clog2(min_size)) : min_size);
    endfunction : probe_size_requests

    virtual function void setup_region();
        ovm_object obj;
        base_top_cfg topCfg;
        int unsigned hierarchical_mmioh_alloc;

        get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
        if (topCfg.block_mode_mmioh == 0) begin
            if (hier == TOP) begin
            granularity = (1 << (`MMIOH_INTERLEAVE_INDEX_START + topCfg.mmioh_interleave_mode * 2));
            edge_granularity = (1 << `MMIOH_INTERLEAVE_BASELIMIT_INDEX_START);
            subregion_granularity = granularity;
            socket = -1;
        end
        end else begin
            if (hier == TOP) begin
                granularity = `MMIOH_BLOCK_MODE_GRANULARITY;
                edge_granularity = `MMIOH_BLOCK_MODE_GRANULARITY;
                subregion_granularity = granularity;
                socket = -1;
            end
            aligned_addr_lo.rand_mode(0);
            aligned_addr_hi.rand_mode(0);
            aligned_baselimit_gen_c.constraint_mode(0);
            intlv_mmioh_total_size_c.constraint_mode(0);
            subregion_size_helper_c.constraint_mode(0);
            if (topCfg.allow_mmio_holes == 1)
                intlv_mmioh_noholes_c.constraint_mode(0);
        end
        if (hierarchical_mmioh_alloc == 0)
            return;
        if (hier == TOP) begin
            minimum_region_size = probe_size_requests(TOP, topCfg);
            `override_cfg_val(size, minimum_region_size * 4);
        end else if (hier == SOCKET) begin
            base_socket_cfg sktCfg;
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            minimum_region_size = 64'h00000001_00000000 + probe_size_requests(SOCKET, sktCfg);
        end else if (hier == M2IOSF) begin
            base_m2iosf_cfg m2iosfCfg;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));
            minimum_region_size = probe_size_requests(M2IOSF, m2iosfCfg);
        end else if (hier == PCIE) begin
            base_pcie_cfg pcieCfg;
            if (get_config_object("pcie_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(pcieCfg, obj));
            minimum_region_size = probe_size_requests(PCIE, pcieCfg);
        end else if (hier == NTB_PB45BAR) begin
            base_pcie_cfg pcieCfg;
            if (get_config_object("pcie_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(pcieCfg, obj));
            minimum_region_size = (probe_size_requests(NTB_PB45BAR, pcieCfg) >> 1); // discount the x2 padding in probe_size_requests at the leaf hierarchy
        end else if (hier == RLINK) begin
            base_rlink_cfg rlinkCfg;
            if (get_config_object("rlink_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlinkCfg, obj));
            minimum_region_size = probe_size_requests(RLINK, rlinkCfg);
        end else if (hier == RLINK_66_DP) begin
            base_rlink_66_dp_cfg rlink66DPCfg;
            if (get_config_object("rlink_66_dp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_66_dp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlink66DPCfg, obj));
            minimum_region_size = probe_size_requests(RLINK_66_DP, rlink66DPCfg);
        end else if (hier == FXR) begin
            base_fxr_cfg fxrCfg;
            if (get_config_object("fxr_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "fxr_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(fxrCfg, obj));
            minimum_region_size = probe_size_requests(FXR);
        end else if (hier == GFX_GUNIT) begin
            base_gfx_gunit_cfg gfxGunitCfg;
            if (get_config_object("gfx_gunit_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "gfx_gunit_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(gfxGunitCfg, obj));
            minimum_region_size = probe_size_requests(GFX_GUNIT, gfxGunitCfg);
        end else if (hier == HQM) begin
            base_hqm_cfg hqmCfg;
            if (get_config_object("hqm_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "hqm_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(hqmCfg, obj));
            minimum_region_size = probe_size_requests(HQM, hqmCfg);
        end else if (hier == CPM) begin
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "cpm_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(cpmCfg, obj));
            minimum_region_size = probe_size_requests(CPM, cpmCfg);
        end else if (hier == TIP) begin
            base_tip_cfg tipCfg;
            if (get_config_object("tip_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "tip_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(tipCfg, obj));
            minimum_region_size = probe_size_requests(TIP, tipCfg);
        end else if (hier == VRP) begin
            base_vrp_cfg vrpCfg;
            if (get_config_object("vrp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "vrp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vrpCfg, obj));
            minimum_region_size = probe_size_requests(VRP, vrpCfg);
        end
    endfunction : setup_region

    virtual function void populate_mmio_regions();
        ovm_object obj;
        int unsigned hierarchical_mmioh_alloc;

        get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
        `ovm_info("SUMEDH DEBUG", $sformatf("populate_mmio_regions invoked for region %s with hierarchical_mmioh_alloc = %0d and generate_hierarchical_subregions = %0d", get_name(), hierarchical_mmioh_alloc, generate_hierarchical_subregions), OVM_HIGH)
        if (hier == TOP && static_regions_created == 0) begin
            base_top_cfg topCfg;
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            set_config_int("*", "sriov_enable", topCfg.sriov_enable);
            set_config_int("*", "iommubar_enable", topCfg.iommubar_enable);
            set_config_int("*", "fxrbar_enable", topCfg.fxrbar_enable);
            set_config_int("*", "oobmsmbar_enable", topCfg.oobmsmbar_enable);
            set_config_int("*", "pcie_rpmbar_enable", topCfg.pcie_rpmbar_enable);
            set_config_int("*", "rlink_membar_enable", topCfg.rlink_membar_enable);
            foreach (topCfg.socketV[i]) begin
                base_mmio_high_region mmioregion;
                string childName = $sformatf("s%0d", topCfg.socketV[i].inst_id);
                if ((topCfg.socketV[i].is_xnc_socket == 1) || (topCfg.socketV[i].is_fpga_socket == 1))
                    continue;
                if (topCfg.socketV[i].m2iosfV.size() == 0 && topCfg.socketV[i].uboxmmiobase_enable == 0)
                    continue;
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object(mmioregion.get_name(), "socket_cfg", topCfg.socketV[i], 0);
                mmioregion.hier = SOCKET;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = granularity;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = topCfg.socketV[i].inst_id;
                if (hierarchical_mmioh_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            subregion_size = new [subregions.size()];
            subregion_size.rand_mode(1);
            static_regions_created = 1;
        end
        if (hier == SOCKET && static_regions_created == 0) begin
            base_socket_cfg sktCfg;
            int unsigned subregionVec_size;
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            subregion_granularity = granularity;
            foreach (sktCfg.m2iosfV[i]) begin
                base_mmio_high_region mmioregion;
                string childName = $sformatf("%s_m2iosf%0d", prefixStr, sktCfg.m2iosfV[i].inst_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object(mmioregion.get_name(), "m2iosf_cfg", sktCfg.m2iosfV[i], 0);
                mmioregion.hier = M2IOSF;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = granularity;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (hierarchical_mmioh_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            subregionVec_size = sktCfg.m2iosfV.size();
            if (subregionVec_size == 0) begin // BFM sockets might not have am M2IOSF explcitly instantiated in hierarchy
                subregionVec_size++;
            end
            subregion_size = new [subregionVec_size];
            static_regions_created = 1;
        end
        if (hier == M2IOSF && static_regions_created == 0) begin
            base_m2iosf_cfg m2iosfCfg;
            int m2iosf_iommubar_mmio_high;
            int unsigned pciebars;
            int unsigned cbdmabars;
            int unsigned npkbars;
            int unsigned iommubar_enable;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));
            get_config_int("m2iosf_iommubar_mmio_high", m2iosf_iommubar_mmio_high);
            get_config_int("iommubar_enable", iommubar_enable);
            if ((m2iosf_iommubar_mmio_high == 1) && (iommubar_enable == 1)) begin
                pcie_bar_region iommubar_region;
                `add_subregion_extend(iommubar_region, {prefixStr, "_iommubar_mmioh"}, pcie_bar_region)
                `override_cfg_val(iommubar_region.size, (1 << 12));
            end
            subregion_granularity = `PORT_MMIOH_GRANULARITY;
            pciebars = 0;
            foreach (m2iosfCfg.pcieV[i]) begin
                base_mmio_high_region mmioregion;
                string childName;
                num_requestors++;
                if (m2iosfCfg.pcieV[i].vmd_enable == 1)
                    continue;
                childName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                `add_subregion_extend(mmioregion, {childName, ((m2iosfCfg.pcieV[i].is_ntb == 1) ? "_pribar45" : ""), "_mmioh"}, base_mmio_high_region)
                set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                mmioregion.hier = (m2iosfCfg.pcieV[i].is_ntb == 1) ? NTB_PB45BAR : PCIE;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = (m2iosfCfg.pcieV[i].is_ntb == 1) ? (1 << m2iosfCfg.pcieV[i].pribar45_size) : `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar45_size));
                end
                if (m2iosfCfg.pcieV[i].pcie_generation >= 4) begin
                    int unsigned pcie_rpmbar_enable;
                    int unsigned pcie_rpmbar_mmio_high;
                    pcie_bar_region pcie_rpmbar_region;

                    get_config_int("pcie_rpmbar_mmio_high", pcie_rpmbar_mmio_high);
                    get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);
                    if ((pcie_rpmbar_mmio_high == 1) && (pcie_rpmbar_enable == 1)) begin
                        `add_subregion_extend(pcie_rpmbar_region, {childName, "_rootportmbar_mmioh"}, pcie_bar_region)
                        `override_cfg_val(pcie_rpmbar_region.size, (64'h1 << 17));
                        pciebars++;
                    end
                end
                if (hierarchical_mmioh_alloc == 0)
                    mmioregion.populate_mmio_regions();
            end
            foreach (m2iosfCfg.rlinkV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_high = 0;
                base_mmio_high_region mmioregion;
                string childName = $sformatf("%s_rlink%0d", prefixStr, m2iosfCfg.rlinkV[i].agent_id);

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_high", rlink_dpmembar_mmio_high);
`else
                get_config_int("rlink_membar_mmio_high", rlink_dpmembar_mmio_high);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_high == 1)) begin
                    pcie_bar_region rlink_dpmembar_region;
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_dpmembar_mmioh"}, pcie_bar_region)
`else
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_membar_mmioh"}, pcie_bar_region)
`endif
                    `override_cfg_val(rlink_dpmembar_region.size, `RLINK_DPMEMBAR_MMIOH_GRANULARITY);
                end
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object({"*", mmioregion.get_name()}, "rlink_cfg", m2iosfCfg.rlinkV[i], 0);
                mmioregion.hier = RLINK;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (hierarchical_mmioh_alloc == 0)
                    mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.rlink66DPV[i]) begin
                int unsigned rlink_membar_enable;
                int unsigned rlink_dpmembar_mmio_high = 0;
                base_mmio_high_region mmioregion;
                string childName = $sformatf("%s_rlink%0d", prefixStr, m2iosfCfg.rlink66DPV[i].agent_id);

                get_config_int("rlink_membar_enable", rlink_membar_enable);
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                get_config_int("rlink_dpmembar_mmio_high", rlink_dpmembar_mmio_high);
`else
                get_config_int("rlink_membar_mmio_high", rlink_dpmembar_mmio_high);
`endif
                if ((rlink_membar_enable == 1) && (rlink_dpmembar_mmio_high == 1)) begin
                    pcie_bar_region rlink_dpmembar_region;
`ifndef PROJCFG_PREHSD2201833275_RLINK_BAR_ALLOC
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_dpmembar_mmioh"}, pcie_bar_region)
`else
                    `add_subregion_extend(rlink_dpmembar_region, {childName, "_membar_mmioh"}, pcie_bar_region)
`endif
                    `override_cfg_val(rlink_dpmembar_region.size, `RLINK_DPMEMBAR_MMIOH_GRANULARITY);
                end
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object({"*", mmioregion.get_name()}, "rlink_66_dp_cfg", m2iosfCfg.rlink66DPV[i], 0);
                mmioregion.hier = RLINK_66_DP;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (hierarchical_mmioh_alloc == 0)
                    mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.fxrV[i]) begin
                int fxr_hfi_mmio_high;
                int unsigned fxrbar_enable;
                fxr_hfi_bar_region fxr_hfi_bar;
                get_config_int("fxr_hfi_mmio_high", fxr_hfi_mmio_high);
                get_config_int("fxrbar_enable", fxrbar_enable);
                if ((fxr_hfi_mmio_high == 1) && (fxrbar_enable == 1)) begin
                    string childName = $sformatf("%s_fxr%0d_hfibar", prefixStr, m2iosfCfg.fxrV[i].agent_id);
                    `add_subregion_extend(fxr_hfi_bar, {childName, "_mmioh"}, fxr_hfi_bar_region)
                    `override_cfg_val(fxr_hfi_bar.size, (1 << 26));
                    fxr_hfi_bar.prefixStr = childName;
                    fxr_hfi_bar.suffixStr = "_mmioh";
                    num_requestors = num_requestors + 64;
                end
            end
            foreach (m2iosfCfg.hqmV[i]) begin
                hqm_mmio_high_intlv_region mmioregion;
                string childName = $sformatf("%s_hqm%0d", prefixStr, m2iosfCfg.hqmV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, hqm_mmio_high_intlv_region)
                set_config_object(mmioregion.get_name(), "hqm_cfg", m2iosfCfg.hqmV[i], 0);
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                num_requestors++;
            end
            foreach (m2iosfCfg.tipV[i]) begin
	             longint unsigned prev_addr_lo;
                tip_mmio_high_intlv_region mmioregion;
                string childName = $sformatf("%s_tip%0d", prefixStr, m2iosfCfg.tipV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, tip_mmio_high_intlv_region)
                set_config_object(mmioregion.get_name(), "tip_cfg", m2iosfCfg.tipV[i], 0);
                mmioregion.prefixStr = childName;
	       `override_cfg_val(mmioregion.size, 28'h2100000);
                num_requestors++;
            end
            foreach (m2iosfCfg.gfxGunitV[i]) begin
                gfxgunit_mmio_high_intlv_region mmioregion;
                string childName = $sformatf("%s_gfxgunit%0d", prefixStr, m2iosfCfg.gfxGunitV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, gfxgunit_mmio_high_intlv_region)
                set_config_object(mmioregion.get_name(), "gfx_gunit_cfg", m2iosfCfg.gfxGunitV[i], 0);
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                num_requestors++;
            end
            foreach (m2iosfCfg.vrpV[i]) begin
                base_mmio_high_region mmioregion;
                string childName = $sformatf("%s_vrp%0d_0", prefixStr, m2iosfCfg.vrpV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object(mmioregion.get_name(), "vrp_cfg", m2iosfCfg.vrpV[i], 0);
                mmioregion.hier = VRP;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (hierarchical_mmioh_alloc == 0)
                mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            foreach (m2iosfCfg.cpmV[i]) begin
                base_mmio_high_region mmioregion;
                string childName = $sformatf("%s_cpm%0d", prefixStr, m2iosfCfg.cpmV[i].agent_id);
                `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                set_config_object(mmioregion.get_name(), "cpm_cfg", m2iosfCfg.cpmV[i], 0);
                mmioregion.hier = CPM;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (hierarchical_mmioh_alloc == 0)
                    mmioregion.populate_mmio_regions();
                num_requestors++;
            end
            // FIXME!!! Randomize between MMIOL and MMIOH
            cbdmabars = 0;
            if (m2iosfCfg.has_cbdma == 1) begin
                for (int unsigned c = 0; c < 8; c++) begin
                    base_mmio_high_region mmioregion;
                    string childName = $sformatf("%s_cbdmabar%0d", prefixStr, c);
                    `add_subregion_extend(mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                    mmioregion.hier = CBDMABAR;
                    mmioregion.prefixStr = childName;
                    mmioregion.granularity = `CBDMABAR_MMIOH_GRANULARITY;
                    mmioregion.edge_granularity = edge_granularity;
                    mmioregion.socket = socket;
                    if (hierarchical_mmioh_alloc == 0)
                    mmioregion.populate_mmio_regions();
                    `override_cfg_val(mmioregion.size, `CBDMABAR_MMIOH_GRANULARITY)
                end
                cbdmabars = 8;
                num_requestors++;
            end
            // - End of FIXME
            npkbars = 0;
            if (m2iosfCfg.has_npk == 1) begin
                npk_swbar_region npk_swbar;
                npk_rtitbar_region npk_rtitbar;
                npk_fwbar_region npk_fwbar;
                string childName;
                childName = $sformatf("%s_npk_swbar", prefixStr);
                `add_subregion_extend(npk_swbar, {childName, "_mmioh"}, npk_swbar_region)
                childName = $sformatf("%s_npk_rtitbar", prefixStr);
                `add_subregion_extend(npk_rtitbar, {childName, "_mmioh"}, npk_rtitbar_region)
                childName = $sformatf("%s_npk_fwbar", prefixStr);
                `add_subregion_extend(npk_fwbar, {childName, "_mmioh"}, npk_fwbar_region)
                npkbars = 3;
                num_requestors = num_requestors + 3;
            end
            subregion_size = new [subregions.size()];
            static_regions_created = 1;
        end
        if (hier == PCIE) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
        end
        if (hier == NTB_PB45BAR) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
        end
        if (hier == RLINK && static_regions_created == 0) begin
            ovm_object obj;
            base_rlink_cfg rlinkCfg;
            int unsigned rlink_membar_enable;
            int unsigned rlink_upmembar_mmio_high;
            get_config_int("rlink_membar_enable", rlink_membar_enable);
            get_config_int("rlink_upmembar_mmio_high", rlink_upmembar_mmio_high);
            if (get_config_object("rlink_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlinkCfg, obj));
            if ((rlink_upmembar_mmio_high == 1) && (rlink_membar_enable == 1) && (rlinkCfg.is_dmi == 0)) begin
                pcie_bar_region rlink_upmembar_region;
                `add_subregion_extend(rlink_upmembar_region, {prefixStr, "_upmembar_mmioh"}, pcie_bar_region)
                `override_cfg_val(rlink_upmembar_region.size, `RLINK_UPMEMBAR_MMIOH_GRANULARITY);
                subregion_size = new [subregions.size()];
            end
            static_regions_created = 1;
        end
        if (hier == RLINK_66_DP && static_regions_created == 0) begin
            ovm_object obj;
            base_rlink_66_dp_cfg rlink66DPCfg;
            int unsigned rlink_membar_enable;
            int unsigned rlink_upmembar_mmio_high;
            get_config_int("rlink_membar_enable", rlink_membar_enable);
            get_config_int("rlink_upmembar_mmio_high", rlink_upmembar_mmio_high);
            if (get_config_object("rlink_66_dp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "rlink_66_dp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(rlink66DPCfg, obj));
            if ((rlink_upmembar_mmio_high == 1) && (rlink_membar_enable == 1) && (rlink66DPCfg.is_dmi == 0)) begin
                pcie_bar_region rlink_upmembar_region;
                `add_subregion_extend(rlink_upmembar_region, {prefixStr, "_upmembar_mmioh"}, pcie_bar_region)
                `override_cfg_val(rlink_upmembar_region.size, `RLINK_UPMEMBAR_MMIOH_GRANULARITY);
                subregion_size = new [subregions.size()];
            end
            static_regions_created = 1;
        end
        if (hier == FXR && static_regions_created == 0) begin
            // do nothing for now
            static_regions_created = 1;
        end
        if (hier == GFX_GUNIT && static_regions_created == 0) begin
            // do nothing for now
            static_regions_created = 1;
        end
        if (hier == VRP && static_regions_created == 0) begin
            ovm_object obj;
            base_vrp_cfg vrpCfg;
            region mmioregion;

            region vrp_prefetch;
            if (get_config_object("vrp_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "vrp_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vrpCfg, obj));
            `add_subregion_extend(vrp_prefetch, $sformatf("S%0d_VRP%0d_0_PREFETCH", socket, vrpCfg.inst_id), region)
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == CPM && static_regions_created == 0) begin
            int unsigned sriov_enable;
            int unsigned cpm_vfbar_mmio_high;
            ovm_object obj;
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0)
                return;
            assert($cast(cpmCfg, obj));
            get_config_int("sriov_enable", sriov_enable);
            get_config_int("cpm_vfbar_mmio_high", cpm_vfbar_mmio_high);
            if ((sriov_enable == 1) && (cpm_vfbar_mmio_high == 1)) begin
                granular_region sriovbar0, sriovbar1, sriovbar2;
                `add_subregion_extend(sriovbar0, {prefixStr, "_sriovbar0_mmioh"}, granular_region)
                `add_subregion_extend(sriovbar1, {prefixStr, "_sriovbar1_mmioh"}, granular_region)
                `add_subregion_extend(sriovbar2, {prefixStr, "_sriovbar2_mmioh"}, granular_region)

                // SRIOVBAR0 - 16K per VF (2 ** 14)
                // SRIOVBAR1 -  8K per VF (2 ** 13)
                // SRIOVBAR2 - 32K per VF (2 ** 15)
                `override_cfg_val(sriovbar0.size, `CPM_SRIOVBAR0_MMIOH_GRANULARITY * cpmCfg.max_num_virtual_functions);
                `override_cfg_val(sriovbar1.size, `CPM_SRIOVBAR1_MMIOH_GRANULARITY * cpmCfg.max_num_virtual_functions);
                `override_cfg_val(sriovbar2.size, `CPM_SRIOVBAR2_MMIOH_GRANULARITY * cpmCfg.max_num_virtual_functions);

                sriovbar0.granularity = `CPM_SRIOVBAR0_MMIOH_GRANULARITY;
                sriovbar1.granularity = `CPM_SRIOVBAR1_MMIOH_GRANULARITY;
                sriovbar2.granularity = `CPM_SRIOVBAR2_MMIOH_GRANULARITY;
            end
            begin
                // physical function BAR region generation
                pcie_bar_region parambar, pmiscbar, wqmringbar;
                `add_subregion_extend(parambar, {prefixStr, "_parambar_mmioh"}, pcie_bar_region)
                `add_subregion_extend(pmiscbar, {prefixStr, "_pmiscbar_mmioh"}, pcie_bar_region)
                `add_subregion_extend(wqmringbar, {prefixStr, "_wqmringbar_mmioh"}, pcie_bar_region)
                `override_cfg_val(parambar.size, `CPM_PARAMBAR_MMIOH_GRANULARITY);
                `override_cfg_val(pmiscbar.size, `CPM_PMISCBAR_MMIOH_GRANULARITY);
                `override_cfg_val(wqmringbar.size, `CPM_WQMRINGBAR_MMIOH_GRANULARITY);
            end
            static_regions_created = 1;
            subregion_size = new [subregions.size()];
        end
    endfunction : populate_mmio_regions

    function void create_multicast_overlay();
            base_multicast_config mcast_cfg;
            base_pcie_cfg pcieCfg;
        ovm_object obj;

            if (get_config_object("mcast_cfg", obj, 0) == 0)
                return;
            assert($cast(mcast_cfg, obj));
            if (mcast_cfg.multicast_enable == 0 || mcast_cfg.socket_has_dramhi_mcast(socket) == 0)
                return;
            if (get_config_object("pcie_cfg", obj, 0) == 0)
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            assert($cast(pcieCfg, obj));
        if (mcast_overlaybar_created == 1)
            return;
            if (pcieCfg.group_mask > 0) begin
                multicast_overlaybar_region mcast_overlay_bar;
                string mcastOverlayName = $sformatf("%s_mcast_overlaybar_mmioh", prefixStr);
                `add_subregion_extend(mcast_overlay_bar, mcastOverlayName, multicast_overlaybar_region);
                mcast_overlay_bar.min_size = `PORT_MMIOH_GRANULARITY;
            end
            subregion_size = new [1];
            mcast_overlaybar_created = 1;
    endfunction : create_multicast_overlay

    function void pre_randomize();
        int unsigned hierarchical_mmioh_alloc;

        get_config_int("lockdown", lockdown);
        if (lockdown == 1)
            return;
        get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
        super.pre_randomize();
        setup_region();
        `ovm_info(get_name(), $sformatf("SUMEDH: DEBUG: finished setting up region %s", get_name()), OVM_HIGH)
        if (hierarchical_mmioh_alloc == 0)
            min_region_size_c.constraint_mode(0);
        if ((hierarchical_mmioh_alloc == 1) && (generate_hierarchical_subregions == 1)) begin
            populate_mmio_regions();
            if (hier == SOCKET) begin
                foreach (subregions[i]) begin
                    base_mmio_high_region m2iosf_mmioh;
                    assert($cast(m2iosf_mmioh, subregions[i]));
                    if (m2iosf_mmioh.hier == M2IOSF)
                        m2iosf_mmioh.mmioh_granularity_c.constraint_mode(0);
                end
            end else if (hier == M2IOSF)
                mmioh_granularity_c.constraint_mode(1);
        end
        iosfagt_mmioh_granularity_c.constraint_mode(0);
        if (hier inside {PCIE, NTB_PB45BAR, RLINK, RLINK_66_DP, FXR, CBDMABAR, VRP, CPM})
            iosfagt_mmioh_granularity_c.constraint_mode(1);
        `ovm_info(get_name(), $sformatf("SUMEDH: DEBUG: now finished pre_randomize"), OVM_HIGH);
        foreach (subregions[i]) begin
            `ovm_info(get_name(), $sformatf("SUMEDH: DEBUG: randomization will happen for subregion %s", subregions[i].get_name()), OVM_HIGH)
        end
    endfunction: pre_randomize

    function void post_randomize();
        int unsigned hierarchical_mmioh_alloc;

        `ovm_info("SUMEDH DEBUG", $sformatf("in post_randomize for region %s", get_name()), OVM_HIGH);
        get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
        get_config_int("lockdown", lockdown);
        if (lockdown == 1)
            return;
        if ((hier == PCIE) || (hier == NTB_PB45BAR)) begin
            base_pcie_cfg pcieCfg;
            ovm_object obj;

            if (get_config_object("pcie_cfg", obj, 0) == 0)
                `ovm_info(get_name(), "pcie_cfg object could not be retrieved", OVM_HIGH)
            assert($cast(pcieCfg, obj));
            if (pcieCfg.group_mask > 0 && mcast_overlaybar_groups_created == 0) begin
                region bar_with_groups;
                int unsigned group_mask_copy;
                string wGroupName;

                mcast_overlaybar_groups_created = 1;
                wGroupName = prefixStr;
                group_mask_copy = pcieCfg.group_mask;
                for (int unsigned group_ix = 0; group_mask_copy > 0; group_ix++) begin
                    if ((group_mask_copy % 2) == 1)
                        wGroupName = $sformatf("%s_group%0d", wGroupName, group_ix);
                    group_mask_copy = group_mask_copy >> 1;
                end
                wGroupName = {wGroupName, "_mcast_overlaybar_mmioh"};
                foreach (subregions[i]) begin
                    if (ovm_is_match("*_mcast_overlaybar_mmioh", subregions[i].name)) begin
                        `add_subregion_extend(bar_with_groups, wGroupName, region, subregions[i]);
                        bar_with_groups.addr_lo = subregions[i].addr_lo;
                        bar_with_groups.addr_hi = subregions[i].addr_hi;
                        bar_with_groups.size = subregions[i].size;
                    end
                end
            end
        end
        if (hier == M2IOSF) begin
            region parent_cfgbar;
            base_m2iosf_cfg m2iosfCfg;
            ovm_object obj;
            int unsigned found_cfgbar = 0;
            foreach (subregions[i]) begin
                if (subregions[i].name == $sformatf("%s_vmdcfgbar_mmioh", prefixStr)) begin
                    found_cfgbar = 1;
                    parent_cfgbar = subregions[i];
                end
            end
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));
            if ((found_cfgbar == 1) && (cfgbar_regions_created == 0)) begin
            cfgbar_regions_created = 1;
            foreach (m2iosfCfg.pcieV[i]) begin
                string pcieChildName;
                region vmd_pcie_cfg0;
                region vmd_pcie_cfg1;
                if (m2iosfCfg.pcieV[i].vmd_enable == 0)
                    continue;
                if (m2iosfCfg.pcieV[i].is_ntb == 1)
                    continue;
                pcieChildName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                `add_subregion_extend(vmd_pcie_cfg0, {pcieChildName, "_cfg0_mmcfg"}, region, parent_cfgbar)
                `override_cfg_val(vmd_pcie_cfg0.addr_lo, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus - m2iosfCfg.base_vmd_bus) * `PCIE_CFGBUS_GRANULARITY)
                `override_cfg_val(vmd_pcie_cfg0.addr_hi, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus - m2iosfCfg.base_vmd_bus + 1) * `PCIE_CFGBUS_GRANULARITY - 1)
                `override_cfg_val(vmd_pcie_cfg0.size, vmd_pcie_cfg0.addr_hi - vmd_pcie_cfg0.addr_lo + 1)
                if (m2iosfCfg.pcieV[i].subordinate_bus > m2iosfCfg.pcieV[i].secondary_bus) begin
                    `add_subregion_extend(vmd_pcie_cfg1, {pcieChildName, "_cfg1_mmcfg"}, region, parent_cfgbar)
                    `override_cfg_val(vmd_pcie_cfg1.addr_lo, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].secondary_bus + 1 - m2iosfCfg.base_vmd_bus) * `PCIE_CFGBUS_GRANULARITY)
                    `override_cfg_val(vmd_pcie_cfg1.addr_hi, parent_cfgbar.addr_lo + (m2iosfCfg.pcieV[i].subordinate_bus - m2iosfCfg.base_vmd_bus + 1) * `PCIE_CFGBUS_GRANULARITY - 1)
                    `override_cfg_val(vmd_pcie_cfg1.size, vmd_pcie_cfg1.addr_hi - vmd_pcie_cfg1.addr_lo + 1)
                end
            end
        end
        end
        if (hier == VRP) begin
            foreach (subregions[i]) begin
                if (ovm_is_match("*S?_VRP?_0_PREFETCH", subregions[i].name)) begin
                    subregions[i].addr_lo  = addr_lo;
                    subregions[i].addr_hi  = addr_hi;
                    subregions[i].size     = size;
                end
            end
        end
        if (hier == CPM) begin
            ovm_object obj;
            base_cpm_cfg cpmCfg;
            if (get_config_object("cpm_cfg", obj, 0) == 0)
                return;
            assert($cast(cpmCfg, obj));
            foreach (subregions[i]) begin
                if (ovm_is_match("*_sriovbar0_mmioh", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar0_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar0_vf%0d_mmioh", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR0_MMIOH_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR0_MMIOH_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end else if (ovm_is_match("*_sriovbar1_mmioh", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar1_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar1_vf%0d_mmioh", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR1_MMIOH_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR1_MMIOH_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end else if (ovm_is_match("*_sriovbar2_mmioh", subregions[i].name)) begin
                    for (int unsigned vfix = 0; vfix < cpmCfg.max_num_virtual_functions; vfix++) begin
                        region vfbar_region;
                        region match_regions[$];
                        match_regions = subregions[i].subregions.find_first(x) with (ovm_is_match($sformatf("*_sriovbar2_vf%0d*", vfix), x.name) == 1);
                        if (match_regions.size() == 0) begin
                            `add_subregion_extend(vfbar_region, $sformatf("%s_sriovbar2_vf%0d_mmioh", prefixStr, vfix), region, subregions[i])
                        end else
                            vfbar_region = match_regions[0];
                        `override_cfg_val(vfbar_region.size, `CPM_SRIOVBAR2_MMIOH_GRANULARITY);
                        `override_cfg_val(vfbar_region.addr_lo, subregions[i].addr_lo + `CPM_SRIOVBAR2_MMIOH_GRANULARITY * vfix);
                        `override_cfg_val(vfbar_region.addr_hi, vfbar_region.addr_lo + vfbar_region.size - 1);
                    end
                end
            end
        end
        if (hierarchical_mmioh_alloc == 1) begin
            foreach (subregions[i]) begin
                base_mmio_high_region mh;
                base_socket_cfg sktCfg;
                int uboxmmio_mmio_high;
                ovm_object uobj;

                if (get_config_object("socket_cfg", uobj, 0) == 0) begin
                    `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
                end
                assert($cast(sktCfg, uobj));

                if ($cast(mh, subregions[i])) begin
                    mh.populate_mmio_regions();
                    mh.generate_hierarchical_subregions = 1;
                    mh.setup_vmd_bars();
                end
                subregions[i].addr_lo.rand_mode(0);
                subregions[i].addr_hi.rand_mode(0);
                subregions[i].size.rand_mode(0);
                get_config_int("uboxmmio_mmio_high", uboxmmio_mmio_high);
                if ((hier == SOCKET) && (mh != null) && (mh.hier == M2IOSF) && (addr_hi == mh.addr_hi) && (uboxmmio_mmio_high == 1) && (sktCfg.uboxmmiobase_enable  == 1)) begin
                    subregions[i].addr_hi -= `UBOXMMIOBASE_MMIOH_GRANULARITY;
                    subregions[i].size -= `UBOXMMIOBASE_MMIOH_GRANULARITY;
                    mh.adjust_minsize_for_ubox = 1;
                    if (hierarchical_mmioh_alloc == 1)
                        generate_ubox_mmioh();
                end
                `ovm_info("SUMEDH: DEBUG", $sformatf("now starting randomization of subregion %s from region %s with limits [0x%0x : 0x%0x]", subregions[i].get_name(), get_name(), subregions[i].addr_lo, subregions[i].addr_hi), OVM_HIGH)
                subregions[i].randomize();
                `ovm_info("SUMEDH: DEBUG", $sformatf("now finished randomization of subregion %s from region %s with limits [0x%0x : 0x%0x]", subregions[i].get_name(), get_name(), subregions[i].addr_lo, subregions[i].addr_hi), OVM_HIGH)
                if ((hier == SOCKET) && (mh != null) && (mh.hier == M2IOSF) && (addr_hi == mh.addr_hi) && (uboxmmio_mmio_high == 1) && (sktCfg.uboxmmiobase_enable  == 1))
                    mh.adjust_minsize_for_ubox = 0;
            end
        end
        super.post_randomize();
    endfunction : post_randomize

    virtual function generate_ubox_mmioh();
        `ovm_info("SUMEDH DEBUG", $sformatf("generate_ubox_mmioh called for region %s", get_name()), OVM_HIGH)
        if (hier == TOP) begin
            foreach (subregions[i]) begin
                base_mmio_high_region skt_mmioh;
                if ($cast(skt_mmioh, subregions[i])) begin
                    if (skt_mmioh.hier == SOCKET)
                        skt_mmioh.generate_ubox_mmioh();
                end
            end
        end
        if (hier == SOCKET) begin
            ovm_object obj;
            ovm_object obj2;
            base_mmio_high_region last_m2iosf_region;
            base_socket_cfg sktCfg;
            base_top_cfg topCfg;
            int uboxmmio_mmio_high;
            int unsigned found_last_m2iosf_region;

            if (get_config_object("top_cfg", obj2, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj2));
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));

            found_last_m2iosf_region = 0;
            foreach (subregions[i]) begin
                if ($cast(last_m2iosf_region, subregions[i])) begin
                    if ((last_m2iosf_region.hier == M2IOSF) && (last_m2iosf_region.addr_hi == addr_hi)) begin
                        found_last_m2iosf_region = 1;
                        break;
                end
            end
            end
            get_config_int("uboxmmio_mmio_high", uboxmmio_mmio_high);
            if ((sktCfg.uboxmmiobase_enable == 1) && (uboxmmio_mmio_high == 1)) begin
                base_mmio_high_region uboxmmiobase_mmioregion;
                uboxmmiobase_bar_region scfbar_region;
                uboxmmiobase_bar_region sbregbar_region;
                uboxmmiobase_bar_region pcubar_region;
                uboxmmiobase_bar_region membar_region;
                string childName = $sformatf("%s_uboxmmiobase", prefixStr);
                int unsigned hierarchical_mmioh_alloc;

                `add_subregion_extend(uboxmmiobase_mmioregion, {childName, "_mmioh"}, base_mmio_high_region)
                uboxmmiobase_mmioregion.hier = UBOXMMIOBASE;
                uboxmmiobase_mmioregion.prefixStr = childName;
                uboxmmiobase_mmioregion.granularity = `UBOXMMIOBASE_MMIOH_GRANULARITY;
                uboxmmiobase_mmioregion.edge_granularity = `UBOXMMIOBASE_MMIOH_GRANULARITY;
                uboxmmiobase_mmioregion.socket = socket;
                `override_cfg_val(uboxmmiobase_mmioregion.size, `UBOXMMIOBASE_MMIOH_GRANULARITY);
                `override_cfg_val(uboxmmiobase_mmioregion.addr_hi, addr_hi)
                `override_cfg_val(uboxmmiobase_mmioregion.addr_lo, addr_hi - `UBOXMMIOBASE_MMIOH_GRANULARITY + 1)
                get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
                if ((found_last_m2iosf_region == 1) && (hierarchical_mmioh_alloc == 0)) begin
                `override_cfg_val(last_m2iosf_region.addr_hi, uboxmmiobase_mmioregion.addr_lo - 1)
                `override_cfg_val(last_m2iosf_region.size, last_m2iosf_region.size - `UBOXMMIOBASE_MMIOH_GRANULARITY)
                end

                // Add subregions to this Ubox MMIOH region
                //Add subregion for each mem bar
                for (int i = 0; i < 8; i++) begin
                    `add_subregion_extend(membar_region, $sformatf("%s_membar%0d", childName, i), uboxmmiobase_bar_region, uboxmmiobase_mmioregion);
                    membar_region.granularity = `MEMBAR_MMIOH_GRANULARITY;
                end
                //Add SCF BAR subregion
                `add_subregion_extend(scfbar_region, $sformatf("%s_scfbar", childName), uboxmmiobase_bar_region, uboxmmiobase_mmioregion);
                scfbar_region.granularity = `SCFBAR_MMIOH_GRANULARITY;
                //Add SBREG BAR subregion
                `add_subregion_extend(sbregbar_region, $sformatf("%s_sbregbar", childName), uboxmmiobase_bar_region, uboxmmiobase_mmioregion);
                sbregbar_region.granularity = `SBREGBAR_MMIOH_GRANULARITY;
                //Add PCU BAR subregion
                `add_subregion_extend(pcubar_region, $sformatf("%s_pcubar", childName), uboxmmiobase_bar_region, uboxmmiobase_mmioregion);
                pcubar_region.granularity = `PCUBAR_MMIOH_GRANULARITY;
                uboxmmiobase_mmioregion.subregion_size = new [11];
                uboxmmiobase_mmioregion.randomize();
                if ((found_last_m2iosf_region == 1) && (hierarchical_mmioh_alloc == 0)) begin
                    `ovm_info("SUMEDH DEBUG", $sformatf("started randomizing last m2iosf region %s", last_m2iosf_region.get_name()), OVM_HIGH);
                    last_m2iosf_region.adjust_minsize_for_ubox = 1;
                last_m2iosf_region.randomize();
                    last_m2iosf_region.adjust_minsize_for_ubox = 0;
            end
        end
        end
        `ovm_info("SUMEDH DEBUG", $sformatf("exiting generate_ubox_mmioh called for region %s", get_name()), OVM_HIGH);
    endfunction : generate_ubox_mmioh

    virtual function void setup_vmd_bars();
        int unsigned hierarchical_mmioh_alloc;

        get_config_int("hierarchical_mmioh_alloc", hierarchical_mmioh_alloc);
        if (hier == TOP) begin
            base_top_cfg topCfg;
            ovm_object obj;
            if (get_config_object("top_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(topCfg, obj));
            foreach (subregions[i]) begin
                base_mmio_high_region sub_mmioh;
                assert($cast(sub_mmioh, subregions[i]));
                foreach (topCfg.socketV[i]) begin
                    if (sub_mmioh.prefixStr == $sformatf("s%0d", topCfg.socketV[i].inst_id))
                        set_config_object(sub_mmioh.get_name(), "socket_cfg", topCfg.socketV[i], 0);
                end
                if (hierarchical_mmioh_alloc == 0)
                sub_mmioh.setup_vmd_bars();
            end
        end
        if (hier == SOCKET) begin
            base_socket_cfg sktCfg;
            ovm_object obj;
            if (get_config_object("socket_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "socket_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(sktCfg, obj));
            foreach (subregions[i]) begin
                base_mmio_high_region sub_mmioh;
                assert($cast(sub_mmioh, subregions[i]));
                if (sub_mmioh == null) continue;
                foreach (sktCfg.m2iosfV[i]) begin
                    if (sub_mmioh.prefixStr == $sformatf("%s_m2iosf%0d", prefixStr, sktCfg.m2iosfV[i].inst_id))
                        set_config_object(sub_mmioh.get_name(), "m2iosf_cfg", sktCfg.m2iosfV[i], 0);
                end
                if (hierarchical_mmioh_alloc == 0)
                sub_mmioh.setup_vmd_bars();
            end
        end
        if (hier == M2IOSF) begin
            ovm_object obj;
            string childName;
            base_m2iosf_cfg m2iosfCfg;
            base_vmdcfgbar_config vmdcfgbar_cfg;
            vmdmembar2_mmio_high_region vmdmembar2;
            if (get_config_object("m2iosf_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "m2iosf_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(m2iosfCfg, obj));

            if (m2iosfCfg.has_vmd == 0)
                return;
            if (get_config_object("vmdcfgbar_cfg", obj, 0) == 0) begin
                `ovm_info(get_name(), "vmdcfgbar_cfg object could not be retrieved", OVM_HIGH)
            end
            assert($cast(vmdcfgbar_cfg, obj));

            if (vmd_bars_set == 1)
                return;
            // Check if CFGBAR for this M2IOSF is in MMIOL
            foreach (vmdcfgbar_cfg.cfgbar_mmioh[i]) begin
                if (vmdcfgbar_cfg.cfgbar_mmioh[i] == 0)
                    continue;
                if (vmdcfgbar_cfg.socket[i] == socket && vmdcfgbar_cfg.m2iosf[i] == m2iosfCfg.inst_id) begin
                    granular_region cfgbar_mmioregion;
                    string childName = $sformatf("%s_vmdcfgbar", prefixStr);
                    `add_subregion_extend(cfgbar_mmioregion, {childName, "_mmioh"}, granular_region)
                    `override_cfg_val(cfgbar_mmioregion.size, vmdcfgbar_cfg.vmd_buses[i] * `PCIE_CFGBUS_GRANULARITY);
                    cfgbar_mmioregion.granularity = cfgbar_mmioregion.size;
                end
            end
            childName = $sformatf("%s_vmdmembar2", prefixStr);
            `add_subregion_extend(vmdmembar2, {childName, "_mmioh"}, vmdmembar2_mmio_high_region)
            vmdmembar2.min_size = (1 << $clog2(`PORT_MMIOH_GRANULARITY));
            vmdmembar2.hier = VMDMEMBAR2;
            vmdmembar2.prefixStr = prefixStr;
            vmdmembar2.edge_granularity = edge_granularity;
            vmdmembar2.socket = socket;
            foreach (m2iosfCfg.pcieV[i]) begin
                base_mmio_high_region mmioregion;
                if (m2iosfCfg.pcieV[i].vmd_enable == 0)
                    continue;
                childName = $sformatf("%s_pcie%0d_%0d", prefixStr, m2iosfCfg.pcieV[i].agent_id, m2iosfCfg.pcieV[i].pcie_port);
                if (m2iosfCfg.pcieV[i].pcie_generation >= 4) begin
                    int unsigned pcie_rpmbar_enable;
                    int unsigned pcie_rpmbar_mmio_high;
                    pcie_bar_region pcie_rpmbar_region;

                    get_config_int("pcie_rpmbar_mmio_high", pcie_rpmbar_mmio_high);
                    get_config_int("pcie_rpmbar_enable", pcie_rpmbar_enable);
                    if ((pcie_rpmbar_mmio_high == 1) && (pcie_rpmbar_enable == 1)) begin
                        `add_subregion_extend(pcie_rpmbar_region, {childName, "_rootportmbar_mmioh"}, pcie_bar_region, vmdmembar2)
                        `override_cfg_val(pcie_rpmbar_region.size, (64'h1 << 17));
                    end
                end
                `add_subregion_extend(mmioregion, {childName, ((m2iosfCfg.pcieV[i].is_ntb == 1) ? "_pribar45" : ""), "_mmioh"}, base_mmio_high_region, vmdmembar2)
                set_config_object({"*", mmioregion.get_name()}, "pcie_cfg", m2iosfCfg.pcieV[i], 0);
                mmioregion.hier = (m2iosfCfg.pcieV[i].is_ntb == 1) ? NTB_PB45BAR : PCIE;
                mmioregion.prefixStr = childName;
                mmioregion.granularity = (m2iosfCfg.pcieV[i].is_ntb == 1) ? (1 << m2iosfCfg.pcieV[i].pribar45_size) : `PORT_MMIOH_GRANULARITY;
                mmioregion.edge_granularity = edge_granularity;
                mmioregion.socket = socket;
                if (m2iosfCfg.pcieV[i].is_ntb == 1) begin
                    `override_cfg_val(mmioregion.size, (1 << m2iosfCfg.pcieV[i].pribar45_size));
                end
                if (hierarchical_mmioh_alloc == 0)
                    mmioregion.setup_vmd_bars();
                vmdmembar2.min_size += ((m2iosfCfg.pcieV[i].is_ntb == 1) ? (1 << m2iosfCfg.pcieV[i].pribar45_size) : (1 << $clog2(`PORT_MMIOH_GRANULARITY)));
            end
            vmdmembar2.subregion_size = new [vmdmembar2.subregions.size()];
            vmd_bars_set = 1;
            subregion_size = new [subregions.size()];
        end
        if (hier == PCIE) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
            vmd_bars_set = 1;
        end
        if (hier == NTB_PB45BAR) begin
            // add a subregion for multicast overlay if needed (check performed inside the function)
            create_multicast_overlay();
            vmd_bars_set = 1;
        end
    endfunction : setup_vmd_bars

`picker_class_end

`picker_class_begin(mmio_high_intlv_region, base_mmio_high_region)
`picker_class_end

`picker_class_begin(mmio_high_region, base_mmio_high_region)
    `define MMIOH_NONINTLV_GRANULARITY 'h400_0000

    `add_knob("nonintlv_addr_lo", nonintlv_addr_lo, longint unsigned, HEX)
    `add_knob("nonintlv_addr_hi", nonintlv_addr_hi, longint unsigned, HEX)

    rand base_mmio_high_region mmio_high_intlv;

    int mmioh_flat_en;

    function void pre_randomize();
        base_top_cfg topCfg;
        ovm_object obj;

        if (get_config_object("top_cfg", obj, 0) == 0) begin
            `ovm_info(get_name(), "top_cfg object could not be retrieved", OVM_HIGH)
        end
        assert($cast(topCfg, obj));

        mmioh_flat_en = topCfg.mmioh_flat_en;
        granularity = `MMIOH_NONINTLV_GRANULARITY;
        nonintlv_addr_lo.rand_mode(0);
        nonintlv_addr_hi.rand_mode(0);
        `ovm_info(get_name(), "inside pre_randomize for mmio_high_region", OVM_HIGH)
        if (static_regions_created == 0) begin
            if (topCfg.block_mode_mmioh == 0) begin
                `add_subregion_extend(mmio_high_intlv, "mmioh_intlv", base_mmio_high_region);
                mmioh_granularity_c.constraint_mode(0);
                aligned_baselimit_gen_c.constraint_mode(0);
                intlv_mmioh_total_size_c.constraint_mode(0);
                intlv_mmioh_noholes_c.constraint_mode(0);
                subregion_size_helper_c.constraint_mode(0);
                subregion_size.rand_mode(0);
            static_regions_created = 1;
            end else begin
                granularity = `MMIOH_BLOCK_MODE_GRANULARITY;
                mmio_high_intlv.rand_mode(0);
                no_mmioh_flat_c.constraint_mode(0);
                subregion_size.rand_mode(0);
            end
        end
        super.pre_randomize(); // This needs to be here because we want to create mmioh_intlv before executing pre_randomize for the base class
        `ovm_info(get_name(), $sformatf("mmio_high_intlv.rand_mode = %0d", mmio_high_intlv.rand_mode()), OVM_HIGH)
    endfunction : pre_randomize

    function void post_randomize();
        nonintlv_addr_lo = 1;
        nonintlv_addr_hi = 0;
        if (mmioh_flat_en == 1) begin
            nonintlv_addr_lo = addr_lo;
            nonintlv_addr_hi = addr_hi;
        end
        `ovm_info("SUMEDH DEBUG", $sformatf("in post_randomize for region %s", get_name()), OVM_HIGH);
        super.post_randomize();
    endfunction : post_randomize

    constraint no_mmioh_flat_c {
       (mmioh_flat_en == 0) -> (addr_lo == mmio_high_intlv.addr_lo);
       (mmioh_flat_en == 0) -> (addr_hi == mmio_high_intlv.addr_hi);
    };

    constraint mmioh_top_granularity_c {
        (addr_lo % edge_granularity) == 0;
        ((addr_hi + 1) % edge_granularity) == 0;
    };

    constraint max_addressability_c {
        addr_hi < (1 << 52);
    };

`picker_class_end
