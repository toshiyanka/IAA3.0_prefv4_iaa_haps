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
// File   : hqm_pwr_iosf_transactions_in_D3hot_seq.sv
// Author : rsshekha
// Description :
//
//   sequence to verify the iosf compliance in D3 hot state. 
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config

class hqm_pwr_iosf_transactions_in_D3hot_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_iosf_transactions_in_D3hot_seq)

  logic [63:0]          addr_dc, addr_cls, addr_cpc, addr_cps, addr_dc_sb, addr_cls_sb, addr_cpc_sb, addr_cps_sb;

  rand hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_iosf_prim_base_seq                   iosf_base_seq;
  hqm_sla_pcie_eot_checks_sequence         error_status_chk_seq;
  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq; 
  hqm_reset_unit_sequence                  prim_rst_seq;
  hqm_reset_unit_sequence                  prim_side_rst_seq;
  hqm_reset_init_sequence                  warm_reset_seq;

  sla_ral_file          hqm_pf_cfg_i;
  sla_ral_reg           csr_bar_u, csr_bar_l;
  Iosf::data_t          iosf_data_0[],iosf_data_1[],iosf_data_2[],iosf_data_3[];

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config);

  function new(string name = "hqm_pwr_iosf_transactions_in_D3hot_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config::type_id::create("hqm_pwr_iosf_transactions_in_D3hot_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task get_addr_data();

  extern virtual task drive_transactions(string interface_type = "sb_prim", string txns_type = "cfg_mem", string device_state = "D0act");

endclass : hqm_pwr_iosf_transactions_in_D3hot_seq

task hqm_pwr_iosf_transactions_in_D3hot_seq::drive_transactions(string interface_type = "sb_prim", string txns_type = "cfg_mem", string device_state = "D0act");

  if (((txns_type == "cfg") || (txns_type == "cfg_mem")) && ((interface_type == "sb_prim") || (interface_type == "prim"))) begin 
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;})
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_cls;})
     if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
        `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0xf doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
  end       
  if (((txns_type == "mem") || (txns_type == "cfg_mem")) && ((interface_type == "sb_prim") || (interface_type == "prim")) && (device_state == "D0act")) begin 
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;})
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cpc;})
     if (iosf_base_seq.iosf_data_l[0] != iosf_data_1[0])
        `ovm_error(get_full_name(),$sformatf(" cfg_patch_control write data 0x39 doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
  end       
  if (((txns_type == "cfg") || (txns_type == "cfg_mem")) && ((interface_type == "sb_prim") || (interface_type == "sb"))) begin 
     `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})
     `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls_sb;wdata == iosf_data_0[0];exp_cplstatus == 2'b00;exp_rsp == 1;})
     `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})
  end       
  if (((txns_type == "mem") || (txns_type == "cfg_mem")) && ((interface_type == "sb_prim") || (interface_type == "sb")) && (device_state == "D0act")) begin 
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})
     `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc_sb;wdata == iosf_data_1[0];})
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cpc_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_1[0];})
  end 
  if ((txns_type == "mem") && ((interface_type == "sb_prim") || (interface_type == "prim")) && (device_state == "D3hot")) begin 
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;iosf_exp_error_l == 1'b1;})
     `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
     `ovm_do_with(error_status_chk_seq, {test_induced_urd==1'b1;test_induced_ced==1'b1;test_induced_ned==1'b1;test_induced_ur==1'b1;test_induced_anfes==1'b1;}); 
  end 
  if ((txns_type == "mem") && ((interface_type == "sb_prim") || (interface_type == "sb")) && (device_state == "D3hot")) begin 
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps_sb;exp_cplstatus == 2'b01;exp_rsp == 1;})
     `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc_sb;wdata == iosf_data_1[0];})
  end 
endtask: drive_transactions   

task hqm_pwr_iosf_transactions_in_D3hot_seq::get_addr_data();
  
  sla_ral_data_t        rd_data;
  addr_dc  = get_reg_addr("hqm_pf_cfg_i","device_command", "primary"); 
  addr_cls = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "primary"); 
  addr_cps = get_reg_addr("config_master","cfg_pm_status", "primary"); 
  addr_cpc = get_reg_addr("credit_hist_pipe","cfg_patch_control", "primary"); 
  addr_dc_sb  = get_reg_addr("hqm_pf_cfg_i","device_command", "sideband"); 
  addr_cls_sb = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "sideband"); 
  addr_cps_sb = get_reg_addr("config_master","cfg_pm_status", "sideband"); 
  addr_cpc_sb = get_reg_addr("credit_hist_pipe","cfg_patch_control", "sideband"); 

  iosf_data_0 = new[1];
  iosf_data_1 = new[1];
  iosf_data_2 = new[1];
  iosf_data_3 = new[1];
  iosf_data_0[0] = 32'h0000000f;
  iosf_data_1[0] = 32'h00000039;

  ReadReg("hqm_pf_cfg_i","cache_line_size",SLA_FALSE,rd_data);
  iosf_data_2[0] = ~rd_data[31:0];// non default data to be written on cache line size 
  iosf_data_3[0] = rd_data[31:0];// default value of cls to check that it didn't effected the transaction

  hqm_pf_cfg_i      = ral.find_file("hqm_pf_cfg_i");
  csr_bar_u         = hqm_pf_cfg_i.find_reg("csr_bar_u");
  csr_bar_l         = hqm_pf_cfg_i.find_reg("csr_bar_l");
  csr_bar_u.set_actual(csr_bar_u.get()); 
  csr_bar_l.set_actual(csr_bar_l.get()); 

endtask: get_addr_data    

task hqm_pwr_iosf_transactions_in_D3hot_seq::body();

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_iosf_transactions_in_D3hot_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  get_addr_data();
  `ovm_info(get_type_name(),"Completed get_addr_data", OVM_LOW);

  // Generate sideband and primary transactions;
  drive_transactions("sb_prim","cfg_mem","Doact");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions", OVM_LOW);

  // Program hqm to D3 hot; 
  pmcsr_ps_cfg(`HQM_D3STATE);
  `ovm_info(get_type_name(),"Completed D3hot", OVM_LOW);

  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  `ovm_info(get_type_name(),"Completed tb reset", OVM_LOW);

  // Generate sideband and primary transactions for config space;
  drive_transactions("sb_prim","cfg","D3hot");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions cfg", OVM_LOW);

  // Generate sideband and primary transactions for mem space and expect UR;
  drive_transactions("sb_prim","mem","D3hot");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions mem in d3hot", OVM_LOW);

  // set severity for ecrcc errors as fatal
  WriteField("hqm_pf_cfg_i","aer_cap_uncorr_err_sev","ecrcc",1'b1);

  // Generate primary cmd parity error;
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_2[i]) {iosf_data_l[i]==iosf_data_2[i]};drivecmdparityerr_l == 1'b1;iosf_wait_for_completion_l==0;})
  `ovm_info(get_type_name(),"Completed primary cmd parity err transaction", OVM_LOW);

  // See the transaction have not effected the register;
  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})
  `ovm_info(get_type_name(),"Completed check for cmd parity err transaction", OVM_LOW);

  // sideband working correctly;
  drive_transactions("sb","cfg","D3hot");
  `ovm_info(get_type_name(),"Completed sideband transactions cfg", OVM_LOW);

  // generate prim_rst and pcie_init; 
  //`ovm_info(get_type_name(),"Starting prim_rst_seq", OVM_LOW);
  //`ovm_do_on_with(prim_rst_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_RESET_ASSERT;}); 
  //`ovm_info(get_type_name(),"Completed PRIM_RESET_ASSERT", OVM_LOW);
  //`ovm_do_on_with(prim_rst_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_RESET_DEASSERT;}); 
  //`ovm_info(get_type_name(),"Completed PRIM_RESET_DEASSERT", OVM_LOW);
  `ovm_do(warm_reset_seq)

  `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
  `ovm_do(pcie_init)

  get_addr_data();
  `ovm_info(get_type_name(),"Completed get_addr_data", OVM_LOW);

  // check that ecrc bit is set in aer_uncorr_err_status register
   `ovm_do_with(error_status_chk_seq, {test_induced_ecrcc == 1'b1;});

  // Program hqm to D3 hot; 
  pmcsr_ps_cfg(`HQM_D3STATE);
  `ovm_info(get_type_name(),"Completed D3hot", OVM_LOW);

  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  `ovm_info(get_type_name(),"Completed tb reset", OVM_LOW);

  // Generate sideband and primary transactions for config space;
  drive_transactions("sb_prim","cfg","D3hot");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions cfg", OVM_LOW);

  // Generate sideband and primary transactions for mem space and expect UR;
  drive_transactions("sb_prim","mem","D3hot");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions mem in d3hot", OVM_LOW);

  // Generate sideband cmd parity error;
  `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls_sb;wdata == iosf_data_2[0];exp_cplstatus == 2'b00;exp_rsp == 0;en_parity_err == 1'b1;})
  `ovm_info(get_type_name(),"Completed sideband cmd parity err transaction", OVM_LOW);

  wait_for_clk(300);

  // generate prim_rst and pcie_init; 
  //`ovm_info(get_type_name(),"Starting prim_side_rst_seq", OVM_LOW);
  //`ovm_do_on_with(prim_side_rst_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_RESET_ASSERT;}); 
  //`ovm_info(get_type_name(),"Completed PRIM_SIDE_RESET_ASSERT", OVM_LOW);
  //`ovm_do_on_with(prim_side_rst_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_RESET_DEASSERT;}); 
  //`ovm_info(get_type_name(),"Completed PRIM_SIDE_RESET_DEASSERT", OVM_LOW);

  `ovm_do(warm_reset_seq)

  `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
  `ovm_do(pcie_init)

  get_addr_data();
  `ovm_info(get_type_name(),"Completed get_addr_data", OVM_LOW);

  // See the transaction have not effected the register;
  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_3[0];})
  `ovm_info(get_type_name(),"Completed check for cmd parity err transaction", OVM_LOW);

  // sideband and primary working correctly;
  drive_transactions("sb_prim","cfg_mem","Doact");
  `ovm_info(get_type_name(),"Completed sideband and primary transactions", OVM_LOW);

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_iosf_transactions_in_D3hot_seq ended \n"),OVM_LOW)

endtask : body
