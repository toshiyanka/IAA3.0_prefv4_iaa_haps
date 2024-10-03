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
// File   : hqm_pwr_base_seq.sv
// Author : rsshekha
//
// Description :
//
//    base pwr seq.
//
// -----------------------------------------------------------------------------
`define HQM_PWR_STIM_CLASS_FOR_SEQ_COMMON_CODE(seq_name, int_var) \
`include "stim_config_macros.svh" \
class seq_name``_stim_config extends ovm_object; \
  static string stim_cfg_name = "seq_name``_stim_config"; \
  `ovm_object_utils_begin(seq_name``_stim_config) \
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) \
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) \
    `ovm_field_int(int_var,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) \
  `ovm_object_utils_end \
  `stimulus_config_object_utils_begin(seq_name``_stim_config) \
    `stimulus_config_field_string(access_path) \
    `stimulus_config_field_string(tb_env_hier) \
    `stimulus_config_field_rand_int(int_var) \
  `stimulus_config_object_utils_end \
  sla_ral_access_path_t         access_path; \
  string                        tb_env_hier     = "*"; \
  rand int                      int_var; \
  constraint soft_``int_var { soft int_var == 0;} \
  function new(string name = "seq_name``_stim_config"); \
    super.new(name);  \
  endfunction \
endclass : seq_name``_stim_config

`define HQM_PWR_STIM_LIB_FUNC_NEW_COMMON_CODE(seq_name) \
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(seq_name``_stim_config); \
  function new(string name = "seq_name", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null); \
    super.new(name, sequencer, parent_seq); \
    cfg = seq_name``_stim_config::type_id::create("seq_name``_stim_config"); \
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type(); \
    apply_stim_config_overrides(0); \
  endfunction

`define HQM_PWR_SEQ_TASK_BODY_COMMON_CODE(seq_name) \
  `ovm_info(get_full_name(),$sformatf("\n seq_name started \n"),OVM_LOW) \
  apply_stim_config_overrides(1); \
  ral_access_path = cfg.access_path; \
  base_tb_env_hier = cfg.tb_env_hier; 

import hcw_transaction_pkg::*;

class hqm_pwr_base_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_pwr_base_seq, sla_sequencer)

  static int i_idx,j_idx;
  string skip_regs_q[$];
  sla_ral_env                   ral;
  sla_ral_access_path_t         ral_access_path;
  hqm_tb_env                    hqm_env;
  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  hqm_iosf_prim_mon             i_hqm_iosf_prim_mon_obj;
  hqm_pp_cq_status              i_hqm_pp_cq_status;     
  hqm_iosf_prim_checker         i_hqm_iosf_prim_checker_obj;
  virtual hqm_misc_if           pins;
  string                        base_tb_env_hier     = "*";

  string mode = "skip";
  int prochot = 0;
  string pwr_seq;
  integer pmcsr_dly = 2000;

  function new(string name = "hqm_pwr_base_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 
    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_LOW) 
    `sla_assert( $cast(pins, hqm_env.pins),  (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_LOW)   
    ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();

    if (!$value$plusargs("HQM_PROCHOT_INIT_VAL=%b",prochot)) begin  
        prochot = 1'b0;
    end 
    if (!$value$plusargs("HQM_PH_MODE=%s",mode)) begin 
        mode = "skip";
    end     
    if (!$value$plusargs("HQM_PWR_SEQ=%s",pwr_seq)) begin
        pwr_seq = "HQM_D0_TO_D3HOT_TO_D0";
    end     
    if (!$value$plusargs("HQM_PMCSR_WAIT_DELAY=%d",pmcsr_dly)) begin
        pmcsr_dly = 2000;
    end     
  endfunction

  extern virtual task body();


  extern virtual task WriteReg( string          file_name,
                                string          reg_name,
                                sla_ral_data_t  wr_data
                              );


  extern virtual task WriteField( string                file_name,
                                  string                reg_name,
                                  string                field_name,
                                  sla_ral_data_t        wr_data
                                );

  extern virtual task ReadReg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );

  extern virtual task ReadField( string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 output  sla_ral_data_t rd_data
                                );

  extern virtual task poll(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);


  extern virtual task compare(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);

  extern virtual task read_and_check_reg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );

  extern virtual task compare_rtl_against_mirror(input string        powerwell,
                                                 boolean_t                exp_error,
                                                 ref sla_ral_field fields[$]
                                 );

  extern virtual task update_mirror_val ();                               

  extern virtual task check_pcie_cfg_space ();                               

  extern virtual task check_power_reg ();                               

  extern virtual task check_alwayson_mmio_cfg_space();                               

  extern virtual task check_powergated_mmio_cfg_space();

  extern virtual task pmcsr_ps_cfg(input int pmcsr_ps);

  extern virtual function reset_tb(string reset_type = "COLD_RESET");

  extern virtual task poll_rst_done();                               

  virtual task wait_for_clk(int number=10);
   repeat(number) begin @(sla_tb_env::sys_clk_r); end
  endtask

  virtual task wait_for_ns(integer number=2000);
    integer var_i = 0;
    while (var_i < number) // wait for 2000ns 
    begin 
      #1ns; 
      var_i = var_i + 1;
    end 
  endtask

  extern virtual task wr_inverse (input string file_name);

  extern virtual task compare_regs(input string file_name);

  extern virtual function void skip_regs_by_name (input string pattern, input string file_name);

  extern virtual function logic [63:0] get_reg_addr (input string file_name, input string reg_name, input string access_path);  

endclass : hqm_pwr_base_seq

task hqm_pwr_base_seq::body();
endtask : body

function logic [63:0]  hqm_pwr_base_seq::get_reg_addr (input string file_name, input string reg_name, input string access_path);

    logic [63:0] addr;

    sla_ral_file file_handle;
    sla_ral_reg  reg_handle;

    file_handle      = ral.find_file(file_name);

    if (file_handle == null) begin
      `ovm_error(get_full_name(),{"hqm_pwr_base_seq::get_reg_addr unable to get handle to RAL file"})
      return (0);
    end

    reg_handle     = file_handle.find_reg(reg_name);

    if (reg_handle == null) begin
      `ovm_error(get_full_name(),{"hqm_pwr_base_seq::get_reg_addr unable to get handle to RAL reg"})
      return (0);
    end
    
    if (access_path == "primary") begin 
        addr  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),reg_handle); 
    end 
    
    else if (access_path == "sideband") begin 
        addr  = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(),reg_handle); 
    end 

    return (addr);

endfunction: get_reg_addr

function hqm_pwr_base_seq::reset_tb(string reset_type = "COLD_RESET");
  ovm_object sb_tmp, prim_mon_tmp, pp_cq_status_tmp, prim_checker_tmp;
  //-----------------------------
  //-- get i_hcw_scoreboard
  //-----------------------------
  if (!p_sequencer.get_config_object("i_hcw_scoreboard", sb_tmp)) begin
     ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
  end

  if (!$cast(i_hcw_scoreboard, sb_tmp)) begin
    ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", sb_tmp.sprint(), i_hcw_scoreboard.sprint()));
  end else begin
    ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_LOW);
  end

  if (p_sequencer.get_config_object("i_hqm_iosf_prim_mon", prim_mon_tmp,0))  begin
      $cast(i_hqm_iosf_prim_mon_obj, prim_mon_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object hqm_iosf_prim_mon_obj");
  end

  if (p_sequencer.get_config_object("i_hqm_pp_cq_status",pp_cq_status_tmp,0)) begin
      $cast(i_hqm_pp_cq_status,pp_cq_status_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_pp_cq_status");
  end
  if (p_sequencer.get_config_object("i_hqm_iosf_prim_checker", prim_checker_tmp,0))  begin
      $cast(i_hqm_iosf_prim_checker_obj, prim_checker_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_iosf_prim_checker_obj");
  end
     //CQ_reset
  i_hqm_iosf_prim_mon_obj.cq_gen_reset(); 
  i_hcw_scoreboard.hcw_scoreboard_reset();
  i_hqm_pp_cq_status.reset();
  // -- Reset transaction Qs -- //
  if (reset_type == "D3HOT") begin
     `ovm_info(get_full_name(),$sformatf("\n skipped hqm_iosf_prim_checker reset \n"),OVM_LOW)
  end
  else begin 
     i_hqm_iosf_prim_checker_obj.reset_txnid_q(); 
     i_hqm_iosf_prim_checker_obj.reset_ep_bus_num_q(); 
     i_hqm_iosf_prim_checker_obj.reset_func_flr_status(); 
  end    
  ovm_report_info(get_full_name(), $psprintf("reset_tb completed"), OVM_LOW);
endfunction: reset_tb

function void hqm_pwr_base_seq::skip_regs_by_name (input string pattern, input string file_name);
     sla_ral_file          ral_file;
     sla_ral_reg           ral_regs[$];

     ral_file = ral.find_file({base_tb_env_hier, file_name});
     if (ral_file == null) begin
       `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
       return;
     end
     ral_file.get_regs(ral_regs);
     foreach(ral_regs[i]) begin 
        if(ovm_is_match(pattern.toupper(), ral_regs[i].get_name() )) begin 
          skip_regs_q.push_back(ral_regs[i].get_name());
        end    
     end       
     `ovm_info(get_full_name(),$sformatf("skip_regs_q size = %d",skip_regs_q.size()),OVM_LOW)
     return;
endfunction: skip_regs_by_name

task hqm_pwr_base_seq::pmcsr_ps_cfg(input int pmcsr_ps);
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_ps_cfg_task started \n"),OVM_LOW)
  // 0. [SW]  write PMCSR.PowerState = 2'd0;
  WriteField("hqm_pf_cfg_i","pm_cap_control_status","ps",pmcsr_ps);
  if (pwr_seq == "HQM_NSR_SEQ") begin // the seq waits 
     wait_for_ns(pmcsr_dly); //#2us;
  end     
  else if ((mode == "skip") && (prochot == 0)) begin     
     wait_for_ns((pmcsr_dly*8)); //#16us;
  end
  else begin //prochot == 1  
     wait_for_ns((pmcsr_dly*8*9)); //#0.13ms;
  end     
  //PCIE spec says the software should wait for 10ms. keeping it 8000ns to reduce simulation time; 
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_ps_cfg_task ended \n"),OVM_LOW)
endtask : pmcsr_ps_cfg

task hqm_pwr_base_seq::check_powergated_mmio_cfg_space();
    string ref_name;
    sla_ral_data_t   rd_data;
   `ovm_info(get_full_name(),$sformatf("\n check_powergated_mmio_cfg_space started \n"),OVM_LOW)
    poll("config_master","cfg_pm_status","pgcb_hqm_idle",SLA_FALSE,1'b1);

    $sformat(ref_name,"vector_ctrl[%0d]",j_idx);
    `ovm_info(get_full_name(),$sformatf("vector_ctrl[j_idx] = %s",ref_name),OVM_LOW)
    read_and_check_reg("hqm_msix_mem",ref_name,SLA_FALSE,rd_data);
    read_and_check_reg("hqm_system_csr","total_ldb_ports",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_system_csr","total_dir_ports",SLA_FALSE,rd_data);
    read_and_check_reg("list_sel_pipe","cfg_patch_control",SLA_FALSE,rd_data);
    read_and_check_reg("direct_pipe","cfg_unit_timeout",SLA_FALSE,rd_data);
    read_and_check_reg("nalb_pipe","cfg_interface_status",SLA_FALSE,rd_data);
    read_and_check_reg("atm_pipe","cfg_unit_version",SLA_FALSE,rd_data);
    read_and_check_reg("aqed_pipe","cfg_control_pipeline_credits",SLA_FALSE,rd_data);
    read_and_check_reg("reorder_pipe","cfg_rop_csr_control",SLA_FALSE,rd_data);
    $sformat(ref_name,"cfg_dir_cq_depth[%0d]",j_idx);
    `ovm_info(get_full_name(),$sformatf("cfg_dir_cq_depth[j_idx] = %s",ref_name),OVM_LOW)
    read_and_check_reg("credit_hist_pipe",ref_name,SLA_FALSE,rd_data);
   `ovm_info(get_full_name(),$sformatf("\n check_powergated_mmio_cfg_space ended \n"),OVM_LOW)
endtask :check_powergated_mmio_cfg_space 

task hqm_pwr_base_seq::check_alwayson_mmio_cfg_space();
    sla_ral_data_t   rd_data;
    read_and_check_reg("hqm_sif_csr","hqm_csr_cp_lo",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_sif_csr","hqm_csr_cp_hi",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_sif_csr","side_cdc_ctl",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_sif_csr","prim_cdc_ctl",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_pm_override",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_pm_pmcsr_disable",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_master_ctl",SLA_FALSE,rd_data);
endtask : check_alwayson_mmio_cfg_space

task hqm_pwr_base_seq::wr_inverse( input string file_name);
  sla_ral_file          ral_file;
  sla_ral_data_t        rd_data;
  sla_ral_data_t        wr_data;
  sla_ral_reg           ral_regs[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_file.get_regs(ral_regs);

  foreach(ral_regs[reg_name]) begin
     `ovm_info(get_full_name(),$sformatf("Entered for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     if(ral_regs[reg_name].get_test_reg() == 0) begin
        continue;
     end
     if(ral_regs[reg_name].get_name() inside {skip_regs_q}) begin 
        `ovm_info(get_full_name(),$sformatf("wr_inverse skipped for register %s",ral_regs[reg_name].get_name()),OVM_LOW)
        continue;
     end
     ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
     `ovm_info(get_full_name(),$sformatf("generating read for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     ReadReg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data);
     wr_data = ~rd_data;
     `ovm_info(get_full_name(),$sformatf("generating write for register %s, rd data %h, wr_data %h",ral_regs[reg_name].get_name(), rd_data, wr_data),OVM_DEBUG)
     WriteReg(ral_file.get_name(),ral_regs[reg_name].get_name(),wr_data);
     `ovm_info(get_full_name(),$sformatf("generating read for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     read_and_check_reg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data); 
     `ovm_info(get_full_name(),$sformatf("generated read_and_check for register %s, rd data %h, wr_data %h",ral_regs[reg_name].get_name(), rd_data, wr_data),OVM_DEBUG)
  end

endtask : wr_inverse

task hqm_pwr_base_seq::compare_regs(input string file_name);
  sla_ral_file          ral_file;
  sla_ral_reg           ral_regs[$];
  sla_ral_data_t        rd_data;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_file.get_regs(ral_regs);

  foreach(ral_regs[reg_name]) begin
     if(ral_regs[reg_name].get_test_reg() == 0) begin
        continue;
     end
     ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
     read_and_check_reg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data); 
  end

endtask : compare_regs

task hqm_pwr_base_seq::read_and_check_reg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read_and_check(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : read_and_check_reg

task hqm_pwr_base_seq::check_power_reg();
    sla_ral_data_t   rd_data;
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_id",SLA_FALSE,rd_data); 
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_next_cap_ptr",SLA_FALSE,rd_data); 
    read_and_check_reg("hqm_pf_cfg_i","pm_cap",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_control_status",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_clk_on_cnt_l",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_clk_on_cnt_h",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_proc_on_cnt_l",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_proc_on_cnt_h",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_prochot_cnt_l",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_prochot_cnt_h",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_prochot_event_cnt_l",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_prochot_event_cnt_h",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_d3tod0_event_cnt_h",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_d3tod0_event_cnt_l",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_clk_cnt_disable",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_pm_override",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_pm_status",SLA_FALSE,rd_data);
    //read_and_check_reg("config_master","cfg_hqm_pgcb_cdc_lock",SLA_FALSE,rd_data); // doesn't exist now, 30/08/2018
    read_and_check_reg("config_master","cfg_hqm_pgcb_control",SLA_FALSE,rd_data);
    read_and_check_reg("config_master","cfg_hqm_cdc_control",SLA_FALSE,rd_data);
endtask : check_power_reg 

task hqm_pwr_base_seq::check_pcie_cfg_space();
    sla_ral_data_t   rd_data;
    read_and_check_reg("hqm_pf_cfg_i","device_command",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","device_status",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","func_bar_l",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","func_bar_u",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","csr_bar_l",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","csr_bar_u",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","msix_cap_control",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pcie_cap_device_cap",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pcie_cap_device_control",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pcie_cap_device_status",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_id",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pm_cap",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_next_cap_ptr",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pm_cap_control_status",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","acs_cap_control",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pasid_cap_id",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","pasid_control",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","aer_cap_control",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","aer_cap_uncorr_err_status",SLA_FALSE,rd_data);
    read_and_check_reg("hqm_pf_cfg_i","aer_cap_corr_err_status",SLA_FALSE,rd_data);
endtask : check_pcie_cfg_space

task hqm_pwr_base_seq::update_mirror_val();
    string ref_name;
    sla_ral_data_t   rd_data;
    `ovm_info(get_full_name(),$sformatf("\n update_mirror_val started \n"),OVM_LOW)
//--------------- Pcie config space ---------------------------//     
    ReadReg("hqm_pf_cfg_i","device_command",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","device_status",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","func_bar_l",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","func_bar_u",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","csr_bar_l",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","csr_bar_u",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","msix_cap_control",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pcie_cap_device_cap",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pcie_cap_device_control",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pcie_cap_device_status",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pm_cap_id",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pm_cap",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pm_cap_next_cap_ptr",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pm_cap_control_status",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","acs_cap_control",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pasid_cap_id",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","pasid_control",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","aer_cap_control",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","aer_cap_uncorr_err_status",SLA_FALSE,rd_data);
    ReadReg("hqm_pf_cfg_i","aer_cap_corr_err_status",SLA_FALSE,rd_data);
//--------------- MMIO ---------------------------//     
    i_idx = $urandom_range(0,15);
    ReadReg("hqm_sif_csr","hqm_csr_cp_lo",SLA_FALSE,rd_data); // NPG
    ReadReg("hqm_sif_csr","hqm_csr_cp_hi",SLA_FALSE,rd_data); // NPG 
    ReadReg("hqm_sif_csr","side_cdc_ctl",SLA_FALSE,rd_data); //NPG
    ReadReg("hqm_sif_csr","prim_cdc_ctl",SLA_FALSE,rd_data); //NPG
    ReadReg("config_master","cfg_pm_override",SLA_FALSE,rd_data); //NPG 
    ReadReg("config_master","cfg_pm_pmcsr_disable",SLA_FALSE,rd_data); //NPG 
    ReadReg("config_master","cfg_master_ctl",SLA_FALSE,rd_data); //NPG
//--------------- Power gated registers  ---------------------------//     
    j_idx = $urandom_range(0,63);
    $sformat(ref_name,"vector_ctrl[%0d]",j_idx);
    `ovm_info(get_full_name(),$sformatf("vector_ctrl[j_idx] = %s",ref_name),OVM_LOW)
    ReadReg("hqm_msix_mem",ref_name,SLA_FALSE,rd_data); //PG
    ReadReg("hqm_system_csr","total_ldb_ports",SLA_FALSE,rd_data);
    ReadReg("hqm_system_csr","total_dir_ports",SLA_FALSE,rd_data);
    ReadReg("list_sel_pipe","cfg_patch_control",SLA_FALSE,rd_data);
    ReadReg("direct_pipe","cfg_unit_timeout",SLA_FALSE,rd_data);
    ReadReg("nalb_pipe","cfg_interface_status",SLA_FALSE,rd_data);
    ReadReg("atm_pipe","cfg_unit_version",SLA_FALSE,rd_data);
    ReadReg("aqed_pipe","cfg_control_pipeline_credits",SLA_FALSE,rd_data);
    ReadReg("reorder_pipe","cfg_rop_csr_control",SLA_FALSE,rd_data);
    $sformat(ref_name,"cfg_dir_cq_depth[%0d]",j_idx);
    `ovm_info(get_full_name(),$sformatf("cfg_dir_cq_depth[j_idx] = %s",ref_name),OVM_LOW)
    ReadReg("credit_hist_pipe",ref_name,SLA_FALSE,rd_data);
    `ovm_info(get_full_name(),$sformatf("\n update_mirror_val ended \n"),OVM_LOW)
endtask : update_mirror_val

task hqm_pwr_base_seq::compare_rtl_against_mirror ( string        powerwell,
                                                    boolean_t                exp_error,
                                                    ref sla_ral_field fields[$]
                                     );
  string fname[$];
  string fname_upper;
  sla_status_t          status;
  sla_ral_data_t        rd_val[$];
  sla_ral_sai_t         legal_sai;
  sla_ral_file my_files[$];
  sla_ral_reg  my_regs[$];
  sla_ral_field my_fields[$];
  ral.get_reg_files(my_files, ral);
  if (my_files.size() == 0)
    `ovm_error(get_full_name(),$sformatf(" my_files size is zero %d", my_files.size()))
  foreach (my_files[i]) begin  
     `ovm_info(get_full_name(),$sformatf("files[%0d]=%s",i,my_files[i].get_name()),OVM_MEDIUM)
     my_files[i].get_regs(my_regs);
    if (my_regs.size() == 0)
       `ovm_error(get_full_name(),$sformatf(" my_regs size is zero %d", my_regs.size()))
     foreach (my_regs[i]) begin
         `ovm_info(get_full_name(),$sformatf("regs[%0d]=%s",i,my_regs[i].get_name()),OVM_MEDIUM)
         my_regs[i].get_fields(my_fields);
         legal_sai     = my_regs[i].pick_legal_sai_value(RAL_READ);
         if (my_fields.size() == 0)
            `ovm_error(get_full_name(),$sformatf(" my_fields size is zero %d", my_fields.size()))
         foreach (my_fields[i]) begin 
            `ovm_info(get_full_name(),$sformatf("fields[%0d]=%s, powerwell %s",i,my_fields[i].get_name(),my_fields[i].get_powerwell()),OVM_MEDIUM)
            if (my_fields[i].get_powerwell() == powerwell) begin
                fields.push_back(my_fields[i]);
                fname_upper = my_fields[i].get_name();
                fname.push_back(fname_upper.toupper());
            end
         end
         my_regs[i].read_and_check_fields(status,fname,rd_val,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
         if (status == SLA_OK)
            `ovm_info(get_full_name(),$sformatf("status= %s",status),OVM_MEDIUM)
         else    
            `ovm_error(get_full_name(),$sformatf("read_and_check_fields: status= %s",status))
     end 
  end
endtask : compare_rtl_against_mirror

task hqm_pwr_base_seq::poll  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name.toupper());
  exp_vals.push_back(exp_data);

  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_TRUE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : poll

task hqm_pwr_base_seq::WriteReg( string               file_name,
                                      string               reg_name,
                                      sla_ral_data_t       wr_data
                                    );
  sla_ral_file      ral_file;
  sla_ral_reg       ral_reg;
  sla_status_t      status;
  sla_ral_sai_t     legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  ral_reg.write(status,wr_data,ral_access_path,this,.sai(legal_sai));
endtask : WriteReg

task hqm_pwr_base_seq::WriteField( string          file_name,
                                        string          reg_name,
                                        string          field_name,
                                        sla_ral_data_t  wr_data
                                      );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  string                field_names[$];
  sla_ral_data_t        field_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  field_names.delete();
  field_vals.delete();

  field_name = field_name.toupper();
  field_names.push_back(field_name);
  field_vals.push_back(wr_data);

  ral_reg.write_fields(status,field_names,field_vals,ral_access_path,this,.sai(legal_sai));
endtask : WriteField

task hqm_pwr_base_seq::ReadReg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : ReadReg

task hqm_pwr_base_seq::ReadField( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       output   sla_ral_data_t  rd_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        reg_val;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,reg_val,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));

  rd_data = ral_field.get_val(reg_val);
endtask : ReadField

task hqm_pwr_base_seq::compare  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name.toupper());
  exp_vals.push_back(exp_data);

  `ovm_info(get_full_name(),$sformatf("\n status = %s, ral_access_path = %s, legal_sai = %h, exp_error = %b", status, ral_access_path, legal_sai, exp_error),OVM_LOW)
  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_FALSE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : compare

task hqm_pwr_base_seq::poll_rst_done();
  `ovm_info(get_full_name(),$sformatf(" poll_rst_done:Started "),OVM_LOW)
       poll("config_master","CFG_DIAGNOSTIC_RESET_STATUS","HQM_PROC_RESET_DONE", SLA_FALSE, 1'b1);
  `ovm_info(get_full_name(),$sformatf(" poll_rst_done:Done"),OVM_MEDIUM)
endtask: poll_rst_done
