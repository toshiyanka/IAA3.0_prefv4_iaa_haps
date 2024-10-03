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
// File   : back2back_cfgrd_seq.sv
// Author :araghuw 
// Description :
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class back2back_cfgrd_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "back2back_cfgrd_seq_stim_config";

  `ovm_object_utils_begin(back2back_cfgrd_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(back2back_cfgrd_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "back2back_cfgrd_seq_stim_config");
    super.new(name); 
  endfunction
endclass : back2back_cfgrd_seq_stim_config

class back2back_cfgrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgrd_seq,sla_sequencer)

  rand back2back_cfgrd_seq_stim_config                cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_rqid_seq   cfg_read_rqid_seq;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(back2back_cfgrd_seq_stim_config);

  function new(string name = "back2back_cfgrd_seq");
    super.new(name); 
    cfg = back2back_cfgrd_seq_stim_config::type_id::create("back2back_cfgrd_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    bit [31:0]          rdata;
    int  np_cnt ; 
      
    np_cnt = 36;
           
    repeat(np_cnt+1) begin

      randomize(cfg_addr);
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
      rdata = cfg_read_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
    end

      if($test$plusargs("RQID_TXN"))begin      
        repeat(np_cnt+1) begin
          `ovm_do_on_with(cfg_read_rqid_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
          rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_rqid_seq.iosf_addr ,rdata),OVM_LOW)
        end
      end            
    
  endtask : body
endclass : back2back_cfgrd_seq
