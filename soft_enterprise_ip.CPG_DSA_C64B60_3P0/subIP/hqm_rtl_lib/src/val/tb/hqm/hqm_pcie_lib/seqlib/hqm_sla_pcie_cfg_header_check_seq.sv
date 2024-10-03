`ifndef HQM_SLA_PCIE_CFG_HEADER_CHECK_SEQ_
`define HQM_SLA_PCIE_CFG_HEADER_CHECK_SEQ_

`define HQMV2_PF_VENDOR_ID 'h_8086
`define HQMV2_PF_DEVICE_ID 'h_2714
`define HQMV2_VF_VENDOR_ID 'h_FFFF
`define HQMV2_VF_DEVICE_ID 'h_2715
`define HQMV2_REVISION_ID 8'h_00

class hqm_sla_pcie_cfg_header_check_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_cfg_header_check_seq,sla_sequencer)

  bit     rslt;
  bit     ten_bit_tag_en_strap;
  bit     hqm_is_reg_ep_arg = $test$plusargs("hqm_is_reg_ep");
  string  file_name;
  hqm_tb_cfg_file_mode_seq     i_cfg2_file_mode_seq;
  hqm_sla_pcie_bar_cfg_seq     pcie_bar_cfg_seq;
  rand Iosf::address_t         hqm_pf_unimp_start_addr;
  rand Iosf::address_t         hqm_vf_unimp_start_addr;

  function new(string name = "hqm_sla_pcie_cfg_header_check_seq");
    super.new(name);
    ten_bit_tag_en_strap = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));
  endfunction

  constraint unimp_start_addr_c { hqm_pf_unimp_start_addr==`HQM_PF_UNIMP_START_ADDR; hqm_vf_unimp_start_addr == `HQM_VF_UNIMP_START_ADDR; }

  virtual task body();

    wait_sys_clk(7000); 

    i_cfg2_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg2_file_mode_seq");
    i_cfg2_file_mode_seq.set_cfg("HQM_SEQ_CFG2", 1'b0);
    i_cfg2_file_mode_seq.start(get_sequencer());

    check_capability_structure(); 

  endtask

  task check_capability_structure();
    int k=0;
    int func_=0;
    sla_ral_reg reg_list[$];
    sla_ral_file reg_file;

    if(!$value$plusargs("HQM_FUNC_CFG_VIEW=%d",func_)) func_=0;

    `ovm_info(get_full_name(),$psprintf("Starting cfg_header_check for function #(0x%0x)",func_),OVM_LOW)

    if(func_==0) begin
        // -- PF cfg space started -- //
        `ovm_info(get_full_name(),$psprintf("\n-------------------------------------------\n\
                                               ----------- Checking PF cfg space ---------\n\
                                               -------------------------------------------\n"),OVM_LOW);
    
        pf_cfg_regs.get_regs(reg_list);
        reg_file = reg_list[0].get_file();
          foreach(reg_list[i]) begin
            sla_ral_data_t exp_addr, exp_val;
            sla_ral_data_t act_addr, act_val;
            string exp_str="";
            string act_str=""; bit match=0;
            string reg_name = reg_list[i].get_name();
            act_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),reg_list[i]) & 'h_ffff;
            act_val  = reg_list[i].get_reset_val();

            `ovm_info(get_full_name(),$psprintf("---------- %s register details: act_addr=0x%0x act_val=0x%0x",reg_name, act_addr, act_val),OVM_LOW);
              case (reg_name.tolower())
                 "vendor_id":  begin
                            exp_addr = 'h_0; exp_val = `HQMV2_PF_VENDOR_ID;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "device_id":  begin
                            exp_addr = 'h_2; exp_val = `HQMV2_PF_DEVICE_ID;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "device_command":  begin
                            exp_addr = 'h_4; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "device_status":  begin
                            exp_addr = 'h_6; exp_val = 'h_10;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "revision_id_class_code":  begin
                            exp_addr = 'h_8; exp_val = {`HQM_CLASS_CODE,`HQMV2_REVISION_ID};
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "cache_line_size":  begin
                            exp_addr = 'h_c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end

                  //Hardwired Zero. Latency Timer Register = 'h_d  is getting checked from cfg_view cft from opt file\\

                 "header_type":  begin
                            exp_addr = 'h_e; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end

                  //Hardwired Zero. BIST Register = 'h_f  is getting checked from cfg_view cft from opt file\\

                 "func_bar_l":  begin
                            exp_addr = 'h_10; exp_val = 'h_c;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "func_bar_u":  begin
                            exp_addr = 'h_14; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "csr_bar_l":  begin
                            exp_addr = 'h_18; exp_val = 'h_c;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "csr_bar_u":  begin
                            exp_addr = 'h_1c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end

                  // BAR Register = 'h_20 -- 'h_27  is getting checked from cfg_view cft from opt file\\
                  // RO, Zero: Cardbus CIS pointer Register = 'h_28 -- 'h_2B  is getting checked from cfg_view cft from opt file\\

                 "subsystem_vendor_id":  begin
                            exp_addr = 'h_2c; exp_val = `HQMV2_PF_VENDOR_ID;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "subsystem_id":  begin
                            exp_addr = 'h_2e; exp_val = 'h_00;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end

                  // Expansion ROM BAR = 'h_30 -- 'h_33  is getting checked from cfg_view cft from opt file\\

                 "cap_ptr":  begin
                            exp_addr = 'h_34; exp_val = 'h_60; //Next: MSIx Cap
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                  // 'h_36 -- 'h_3B  is getting checked from cfg_view cft from opt file\\
                 "int_line":  begin
                            exp_addr = 'h_3c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "int_pin":  begin
                            exp_addr = 'h_3d; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end

                  // Min_Gnt/Min_Lat Registers = 'h_3E/'h_3F  is getting checked from cfg_view cft from opt file\\

                 "msix_cap_id":  begin
                            exp_addr = 'h_60; exp_val = 'h_11; // -- Val picked from PCI LB spec 3.0 -- //
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "msix_cap_next_cap_ptr":  begin // Next: PCIe Extended Cap
                            exp_addr = 'h_61; exp_val = 'h_6c; 
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "msix_cap_control":  begin
                            exp_addr = 'h_62; exp_val = 'h_40; // -- Table size 65 -> 65 MSI-X4 supported -- //
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "msix_cap_table_offset_bir":  begin
                            exp_addr = 'h_64; exp_val = 'h_100_0000; // -- Offset of 'h_100_0000 BAR_0 -- //
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "msix_cap_pba_offset_bir":  begin
                            exp_addr = 'h_68; exp_val = 'h_100_1000; // -- Offset of 'h_100_0000 BAR_0 -- //
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_id":  begin
                            exp_addr = 'h_6c; exp_val = 'h_10;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "pcie_cap_next_cap_ptr":  begin
                            exp_addr = 'h_6d; exp_val = 'h_b0; // Next: PM cap
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "pcie_cap":  begin
                            exp_addr = 'h_6e; exp_val = 'h_92; if(hqm_is_reg_ep_arg) exp_val = 'h_02;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_device_cap":  begin
                            exp_addr = 'h_70; exp_val = 'h_1000_8062;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_device_control":  begin
                            exp_addr = 'h_74; exp_val = 'h_2910;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_device_status":  begin
                            exp_addr = 'h_76; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_link_cap":  begin
                            exp_addr = 'h_78; exp_val = 'h_40_0c11;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end
                 "pcie_cap_link_control":  begin
                            exp_addr = 'h_7c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end
                 "pcie_cap_link_status":  begin
                            exp_addr = 'h_7e; exp_val = 'h_1011;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end

                        // slot capabilities, control, status , Root control, capabilities, status registers 'h_80 -- 'h_8F, 

                 "pcie_cap_device_cap_2":  begin
                            exp_addr = 'h_90; exp_val = 'h_71_0010; if(ten_bit_tag_en_strap) exp_val[16] = 1'b_1; else exp_val[16] = 1'b_1; // -- Strap value doesn't affect this bit
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "pcie_cap_device_control_2":  begin
                            exp_addr = 'h_94; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end

                        // 'h_96 -- 'h_A7; Device status 2, Link cap/control/status 2, Slot cap/control/status 2 are getting checked from cfg_view cft from opt file\\

                 "pm_cap_id":  begin
                            exp_addr = 'h_b0; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "pm_cap_next_cap_ptr":  begin
                            exp_addr = 'h_b1; exp_val = 'h_0; // Next: Last Capability structure
                            read_compare(reg_list[i],exp_val,32'h_0000_00ff,rslt); match=rslt;
                        end
                 "pm_cap":  begin
                            exp_addr = 'h_b2; exp_val = 'h_23; 
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pm_cap_control_status":  begin
                            exp_addr = 'h_b4; exp_val = 'h_8;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 // PF Extended capabilities Start
                 "acs_cap_id":  begin
                            exp_addr = 'h_100; exp_val = 'h_d;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "acs_cap_version_next_ptr":  begin // Next: SRIOV cap //--HQMV30: hqm_pf_cfg_fpga.rdl:    hqm_pcie_acs_cap.ACS_CAP_VERSION_NEXT_PTR.CAP_PTR->reset = 12'h148;
                            exp_addr = 'h_102; exp_val = 'h_1481;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "acs_cap":  begin
                            exp_addr = 'h_104; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "acs_cap_control":  begin
                            exp_addr = 'h_106; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end

                  // 'h_108 -- ACS P2P Egress Control Enable (E) = 0; so Egress Control Vector register is not required to be present;  \\
                  // 'h_114 -- SRIOV_CAP_INITIAL_VF_CNT
                  // 'h_118 -- SRIOV_CAP_NUM_VF
                  // 'h_11c -- SRIOV_CAP_FIRST_VF_OFFSET
                  // 'h_120 -- SRIOV_CAP_VF_DEVICE_ID
                  // 'h_124 -- SRIOV_CAP_SUPP_PAGE_SIZE
                  // 'h_128 -- SRIOV_CAP_SYS_PAGE_SIZE
                  // 'h_12c -- SRIOV_CAP_FUNC_BAR_L

                 "pasid_cap_id":  begin
                            exp_addr = 'h_148; exp_val = 'h_1b;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pasid_cap_version_next_ptr":  begin
                            exp_addr = 'h_14a; exp_val = 'h_1501; // Next: SCIOV DVSEC cap
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pasid_cap":  begin
                            exp_addr = 'h_14c; exp_val = 'h_1400;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "pasid_control":  begin
                            exp_addr = 'h_14e; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "dvsec_cap_id":  begin
                            exp_addr = 'h_150; exp_val = 'h_23;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "dvsec_cap_version_next_ptr":  begin
                            exp_addr = 'h_152; exp_val = 'h_1681; // Next: AER Cap
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "dvsec_hdr1":  begin
                            exp_addr = 'h_154; exp_val = 'h_0180_8086;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "dvsec_hdr2":  begin
                            exp_addr = 'h_158; exp_val = 'h_5;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "sciov_cap":  begin
                            exp_addr = 'h_15a; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "sciov_supp_pgsz":  begin
                            exp_addr = 'h_15c; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "sciov_sys_pgsz":  begin
                            exp_addr = 'h_160; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "sciov_ims":  begin
                            exp_addr = 'h_164; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end

                 "aer_cap_id":  begin //
                            exp_addr = 'h_168; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "aer_cap_version_next_ptr":  begin
                            exp_addr = 'h_16a; exp_val = 'h_1B02; if(hqm_is_reg_ep_arg) exp_val = 'h_1B02;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                        end
                 "aer_cap_uncorr_err_status":  begin
                            exp_addr = 'h_16c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_uncorr_err_mask":  begin
                            exp_addr = 'h_170; exp_val = 'h_40_0000;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_uncorr_err_sev":  begin
                            exp_addr = 'h_174; exp_val = 'h_44_0000;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_corr_err_status":  begin
                            exp_addr = 'h_178; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_corr_err_mask":  begin
                            exp_addr = 'h_17c; exp_val = 'h_6000;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_control":  begin
                            exp_addr = 'h_180; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_header_log_0":  begin
                            exp_addr = 'h_184; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_header_log_1":  begin
                            exp_addr = 'h_188; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_header_log_2":  begin
                            exp_addr = 'h_18c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_header_log_3":  begin
                            exp_addr = 'h_190; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_root_error_command":  begin
                            exp_addr = 'h_194; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_root_error_status":  begin
                            exp_addr = 'h_198; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_error_source_ident":  begin
                            exp_addr = 'h_19c; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_tlp_prefix_log_0":  begin
                            exp_addr = 'h_1a0; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_tlp_prefix_log_1":  begin
                            exp_addr = 'h_1a4; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_tlp_prefix_log_2":  begin
                            exp_addr = 'h_1a8; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "aer_cap_tlp_prefix_log_3":  begin
                            exp_addr = 'h_1ac; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end

                 "ari_cap_id":  begin
                            exp_addr = 'h_1b0; exp_val = 'h_e;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end
                 "ari_cap_version_next_ptr":  begin
                            exp_addr = 'h_1b2; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end
                 "ari_cap":  begin
                            exp_addr = 'h_1b4; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_0000_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end
                 "ari_cap_control":  begin
                            exp_addr = 'h_1b6; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                            if(!hqm_is_reg_ep_arg) `ovm_error(get_full_name(), $psprintf("Unexpected reg present for RCIEP mode of HQM"))
                        end

                 "ats_cap_id":  begin
                            exp_addr = 'h_1b0; exp_val = 'h1_000f;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end
                 "ats_cap_version_next_ptr":  begin
                            exp_addr = 'h_1b2; exp_val = 'h_1;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end

                 "ats_cap":  begin
                            exp_addr = 'h_1b4; exp_val = 'h_60;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end

                 "ats_cap_control":  begin
                            exp_addr = 'h_1b6; exp_val = 'h_0;
                            read_compare(reg_list[i],exp_val,32'h_ffff_ffff,rslt); match=rslt;
                        end



              endcase
              act_str = $psprintf("\tAddress:0x%0x, Value:0x%0x",act_addr,act_val);
              exp_str = $psprintf("\tAddress:0x%0x; Value:0x%0x",exp_addr,exp_val);
              if(match) `ovm_info(get_full_name(),$psprintf("%s-> Regsiter check PASSED against expected:%s" ,act_str,exp_str),OVM_LOW)
              else      `ovm_error(get_full_name(),$psprintf("%s-> Regsiter check FAILED against expected:%s",act_str,exp_str))
          end
    
    
         // -- Check from last implemented address to end of cfg space 4KB -- //
         for(Iosf::address_t addr = hqm_pf_unimp_start_addr; addr[15:0] < 'h_fff; addr = addr + 'h_4) begin
           addr[31:24] = pf_cfg_regs.DEVICE_COMMAND.get_bus_num();
           addr[23:19] = pf_cfg_regs.DEVICE_COMMAND.get_dev_num();
           addr[18:16] = pf_cfg_regs.DEVICE_COMMAND.get_func_num();

           cfgrd_chk_addr(addr, 'h_0);
         end

    end // -- HQM_CFG_VIEW   
    // -- PF cfg space ended -- //

         // -- Check unimplemented regs rd data till last implemented address -- //
         if ($value$plusargs({"HQM_CFG_VIEW","=%s"}, file_name)) begin 
            `ovm_info(get_full_name(),$psprintf("Call rd_chk_file HQM_CFG_VIEW=file_name=%s", file_name),OVM_LOW)
            rd_chk_file(file_name); 
         end else begin 
              case(hqm_is_reg_ep_arg)
                1'b_1  : // ---------------------------- EP mode ------------------------- // 
                         if(func_==0) file_name = "$WORKAREA/src/val/tb/hqm/hqm_pcie_lib/cft/hqm_ep_pf_cfg_view"; 
                         else         file_name = $psprintf("$WORKAREA/src/val/tb/hqm/hqm_pcie_lib/cft/hqm_ep_vf%0d_cfg_view", k);
                default: // ---------------------------- RCIEP mode ------------------------- // 
                         if(func_==0) file_name = "$WORKAREA/src/val/tb/hqm/hqm_pcie_lib/cft/hqm_rciep_pf_cfg_view"; 
                         else         file_name = $psprintf("$WORKAREA/src/val/tb/hqm/hqm_pcie_lib/cft/hqm_rciep_vf%0d_cfg_view", k);
              endcase
              `ovm_info(get_full_name(),$psprintf("Call rd_chk_file file_name=%s hqm_is_reg_ep_arg=%0d", file_name, hqm_is_reg_ep_arg),OVM_LOW)
              rd_chk_file(file_name); 
         end

  endtask

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass

`endif
