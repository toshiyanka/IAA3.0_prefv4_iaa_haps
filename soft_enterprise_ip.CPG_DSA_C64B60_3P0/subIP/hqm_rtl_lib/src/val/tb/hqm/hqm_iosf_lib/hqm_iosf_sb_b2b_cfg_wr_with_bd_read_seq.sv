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
// File   : hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config

class hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq,sla_sequencer)

  rand hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config        cfg;

  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config);

  function new(string name = "hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq");
    super.new(name); 
    cfg = hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config::type_id::create("hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction
  
  extern virtual task body();
endclass : hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq

task  hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq::body();

  Iosf::data_t          iosf_data_0[];
  bit [63:0]            addr_cls;
  int                   all_reg_read_complete = 0;
  int                   num_txns = 255;
  sla_ral_reg           cache_line_size_reg_h;
  sla_status_t          status;
  sla_ral_data_t        bd_cache_line_size, last_cache_line_size, exp_cache_line_size;

  apply_stim_config_overrides(1);
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq started \n"),OVM_LOW)
  
  addr_cls   = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "sideband"); 
  iosf_data_0    = new[1];
  fork
  begin  //thread to genenrate back2back cfg wrs wo waiting for completions    
     for (int i = 1; i < (num_txns + 1); i++) begin
        iosf_data_0[0] = i;
        `ovm_info(get_full_name(),$sformatf("\n sb_cfg_wr_seq addr_cls \n"),OVM_DEBUG)
        `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_rsp == 0;})
     end
  end
  begin  //thread to read registers to validate the cfg wrs
     exp_cache_line_size = 1;
     cache_line_size_reg_h = ral.find_reg_by_file_name("cache_line_size","hqm_pf_cfg_i");
     cache_line_size_reg_h.read_backdoor(status,last_cache_line_size,this);
     if (status == SLA_FAIL)
     begin 
         `ovm_error(get_full_name(),$sformatf("status for backdoor read of cache_lize_size is %s",status))
     end
     while (!all_reg_read_complete)
     begin 
         cache_line_size_reg_h.read_backdoor(status,bd_cache_line_size,this);
         if (status == SLA_FAIL)
         begin 
             `ovm_error(get_full_name(),$sformatf("status for backdoor read of cache_lize_size is %s",status))
             break;
         end
         else 
         begin
             if (bd_cache_line_size == last_cache_line_size) 
             begin 
                `ovm_info(get_full_name(),$sformatf("cache_line_size register value is not updated in rtl"),OVM_DEBUG)
             end
             else if (bd_cache_line_size == exp_cache_line_size) 
             begin 
                `ovm_info(get_full_name(),$sformatf("backdoor read for reg cache_line_size value %d match with expected value %d", bd_cache_line_size, exp_cache_line_size),OVM_LOW)
                exp_cache_line_size = exp_cache_line_size + 1;
                last_cache_line_size = bd_cache_line_size;
                if (bd_cache_line_size == num_txns) 
                begin
                    all_reg_read_complete = 1;
                end 
             end
             else
             begin
                `ovm_error(get_full_name(),$sformatf("backdoor read cache_line_size reg value %d mismatch with expected value %d", bd_cache_line_size, exp_cache_line_size))
             end 
         end 
         // wait for sometime, should be below the latency of cfg wr updates internally in rtl
         wait_for_ns(5);
     end 
  end 
  join 

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq ended \n"),OVM_LOW)

endtask : body
