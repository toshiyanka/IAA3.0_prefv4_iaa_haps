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
// File   : hqm_iosf_random_ecrc_seq.sv
// Author : rsshekha
// Description :
//
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_random_ecrc_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_random_ecrc_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_random_ecrc_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_random_ecrc_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_random_ecrc_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_random_ecrc_seq_stim_config

class hqm_iosf_random_ecrc_seq extends hqm_sla_pcie_base_seq;
  `ovm_object_utils(hqm_iosf_random_ecrc_seq)

  logic [63:0]          addr_dc, addr_cls, addr_cpc, addr_cps;

  rand hqm_iosf_random_ecrc_seq_stim_config        cfg;

  hqm_iosf_prim_base_seq                   iosf_base_seq;
  sla_ral_file                             hqm_pf_cfg_i, config_master, credit_hist_pipe;
  sla_ral_reg                              device_command, cache_line_size, cfg_patch_control, cfg_pm_status;
  Iosf::data_t                             iosf_data_0[],iosf_data_1[];

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_random_ecrc_seq_stim_config);

  function new(string name = "hqm_iosf_random_ecrc_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 

    cfg = hqm_iosf_random_ecrc_seq_stim_config::type_id::create("hqm_iosf_random_ecrc_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task generate_traffic(input bit [31:0] random_ecrc = 32'h0000_0000);

endclass : hqm_iosf_random_ecrc_seq

task hqm_iosf_random_ecrc_seq::generate_traffic(input bit [31:0] random_ecrc = 32'h0000_0000);
  hqm_pf_cfg_i      = ral.find_file("hqm_pf_cfg_i");
  config_master     = ral.find_file("config_master");
  credit_hist_pipe  = ral.find_file("credit_hist_pipe");
  if ((hqm_pf_cfg_i == null) || (config_master == null) || (credit_hist_pipe == null)) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file"})
  end
  device_command     = hqm_pf_cfg_i.find_reg("device_command");
  cache_line_size   = hqm_pf_cfg_i.find_reg("cache_line_size");
  cfg_patch_control = credit_hist_pipe.find_reg("cfg_patch_control");
  cfg_pm_status     = config_master.find_reg("cfg_pm_status");
  if ((device_command == null) || (cache_line_size == null) || (cfg_patch_control == null) || (cfg_pm_status == null)) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL reg"})
  end
  addr_dc  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),device_command); 
  addr_cls = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),cache_line_size);
  addr_cps = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),cfg_pm_status); 
  addr_cpc = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),cfg_patch_control);
  iosf_data_0 = new[1];
  iosf_data_1 = new[1];
  iosf_data_0[0] = 32'h0000000f;
  iosf_data_1[0] = 32'h00000039;
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_dc;ecrc_l == random_ecrc;})
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgWr0;iosf_addr_l == addr_cls;iosf_data_l.size() == iosf_data_0.size();foreach(iosf_data_0[i]) {iosf_data_l[i]==iosf_data_0[i]};ecrc_l == random_ecrc;})
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::CfgRd0;iosf_addr_l == addr_cls;ecrc_l == random_ecrc;})
  if (iosf_base_seq.iosf_data_l[0] != iosf_data_0[0])
     `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0xf doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cps;ecrc_l == random_ecrc;})
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MWr64;iosf_addr_l == addr_cpc;iosf_data_l.size() == iosf_data_1.size();foreach(iosf_data_1[i]) {iosf_data_l[i]==iosf_data_1[i]};ecrc_l == random_ecrc;})
  `ovm_do_with(iosf_base_seq, {cmd == Iosf::MRd64;iosf_addr_l == addr_cpc;ecrc_l == random_ecrc;})
  if (iosf_base_seq.iosf_data_l[0] != iosf_data_1[0])
     `ovm_error(get_full_name(),$sformatf(" cfg_patch_control write data 0x39 doesn't match read data 0x%h", iosf_base_seq.iosf_data_l[0]))
endtask: generate_traffic    

task hqm_iosf_random_ecrc_seq::body();

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_random_ecrc_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  for (int i = 0; i < 5; i++) begin
    case (i)  
        0: begin  
              generate_traffic(.random_ecrc(32'h0000_0000));
           end 
        1: begin  
              generate_traffic(.random_ecrc(32'hFFFF_FFFF));
           end 
        2: begin  
              generate_traffic(.random_ecrc(32'h0000_0000));
           end 
        3: begin  
              generate_traffic(.random_ecrc($urandom()));
           end 
        4: begin  
              generate_traffic(.random_ecrc($urandom()));
           end 
    endcase     
  end 

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_random_ecrc_seq ended \n"),OVM_LOW)

endtask : body
