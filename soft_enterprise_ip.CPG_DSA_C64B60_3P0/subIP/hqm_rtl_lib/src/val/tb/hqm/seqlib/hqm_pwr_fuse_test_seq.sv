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
// File   : hqm_pwr_fuse_test_seq.sv
// Author : rsshekha
// Description :
//
//   sequence to verify the fuse_proc_disable, fuse_force_on and cfg_pm_override
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_pwr_fuse_test_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_fuse_test_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_fuse_test_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sel_cold_reset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(check_thru_sb,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pm_override,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_fuse_test_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(sel_cold_reset)
    `stimulus_config_field_rand_int(check_thru_sb)
    `stimulus_config_field_rand_int(cfg_pm_override)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      sel_cold_reset;
  rand int                      check_thru_sb;
  rand int                      cfg_pm_override;
  constraint soft_sel_cold_reset { soft sel_cold_reset == 0;}       
  constraint soft_check_thru_sb  { soft check_thru_sb  == 0;}       
  constraint soft_cfg_pm_override { soft cfg_pm_override  == 0;}       

  function new(string name = "hqm_pwr_fuse_test_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_fuse_test_seq_stim_config

class hqm_pwr_fuse_test_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_fuse_test_seq)

  logic [63:0]          addr_dc, addr_cls, addr_cpc, addr_cps;
  bit [31:0]            hqm_fuse_values;
  bit [15:0]            hqm_fuse_values_rnd;
  string                fuse_string = "0x00000000", diff_fuse_string = "0x00000000";
  longint               lfuse_val, diff_lfuse_val;


  rand hqm_pwr_fuse_test_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_iosf_prim_base_seq                   iosf_base_seq;
  hqm_sla_pcie_eot_checks_sequence         error_status_chk_seq;
  hqm_reset_unit_sequence                  early_fuses_assert_seq;
  hqm_reset_init_sequence                  warm_rst_seq;
  hqm_cold_reset_sequence                  cold_rst_seq; 
  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq; 

  sla_ral_file          hqm_pf_cfg_i;
  sla_ral_reg           csr_bar_u, csr_bar_l;
  Iosf::data_t          iosf_data_0[],iosf_data_1[];

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_fuse_test_seq_stim_config);

  function new(string name = "hqm_pwr_fuse_test_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_fuse_test_seq_stim_config::type_id::create("hqm_pwr_fuse_test_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task get_addr_data();

endclass : hqm_pwr_fuse_test_seq

task hqm_pwr_fuse_test_seq::get_addr_data();
  
  if (!cfg.check_thru_sb) begin 
     addr_dc  = get_reg_addr("hqm_pf_cfg_i","device_command", "primary"); 
     addr_cls = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "primary"); 
     addr_cps = get_reg_addr("config_master","cfg_pm_status", "primary"); 
     addr_cpc = get_reg_addr("credit_hist_pipe","cfg_patch_control", "primary"); 
  end

  else begin 
     addr_dc  = get_reg_addr("hqm_pf_cfg_i","device_command", "sideband"); 
     addr_cls = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "sideband"); 
     addr_cps = get_reg_addr("config_master","cfg_pm_status", "sideband"); 
     addr_cpc = get_reg_addr("credit_hist_pipe","cfg_patch_control", "sideband"); 
  end 

  iosf_data_0 = new[1];
  iosf_data_1 = new[1];
  iosf_data_0[0] = 32'h0000000f;
  iosf_data_1[0] = 32'h00000039;

  hqm_pf_cfg_i      = ral.find_file("hqm_pf_cfg_i");
  csr_bar_u         = hqm_pf_cfg_i.find_reg("csr_bar_u");
  csr_bar_l         = hqm_pf_cfg_i.find_reg("csr_bar_l");
  csr_bar_u.set_actual(csr_bar_u.get()); 
  csr_bar_l.set_actual(csr_bar_l.get()); 

endtask: get_addr_data    

task hqm_pwr_fuse_test_seq::body();

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_fuse_test_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  get_addr_data();
  $value$plusargs("HQM_TB_FUSE_VALUES=%s",fuse_string);
  if (lvm_common_pkg::token_to_longint(fuse_string,lfuse_val) == 0) begin
    `ovm_error("hqm_pwr_fuse_pull_test_seq",$psprintf("+HQM_TB_FUSE_VALUES=%s not a valid integer value",fuse_string))
    return;
  end
  hqm_fuse_values = lfuse_val[31:0];

  `ovm_info(get_full_name(),$sformatf("\n +HQM_TB_FUSE_VALUES=0x%0x check cfg_pm_status.fuse_proc_disable and fuse_force_on\n", hqm_fuse_values),OVM_LOW)
  compare("config_master","cfg_pm_status","fuse_proc_disable",SLA_FALSE,hqm_fuse_values[0]);
  compare("config_master","cfg_pm_status","fuse_force_on",SLA_FALSE,hqm_fuse_values[1]);

  //-----------------------
  //--early_fuses asserted before side_rst_b
  //-----------------------
  $value$plusargs("HQM_TB_FUSE_VALUES_DIFF=%s",diff_fuse_string);
  if (lvm_common_pkg::token_to_longint(diff_fuse_string,diff_lfuse_val) == 0) begin
    `ovm_error("hqm_pwr_fuse_pull_test_seq",$psprintf("+HQM_TB_FUSE_VALUES_DIFF=%s not a valid integer value",diff_fuse_string))
    return;
  end
  hqm_fuse_values = diff_lfuse_val[31:0];
  //`ovm_info(get_full_name(),$sformatf("\n Calling early_fuses_assert_seq to load hqm_fuse_values=diff_lfuse_val 0x%0x\n",  hqm_fuse_values),OVM_LOW)
  //`ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::EARLY_FUSES_ASSERT; EarlyFuseIn_l==hqm_fuse_values;})

     
  //--reset
  if (!cfg.sel_cold_reset) begin 
     `ovm_info(get_full_name(),$sformatf("\n generating warm reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
     //`ovm_do(warm_rst_seq)
     `ovm_do_with(warm_rst_seq, {early_fuses_val == hqm_fuse_values; });
  end else begin
     `ovm_info(get_full_name(),$sformatf("\n generating cold reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
     //`ovm_do(cold_rst_seq)
     `ovm_do_with(cold_rst_seq, {early_fuses_val == hqm_fuse_values; });
  end
  ral.reset_regs();
  reset_tb(); // After D3hot scoreboard and prim_mon need to be reset


  //--after reset, issue early_fuses, should not be sampled by HQM
  hqm_fuse_values_rnd=$urandom_range (0, 16'hffff);
  `ovm_info(get_full_name(),$sformatf("\n Calling early_fuses_assert_seq to load hqm_fuse_values=diff_lfuse_val_rnd 0x%0x after reset (should not be sampled) \n",  hqm_fuse_values_rnd),OVM_LOW)
  `ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::EARLY_FUSES_ASSERT; EarlyFuseIn_l==hqm_fuse_values_rnd;})

  `ovm_info(get_full_name(),$sformatf("\n cfg.cfg_pm_override %d, cfg.sel_cold_reset %d, cfg.check_thru_sb %d, hqm_fuse_values 0x%0x\n", cfg.cfg_pm_override, cfg.sel_cold_reset, cfg.check_thru_sb, hqm_fuse_values),OVM_LOW)
  case (hqm_fuse_values[1:0])
      2'b00, 2'b10: begin 
           for (int i = 0; i < 2; i++) begin 
              `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
              `ovm_do(pcie_init)
              `ovm_info(get_full_name(),$sformatf("\n check cfg_pm_status.fuse_proc_disable fuse_force_on hqm_fuse_values=0x%0x = diff_lfuse_val=0x%0x in round=%0d  \n", hqm_fuse_values, diff_lfuse_val, i),OVM_LOW)
              compare("config_master","cfg_pm_status","fuse_proc_disable",SLA_FALSE,hqm_fuse_values[0]);
              compare("config_master","cfg_pm_status","fuse_force_on",SLA_FALSE,hqm_fuse_values[1]);
              get_addr_data();
              if (cfg.cfg_pm_override) begin 
                  WriteField("config_master","cfg_pm_override","override",1'b1);
                  compare("config_master","cfg_pm_override","override",SLA_FALSE,1'b1);
                  i = i + 1;
              end     
              if (!cfg.check_thru_sb) begin
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_cls;})
                  if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
                     `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0xf doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cpc;})
                  if (iosf_base_seq.iosf_data_l[0] != iosf_data_1[0])
                     `ovm_error(get_full_name(),$sformatf(" cfg_patch_control write data 0x39 doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
              end 
              else begin 
                 `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b00;exp_rsp == 1;})
                 `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_cplstatus == 2'b00;exp_rsp == 1;})
                 `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})
                 `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps;exp_cplstatus == 2'b00;exp_rsp == 1;})
                 `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc;wdata == iosf_data_1[0];})
                 `ovm_do_with(sb_mem_rd_seq, {addr == addr_cpc;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_1[0];})
              end
              if (cfg.cfg_pm_override || (i == 0)) begin
                  // Disable reporting of error since error is test induced and expected.
                  WriteField("hqm_pf_cfg_i","pcie_cap_device_control","fere",1'b0);
                  WriteField("hqm_pf_cfg_i","pcie_cap_device_control","cere",1'b0);
                  WriteField("hqm_pf_cfg_i","pcie_cap_device_control","nere",1'b0);
                  pmcsr_ps_cfg(`HQM_D3STATE);
                  // reset the power gated domain registers in ral mirror.
                  ral.reset_regs("D3HOT","vcccfn_gated",0);
                  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
                  if (!cfg.check_thru_sb) begin
                       `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;})
                       `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
                       `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_cls;})
                       if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
                          `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0xf doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
                       `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;iosf_exp_error_l == 1'b1;})
                       `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
                       `ovm_do_with(error_status_chk_seq, {test_induced_urd==1'b1;test_induced_ced==1'b1;test_induced_ned==1'b1;test_induced_ur==1'b1;test_induced_anfes==1'b1;}); 
                  end 
                  else begin 
                      `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b00;exp_rsp == 1;})
                      `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_cplstatus == 2'b00;exp_rsp == 1;})
                      `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})
                      `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps;exp_cplstatus == 2'b01;exp_rsp == 1;})
                      `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc;wdata == iosf_data_1[0];})
                  end     
                  pmcsr_ps_cfg(`HQM_D0STATE);
              end 
              if (i == 0) begin 
                 hqm_fuse_values = lfuse_val[31:0];
                 `ovm_info(get_full_name(),$sformatf("\n Calling reset_seq to load hqm_fuse_values=0x%0x = lfuse_val=0x%0x at end of round %0d before reset \n",  hqm_fuse_values, lfuse_val, i),OVM_LOW)
                 //`ovm_info(get_full_name(),$sformatf("\n Calling early_fuses_assert_seq to load hqm_fuse_values=0x%0x = lfuse_val=0x%0x at end of round %0d before reset \n",  hqm_fuse_values, lfuse_val, i),OVM_LOW)
                 //`ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::EARLY_FUSES_ASSERT; EarlyFuseIn_l==hqm_fuse_values;})

                 //--reset
                 if (!cfg.sel_cold_reset) begin 
                    `ovm_info(get_full_name(),$sformatf("\n generating warm reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
                    //`ovm_do(warm_rst_seq)
                    `ovm_do_with(warm_rst_seq, {early_fuses_val == hqm_fuse_values; });
                 end else begin
                    `ovm_info(get_full_name(),$sformatf("\n generating cold reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
                    //`ovm_do(cold_rst_seq)
                    `ovm_do_with(cold_rst_seq, {early_fuses_val == hqm_fuse_values; });
                 end


                 `ovm_info(get_full_name(),$sformatf("\n calling ral.reset_regs  \n"),OVM_LOW)
                 ral.reset_regs();
                 `ovm_info(get_full_name(),$sformatf("\n calling reset_tb  \n"),OVM_LOW)
                 reset_tb(); // After D3hot scoreboard and prim_mon need to be reset
                 //hqm_fuse_values = lfuse_val[31:0];
                 //--after reset, issue early_fuses, should not be sampled by HQM
                 hqm_fuse_values_rnd=$urandom_range (0, 16'hffff);
                 `ovm_info(get_full_name(),$sformatf("\n Calling early_fuses_assert_seq to load hqm_fuse_values=diff_lfuse_val_rnd 0x%0x after reset (should not be sampled) \n",  hqm_fuse_values_rnd),OVM_LOW)
                 `ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::EARLY_FUSES_ASSERT; EarlyFuseIn_l==hqm_fuse_values_rnd;})
              end
              `ovm_info(get_full_name(),$sformatf("\n index %d\n", i),OVM_LOW)
           end    
      end 
      2'b01,2'b11: begin
               get_addr_data();
               if (!cfg.check_thru_sb) begin
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;iosf_exp_error_l == 1'b1;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};iosf_exp_error_l == 1'b1;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;iosf_exp_error_l == 1'b1;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
              end 
              else begin 
                  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b01;exp_rsp == 1;})
                  `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_cplstatus == 2'b01;exp_rsp == 1;})
                  `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps;exp_cplstatus == 2'b01;exp_rsp == 1;})
                  `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc;wdata == iosf_data_1[0];})
              end     

              hqm_fuse_values = lfuse_val[31:0];
              `ovm_info(get_full_name(),$sformatf("\n Calling reset_seq to load hqm_fuse_values=0x%0x = lfuse_val=0x%0x before reset \n",  hqm_fuse_values, lfuse_val),OVM_LOW)
              //`ovm_info(get_full_name(),$sformatf("\n Calling early_fuses_assert_seq to load hqm_fuse_values=0x%0x = lfuse_val=0x%0x before reset \n",  hqm_fuse_values, lfuse_val),OVM_LOW)
              //`ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::EARLY_FUSES_ASSERT; EarlyFuseIn_l==hqm_fuse_values;})


              //--reset
              if (!cfg.sel_cold_reset) begin 
                 `ovm_info(get_full_name(),$sformatf("\n generating warm reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
                 //`ovm_do(warm_rst_seq)
                 `ovm_do_with(warm_rst_seq, {early_fuses_val == hqm_fuse_values; });
              end else begin
                 `ovm_info(get_full_name(),$sformatf("\n generating cold reset hqm_fuse_values=0x%0x \n", hqm_fuse_values),OVM_LOW)
                 //`ovm_do(cold_rst_seq)
                 `ovm_do_with(cold_rst_seq, {early_fuses_val == hqm_fuse_values; });
              end



               `ovm_info(get_full_name(),$sformatf("\n calling ral.reset_regs  \n"),OVM_LOW)
               ral.reset_regs();
               `ovm_info(get_full_name(),$sformatf("\n calling reset_tb  \n"),OVM_LOW)
               reset_tb(); // After D3hot scoreboard and prim_mon need to be reset
               `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
               `ovm_do(pcie_init)
               if (!cfg.check_thru_sb) begin  
                   if (!cfg.sel_cold_reset) begin  
                     `ovm_do_with(error_status_chk_seq, {test_induced_ur==1'b_1;test_induced_anfes==1'b_1;}); 
                   end       
               end       
               hqm_fuse_values = lfuse_val[31:0];
               compare("config_master","cfg_pm_status","fuse_proc_disable",SLA_FALSE,hqm_fuse_values);
               compare("config_master","cfg_pm_status","fuse_force_on",SLA_FALSE,hqm_fuse_values[1]);
               get_addr_data();
               if (!cfg.check_thru_sb) begin
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_cls;})
                  if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
                     `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0xf doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};})
                  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cpc;})
                  if (iosf_base_seq.iosf_data_l[0] != iosf_data_1[0])
                     `ovm_error(get_full_name(),$sformatf(" cfg_patch_control write data 0x39 doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
               end 
               else begin 
                  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b00;exp_rsp == 1;})
                  `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_cplstatus == 2'b00;exp_rsp == 1;})
                  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})
                  `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps;exp_cplstatus == 2'b00;exp_rsp == 1;})
                  `ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc;wdata == iosf_data_1[0];})
                  `ovm_do_with(sb_mem_rd_seq, {addr == addr_cpc;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_1[0];})
              end 
           end 
   endcase     

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_fuse_test_seq ended \n"),OVM_LOW)

endtask : body
