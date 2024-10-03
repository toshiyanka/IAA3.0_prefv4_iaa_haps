// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_pwr_long_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"
//import "DPI-C" context SLA_VPI_put_value =
//  function void hqm_seq_put_value(input chandle handle, input logic [0:0] value);

class hqm_pwr_long_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_long_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_long_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(flr,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_long_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(flr)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      flr;
  constraint soft_flr { soft flr == 0;}       

  function new(string name = "hqm_pwr_long_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_long_seq_stim_config

class hqm_pwr_long_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_long_seq)

  rand hqm_pwr_long_seq_stim_config        cfg;

  hqm_sla_pcie_flr_sequence                flr_seq;
  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_cold_reset_sequence                  cold_reset_sequence; 
  hqm_reset_unit_sequence                  lcp_seq;
  hqm_tb_cfg_file_mode_seq                 i_cfg_file_mode_seq;
  hqm_tb_cfg_file_mode_seq                 i_hcw_file_mode_seq;
  hcw_perf_dir_ldb_test1_hcw_seq           hcw_traffic_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_long_seq_stim_config);

  function new(string name = "hqm_pwr_long_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_long_seq_stim_config::type_id::create("hqm_pwr_long_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task generate_hcw_traffic();

endclass : hqm_pwr_long_seq

task hqm_pwr_long_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  bit [63:0] D3toD0_event_cnt = 64'h0;
  //chandle               force_async_cold_reset_handle;
  

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_long_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
 // 1.	Cold_reset
 // 2.	FLR
 // 3.	write cfg_pm_pmcsr_disable(32’h0)
    `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_pwr_long_seq \n"),OVM_LOW)
     wait_for_clk(100); 
     `ovm_info(get_full_name(),$sformatf("\n completed wait_for_clk(1) \n"),OVM_LOW)
     `ovm_do_with(flr_seq, {flr_seq.no_sys_init==1'b1;}) 
     `ovm_info(get_full_name(),$sformatf("\n completed flr(2) \n"),OVM_LOW)
     `ovm_do(pcie_init)
     D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
     `ovm_info(get_full_name(),$sformatf("\n completed pcie_init(3) \n"),OVM_LOW)
 // 4.	D0->D3
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3(4) \n"),OVM_LOW)
 // 5.	D3->D0
     pmcsr_ps_cfg(`HQM_D0STATE);
     D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D0(5) \n"),OVM_LOW)
     poll_rst_done();
     generate_hcw_traffic();
 // 6.	FLR
     `ovm_do(flr_seq) // internally calls pcie_init with pcie_init.cfg.skip_pmcsr_disable==1
     `ovm_info(get_full_name(),$sformatf("\n completed flr(6) \n"),OVM_LOW)
 // 7.	D0->D3
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3(7) \n"),OVM_LOW)
 // 8.	FLR
     `ovm_do(flr_seq) 
     D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
     `ovm_info(get_full_name(),$sformatf("\n completed flr(8) \n"),OVM_LOW)
 // 9.	D0->D3
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3(9) \n"),OVM_LOW)
     // As per Bill's comment 
     // lcp_shift_done cannot be done outside of a COLD or WARM reset sequence. 
     // For WARM reset, shift_done drops concurrent with prim_rst_b and asserts after side_rst_b is released and before prim_rst_b Is released.
     // `ovm_info(get_type_name(),"starting lcp_seq", OVM_LOW)
     // `ovm_do_on_with(lcp_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::LCP_RESET; LcpDatIn==32'hFFFFFFFF;}) 
 // 10.	Cold_reset
    // `ovm_do_with(cold_reset_sequence, {skip_pcie_init==1'b1;}) 
    `ovm_do(cold_reset_sequence)
    ral.reset_regs();
    reset_tb(); // After coldreset scoreboard and prim_mon need to be reset
    D3toD0_event_cnt = 64'h0;

     `ovm_info(get_full_name(),$sformatf("\n completed cold_reset(10) \n"),OVM_LOW)
 //11.	write cfg_pm_pmcsr_disable(32’h0)
     `ovm_do(pcie_init)
     D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
     `ovm_info(get_full_name(),$sformatf("\n completed pcie_init(11) \n"),OVM_LOW)
     generate_hcw_traffic();
 //12.	FLR
     `ovm_do(flr_seq) 
     `ovm_info(get_full_name(),$sformatf("\n completed flr(12) \n"),OVM_LOW)
 //13.	D0->D3
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3(13) \n"),OVM_LOW)
 //14.	D3->D0
     pmcsr_ps_cfg(`HQM_D0STATE);
     D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D0(14) \n"),OVM_LOW)
     `ovm_do(pcie_init)
     `ovm_info(get_full_name(),$sformatf("\n completed pcie_init(15) \n"),OVM_LOW)
     generate_hcw_traffic();
     compare("config_master","cfg_d3tod0_event_cnt_l","count",SLA_FALSE,D3toD0_event_cnt[31:0]);
     compare("config_master","cfg_d3tod0_event_cnt_h","count",SLA_FALSE,D3toD0_event_cnt[63:32]);
 //15.	D0->D3
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3(16) \n"),OVM_LOW)
     pmcsr_ps_cfg(`HQM_D0STATE);
     `ovm_info(get_full_name(),$sformatf("\n completed program_to_D0(17) \n"),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_long_seq ended \n"),OVM_LOW)
     
endtask : body

task hqm_pwr_long_seq::generate_hcw_traffic();
    `ovm_info(get_full_name(),$sformatf("\n generate_hcw_traffic started \n"),OVM_LOW)
    i_cfg_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_cfg_file_mode_seq");
    if ($test$plusargs("HQM_PWR_CFG_CFT")) begin   
       `ovm_info(get_full_name(),$sformatf("\n picking HQM_PWR_CFG_CFT\n"),OVM_LOW)
       i_cfg_file_mode_seq.set_cfg("HQM_PWR_CFG_CFT", 1'b0);
    end 
    else begin 
       `ovm_info(get_full_name(),$sformatf("\n picking HQM_SEQ_CFG\n"),OVM_LOW)
       i_cfg_file_mode_seq.set_cfg("HQM_SEQ_CFG", 1'b0);
    end 
    i_cfg_file_mode_seq.start(get_sequencer());

    `ovm_info(get_full_name(),$sformatf("\n configuration ended \n"),OVM_LOW)

    if ($test$plusargs("HQM_PWR_HCW_CFT")) begin   
       `ovm_info(get_full_name(),$sformatf("\n Generating hcw traffic using cft \n"),OVM_LOW)
       i_hcw_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hcw_file_mode_seq");
       i_hcw_file_mode_seq.set_cfg("HQM_PWR_HCW_CFT", 1'b0);
       i_hcw_file_mode_seq.start(get_sequencer());
    end 
    else begin 
       `ovm_info(get_full_name(),$sformatf("\n Generating hcw traffic after pwr extra data phase using seq \n"),OVM_LOW)
        `ovm_do (hcw_traffic_seq)
    end 
    `ovm_info(get_full_name(),$sformatf("\n generate_hcw_traffic ended \n"),OVM_LOW)
endtask : generate_hcw_traffic
