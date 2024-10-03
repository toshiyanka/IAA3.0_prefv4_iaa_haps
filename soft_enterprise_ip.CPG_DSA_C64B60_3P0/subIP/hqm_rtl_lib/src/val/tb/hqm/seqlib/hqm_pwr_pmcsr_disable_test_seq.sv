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
// File   : hqm_pwr_pmcsr_disable_test_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the test_seqbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pwr_pmcsr_disable_test_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_pmcsr_disable_test_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_pmcsr_disable_test_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(flr,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_pmcsr_disable_test_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(flr)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      flr;
  constraint soft_flr { soft flr == 0;}       

  function new(string name = "hqm_pwr_pmcsr_disable_test_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_pmcsr_disable_test_seq_stim_config

class hqm_pwr_pmcsr_disable_test_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_pmcsr_disable_test_seq)

  logic [63:0] reg_q_np_pg[$];
  logic [63:0] reg_q_np_npg[$];
  logic [63:0] reg_q_p_pg[$];
  logic [63:0] reg_q_p_npg[$];

  string           cfg_cmds[$];
  string ref_name;
  bit         do_cfg_seq;
  hqm_cfg_seq cfg_seq;
  string      cmd;
  rand hqm_pwr_pmcsr_disable_test_seq_stim_config        cfg;

  Iosf::data_t          iosf_data_0[];
  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_sla_pcie_eot_checks_sequence         error_status_chk_seq;
  hqm_iosf_prim_base_seq                   iosf_base_seq;
  hcw_perf_dir_ldb_test1_hcw_seq hcw_traffic_seq;
  hqm_tb_cfg_file_mode_seq i_opt_file_mode_seq;
  hqm_cfg             i_hqm_cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_pmcsr_disable_test_seq_stim_config);

  function new(string name = "hqm_pwr_pmcsr_disable_test_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_pmcsr_disable_test_seq_stim_config::type_id::create("hqm_pwr_pmcsr_disable_test_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task fill_reg_q_np_pg();

  extern virtual task fill_reg_q_np_npg();

  extern virtual task fill_reg_q_p_pg();

  extern virtual task fill_reg_q_p_npg();

  extern virtual task set_hcw_exp_drop(input int val);

  extern virtual task send_cmd();

endclass : hqm_pwr_pmcsr_disable_test_seq

task  hqm_pwr_pmcsr_disable_test_seq::fill_reg_q_p_npg();

    reg_q_p_npg.push_back(get_reg_addr("hqm_sif_csr","hcw_timeout", "primary"));

endtask : fill_reg_q_p_npg

task  hqm_pwr_pmcsr_disable_test_seq::fill_reg_q_p_pg();

    reg_q_p_pg.push_back(get_reg_addr("hqm_msix_mem", "vector_ctrl[0]", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("hqm_system_csr","ingress_alarm_enable", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("hqm_system_csr","parity_ctl", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("list_sel_pipe","cfg_patch_control", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("direct_pipe","cfg_unit_timeout", "primary"));
    //reg_q_p_pg.push_back(get_reg_addr("dqed_pipe","cfg_control_general", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("qed_pipe","cfg_control_general", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("nalb_pipe","cfg_control_general", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("atm_pipe","cfg_control_general", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("aqed_pipe","cfg_control_pipeline_credits", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("reorder_pipe","cfg_rop_csr_control", "primary"));
    reg_q_p_pg.push_back(get_reg_addr("credit_hist_pipe","cfg_dir_cq_depth[0]", "primary"));

endtask : fill_reg_q_p_pg

task  hqm_pwr_pmcsr_disable_test_seq::fill_reg_q_np_pg();

    reg_q_np_pg.push_back(get_reg_addr("hqm_msix_mem", "vector_ctrl[0]", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("hqm_system_csr","total_ldb_ports", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("hqm_system_csr","total_dir_ports", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("list_sel_pipe","cfg_patch_control", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("direct_pipe","cfg_unit_timeout", "primary"));
    //reg_q_np_pg.push_back(get_reg_addr("dqed_pipe","cfg_control_general", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("nalb_pipe","cfg_interface_status", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("atm_pipe","cfg_unit_version", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("aqed_pipe","cfg_control_pipeline_credits", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("reorder_pipe","cfg_rop_csr_control", "primary"));
    reg_q_np_pg.push_back(get_reg_addr("credit_hist_pipe","cfg_dir_cq_depth[0]", "primary"));

endtask : fill_reg_q_np_pg

task  hqm_pwr_pmcsr_disable_test_seq::fill_reg_q_np_npg();

    reg_q_np_npg.push_back(get_reg_addr("hqm_sif_csr","hqm_csr_cp_lo", "primary"));
    reg_q_np_npg.push_back(get_reg_addr("hqm_sif_csr","hqm_csr_cp_hi", "primary"));
    reg_q_np_npg.push_back(get_reg_addr("hqm_sif_csr","side_cdc_ctl", "primary"));
    reg_q_np_npg.push_back(get_reg_addr("hqm_sif_csr","prim_cdc_ctl", "primary"));
    reg_q_np_npg.push_back(get_reg_addr("config_master","cfg_pm_override", "primary"));
    reg_q_np_npg.push_back(get_reg_addr("config_master","cfg_pm_pmcsr_disable", "primary"));

endtask : fill_reg_q_np_npg

task hqm_pwr_pmcsr_disable_test_seq::set_hcw_exp_drop(input int val);
  for(int i=0;i<16;i++) begin
    $sformat(ref_name,"dir pp %0d exp_drop=%0d",i,val);
    cfg_cmds.push_back(ref_name);
  end   
  for(int i=0;i<8;i++) begin
    $sformat(ref_name,"ldb pp %0d exp_drop=%0d",i,val);
    cfg_cmds.push_back(ref_name);
  end
  send_cmd();
endtask : set_hcw_exp_drop

task hqm_pwr_pmcsr_disable_test_seq::send_cmd();
  while (cfg_cmds.size()) begin
      cmd = cfg_cmds.pop_front();
      i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
      if (do_cfg_seq) begin
        `ovm_create(cfg_seq)
        cfg_seq.pre_body();
        start_item(cfg_seq);
        finish_item(cfg_seq);
        cfg_seq.post_body();
      end
  end
endtask : send_cmd

task hqm_pwr_pmcsr_disable_test_seq::body();
  ovm_object temp_o;

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_disable_test_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  
  //-----------------------------
  //-- get i_hqm_cfg 
  //----------------------------- 
  if (!p_sequencer.get_config_object("i_hqm_cfg", temp_o,0)) begin
    ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
  end

  if (!$cast(i_hqm_cfg, temp_o)) begin
    ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
  end   
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

 // COLD boot HQM.
 // Do not clear pmcsr_disable. IOSF interface will be in D0, but hqm_proc is powered off. 
 `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_pwr_pmcsr_disable_test_seq \n"),OVM_LOW)
 `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
 `ovm_info(get_full_name(),$sformatf("\n completed pcie_init \n"),OVM_LOW)

 // Ensure access to memory in all MMIO BAR spaces are handled cleanly- every NP access returns a response. Posted accesses are accepted without error.
 // Desired response to NP requests is UR.
 fill_reg_q_np_pg();

 foreach (reg_q_np_pg[i]) begin
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == reg_q_np_pg[i];iosf_exp_error_l == 1'b0;})
 end 
 `ovm_info(get_full_name(),$sformatf("\n completed fill_reg_q_np_pg \n"),OVM_LOW)


 fill_reg_q_np_npg();

 foreach (reg_q_np_npg[i]) begin
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == reg_q_np_npg[i];iosf_exp_error_l == 1'b0;})
 end 
 `ovm_info(get_full_name(),$sformatf("\n completed fill_reg_q_np_npg \n"),OVM_LOW)

 fill_reg_q_p_pg();

 iosf_data_0 = new[1];
 iosf_data_0[0] = 32'hffffffff;
 foreach (reg_q_p_pg[i]) begin
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == reg_q_p_pg[i];iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
 end
 `ovm_info(get_full_name(),$sformatf("\n completed fill_reg_q_p_pg \n"),OVM_LOW)

 `ovm_do_with(error_status_chk_seq, {test_induced_urd==1'b0;test_induced_ced==1'b0;test_induced_ned==1'b0;test_induced_ur==1'b0;test_induced_anfes==1'b0;});
 `ovm_info(get_full_name(),$sformatf("\n completed eot_status_chk_seq after np/p traffic \n"),OVM_LOW)

 fill_reg_q_p_npg();

 iosf_data_0[0] = 32'h80000016;
 foreach (reg_q_p_npg[i]) begin
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == reg_q_p_npg[i];iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == reg_q_p_npg[i];})
    if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
       `ovm_error(get_full_name(),$sformatf(" write data 0x%h doesn't match read data 0x%h", iosf_data_0[0], iosf_base_seq.iosf_data_l[0]))
    iosf_data_0[0] = 32'h80000015;
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == reg_q_p_npg[i];iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
    `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == reg_q_p_npg[i];})
    if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
       `ovm_error(get_full_name(),$sformatf(" write data 0x%h doesn't match read data 0x%h", iosf_data_0[0], iosf_base_seq.iosf_data_l[0]))
 end
 `ovm_info(get_full_name(),$sformatf("\n completed fill_reg_q_p_npg \n"),OVM_LOW)

 //Attempt the enqueue at least 64 HCWs.
 i_opt_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg_opt_file_mode_seq");
 i_opt_file_mode_seq.set_cfg("HQM_SEQ_CFG", 1'b0);
 i_opt_file_mode_seq.start(get_sequencer());

 `ovm_info(get_full_name(),$sformatf("\n completed pre i_hqm_tb_cfg_opt_file_mode_seq \n"),OVM_LOW)
  set_hcw_exp_drop(1);
  i_hqm_cfg.sb_exp_errors.enq_hcw_q_not_empty = 0; 

  hcw_traffic_seq = hcw_perf_dir_ldb_test1_hcw_seq::type_id::create("hcw_perf_dir_ldb_test1_hcw_seq");
  hcw_traffic_seq.start(get_sequencer());
 //`ovm_do (hcw_traffic_seq)
 
 `ovm_info(get_full_name(),$sformatf("\n completed pre hcw_traffic_seq \n"),OVM_LOW)

 `ovm_do_with(error_status_chk_seq, {test_induced_urd==1'b0;test_induced_ced==1'b0;test_induced_ned==1'b0;test_induced_ur==1'b0;test_induced_anfes==1'b0;});
 `ovm_info(get_full_name(),$sformatf("\n completed eot_status_chk_seq after pre hcw traffic \n"),OVM_LOW)

 reset_tb("D3HOT");
 `ovm_info(get_full_name(),$sformatf("\n completed reset_tb \n"),OVM_LOW)

 // reset the power gated domain registers in ral mirror.
 ral.reset_regs("PMCSR_DISABLE","vcccfn_gated",0);
 `ovm_info(get_full_name(),$sformatf("\n completed ral_reset for power gated mmio registers \n"),OVM_LOW)

 WriteField("config_master","cfg_pm_pmcsr_disable","disable",1'b0);
 `ovm_info(get_full_name(),$sformatf("\n completed cfg_pm_pmcsr_disable \n"),OVM_LOW)
 
  wait_for_clk(6400);
 // Configure HQM
 // enqueue 64 HCWs and ensure 64 QEs are correctly scheduled.
 poll_rst_done(); 
 cfg_cmds.push_back("#mem_update");
 send_cmd();
 i_opt_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg_opt_file_mode_seq");
 i_opt_file_mode_seq.set_cfg("HQM_SEQ_CFG", 1'b0);
 i_opt_file_mode_seq.start(get_sequencer());
 `ovm_info(get_full_name(),$sformatf("\n completed post i_hqm_tb_cfg_opt_file_mode_seq \n"),OVM_LOW)
  set_hcw_exp_drop(0);
  i_hqm_cfg.sb_exp_errors.enq_hcw_q_not_empty = 1; 
 `ovm_do (hcw_traffic_seq)
 `ovm_info(get_full_name(),$sformatf("\n completed post hcw_traffic_seq \n"),OVM_LOW)

 `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_disable_test_seq ended \n"),OVM_LOW)
     
endtask : body
