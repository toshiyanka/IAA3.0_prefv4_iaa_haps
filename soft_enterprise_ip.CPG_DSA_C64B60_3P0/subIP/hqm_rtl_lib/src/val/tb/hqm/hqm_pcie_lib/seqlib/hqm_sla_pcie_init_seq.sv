//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_SLA_PCIE_INIT_SEQ__SV
`define HQM_SLA_PCIE_INIT_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_init_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence initializes PCIe cfg space of HQM.
//               Configures in PF/SRIOv/SCIOV mode,
//               Programs BARs, sets up MSI/MSIX tables, and PCIe control registers.
//               Control parameters as below,
//               - pf_func_bar        -> PF FUNC BAR value
//               - pf_csr_bar         -> CSR BAR value 
//               - sriov_bar          -> SRIOV BAR value 
//               - mode               -> sriov/sciov/pf 
//               - num_vfs            -> 0-16 
//               - skip_pmcsr_disable -> If 1, skips write '0' to PMCSR  
//               - skip_msix_cfg      -> If 1, skips MSIX table setup  
//               - enter_d3_post_init -> If 1, programs HQM to enter D3 state post initialization
//------------------------------------------------------------------------------


`include "stim_config_macros.svh"

class hqm_pcie_init_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_pcie_init_stim_config";
 
  rand bit [63:0]   pf_func_bar              ; 
  rand bit [63:0]   pf_csr_bar               ;
  rand bit [63:0]   sriov_bar                ;
  rand hqm_mode_t   mode                     ;  
  rand bit [15:0]   num_vfs                  ;
  rand bit          ats_enable               ;  
  rand bit          skip_bar_prog            ;  
  rand bit          skip_pcie_prog           ;  
  rand bit          skip_pmcsr_disable       ;  
  rand bit          skip_msix_cfg            ;  
  rand bit          enter_d3_post_init       ;  
  rand bit          issue_hw_reset_force_pwr_on;  

  rand bit          ser                      ;
  rand bit          per                      ;
  rand bit          bme                      ;
  rand bit          mem                      ;

  rand bit [2:0]    mrs                      ;
  rand bit          ens                      ;
  rand bit          etfe                     ;
  rand bit [2:0]    mps                      ;
  rand bit          ero                      ;
  rand bit          urro                     ;
  rand bit          fere                     ;
  rand bit          nere                     ;
  rand bit          cere                     ;

  rand bit          eido                     ;

  rand bit          ieunc_mask               ;
  rand bit          ur_mask                  ;
  rand bit          mtlp_mask                ;
  rand bit          ec_mask                  ;
  rand bit          ct_mask                  ;
  rand bit          ptlpr_mask               ;

  rand bit          ieunc_sev                ;
  rand bit          ur_sev                   ;
  rand bit          mtlp_sev                 ;
  rand bit          ec_sev                   ;
  rand bit          ct_sev                   ;
  rand bit          ptlpr_sev                ;

  rand bit          iecor_mask               ;
  rand bit          anfes_mask               ;

  `ovm_object_utils_begin(hqm_pcie_init_stim_config)
    `ovm_field_int(pf_func_bar        , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_csr_bar         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_vfs            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sriov_bar          , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ats_enable         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_bar_prog      , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_pcie_prog     , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_pmcsr_disable , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_msix_cfg      , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enter_d3_post_init , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mrs                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ens                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(etfe               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mps                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ero                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(urro               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(fere               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(nere               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cere               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ser                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(per                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(bme                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mem                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(eido               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ieunc_mask         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ur_mask            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mtlp_mask          , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ec_mask            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ct_mask            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ptlpr_mask         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ieunc_sev          , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ur_sev             , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mtlp_sev           , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ec_sev             , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ct_sev             , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ptlpr_sev          , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(iecor_mask         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(anfes_mask         , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hqm_mode_t        , mode, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(issue_hw_reset_force_pwr_on , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pcie_init_stim_config)
    `stimulus_config_field_rand_int(pf_func_bar       )
    `stimulus_config_field_rand_int(pf_csr_bar        )
    `stimulus_config_field_rand_int(num_vfs           )
    `stimulus_config_field_rand_int(sriov_bar         )
    `stimulus_config_field_rand_enum(hqm_mode_t, mode )
    `stimulus_config_field_rand_int(ats_enable     )
    `stimulus_config_field_rand_int(skip_bar_prog     )
    `stimulus_config_field_rand_int(skip_pcie_prog    )
    `stimulus_config_field_rand_int(skip_pmcsr_disable)
    `stimulus_config_field_rand_int(skip_msix_cfg     )
    `stimulus_config_field_rand_int(enter_d3_post_init)
    `stimulus_config_field_rand_int(mrs               )
    `stimulus_config_field_rand_int(ens               )
    `stimulus_config_field_rand_int(etfe              )
    `stimulus_config_field_rand_int(mps               )
    `stimulus_config_field_rand_int(ero               )
    `stimulus_config_field_rand_int(urro              )
    `stimulus_config_field_rand_int(fere              )
    `stimulus_config_field_rand_int(nere              )
    `stimulus_config_field_rand_int(cere              )
    `stimulus_config_field_rand_int(ser               )
    `stimulus_config_field_rand_int(per               )
    `stimulus_config_field_rand_int(bme               )
    `stimulus_config_field_rand_int(mem               )
    `stimulus_config_field_rand_int(eido              )
    `stimulus_config_field_rand_int(ieunc_mask        )
    `stimulus_config_field_rand_int(ur_mask           )
    `stimulus_config_field_rand_int(mtlp_mask         )
    `stimulus_config_field_rand_int(ec_mask           )
    `stimulus_config_field_rand_int(ct_mask           )
    `stimulus_config_field_rand_int(ptlpr_mask        )
    `stimulus_config_field_rand_int(ieunc_sev         )
    `stimulus_config_field_rand_int(ur_sev            )
    `stimulus_config_field_rand_int(mtlp_sev          )
    `stimulus_config_field_rand_int(ec_sev            )
    `stimulus_config_field_rand_int(ct_sev            )
    `stimulus_config_field_rand_int(ptlpr_sev         )
    `stimulus_config_field_rand_int(iecor_mask        )
    `stimulus_config_field_rand_int(anfes_mask        )
    `stimulus_config_field_rand_int(issue_hw_reset_force_pwr_on)
  `stimulus_config_object_utils_end
 
  constraint hqm_mode_c     { soft mode == pf; }

  constraint num_vfs_c      { soft num_vfs == 16'h_10; }

  constraint _pmcsr_dis_    { soft skip_pmcsr_disable == 1'b_0; }

  constraint _ats_ena_      { soft ats_enable == 1'b_0; }

  constraint _bar_skip_     { soft skip_bar_prog == 1'b_0; }

  constraint _pcie_skip_    { soft skip_pcie_prog == 1'b_0; }

  constraint _msix_msi_cfg_ { soft skip_msix_cfg == 1'b_1; }

  constraint enter_d3_post_init_c { soft enter_d3_post_init == 1'b_0; }

  constraint hw_reset_force_pwr_on_c    { soft issue_hw_reset_force_pwr_on == 1'b_0; }

  constraint _pcie_control_fields_ {
             soft mrs        == 3'b_010 ; 
  // --      soft ens        == 1'b_1   ;  ens  to be 0/1  -- //
  // --      soft etfe       == 1'b_1   ;  etfe to be 0/1  -- //
             soft mps        == 3'b_000 ; 
  // --      soft ero        == 1'b_1   ;  ero  to be 0/1  -- //
             soft urro       == 1'b_1   ; 
             soft fere       == 1'b_1   ; 
             soft nere       == 1'b_1   ; 
             soft cere       == 1'b_1   ; 
             soft ser        == 1'b_0   ; 
             soft per        == 1'b_0   ; 
             soft bme        == 1'b_1   ; 
             soft mem        == 1'b_1   ; 
  // --      soft eido       == 1'b_0   ;  eido to be 0/1 -- //
             soft ieunc_mask == 1'b_1   ; 
             soft ur_mask    == 1'b_0   ; 
             soft mtlp_mask  == 1'b_0   ; 
             soft ec_mask    == 1'b_0   ; 
             soft ct_mask    == 1'b_0   ; 
             soft ptlpr_mask == 1'b_0   ; 
             soft ieunc_sev  == 1'b_1   ; 
             soft ur_sev     == 1'b_0   ; 
             soft mtlp_sev   == 1'b_1   ; 
             soft ec_sev     == 1'b_0   ; 
             soft ct_sev     == 1'b_0   ; 
             soft ptlpr_sev  == 1'b_0   ; 
             soft iecor_mask == 1'b_1   ; 
             soft anfes_mask == 1'b_1   ; 

  }

  constraint _bars_ {
    // -- Ensure non-overlapping base addresses by default, Can be overriden via stim_cfg -- //
    pf_func_bar[25:0]   == 26'h0;
    pf_csr_bar[31:0]    == 32'h0;
    sriov_bar[25:0]     == 26'h0;
    sriov_bar[29:26]    == 4'h0;        // needed because RAL access routines OR the offset with SRIOV BAR register
                                                // and the offset includes the VF number in bits [29:26]

    soft ((pf_func_bar + 'h04000000)            <= pf_csr_bar) ||
         ( pf_func_bar                          >= (pf_csr_bar + 64'h00000001_00000000));

    soft ((sriov_bar + (16 * 'h04000000))       <= pf_csr_bar) ||
         ( sriov_bar                            >= (pf_csr_bar + 64'h00000001_00000000));

    soft ((sriov_bar + (16 * 'h04000000))       <= pf_func_bar) ||
         ( sriov_bar                            >= (pf_func_bar + 64'h00000000_04000000));
  }  

  function new(string name = "hqm_pcie_init_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_pcie_init_stim_config

class hqm_sla_pcie_init_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_init_seq,sla_sequencer)

  static  bit                     cap_struct_chk=1;
  hqm_sla_pcie_bar_cfg_seq        pcie_bar_cfg_seq;
  hqm_msix_cfg_seq                msix_cfg;
  hqm_mode_t                      hqm_mode;
  static  bit                     first_init_override = 1'b_1;

  rand  hqm_pcie_init_stim_config cfg; 
 
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pcie_init_stim_config);

  function new(string name = "hqm_sla_pcie_init_seq");
    super.new(name);
    cfg = hqm_pcie_init_stim_config::type_id::create("hqm_pcie_init_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
  endfunction

  virtual task body();

    apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

    hqm_mode = cfg.mode ;

    `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program BAR as: cfg.pf_func_bar (0x%0x), cfg.pf_csr_bar (0x%0x), cfg.sriov_bar (0x%0x)", cfg.pf_func_bar, cfg.pf_csr_bar, cfg.sriov_bar), OVM_LOW)

    // ----------------- 
    // ----------------- 
    if(cfg.ats_enable == 1'b_1 || $test$plusargs("HQMV30_ATS_ENA")) begin 
       `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program ATS_CAP_CONTROL.ATSE=1"), OVM_LOW);
        pf_cfg_regs.ATS_CAP_CONTROL.write_fields(status,{"ATSE"},{1'b_1},primary_id,this,.sai(legal_sai));
        read_compare(pf_cfg_regs.ATS_CAP_CONTROL,32'h8000,.mask(32'h_0000_ffff), .result(result));
       `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program ATS_CAP_CONTROL.ATSE=1 completed"), OVM_LOW);
    end

    // ----------------- 
    if(cfg.skip_bar_prog == 1'b_0) begin 
	`ovm_do_with(pcie_bar_cfg_seq,{func_bar_h==cfg.pf_func_bar[63:32]; func_bar_l == cfg.pf_func_bar[31:0]; csr_bar_h==cfg.pf_csr_bar[63:32];});

       `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program DEVICE_COMMAND, PCIE_CAP_DEVICE_CONTROL"), OVM_LOW);
	pf_cfg_regs.DEVICE_COMMAND.write(status,{7'h_0,cfg.ser,1'b0,cfg.per,3'b_000,cfg.bme,cfg.mem,1'b_0},primary_id,this,.sai(legal_sai));
        //iosf_pri_protocol lib does not filter return data, just use mask here for 16-bit regs
	read_compare(pf_cfg_regs.DEVICE_COMMAND,{7'h_0,cfg.ser,1'b0,cfg.per,3'b_000,cfg.bme,cfg.mem,1'b_0},.mask(32'h_0000_ffff),.result(result));
	pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status,{1'b_0,cfg.mrs,cfg.ens,2'b_00,cfg.etfe,cfg.mps,cfg.ero,cfg.urro,cfg.fere,cfg.nere,cfg.cere},primary_id,this,.sai(legal_sai));
    end
    
    // ----------------- 
    if(cfg.skip_pcie_prog == 1'b_0) begin 
      `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program PCIE_CAP_DEVICE_CONTROL_2, AER_CAP_UNCORR_ERR_MASK, AER_CAP_UNCORR_ERR_SEV, AER_CAP_CORR_ERR_MASK"), OVM_LOW);
	pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL_2.write(status,{cfg.eido,8'h_0},primary_id,this,.sai(legal_sai));

	pf_cfg_regs.AER_CAP_UNCORR_ERR_MASK.write(status,{cfg.ieunc_mask,1'b_0,cfg.ur_mask,1'b_0,cfg.mtlp_mask,1'b_0,cfg.ec_mask,1'b_0,cfg.ct_mask,1'b_0,cfg.ptlpr_mask,12'h_0},primary_id,this,.sai(legal_sai));
	pf_cfg_regs.AER_CAP_UNCORR_ERR_SEV.write(status,{cfg.ieunc_sev,1'b_0,cfg.ur_sev,1'b_0,cfg.mtlp_sev,1'b_0,cfg.ec_sev,1'b_0,cfg.ct_sev,1'b_0,cfg.ptlpr_sev,12'h_0},primary_id,this,.sai(legal_sai));
	pf_cfg_regs.AER_CAP_CORR_ERR_MASK.write(status,{cfg.iecor_mask,cfg.anfes_mask,13'h_0},primary_id,this,.sai(legal_sai));
    end

    // ----------------- 
    if(cfg.skip_pmcsr_disable == 1'b_0) begin 
      `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: program CFG_PM_PMCSR_DISABLE=0"), OVM_LOW);
       master_regs.CFG_PM_PMCSR_DISABLE.write(status,32'h_0,primary_id,this,.sai(legal_sai));
       read_compare(master_regs.CFG_PM_PMCSR_DISABLE,32'h_0,.result(result));
       poll_reg_val(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,1000);
    end else if(cfg.issue_hw_reset_force_pwr_on == 1'b1) begin
      `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: skip CFG_PM_PMCSR_DISABLE=0 setting and force hqm_tb_top.hw_reset_force_pwr_on=1 "), OVM_LOW);
       sla_vpi_force_value_by_name("hqm_tb_top.hw_reset_force_pwr_on", 1);
       poll_reg_val(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,1000);
    end

    `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: hqm_pcie_init_stim_config provided mode as %s", cfg.mode.name()), OVM_LOW);

    // -- if(first_init_override) begin hqm_mode = chk_hqm_mode_override(); first_init_override = 1'b_0; end

    // ----------------- 
    if (hqm_mode == sciov) begin   
       //--"reg_utils-srvrvip-20ww11a" fixed it, keep write_fields:
       `ovm_info(get_full_name(),$psprintf("hqm_sla_pcie_init_seq:: program Configuring HQM in SCIOV mode PASID_CONTROL.PASID_ENABLE=1"),OVM_LOW);
       pf_cfg_regs.PASID_CONTROL.write_fields(status,{"PASID_ENABLE"},{1'b_1},primary_id,this,.sai(legal_sai));

      //-- write again with reg.write due to Gen3 contour bug https://hsdes.intel.com/resource/14010999661 
      // `ovm_info(get_full_name(),$psprintf("Configuring HQM in SCIOV mode"),OVM_LOW);
      // pf_cfg_regs.PASID_CONTROL.write(status,32'h1,primary_id,this,.sai(legal_sai));
    end else begin   
       `ovm_info(get_full_name(),$psprintf("hqm_sla_pcie_init_seq:: program Configuring HQM in PF only mode"),OVM_LOW);
       if($test$plusargs("HQM_WAIT_FOR_IDLE")) begin
          #1000ns;
       end
    end

    // ----------------- 
    if(cfg.skip_msix_cfg == 0) begin `ovm_do(msix_cfg); end

    // ----------------- 
    if(cfg.enter_d3_post_init == 1) begin pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,32'h_3,primary_id,this,.sai(legal_sai)); wait_ns_clk(2000); end

  endtask

  function hqm_mode_t chk_hqm_mode_override();
    string mode = "";
    if(!$value$plusargs("HQM_INIT_MODE=%s",mode)) begin mode = "sciov"; end
    `ovm_info(get_full_name(), $psprintf("chk_hqm_mode_override method provided mode:(%s)",mode), OVM_LOW)
     case (mode.tolower())
       "pf"   : chk_hqm_mode_override = pf;
       "sriov": chk_hqm_mode_override = sriov;
       "sciov": chk_hqm_mode_override = sciov;
       default: chk_hqm_mode_override = sciov;
     endcase
  endfunction

  function init_sm_addr();
    bit [63:0] addr_alloc;

    // -- HQM_PF_FUNC_BAR_SPACE allocation -- //
    addr_alloc = get_sm_addr("HQM_PF_FUNC_BAR_SPACE", (`HQM_PF_FUNC_BAR_SIZE + 1), `HQM_PF_FUNC_BAR_SIZE/*, "s0_mmioh"*/);
    cfg.pf_func_bar = addr_alloc;

    // -- HQM_PF_CSR_BAR_SPACE allocation -- //
    addr_alloc = get_sm_addr("HQM_PF_CSR_BAR_SPACE", (`HQM_PF_CSR_BAR_SIZE+1), `HQM_PF_CSR_BAR_SIZE/*, "s0_mmioh"*/);
    cfg.pf_csr_bar = addr_alloc;

    `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_init_seq:: SM BAR addr: cfg.pf_func_bar (0x%0x), cfg.pf_csr_bar (0x%0x)", cfg.pf_func_bar, cfg.pf_csr_bar), OVM_LOW)

  endfunction

endclass

`endif
