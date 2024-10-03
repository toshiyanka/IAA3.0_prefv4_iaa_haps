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
// File   : hqm_iosf_smoke_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base iosf seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"
//import "DPI-C" context SLA_VPI_put_value =
//  function void hqm_seq_put_value(input chandle handle, input logic [0:0] value);

class hqm_iosf_smoke_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_smoke_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_smoke_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_smoke_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_smoke_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_smoke_seq_stim_config

class hqm_iosf_smoke_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_iosf_smoke_seq)

  rand hqm_iosf_smoke_seq_stim_config        cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_smoke_seq_stim_config);

  function new(string name = "hqm_iosf_smoke_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_iosf_smoke_seq_stim_config::type_id::create("hqm_pwr_smoke_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

endclass : hqm_iosf_smoke_seq

task hqm_iosf_smoke_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_smoke_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

 `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_iosf_smoke_seq \n"),OVM_LOW)
   update_mirror_val();

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_smoke_seq ended \n"),OVM_LOW)
     
endtask : body
